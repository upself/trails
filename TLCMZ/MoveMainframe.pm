#!/usr/bin/perl -w

package TLCMZ::MoveMainframe;

use strict;
use warnings;
use File::Copy;
use File::Basename;
use XML::Twig;
use Time::Local;


my @message;

sub new
{
   my $class = shift;
   my $self = {
   	    _typeDir => shift
        ,_userEmail => 'UNKNOWN'
        ,_fileName => shift
        ,_ftpLog => '/var/log/vsftpd.log'
        ,_reviewAll => 'yes'
        ,_testing => 'yes'
        ,_logCheck => 'no'
        ,_maxCreateTime => time - ( 30 * 60 )
        ,_maxFileSize => 1024 * 1024
        ,_startTime => localtime   	
   };               
	umask(007);
   return bless $self, $class;   
}

sub DESTROY
{
   print "   moveMainframe::DESTROY called\n";
}

sub setUserEmail() {
	my ( $self, $userEmail ) = @_;
    $self->{_userEmail} = $userEmail if defined($userEmail);
    return $self->{_userEmail};	
}

sub getUserEmail {
    my( $self ) = @_;
    return $self->{_userEmail};
}

sub getLogCheck {
    my( $self ) = @_;
    return $self->{_logCheck};
}

sub getFileName {
    my( $self ) = @_;
    return $self->{_fileName};
}

sub getMaxCreateTime {
    my( $self ) = @_;
    return $self->{_maxCreateTime};	
}

sub getMaxFileSize {
    my( $self ) = @_;
	return $self->{_maxFileSize};	
}

sub getReviewAll {
    my( $self ) = @_;
	return $self->{_reviewAll};	
}

sub getTesting {
    my( $self ) = @_;
	return $self->{_testing};	
}

sub getStartTime {
    my( $self ) = @_;
	return $self->{_startTime};	
}

sub getPermDir {
    my( $self ) = @_;
	return '/var/ftp/' . $self->{_typeDir} . '/perm/';	
}

sub getBadDir {
    my( $self ) = @_;
	return '/var/ftp/' . $self->{_typeDir} . '/bad/';	
}


sub getLog {
    my( $self ) = @_;
	return '/var/ftp/' . $self->{_typeDir} . '/log.txt';	
}

sub getIncomingDir {
    my( $self ) = @_;
	return '/var/ftp/' . $self->{_typeDir} . '/';	
}

