package DoranaDelegate;

use strict;
use File::Find;
use File::Basename;
use File::Copy;
use IO::Handle;
use Text::CSV_XS;
use Base::Utils;
use SWASSET::OM::DoranaComputer;
use SWASSET::OM::InstalledDoranaSoftware;

###Searches for and returns dorana scan files from the
###file system.  Takes a flag argument to determine
###whether or not to return dorana scan files which
###have already been processed.  If loadDeltaOnly
###is true, then it will return only new files
###which have not yet been processed.  Using the file
###extenion of ".processed" to indicate whether or
###not a given file has been processed.
sub getInputFiles {
	my ( $self, $scanFilesRootDir, $loadDeltaOnly ) = @_;

	###Check scanFilesRootDir is passed correctly
	die "Invalid value passed for scanFilesRootDir param!\n"
	  unless ( -d $scanFilesRootDir || -e $scanFilesRootDir );

	###Check loadDeltaOnly is passed correctly
	die "Invalid value passed for loadDeltaOnly param!\n"
	  unless ( $loadDeltaOnly == 0 || $loadDeltaOnly == 1 );

	###List of files to return.
	my @inputFiles = ();

	###Establish root directories to search for dorana
	###scan files.
	my @doranaScanDirectories = ();
	push @doranaScanDirectories, $scanFilesRootDir;

	###File::Find prints warning messages whenever you
	###have it skip a file in the sub.  We do not want
	###to see these.
	no warnings;

	###Perform search of the file system for each of
	###the root directories in the doranaScanDirectories
	###list configured above. If loadDeltaOnly is true
	###then ignore previously processed files.
	find(
		sub {
			next unless -f && -s;
			next if $loadDeltaOnly == 1 && m/.processed$/;
			push( @inputFiles, $File::Find::name );
		},
		@doranaScanDirectories
	);
	dlog( 'found ' . scalar @inputFiles . ' total files' );

	###Sort the input files array so that the most
	###recently modified files are the last in order.
	my @inputFilesSorted =
	  sort { [ stat $a ]->[9] <=> [ stat $b ]->[9] } @inputFiles;

	return @inputFilesSorted;
}

