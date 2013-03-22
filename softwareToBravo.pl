#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use File::Basename;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Database::Connection;
use Base::ConfigManager;
use BRAVO::SoftwareLoader;
use Tap::NewPerl;

my $logfile    = "/var/staging/logs/softwareToBravo/softwareToBravo.log";
my $pidFile    = "/tmp/softwareToBravo.pid";
my $configFile = "/opt/staging/v2/config/softwareToBravoConfig.txt";

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

my $job                  = 'STAGING TO BRAVO';
my $systemScheduleStatus = startJob($job);

my $maxChildren        = 50;
my %runningCustomerIds = ();
my %children           = ();
my $children;

my $connection = Database::Connection->new('staging');
my @customerIds = getStagingQueue( $connection, 0 );
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
        if ( isCustomerRunning( $customerId, $date ) == 1 ) {
            next;
        }
        newChild( $customerId, $date, 0 );
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
             my $connection = Database::Connection->new('staging');
             @customerIds = getStagingQueue( $connection, $count );
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
            if ( isCustomerRunning( $customerId, $date ) == 1 ) {
                $i--;
                next;
            }
            newChild( $customerId, $date, $count );
            if ( scalar @customerIds == 0 ) {
                sleep 5;
                $count++;
                if ( $count > 5 ) {
                    $count = 0;
                }
                last;
            }
        }
    }
}

sub isCustomerRunning {
    my $customerId = shift;
    my $date       = shift;
    my $result     = 0;
    wlog("Checking $customerId, $date");
    if ( exists $runningCustomerIds{$customerId}{$date} ) {
        wlog("$customerId, $date is running");
        $result = 1;
    }
    return $result;
}

sub newChild {
    my $customerId = shift;
    my $date       = shift;
    my $phase      = shift;
    my $pid;

    wlog("spawning $customerId, $date, $phase");
    my $sigset = POSIX::SigSet->new(SIGINT);
    sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
    die "Cannot fork child: $!\n" unless defined( $pid = fork );
    if ($pid) {
        $children{$pid} = 1;
        $children++;
        $runningCustomerIds{$customerId}{$date} = $pid;
        ilog("forked new child, we now have $children children");
        return;
    }

    my $stagingConnection = Database::Connection->new('staging');
    my $trailsConnection  = Database::Connection->new('trails');
    my $swassetConnection = Database::Connection->new('swasset');

    my @lpars = findSoftwareLparsByCustomerIdByDate( $customerId, $date, $phase, $stagingConnection );
    wlog( "Child $customerId, $date, " . scalar @lpars . " running -- $phase" );
    foreach my $id (@lpars) {
        my $loader = new BRAVO::SoftwareLoader( $stagingConnection, $trailsConnection, $swassetConnection );
        $loader->load(
                       LoadDeltaOnly => 1,
                       ApplyChanges  => 1,
                       CustomerId    => $customerId,
                       LparId        => $id,
                       Phase         => 1
        );
    }

    $stagingConnection->disconnect;
    $trailsConnection->disconnect;
    $swassetConnection->disconnect;
    wlog( "Child $customerId, $date," . scalar @lpars . " done -- $phase" );
    exit;
}

