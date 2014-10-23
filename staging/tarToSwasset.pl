#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use Base::Utils;
use SWASSET::TARLoader;
use Base::ConfigManager;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/tarToSwasset/tarToSwasset.log";
my $pidFile    = "/tmp/tarToSwasset.pid";
my $configFile = "/opt/staging/v2/config/tarToSwassetConfig.txt";

###Initialize properties
my $cfgMgr       = Base::ConfigManager->instance($configFile);
my $sleepPeriod  = $cfgMgr->sleepPeriod;
my $server       = $cfgMgr->server;
my $applyChanges = $cfgMgr->applyChanges;

my $DEPOT           = '/var/ftp/scan';
my $completeDir     = "$DEPOT/inv_complete";
my $workDir         = "$DEPOT/inv_work";
my $errorDir        = "$DEPOT/inv_error";
my $unregisteredDir = "$DEPOT/inv_unregistered";
my $garbageDir      = "$DEPOT/inv_garbage";
my $logDir          = "$DEPOT/inv_logs";

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
    unless validateServer($server);

###Make a daemon.
chdir "/tmp";
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
        
        ###Grab the files
        my @files = getTarFiles($DEPOT);

        ###Execute load(s).
        $loader = SWASSET::TARLoader->new(
            $applyChanges, $DEPOT, $completeDir, $workDir, $errorDir,
            $unregisteredDir, $garbageDir, $logDir    
        );
        $loader->load;

        ###Check if we should stop.
        last if loaderCheckForStop($pidFile) == 1;
        sleep $sleepPeriod;
    }
};
if ($@) {
    elog($@);
    die $@;
}

sub getTarFiles {
    my $dir = shift;
    
    my @files;
    
    opendir(TAR, $dir) || die("Cannot open tar directory!");
    while ( defined (my $file = readdir TAR) ) {
        
        next if $file =~ /^\.\.?$/;
        next if $file =~ /^inv_/;
        
        unless ( $file =~ /\.tar$/i ) {
            $self->moveFileToGarbage($file);
            next;
        }
        
        my $origFile = $file;
        $file = uc($file); 
        $file =~ s/\.TAR$/\.tar/;
        
        push @files, $file;
    }
    closedir(TAR);

    $self->tarFiles(\%files);
}

exit 0;
