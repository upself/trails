#!/usr/bin/perl

#-------------------------------------------------------------------------------
# Program: sftpTransfer.pl
# Author: Michal Starek (michal.starek@cz.ibm.com)
# ----------------------------------------------
# Performs SFTP or GSA file transferring by pre-configured parameters
#-------------------------------------------------------------------------------

use Sys::Hostname;
use File::Basename;
use File::Copy;
use File::stat;

#### CONSTANTS TO CHANGE FOR USING IN A NEW TEAM
use lib '/opt/staging/v2';
use Base::Utils;
our $useftp = ( hostname eq "tap.raleigh.ibm.com" ) ? 0 : 1;
our $logfile    = "/var/staging/logs/sftpTransfer/sftpTransfer.log";
our $connectionConfig = "/opt/staging/v2/config/connectionConfig.txt"; # from this file, passwords are taken - so they're not stored on multiple places

logging_level( "info" ); # detailed level of the logfile
###################################################

use if ( $useftp ), Net::SFTP; # stupid crappy TAP server doesn't have Perl SFTP modules and can't install them

# global variables
our $name; # name of this FTP session processed
our $direction; # remote to local or local to remote
our $srchostname; # remote hostname of source
our $tgthostname; # remote hostname of target
our $source; # source directory
our $target; # target directory
our @filemasks; # regular expressions to match the filename
our $delsource; # true false whether to keep the original files after successful copy
our $minage; # minimum age of file, in minutes
our $flag; # a special file marking the files are ready (is by itself never transferred
our $srcusr; # source FTP user
our $srcpwd; # source FTP password
our $tgtusr; # target FTP user
our $tgtpwd; # target FTP password

our $flagispresent; # flag is present

our %processednames; # hash of all the processed FTP sessions

our %connConfigParams; # hash of all the lines in connection config file, to keep passwords in one place

####################################
##       SUBS
####################################
sub readConnectionConfig {
	my $param=shift;
	
	return $param unless ( $param =~ /^\[.*\]$/ );
	
	$param =~ s/^\[//;
	$param =~ s/\]$//;
	
	if (scalar(keys %connConfigParams) == 0 ) {
		open(CONNCONF, "<$connectionConfig") or die "Can't open the connectionConfig file $connectionConfig !";
		while (my $line=<CONNCONF>) {
			chomp($line);
			$line =~ s/\r//g;
			my ($str1, $str2) = split(/=/, $line);
			$connConfigParams{$str1}=$str2;
		}
		close(CONNCONF);
	}
	
	unless (exists $connConfigParams{$param} ) {
		wlog("Warning! Parameter $param not found in $connectionConfig file!");
		return undef;
	}
	
	return $connConfigParams{$param};
}

