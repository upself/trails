package integration::reconEngine::TestScarletReconcileExist;

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
   'select count(*) as QTY 
    from reconcile r, scarlet_reconcile sr
    where r.id = sr.id and r.installed_software_id =?',
   $self->installedSoftwareId
  ],
  tests       => { ">" => { QTY => 0 } },
  description => "scarlet reconcile exists"
 );
}

1;

