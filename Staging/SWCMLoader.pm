package Staging::SWCMLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use CNDB::Delegate::CNDBDelegate;
use SWCM::Delegate::SWCMDelegate;
use Staging::OM::License;
use Staging::Delegate::StagingDelegate;

###Object constructor.
sub new {
	my ($class) = @_;
	my $self = {
		_testMode           => undef,
		_loadDeltaOnly      => undef,
		_applyChanges       => undef,
		_licenseList        => undef,
		_accountNumberMap   => undef,
		_customerNameMap    => undef,
		_dupCustomerNameMap => undef,
		_updateCnt          => 0,
		_deleteCnt          => 0,
		_totalCnt           => 0
	};
	bless $self, $class;
	dlog("instantiated self");

	###Get the acct num map
	$self->accountNumberMap(
		CNDB::Delegate::CNDBDelegate->getAccountNumberMap );
	dlog("got cust num map");

	###Get the cust name map
	$self->getCustomerNameMap(
		CNDB::Delegate::CNDBDelegate->getCustomerNameMap );
	dlog("got cust name map");
	

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

sub licenseList {
	my ( $self, $value ) = @_;
	$self->{_licenseList} = $value if defined($value);
	return ( $self->{_licenseList} );
}

sub accountNumberMap {
	my ( $self, $value ) = @_;
	$self->{_accountNumberMap} = $value if defined($value);
	return ( $self->{_accountNumberMap} );
}

sub customerNameMap {
	my ( $self, $value ) = @_;
	$self->{_customerNameMap} = $value if defined($value);
	return ( $self->{_customerNameMap} );
}

sub dupCustomerNameMap {
	my ( $self, $value ) = @_;
	$self->{_dupCustomerNameMap} = $value if defined($value);
	return ( $self->{_dupCustomerNameMap} );
}

sub getCustomerNameMap {
	my ( $self, $customerNameMap, $dupCustomerNameMap ) = @_;
	$self->customerNameMap($customerNameMap);
	$self->dupCustomerNameMap($dupCustomerNameMap);
}

sub updateCnt {
	my ( $self, $value ) = @_;
	$self->{_updateCnt} = $value if defined($value);
	return ( $self->{_updateCnt} );
}

sub deleteCnt {
	my ( $self, $value ) = @_;
	$self->{_deleteCnt} = $value if defined($value);
	return ( $self->{_deleteCnt} );
}

sub totalCnt {
	my ( $self, $value ) = @_;
	$self->{_totalCnt} = $value if defined($value);
	return ( $self->{_totalCnt} );
}

sub incrDeleteCnt {
	my ($self) = @_;
	$self->{_deleteCnt}++;
}

sub incrTotalCnt {
	my ($self) = @_;
	$self->{_totalCnt}++;
}

sub incrUpdateCnt {
	my ($self) = @_;
	$self->{_updateCnt}++;
}

###Primary method used by calling clients to load swcm
###license data to the staging db.
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
		$job = 'SWCM TO STAGING (DELTA)';
	}
	else {
		$job = 'SWCM TO STAGING (FULL)';
	}
	dlog("job=$job");

	my $systemScheduleStatus;
	if ( $self->applyChanges == 1 ) {
		###Notify the scheduler that we are starting
		ilog("starting $job system schedule status");
		$systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
		ilog("started $job system schedule status");
	}

	###Get a connection to swcm
	ilog("getting swcm db connection");
	my $swcmConnection = Database::Connection->new('swcm');
	ilog("got swcm db connection");
	

	###Get a connection to staging
	ilog("getting staging db connection");
	my $stagingConnection = Database::Connection->new('staging');
	ilog("got staging db connection");

	###Get a connection to bravo
	ilog("getting bravo db connection");
	my $bravoConnection = Database::Connection->new('trails');
	ilog("got bravo db connection");

	###Get start time for processing
	my $begin = time();

	###Hash to keep load statistics
	my %statistics = ();

	###Wrap all of this in an eval so we can close the
	###connections if something dies.  Use dieMsg to
	###determine if this method should throw the die.
	my $dieMsg;
	eval {
		# execute the proc to prepare the data
		ilog("Calling swlm.createtrailstables()");
		$swcmConnection->dbh->do("call swlm.createtrailstables()");
		###Get the swcm data from the swcm db
		$self->prepareSourceData( $stagingConnection, $swcmConnection,
			$bravoConnection );
		ilog("got data from swcm");
		ilog( "swcm lic count: " . scalar keys %{ $self->licenseList } );

		###Delta the swcm license data against staging.
		$self->doLicenseDelta($stagingConnection);
		ilog("performed delta between swcm and staging");

		###Apply the changes to staging if ApplyChanges is 1
		if ( $args{'ApplyChanges'} == 1 ) {
			ilog('Applying deltas');
			$self->applyLicenseDelta($stagingConnection);
			ilog("applyed lic changes from swcm to staging");
		}
		else {
			ilog(
"skipped applying license changes to staging per ApplyChanges arg"
			);
	# just for donnie testing
#	foreach my $ky2 ( keys %{ $self->licenseList } ) {
#		if ( $self->licenseList->{$ky2}->action eq 'DELETE' ) {
#			dlog ("Donnie Deleting " . $self->licenseList->{$ky2}->extSrcId );
#		}
#	}
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

	###Display counts
	logMsg("Total Counts  - $self->{_totalCnt}");
	logMsg("Update Counts - $self->{_updateCnt}");
	logMsg("Delete Counts - $self->{_deleteCnt}");
	
	###Display statistics
	foreach my $key ( sort keys %statistics ) {
		ilog( "statistics: $key=" . $statistics{$key} );
	}
	
	###Calculate duration of this processing
	my $totalProcessingTime = time() - $begin;
	ilog("totalProcessingTime: $totalProcessingTime secs");

	###Close the swcm connection
	ilog("disconnecting swcm db connection");
	$swcmConnection->disconnect;
	ilog("disconnected swcm db connection");

	###Close the staging db connection
	ilog("disconnecting staging db connection");
	$stagingConnection->disconnect;
	ilog("disconnected staging db connection");

	###Close the bravo db connection
	ilog("disconnecting bravo db connection");
	$bravoConnection->disconnect;
	ilog("disconnected bravo db connection");

	###die if dieMsg is defined
	die $dieMsg if defined $dieMsg;
}

###Checks arguments passed to load method.
sub checkArgs {
	my ( $self, $args ) = @_;

	###Check TestMode arg is passed correctly
	die "Must specify TestMode sub argument!\n"
	  unless exists( $args->{'TestMode'} );
	die "Invalid value passed for TestMode param!\n"
	  unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 );
	$self->testMode( $args->{'TestMode'} );
	ilog( "testMode=" . $self->testMode );

	###Check LoadDeltaOnly arg is passed correctly
	die "Must specify LoadDeltaOnly sub argument!\n"
	  unless exists( $args->{'LoadDeltaOnly'} );
	die "Invalid value passed for LoadDeltaOnly param!\n"
	  unless ( $args->{'LoadDeltaOnly'} == 0 || $args->{'LoadDeltaOnly'} == 1 );
	$self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
	ilog( "loadDeltaOnly=" . $self->loadDeltaOnly );

	###Check ApplyChanges arg is passed correctly
	die "Must specify ApplyChanges sub argument!\n"
	  unless exists( $args->{'ApplyChanges'} );
	die "Invalid value passed for ApplyChanges param!\n"
	  unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 );
	$self->applyChanges( $args->{'ApplyChanges'} );
	ilog( "applyChanges=" . $self->applyChanges );
}

