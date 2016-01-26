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

sub contains {
 my $self        = shift;
 my $reconcileId = shift;

 my $query = 'select id from scarlet_reconcile where id = ?';
 dlog( 'exists=' . $query );

 my $id;
 $self->connection->prepareSqlQuery( 'checkExistence', $query );
 my $sth = $self->connection->sql->{checkExistence};
 $sth->bind_columns( \$id );

 $sth->execute($reconcileId);
 $sth->fetchrow_arrayref;
 $sth->finish;

 if ( defined $id ) {
  return 1;
 }
 else {
  return 0;
 }
}

sub validate {
 my $self = shift;
 my $id   = shift;

 $self->connection->prepareSqlQueryAndFields( $self->queryObserveItems($id) );
 my $sth = $self->connection->sql->{getObserveItems};
 my %recc;
 $sth->bind_columns( map { \$recc{$_} }
    @{ $self->connection->sql->{getObserveItemsFields} } );

 $sth->execute( $self->gapHour );

 while ( $sth->fetchrow_arrayref ) {
  my $scarletIs = new Recon::ScarletInstalledSoftware();

  if ( !defined $recc{installedSoftwareId} || !defined $recc{customerId} ) {
   dlog("start delete scarlet reconcile ");
   my $scarletReconcile = new Recon::OM::ScarletReconcile();
   $scarletReconcile->id( $recc{reconcileId} );
   $scarletReconcile->delete( $self->connection );
   dlog("end delete scarlet reconcile ");
  }
  elsif ( $self->ruleFail( $scarletIs, \%recc ) ) {
   dlog("item not in scarlet");
   dlog("reconcileId=$recc{reconcileId}");
   dlog("installedSoftwareId=$recc{installedSoftwareId}");

   dlog("not exists in scarlet");
   my $installedSoftware = new BRAVO::OM::InstalledSoftware();
   $installedSoftware->id( $recc{installedSoftwareId} );

   my $softwareLpar = new BRAVO::OM::SoftwareLpar();
   $softwareLpar->customerId( $recc{customerId} );

   my $queue =
     Recon::Queue->new( $self->connection, $installedSoftware, $softwareLpar,
    'LICENSING' );
   $queue->add;

   my $scarletReconcile = new Recon::OM::ScarletReconcile();
   $scarletReconcile->id( $recc{reconcileId} );
   $scarletReconcile->delete( $self->connection );

   dlog("appened into licensing queue");
  }
  elsif ( $scarletIs->outOfService ) {
   ##scarlet out of service do nothing.
   wlog('scarlet out of service. ');
  }
  else {
   dlog("item still valid in scarlet");
   my $scarletReconcile = new Recon::OM::ScarletReconcile();
   $scarletReconcile->id( $recc{reconcileId} );
   $scarletReconcile->update( $self->connection );

   dlog("last validation time reset.");
  }
 }

 $sth->finish;
}

sub queryObserveItems {
 my $self = shift;
 my $id   = shift;

 my @fileds = qw(reconcileId
   machineLevel
   installedSoftwareId
   customerId
   reconcileTypeId
   softwareId
 );

 my $query = '
    select 
      sr.id, 
      r.machine_level,
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
 if ( defined $id ) {
  $query .= ' and sr.id = ' . $id;
 }
 dlog( 'getObserveItems=' . $query );

 return ( 'getObserveItems', $query, \@fileds );

}

sub ruleFail {
 my $self      = shift;
 my $scarletIs = shift;
 my $rs        = shift;

 my %recc = %{$rs};

 if ( $recc{machineLevel} ) {
  my ( $scope, $level ) =
    Recon::Delegate::ReconDelegate->getScheduleFScopeByISW( $self->connection,
   $recc{installedSoftwareId} );

  return 1 if ( "HOSTNAME" eq $level );
 }

 if (
  (
   not $scarletIs->existInScarlet( $recc{reconcileId},
    $recc{installedSoftwareId} )
  )
  && ( not $scarletIs->outOfService )
   )
 {
  return 1;    
 }

 return 0;
}

sub checkDataConstency {
 my ( $self, $reconTypeId, $softwareIdOfInstalledSw, $reconcileId ) = @_;

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

 $sth->finish;

 dlog( "swMapLicense=" . $swMapLicense );

 if ( ( $reconTypeId eq 5 ) and $swMapLicense ) {
  return 1;
 }
 return 0;

}

1;

