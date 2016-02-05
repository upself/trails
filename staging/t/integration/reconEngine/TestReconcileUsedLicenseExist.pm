package integration::reconEngine::TestReconcileUsedLicenseExist;

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
  description => $self->label . ", reconcil exist"
 );

 row_ok(
  dbh => $self->connection->dbh,
  sql => [
   "select count(*) as QTY from 
   reconcile r, 
   reconcile_used_license rul, 
   used_license ul
   where r.id = rul.reconcile_id 
     and rul.used_license_id = ul.id
    and r.installed_software_id = ?", $self->installedSoftwareId
  ],
  tests       => { ">=" => { QTY => 1 } },
  description => $self->label . ', used license exist' 
 );
}

1;