sub prepareSourceData {
	my ( $self, $stagingConnection, $swcmConnection, $bravoConnection ) = @_;

	my $lastUpdateDate = undef;
	if ( $self->loadDeltaOnly == 1 ) {
		($lastUpdateDate) = $self->getLastUpdate($stagingConnection);
		dlog("lastUpdateDate=$lastUpdateDate");
	}

	###Get everything from swcm
	$self->swcmData(
		SWCMDelegate->getData(
			$swcmConnection,           $bravoConnection,
			$self->accountNumberMap,   $self->customerNameMap,
			$self->dupCustomerNameMap, $self->testMode,
			$self->loadDeltaOnly,      $lastUpdateDate
		)
	);

	$self->totalCnt( scalar keys %{ $self->licenseList } );
	dlog("got swcm data");
}

sub swcmData {
	my ( $self, $licenseList ) = @_;
	$self->licenseList($licenseList);
}

sub getLastUpdate {
	my ( $self, $stagingConnection ) = @_;

	dlog('Start getLastUpdateTime method');

	dlog('Preparing staging licenseLastUpdate query');
	$stagingConnection->prepareSqlQueryAndFields(
		Staging::Delegate::StagingDelegate->queryLicenseLastUpdate() );
	dlog('Staging licenseLastUpdate query prepared');

	dlog('Getting statement handle');
	my $sth = $stagingConnection->sql->{licenseLastUpdate};
	dlog('Acquired statement handle');

	dlog('Binding columns');
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $stagingConnection->sql->{licenseLastUpdateFields} } );
	dlog('Columns binded');

	ilog('Executing staging license last update query');
	$sth->execute();
	$sth->fetchrow_arrayref();
	$sth->finish();
	ilog('Staging license last update query complete');

	dlog('End getLastUpdateTime method');

	return ( $rec{lastUpdate} );
}

