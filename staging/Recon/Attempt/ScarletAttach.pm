package Recon::Attempt::ScarletAttach;

use strict;
use Base::Utils;
use Database::Connection;

use Recon::OM::Reconcile;
use BRAVO::OM::InstalledSoftware;    
use Recon::ScarletInstalledSoftware;
use Scarlet::SkuEndpoint;

sub new {
 my ( $class, $installedSoftware ) = @_;
 my $self = {
  _installedSoftware => $installedSoftware,
  _skuEndpoint       => Scarlet::SkuEndpoint->new,
  _connection        => Database::Connection->new('trails')
 };

 bless $self, $class;
}

sub skuEndpoint {
 my $self = shift;
 $self->{_skuEndpoint} = shift if scalar @_ == 1;
 return $self->{_skuEndpoint};
}

sub installedSoftware {
 my $self = shift;
 $self->{_installedSoftware} = shift if scalar @_ == 1;
 return $self->{_installedSoftware};
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub attempt {
 my $self = shift;

 dlog('begin scarlet attach attempt');
 my $result = $self->getAccountNoGuid;
 my $skus   =
   $self->skuEndpoint->httpGet( $result->{accountNo}, $result->{guid} );

 $skus = [] if ( !defined $skus );
 dlog( scalar @{$skus} . ' sku(s) found in scarlet' );

 my $allocation = undef;
 foreach my $skuHash ( @{$skus} ) {

  $self->concatenateWithPrefix( $skuHash->{licenseIds}, 'SWCM_' );

  my $param = {
   extSrcIds => $skuHash->{licenseIds},
   guids     => $skuHash->{guids},
   hwId      => $result->{hardwareId},
   swLparId  => $result->{softwareLparId},
  };

  my $scarletIs = Recon::ScarletInstalledSoftware->new();

  my $reconcile = $self->getMatchedReconcile($param);

  if ( defined $reconcile ) {
   dlog('matched reconcile found');

   my $is = BRAVO::OM::InstalledSoftware->new;
   $is->id( $reconcile->installedSoftwareId );
   $is->getById( $self->connection );

   my $isObj =
     Recon::LicensingInstalledSoftware->new( $self->connection, $is, 0 );
   $isObj->setUp();

   $scarletIs->reconcileTypeId( $reconcile->reconcileTypeId );
   $scarletIs->machineLevel( $reconcile->machineLevel );
   $scarletIs->allocMethodId( $reconcile->allocationMethodologyId );

   my $usedLicenseIds = $self->getUsedLicenseIds($reconcile);
   $scarletIs->usedLicenses($usedLicenseIds);

   $allocation =
     $scarletIs->allocateOnInstalledSoftwareId( $self->installedSoftware->id,
    $isObj );
   last;
  }
 }

 if ( defined $allocation ) {
  dlog('reconciled by scarlet attach attempt');
  return 1;
 }

 dlog('did not reconcile by scarlet attach attempt');
 return 0;
}

sub getAccountNoGuid {
 my $self = shift;

 $self->connection->prepareSqlQueryAndFields( $self->queryAccountNoGuid );
 my $sth = $self->connection->sql->{queryAccountNOGuid};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{queryAccountNOGuidFields} } );
 $sth->execute( $self->installedSoftware->id );
 $sth->fetchrow_arrayref;
 my $result = \%rec;
 $sth->finish;
 dlog('accountNo='
    . $result->{accountNo}
    . ' guid='
    . $result->{guid}
    . ' hardwareId='
    . $result->{hardwareId}
    . ' softwareLparId='
    . $result->{softwareLparId} );

 return $result;
}

sub queryAccountNoGuid {

 my @fields = qw(
   accountNo
   guid
   softwareLparId
   hardwareId
 );

 my $query = "
select 
c.account_number, 
kd.guid, 
sl.id,
h.id
from 
installed_software is, 
software_lpar sl,
hw_sw_composite hsc,
hardware_lpar hl,
hardware h,
customer c,
kb_definition kd
where 
is.software_lpar_id = sl.id
and sl.id = hsc.software_lpar_id
and hsc.hardware_lpar_id = hl.id
and hl.hardware_id = h.id
and sl.customer_id = c.customer_id
and is.software_id = kd.id
and is.id = ?
with ur";

 dlog( 'query=' . $query );
 return ( 'queryAccountNOGuid', $query, \@fields );
}

