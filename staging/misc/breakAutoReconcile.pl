#!/usr/bin/perl -w
# NOTE: This script is used for breaking auto reconcilation under special product name.
# Not for recovery usage.
# Author: Yi R Zhang/China/IBM.
# Logical:
# 1. find the auto reconciled id under special product name.
# 2. call delegate to break the reconcile.
# 3. append the installed software into recon queue with action  = LICENSING.

use strict;
use Database::Connection;
use Base::Utils;
use Recon::Delegate::ReconDelegate;
use Recon::OM::ReconInstalledSoftware;

my $connection = Database::Connection->new('trails');
my $data       = getAutoReconcileInfo($connection);

my $counter = 0;
my $total   = scalar keys %{$data};
foreach my $rid ( sort keys %{$data} ) {
 print $rid. ', ' . $data->{$rid}->{cId} . ', ' . $data->{$rid}->{isId} . "\n";

 Recon::Delegate::ReconDelegate->breakReconcileById( $connection, $rid );

 my $reconIs = new Recon::OM::ReconInstalledSoftware();
 $reconIs->customerId( $data->{$rid}->{cId} );
 $reconIs->installedSoftwareId( $data->{$rid}->{isId} );
 $reconIs->action('LICENSING');
 $reconIs->save($connection);

 $counter++;
 print $reconIs->toString . "\n";
 print " $counter/$total \n";

 
}

sub queryAutoReconcileByProduct {
 my @fields = qw( reconcileId customerId isId );
 my $query  = '
select r.id,sl.customer_id,is.id from reconcile r, 
installed_software is, 
software_lpar sl
where 
r.installed_software_id = is.id
and sl.id = is.software_lpar_id
and r.reconcile_type_id = 5
and is.software_id in (215245, 497477,134613,220160,220164,220165,220167,220169,220171,220834,220831,220832,220833,
220835,220828,220829,220830,223199)
order by r.record_time desc
with ur
    ';

 return ( 'autoReconcileByProduct', $query, \@fields );
}

sub getAutoReconcileInfo {
 my ($connection) = @_;

 my %data;

 $connection->prepareSqlQueryAndFields( queryAutoReconcileByProduct() );
 my $sth = $connection->sql->{autoReconcileByProduct};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $connection->sql->{autoReconcileByProductFields} } );
 $sth->execute();
 while ( $sth->fetchrow_arrayref ) {
  $data{ $rec{reconcileId} }{cId}  = $rec{customerId};
  $data{ $rec{reconcileId} }{isId} = $rec{isId};
 }
 $sth->finish;

 return \%data;
}