sub Usage {
	print <<EOL;
A tool for FTP transfer of files from or to a target server
Requires a single parameter, pointing to config file.
The logfile is $logfile

The config file should look like (comments can be written after # and are optional ):

[TARGET-NAME] # name of the copying job
direction=ftp2loc # ftp2loc - FTP to local, gsa2loc - GSA to local, loc2gsa or any other combination
srchostname=REMOTE HOSTNAME / GSA CELL NAME OF SOURCE
tgthostname=REMOTE HOSTNAME / GSA CELL NAME OF TARGET
source=SOURCE DIRECTORY # to copy from
target=TARGET DIRECTORY # to copy into
filemask=regular expression to match the filename
srcusr=username # for logging onto FTP/GSA source
srcpwd=password
tgtusr=username # for logging onto FTP/GSA target
tgtpwd=password
delsource=true # true/false, whether delete the original files after successful copying - default yes
minage=minimum of age of the file to be copied, in minutes - optional, default 0
flag=FILENAME # if given, then the files will only be transferred when the "flag" filename exists in the source dir
<blank line>
[ANOTHER-TARGET-NAME] # name of another copying job - MUST BE DIFFERENT!
direction=...

The order of the parameters doesn't matter, however the first five are mandatory.
Of course only remote hostname of source / target is mandatory where applicable, depending on the copying direction.
(When user and password not given for FTP, assuming login via SSH keys. User and password are mandatory for GSA.)

NOTE: Instead of specifying a solid value, like password, you can specify to use certain attribute from $connectionConfig .
Like this:
srcftpuser=[gsa.swmulti.report.user]

NOTE: You can also define more filemasks, as filemask, filemask2 and filemask3...
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
			$srcuser="";
			$srcpwd="";
			$tgtuser="";
			$tgtpwd="";
			@filemasks=();
			$delsource="true";
			$flag="";
			$minage=0;
			$flagispresent=0; # bool whether the flagfile has been present
		}
		$direction=lc(retparam($line)) if ( $line =~ /^direction/i );
		$srchostname=readConnectionConfig(retparam($line)) if ( $line =~ /^srchostname/i );
		$tgthostname=readConnectionConfig(retparam($line)) if ( $line =~ /^tgthostname/i );
		$source=readConnectionConfig(retparam($line)) if ( $line =~ /^source/i );
		$target=readConnectionConfig(retparam($line)) if ( $line =~ /^target/i );
		$srcusr=readConnectionConfig(retparam($line)) if ( $line =~ /^srcusr/i );
		$srcpwd=readConnectionConfig(retparam($line)) if ( $line =~ /^srcpwd/i );
		$tgtusr=readConnectionConfig(retparam($line)) if ( $line =~ /^tgtusr/i );
		$tgtpwd=readConnectionConfig(retparam($line)) if ( $line =~ /^tgtpwd/i );
		push (@filemasks, retparam($line) ) if ( $line =~ /^filemask/i );
		$delsource=lc(retparam($line)) if ( $line =~ /^delsource/i );
		$flag=retparam($line) if ( $line =~ /^flag/i );
		$minage=retparam($line) if ( $line =~ /^minage/i );
		
		if ( $line =~ /^\s*$/ ) { # blank line, this is our point of complete reading of one session
			if ( (( $srchostname ne "" ) || ( $tgthostname ne "" )) && ( $direction ne "" ) && ( $source ne "" ) && ( $target ne "" ) && ( $filemasks[0] ne "" )) {
				next if exists ($processednames{$name});
				$processednames{$name}=1;
				dlog("Found job: name=$name, direction=$direction, srchostname=$srchostname, tgthostname=$tgthostname, source=$source, target=$target, filemask1=".$filemasks[0]);
				return 1;
			}
		}
	}
	
	if ( (( $srchostname ne "" ) || ( $tgthostname ne "" )) && ( $direction ne "" ) && ( $source ne "" ) && ( $target ne "" ) && ( $filemasks[0] ne "" )) {
		return 0 if exists ($processednames{$name});
		$processednames{$name}=1;
		dlog("Found job: name=$name, direction=$direction, srchostname=$srchostname, tgthostname=$tgthostname, source=$source, target=$target, filemask1=".$filemasks[0]);
		return 1;
	}
		
	return 0;
}
	
sub retparam { # returs the parameter    motaba=12 #comment ----> returns 12
	my $string=shift;
	my $toret;
	
	chomp($string);
	
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
	
	return undef unless ( $useftp );
	
	$ftplogin="" unless (defined $ftplogin);
	$ftppwd="" unless (defined $ftppwd);

    if (( $ftplogin ne "" ) && ( $ftppwd ne "" )) {
		unless($sftp = Net::SFTP->new($hostname, user => $ftplogin, password => $ftppwd)){ wlog "WARNING: Job $name, can't connect/login to $hostname: ".$@; return undef; }
	} else {
		unless($sftp = Net::SFTP->new($hostname)){ wlog "WARNING: Job $name, can't connect loginless to $hostname: ".$@; return undef; }
	}
	
	return $sftp;
}

sub logToGSA {
	my $loginout=shift;
	my $hostname=shift;
	my $gsalogin=shift;
	my $gsapwd=shift;
	
	if (( not defined $gsalogin ) || ( not defined $gsapwd )) {
		elog ("GSA login or password not defined!");
		return 1;
	}
	
	my $parameter="";
	$parameter="-c $hostname" if ( $loginout eq "in" );
	$parameter="-r" if ( $loginout eq "out" );
	
	system "echo $gsapwd | gsa_login -p $parameter $gsalogin";
	
	unless ( $? == 0 ) {
		print "Error on logging to GSA cell $hostname, user $gsalogin (job $name)!";
		return 0;
	}
	
    return 1;
}

