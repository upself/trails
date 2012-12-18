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
use Recon::ReconEngineCustomer;
use Recon::ReconEngineSoftware;

my $logfile    = "/var/staging/logs/reconEngine/reconEngine.log";
my $pidFile    = "/tmp/reconEngine.pid";
my $configFile = "/opt/staging/v2/config/reconEngineConfig.txt";

my $cfgMgr       = Base::ConfigManager->instance($configFile);
my $sleepPeriod  = $cfgMgr->sleepPeriod;
my $server       = $cfgMgr->server;
my $testMode     = $cfgMgr->testMode;
my $applyChanges = $cfgMgr->applyChanges;

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
    unless validateServer($server);

logging_level( $cfgMgr->debugLevel );
logfile($logfile);

my $job                  = 'RECON ENGINE';
my $systemScheduleStatus = startJob($job);

my $maxChildren        = 100;
my %runningCustomerIds = ();
my %children           = ();
my $children;

my $connection = Database::Connection->new('trails');
my @customerIds = getReconCustomerQueue( $connection, $testMode );
my ( $masters, $members ) = getPoolCustomers($connection);
my @softwareIds = getReconSoftwareQueue($connection);
$connection->disconnect;

daemonize();
spawnChildren();
keepTicking();
endJob($systemScheduleStatus);
exit;

sub spawnChildren {
    wlog("Spawning children");
    for ( my $i = 0; $i < $maxChildren; $i++ ) {
        my $customer = shift @customerIds;
        my ( $date, $customerId ) = each %$customer;
        if ( isCustomerRunning($customerId) == 1 ) {
            next;
        }
        elsif ( canProcess( $customerId, $masters, $members ) ) {
            newChild( $customerId, $date, 0 );
        }
        else {
            newChild( $customerId, $date, 1 );
        }
        if ( scalar @customerIds == 0 ) {
            last;
        }
    }
}

sub keepTicking {
    wlog("Keep on ticking");
    my $count = 0;
    while (1) {
        if ( scalar @customerIds == 0 ) {
            newSoftwareChild( shift @softwareIds );
            my $connection = Database::Connection->new('trails');
            @customerIds = getReconCustomerQueue( $connection, $testMode );
            ( $masters, $members ) = getPoolCustomers($connection);
            $connection->disconnect;
        }
        if ( $children >= $maxChildren ) {
            wlog("sleeping");
            sleep;
            wlog("done sleeping");
        }
        for ( my $i = $children; $i < $maxChildren; $i++ ) {
            wlog("running $i");
            my $customer = shift @customerIds;
            my ( $date, $customerId ) = each %$customer;
            if ( isCustomerRunning($customerId) == 1 ) {
                next;
            }
            elsif ( canProcess( $customerId, $masters, $members ) ) {
                newChild( $customerId, $date, 0 );
            }
            else {
                newChild( $customerId, $date, 1 );
            }
            if ( scalar @customerIds == 0 ) {
                last;
            }
        }
    }
}

sub isCustomerRunning {
    my $customerId = shift;
    my $result     = 0;
    if ( exists $runningCustomerIds{$customerId} ) {
        wlog("$customerId already running, skipping");
        $result = 1;
    }
    return $result;
}

sub canProcess {
    my ( $customerId, $masters, $members ) = @_;
    my $result = 1;

    return 0 if !defined $customerId;

    foreach my $memberId ( keys %{ $masters->{$customerId} } ) {
        next if $customerId == $memberId;
        if ( exists $runningCustomerIds{$memberId} ) {
            $result = 0;
        }
        if ( exists $members->{$memberId} ) {
            foreach my $masterId ( keys %{ $members->{$memberId} } ) {
                next if $customerId == $masterId;
                if ( exists $runningCustomerIds{$masterId} ) {
                    $result = 0;
                }
            }
        }
    }
    foreach my $masterId ( keys %{ $members->{$customerId} } ) {
        next if $customerId == $masterId;
        if ( exists $runningCustomerIds{$masterId} ) {
            $result = 0;
        }
        if ( exists $masters->{$masterId} ) {
            foreach my $memberId ( keys %{ $masters->{$masterId} } ) {
                next if $customerId == $memberId;
                if ( exists $runningCustomerIds{$memberId} ) {
                    $result = 0;
                }
            }
        }
    }

    return $result;
}

sub newChild {
    my $customerId  = shift;
    my $date        = shift;
    my $poolRunning = shift;
    my $pid;

    wlog("spawning $customerId, $date, $poolRunning");
    my $sigset = POSIX::SigSet->new(SIGINT);
    sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
    die "Cannot fork child: $!\n" unless defined( $pid = fork );
    if ($pid) {
        $children{$pid} = 1;
        $children++;
        $runningCustomerIds{$customerId} = $pid;
        ilog("forked new child, we now have $children children");
        return;
    }

    if ( scalar @customerIds == 0 ) {
        wlog("sleeping 5");
        sleep 300;
        wlog("done sleeping 5");
    }

    my $reconEngine = new Recon::ReconEngineCustomer( $customerId, $date, $poolRunning );
    $reconEngine->recon;

    sleep 300;

    wlog("Child $customerId, $date, $poolRunning complete");
    exit;
}

sub newSoftwareChild {
    my $softwareId = shift;
    my $pid;

    wlog("spawning software: $softwareId");
    my $sigset = POSIX::SigSet->new(SIGINT);
    sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
    die "Cannot fork child: $!\n" unless defined( $pid = fork );
    if ($pid) {
        $children{$pid} = 1;
        $children++;
        ilog("forked new child, we now have $children children");
        return;
    }

    my $reconEngine = new Recon::ReconEngineSoftware($softwareId);
    $reconEngine->recon;

    wlog("Child software: $softwareId complete");
    exit;
}

