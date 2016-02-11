package integration::reconEngine::CmdBreakReconcileIfExists;

use strict;
use base qw(integration::reconEngine::Properties);
use Recon::OM::AlertUnlicensedSoftware;

sub new {
 my ( $class, $properties ) = @_;

 my $self = $class->SUPER::new($properties);

 bless $self, $class;
 return $self;

}

sub execute {
 my $self = shift;

 my $reconcile = $self->findReconcile();

 my $hadSetup = 0;

 my $is = BRAVO::OM::InstalledSoftware->new();
 $is->id( $self->installedSoftwareId );
 $is->getById( $self->connection );

 my $lis =
   Recon::LicensingInstalledSoftware->new( $self->connection, $is,
  $self->isPool );

 if ( defined $reconcile->id ) {

  $lis->setUp;
  $hadSetup = 1;

  $self->breakMachineLevelReconcile($lis);
  Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
   $reconcile->id );
 }

 my $aus = Recon::OM::AlertUnlicensedSoftware->new;
 $aus->installedSoftwareId( $is->id );
 $aus->getByBizKey( $self->connection );

 if ( not $aus->open ) {
  if ( not $hadSetup ) {
   $lis->setUp;
  }
  $lis->openAlertUnlicensedSoftware();    
 }

}

sub findReconcile {
 my $self = shift;

 my $reconcile = new Recon::OM::Reconcile;
 $reconcile->installedSoftwareId( $self->installedSoftwareId );
 $reconcile->getByBizKey( $self->connection );

 return $reconcile;
}

sub breakMachineLevelReconcile {
 my $self = shift;
 my $lis  = shift;

 my $reconciles =
   $lis->getExistingMachineLevelReconLegacy(
  $lis->installedSoftwareReconData->scopeName );

 foreach my $reconcileId ( sort keys %{$reconciles} ) {
  my $r = new Recon::OM::Reconcile();
  $r->id($reconcileId);
  $r->getById( $self->connection );

  my $installedSoftware = new BRAVO::OM::InstalledSoftware();
  $installedSoftware->id( $r->installedSoftwareId );
  $installedSoftware->getById( $self->connection );

  my $recon =
    Recon::LicensingInstalledSoftware->new( $self->connection,
   $installedSoftware );
  $recon->setUp;

  $recon->openAlertUnlicensedSoftware();
  Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
   $r->id );
 }
}

1;

