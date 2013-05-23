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

my $rNo                = "revision185";
my $children           =0;
my $maxChildren        = 135;
my %runningCustomerIds = ();
my %children           = ();

my $connection = Database::Connection->new('staging');
my @customerIds = getStagingQueue( $connection, 5 );
$connection->disconnect;

daemonize();
spawnChildren();
keepTicking();
endJob($systemScheduleStatus);
exit;

sub spawnChildren {
 wlog("$rNo Spawning children");
 for ( my $i = 0 ; $i < $maxChildren ; $i++ ) {
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
 wlog("$rNo Keep on ticking");
 my $count = 5;
 while (1) {
  if ( scalar @customerIds == 0 ) {
   my $connection = Database::Connection->new('staging');
   @customerIds = getStagingQueue( $connection, $count );
   $connection->disconnect;
  }
  if ( $children >= $maxChildren ) {
   wlog("$rNo sleeping");
   sleep;
   wlog("$rNo done sleeping");
  }
  for ( my $i = $children ; $i < $maxChildren ; $i++ ) {
   dlog("$rNo running $i");
   my $customer = shift @customerIds;
   my ( $date, $customerId ) = each %$customer;
   if ( isCustomerRunning( $customerId, $date ) == 1 ) {
    $i--;
    next;
   }
   if ( scalar @customerIds == 0 ) {
     sleep 5;
     $count++;
     if($count>6){
       $count = 0;
     }
    last;
   }else{
    newChild( $customerId, $date, $count );
   }
  }
 }
}

sub isCustomerRunning {
 my $customerId = shift;
 my $date       = shift;
 my $result     = 0;
 dlog("$rNo Checking $customerId, $date");
 if ( exists $runningCustomerIds{$customerId}{$date} ) {
  dlog("$rNo $customerId, $date is running");
  $result = 1;
 }
 return $result;
}

sub newChild {
 my $customerId = shift;
 my $date       = shift;
 my $phase      = shift;
 my $pid;

 wlog("$rNo spawning $customerId, $date, $phase");
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

 my @lpars =
   findSoftwareLparsByCustomerIdByDate( $customerId, $date, $phase,
  $stagingConnection );
 wlog(
  "$rNo Child $customerId, $date, " . scalar @lpars . " running -- $phase" );
 foreach my $id (@lpars) {
  my $loader =
    new BRAVO::SoftwareLoader( $stagingConnection, $trailsConnection,
   $swassetConnection );
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
 wlog( "$rNo Child $customerId, $date," . scalar @lpars . " done -- $phase" );
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
 exit                             if $pid;

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
 my %customerIdDateHash = ();

 for ( my $p = 0 ; $p < 2 ; $p++ ) {
  wlog("$rNo start building customer id array for $p");
  ###Prepare query to pull software lpar ids from staging
  dlog("preparing software lpar ids query");
  $connection->prepareSqlQueryAndFields(
   querySoftwareLparCustomers( $count, $p ) );
  dlog("prepared software lpar ids query");

  ###Get the statement handle
  dlog("getting sth for software lpar ids query");
  my $sth = $connection->sql->{ 'softwareLparCustomers' . $p };
  dlog("got sth for software lpar ids query");

  ###Bind our columns
  my %rec;
  dlog("binding columns for software lpar ids query");
  $sth->bind_columns( map { \$rec{$_} }
     @{ $connection->sql->{ 'softwareLparCustomers' . $p . 'Fields' } } );
  dlog("binded columns for software lpar ids query");

  ###Excute the query
  ilog("executing software lpar ids query");
  $sth->execute();
  ilog("executed software lpar ids query");

  while ( $sth->fetchrow_arrayref ) {
   cleanValues( \%rec );

   my $keys = $rec{customerId} . '|' . $rec{date};
   if ( $customerIdDateHash{$keys} ) {
    dlog( "keys=" . $keys );
    next;
   }
   else {
    my %data;
    $data{ $rec{date} } = $rec{customerId};
    push @customers, \%data;
    $customerIdDateHash{$keys} = 1;
   }
  }
  wlog("$rNo end building customer id array for $p");
 }
 wlog( $rNo.' Loaded customer/date combinations :' . scalar @customers. 'Phase :'.$count );
 wlog("$rNo Running Threads : $children ");

 return @customers;
}

sub querySoftwareLparCustomers {
 my ( $count, $p ) = @_;
 my @fields = (qw( customerId date ));

 my $query = undef;
 if ( $p == 0 ) {
  $query = p1Query($count);
 }
 elsif ( $p == 1 ) {
  $query = p2Query($count);
 }

 dlog("querySoftwareLparCustomers$p=$query");

 return ( 'softwareLparCustomers' . $p, $query, \@fields );
}

sub p1Query {
 my $count = shift;

 my $query = '
        select
            a.customer_id
            ,date(a.scan_time)
        from software_lpar a
        left outer join software_lpar_map b on
            a.id = b.software_lpar_id
        left outer join scan_record c on
            b.scan_record_id = c.id
    ';
 if ( $count == 1 ) {
  $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
 }
 elsif ( $count == 2 ) {
  $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
 }
 elsif ( $count == 3 ) {
  $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
 }
 elsif ( $count == 4 ) {
  $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
 }
 elsif ( $count == 5 ) {
  $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
 }
 elsif ( $count == 6 ) {
  $query .= '
        left outer join scan_software_item si on
            c.id = si.scan_record_id
        ';
 }
 my $clause = '';
 $query .= ' where a.customer_id in (
               337,414,479,503,504,506,514,525,532,758,1034,1206,1471,2447,
               2568,2602,2605,2676,2692,2845,2876,2928,2960,2961,2963,2981,
               2991,3485,3947,4173,5304,5704,5798,5825,6266,6782,7049,7076,
               7081,7088,7090,7097,7109,7112,7114,7128,7160,7199,7200,7649,
               7732,7737,8571,8611,8621,8664,8666,8668,8672,8689,8808,8825,
               8844,8996,8998,9047,9102,9182,9198,9204,9206,9363,9416,9473,
               9514,9590,9598,9601,9664,9754,11034,11472,11480,11498,11660,
               11804,11860,11959,12031,12045,12058,12109,12132,12137,12155,
               12335,12350,12476,12496,12508,12543,12999,13293,13331,13395,
               13444,13454,13457,13546,13561,13595,13651,13767,13775,13786,
               13792,13799,13816,13818,14015,14075,14172,14182,14292,14346,
               14373,14472,14501,14536,14543,14555,14939,14940,15167,15246,
               15302,15323,15620,4200,14046,11869
       )
    and (
        a.action != \'COMPLETE\'
        or b.action != \'COMPLETE\' ';
 if ( $count == 1 ) {
  $query .= '
                or sm.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 2 ) {
  $query .= '
                or sd.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 3 ) {
  $query .= '
                or st.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 4 ) {
  $query .= '
                or sf.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 5 ) {
  $query .= '
                or ss.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 6 ) {
  ### 0-COMPLETE 1-UPDATE 2-DELETE 3-CATALOG MISSING
  $query .= '
                or si.action in (1,2)
            ';
 }

 $query .= ')';

 $query .= '
        group by
            a.customer_id
            ,date(a.scan_time)
        order by
            date(a.scan_time)
        with ur
    ';

 return $query;
}

sub p2Query {
 my $count = shift;

 my $query = '
        select
            a.customer_id
            ,date(a.scan_time)
        from software_lpar a
        left outer join software_lpar_map b on
            a.id = b.software_lpar_id
        left outer join scan_record c on
            b.scan_record_id = c.id
    ';
 if ( $count == 1 ) {
  $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
 }
 elsif ( $count == 2 ) {
  $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
 }
 elsif ( $count == 3 ) {
  $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
 }
 elsif ( $count == 4 ) {
  $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
 }
 elsif ( $count == 5 ) {
  $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
 }
 elsif ( $count == 6 ) {
  $query .= '
        left outer join scan_software_item si on
            c.id = si.scan_record_id
        ';
 }
 $query .= ' where a.action != \'COMPLETE\'
        or b.action != \'COMPLETE\' ';
 if ( $count == 1 ) {
  $query .= '
                or sm.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 2 ) {
  $query .= '
                or sd.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 3 ) {
  $query .= '
                or st.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 4 ) {
  $query .= '
                or sf.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 5 ) {
  $query .= '
                or ss.action != \'COMPLETE\'
            ';
 }
 elsif ( $count == 6 ) {
  ### 0-COMPLETE 1-UPDATE 2-DELETE
  $query .= '
                or si.action in (1,2)
            ';
 }

 $query .= '
        group by
            a.customer_id
            ,date(a.scan_time)
        order by
            date(a.scan_time)
        with ur
    ';

 return $query;
}

sub findSoftwareLparsByCustomerIdByDate {
 my ( $customerId, $date, $phase, $connection ) = @_;

 my @lparIds;

 ###Prepare query to pull software lpar ids from staging
 dlog("preparing software lpar ids query");
 $connection->prepareSqlQueryAndFields(
  querySoftwareLparsByCustomerIdByDate($phase) );
 dlog("prepared software lpar ids query");

 ###Get the statement handle
 dlog("getting sth for software lpar ids query");
 my $sth = $connection->sql->{softwareLparsByCustomerIdByDate};
 dlog("got sth for software lpar ids query");

 ###Bind our columns
 my %rec;
 dlog("binding columns for software lpar ids query");
 $sth->bind_columns( map { \$rec{$_} }
    @{ $connection->sql->{softwareLparsByCustomerIdByDateFields} } );
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
 if ( $phase == 1 ) {
  $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
 }
 elsif ( $phase == 2 ) {
  $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
 }
 elsif ( $phase == 3 ) {
  $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
 }
 elsif ( $phase == 4 ) {
  $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
 }
 elsif ( $phase == 5 ) {
  $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
 }
 elsif ( $phase == 6 ) {
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
 if ( $phase == 1 ) {
  $query .= '
                or sm.action != \'COMPLETE\'
            ';
 }
 elsif ( $phase == 2 ) {
  $query .= '
                or sd.action != \'COMPLETE\'
            ';
 }
 elsif ( $phase == 3 ) {
  $query .= '
                or st.action != \'COMPLETE\'
            ';
 }
 elsif ( $phase == 4 ) {
  $query .= '
                or sf.action != \'COMPLETE\'
            ';
 }
 elsif ( $phase == 5 ) {
  $query .= '
                or ss.action != \'COMPLETE\'
            ';
 }
 elsif ( $phase == 6 ) {
  ### 0-COMPLETE 1-UPDATE 2-DELETE 3-CATALOG MISSING
  $query .= '
                or si.action in (1,2)
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
