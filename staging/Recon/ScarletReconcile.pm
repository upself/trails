package Recon::ScarletReconcile;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::ScarletInstalledSoftware;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use Recon::Queue;

sub new {
 my ( $class, $gapHour ) = @_;
 my $self = {
  _connection => Database::Connection->new('trails'),
  _gapHour    => $gapHour
 };
 bless $self, $class;
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub gapHour {
 my $self = shift;
 $self->{_gapHour} = shift if scalar @_ == 1;
 return $self->{_gapHour};
}

sub validate {
 my $self = shift;

 my $query = '
    select 
      sr.id, 
      r.installed_software_id,
      sl.customer_id, 
      r.reconcile_type_id,
      is.software_id
    from 
      scarlet_reconcile sr
      left outer join reconcile r
      on sr.id = r.id
      left outer join installed_software is
      on is.id = r.installed_software_id
      left outer join software_lpar sl
      on sl.id = is.software_lpar_id
    where 
      TIMESTAMPDIFF(8, (current timestamp)-(sr.last_validate_time)) >=?'
   ;

 dlog( 'getObserveItems=' . $query );

 my $reconcileId;
 my $installedSoftwareId;
 my $customerId;
 my $reconcileTypeId;
 my $swIdOfInstalledSw;
 $self->connection->prepareSqlQuery( 'getObserveItems', $query );
 my $sth = $self->connection->sql->{getObserveItems};
 $sth->bind_columns( \$reconcileId, \$installedSoftwareId, \$customerId,
  \$reconcileTypeId, \$swIdOfInstalledSw );

 $sth->execute( $self->gapHour );

 while ( $sth->fetchrow_arrayref ) {
  my $scarletIs = new Recon::ScarletInstalledSoftware();

  if ( !defined $installedSoftwareId || !defined $customerId ) {
   dlog("reconcile already breaked ");
   my $scarletReconcile = new Recon::OM::ScarletReconcile();
   $scarletReconcile->id($reconcileId);
   $scarletReconcile->delete( $self->connection );
   dlog("scarlet reconcile deleted");
  }
  elsif (
      ( not $scarletIs->existInScarlet( $reconcileId, $installedSoftwareId ) )
   && ( not $scarletIs->outOfService ) )
  {
   dlog("item not in scarlet");
   dlog("reconcileId=$reconcileId");
   dlog("installedSoftwareId=$installedSoftwareId");

   my $isAutoScarlet =
     $self->checkIfAutoScarletAllocate( $reconcileTypeId, $swIdOfInstalledSw,
    $reconcileId );

   dlog( "isAutoScarlet=" . $isAutoScarlet );

   if ( not $isAutoScarlet ) {
    dlog("not reconciled by scarelt");
    my $scarletReconcile = new Recon::OM::ScarletReconcile();
    $scarletReconcile->id($reconcileId);
    $scarletReconcile->delete( $self->connection );
    dlog("scarlet reconcile deleted");
   }
   else {
    dlog("not exists in scarlet");
    my $installedSoftware = new BRAVO::OM::InstalledSoftware();
    $installedSoftware->id($installedSoftwareId);

    my $softwareLpar = new BRAVO::OM::SoftwareLpar();
    $softwareLpar->customerId($customerId);

    my $queue =
      Recon::Queue->new( $self->connection, $installedSoftware, $softwareLpar,
     'LICENSING' );
    $queue->add;

    my $scarletReconcile = new Recon::OM::ScarletReconcile();
    $scarletReconcile->id($reconcileId);
    $scarletReconcile->update( $self->connection );

    dlog("appened into licensing queue");
   }
  }
  elsif ( $scarletIs->outOfService ) {
   ##scarlet out of service do nothing.
   wlog('scarlet out of service. ');
  }
  else {
   dlog("item still valid in scarlet");
   my $scarletReconcile = new Recon::OM::ScarletReconcile();
   $scarletReconcile->id($reconcileId);
   $scarletReconcile->update( $self->connection );

   dlog("last validation time reset.");
  }
 }
}

sub checkIfAutoScarletAllocate {
 my ( $self, $reconTypeId, $softwareIdOfInstalledSw, $reconcileId ) =
   @_;    

 my $query = '
    select
     lsm.software_id
   from 
     scarlet_reconcile sr, 
     reconcile_used_license rul, 
     used_license ul,
     license_sw_map lsm
   where
     sr.id  = rul.reconcile_id
     and rul.used_license_id = ul.id
     and ul.license_id  = lsm.license_id
     and sr.id  = ?
 ';

 dlog( "query=" . $query );
 dlog( "reconcileId=" . $reconcileId );

 my $softwareIdFromLicenseMap;
 $self->connection->prepareSqlQuery( 'getSWIdFromLicenseMap', $query );
 my $sth = $self->connection->sql->{getSWIdFromLicenseMap};
 $sth->bind_columns( \$softwareIdFromLicenseMap );
 $sth->execute($reconcileId);

 my $swMapLicense = 0;

 while ( $sth->fetchrow_arrayref ) {

  dlog('$softwareIdOfInstalledSw='
     . $softwareIdOfInstalledSw
     . ' $softwareIdFromLicenseMap='
     . $softwareIdFromLicenseMap );

  #if not equal means it's scarlet reconcile.
  if ( $softwareIdOfInstalledSw ne $softwareIdFromLicenseMap ) {
   $swMapLicense = 1;
   last;
  }
 }

 dlog( "swMapLicense=" . $swMapLicense );

 if ( ( $reconTypeId eq 5 ) and $swMapLicense ) {
  return 1;
 }
 return 0;

}

1;

