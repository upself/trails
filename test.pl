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

my $connection = Database::Connection->new('trails');
my @customerIds = getReconCustomerQueue( $connection, 0);
for my $elemt (@customerIds ) {
  my($date,$customerId) = each %$elemt;
  print "$date,$customerId \n";

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



sub queryDistinctCustomerIdsFromQueueFifo {
    my $testMode = shift;

    my $query = '
select
a.customer_id
,date(a.record_time)
from
v_recon_queue a
group by
a.customer_id
,date(a.record_time)
order by
date(a.record_time)
with ur
    ';
    return ( 'distinctCustomerIdsFromQueueFifo', $query );
}

