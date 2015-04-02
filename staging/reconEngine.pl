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
use Recon::ReconEnginePvu;

my $logfile    = "/var/staging/logs/reconEngine/reconEngine.log";
my $pidFile    = "/tmp/reconEngine.pid";
my $configFile = "/opt/staging/v2/config/reconEngineConfig.txt";

my $cfgMgr       = Base::ConfigManager->instance($configFile);
my $sleepPeriod  = $cfgMgr->sleepPeriod;
my $server       = $cfgMgr->server;
my $testMode     = $cfgMgr->testMode;
my $connRetryTimes  = $cfgMgr->connRetryTimes;
my $connRetrySleepPeriod = $cfgMgr->connRetrySleepPeriod;
#my $applyChanges = $cfgMgr->applyChanges;

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
    unless validateServer($server);

logging_level( $cfgMgr->debugLevel );
logfile($logfile);

my $job                  = 'RECON ENGINE';
my $systemScheduleStatus = startJob($job);

my $rNo = 'revision233';

my $maxChildren        = 100;
my %runningCustomerIds = ();
my %children           = ();
my $children;

my $connection = Database::Connection->new('trails',$connRetryTimes,$connRetrySleepPeriod);
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
    wlog("$rNo Spawning children");
    for ( my $i = 0; $i < $maxChildren; $i++ ) {
        my $customer = shift @customerIds;
        last if( !defined $customer && scalar @customerIds == 0);
        my ($date, $customerId) = each %$customer;
        if ( isCustomerRunning($customerId) == 1 ) {
            next;
        }
        elsif ( canProcess( $customerId, $masters, $members ) ) {
            newChild( $customerId, $date, 0 );
        }

        if ( scalar @customerIds == 0 ) {
            last;
        }
    }
}

sub keepTicking {
    wlog("$rNo Keep on ticking");
    my $count = 0;
    while (1) {
        if ( scalar @customerIds == 0 ) {
             newSoftwareChild(shift @softwareIds) if ( scalar @softwareIds > 0 );
             newPvuChild();
             my $connection = Database::Connection->new('trails');
             @customerIds = getReconCustomerQueue( $connection, $testMode );
             ( $masters, $members ) = getPoolCustomers($connection);
             $connection->disconnect;
        }
        if ( $children >= $maxChildren ) {
            wlog("$rNo sleeping");
            sleep;
            
            wlog("$rNo before reset array size:". scalar @customerIds);
            my $connection = Database::Connection->new('trails');
            @customerIds = getReconCustomerQueue( $connection, $testMode );
            ( $masters, $members ) = getPoolCustomers($connection);
            $connection->disconnect;
            wlog("$rNo end reset array size:". scalar @customerIds);
            
            wlog("$rNo done sleeping");
        }
        
        
        for ( my $i = $children; $i < $maxChildren; $i++ ) {
            ilog("$rNo running $i");
            my $customer = shift @customerIds;
            last if( !defined $customer && scalar @customerIds == 0);
            my ( $date, $customerId ) = each %$customer;
            if ( isCustomerRunning( $customerId ) == 1 ) {
                next;
            }
            elsif ( canProcess( $customerId, $masters, $members ) ) {
                newChild( $customerId, $date, 0 );
            }else{
               ilog("$rNo ingore pool process for $customerId, $date");
            }

            if ( scalar @customerIds == 0 ) {
                last;
            }
        }
        
        if(scalar @customerIds == 0){
            wlog("$rNo loop of customer array finished will sleep till end of child");
            sleep;
            wlog("$rNo waked up");   
        }    
    }
}

sub isCustomerRunning {
    my $customerId = shift;
    my $result     = 0;
    if ( exists $runningCustomerIds{$customerId} ) {
        ilog("$rNo $customerId already running, skipping");
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

    wlog("$rNo spawning $customerId, $date, $poolRunning");
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
       wlog("$rNo sleeping 5");
       sleep 300;
       wlog("$rNo done sleeping 5");
    }

    my $reconEngine = new Recon::ReconEngineCustomer( $customerId, $date, $poolRunning );
    $reconEngine->recon;

    sleep 30;
    wlog("$rNo Child $customerId, $date, $poolRunning complete");

    exit;
}

