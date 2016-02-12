package integration::reconEngine::TestAlertOpen;

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

 row_ok(
  dbh => $self->connection->dbh,
  sql => [
   "select * from reconcile where installed_software_id = ?",
   $self->installedSoftwareId
  ],
  results     => 0,
  description => $self->label . " installed software not reconciled"
 );

 row_ok(
  dbh => $self->connection->dbh,
  sql => [
   "select OPEN 
   from alert_unlicensed_sw where installed_software_id = ?",
   $self->installedSoftwareId
  ],
  tests       => { "==" => { OPEN => 1 } },
  description => $self->label . ", alert is open" 
 );

}

1;