sub REAPER {
    my $stiff;
    while ( ( $stiff = waitpid( -1, &WNOHANG ) ) > 0 ) {
        warn("child $stiff terminated -- status $?");
        $children--;
        foreach my $customerId ( keys %runningCustomerIds ) {
            if ( $stiff == $runningCustomerIds{$customerId} ) {
                delete $runningCustomerIds{$customerId};
            }
        }
    }
    $SIG{CHLD} = \&REAPER;
}

sub daemonize {
    my $pid = fork;
    defined($pid) or die "Cannot start daemon: $!";
    print "Parent daemon running.\n" if $pid;
    exit if $pid;

    POSIX::setsid();
    loaderStart( shift @ARGV, $pidFile );

    close(STDOUT);
    close(STDIN);
    close(STDERR);

    $SIG{__WARN__} = sub {
        ilog( "NOTE! " . join( " ", @_ ) );
    };

    $SIG{__DIE__} = sub {
        elog( "FATAL! " . join( " ", @_ ) );
        exit;
    };

    $SIG{HUP} = $SIG{INT} = $SIG{TERM} = sub {
        my $sig = shift;
        $SIG{$sig} = 'IGNORE';
        kill 'INT' => keys %children;
        die "killed by $sig\n";
        exit;
    };

    $SIG{CHLD} = \&REAPER;
}

sub startJob {
    my $job = shift;
    return SystemScheduleStatusDelegate->start($job);
}

sub endJob {
    my $systemScheduleStatus = shift;
    SystemScheduleStatusDelegate->stop($systemScheduleStatus);
}

sub getPoolCustomers {
    my ($connection) = @_;

    ###Get customer ids from bravo to process.
    my $masterId;
    my $memberId;
    my %masters;
    my %members;
    $connection->prepareSqlQuery( queryMasterPoolCustomers() );
    my $sth = $connection->sql->{masterPoolCustomers};
    $sth->bind_columns( \$masterId, \$memberId );
    $sth->execute();

    while ( $sth->fetchrow_arrayref ) {
        $masters{$masterId}{$memberId}++;
        $members{$memberId}{$masterId}++;
    }
    $sth->finish;

    return ( \%masters, \%members );
}

sub queryMasterPoolCustomers {
    my $query = '
    select
        a.master_account_id
       ,a.member_account_id
    from
        account_pool a
    where
        a.LOGICAL_DELETE_IND = 0
    with ur
    ';
    return ( 'masterPoolCustomers', $query );
}

sub getReconCustomerQueue {
    my ( $connection, $testMode ) = @_;

    my $id;
    my $recordTime;
    my @customers;
    $connection->prepareSqlQuery( queryDistinctCustomerIdsFromQueueFifo($testMode) );
    my $sth = $connection->sql->{distinctCustomerIdsFromQueueFifo};
    $sth->bind_columns( \$id, \$recordTime );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        my %data;
        $data{$recordTime} = $id;
        push @customers, \%data;
    }
    $sth->finish;

    dlog("end getDistinctCustomerIdsFromQueueFifo");

    return @customers;
}

sub getReconSoftwareQueue {
    my ( $connection, $testMode ) = @_;

    my $id;
    my $recordTime;
    my @softwares;
    $connection->prepareSqlQuery( querySoftwareIdsFromQueueFifo() );
    my $sth = $connection->sql->{softwareIdsFromQueueFifo};
    $sth->bind_columns( \$id );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        push @softwares, $id;
    }
    $sth->finish;

    dlog("end getSoftwareIdsFromQueueFifo");

    return @softwares;
}

sub querySoftwareIdsFromQueueFifo {
    my $query = '
        select
            a.software_id
        from
            recon_software a
        group by
            a.software_id
        with ur
    ';
    return ( 'softwareIdsFromQueueFifo', $query );
}

sub queryDistinctCustomerIdsFromQueueFifo {
    my $testMode = shift;

    my $query = '
        select
            a.customer_id
            ,date(a.record_time)
        from
            v_recon_queue a
    ';
    if ( $testMode == 1 ) {
        $query .= '
        where a.customer_id in ('
            . $cfgMgr->testCustomerIdsAsString() . ')';
    }
    $query .= '
                group by
                    a.customer_id
                    ,date(a.record_time)
                order by date(a.record_time)
                with ur
    ';
    return ( 'distinctCustomerIdsFromQueueFifo', $query );
}

sub getMinCustomerDate {
    my ( $customerId, $connection ) = @_;
    ilog("Getting min date for customer $customerId");
    my $date;
    ilog("Preparing query");
    $connection->prepareSqlQuery( queryMinCustomerDate() );
    ilog("Min date query prepared");
    ilog("Getting statement handle");
    my $sth = $connection->sql->{minCustomerDate};
    ilog("Statement handle acquired");
    ilog("Binding columns");
    $sth->bind_columns( \$date );
    ilog("Columns binded");
    ilog("Executing query");
    $sth->execute($customerId);
    ilog("Query executed");
    ilog("fetch results");
    $sth->fetchrow_arrayref;
    ilog("results fetched");
    $sth->finish;
    return $date;
}

sub queryMinCustomerDate {
    my $query = '
        select
            min(date(a.record_time))
        from
            v_recon_queue a
        where
            a.customer_id = ?
        for fetch only with ur
    ';
    return ( 'minCustomerDate', $query );
}
