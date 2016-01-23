package integration::reconEngine::CmdBreakReconcileIfExists;

use strict;
use base qw(integration::reconEngine::Properties);    

sub new {
 my ( $class, $properties ) = @_;

 my $self = $class->SUPER::new($properties);

 bless $self, $class;
 return $self;

}

sub execute {
 my $self = shift;

 my $reconcile = $self->findReconcile();

 if ( defined $reconcile->id ) {
  my $is = BRAVO::OM::InstalledSoftware->new();
  $is->id( $self->installedSoftwareId );
  $is->getById( $self->connection );

  my $lis =
    Recon::LicensingInstalledSoftware->new( $self->connection, $is,
   $self->isPool );
  $lis->setUp;

  $self->breakMachineLevelReconcile($lis);

  $lis->openAlertUnlicensedSoftware();
  Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
   $reconcile->id );
 }

}

1;

