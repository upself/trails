#!/usr/bin/perl

#-------------------------------------------------------------------------------
# Program: ftpTransferTest.pl
# Author: Wang Wanbo (vndwbwan@cn.ibm.com)
# ----------------------------------------------
# Test steps:
# 1) Create the config file for FTP transfer
# 2) Create the srouce files
# 3) Run sftpTransfer.pl
# 4) Check for existence of target files
# 5) Delete the target files,so it's possible to retest again
#-------------------------------------------------------------------------------

use strict;
use File::Basename;
use File::stat;
use Net::SFTP;
use lib '/opt/staging/v2';
use Cwd;

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

our $cfg="config/sftpTransferConfig.txt";
our %processednames; # hash of all the processed FTP sessions

##################################
##        MAIN
##################################

#Step 1: create a config file for FTP transfer

print "################ Start to init config file #################\n";
createCfg();
print "\n";

print "################ Start to init source files #################\n";
createSourceFiles();
print "\n";


print "################ Start to run sftpTransfer.pl #################\n";
system("perl sftpTransfer.pl $cfg");
print "\n";

print "################ Start to validate sftp result and delete sftp transferd files #################\n";
validateResultAndDelete();

# create a new config file, and write configurations


##################################
##        Subs
##################################

sub createCfg {	
	
	if(-e $cfg){
		print "config file exist. delete it.\n";
		unlink($cfg);
	}
	
	open(CFGFILE,">",$cfg) or die $!;
	
	print CFGFILE "[POKUS-MYYYSHA]\n";
	print CFGFILE "direction=rem2loc\n";
	print CFGFILE "srchostname=lexbz2250.cloud.dst.ibm.com\n";
	print CFGFILE "source=/home/myyysha/SFTPfrom\n";
	print CFGFILE "target=/home/vndwbwan/SFTPto\n";
	print CFGFILE "filemask=^w.*\n";
	print CFGFILE "srcftpuser=myyysha\n";
	print CFGFILE "srcftppwd=567uJHGt\n";
	print CFGFILE "delsource=false\n";
	print CFGFILE "minage=20\n";
	
	print CFGFILE "\n";
	
	print CFGFILE "[ZPET-MYYYSHA]\n";
	print CFGFILE "direction=loc2rem\n";
	print CFGFILE "tgthostname=lexbz2250.cloud.dst.ibm.com\n";
	print CFGFILE "target=/home/myyysha/SFTPto\n";
	print CFGFILE "source=/home/vndwbwan/SFTPfrom\n";
	print CFGFILE "filemask=.*\n";
	print CFGFILE "tgtftpuser=myyysha\n";
	print CFGFILE "tgtftppwd=567uJHGt\n";
	print CFGFILE "delsource=true\n";
	print CFGFILE "flag=READY\n";
	
	print CFGFILE "\n";
	
	print CFGFILE "[TEST-MYYYSHA]\n";
	print CFGFILE "direction=rem2rem\n";
	print CFGFILE "tgthostname=lexbz2250.cloud.dst.ibm.com\n";
	print CFGFILE "srchostname=lexbz2250.cloud.dst.ibm.com\n";
	print CFGFILE "target=/home/myyysha/SFTPto\n";
	print CFGFILE "source=/home/myyysha/SFTPfrom\n";
	print CFGFILE "filemask=.*\n";
	print CFGFILE "tgtftpuser=myyysha\n";
	print CFGFILE "tgtftppwd=567uJHGt\n";
	print CFGFILE "srcftpuser=myyysha\n";
	print CFGFILE "srcftppwd=567uJHGt\n";
	print CFGFILE "delsource=true\n";
	print CFGFILE "flag=READY\n";
	
	close(CFGFILE);
	
	print "create config file success.\n"
}

