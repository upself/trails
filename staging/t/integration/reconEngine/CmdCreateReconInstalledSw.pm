package integration::reconEngine::CmdCreateReconInstalledSw;

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

 my $reconInstalledSoftware =
   integration::reconEngine::ReconInstalledSoftware->new();
 $reconInstalledSoftware->installedSoftwareId( $self->installedSoftwareId );
 $reconInstalledSoftware->customerId( $self->customerId );
 $reconInstalledSoftware->recordTime( $self->date . ' 09:00:00' );
 $reconInstalledSoftware->remoteUser('TC1');
 $reconInstalledSoftware->action('LICENSING');
 $reconInstalledSoftware->save( $self->connection );

 
}

1;

