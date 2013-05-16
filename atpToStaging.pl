#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use Base::Utils;
use Staging::ATPLoader;    
use Base::ConfigManager;
use Tap::NewPerl;
use HealthCheck::Delegate::EventLoaderDelegate;#Added by Larry for HealthCheck And Monitor Module - Phase 2B

###Globals
my $logfile    = "/var/staging/logs/atpToStaging/atpToStaging.log";
my $pidFile    = "/tmp/atpToStaging.pid";
my $configFile = "/opt/staging/v2/config/atpToStagingConfig.txt";

###Initialize properties
my $cfgMgr              = Base::ConfigManager->instance($configFile);
my $sleepPeriod         = $cfgMgr->sleepPeriod;
my $server              = $cfgMgr->server;
my $testMode            = $cfgMgr->testMode;
my $loadDeltaOnly       = $cfgMgr->loadDeltaOnly;
my $applyChanges        = $cfgMgr->applyChanges;
my $fullLoadPeriodHours = $cfgMgr->fullLoadPeriodHours;

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
logging_level( $cfgMgr->debugLevel );

###Set the logfile
logfile($logfile);

my $eventTypeName = 'ATPTOSTAGING_START_STOP_SCRIPT';#Added by Larry for HealthCheck And Monitor Module - Phase 2B
my $eventObject;#Added by Larry for HealthCheck And Monitor Module - Phase 2B

###Wrap everything in an eval so we can capture in logfile.
eval {
    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    $| = 1;
    my $loader;

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	###Notify Event Engine that we are starting.
    dlog("eventTypeName=$eventTypeName");
    ilog("starting $eventTypeName event status");
    $eventObject = EventLoaderDelegate->start($eventTypeName);
    ilog("started $eventTypeName event status");
    #Added by Larry for HealthCheck And Monitor Module - Phase 2B End 

    while (1) {

        ###Execute load(s).
        $loader = new Staging::ATPLoader();
        $loader->load(
                       TestMode            => $testMode,
                       LoadDeltaOnly       => $loadDeltaOnly,
                       ApplyChanges        => $applyChanges,
                       FullLoadPeriodHours => $fullLoadPeriodHours
        );

        ###Check if we should stop.
        last if loaderCheckForStop($pidFile) == 1;
        sleep $sleepPeriod;
    }
};
if ($@) {
    elog($@);
    die $@;

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	###Notify the Event Engine that we had an error
    ilog("erroring $eventTypeName event status");
	EventLoaderDelegate->error($eventObject,$eventTypeName);
    ilog("errored $eventTypeName event status");
	#Added by Larry for HealthCheck And Monitor Module - Phase 2B End 
}
else {

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
    ###Notify the Event Engine that we are stopping
    ilog("stopping $eventTypeName event status");
	EventLoaderDelegate->stop($eventObject,$eventTypeName);
    ilog("stopped $eventTypeName event status");
	#Added by Larry for HealthCheck And Monitor Module - Phase 2B End
}

exit 0;
