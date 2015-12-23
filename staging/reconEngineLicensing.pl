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
use Recon::LicensingReconEngineCustomer;
use Recon::Delegate::ReconDelegate;

my $logfile    = "/var/staging/logs/reconEngineLicensing/reconEngineLicensing.log";
my $pidFile    = "/tmp/reconEngineLicensing.pid";
my $configFile = "/opt/staging/v2/config/reconEngineLicensingConfig.txt";

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

my $job                  = 'RECON ENGINE LICENSING';
my $systemScheduleStatus = startJob($job);

my $rNo = 'revision233';

my $maxChildren        = 100;
my %runningCustomerIds = ();
my %children           = ();
# my $children;

my $connection = Database::Connection->new('trails',$connRetryTimes,$connRetrySleepPeriod);
my @customerIds = getReconCustomerQueue( $connection, $testMode );
my ( $masters, $members ) = getPoolCustomers($connection);
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
    while ( loaderCheckForStop($pidFile) == 0 ) {
        if ( scalar @customerIds == 0 ) {
             my $connection;
             while (!defined($connection)) {$connection= Database::Connection->new('trails',$connRetryTimes,$connRetrySleepPeriod)}
             @customerIds = getReconCustomerQueue( $connection, $testMode );
             ( $masters, $members ) = getPoolCustomers($connection);
             $connection->disconnect;
             Recon::Delegate::ReconDelegate->checkRunningProcHash(\%children);
        }
         if ( scalar (keys (%children)) >= $maxChildren ) {
			if ( Recon::Delegate::ReconDelegate->checkRunningProcHash(\%children) == 0 ) {
				wlog("$rNo sleeping");
				sleep;
			}
            
            wlog("$rNo before reset array size:". scalar @customerIds);
            my $connection;
            while (!defined($connection)) {$connection= Database::Connection->new('trails',$connRetryTimes,$connRetrySleepPeriod)}
            @customerIds = getReconCustomerQueue( $connection, $testMode );
            ( $masters, $members ) = getPoolCustomers($connection);
            $connection->disconnect;
            wlog("$rNo end reset array size:". scalar @customerIds);
            
            wlog("$rNo done sleeping");
        }
        
        
        for ( my $i = scalar (keys %children); $i < $maxChildren; $i++ ) {
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
        
        if ((scalar @customerIds == 0) && ( scalar (keys %children) > 0 )) {
			Recon::Delegate::ReconDelegate->checkRunningProcHash(\%children);
			if ( scalar (keys %children) > 0 ) {
				wlog("$rNo loop of customer array finished will sleep till end of child");
				sleep;
				wlog("$rNo waked up");
			}
        }
        elsif ((scalar @customerIds == 0) && ( scalar(keys %children) == 0 ) && ( loaderCheckForStop ( $pidFile ) == 0 )) {
			wlog("$rNo customer array empty and no children running, sleeping 2 minutes before reloading the queue");
			sleep 120;
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
        $runningCustomerIds{$customerId} = $pid;
        ilog("forked new child, we now have ".scalar(keys %children)." children");
        return;
    }

    if ( scalar @customerIds == 0 ) {
       wlog("$rNo sleeping 5");
       sleep 300;
       wlog("$rNo done sleeping 5");
    }

    my $reconEngine = new Recon::LicensingReconEngineCustomer( $customerId, $date, $poolRunning );
    $reconEngine->recon;

    sleep 35;
    wlog("$rNo Child $customerId, $date, $poolRunning complete");

    exit;
}

sub REAPER {
    my $stiff;
    while ( ( $stiff = waitpid( -1, &WNOHANG ) ) > 0 ) {
        warn("child $stiff terminated -- status $?");
        delete $children{$stiff} if exists $children{$stiff};
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
            v_recon_licensing_queue a
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
            v_recon_licensing_queue a
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
