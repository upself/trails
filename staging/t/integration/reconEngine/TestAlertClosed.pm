package integration::reconEngine::TestAlertClosed;

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

 row_ok(
  dbh => $self->connection->dbh,
  sql => [
   "select count(*) as QTY from reconcile where installed_software_id = ?",
   $self->installedSoftwareId
  ],
  test        => { ">=" => { QTY => 1 } },
  description => "installed software reconciled"
 );

 row_ok(
  dbh => $self->connection->dbh,
  sql => [
   "select OPEN 
   from alert_unlicensed_sw where installed_software_id = ?",
   $self->installedSoftwareId
  ],
  tests       => { "==" => { OPEN => 0 } },
  description => "alert is closed" 
 );

}

1;

