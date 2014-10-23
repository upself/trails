#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use File::Basename;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Base::ConfigManager;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/hardwareToBravo/hardwareToBravo.log";
my $pidFile    = "/tmp/hardwareToBravo.pid";
my $configFile = "/opt/staging/v2/config/hardwareToBravoConfig.txt";

###Initialize properties
my $cfgMgr        = Base::ConfigManager->instance($configFile);
my $sleepPeriod   = $cfgMgr->sleepPeriod;
my $server        = $cfgMgr->server;
my $testMode      = $cfgMgr->testMode;
my $loadDeltaOnly = $cfgMgr->loadDeltaOnly;
my $applyChanges  = $cfgMgr->applyChanges;

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
my $maxChildren = 5;
my %children    = ();
my $children    = 0;
my $sleepTime   = 60;
my $childScript = ( dirname $0) . "/" . ( split( /\./, ( basename $0) ) )[0] . "Child.pl";

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
my $job;
if ( $loadDeltaOnly == 1 ) {
    $job = 'STAGING TO BRAVO - HW (DELTA)';
}
else {
    $job = 'STAGING TO BRAVO - HW (FULL)';
}
dlog("job=$job");
my $systemScheduleStatus;

###Wrap everything in an eval so we can capture in logfile.
eval {
    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    $| = 1;
    my $count = 0;
    while (1) {
        ###Notify system schedule status that we are starting.
        dlog("job=$job");
        if ( $applyChanges == 1 ) {
            ###Notify the scheduler that we are starting
            ilog("starting $job system schedule status");
            $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
            ilog("started $job system schedule status");
        }

        ###Get a connection to staging
        ilog("getting staging db connection");
        my $stagingConnection = Database::Connection->new('staging');
        die "Unable to get staging db connection!\n"
            unless defined $stagingConnection;
        ilog("got staging db connection");

        ###Get batches from staging to process.
        my @customers;
        eval {
            ###Get the current software lpar batches to process.
            @customers =
                getHardwareCustomers( $stagingConnection, $testMode, $loadDeltaOnly,
                                      Base::ConfigManager->instance()->testCustomerIdsAsString() );
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
        foreach my $customerId (@customers) {
            ilog("customerId: $customerId");

            ###Spawn child unless maxed out.
            while ( $children >= $maxChildren ) {

                #ilog("sleeping");
                sleep $sleepTime;
            }

            my $logNum   = shift @logArray;
            my $childLog = $logfile . ".child." . $logNum;
            spawnScript( $customerId, $childLog, $logNum );
            sleep 5;
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
        $count++;
    }
};
if ($@) {
    elog($@);
    die $@;

    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we had an error
        ilog("erroring $job system schedule status");
        SystemScheduleStatusDelegate->error($systemScheduleStatus);
        ilog("errored $job system schedule status");
    }
}
else {

    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we are stopping
        ilog("stopping $job system schedule status");
        SystemScheduleStatusDelegate->stop($systemScheduleStatus);
        ilog("stopped $job system schedule status");
    }
}

exit 0;

sub spawnScript {
    my $customerId  = shift;
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
              "$childScript"
            . " -d $loadDeltaOnly -a $applyChanges "
            . " -i $customerId -l $childLog -c $configFile";
        ilog("spawning child: $cmd");
        `$cmd >>$childLog 2>&1`;
        ilog("child complete: $cmd");
        exit 0;
    }
}

sub getHardwareCustomers {
    my ( $stagingConnection, $testMode, $loadDeltaOnly, $testCustomerString ) = @_;

    my @ids;
    my %rec;

    $stagingConnection->prepareSqlQueryAndFields(
                                        queryHardwareCustomers( $testMode, $loadDeltaOnly, $testCustomerString ) );
    my $sth = $stagingConnection->sql->{hardwareCustomers};
    $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{hardwareCustomersFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        dlog( "Customer ID: " . $rec{id} );
        push @ids, $rec{id};
    }
    $sth->finish;

    return @ids;
}

sub queryHardwareCustomers {
    my($testMode, $loadDeltaOnly, $testCustomerString) = @_;
    my @fields = qw(
        id
    );

    my $query = '
        select
            h.customer_id
        from
            hardware h
            left outer join hardware_lpar hl on
                h.id = hl.hardware_id
            left outer join effective_processor ep on
                ep.hardware_lpar_id = hl.id
    ';

    my $clause = 'where';

    if ( $loadDeltaOnly == 1 ) {
        $query .= ' ' . $clause . ' ((h.action != \'COMPLETE\' and substr(h.action,length(h.action),1) != \'0\' )
                or (hl.action != \'COMPLETE\' and substr(hl.action,length(hl.action),1) != \'0\')
                or (ep.action != \'COMPLETE\' and substr(ep.action,length(ep.action),1) != \'0\' )) ';
        $clause = ' and ';
    }
    if ( $testMode == 1 ) {
        $query .=
              ' ' . $clause
            . ' (h.customer_id in ('
            . Base::ConfigManager->instance()->testCustomerIdsAsString()
            . ') or hl.customer_id in ('
            . Base::ConfigManager->instance()->testCustomerIdsAsString() . '))';
    }
    
    $query .= ' group by h.customer_id order by count(*) desc';

    dlog("queryHardwareCustomers=$query");
    return ( 'hardwareCustomers', $query, \@fields );
}

exit 0;

