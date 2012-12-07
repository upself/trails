package SWASSET::TLCMZLoader;

use strict;
use Data::Dumper;
use File::Copy;
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Staging::Delegate::StagingDelegate;
use TLCMZ::Delegate::TLCMZDelegate;
use SWASSET::Delegate::SWASSETDelegate;
use Sigbank::Delegate::BankAccountDelegate;

###Object constructor.
sub new {
	my ($class) = @_;
	my $self = {
		_testMode                   => undef,
		_loadDeltaOnly              => undef,
		_applyChanges               => undef,
		_scanFilesRootDir           => undef,
		_maxComputersInMemory       => undef,
		_hardwareLparMap            => undef,
		_computerList               => undef,
		_tlcmzSoftwareList          => undef,
		_installedTLCMZSoftwareList => undef
	};
	bless $self, $class;
	dlog("instantiated self");

	###Instantiate list (hashes) objects
	$self->computerList(               {} );
	$self->tlcmzSoftwareList(          {} );
	$self->installedTLCMZSoftwareList( {} );

	###Get our hw_lpar mapping
	$self->hardwareLparMap( Staging::Delegate::StagingDelegate->getHardwareLparMap() );
	dlog("got hw lpar map");

	return $self;
}

###Object get/set methods.
sub testMode {
	my ( $self, $value ) = @_;
	$self->{_testMode} = $value if defined($value);
	return ( $self->{_testMode} );
}

sub loadDeltaOnly {
	my ( $self, $value ) = @_;
	$self->{_loadDeltaOnly} = $value if defined($value);
	return ( $self->{_loadDeltaOnly} );
}

sub applyChanges {
	my ( $self, $value ) = @_;
	$self->{_applyChanges} = $value if defined($value);
	return ( $self->{_applyChanges} );
}

sub scanFilesRootDir {
	my ( $self, $value ) = @_;
	$self->{_scanFilesRootDir} = $value if defined($value);
	return ( $self->{_scanFilesRootDir} );
}

sub maxComputersInMemory {
	my ( $self, $value ) = @_;
	$self->{_maxComputersInMemory} = $value if defined($value);
	return ( $self->{_maxComputersInMemory} );
}

sub hardwareLparMap {
	my ( $self, $value ) = @_;
	$self->{_hardwareLparMap} = $value if defined($value);
	return ( $self->{_hardwareLparMap} );
}

sub computerList {
	my ( $self, $value ) = @_;
	$self->{_computerList} = $value if defined($value);
	return ( $self->{_computerList} );
}

sub tlcmzSoftwareList {
	my ( $self, $value ) = @_;
	$self->{_tlcmzSoftwareList} = $value if defined($value);
	return ( $self->{_tlcmzSoftwareList} );
}

sub installedTLCMZSoftwareList {
	my ( $self, $value ) = @_;
	$self->{_installedTLCMZSoftwareList} = $value if defined($value);
	return ( $self->{_installedTLCMZSoftwareList} );
}

