#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use Base::Utils;
use Base::ConfigManager;
use BRAVO::ContactLoader;
use BRAVO::GeographyLoader;
use BRAVO::RegionLoader;
use BRAVO::CountryCodeLoader;
use BRAVO::PodLoader;
use BRAVO::SectorLoader;
use BRAVO::IndustryLoader;
use BRAVO::CustomerTypeLoader;
use BRAVO::CustomerLoader;
use BRAVO::OutsourceProfileLoader;
use BRAVO::MajorLoader;
use BRAVO::LpidLoader;    
use BRAVO::AccountPoolLoader;
use BRAVO::CustomerNumberLoader;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/cndbReplication/cndbReplication.log";
my $pidFile    = "/tmp/cndbReplication.pid";
my $configFile = "/opt/staging/v2/config/cndbReplicationConfig.txt";

###Initialize properties
my $cfgMgr              = Base::ConfigManager->instance($configFile);
my $sleepPeriod         = 3600;
my $server              = $cfgMgr->server;
my $testMode            = $cfgMgr->testMode;
my $loadDeltaOnly       = $cfgMgr->loadDeltaOnly;
my $applyChanges        = $cfgMgr->applyChanges;
my $fullLoadPeriodHours = 1;

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

###Wrap everything in an eval so we can capture in logfile.
eval {
    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    $| = 1;
    my $loader;
    while (1) {

        ###Execute load(s).
#        $loader = new BRAVO::ContactLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::GeographyLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::RegionLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::CountryCodeLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::PodLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::SectorLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::IndustryLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::CustomerTypeLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::CustomerLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::OutsourceProfileLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::AccountPoolLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::MajorLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );
#
#        $loader = new BRAVO::LpidLoader();
#        $loader->load( TestMode            => $testMode,
#                       LoadDeltaOnly       => $loadDeltaOnly,
#                       ApplyChanges        => $applyChanges,
#                       FullLoadPeriodHours => $fullLoadPeriodHours
#        );

        $loader = new BRAVO::CustomerNumberLoader();
        $loader->load( TestMode            => $testMode,
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
}

exit 0;
