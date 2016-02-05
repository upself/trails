#!/usr/bin/perl
#
# Move this script to /opt/staging/v2 and execute till finished. 
#
use strict;
use Digest::MD5 qw(md5_hex);

use Recon::OM::Reconcile;
use Recon::OM::ScarletReconcile;
use Database::Connection;

print 'process started' . "\n";
my $conn = Database::Connection->new('trails');
$conn->prepareSqlQueryAndFields( queryScarletReconcile() );
my $sth = $conn->sql->{queryScarletReconcileId};

my %rec;
$sth->bind_columns( map { \$rec{$_} }
   @{ $conn->sql->{queryScarletReconcileIdFields} } );
$sth->execute();

while ( $sth->fetchrow_arrayref ) {
 my $r = Recon::OM::Reconcile->new;
 $r->id( $rec{id} );
 $r->getById($conn);

 my $sr = Recon::OM::ScarletReconcile->new();
 $sr->id( $rec{id} );
 $sr->reconcileMd5Hex( md5_hex( $r->toString ) );
 $sr->update($conn);

 print $sr->toString . "\n";    

}

print 'process done' . "\n";

sub queryScarletReconcile {
 my @fields = qw(id);
 my $query  = "select id from scarlet_reconcile";

 return ( 'queryScarletReconcileId', $query, \@fields );
}
