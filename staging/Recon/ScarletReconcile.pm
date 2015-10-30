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
      sl.customer_id
    from 
      scarlet_reconcile sr
      left outer join reconcile r
      on sr.id = r.id
      left outer join installed_software is
      on is.id = r.installed_software_id
      left outer join software_lpar sl
      on sl.id = is.software_lpar_id
    where 
      TIMESTAMPDIFF(8, (current timestamp)-(sr.last_validate_time)) >=?';

 dlog( 'getObserveItems=' . $query );

 my $reconcileId;
 my $installedSoftwareId;
 my $customerId;
 $self->connection->prepareSqlQuery( 'getObserveItems', $query );
 my $sth = $self->connection->sql->{getObserveItems};
 $sth->bind_columns( \$reconcileId, \$installedSoftwareId, \$customerId );

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
   && ( not $scarletIs->outOfService )    
    )
  {
   dlog("item not in scarlet");
   dlog("reconcileId=$reconcileId");
   dlog("installedSoftwareId=$installedSoftwareId");

   my $installedSoftware = new BRAVO::OM::InstalledSoftware();
   $installedSoftware->id($installedSoftwareId);

   my $softwareLpar = new BRAVO::OM::SoftwareLpar();
   $softwareLpar->customerId($customerId);

   my $queue =
     Recon::Queue->new( $self->connection, $installedSoftware, $softwareLpar,
    'LICENSING' );
   $queue->add;

   dlog("appened into licensing queue");
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

1;
