#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use File::Basename;
use Base::Utils;
use Sigbank::Delegate::BankAccountDelegate;
use Base::ConfigManager;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/ipAddressToStaging/ipAddressToStaging.log";
my $pidFile    = "/tmp/ipAddressToStaging.pid";
my $configFile = "/opt/staging/v2/config/ipAddressToStagingConfig.txt";

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

###Setup for forking children.
my $maxChildren = 2;
my %children    = ();
my $children    = 0;
my $sleepTime   = 5;
my $childScript = ( dirname $0) . "/" . ( split( /\./, ( basename $0) ) )[0] . "Child.pl";

###Signal handler for dead children
sub REAPER {
    $SIG{CHLD} = \&REAPER;
    while ( ( my $pid = waitpid( -1, &WNOHANG ) ) > 0 ) {
        if ( exists( $children{$pid} ) ) {
            dlog("removing child");
            $children--;
            delete $children{$pid};
        }
        else {
            wlog("i should not hit this in the reaper sub");
        }
    }
}
$SIG{CHLD} = \&REAPER;

###Wrap everything in an eval so we can capture in logfile.
eval {
    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    $| = 1;

    while (1) {

        my @bankAccounts;
        eval {
            ###Get the current software lpar batches to process.
            @bankAccounts = Sigbank::Delegate::BankAccountDelegate->getBankAccounts;
        };
        if ($@) {
            die $@;
        }

        foreach my $name (@bankAccounts) {
            ilog("name=$name");

            
            next if $name eq 'TLCMZ';
            next if $name eq 'SWDISCRP';
            next if $name eq 'DORANA';

            if ( $testMode == 1 ) {
                next
                  unless ( exists( $cfgMgr->testBankAccountsAsHash->{$name} ) );
            }

            ###Spawn child unless maxed out.
            while ( $children >= $maxChildren ) {
                ilog("sleeping");
                sleep $sleepTime;
            }

            my $childLog = $logfile . "." . $name;
            spawnScript( $name, $childLog );
        }

        ###Wait till  all children die.
        while ( $children != 0 ) {
            sleep 5;
        }

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

sub spawnScript {
    my $name     = shift;
    my $childLog = shift;
    my $pid;

    unless ( defined( $pid = fork ) ) {
        elog("ERROR: unable to fork child process!");
        exit 1;
    }

    if ($pid) {
        ###I am the parent
        $children{$pid}{'log'} = 1;
        $children++;
        return;
    }
    else {
        ###I am the child, i *CANNOT* return only exit
        my $cmd =
            "$childScript -b $name -f $fullLoadPeriodHours"
          . " -t $testMode -d $loadDeltaOnly -a $applyChanges -l $childLog -c $configFile";
        ilog("spawning child: $cmd");
        `$cmd >>$childLog 2>&1`;
        ilog("Child complete: $cmd");
        exit 0;
    }
}
