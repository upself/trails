package integration::reconEngine::CmdCleanReconInstalledSoftware;

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

 my $sql =
   "delete from recon_installed_sw where installed_software_id = ? 
    and action = 'LICENSING' ";

 $self->connection->prepareSqlQuery( 'queryCleanReconInstalledSoftware', $sql );
 my $sth = $self->connection->sql->{queryCleanReconInstalledSoftware};
 $sth->execute( $self->installedSoftwareId );
 $sth->finish;
}

1;

