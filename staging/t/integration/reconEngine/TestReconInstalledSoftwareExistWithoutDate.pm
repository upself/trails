package integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate;

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
   "SELECT 
    action, date(record_time) as DATE, customer_id
    FROM recon_installed_sw WHERE installed_software_id = ? 
    and action ='LICENSING'",
   $self->installedSoftwareId
  ],
  tests => {
   "eq" => { ACTION      => "LICENSING" },
   "==" => { CUSTOMER_ID => $self->customerId }
  },
  description => $self->label
    . ", installed software exist in recon_installed_sw"    
 );
}

1;