sub filetomove { # determines whether given file is elligible to be copied
	my $filename=shift;
	my $stamp=shift;
	my $curstamp=time;
	
	my $okay=0; # temporary value to see if the file is matching one of the given regexps
	
	if (( defined $flag ) && ( $flag eq $filename)) { # the flagfile itself
		$flagispresent = 1;
		dlog("Flagfile $flag defined and present, the files are ready to transfer (job $name)!");
		return 0;
	}
	
	return 0 if ($filename =~ /^\./ ); # UNIX hidden file or a directory link
	
	foreach my $filemask ( @filemasks ) {
		$okay=1 if ( $filename =~ /$filemask/ ); # file belonging to the defined mask
	}
	
	if ( $okay == 0 ) {
		ilog("$filename skipped, not in the defined mask(s)! (job $name)");
		return 0;
	}

	
	return 1 if ( (( $curstamp - $stamp ) / 60 ) > $minage );	# file older than minimum age
	
	dlog("$filename skipped, too new for the defined minage of $minage minutes! (job $name)");
	return 0;
}

sub getfile { # transfers the file from source to /tmp, returns 0 on success
	my $srcdir=shift;
	my $srcfile=shift;
	my $ftphandle=shift;
	
	if ( defined $ftphandle ) {
		$ftphandle->get($source."/".$file, "/tmp/".$file);
		return ( $srcftp->status != 0 );
	}
	
	copy($srcdir."/".$srcfile, "/tmp/".$srcfile );
	return $?;	
}

sub putfile { # moves file from /tmp to target
	my $srcfile=shift;
	my $tgtdir=shift;
	my $ftphandle=shift;
	
	if ( defined $ftphandle ) {
		$ftphandle->put("/tmp/".$srcfile, $tgtdir."/".$srcfile);
		unlink("/tmp/".$srcfile);
		return ( $tgtftp->status == 0 );
	}
	
	move("/tmp/".$srcfile, $tgtdir."/".$srcfile);
	return $?;
}

##################################
##        MAIN
##################################

logfile($logfile);

Usage() unless ( defined $ARGV[0] );

my $curstamp;

open (CFGFILE,"<",$ARGV[0]) or die ("The config file can't be opened!\n");

