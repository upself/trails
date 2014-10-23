package TLCMZDelegate;

use strict;
use File::Find;
use File::Basename;
use File::Copy;
use Text::CSV;
use Base::Utils;
use SWASSET::OM::TLCMZComputer;
use SWASSET::OM::TLCMZSoftware;
use SWASSET::OM::InstalledTLCMZSoftware;

###Searches for and returns tlcmz scan files from the
###file system.  Takes a flag argument to determine
###whether or not to return tlcmz scan files which
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

	###Establish root directories to search for tlcmz
	###scan files.
	my @tlcmzScanDirectories = ();
	push @tlcmzScanDirectories, $scanFilesRootDir;

	###File::Find prints warning messages whenever you
	###have it skip a file in the sub.  We do not want
	###to see these.
	no warnings;

	###Perform search of the file system for each of
	###the root directories in the tlcmzScanDirectories
	###list configured above. If loadDeltaOnly is true
	###then ignore previously processed files.
	find(
		sub {
			next unless -f && -s;
			next if $loadDeltaOnly == 1 && m/.processed$/;

			# for the time being do not process .error files
			next if $loadDeltaOnly == 1 && m/.error$/;
			push( @inputFiles, $File::Find::name );
		},
		@tlcmzScanDirectories
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
	my %computerList               = ();
	my %tlcmzSoftwareList          = ();
	my %installedTLCMZSoftwareList = ();

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
		dlog(
			"no matching atp hardware lpar record found for full serial number"
		);

		# Added logic to check if it matches serial 4
		foreach my $my_id ( sort keys %{$hardwareLparMap} ) {
			next
			  unless $lpar eq $hardwareLparMap->{$my_id}->{"hardwareLparName"};
			my $serial4 = substr $serial, -4;
			my $hardwareSerial4 =
			  substr $hardwareLparMap->{$my_id}->{"hardwareSerial"}, -4;
			if ( $serial4 eq $hardwareSerial4 ) {
				my $machineType =
				  Staging::Delegate::StagingDelegate->getMachineTypeByHardwareId( $lpar,
					$serial4 );
				if ( $machineType eq "MAINFRAME" ) {
					$atpAcctNum = $hardwareLparMap->{$my_id}->{"accountNumber"};
					dlog( "acct num from atp based on serial(4): "
						  . $atpAcctNum );
					last;
				}
			}
		}
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
	my $computer = new SWASSET::OM::TLCMZComputer();
	$computer->computerSysId( $acctNum . "." . $lpar );

	###Original routine used now for scantime
	###Use now for scantime (fmt = yyyy-MM-dd-hh.mm.ss.000000)
	# my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
	# Don changed to use the file creation time as the scantime
	# changed from $ctime to $mtime after SA changed file permissions
	# $ctime is updated when file permissions/ownership is changed
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)
           = stat($inputFile);
        my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime($mtime);
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
	dlog( "computer=" . $computer->toString() );

	###Add computer object to list to return
	$computerList{ $computer->computerSysId } = $computer;

	###Process input file for software and installed sofware records
	my $csv = Text::CSV->new();
	open CSV, "<$inputFile" or die "$inputFile: $!";
	my $lineNum = 0;
	while (<CSV>) {
		$lineNum++;
		s/^\s+//g;
		s/\s+$//g;
		chomp;
		if ( $csv->parse($_) ) {
			my @row = $csv->fields();
			if ( defined $row[0] && scalar(@row) >= 7 ) {
				###Get the record hash.
				my @fields = (
					qw(tlcmzProductId
					  na1
					  tlcmzProductName
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
				my %rec   = map { $fields[ $index++ ] => $_ } @row;

				###Perform line level validation.
				my $lineError = 0;

				###Check for a space char in the lparName.
				if ( $rec{lparName} =~ m/ / ) {
					wlog("blank lparName on line $lineNum of file $inputFile");
					$lineError = 1;
				}

				###Check tlcmz product id is <= 8 chars.
				if ( length( $rec{tlcmzProductId} ) > 8 ) {
					wlog(
"tlcmz prod id > 8 chars on line $lineNum of file $inputFile"
					);
					$lineError = 1;
				}

				if ( $lineError == 1 ) {
					$self->markFileAsError($inputFile);
					return ( undef, undef, undef );
				}

				###Instantiate tlcmz sw object
				my $tlcmzSoftware = new SWASSET::OM::TLCMZSoftware();
				$tlcmzSoftware->tlcmzProductId( $rec{tlcmzProductId} );
				$tlcmzSoftware->tlcmzProductName( $rec{tlcmzProductName} );
				$tlcmzSoftware->vendorId( $rec{vendorId} );
				$tlcmzSoftware->vendorName( $rec{vendorName} );
				$tlcmzSoftware->versionGroupId( $rec{versionGroupId} );
				$tlcmzSoftware->productVersion( $rec{productVersion} );
				$tlcmzSoftware->productRelease( $rec{productRelease} );
				$tlcmzSoftware->productEblmtElgFlag(
					$rec{productEblmtElgFlag} );
				$tlcmzSoftware->ibmFeatureCode( $rec{ibmFeatureCode} );
				$tlcmzSoftware->productDelIndicator(
					$rec{productDelIndicator} );
				dlog( "tlcmzSoftware=" . $tlcmzSoftware->toString() );

				###Add the tlcmz sw object to the list
				my $tlcmzSoftwareKey = $tlcmzSoftware->tlcmzProductId;
				if ( exists $tlcmzSoftwareList{$tlcmzSoftwareKey} ) {
					wlog("this tlcmz sw was already in the list hash");
				}
				else {
					$tlcmzSoftwareList{$tlcmzSoftwareKey} = $tlcmzSoftware;
				}

				###Instantiate inst tlcmz sw object
				my $installedTLCMZSoftware =
				  new SWASSET::OM::InstalledTLCMZSoftware();
				$installedTLCMZSoftware->computerSysId(
					$computer->computerSysId );
				$installedTLCMZSoftware->tlcmzProductId(
					$tlcmzSoftware->tlcmzProductId );
				dlog( "installedTLCMZSoftware="
					  . $installedTLCMZSoftware->toString() );

				###Add the inst tlcmz sw record to the list
				my $installedTLCMZSoftwareKey =
				    $computer->computerSysId . "."
				  . $tlcmzSoftware->tlcmzProductId;
				if (
					exists
					$installedTLCMZSoftwareList{$installedTLCMZSoftwareKey} )
				{
					wlog("this inst tlcmz sw was already in the list hash");
				}
				else {
					$installedTLCMZSoftwareList{$installedTLCMZSoftwareKey} =
					  $installedTLCMZSoftware;
				}
			}
			else {
				###Parsing error, wlog it and then mark the input file as error,
				###and return undefs to the caller.
				wlog("csv parsing error on line $lineNum of file $inputFile");
				$self->markFileAsError($inputFile);
				return ( undef, undef, undef );
			}
		}
		else {
			my $err = $csv->error_input;
			print "Failed to parse line: $err";
		}
	}
	close CSV;

	return ( \%computerList, \%tlcmzSoftwareList,
		\%installedTLCMZSoftwareList );
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