sub getData {
	my ( $self, $hardwareLparMap, $inputFile ) = @_;

	###Lists to return
	my %computerList                = ();
	my %installedDoranaSoftwareList = ();

	###Get the serial and lpar based on the file name path
	my @dirs   = split( /\//, dirname($inputFile) );
	my $lpar   = $dirs[$#dirs];
	my $serial = $dirs[ $#dirs - 1 ];
	dlog("lpar=$lpar, serial=$serial");

	###If the file was submitted via the bravo gui, then it
	###will specifiy the cndb account number in the file name
	###and we need to handle these differently b/c we are
	###allowing these to create new software lpars in bravo
	###even if they do not have an associated atp hardware
	###lpar at this point.  The asset analyst will see these
	###in the bravo gui as sw w/o hw records and will then
	###be aware that they need to work these. The file format
	###is "WEB_$acctId_$cpuSerial_$lparName.csv"
	my $fileAcctNum;
	if ( basename($inputFile) =~ m/^WEB_/ ) {
		dlog("input file from bravo web upload");
		$fileAcctNum = ( split( /_/, basename($inputFile) ) )[1];
		if ( defined $fileAcctNum ) {
			dlog( "acct num from file name: " . $fileAcctNum );
		}
		else {
			wlog("unable to get acct num from file name");
		}
	}

	###Get the cndb account number based on serial and lpar
	###from the staging hardware lpar map if this serial and
	###lpar combination have a record from atp.
	my $atpAcctNum;
	foreach my $id ( sort keys %{$hardwareLparMap} ) {
		next unless $serial eq $hardwareLparMap->{$id}->{"hardwareSerial"};
		next unless $lpar   eq $hardwareLparMap->{$id}->{"hardwareLparName"};
		$atpAcctNum = $hardwareLparMap->{$id}->{"accountNumber"};
		last;
	}
	if ( defined $atpAcctNum ) {
		dlog( "acct num from atp: " . $atpAcctNum );
	}
	else {
		dlog("no matching atp hardware lpar record found");
	}

	###Select the acct num to use for the load.
	my $acctNum;
	if ( defined $fileAcctNum ) {
		if ( defined $atpAcctNum ) {

			###Use the acct num from atp if it is defined no matter
			###what the file acct num is, this is to implement the
			###business policy that atp is the master source for this
			###data.
			dlog("file and atp acct nums defined, using atp");
			$acctNum = $atpAcctNum;
		}
		else {

			###Use file acct num if atp not defined.
			dlog("file acct num defined, but atp is not, using file");
			$acctNum = $fileAcctNum;
		}
	}
	else {
		if ( defined $atpAcctNum ) {

			###Use the acct num from atp if it is defined no matter
			###what the file acct num is, this is to implement the
			###business policy that atp is the master source for this
			###data.
			dlog("file acct num not defined, but atp is, using atp");
			$acctNum = $atpAcctNum;
		}
		else {

			###If the file acct num and atp acct num are both undef
			###then we will not be able to load this record to swasset
			###b/c we do not know the acct num which is part of the
			###business key for these records.

			###TODO: how do we want to log these???
			###For now just log a warning and move on to the next
			###record and keep processing.
			dlog("file and atp acct nums not defined");
			wlog("unable to obtain a valid acct num for this record");
			return ( undef, undef, undef );
		}
	}

	###Instantiate computer object
	my $computer = new SWASSET::OM::DoranaComputer();
	$computer->computerSysId( $acctNum . "." . $lpar );

	###Use now for scantime (fmt = yyyy-MM-dd-hh.mm.ss.000000)
	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
	my $now = sprintf(
		"%04d-%02d-%02d-%02d.%02d.%02d.000000",
		( $year + 1900 ),
		( $mon + 1 ),
		$mday, $hour, $min, $sec
	);
	$computer->computerScantime($now);
	$computer->tmeObjectId($acctNum);
	$computer->tmeObjectLabel($lpar);
	$computer->sysSerNum($serial);

	###Add computer object to list to return
	$computerList{ $computer->computerSysId } = $computer;

	###Process input file for installed sofware records
	my $csv = Text::CSV_XS->new( { binary => 1, eol => $/ } );
	open my $io, "<", $inputFile or die "$inputFile: $!";
	my $lineNum = 0;
	while ( my $row = $csv->getline($io) ) {
		$lineNum++;
		if ( defined @$row && scalar(@$row) > 13 ) {

			###Get the record hash.
			my @fields = (
				qw(doranaProductId
				  na1
				  doranaProductName
				  vendorId
				  na4
				  vendorName
				  na6
				  na7
				  na8
				  na9
				  versionGroupId
				  productVersion
				  productRelease
				  productEblmtElgFlag
				  ibmFeatureCode
				  productDelIndicator
				  na16
				  na17
				  na18
				  na19)
			);
			my $index = 0;
			my %rec   = map { $fields[ $index++ ] => $_ } @$row;

			###Check for a space char in the lparName.
			next if $rec{lparName} =~ m/ /;

			###Instantiate inst dorana sw object
			###
			### NOTE: for dorana we use the product name field
			###       as the product id.
			###
			my $installedDoranaSoftware =
			  new SWASSET::OM::InstalledDoranaSoftware();
			$installedDoranaSoftware->computerSysId( $computer->computerSysId );
			$installedDoranaSoftware->doranaProductId(
				$rec{doranaProductName} );

			###Add the inst dorana sw record to the list
			my $installedDoranaSoftwareKey =
			    $computer->computerSysId . "."
			  . $installedDoranaSoftware->doranaProductId;
			dlog("installedDoranaSoftwareKey=$installedDoranaSoftwareKey");
			if (
				exists $installedDoranaSoftwareList{$installedDoranaSoftwareKey}
			  )
			{
				wlog("this inst dorana sw was already in the list hash");
			}
			else {
				$installedDoranaSoftwareList{$installedDoranaSoftwareKey} =
				  $installedDoranaSoftware;
			}
		}
		else {

			###Parsing error, wlog it and then mark the input file as error,
			###and return undefs to the caller.
			wlog("csv parsing error on line $lineNum of file $inputFile");
			close($io);
			$self->markFileAsError($inputFile);
			return ( undef, undef, undef );
		}
		last if eof($io);
	}
	close($io);

	return ( \%computerList, \%installedDoranaSoftwareList );
}

sub markFileAsProcessed {
	my ( $self, $inputFile ) = @_;

	###Only move to .processed if it is not already.
	if ( $inputFile =~ m/\.processed$/ ) {
		dlog("inputFile: $inputFile already marked as processed");
	}
	###Remove .error suffix if currently marked as error.
	elsif ( $inputFile =~ m/\.error$/ ) {
		my $targetFile = $inputFile;
		$targetFile =~ s/\.error$//;
		$targetFile = $targetFile . ".processed";
		move( $inputFile, $targetFile );
		dlog("moved file: $inputFile to: $targetFile");
	}
	else {
		my $targetFile = $inputFile . ".processed";
		move( $inputFile, $targetFile );
		dlog("moved file: $inputFile to: $targetFile");
	}
}

sub markFileAsError {
	my ( $self, $inputFile ) = @_;

	###Only move to .error if it is not already.
	if ( $inputFile =~ m/\.error$/ ) {
		dlog("inputFile: $inputFile already marked as error");
	}
	###Remove .processed suffix if currently marked as error.
	elsif ( $inputFile =~ m/\.processed$/ ) {
		my $targetFile = $inputFile;
		$targetFile =~ s/\.processed$//;
		$targetFile = $targetFile . ".error";
		move( $inputFile, $targetFile );
		dlog("moved file: $inputFile to: $targetFile");
	}
	else {
		my $targetFile = $inputFile . ".error";
		move( $inputFile, $targetFile );
		dlog("moved file: $inputFile to: $targetFile");
	}
}

1;
