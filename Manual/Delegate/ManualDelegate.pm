package ManualDelegate;

use strict;
use File::Find;
use File::Basename;
use File::Copy;
use IO::Handle;
use Text::CSV_XS;
use Base::Utils;
use SWASSET::OM::ManualComputer;
use SWASSET::OM::InstalledManualSoftware;

###Searches for and returns manual scan files from the
###file system.  Takes a flag argument to determine
###whether or not to return manual scan files which
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

	###Establish root directories to search for manual
	###scan files.
	my @manualScanDirectories = ();
	push @manualScanDirectories, $scanFilesRootDir;

	###File::Find prints warning messages whenever you
	###have it skip a file in the sub.  We do not want
	###to see these.
	no warnings;

	###Perform search of the file system for each of
	###the root directories in the manualScanDirectories
	###list configured above. If loadDeltaOnly is true
	###then ignore previously processed files.
	find(
		sub {

			# taking out the zero length file check of -s
			next unless -f;
			next if $loadDeltaOnly == 1 && m/.processed$/;
			push( @inputFiles, $File::Find::name );
		},
		@manualScanDirectories
	);
	dlog( 'found ' . scalar @inputFiles . ' total files' );

	###Sort the input files array so that the most
	###recently modified files are the last in order.
	my @inputFilesSorted =
	  sort { [ stat $a ]->[9] <=> [ stat $b ]->[9] } @inputFiles;

	return @inputFilesSorted;
}

sub getData {
	my ( $self, $inputFile ) = @_;

	###Lists to return
	my %computerList                = ();
	my %installedManualSoftwareList = ();

	###Use now for scantime (fmt = yyyy-MM-dd-hh.mm.ss.000000)
	###unless specified in the input file for special loads.
	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
	my $now = sprintf(
		"%04d-%02d-%02d-%02d.%02d.%02d.000000",
		( $year + 1900 ),
		( $mon + 1 ),
		$mday, $hour, $min, $sec
	);

	###Process input file for software and installed sofware records
	my $csv = Text::CSV_XS->new( { binary => 1, eol => $/ } );
	open my $io, "<", $inputFile or die "$inputFile: $!";
	my $lineNum = 0;
	while ( my $row = $csv->getline($io) ) {
		$lineNum++;
		if ( defined @$row && scalar(@$row) >= 7 ) {

			###Get the record hash.
			my @fields = (
				qw(acctId
				  lparName
				  processorCount
				  softwareProd
				  productVersion
				  users
				  softwareId
				  scanTime)
			);
			my $index = 0;
			my %rec   = map { $fields[ $index++ ] => $_ } @$row;

			logRec( 'dlog', \%rec );

			###Perform line level validation.
			my $lineError = 0;

			###Check for a space char in the lparName.
			if ( $rec{lparName} =~ m/ / ) {
				wlog("blank lparName on line $lineNum of file $inputFile");
				$lineError = 1;
			}

			if ( $lineError == 1 ) {
				close($io);
				$self->markFileAsError($inputFile);
				return ( undef, undef );
			}

			###Set the key to acctId.lparName per our standard
			###swasset model.
			my $computerSysId = $rec{acctId} . "." . $rec{lparName};

			###Check if computer object for this acctId.lparName is new
			###within the file, if so create new object and add to list.
			###Otherwise we will just add sw line items to it.
			if ( !exists( $computerList{$computerSysId} ) ) {

				###Create computer object.
				my $computer = new SWASSET::OM::ManualComputer();
				$computer->computerSysId($computerSysId);
				$computer->tmeObjectId( $rec{acctId} );
				$computer->tmeObjectLabel( $rec{lparName} );
				$computer->processorCount( $rec{processorCount} );

				###For scan time we will use the current time
				###unless this is a special load and we need
				###to preserve a historical value.
				if ( defined $rec{scanTime} ) {
					$computer->computerScantime( $rec{scanTime} );
				}
				else {
					$computer->computerScantime($now);
				}
				dlog( "computer=" . $computer->toString() );

				###Add to the list.
				$computerList{$computerSysId} = $computer;
			}

			###Instantiate inst manual sw object for this input file line
			my $installedManualSoftware =
			  new SWASSET::OM::InstalledManualSoftware();
			$installedManualSoftware->computerSysId($computerSysId);
			$installedManualSoftware->softwareId( $rec{softwareId} );
			$installedManualSoftware->productVersion( $rec{productVersion} );
			$installedManualSoftware->users( $rec{users} );
			dlog( "installedManualSoftware="
				  . $installedManualSoftware->toString() );

			###Add the inst manual sw object to the list
			my $instManualSwKey =
			  $computerSysId . "." . $installedManualSoftware->softwareId;
			if ( exists $installedManualSoftwareList{$instManualSwKey} ) {
				wlog("this inst manual sw was already in the list hash");
			}
			else {
				$installedManualSoftwareList{$instManualSwKey} =
				  $installedManualSoftware;
			}
		}
		else {

			###Parsing error, wlog it and then mark the input file as error,
			###and return undefs to the caller.
			wlog("csv parsing error on line $lineNum of file $inputFile");
			close($io);
			$self->markFileAsError($inputFile);
			return ( undef, undef );
		}
		last if eof($io);
	}
	close($io);

	return ( \%computerList, \%installedManualSoftwareList );
}

sub markFileAsProcessed {
	my ( $self, $inputFile ) = @_;

	###Only move to .processed if it is not already.
	if ( $inputFile =~ m/\.processed$/ ) {
		ilog("inputFile: $inputFile already marked as processed");
	}
	###Remove .error suffix if currently marked as error.
	elsif ( $inputFile =~ m/\.error$/ ) {
		my $targetFile = $inputFile;
		$targetFile =~ s/\.error$//;
		$targetFile = $targetFile . ".processed";
		move( $inputFile, $targetFile );
		ilog("moved file: $inputFile to: $targetFile");
	}
	else {
		my $targetFile = $inputFile . ".processed";
		move( $inputFile, $targetFile );
		ilog("moved file: $inputFile to: $targetFile");
	}
}

sub markFileAsError {
	my ( $self, $inputFile ) = @_;

	###Only move to .error if it is not already.
	if ( $inputFile =~ m/\.error$/ ) {
		ilog("inputFile: $inputFile already marked as error");
	}
	###Remove .processed suffix if currently marked as error.
	elsif ( $inputFile =~ m/\.processed$/ ) {
		my $targetFile = $inputFile;
		$targetFile =~ s/\.processed$//;
		$targetFile = $targetFile . ".error";
		move( $inputFile, $targetFile );
		ilog("moved file: $inputFile to: $targetFile");
	}
	else {
		my $targetFile = $inputFile . ".error";
		move( $inputFile, $targetFile );
		ilog("moved file: $inputFile to: $targetFile");
	}
}

1;
