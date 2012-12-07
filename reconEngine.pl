#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use File::Basename;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Database::Connection;
use Base::ConfigManager;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/reconEngine/reconEngine.log";
my $pidFile    = "/tmp/reconEngine.pid";
my $configFile = "/opt/staging/v2/config/reconEngineConfig.txt";

###Initialize properties
my $cfgMgr             = Base::ConfigManager->instance($configFile);
my $sleepPeriod        = $cfgMgr->sleepPeriod;
my $server             = $cfgMgr->server;
my $testMode           = $cfgMgr->testMode;
my $applyChanges       = $cfgMgr->applyChanges;
my $reconSoftwareHours = 12;

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
my $maxChildren         = 50;
my %children            = ();
my $children            = 0;
my $sleepTime           = 10;
my $customerChildScript = ( dirname $0) . "/"
    . ( split( /\./, ( basename $0) ) )[0]
    . "CustomerChild.pl";
my $softwareChildScript = ( dirname $0) . "/"
    . ( split( /\./, ( basename $0) ) )[0]
    . "SoftwareChild.pl";
my $pvuChildScript = ( dirname $0) . "/"
    . ( split( /\./, ( basename $0) ) )[0]
    . "PvuChild.pl";

###Setup logArray
my @logArray = ();
for my $i ( 1 .. $maxChildren ) {
    push @logArray, $i;
}

###Setup runningCustomerIds
my %runningCustomerIds = ();

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
my $job = 'RECON ENGINE';
dlog("job=$job");
my $systemScheduleStatus;

###Wrap everything in an eval so we can capture in logfile.
eval {
    $| = 1;

    ###Notify system schedule status that we are starting.
    dlog("job=$job");
    if ( $applyChanges == 1 ) {
        ###Notify the scheduler that we are starting
        ilog("starting $job system schedule status");
        $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
        ilog("started $job system schedule status");
    }

    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    while (1) {

#        my $timeoutTime = time() + (60);
#        dlog( "timeoutTime=" . $timeoutTime );

        ###
        ###Customer based recon
        ###

#        my $now = time();
#        dlog( "now=" . $now );

#        while ( $now < $timeoutTime ) {

#            $now = time();

            ###Get recon customer queue snapshot.
            my @customerIds = getReconCustomerQueue();
            dlog( "customerIds count=" . scalar @customerIds );

            ###Cleanup hash.
#            foreach my $customerId ( keys %runningCustomerIds ) {
#                if ( !exists $children{ $runningCustomerIds{$customerId} } ) {
#                    delete $runningCustomerIds{$customerId};
#                    dlog("removed $customerId from running hash");
#                }
#            }
            my %pool = ();
            ###Process each customer id with max children forks.
            while(scalar @customerIds > 0) {
                my $customerId = shift(@customerIds);
                ilog( "customerId=" . $customerId );
                ilog(scalar @customerIds);

            ###Cleanup hash.
            foreach my $cust ( keys %runningCustomerIds ) {
                if ( !exists $children{ $runningCustomerIds{$cust} } ) {
                    delete $runningCustomerIds{$cust};
                    dlog("removed $cust from running hash");
                }
            }


                ###Are any of my members or masters running
                my $poolCustomers;
                if(defined $pool{$customerId}){
                    ilog("pool defined");
                    $poolCustomers = $pool{$customerId};
                }
                else {
                    ilog("pool not defined");
                    $poolCustomers = getPoolCustomers($customerId);
                    $pool{$customerId} = $poolCustomers;
                }

                my $flag = 0;
                foreach my $poolCustomerId ( keys %{$poolCustomers} ) {
                    if ( exists $runningCustomerIds{$poolCustomerId} ) {
                        ilog("Pool customer id running, skipping " . $poolCustomerId);
                        $flag = 1;
                        last;
                    }
                }

                if ( $flag == 1 ) {
                    push(@customerIds,$customerId);
                    next;
                }

                ###Skip if currently running by a child.
                if ( exists $runningCustomerIds{$customerId} ) {
                    dlog("customerId already running, skipping");
                    push(@customerIds,$customerId);
                    next;
                }
                else {
                    dlog("customerId not running");
                }

                ###Spawn customer child unless maxed out.
                dlog("children=$children");
                while ( $children >= $maxChildren ) {
                    ilog("children=$children, sleeping");
                    sleep $sleepTime;
                }

                my $logNum   = shift @logArray;
                my $childLog = $logfile . ".child." . $logNum;
                spawnCustomerChildScript( $customerId, $childLog, $logNum );
            }
            ilog("completed looping over customer ids");

            sleep $sleepPeriod;
        #}
        dlog("customer recons timed out");

        ###Wait till  all children die.
        while ( $children != 0 ) {
            ilog("waiting for children to stop, count: $children");
            sleep 5;
        }
        ilog("all children are dead");

        ###
        ###Software based recon
        ###
        my @softwareIds = getReconSoftwareQueue();

        ###Process each software id with *SINGLE* child.
        foreach my $softwareId (@softwareIds) {
            ilog( "softwareId=" . $softwareId );

            ###Spawn software child *ONE* at a time.
            while ( $children >= 1 ) {

                #ilog("sleeping");
                sleep $sleepTime;
            }

            my $logNum   = shift @logArray;
            my $childLog = $logfile . ".sw." . $logNum;
            spawnSoftwareChildScript( $softwareId, $childLog, $logNum );
        }
        ilog("completed looping over software ids");

        ###Wait till sw child is dead.
        while ( $children != 0 ) {
            ilog("waiting for sw child to stop, count: $children");
            sleep 5;
        }
        ilog("sw child is dead");

        #Lunch the pvu recon child.
        my $logNum   = shift @logArray;
        my $childLog = $logfile . ".pvu." . $logNum;
        spawnPvuChildScript( $childLog, $logNum );

        while ( $children != 0 ) {
            ilog("waiting for sw child to stop, count: $children");
            sleep 5;
        }

        ###Check if we should stop.
        if ( loaderCheckForStop($pidFile) == 1 ) {
            ilog("stopping daemon");
            last;
        }
        sleep $sleepPeriod;
    }
};
if ($@) {
    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we had an error
        ilog("erroring $job system schedule status");
        SystemScheduleStatusDelegate->error( $systemScheduleStatus, $@ );
        ilog("errored $job system schedule status");
    }

    elog($@);
    die $@;
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

