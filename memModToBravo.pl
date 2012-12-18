#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use File::Basename;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Staging::Delegate::StagingDelegate;
use Base::ConfigManager;
use Tap::NewPerl; 

###Globals
my $maxLparsInQuery = 1000;
my $logfile         = "/var/staging/logs/memModToBravo/memModToBravo.log";
my $pidFile         = "/tmp/memModToBravo.pid";
my $configFile      = "/opt/staging/v2/config/memModToBravoConfig.txt";

###Initialize properties
my $cfgMgr =  Base::ConfigManager->instance($configFile);
my $sleepPeriod         = $cfgMgr->sleepPeriod;
my $server              = $cfgMgr->server;
my $testMode            = $cfgMgr->testMode;
my $loadDeltaOnly       = $cfgMgr->loadDeltaOnly;
my $applyChanges        = $cfgMgr->applyChanges;
my $fullLoadPeriodHours = $cfgMgr->bravoFullLoadPeriodHours;

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
  unless validateServer($server);

###Make a daemon.
umask 0;
defined( my $pid = fork )
  or die "ERROR: Unable to fork: $!";
exit if $pid;
setsid or die "ERROR: Unable to setsid: $!";

####Handle usage and user action.
loaderStart( shift @ARGV, $pidFile );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

###Set the logging level
logging_level($cfgMgr->debugLevel);

###Set the logfile
logfile($logfile);

###Setup for forking children.
my $maxChildren = 1;
my %children    = ();
my $children    = 0;
my $sleepTime   = 60;
my $childScript =
  ( dirname $0) . "/" . ( split( /\./, ( basename $0) ) )[0] . "Child.pl";

###Setup logArray
my @logArray = ();
for my $i ( 1 .. $maxChildren ) {
	push @logArray, $i;
}

###Signal handler for dead children
sub REAPER {
	$SIG{CHLD} = \&REAPER;
	while ( ( my $pid = waitpid( -1, &WNOHANG ) ) > 0 ) {
		if ( exists( $children{$pid} ) ) {
			$children--;
			push @logArray, $children{$pid}{'log'};
			delete $children{$pid};
		}
		else {
			wlog("i should not hit this in the reaper sub");
		}
	}
}
$SIG{CHLD} = \&REAPER;

###Set the job name of this script to update the status
my $job = 'MEMMOD STAGING TO BRAVO';
my $job1;
my $systemScheduleStatus;

###Wrap everything in an eval so we can capture in logfile.
eval {
	###Execute loader once, and then continue to execute
	###based on existance of pid file.
	$| = 1;
	while (1) {
        
        ###Check to see if we need full load or delta load
        $loadDeltaOnly = 1;
        if ( SystemScheduleStatusDelegate->isFullLoad( "$job (FULL)", $fullLoadPeriodHours ) == 0 ) {
            dlog('This is a delta load');
            $job1 = "$job (DELTA)";
        }
        else {
            dlog('This is a full load');
            $loadDeltaOnly = 0;
            $job1 = "$job (FULL)";
        }

		###Notify system schedule status that we are starting.
		dlog("job=$job1");
		if ( $applyChanges == 1 ) {
			###Notify the scheduler that we are starting
			ilog("starting $job1 system schedule status");
			$systemScheduleStatus = SystemScheduleStatusDelegate->start($job1);
			ilog("started $job1 system schedule status");
		}

		###Get a connection to staging
		ilog("getting staging db connection");
		my $stagingConnection = Database::Connection->new('staging');
		die "Unable to get staging db connection!\n"
		  unless defined $stagingConnection;
		ilog("got staging db connection");

		###Get batches from staging to process.
		my @batches;
		eval {
			###Get the current software lpar batches to process.
			@batches = Staging::Delegate::StagingDelegate->getScanRecordMemModBatches(
				$stagingConnection, $testMode,
				$loadDeltaOnly,     $maxLparsInQuery
			);
		};
		if ($@) {
			###Close the staging db connection
			ilog("disconnecting staging db connection");
			$stagingConnection->disconnect;
			ilog("disconnected staging db connection");
			die $@;
		}

		###Close the staging db connection
		ilog("disconnecting staging db connection");
		$stagingConnection->disconnect;
		ilog("disconnected staging db connection");

		###Process each batch with max children forks.
		foreach my $batch (@batches) {
			my $firstId = ( split( /\,/, $batch ) )[0];
			my $lastId  = ( split( /\,/, $batch ) )[1];
			ilog("batch: firstId=$firstId, lastId=$lastId");

			###Spawn child unless maxed out.
			while ( $children >= $maxChildren ) {

				#ilog("sleeping");
				sleep $sleepTime;
			}

			my $logNum   = shift @logArray;
			my $childLog = $logfile . ".child." . $logNum;
			spawnScript( $firstId, $lastId, $childLog, $logNum );
		}
		ilog("completed looping over batches");

		###Wait till  all children die.
		while ( $children != 0 ) {
			ilog("waiting for children to stop, count: $children");
			sleep 5;
		}
		ilog("all children are dead");

		###Check if we should stop.
		if ( loaderCheckForStop($pidFile) == 1 ) {
			ilog("stopping daemon");
			last;
		}
		sleep $sleepPeriod;
	}
};
if ($@) {
	elog($@);
	die $@;

	if ( $applyChanges == 1 ) {

		###Notify the scheduler that we had an error
		ilog("erroring $job1 system schedule status");
		SystemScheduleStatusDelegate->error($systemScheduleStatus);
		ilog("errored $job1 system schedule status");
	}
}
else {

	if ( $applyChanges == 1 ) {

		###Notify the scheduler that we are stopping
		ilog("stopping $job1 system schedule status");
		SystemScheduleStatusDelegate->stop($systemScheduleStatus);
		ilog("stopped $job1 system schedule status");
	}
}

exit 0;

sub spawnScript {
	my $firstId  = shift;
	my $lastId   = shift;
	my $childLog = shift;
	my $logNum   = shift;
	my $pid;

	unless ( defined( $pid = fork ) ) {
		elog("ERROR: unable to fork child process!");
		exit 1;
	}

	if ($pid) {
		###I am the parent
		$children{$pid}{'log'} = $logNum;
		$children++;
		return;
	}
	else {
		###I am the child, i *CANNOT* return only exit
		my $cmd =
		    "perl $childScript"
		  . " -t $testMode -d $loadDeltaOnly -a $applyChanges -m $maxLparsInQuery"
		  . " -b $firstId -e $lastId -l $childLog -c $configFile";
		ilog("spawning child: $cmd");
		`$cmd >>$childLog 2>&1`;
		ilog("child complete: $cmd");
		exit 0;
	}
}

