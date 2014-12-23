#!/usr/bin/perl

#-------------------------------------------------------------------------------
# Program: ftpTransfer.pl
# Author: Michal Starek (michal.starek@cz.ibm.com)
# ----------------------------------------------
# Performs SFTP file transfering by pre-configured parameters
#-------------------------------------------------------------------------------

# constants
use strict;
use File::Basename;
use File::stat;
use Net::SFTP;
use Base::Utils;

# global variables
our $name; # name of this FTP session processed
our $direction; # remote to local or local to remote
our $srchostname; # remote hostname of source
our $tgthostname; # remote hostname of target
our $source; # source directory
our $target; # target directory
our $filemask; # regular expression to match the filename
our $delsource; # true false whether to keep the original files after successful copy
our $minage; # minimum age of file, in minutes
our $flag; # a special file marking the files are ready (is by itself never transferred
our $srcftpuser; # source FTP user
our $srcftppwd; # source FTP password
our $tgtftpuser; # target FTP user
our $tgtftppwd; # target FTP password

our $flagispresent; # flag is present

our %processednames; # hash of all the processed FTP sessions

our $logfile    = "/var/staging/logs/ftpTransfer/ftpTransfer.log";

####################################
##       SUBS
####################################
sub Usage {
	print <<EOL;
A tool for FTP transfer of files from or to a target server
Requires a single parameter, pointing to config file.
The logfile is $logfile

The config file should look like (comments can be written after # and are optional ):

[TARGET-NAME] # name of the copying job
direction=rem2loc # rem2loc - remote to local, loc2rem or rem2rem - in the future we shall implement also some zipping
srchostname=REMOTE HOSTNAME
tgthostname=REMOTE HOSTNAME OF TARGET
source=SOURCE DIRECTORY # to copy from
target=TARGET DIRECTORY
filemask=regular expression to match the filename
srcftpuser=username # for logging onto FTP source
srcftppwd=password
tgtftpuser=username # for logging onto FTP target
tgtftppwd=password
delsource=true # true/false, whether delete the original files after successful copying - default yes
minage=minimum of age of the file to be copied, in minutes - optional, default 0
flag=FILENAME # if given, then the files will only be transferred when the "flag" filename exists in the source dir
<blank line>
[ANOTHER-TARGET-NAME] # name of another copying job - MUST BE DIFFERENT!
direction=...

The order of the parameters doesn't matter, however all of them except the last seven are mandatory.
Of course only remote hostname of source / target is mandatory where applicable, depending on the copying direction.
(When user and password not given, assuming login via SSH keys.)
EOL
	exit;
}

sub readcfgfile { # reads from config file
	my $fh=shift;
	
	while ( my $line=(<$fh>) ) {
		if ($line =~ /^\[/) { # init
			$line =~ /^\[([^\]]+)]/;
			$name=$1;
			$direction="";
			$srchostname="";
			$tgthostname="";
			$source="";
			$target="";
			$srcftpuser="";
			$srcftppwd="";
			$tgtftpuser="";
			$tgtftppwd="";
			$filemask="";
			$delsource="true";
			$flag="";
			$minage=0;
			$flagispresent=0; # bool whether the flagfile has been present
		}
		$direction=lc(retparam($line)) if ( $line =~ /^direction/i );
		$srchostname=retparam($line) if ( $line =~ /^srchostname/i );
		$tgthostname=retparam($line) if ( $line =~ /^tgthostname/i );
		$source=retparam($line) if ( $line =~ /^source/i );
		$target=retparam($line) if ( $line =~ /^target/i );
		$srcftpuser=retparam($line) if ( $line =~ /^srcftpuser/i );
		$srcftppwd=retparam($line) if ( $line =~ /^srcftppwd/i );
		$tgtftpuser=retparam($line) if ( $line =~ /^tgtftpuser/i );
		$tgtftppwd=retparam($line) if ( $line =~ /^tgtftppwd/i );
		$filemask=retparam($line) if ( $line =~ /^filemask/i );
		$delsource=lc(retparam($line)) if ( $line =~ /^delsource/i );
		$flag=retparam($line) if ( $line =~ /^flag/i );
		$minage=retparam($line) if ( $line =~ /^minage/i );
		
		if ( $line =~ /^\s*$/ ) { # blank line, this is our point of complete reading of one session
			if ( (( $srchostname ne "" ) || ( $tgthostname ne "" )) && ( $direction ne "" ) && ( $source ne "" ) && ( $target ne "" ) && ( $filemask ne "" )) {
				next if exists ($processednames{$name});
				$processednames{$name}=1;
				dlog("Found job: name=$name, direction=$direction, srchostname=$srchostname, tgthostname=$tgthostname, source=$source, target=$target, filemask=$filemask");
				return 1;
			}
		}
	}
	
	if ( (( $srchostname ne "" ) || ( $tgthostname ne "" )) && ( $direction ne "" ) && ( $source ne "" ) && ( $target ne "" ) && ( $filemask ne "" )) {
		return 0 if exists ($processednames{$name});
		$processednames{$name}=1;
		dlog("Found job: name=$name, direction=$direction, srchostname=$srchostname, tgthostname=$tgthostname, source=$source, target=$target, filemask=$filemask");
		return 1;
	}
		
	return 0;
}
	
sub retparam { # returs the parameter    motaba=12 #comment ----> returns 12
	my $string=shift;
	my $toret;
	
	$string =~ /^[^=]*=([^#]+)/;
	$toret=$1;
	
	$toret =~ s/^\s*//;
	$toret =~ s/\s*$//;
	
	return $toret;
}

sub loginToFTP {
	my $hostname=shift;
	my $ftplogin=shift;
	my $ftppwd=shift;
	
	my $sftp;
	
	$ftplogin="" unless (defined $ftplogin);
	$ftppwd="" unless (defined $ftppwd);

    if (( $ftplogin ne "" ) && ( $ftppwd ne "" )) {
		unless($sftp = Net::SFTP->new($hostname, user => $ftplogin, password => $ftppwd)){ wlog "WARNING: Job $name, can't connect/login to $hostname: ".$@; return undef; }
	} else {
		unless($sftp = Net::SFTP->new($hostname)){ wlog "WARNING: Job $name, can't connect loginless to $hostname: ".$@; return undef; }
	}
	
	return $sftp;
}

sub filetomove { # determines whether given file is elligible to be copied
	my $filename=shift;
	my $stamp=shift;
	my $curstamp=time;
	
	if (( defined $flag ) && ( $flag eq $filename)) { # the flagfile itself
		$flagispresent = 1;
		return 0;
	}
	
	return 0 if ($filename =~ /^\./ ); # UNIX hidden file
	
	if ($filename !~ /$filemask/ ) {
		dlog("$filename skipped, not in the defined mask! (job $name)");
		return 0;
	} # file not belonging to the defined mask
	
	return 1 if ( (( $curstamp - $stamp ) / 60 ) > $minage );	# file older than minimum age
	
	dlog("$filename skipped, too new for the defined minage of $minage minutes! (job $name)");
	return 0;
}

##################################
##        MAIN
##################################

logging_level( "debug" );
logfile($logfile);

Usage() unless ( defined $ARGV[0] );

my $curstamp;

open (CFGFILE,"<",$ARGV[0]) or die ("The config file can't be opened!\n");

while (readcfgfile(\*CFGFILE)) {
	ilog("============== Working on $name SFTP job ================");
	
	# if there are more valid directions in future, this needs to change
	if (( $direction ne "rem2loc" ) && ( $direction ne "loc2rem" ) && ( $direction ne "rem2rem")) {
		elog("ERROR: Invalid value of direction, not rem2loc, loc2rem or rem2rem, skipping $name!");
		next;
	}
	
    if ( $direction eq "rem2loc" ) { ##################### REMOTE TO LOCAL
		my %filestocopy;
		
		if ( $srchostname eq "" ) {
			elog("ERROR: Job $name, no source hostname with rem2loc direction, invalid!");
			next; 
		}
		
		my $srcftp=loginToFTP($srchostname, $srcftpuser, $srcftppwd );
		next unless defined $srcftp; # login failed
		
		foreach my $entry ( $srcftp->ls($source) ) { # puts each file of the remote ls into hash of files to be copied, if it passes filetomove func
			my $soubor=$entry->{filename};
			$filestocopy{$soubor} = 1 if (filetomove($soubor, $entry->{a}->{mtime}) );
		}
			
		if (( $flag ne "" ) && ( $flagispresent == 0 )) {
			wlog("Flagfile $flag is defined and not present in the source directory, skipping job $name!");
			next;
		}
			
		my $successfulfiles=0;
		ilog("Job $name, copying files...");
		foreach my $file (keys %filestocopy) {
			$successfulfiles++;
			dlog("Job $name, copying $file...");
			$srcftp->get($source."/".$file, $target."/".$file);
			if ( $srcftp->status != 0 ) {
				elog("Job $name, error copying file $file!");
				$filestocopy{$file}=0;
				$successfulfiles--;
			}
		}
		ilog("Job $name, successfully copied $successfulfiles of ".scalar (keys %filestocopy).".");
		if (( $flag ne "" ) && ( $successfulfiles > 0 ) && ( $successfulfiles eq (scalar keys %filestocopy) ) ) {
			ilog("Job $name, removing flag from source directory...");
			$srcftp->do_remove($source."/".$flag);
		}
		if ( lc($delsource) eq "true" ) {
			ilog("Job $name, deleting successfully copied source files...");
			foreach my $file (keys %filestocopy) {
				next unless ( $filestocopy{$file} == 1 );
				$srcftp->do_remove($source."/".$file);
			}
		}

	} elsif ( $direction eq "loc2rem" ) { ################################# LOCAL TO REMOTE
		my %filestocopy;
		
		my $dirhandle;
		
		if ( $tgthostname eq "" ) {
			elog("Job $name, ERROR: No target hostname with loc2rem direction, invalid!");
			next; 
		}
		
		my $tgtftp=loginToFTP($tgthostname, $tgtftpuser, $tgtftppwd );
		next unless defined $tgtftp; # login failed
		
		opendir($dirhandle, $source) || elog("Can't open the directory $source, skipping job $name!");
		closedir($dirhandle);
		opendir($dirhandle, $source) || next;
		
		while (my $file=readdir($dirhandle)) {
			my $stats=stat($source."/".$file);
			$filestocopy{$file} = 1 if (filetomove($file, $stats->mtime));
		}
		
		closedir($dirhandle);
		
		if (( $flag ne "" ) && ( $flagispresent == 0 )) {
			wlog("Flagfile $flag is defined and not present in the source directory, skipping job $name!");
			next;
		}
			
		my $successfulfiles=0;
		ilog("Job $name, copying files...");
		foreach my $file (keys %filestocopy) {
			$successfulfiles++;
			dlog("Job $name, copying $file...");
			$tgtftp->put($source."/".$file, $target."/".$file);
			if ( $tgtftp->status != 0 ) {
				elog("Job $name, error copying file $file!");
				$filestocopy{$file}=0;
				$successfulfiles--;
			}
		}
		ilog("Job $name, successfully copied $successfulfiles of ".scalar (keys %filestocopy).".");
		if (( $flag ne "" ) && ( $successfulfiles > 0 ) && ( $successfulfiles eq (scalar keys %filestocopy) ) ) {
			ilog("Job $name, removing flag from source directory...");
			unlink($source."/".$flag);
		}
		if ( lc($delsource) eq "true" ) {
			ilog("Job $name, deleting successfully copied source files...");
			foreach my $file (keys %filestocopy) {
				next unless ( $filestocopy{$file} == 1 );
				unlink($source."/".$file);
			}
		}


	}


}

close (CFGFILE);

dlog("Exiting normally.");