sub REAPER {
    my $stiff;
    while ( ( $stiff = waitpid( -1, &WNOHANG ) ) > 0 ) {
        warn("child $stiff terminated -- status $?");
        $children--;
        foreach my $customerId ( keys %runningCustomerIds ) {
            foreach my $date ( keys %{ $runningCustomerIds{$customerId} } ) {
                if ( $stiff == $runningCustomerIds{$customerId}{$date} ) {
                    delete $runningCustomerIds{$customerId}{$date};
                }
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

sub getStagingQueue {
    my ( $connection, $count ) = @_;

    my @customers;

    ###Prepare query to pull software lpar ids from staging
    dlog("preparing software lpar ids query");
    $connection->prepareSqlQueryAndFields( querySoftwareLparCustomers($count) );
    dlog("prepared software lpar ids query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids query");
    my $sth = $connection->sql->{softwareLparCustomers};
    dlog("got sth for software lpar ids query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparCustomersFields} } );
    dlog("binded columns for software lpar ids query");

    ###Excute the query
    ilog("executing software lpar ids query");
    $sth->execute();
    ilog("executed software lpar ids query");

    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );

        my %data;
        $data{ $rec{date} } = $rec{customerId};
        push @customers, \%data;
    }

    return @customers;
}

sub querySoftwareLparCustomers {
    my ($count) = @_;
    my @fields  = (qw( customerId date ));
    my $query   = '
        select
            a.customer_id
            ,date(a.scan_time)
        from software_lpar a
        left outer join software_lpar_map b on
            a.id = b.software_lpar_id
        left outer join scan_record c on
            b.scan_record_id = c.id
    ';
    if ( $count == 0 ) {
        $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
    }
    elsif ( $count == 1 ) {
        $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
    }
    elsif ( $count == 2 ) {
        $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
    }
    elsif ( $count == 3 ) {
        $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
    }
    elsif ( $count == 4 ) {
        $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
    }
    elsif ( $count == 5 ) {
        $query .= '
        left outer join scan_software_item si on
            c.id = si.scan_record_id
        ';
    }
    my $clause = 'where';
    $query .= ' ' . $clause . '  a.customer_id in (
    5304,6782,8571,8611,8808,9206,9416,9754,11959,12335,13561,13651,13799,13816,13818,14172,14501,15315,15323,
    8621,8996,9363,12031,13767
    ) 
    and ( (
        a.action != \'COMPLETE\'
        or b.action != \'COMPLETE\' ';
    if ( $count == 0 ) {
        $query .= '
                or sm.action != \'COMPLETE\'
            ';
    }
    elsif ( $count == 1 ) {
        $query .= '
                or sd.action != \'COMPLETE\'
            ';
    }
    elsif ( $count == 2 ) {
        $query .= '
                or st.action != \'COMPLETE\'
            ';
    }
    elsif ( $count == 3 ) {
        $query .= '
                or sf.action != \'COMPLETE\'
            ';
    }
    elsif ( $count == 4 ) {
        $query .= '
                or ss.action != \'COMPLETE\'
            ';
    }
    elsif ( $count == 5 ) {
        ### 0-COMPLETE 1-UPDATE 2-DELETE
        $query .= '
                or si.action != 0  
            ';
    }
    $query .= '))';
    $clause = 'and';

    $query .= '
        group by
            a.customer_id
            ,date(a.scan_time)
        order by
            date(a.scan_time)
        with ur
    ';
    dlog("querySoftwareLparCustomers=$query");
    return ( 'softwareLparCustomers', $query, \@fields );
}

sub findSoftwareLparsByCustomerIdByDate {
    my ( $customerId, $date, $phase, $connection ) = @_;

    my @lparIds;

    ###Prepare query to pull software lpar ids from staging
    dlog("preparing software lpar ids query");
    $connection->prepareSqlQueryAndFields( querySoftwareLparsByCustomerIdByDate($phase) );
    dlog("prepared software lpar ids query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids query");
    my $sth = $connection->sql->{softwareLparsByCustomerIdByDate};
    dlog("got sth for software lpar ids query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparsByCustomerIdByDateFields} } );
    dlog("binded columns for software lpar ids query");

    ###Excute the query
    ilog("executing software lpar ids query");
    $sth->execute( $customerId, $date );
    ilog("executed software lpar ids query");

    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );
        push @lparIds, $rec{id};
    }

    return @lparIds;
}

sub querySoftwareLparsByCustomerIdByDate {
    my $phase  = shift;
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from software_lpar a
        left outer join software_lpar_map b on
            a.id = b.software_lpar_id
        left outer join scan_record c on
            b.scan_record_id = c.id
    ';
    if ( $phase == 0 ) {
        $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
    }
    elsif ( $phase == 1 ) {
        $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
    }
    elsif ( $phase == 2 ) {
        $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
    }
    elsif ( $phase == 3 ) {
        $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
    }
    elsif ( $phase == 4 ) {
        $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
    }
    elsif ( $phase == 5 ) {
        $query .= '
        left outer join scan_software_item si on
            c.id = si.scan_record_id
        ';
    }
    $query .= '
        where
            a.customer_id = ?
            and date(a.scan_time) = ?
            and (a.action != \'COMPLETE\'
            or b.action != \'COMPLETE\'
        ';
    if ( $phase == 0 ) {
        $query .= '
                or sm.action != \'COMPLETE\'
            ';
    }
    elsif ( $phase == 1 ) {
        $query .= '
                or sd.action != \'COMPLETE\'
            ';
    }
    elsif ( $phase == 2 ) {
        $query .= '
                or st.action != \'COMPLETE\'
            ';
    }
    elsif ( $phase == 3 ) {
        $query .= '
                or sf.action != \'COMPLETE\'
            ';
    }
    elsif ( $phase == 4 ) {
        $query .= '
                or ss.action != \'COMPLETE\'
            ';
    }
    elsif ( $phase == 5 ) {
        ### 0-COMPLETE 1-UPDATE 2-DELETE
        $query .= '
                or si.action != 0
            ';
    }
    $query .= ')';
    $query .= '
        group by
            a.id
        order by
            a.id
        with ur
    ';
    return ( 'softwareLparsByCustomerIdByDate', $query, \@fields );
}