while (readcfgfile(\*CFGFILE)) {
	ilog("============== Working on $name SFTP job ================");
	
	if ( $direction !~ /^(ftp|gsa|loc)2(ftp|gsa|loc)$/ ) {
		elog("ERROR: Unknown characters in direction $direction, skipping job $name!");
		next;
	}
	
	my %filestocopy;
	
	if (( $direction =~ /^(ftp|gsa)2/ ) && ( $srchostname eq "" )) {
		elog("ERROR: Job $name, no source hostname with this direction, invalid!");
		next;
	}
	
	if (( $direction =~ /2(ftp|gsa)$/ ) && ( $tgthostname eq "" )) {
		elog("ERROR: Job $name, no target hostname with this direction, invalid!");
		next;
	}
	
	if (( $direction =~ /ftp/ ) && ( $useftp == 0 )) {
		elog("ERROR: Job $name, sadly SFTP can't be used on this server!");
		next;
	}
	
	my $srcftp=undef;
	my $tgtftp=undef;
	my $srcgsadir=undef;
	my $tgtgsadir=undef;
	
	# logging to source determining files to copy
	
	if ( $direction =~ /^ftp/ ) {
		my $srcftp=loginToFTP($srchostname, $srcusr, $srcpwd );
		next unless defined $srcftp;

		foreach my $entry ( $srcftp->ls($source) ) { # puts each file of the remote ls into hash of files to be copied, if it passes filetomove func
			my $soubor=$entry->{filename};
			$filestocopy{$soubor} = 1 if (filetomove($soubor, $entry->{a}->{mtime}) );
		}
	}
	if ( $direction =~ /^gsa/ ) {
		next unless ( logToGSA("in",$srchostname,$srcusr,$srcpwd ) );
		$srchostname =~ /^([^.]+)/;
		$srcgsadir = "/gsa/".$1.$source;
		
		opendir($dirhandle, $srcgsadir) || elog("Can't open the directory $source on GSA $srchostname, skipping job $name!");
		closedir($dirhandle);
		opendir($dirhandle, $srcgsadir) || next;
		
		while (my $file=readdir($dirhandle)) {
			my $stats=stat($srcgsadir."/".$file);
			$filestocopy{$file} = 1 if (filetomove($file, $stats->mtime));
		}
		closedir($dirhandle);
	}
	if ( $direction =~ /^loc/ ) {
		opendir($dirhandle, $source) || elog("Can't open the directory $source on local, skipping job $name!");
		closedir($dirhandle);
		opendir($dirhandle, $source) || next;
		
		while (my $file=readdir($dirhandle)) {
			my $stats=stat($source."/".$file);
			$filestocopy{$file} = 1 if (filetomove($file, $stats->mtime));
		}
		closedir($dirhandle);
	}	
	
	if (( $flag ne "" ) && ( $flagispresent == 0 )) {
			wlog("Flagfile $flag is defined and not present in the source directory, skipping job $name!");
			next;
	}
	
	###### logging to target
	
	if ( $direction =~ /ftp$/ ) {
		$tgtftp=loginToFTP($tgthostname, $tgtftpuser, $tgtftppwd );
		next unless defined $tgtftp; # login failed
	}
	
	if ( $direction =~ /gsa$/ ) {
		next unless ( logToGSA("in",$tgthostname,$tgtusr,$tgtpwd ) );
		$tgthostname =~ /^([^.]+)/;
		$tgtgsadir = "/gsa/".$1.$source;
	}
	
	if ( $direction =~ /loc$/ ) {
		opendir($dirhandle, $target) || elog("Can't open the directory $target on local, skipping job $name!");
		closedir($dirhandle);
		opendir($dirhandle, $target) || next;
	}
	
	###### copying files
	
	my $successfulfiles=0;
	ilog("Job $name, copying files...");
	
	foreach my $file (keys %filestocopy) {
		my $ret; # return value
		
		$successfulfiles++;
		dlog("Job $name, copying $file...");
		
		$ret=getfile($source, $file, $srcftp) if ( $direction =~ /^ftp/ );
		$ret=getfile($srcgsadir, $file, undef) if ( $direction =~ /^gsa/ );
		$ret=getfile($source, $file, undef) if ( $direction =~ /^loc/ );
		
		if ( $ret != 0 ) {
			elog("Job $name, error getting file $file!");
			$filestocopy{$file}=0;
			$successfulfiles--;
			next;
		}
		
		$ret=putfile($file, $target, $tgtftp) if ( $direction =~ /ftp$/ );
		$ret=putfile($file, $tgtgsadir, undef) if ( $direction =~ /gsa$/ );
		$ret=putfile($file, $target, undef) if ( $direction =~ /loc$/ );

		if ( $ret != 0 ) {
			elog("Job $name, error putting file $file!");
			$filestocopy{$file}=0;
			$successfulfiles--;
		}
	}
	
	ilog("Job $name, successfully copied $successfulfiles of ".scalar (keys %filestocopy).".");
	
	###### deletting source files

	if (( $flag ne "" ) && ( $successfulfiles > 0 ) && ( $successfulfiles eq (scalar keys %filestocopy) ) ) {
		ilog("Job $name, removing flag from source directory...");
		$srcftp->do_remove($source."/".$flag) if ( $direction =~ /^ftp/ );
		unlink($srcgsadir."/".$flag) if ( $direction =~ /^gsa/ );
		unlink($source."/".$flag) if ( $direction =~ /^loc/ );
	}
	
	if (( lc($delsource) eq "true" ) > ( $successfulfiles == 0 )) {
		ilog("Job $name, removing successfully copied source files...");
	
		foreach my $file (keys %filestocopy) {
			next unless ( $filestocopy{$file} == 1 );
			$srcftp->do_remove($source."/".$file) if ( $direction =~ /^ftp/ );
			unlink($srcgsadir."/".$file) if ( $direction =~ /^gsa/ );
			unlink($source."/".$file) if ( $direction =~ /^loc/ );
		}
	}
	
#	logToGSA("out",$srchostname,$srcusr,$srcpwd ) if ( $direction =~ /^gsa/ ); # Petr Soufek agreed he's happy not to logout from GSA
#	logToGSA("out",$tgthostname,$tgtusr,$tgtpwd ) if ( $direction =~ /gsa$/ );
	
}

close (CFGFILE);

dlog("Exiting normally.");
