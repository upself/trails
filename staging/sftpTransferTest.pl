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
our $name;           # name of this FTP session processed
our $direction;      # remote to local or local to remote
our $srchostname;    # remote hostname of source
our $tgthostname;    # remote hostname of target
our $source;         # source directory
our $target;         # target directory
our $filemask;       # regular expression to match the filename
our $delsource;      # true false whether to keep the original files after successful copy
our $minage;         # minimum age of file, in minutes
our $flag;           # a special file marking the files are ready (is by itself never transferred
our $srcftpuser;     # source FTP user
our $srcftppwd;      # source FTP password
our $tgtftpuser;     # target FTP user
our $tgtftppwd;      # target FTP password

our $flagispresent;  # flag is present

our %processednames; # hash of all the processed FTP sessions

our $logfile = "/var/staging/logs/ftpTransferTest/ftpTransferTest.log";

####################################
##       Usage
####################################
sub Usage {
	print <<EOL;
A tool for test FTP transfer result of files from or to target server
Requires a single parameter, pointing to config file(Same as sftpTransfer tool).
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

##################################
##        MAIN
##################################

logging_level("debug");
logfile($logfile);

Usage() unless ( defined $ARGV[0] );
print "CFGFILE = $ARGV[0] \n";
print "LogFile = $logfile \n";

open( CFGFILE, "<", $ARGV[0] ) or die("The config file can't be opened!\n");

while ( readcfgfile( \*CFGFILE ) ) {
	ilog("============== Working on $name SFTP job ================");

	if ( $direction eq "rem2loc" ) {
		my @local_files;

		if ( $target eq "" ) {
			elog("ERROR: Job $name, no target source with rem2loc direction, invalid!");
			next;
		}

		if ( !-e $target ) {
			ilog("INFO: Job $name, Can't find any file from target source folder. Rem2loc transfer FAILED!");
			next;

		}
		else {
			ilog("INFO: Job $name, Find some files from target source folder. Rem2loc transfer SUCCESS!");

			if ( -d $target ) {

				opendir( TGT, $target ) or die("Can't open target folder");
				@local_files = readdir TGT;

				foreach (@local_files) {
					ilog("INFO: Job $name, Find file or folder: $_!");
				}

				close(TGT);

			}
			else {
				ilog("INFO: Job $name, Find file: $target");
			}

		}

	}
	elsif ( $direction eq "loc2rem" ) {

		my $cnt = 0;
		my @remote_files;

		if ( $target eq "" ) {
			elog("ERROR: Job $name, no target source with Loc2rem direction, invalid!");
			next;
		}

		my $tgtftp = loginToFTP( $tgthostname, $tgtftpuser, $tgtftppwd );
		next unless defined $tgtftp;    # login failed

		@remote_files = $tgtftp->ls($target) or die("Can't find target folder");

		foreach my $entry (@remote_files) {

			if ( !$entry->{filename} =~ /^\.+$/ ) {
				if ( $cnt++ eq 1 ) {
					ilog("INFO: Job $name, Find some files from target source folder. Loc2rem transfer SUCCESS!");
				}
				ilog( "INFO: Job $name, Find file or folder: " . $entry->{filename} . "!" );
			}
		}

		if ( $cnt eq 0 ) {
			ilog("INFO: Job $name, Can't find any file from target source folder. Loc2rem transfer FAILED!");
		}

	}
	elsif ( $direction eq "rem2rem" ) {
		my $cnt = 0;
		my @remote_files;

		if ( $target eq "" ) {
			elog("ERROR: Job $name, no target source with Rem2rem direction, invalid!");
			next;
		}

		my $tgtftp = loginToFTP( $tgthostname, $tgtftpuser, $tgtftppwd );
		next unless defined $tgtftp;    # login failed

		@remote_files = $tgtftp->ls($target)
		  or die("Can't find target folder: $target ON $tgthostname");

		foreach my $entry (@remote_files) {
			if ( !$entry->{filename} =~ /^\.+$/ ) {
				if ( $cnt++ eq 1 ) {
					ilog("INFO: Job $name, Find some files from target source folder. Rem2rem transfer SUCCESS!");
				}
				ilog( "INFO: Job $name, Find file or folder: " . $entry->{filename} . "!" );
			}
		}

		if ( $cnt eq 0 ) {
			ilog("INFO: Job $name, Can't find any file from target source folder. Rem2rem transfer FAILED!");
		}

	}
	else {
		elog("ERROR: Invalid value of direction, not rem2loc, loc2rem or rem2rem, skipping $name!");
		next;
	}
}

close(CFGFILE);

dlog("Exiting normally.");

####################################
##       Subs
####################################
sub readcfgfile {    # reads from config file
	my $fh = shift;

	while ( my $line = (<$fh>) ) {
		if ( $line =~ /^\[/ ) {    # init
			$line =~ /^\[([^\]]+)]/;
			$name          = $1;
			$direction     = "";
			$srchostname   = "";
			$tgthostname   = "";
			$source        = "";
			$target        = "";
			$srcftpuser    = "";
			$srcftppwd     = "";
			$tgtftpuser    = "";
			$tgtftppwd     = "";
			$filemask      = "";
			$delsource     = "true";
			$flag          = "";
			$minage        = 0;
			$flagispresent = 0;        # bool whether the flagfile has been present
		}
		$direction   = lc( retparam($line) ) if ( $line =~ /^direction/i );
		$srchostname = retparam($line)       if ( $line =~ /^srchostname/i );
		$tgthostname = retparam($line)       if ( $line =~ /^tgthostname/i );
		$source      = retparam($line)       if ( $line =~ /^source/i );
		$target      = retparam($line)       if ( $line =~ /^target/i );
		$srcftpuser  = retparam($line)       if ( $line =~ /^srcftpuser/i );
		$srcftppwd   = retparam($line)       if ( $line =~ /^srcftppwd/i );
		$tgtftpuser  = retparam($line)       if ( $line =~ /^tgtftpuser/i );
		$tgtftppwd   = retparam($line)       if ( $line =~ /^tgtftppwd/i );
		$filemask    = retparam($line)       if ( $line =~ /^filemask/i );
		$delsource   = lc( retparam($line) ) if ( $line =~ /^delsource/i );
		$flag        = retparam($line)       if ( $line =~ /^flag/i );
		$minage      = retparam($line)       if ( $line =~ /^minage/i );

		if ( $line =~ /^\s*$/ ) {    # blank line, this is our point of complete reading of one session
			if (   ( ( $srchostname ne "" ) || ( $tgthostname ne "" ) )
				&& ( $direction ne "" )
				&& ( $source    ne "" )
				&& ( $target    ne "" )
				&& ( $filemask  ne "" ) )
			{
				next if exists( $processednames{$name} );
				$processednames{$name} = 1;

				dlog(
					"Found job: name=$name, direction=$direction, srchostname=$srchostname, tgthostname=$tgthostname, source=$source, target=$target, filemask=$filemask"
				);

				return 1;
			}
		}
	}

	if (   ( ( $srchostname ne "" ) || ( $tgthostname ne "" ) )
		&& ( $direction ne "" )
		&& ( $source    ne "" )
		&& ( $target    ne "" )
		&& ( $filemask  ne "" ) )
	{
		return 0 if exists( $processednames{$name} );
		$processednames{$name} = 1;

		dlog(
			"Found job: name=$name, direction=$direction, srchostname=$srchostname, tgthostname=$tgthostname, source=$source, target=$target, filemask=$filemask"
		);

		return 1;
	}

	return 0;
}

sub retparam {    # returs the parameter    motaba=12 #comment ----> returns 12
	my $string = shift;
	my $toret;

	$string =~ /^[^=]*=([^#]+)/;
	$toret = $1;

	$toret =~ s/^\s*//;
	$toret =~ s/\s*$//;

	return $toret;
}

sub loginToFTP {
	my $hostname = shift;
	my $ftplogin = shift;
	my $ftppwd   = shift;

	my $sftp;

	$ftplogin = "" unless ( defined $ftplogin );
	$ftppwd   = "" unless ( defined $ftppwd );

	if ( ( $ftplogin ne "" ) && ( $ftppwd ne "" ) ) {
		unless ( $sftp = Net::SFTP->new( $hostname, user => $ftplogin, password => $ftppwd ) ) {
			wlog "WARNING: Job $name, can't connect/login to $hostname: " . $@;
			return undef;
		}
	}
	else {
		unless ( $sftp = Net::SFTP->new($hostname) ) {
			wlog "WARNING: Job $name, can't connect loginless to $hostname: " . $@;
			return undef;
		}
	}

	return $sftp;
}