sub newSoftwareChild {
    my $softwareId = shift;
    my $pid;

    wlog("$rNo spawning software: $softwareId");
    my $sigset = POSIX::SigSet->new(SIGINT);
    sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
    die "Cannot fork child: $!\n" unless defined( $pid = fork );
    if ($pid) {
        $children{$pid} = 1;
        $children++;
        ilog("forked new child, we now have $children children");
        return;
    }

    my $reconEngine = new Recon::ReconEngineSoftware( $softwareId );
    $reconEngine->recon;

    wlog("$rNo Child software: $softwareId complete");
    
    exit;
}

sub newPvuChild {
    my $pid;

    wlog("$rNo spawning PVU child");
    my $sigset = POSIX::SigSet->new(SIGINT);
    sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
    die "Cannot fork child: $!\n" unless defined( $pid = fork );
    if ($pid) {
        $children{$pid} = 1;
        $children++;
        ilog("forked new child, we now have $children children");
        return;
    }

   	my $pvuEngine = new Recon::ReconEnginePvu;
	$pvuEngine->recon; # spawning one PVU job... the called entity will read the PVU queue by itself and process one record of it, or die if none found
	
	wlog("$rNo PVU child complete");

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
                wlog("$rNo reaped $customerId ");
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
    return SystemScheduleStatusDelegate->start($job,$connRetryTimes,$connRetrySleepPeriod);
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

    my @customers;
    my %customerIdDateHash = ();
    
    my $id;
    my $recordTime;
    wlog("$rNo start building customer id array");
    
    
    for (my $phase=0; $phase<1; $phase++){
     
        my $qName = undef;
        my $query = undef;
        
        if($phase == 0){
           ($qName,$query) = queryPriorityCustomerIds();
        }elsif($phase == 1){
           ($qName,$query) = queryDistinctCustomerIdsFromQueueFifo($testMode);
            
        }
        
        wlog("phase $phase, qname $qName, query $query");
     
        $connection->prepareSqlQuery($qName,$query);
        my $sth = $connection->sql->{$qName};
        $sth->bind_columns( \$id, \$recordTime );
        $sth->execute();
    
        while ( $sth->fetchrow_arrayref ) {
            my $keys  = $id.'|'.$recordTime;
        
            if($customerIdDateHash{$keys}){
             dlog("keys=".$keys."exist ingore");
             next;
            }else{
               my %data;
               $data{$recordTime} = $id;
               push @customers, \%data;
               $customerIdDateHash{$keys} = 1;
            }
        }
        
        $sth->finish;
    }    

    wlog("$rNo end building customer id array");
       
    dlog("array size:".scalar @customers);
    dlog("end getDistinctCustomerIdsFromQueueFifo");

    return @customers;
}


sub queryPriorityCustomerIds{
   my $query = '
      select
            a.customer_id
            ,date(a.record_time)
        from
            v_recon_queue a
        group by
            a.customer_id
            ,date(a.record_time)
        order by date(a.record_time)
        with ur
   ';
   
   
   return ('queryPriorityCustomerIds', $query);
}


sub queryDistinctCustomerIdsFromQueueFifo {
    my $testMode = shift;

    my $query = '
        select
            a.customer_id
            ,date(a.record_time)
        from
            v_recon_queue a
        where
    ';
    if ( $testMode == 1 ) {
        $query .= '
        a.customer_id in ('
            . $cfgMgr->testCustomerIdsAsString() . ')
        ';
    } else {
    $query .= '
                a.table!=\'RECON_CUSTOMER\' 
				';
	}
    $query.='   group by
                    a.customer_id
                    ,date(a.record_time)
                order by date(a.record_time)
                with ur
    ';
    dlog($query);
    return ( 'distinctCustomerIdsFromQueueFifo', $query );
}


sub getReconSoftwareQueue {
    my ( $connection) = @_;

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