###Primary method used by calling clients to load tlcmz
###scan data to the swasset db.
sub load {
	my ( $self, %args ) = @_;

	dlog("start load method");

	###Check and set arguments.
	dlog("checking passed arguments");
	$self->checkArgs( \%args );
	dlog("checked passed arguments");

	###Set the job name of this script to update the status
	my $job;
	if ( $self->loadDeltaOnly == 1 ) {
		$job = 'TLCMZ TO SWASSET (DELTA)';
	}
	else {
		$job = 'TLCMZ TO SWASSET (FULL)';
	}
	dlog("job=$job");

	my $systemScheduleStatus;
	if ( $self->applyChanges == 1 ) {
		###Notify the scheduler that we are starting
		ilog("starting $job system schedule status");
		$systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
		ilog("started $job system schedule status");
	}

	###Get the pending tlcmz scan files from the delegate.
	ilog("getting input files");
	my @inputFiles =
	  TLCMZDelegate->getInputFiles( $self->scanFilesRootDir,
		$self->loadDeltaOnly );
	ilog( "got input files, count: " . scalar @inputFiles );

	###Get a connection to swasset and reuse it for each
	###input file we are processing.
	ilog("getting swasset bank account");
	my $swassetBankAccount =
	  Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('SWASSTDB');
	if ( !defined $swassetBankAccount ) {
		elog("SWASSTDB Bank Account does not exist!!");
		die;
	}
	ilog( "got swasset bank account: " . $swassetBankAccount->toString() );

	ilog("getting swasset db connection");
	my $swassetConnection =
	  Database::Connection->new($swassetBankAccount);
	if ( !defined $swassetConnection ) {
		elog("Unable to get swasset db connection!!");
		die;
	}
	ilog("got swasset db connection");

	###Get start time for processing
	my $begin = time();

	###Wrap all of this in an eval so we can close the
	###swasset connection if something dies.  Use dieMsg to
	###determine if this method should throw the die.
	my $dieMsg = undef;
	eval {

		###Hash to store input files which have been processed.
		my %inputFilesProcessing = ();

		###Load each file individually.
		for ( my $i = 0 ; $i <= $#inputFiles ; $i++ ) {
			my $inputFile = $inputFiles[$i];
			ilog("processing inputFile: $inputFile");

			###Get the tlcmz scan data from the current file.
			###If the prepareSourceData returns undef, then
			###there was an issue getting the data, for example
			###the scan record may not be able to be mapped
			###to a valid cndb account number. In this case
			###we want to leave the file as is so that it will
			###continue to try and reload each run of this loader.
			ilog("getting data from inputFile: $inputFile");
			if ( $self->prepareSourceData($inputFile) ) {
				ilog("got data from inputFile: $inputFile");

				###Add input file to hash as processing.
				$inputFilesProcessing{$inputFile}++;
				dlog("added input file to hash as processing");
			}
			else {
				ilog("unable to get data from inputFile: $inputFile");
			}

			###Perform delta and apply for current data stored in
			###memory if we have reached either the MaxComputersInMemory
			###number or the last input file needing processing.
			###This logic is in place to ensre we do not consume too
			###much memory if there are a very large number of scan files
			###needing processing at this time.
			if (
				( $i == $#inputFiles )
				|| (
					defined $self->computerList
					&& (
						scalar keys %{ $self->computerList } >=
						$self->maxComputersInMemory )
				)
			  )
			{

				###Delta the tlcmz scan data against swasset.
				ilog("performing delta between input files and swasset");
				$self->doDelta($swassetConnection);
				ilog("performed delta between input files and swasset");

				###Apply the changes to swasset if ApplyChanges is 1
				if ( $self->applyChanges == 1 ) {

					ilog("applying changes from input files to swasset");
					$self->applyDeltas($swassetConnection);
					ilog("applyed changes from input files to swasset");

				}
				else {
					ilog(
"skipped applying changes to swasset per ApplyChanges arg"
					);
				}

				###Reset lists now that we have processed their data
				$self->computerList(               {} );
				$self->tlcmzSoftwareList(          {} );
				$self->installedTLCMZSoftwareList( {} );

				###Flag all input files in processing hash as processed and remove.
				foreach my $file ( sort keys %inputFilesProcessing ) {
					if ( $self->applyChanges == 1 ) {
						ilog("marking input file as processed: $file");
						TLCMZDelegate->markFileAsProcessed($file);
						ilog("marked input file as processed: $file");
					}
					delete $inputFilesProcessing{$file};
				}
			}
		}
	};
	if ($@) {
		###Something died in the eval, set dieMsg so
		###we know to die after closing the db connections.
		elog($@);
		$dieMsg = $@;

		if ( $self->applyChanges == 1 ) {

			###Notify the scheduler that we had an error
			ilog("erroring $job system schedule status");
			SystemScheduleStatusDelegate->error($systemScheduleStatus);
			ilog("errored $job system schedule status");
		}
	}
	else {
		if ( $self->applyChanges == 1 && !defined $dieMsg ) {

			###Notify the scheduler that we are stopping
			ilog("stopping $job system schedule status");
			SystemScheduleStatusDelegate->stop($systemScheduleStatus);
			ilog("stopped $job system schedule status");
		}
	}

	###Calculate duration of this processing
	my $totalProcessingTime = time() - $begin;
	ilog("totalProcessingTime: $totalProcessingTime secs");

	###Close the swasset connection
	ilog("disconnecting swasset db connection");
	$swassetConnection->disconnect;
	ilog("disconnected swasset db connection");

	###die if dieMsg is defined
	die $dieMsg if defined $dieMsg;
}

###Checks arguments passed to load method.
sub checkArgs {
	my ( $self, $args ) = @_;

	###Check TestMode arg is passed correctly
	unless ( exists $args->{'TestMode'} ) {
		elog("Must specify TestMode sub argument!");
		die;
	}
	unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 ) {
		elog("Invalid value passed for TestMode param!");
		die;
	}
	$self->testMode( $args->{'TestMode'} );
	ilog( "testMode=" . $self->testMode );

	###Check LoadDeltaOnly arg is passed correctly
	unless ( exists $args->{'LoadDeltaOnly'} ) {
		elog("Must specify LoadDeltaOnly sub argument!");
		die;
	}
	unless ( $args->{'LoadDeltaOnly'} == 0 || $args->{'LoadDeltaOnly'} == 1 ) {
		elog("Invalid value passed for LoadDeltaOnly param!");
		die;
	}
	$self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
	ilog( "loadDeltaOnly=" . $self->loadDeltaOnly );

	###Check ApplyChanges arg is passed correctly
	unless ( exists $args->{'ApplyChanges'} ) {
		elog("Must specify ApplyChanges sub argument!");
		die;
	}
	unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 ) {
		elog("Invalid value passed for ApplyChanges param!");
		die;
	}
	$self->applyChanges( $args->{'ApplyChanges'} );
	ilog( "applyChanges=" . $self->applyChanges );

	###Check ScanFilesRootDir arg is passed correctly
	unless ( exists $args->{'ScanFilesRootDir'} ) {
		elog("Must specify ScanFilesRootDir sub argument!");
		die;
	}
	unless ( -d $args->{'ScanFilesRootDir'} || -e $args->{'ScanFilesRootDir'} )
	{
		elog("Invalid value passed for ScanFilesRootDir param!");
		die;
	}
	$self->scanFilesRootDir( $args->{'ScanFilesRootDir'} );
	ilog( "scanFilesRootDir arg=" . $self->scanFilesRootDir );

	###Check MaxComputersInMemory arg is passed correctly
	unless ( exists $args->{'MaxComputersInMemory'} ) {
		elog("Must specify MaxComputersInMemory sub argument!");
		die;
	}
	unless ( $args->{'MaxComputersInMemory'} =~ m/\d+/ ) {
		elog("Invalid value passed for MaxComputersInMemory param!");
		die;
	}
	$self->maxComputersInMemory( $args->{'MaxComputersInMemory'} );
	ilog( "maxComputersInMemory arg=" . $self->maxComputersInMemory );
}

