#!/usr/bin/perl -w

use strict;
use Tap::NewPerl;
use POSIX;
use Base::Utils;
use File::Copy;
use File::Basename;
use Base::ConfigManager;
use Database::Connection;

###Globals
my $logfile    = "/var/staging/logs/bravoArchival/bravoArchival.log";
my $pidFile    = "/tmp/bravoArchival.pid";
my $configFile = "/opt/staging/v2/config/bravoArchivalConfig.txt";

###Initialize properties
my $cfgMgr   = Base::ConfigManager->instance($configFile);
my $server   = $cfgMgr->server;
my $testMode = $cfgMgr->testMode;

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
  unless validateServer($server);

###Make a daemon.
umask 0;
defined( my $pid = fork )
  or die "ERROR: Unable to fork: $!";
exit if $pid;
setsid or die "ERROR: Unable to setsid: $!";

##It is not tested, if tested, please remove this line 
die "Not tested, exit !";

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
my $maxChildren = 5;
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

    my @customerIds;
    eval {
        ###Get the current software lpar batches to process.
        @customerIds = getCustomerIds();
    };
    if ($@) {
        die $@;
    }

    foreach my $id ( sort @customerIds ) {
        dlog("id=$id");

        ###Spawn child unless maxed out.
        while ( $children >= $maxChildren ) {
            dlog("sleeping");
            sleep $sleepTime;
        }

        my $childLog = $logfile . "." . $id;
        spawnScript( $id, $childLog );
    }

    ###Wait till  all children die.
    while ( $children != 0 ) {
        sleep 5;
    }
};
if ($@) {
    elog($@);
    die $@;
}

exit 0;

sub spawnScript {
    my $id       = shift;
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
        my $cmd = "$childScript -b $id -l $childLog -c $configFile -t $testMode";    
        dlog("spawning child: $cmd");
        `$cmd >>$childLog 2>&1`;
        dlog("Child complete: $cmd");
        exit 0;
    }
}

sub getCustomerIds {

    ###Hash to return
    my @ids;

    ###Get a cndb connection
    my $connection = Database::Connection->new('trails');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryCustomerIds() );

    my $sth = $connection->sql->{customerIds};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{customerIdsFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        push @ids, $rec{id};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return @ids;
}

sub queryCustomerIds {

    my @fields = (qw(id));
    my $query  = '
        select
            a.customer_id
        from
            customer a
    ';

    return ( 'customerIds', $query, \@fields );
}