sub createSourceFiles{
	
	%processednames=();
	open (CFGFILE,"<",$cfg) or die ("The config file can't be opened!\n");
	
	while (readcfgfile(\*CFGFILE)) {
		
		if (( $direction ne "rem2loc" ) && ( $direction ne "loc2rem" ) && ( $direction ne "rem2rem")) {
			print "Can't create source files for Job[$name]. Invalid value of direction\n";
			next;
		}
	
		if($direction eq "loc2rem") {
			#if there is no file in source folder,create a temp source file
			#else do nothing
			my @SFTPFrom = <$source/*>;
			if(@SFTPFrom){
				print "Find some source files for job $name from source folder $source: \n";
				foreach my $file (@SFTPFrom) {
        			print "File: $file\n";
    			}
    			
    			next;
			}
			
			print "Can't find any source file for job $name from source folder $source, create a temp source file..\n";
	
			open(SOURCE,">",$source."/temp" ) or die ("Can't create source file for job $name. please make sure path = $source exist.");
			print SOURCE "loc2rem sftp transfer test source file.\n";
			close(SOURCE);
			
			print "create $direction source file success.\n";
			
		}elsif($direction eq "rem2loc" || $direction eq "rem2rem"){
			#if there is no file in source folder,create a temp source file
			#else do nothing
			
			my $cnt = 0;
			my @SFTPFrom=();
			
			my $sftp = loginToFTP( $srchostname, $srcftpuser, $srcftppwd );
			if(!defined $sftp){
				print "Can't login FTP:$srchostname for job $name, please check ftp user and password.\n";
				next;
			}
			
			@SFTPFrom = $sftp->ls($source) or die("Can't find source folder:$source for job $name");
			
			foreach my $entry (@SFTPFrom) {
				if ( $entry->{filename} =~ /^\.+$/ ) {
					next;
				}else{
					if ( ++$cnt eq 1 ) {
						print "Find some source files for job $name from source folder $source: \n";
					}
					print "File: ".$entry->{filename}."\n";
				}
			}
			
			if($cnt eq 0){
				print "Can't find any source file for job $name from source folder $source, create a temp source file..\n";
				
				my $localFile = getcwd."/temp";
				unlink($localFile) unless(! -e  $localFile);
				
				open(SOURCE,">",$localFile) or die ( "Can't create a local file");
				print SOURCE "$direction sftp transfer test source file.\n";
				close(SOURCE);
				
				$sftp->put($localFile,$source."/temp") or die ("Can't send file to remote");
			
				print "create $direction source file success.\n";
			}
		}
	}

	close (CFGFILE);
}

sub validateResultAndDelete{
	%processednames=();
	open (CFGFILE,"<",$cfg) or die ("The config file can't be opened!\n");
	while (readcfgfile(\*CFGFILE)) {
		
		if (( $direction ne "rem2loc" ) && ( $direction ne "loc2rem" ) && ( $direction ne "rem2rem")) {
			print "Can't create source files for Job[$name]. Invalid value of direction\n";
			next;
		}
	
		if($direction eq "rem2loc") {
			my @SFTPFrom;
			my @SFTPTo;
			
			my @findFile=();
			my @missFile=();
			
			my $sftp = loginToFTP( $srchostname, $srcftpuser, $srcftppwd );
			@SFTPFrom = $sftp->ls($source) or die("Can't find source folder:$name for job $name");
			
			foreach my $file(@SFTPFrom) {
				if ($file->{filename} =~ /^\.+$/ ) {
					next;
				}else{
					if(-e $target."/".$file->{filename}){
						push @findFile,$target."/".$file->{filename};
						
						unlink($target."/".$file->{filename});#delete file
					}else{
						push @missFile,$target."/".$file->{filename};
					}
				}
			}
			
			if(!@missFile){
				print "\nrem2loc SFTP transfer success. no missing file. \n";
			}else{
				print "\nrem2loc SFTP transfer failed. missing file: \n";
				foreach my $mFile (@missFile){
					print "missing file: $mFile \n";
				}
			}
			
		}elsif($direction eq "loc2rem"){
			my @SFTPFrom;
			my @SFTPTo;
			
			my @findFile=();
			my @missFile=();
			
			opendir(TEMPDIR, $source) or die "can't open local source folder";
			@SFTPFrom = readdir TEMPDIR; 
			close TEMPDIR;
			
			my $tgtftp = loginToFTP( $tgthostname, $tgtftpuser, $tgtftppwd );
			@SFTPTo = $tgtftp->ls($target) or die("Can't find target folder:$name for job $name");
			
			foreach my $sfile(@SFTPFrom){
				if ($sfile =~ /^\.+$/ ) {
					next;
				}else{
					my $flag = 0;
					
					foreach my $tfile(@SFTPTo){
						if($tfile->{filename} eq $sfile){
							push @findFile ,$tfile->{filename};
							$flag = 1;
							$tgtftp->do_rename($target."/".$tfile->{filename}, $target."/".$tfile->{filename}.gmtime());#delete file
							last;
						}
					}
					
					if($flag eq 0){
						push @missFile ,$source."/".$sfile;
					}
				}
			}
			
			if(!@missFile){
				print "\n$direction SFTP transfer success. no missing file. \n";
			}else{
				print "\n$direction SFTP transfer failed. missing file: \n";
				foreach my $mFile (@missFile){
					print "missing file: $mFile \n";
				}
			}
		}elsif($direction eq "rem2rem"){
			my @SFTPFrom;
			my @SFTPTo;
			
			my @findFile=();
			my @missFile=();
			
			my $srcftp = loginToFTP( $srchostname, $srcftpuser, $srcftppwd );
			@SFTPFrom = $srcftp->ls($source) or die("Can't find source folder:$name for job $name");
			
			my $tgtftp = loginToFTP( $tgthostname, $tgtftpuser, $tgtftppwd );
			@SFTPTo = $tgtftp->ls($target) or die("Can't find target folder:$name for job $name");
			
			foreach my $sfile(@SFTPFrom) {
				if ($sfile->{filename} =~ /^\.+$/ ) {
					next;
				}else{
					my $flag = 0;
					foreach my $tfile(@SFTPTo){
						if($tfile->{filename} eq $sfile->{filename}){
							push @findFile ,$tfile->{filename};
							$flag = 1;
							$tgtftp->do_rename($target."/".$tfile->{filename}, $target."/".$tfile->{filename}.gmtime());#delete file
							last;
						}
					}
					
					if($flag eq 0){
						push @missFile ,$sfile->{filename};
						next;
					}
				}
			}
			
			if(!@missFile){
				print "\n$direction SFTP transfer success. no missing file. \n";
			}else{
				print "\n$direction SFTP transfer failed. missing file: \n";
				foreach my $mFile (@missFile){
					print "missing file: $mFile \n";
				}
			}
		}
	}

	close (CFGFILE);
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

sub retparam { # returs the parameter    motaba=12 #comment ----> returns 12
	my $string=shift;
	my $toret;
	
	$string =~ /^[^=]*=([^#]+)/;
	$toret=$1;
	
	$toret =~ s/^\s*//;
	$toret =~ s/\s*$//;
	
	return $toret;
}