sub spawnPvuChildScript {
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
        my $cmd = "$pvuChildScript"
            . " -t $testMode -a $applyChanges "
            . " -l $childLog -f $configFile";
        ilog("spawning pvu child: $cmd");
        `$cmd >>$childLog 2>&1`;
        ilog("child complete: $cmd");
        exit 0;
    }
}

sub spawnCustomerChildScript {
    my $customerId = shift;
    my $childLog   = shift;
    my $logNum     = shift;
    my $pid;

    unless ( defined( $pid = fork ) ) {
        elog("ERROR: unable to fork child process!");
        exit 1;
    }

    if ($pid) {
        ###I am the parent
        dlog("pid=$pid, customerId=$customerId");
        $children{$pid}{'log'} = $logNum;
        $runningCustomerIds{$customerId} = $pid;
        $children++;
        return;
    }
    else {
        ###I am the child, i *CANNOT* return only exit
        my $cmd = "$customerChildScript"
            . " -t $testMode -a $applyChanges -c $customerId"
            . " -l $childLog -f $configFile";
        ilog("spawning customer child: $cmd");
        `$cmd >>$childLog 2>&1`;
        ilog("child complete: $cmd");
        exit 0;
    }
}

sub spawnSoftwareChildScript {
    my $softwareId = shift;
    my $childLog   = shift;
    my $logNum     = shift;
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
        my $cmd = "$softwareChildScript"
            . " -t $testMode -a $applyChanges -s $softwareId"
            . " -l $childLog -f $configFile";
        ilog("spawning software child: $cmd");
        `$cmd >>$childLog 2>&1`;
        ilog("child complete: $cmd");
        exit 0;
    }
}

sub getPoolCustomers {
    my $customerId = shift;

    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    die "Unable to get bravo db connection!\n"
        unless defined $bravoConnection;
    ilog("got bravo db connection");

    ###Get customer ids from bravo to process.
    my %customers;
    eval {
        my $id;
        my $otherId;
        $bravoConnection->prepareSqlQuery( queryMasterPoolCustomers() );
        my $sth = $bravoConnection->sql->{masterPoolCustomers};
        $sth->bind_columns( \$id, \$otherId );
        $sth->execute( $customerId, $customerId );
        while ( $sth->fetchrow_arrayref ) {
            $customers{$id}++;
            $customers{$otherId}++;
        }
        $sth->finish;
    };
    if ($@) {
        ###Close the bravo db connection
        ilog("disconnecting bravo db connection");
        $bravoConnection->disconnect;
        ilog("disconnected bravo db connection");
        die $@;
    }

    ###Close the bravo db connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    return \%customers;
}