###Gets the tlcmz scan data from a given input file. Used as
###a helper method for loadDelta to keep it's logic clean.
sub prepareSourceData {
	my ( $self, $inputFile ) = @_;

	###Get data from tlcmz input file.  Return undef or 1 based
	###on return from tlcmzData method.
	return $self->tlcmzData(
		TLCMZDelegate->getData( \%{ $self->hardwareLparMap }, $inputFile ) );
}

sub tlcmzData {
	my ( $self, $computerList, $tlcmzSoftwareList, $installedTLCMZSoftwareList )
	  = @_;

	###Handle case where tlcmz delegate was unable to get the data properly.
	###In this case it will return undef for the computerList hash.
	return undef unless defined $computerList;

	ilog( "scan file computers count: " . scalar keys %{$computerList} );
	ilog(
		"scan file sw line items count: " . scalar keys %{$tlcmzSoftwareList} );
	ilog( "scan file inst sw line items count: " . scalar
		  keys %{$installedTLCMZSoftwareList} );

	###Append to lists for the given files data we just processed.
	foreach my $key ( keys %{$computerList} ) {
		$self->computerList->{$key} = $computerList->{$key};
	}
	foreach my $key ( keys %{$tlcmzSoftwareList} ) {
		$self->tlcmzSoftwareList->{$key} = $tlcmzSoftwareList->{$key};
	}
	foreach my $key ( keys %{$installedTLCMZSoftwareList} ) {
		$self->installedTLCMZSoftwareList->{$key} =
		  $installedTLCMZSoftwareList->{$key};
	}

	###Return defined value so caller knows we were successful.
	return 1;
}

