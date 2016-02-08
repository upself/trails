package integration::reconEngine::TestReconInstalledSoftwareNotExist;

use strict;
use base qw(integration::reconEngine::Properties);

use Test::DatabaseRow;
use Test::More;

sub new {
 my ( $class, $properties, $label ) = @_;

 my $self = $class->SUPER::new($properties);
 $self->{_label} = $label;

 bless $self, $class;
 return $self;

}

sub label {
 my $self = shift;
 $self->{_label} = shift
   if scalar @_ == 1;
 return $self->{_label};
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
  description => $self->label . ", recon queue is clean"    
 );

}

1;

