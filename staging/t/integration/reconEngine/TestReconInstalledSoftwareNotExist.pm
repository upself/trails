package integration::reconEngine::TestReconInstalledSoftwareNotExist;

use strict;
use base qw(integration::reconEngine::Properties);

use Test::DatabaseRow;
use Test::More;

sub new {
 my ( $class, $properties ) = @_;

 my $self = $class->SUPER::new($properties);

 bless $self, $class;
 return $self;

}

sub test {
 my $self = shift;

 not_row_ok(
  dbh => $self->connection->dbh,
  sql => [
   "select * from recon_installed_sw where installed_software_id = ? 
    and action = 'LICENSING' ",
   $self->installedSoftwareId
  ],
  description => "recon queue is clean"
 );

}

1;

