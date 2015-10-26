#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use Base::Utils;
use Base::ConfigManager;
use Tap::NewPerl;
use Recon::ScarletReconcile;

###Globals
my $logfile    = "/var/staging/logs/Scarlet/scarletProcess.log";
my $pidFile    = "/tmp/scarlet.pid";
my $configFile = "/opt/staging/v2/config/scarletProcessConfig.txt";

###Initialize properties
my $cfgMgr      = Base::ConfigManager->instance($configFile);
my $sleepPeriod = $cfgMgr->sleepPeriod;
my $server      = $cfgMgr->server;
my $gapHour     = $cfgMgr->config->getProperty('validationGapHour');                   

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
  $loader = new Recon::ScarletReconcile($gapHour);
  $loader->validate();

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