sub doDelta {
	my ( $self, $swassetConnection ) = @_;

	###
	###Delta the computer objects
	###

	###Prepare query to pull computers from swasset
	$swassetConnection->prepareSqlQueryAndFields(
		SWASSETDelegate->queryTLCMZComputerData() );
	dlog("prepared computer data query");

	###Get the statement handle
	my $sth = $swassetConnection->sql->{tlcmzComputerData};
	dlog("got sth for computer data query");

	###Bind our columns
	my %rec = ();
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $swassetConnection->sql->{tlcmzComputerDataFields} } );
	dlog("binded columns for computer data query");

	###Execute the query
	$sth->execute();
	dlog("executed computer data query, no args");
	my $key = undef;
	while ( $sth->fetchrow_arrayref ) {

		###Get the key
		$key = $rec{computerSysId};

		###Does this swasset computer match one we have in our list?
		if ( $self->computerList->{$key} ) {

			dlog("found computer key match: $key");

			###If we are here, then it means there was a matching
			###computer record in swasset, so we need to update
			###it since we have now receieved a new scan file.
			###For this loader we never delete or inactivate
			###data, we keep all scan data until specifically
			###asked to remove it.

			###Since the swasset computer table does not use
			###a surrogate key, we set the "id" field to the
			###business key, which in this case is the
			###computerSysId.
			$self->computerList->{$key}->id($key);
			dlog("set id to key to flag update");
		}

		###Note: If any of our computers found in the scan files
		###do not match a record in swasset, then the "id" field
		###will be undef, and the apply logic will treat these
		###as inserts.
	}
	$sth->finish;

	###
	###Next, delta the tlcmz software objects
	###

	###Prepare query to pull tlcmz software data
	$swassetConnection->prepareSqlQueryAndFields(
		SWASSETDelegate->queryTLCMZSoftwareData() );
	dlog("prepared tlcmz software data query");

	###Get the statement handle
	$sth = $swassetConnection->sql->{tlcmzSoftwareData};
	dlog("got sth for tlcmz software data query");

	###Bind our columns
	%rec = ();
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $swassetConnection->sql->{tlcmzSoftwareDataFields} } );
	dlog("binded columns for tlcmz software data query");

	###Execute the query
	$sth->execute();
	dlog("executed tlcmz software data query, no args");
	$key = undef;
	while ( $sth->fetchrow_arrayref ) {

		###Get the key
		$key = $rec{tlcmzProductId};

		###Does this tlcmz software product match one we have in our list?
		if ( $self->tlcmzSoftwareList->{$key} ) {

			dlog("found tlcmz sw key match: $key");

			###Set the id so we know this product is already in swasset

			###Since the swasset tlcmz sw table does not use
			###a surrogate key, we set the "id" field to the
			###business key, which in this case is the
			###tlcmzProductId.
			$self->tlcmzSoftwareList->{$key}->id($key);
			dlog("set id to key to flag already exists in swasset");
		}

		###Note: If any of our tlczm sw prods found in the scan files
		###do not match a record in swasset, then the "id" field
		###will be undef, and the apply logic will treat these
		###as inserts.
	}
	$sth->finish;

	###
	###Finally, delta the installed tlcmz software objects
	###

	###Prepare query to pull inst tlcmz software data
	$swassetConnection->prepareSqlQueryAndFields(
		SWASSETDelegate->queryInstalledTLCMZSoftwareData() );
	dlog("prepared inst tlcmz software data query");

	###Get the statement handle
	$sth = $swassetConnection->sql->{installedTLCMZSoftwareData};
	dlog("got sth for inst tlcmz software data query");

	###Bind our columns
	%rec = ();
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $swassetConnection->sql->{installedTLCMZSoftwareDataFields} } );
	dlog("binded columns for inst tlcmz software data query");

	###Execute the query
	$sth->execute();
	dlog("executed inst tlcmz software data query, no args");
	$key = undef;
	while ( $sth->fetchrow_arrayref ) {

		###Ignore this record if it is not associated to one of the computers in our list
		next unless $self->computerList->{ $rec{computerSysId} };

		###Get the key
		$key = $rec{computerSysId} . "." . $rec{tlcmzProductId};

		###Note: For inst tlcmz software line items, we do want to
		###create new ones AND remove ones no longer found on
		###on this computer.

		###Does this inst tlcmz software line item match one we have in our list?
		if ( $self->installedTLCMZSoftwareList->{$key} ) {

			dlog("found inst tlcmz sw key match: $key");

			###Set the id so we know this line item is already in swasset

			###Since the swasset inst tlcmz sw table does not use
			###a surrogate key, we set the "id" field to the
			###business key, which in this case is the
			###computerSysId,tlcmzProductId.
			$self->installedTLCMZSoftwareList->{$key}->id($key);
			dlog("set id to key to flag already exists in swasset");

		}
		else {

			dlog("no key match found for inst tlcmz sw: $key");

			###This line item is no longer found on this computer,
			###so we need to remove it.  To do this, we create a new
			###installedTLCMZSoftware object, flag it for delete
			###by setting the "id" field to -1, and then add it
			###to the memory list so the apply method will have
			###it deleted.

			###Instantiate new object
			my $installedTLCMZSoftware =
			  new SWASSET::OM::InstalledTLCMZSoftware();
			$installedTLCMZSoftware->computerSysId( $rec{computerSysId} );
			$installedTLCMZSoftware->tlcmzProductId( $rec{tlcmzProductId} );

			###Flag for delete by setting "id" field to "-1"
			###Note: Since the swasset inst tlcmz sw table does not use
			###a surrogate key, we set the "id" field to the
			###the string "-1", the delegate will know to remove
			###any line items with this value.
			$installedTLCMZSoftware->id("-1");

			###Add to memory list
			$self->installedTLCMZSoftwareList->{$key} = $installedTLCMZSoftware;
		}
	}
	$sth->finish;
}