sub concatenateWithPrefix {
 my $self   = shift;
 my $array  = shift;
 my $prefix = shift;

 for ( my $i = 0 ; $i < ( scalar @{$array} ) ; $i++ ) {
  $array->[$i] = $prefix . $array->[$i];
 }
}

sub getMatchedReconcile {
 my $self  = shift;
 my $param = shift;

 dlog( "hwId=" . $param->{hwId} . ",swlparId=" . $param->{swLparId} );

 my @guids     = @{ $param->{guids} };
 my @extSrcIds = @{ $param->{extSrcIds} };

 my $inGuids     = join( ', ', ('?') x @guids );
 my $inExtSrcIds = join( ', ', ('?') x @extSrcIds );

 my $queryName =
   'queryMatchedReconciledIDs' . ( scalar @guids ) .'_'. ( scalar @extSrcIds );
 dlog($queryName);

 $self->connection->prepareSqlQuery(
  $self->queryMatchedReconciledId( $queryName, $inGuids, $inExtSrcIds ) );
 my $sth = $self->connection->sql->{$queryName};

 my $reconcileId;
 $sth->bind_columns( \$reconcileId );
 $sth->execute( @guids, @extSrcIds, $param->{hwId}, $param->{swLparId} );
 $sth->fetchrow_arrayref;
 $sth->finish;

 if ( defined $reconcileId ) {
  dlog( 'reconcileId=' . $reconcileId );
  my $r = Recon::OM::Reconcile->new();
  $r->id($reconcileId);
  $r->getById( $self->connection );
  return $r;
 }
 else {
  dlog('no matched reconcile found');
  return undef;
 }

}

sub queryMatchedReconciledId {
 my $self     = shift;
 my $name     = shift;
 my $guid     = shift;
 my $extSrcId = shift;

 my $query = '
select 
 r.id
from 
 reconcile r, 
 installed_software is,
 software_lpar sl, 
 hw_sw_composite hsc,
 hardware_lpar hl, 
 hardware h, 
 kb_definition kd,
 reconcile_used_license rul, 
 used_license ul,
 license l
where
 r.installed_software_id = is.id
 and is.software_lpar_id = sl.id
 and sl.id = hsc.software_lpar_id
 and hsc.hardware_lpar_id = hl.id
 and hl.hardware_id = h.id
 and is.software_id = kd.id
 and r.id = rul.reconcile_id
 and rul.used_license_id = ul.id
 and ul.license_id = l.id
 and r.reconcile_type_id  in (1,5)
 and kd.guid in (' . $guid . ')
 and l.ext_src_id in (' . $extSrcId . ')
 and ( 
        (r.machine_level = 1 and h.id = ?) 
        or (r.machine_level =0 and sl.id = ?) 
     )
with ur
 ';

 dlog( $name . '=' . $query );
 return ( $name, $query );
}

sub getUsedLicenseIds {
 my $self      = shift;
 my $reconcile = shift;

 my @ulIds;
 $self->connection->prepareSqlQueryAndFields( $self->queryUsedLicenseIds() );
 my $sth = $self->connection->sql->{queryUsedLicenseIDs};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{queryUsedLicenseIDsFields} } );
 $sth->execute( $reconcile->id );

 while ( $sth->fetchrow_arrayref ) {
  push @ulIds, $rec{usedLicenseId};
 }
 $sth->finish;

 return \@ulIds;

}

sub queryUsedLicenseIds {

 my @fields = qw(
   usedLicenseId
 );

 my $query = "select rul.used_license_id from
 reconcile_used_license rul where rul.reconcile_id = ?";

 dlog( 'query=' . $query );
 return ( 'queryUsedLicenseIDs', $query, \@fields );
}

1;