sub getReconCustomerQueue {
    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    die "Unable to get bravo db connection!\n"
        unless defined $bravoConnection;
    ilog("got bravo db connection");

    ###Get customer ids from bravo to process.
    my @customerIds;
    eval {
        @customerIds = getDistinctCustomerIdsFromQueueFifo( $bravoConnection,
            $testMode );
    };
    if ($@) {
        ###Close the bravo db connection
        ilog("disconnecting bravo db connection");
        $bravoConnection->disconnect;
        ilog("disconnected bravo db connection");
        die $@;
    }

    ###Close the bravo db connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    return @customerIds;
}

sub getReconSoftwareQueue {
    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    die "Unable to get bravo db connection!\n"
        unless defined $bravoConnection;
    ilog("got bravo db connection");

    ###Get software ids from bravo to process.
    my @softwareIds;
    eval {
        @softwareIds = getDistinctSoftwareIdsFromQueueFifo($bravoConnection);
    };
    if ($@) {
        ###Close the bravo db connection
        ilog("disconnecting bravo db connection");
        $bravoConnection->disconnect;
        ilog("disconnected bravo db connection");
        die $@;
    }

    ###Close the bravo db connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    return @softwareIds;
}

sub getDistinctCustomerIdsFromQueueFifo {
    my ( $connection, $testMode ) = @_;
    dlog("begin getDistinctCustomerIdsFromQueueFifo");

    my @ids    = ();
    my %unique = ();

    my $id;
    $connection->prepareSqlQuery(
        queryDistinctCustomerIdsFromQueueFifo($testMode) );
    my $sth = $connection->sql->{distinctCustomerIdsFromQueueFifo};
    $sth->bind_columns( \$id );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        next if exists $unique{$id};
        push @ids, $id;
        $unique{$id}++;
    }
    $sth->finish;

    dlog("end getDistinctCustomerIdsFromQueueFifo");

    return @ids;
}

sub queryDistinctCustomerIdsFromQueueFifo {
    my $testMode = shift;

    my $query = '
        select
            a.customer_id
        from
            v_recon_queue a
    ';
    if ( $testMode == 1 ) {
        $query .= '
    	where a.customer_id in ('
            . $cfgMgr->testCustomerIdsAsString() . ')';
    }
    $query .= '
		order by
		    case when a.table = \'RECON_LICENSE\' then 0 else 1 end
        	,a.record_time asc
	';
    return ( 'distinctCustomerIdsFromQueueFifo', $query );
}

sub queryMasterPoolCustomers {
    my $query = '
    select
        b.master_account_id
       ,c.member_account_id
    from
        v_recon_queue a
        ,account_pool b
        left outer join account_pool c on
            b.master_account_id = c.master_account_id
            and c.member_account_id != b.member_account_id
    where
        a.customer_id = ?
        and a.customer_id = b.member_account_id
    union
    select
        b.member_account_id
        ,c.master_account_id
    from
        v_recon_queue a
        ,account_pool b
        left outer join account_pool c on
            b.member_account_id = c.member_account_id
            and c.master_account_id != b.master_account_id
    where
        a.customer_id = ?
        and a.customer_id = b.master_account_id
    ';
    return ( 'masterPoolCustomers', $query );
}

sub getDistinctSoftwareIdsFromQueueFifo {
    my ( $connection, $testMode ) = @_;
    dlog("begin getDistinctSoftwareIdsFromQueueFifo");

    my @ids    = ();
    my %unique = ();

    my $id;
    $connection->prepareSqlQuery( queryDistinctSoftwareIdsFromQueueFifo() );
    my $sth = $connection->sql->{distinctSoftwareIdsFromQueueFifo};
    $sth->bind_columns( \$id );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        next if exists $unique{$id};
        push @ids, $id;
        $unique{$id}++;
    }
    $sth->finish;

    dlog("end getDistinctSoftwareIdsFromQueueFifo");

    return @ids;
}

sub queryDistinctSoftwareIdsFromQueueFifo {
    my $query = '
        select
            a.software_id
        from
            recon_software a
		order by
        	a.record_time asc
	';
    return ( 'distinctSoftwareIdsFromQueueFifo', $query );
}
