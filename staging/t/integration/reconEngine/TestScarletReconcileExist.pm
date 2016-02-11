package integration::reconEngine::TestReconcileOnMachineLevel;

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
   'select machine_level as LEVEL 
    from reconcile r
    where r.installed_software_id =?',    
   $self->installedSoftwareId
  ],
  tests       => { "==" => { LEVEL => 1 } },
  description => "reconciled on machie level"
 );
}

1;