sub applyDeltas {
	my ( $self, $swassetConnection ) = @_;

	###Save computer records to swasset, insert any records where
	###the "id" field is undef, and update any records where the
	###"id" field is set.
	foreach my $key ( keys %{ $self->computerList } ) {

		###The Computer->save method contains the logic
		###to determine an insert vs. an update, all we need to
		###is call it here and pass the given computer object.
		$self->computerList->{$key}->save($swassetConnection);
		dlog( "saved computer record to swasset: "
			  . $self->computerList->{$key}->toString() );
	}

	###Save tlcmz sw records to swasset.
	foreach my $key ( keys %{ $self->tlcmzSoftwareList } ) {

		###For tlcmz software products, we only want to load
		###new ones, we do NOT want to update products
		###that are already in the database, this is mostly
		###to avoid the extra cycles required to do this,
		###and the trusted source for this information is
		###SigBank anyway, so this is really just a nice to have.
		if ( !defined( $self->tlcmzSoftwareList->{$key}->id ) ) {

			###Save if id is undef
			$self->tlcmzSoftwareList->{$key}->save($swassetConnection);
			dlog( "saved tlcmz sw record to swasset: "
				  . $self->tlcmzSoftwareList->{$key}->toString() );
		}
		else {

			###Skip if id is defined
			dlog( "tlcmz sw record already in swasset: "
				  . $self->tlcmzSoftwareList->{$key}->toString() );
		}
	}

	###Save inst tlcmz sw records to swasset, insert any new line items
	###found on this computer, or delete any line items that were
	###flagged in doDelta by setting id field to "-1".
	foreach my $key ( keys %{ $self->installedTLCMZSoftwareList } ) {

		if ( !defined( $self->installedTLCMZSoftwareList->{$key}->id ) ) {

			###Save if id is undef
			$self->installedTLCMZSoftwareList->{$key}->save($swassetConnection);
			dlog( "saved inst tlcmz sw record to swasset: "
				  . $self->installedTLCMZSoftwareList->{$key}->toString() );

		}
		else {

			if ( $self->installedTLCMZSoftwareList->{$key}->id eq "-1" ) {

				###Delete if id is defined and set to "-1"
				$self->installedTLCMZSoftwareList->{$key}
				  ->delete($swassetConnection);
				dlog( "inst tlcmz sw record deleted from swasset: "
					  . $self->installedTLCMZSoftwareList->{$key}->toString() );

			}
			else {

				###Skip if id is defined and NOT set to "-1"
				dlog( "inst tlcmz sw record already in swasset: "
					  . $self->installedTLCMZSoftwareList->{$key}->toString() );
			}
		}
	}
}

1;