sub doLicenseDelta {
	my ( $self, $stagingConnection ) = @_;

	###Prepare query to pull lics from staging
	$stagingConnection->prepareSqlQueryAndFields(
		Staging::Delegate::StagingDelegate->queryLicenseData(
			$self->testMode, 0
		)
	);
	dlog("prepared lic data query");

	###Get the statement handle
	my $sth = $stagingConnection->sql->{licenseData};
	dlog("got sth for lic data query");

	###Bind our columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $stagingConnection->sql->{licenseDataFields} } );
	dlog("binded columns for lic query");

	###Excute the query
	$sth->execute();
	dlog("executed lic query");
	while ( $sth->fetchrow_arrayref ) {

		###Get the key
		my $key = $rec{extSrcId};
		dlog("key=$key");

		if ( $rec{action} eq 'DELETE' ) {
			delete $self->licenseList->{$key};
			next;
		}

		###Create and populate a new license object
		my $license = new Staging::OM::License();
		$license->id( $rec{id} );
		$license->extSrcId( $rec{extSrcId} );
		$license->licType( $rec{licType} );
		$license->capType( $rec{capType} );
		$license->customerId( $rec{customerId} );
		$license->softwareId( $rec{softwareId} );
		$license->quantity( $rec{quantity} );
		$license->ibmOwned( $rec{ibmOwned} );
		$license->draft( $rec{draft} );
		$license->pool( $rec{pool} );
		$license->tryAndBuy( $rec{tryAndBuy} );
		$license->expireDate( $rec{expireDate} );
		$license->endDate( $rec{endDate} );
		$license->poNumber( $rec{poNumber} );
		$license->prodName( $rec{prodName} );
		$license->fullDesc( $rec{fullDesc} );
		$license->version( $rec{version} );
		$license->cpuSerial( $rec{cpuSerial} );
		$license->lparName( $rec{lparName} );
		$license->licenseStatus( $rec{licenseStatus} );
		$license->swcmRecordTime( $rec{swcmRecordTime} );
		$license->agreementType( $rec{agreementType} );
		$license->environment(
			$self->getEnvironment( $rec{environment}, undef ) );
		$license->status( $rec{status} );
		$license->action( $rec{action} );

		dlog( "current staging license obj=" . $license->toString() );

		if ( defined $self->licenseList->{$key} ) {
			dlog("license exists in swcm");

			###Set the id
			$self->licenseList->{$key}->id( $license->id );

			if ( !$license->equals( $self->licenseList->{$key} ) ) {
				dlog("license is not equal");
				dlog( "swcm license obj="
					  . $self->licenseList->{$key}->toString() );

				if ( $license->action eq 'COMPLETE' ) {
					###Set to update if the license is currently complete
					$self->licenseList->{$key}->action('UPDATE');
					$self->incrUpdateCnt();
				}
				else {
					###Set to complete so we don't save
					$self->licenseList->{$key}->action('COMPLETE');
				}
			}
			else {
				dlog("license is equal, setting to complete");
				$self->licenseList->{$key}->action('COMPLETE');
			}
		}
		else {
			dlog("license does not exist in swcm");

			if ( $self->loadDeltaOnly == 1 ) {
				dlog("Setting to complete as this is delta only");
				$license->action('COMPLETE');
			}
			else {
				if ( $license->action eq 'COMPLETE' ) {
					$license->action('DELETE');
					$self->incrDeleteCnt();
					dlog("set license to delete");
				}
				elsif ( $license->action eq 'ERROR' ) {
					dlog('Setting license to delete');
					$license->action('DELETE');
					$self->incrDeleteCnt();
				}
				else {
					$license->action('COMPLETE');
					dlog("license is in update or delete, setting to complete");
				}

				$license->status('INACTIVE');
			}

			$self->licenseList->{$key} = $license;
			dlog( "new license obj=" . $self->licenseList->{$key}->toString() );
		}
	}
}

sub getEnvironment {
	my ( $self, $newEnvironment, $currentEnvironment ) = @_;

	return 'PRODUCTION'
	  if ( !defined $newEnvironment || $newEnvironment eq '' );
	return 'PRODUCTION' if $newEnvironment ne 'DEVELOPMENT';
	return 'PRODUCTION'
	  if defined $currentEnvironment && $currentEnvironment eq 'PRODUCTION';
	return 'DEVELOPMENT';
}

sub applyLicenseDelta {
	my ( $self, $stagingConnection ) = @_;

	foreach my $key ( keys %{ $self->licenseList } ) {
		if ( !defined $self->licenseList->{$key}->status ) {
			$self->licenseList->{$key}->status('ACTIVE');
		}
		

		$self->licenseList->{$key}->action('UPDATE')
		  if ( !defined $self->licenseList->{$key}->action );
		next if ( $self->licenseList->{$key}->action eq 'COMPLETE' );
		$self->licenseList->{$key}->save($stagingConnection);
		dlog(
			"saved lic: [key=$key] " . $self->licenseList->{$key}->toString() );
	}
}

1;