sub checkIt($) {
	my ($self, $file ) = @_;
	my $fileToCheck = $self->getIncomingDir() . $file;
	my $fromWeb     = "no";
	$self->setUserEmail("UNKNOWN");
	print $fileToCheck;

	# in the log file it is relative to the main ftp directory
	my $ftpFileName = "/" . $self->{_typeDir} . "/" . $file;
	my (
		$dev,  $ino,   $mode,  $nlink, $uid,     $gid, $rdev,
		$size, $atime, $mtime, $ctime, $blksize, $blocks
	) = stat($fileToCheck);
	if ( $size > $self->getMaxFileSize() ) {
		return "bad", "bad";
		@message = ( @message, "$fileToCheck was too big to be a valid file." );
	}

	if ( $self->getLogCheck() eq "yes" ) {

   # check the vsftpd.log file for this entry but don't fail
   # if not in the log file -- just in case this script hasn't ran for many days
		open FTPLOG, "< " . $self->getFtpLog() or die "unable to open log";
		my @logEntry = {};

		while (<FTPLOG>) {
			@logEntry = split / /;

			# find the file
			if ( ( $logEntry[8] eq $ftpFileName ) && ( $logEntry[7] == $size ) )
			{

				# set the email address
				$self->setUserEmail($logEntry[13]);

				# check for various things in the log
				# is the transfer complete?
				if ( $logEntry[17] eq "i" ) {

		 # in $maxCreateTime seconds -- thus we need to email the user and whack
		 # no file should take more than 30 minutes to transmit
					if ( $self->getMaxCreateTime() > $ctime ) {
						@message = (
							@message,
"ftping $file to the tap server appears to have died before completing. Your partial file was deleted. Please restart the process."
						);
						return "bad", "bad";
					}
					else {
						return "working", "working";
					}
				}
			}
		}
		close FTPLOG;
	}
	print "Checking $fileToCheck \n";
	open FH, "< $fileToCheck" || return "bad", "bad";
	my $line = "";
	my $cpu  = "";
	my $lpar = "";
	my $myTime = time;
	$_ = $file;
	if (/^WEB_/) {
		my @fileParts = split /_/;
		$cpu  = $fileParts[2];
		$lpar = $fileParts[3];
		if ( $#fileParts > 4 ) {
			foreach my $f ( @fileParts[ 4 .. $#fileParts ] ) {
				$lpar .= "_" . $f;
			}
		}
		$lpar =~ s/.TXT//g;
		print "LPAR name is $lpar \n";
		$fromWeb = "yes";
	}
	if ( /xml$/ || /XML$/ ) {
		# preload cpu and lpar as bad
		$lpar = "bad";
		$cpu = "bad";
		my $twig1 =
		  new XML::Twig(
			twig_roots => { 'Comment' => 1 } );
		$twig1->parsefile($fileToCheck);
		my $root1 =  $twig1->root;
		my $comment = $root1->text;
		my @comments = split('\n', $comment);
		foreach my $c ( @comments ) {
			if ( $c =~ /LAST SURVEY/ ) {
				(my $month, my $day, my $year ) = split('/', substr($c, 14, 10));
				$myTime = timelocal(0, 1, 12, $day, $month -1, $year);
			}
		}
					
		my $twig =
		  new XML::Twig(
			twig_roots => { 'HardwareInventoryAndCapacity' => 1 } );
		$twig->parsefile($fileToCheck);    # build the twig
		my $root      = $twig->root;       # get the root of the twig
		my @hardwares = $root->children;
		my $hardware  = $hardwares[0];

		$cpu =
		  $hardware->first_child('Hardware')->{'att'}->{'hwUniqueKey'};
		my $cpu1 =
		  $hardware->first_child('Hardware')->{'att'}->{'hwPlantCode'};
		
		my $twig2 =
		  new XML::Twig(
			twig_roots => { 'SoftwareInventoryAndUse' => 1 } );
		$twig2->parsefile($fileToCheck);    # build the twig
		my $root2      = $twig2->root;       # get the root of the twig
		my @lpars = $root2->children;
		my $lpar2  = $lpars[0];

		$lpar = $lpar2->first_child('System')->{'att'}->{'hwPartitionUniqueKeyRef'};
		
		
		
		close FH;
		$cpu = substr $cpu, -5;
		return $cpu1 . $cpu, $lpar, $myTime;

	}
	if ( /asc$/ || /ASC$/ ) {
		# preload cpu and lpar as bad
		$lpar = "bad";
		$cpu = "bad";
		undef $myTime;
		my $asterCount = 0;
		my $lineCount = 0;
		my $tmpTime;
		my $commentScanTime;
		while (<FH>) {
			# Check and grab the scan date from the header if possible
			if ( /\* LAST SURVEY: / ) {
				my $stringDate = substr($_, 15, 10);
				my $month = substr($stringDate, 0, 2);
				my $day = substr($stringDate, 3, 2);
				my $year = substr($stringDate, 6, 4 );
				$commentScanTime = timelocal(0, 1, 12, $day, $month -1, $year);
			}
			if ( $asterCount == 2 ) {
				$lineCount++;
			}
			if ( /\*\*\*\*\*\*\*\*\**/) {
				$asterCount++;
			}
			if ( $lineCount == 2 ) {
				$cpu = substr($_, 417, 11 );
				$cpu =~ s/ //g;
				$lpar = substr($_, 408, 8);
				$lpar =~ s/ //g;
				while (<FH>) {
					if ( /^S[ACU]/ ) {
						my $stringDate = substr($_, 2, 8);
						my $month = substr($stringDate, 0, 2);
						my $day = substr($stringDate, 2, 2);
						my $year = substr($stringDate, 4, 4);
						$tmpTime = timelocal(0, 1, 12, $day, $month -1, $year);
						if ( ! defined $myTime ) {
							$myTime = $tmpTime;
						} else {
							if ( $tmpTime > $myTime ) {
								$myTime = $tmpTime;
							}
						}
#						close FH;
#						return $cpu, $lpar, $myTime;
					}
				}
				close FH;
				if ( ! defined($commentScanTime) ) {
					$commentScanTime = timelocal(0, 1, 12, 1, 0, 1970);
				}
				if ( ! defined($myTime) ) {
					$myTime = $commentScanTime;
				}
				return $cpu, $lpar, $myTime;
			}
			if ( /\* SESDR syst_id / ) {
				# I am disabling this UNTIL we have a good file to test
				$cpu = "bad";
				$lpar = "bad";
				close FH;
				return $cpu, $lpar, $myTime;
			}
		}
		close FH;
		# if it is not set above then it returns "bad"
		return $cpu, $lpar, $myTime;
	}

	# if I have made it this far then it is a normal file
	my $eofChar = 0;

	while (<FH>) {

		my @fields = split /","/;

		# Originally we were checking for 19 which is what is
		# documented in the TLCMz documentation
		# check to make sure it has the right number of columns (14)
		# NOTE: $# is the subscript of the last element NOT the length
		# and that the lpar and cpu columns are unchanging
		if ( $fields[7] ) {
			if ( $#fields < 13 ) {
				close FH;
				@message = (
					@message,
"$fileToCheck did not have the correct number of fields in the file."
				);
				return "bad", "bad", $myTime;
			}
			if ( $cpu eq "" ) {
				$cpu  = $fields[7];
				$lpar = $fields[6];
			}
			else {
				if (   ( $fromWeb eq "no" )
					&& ( ( $fields[7] ne $cpu ) || ( $fields[6] ne $lpar ) ) )
				{
					close FH;
					@message = (
						@message,
"$fileToCheck had cpu and lpar that changed in the file."
					);
					return "bad", "bad", $myTime;
				}
			}
		}
		else {
			if ( $#fields == 0 ) {
				$eofChar = ord @fields;
			}
			else {
				close FH;
				@message = (
					@message,
					"$fileToCheck is missing an end of transmission marker."
				);
				return "bad", "bad", $myTime;
			}
		}
	}
	close FH;
	return $cpu, $lpar, $myTime;

}

sub sendNotice() {
    my( $self ) = @_;
	my $errorFile = $self->getFileName() . "ERR";
	open ERRMESG, "> $errorFile";
	for my $messageLine (@message) {
		print ERRMESG $messageLine . "\n";
	}
	my $mail_me = "mutt -s '" .
		$self->getUserEmail() . " " .
		$self->getFileName() . " submitted to BRAVO' -a " .
		$self->getFileName() . " " . $self->getUserEmail() . " < $errorFile";
	if ( !$self->getUserEmail() eq "" ) {
		unless ( $self->getTesting() eq "yes" ) { system($mail_me) }
	}
	else {
		print "No user email address for " . $self->getFileName();
		for my $messageLine (@message) {
			print $messageLine . "\n";
		}
	}
	
	close ERRMESG;

	# clear the message array and remove error messages file
	@message = {};
	unlink $errorFile;
}

sub processBadFile($) {
    my( $self, $badFile ) = @_;

	# make log entry
	open LOG, ">> " . $self->getLog() or warn "Unable to open log.";
	print LOG "$badFile is invalid and will be processed as such.\n";
	for my $messageLine (@message) {
		print LOG $self->getStartTime() . " " . $messageLine . "\n";
	}
	close LOG;
	$self->sendNotice();
	if ( $self->getReviewAll() eq "yes" ) {
		my ( $basefile, $dir, $ext ) = fileparse($badFile);
		copy( $badFile, $self->getBadDir() . $basefile );
		unlink $badFile;
	}
	else {
		unlink $badFile;
	}
}

sub moveFile($$$$$) {
	my $self = shift;
	my $file = shift;
	my $cpu  = shift;
	my $lpar = shift;
	my $myTime = shift;

	# create directories if they do not exist
	if ( !-d $self->getPermDir() . $cpu ) {
		mkdir $self->getPermDir() . "/" . $cpu;
	}
	if ( !-d $self->getPermDir() . $cpu . "/" . $lpar ) {
		mkdir $self->getPermDir() . "/" . $cpu . "/" . $lpar;
	}

	# only do the rest of this if the directory exists
	if ( -d $self->getPermDir() . "/" . $cpu . "/" . $lpar ) {
		my ( $basefile, $dir, $ext ) = fileparse($file);

# delete all the old files before doing anything
# -- processed files will have an extension of ".processed" thus will not be deleted
		my @deleteFiles =
		  glob $self->getPermDir() . "/" . $cpu . "/" . $lpar . "/" . "*.{txt,TXT}";
		for my $deleteFile (@deleteFiles) {
			unlink($deleteFile);
		}
		copy( $file, $self->getPermDir() . "/" . $cpu . "/" . $lpar . "/" . $basefile )
		  or die "File cannot be copied.";
		utime $myTime, $myTime, $self->getPermDir() . "/" . $cpu . "/" . $lpar . "/" . $basefile;
		unlink($file);
		open TO_PROC, ">> " . $self->getIncomingDir() . "/to_scan.txt";
		print TO_PROC $self->getStartTime() . " " 
		  . $self->getPermDir() 
		  . $cpu . "/" 
		  . $lpar . "/"
		  . $basefile . " "
		  . $self->getUserEmail() . " \n";
		close TO_PROC;

		# give a positive notification
		@message = (
			@message,
"$file has been submitted and will show up in BRAVO if $cpu $lpar exists in ATP."
		);
		$self->sendNotice();
	}
	else {
		print "Unable to copy $file due to directory problem";
	}
}


1;
