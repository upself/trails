package integration::reconEngine::TestScheduleFOnHostDefinedActive;

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
   "select sf.id,sf.status_id as STATUS
 from 
 schedule_f sf, 
 installed_software is, 
 software_lpar sl, 
 software_item si
 where 
 is.software_id = si.id
 and is.software_lpar_id = sl.id
 and is.id = ?
 and sf.software_id = si.id
 and sf.software_name = si.name
 and sf.customer_id = sl.customer_id
 and sf.hostname = sl.name",
   $self->installedSoftwareId
  ],
  tests       => { "==" => { STATUS => 2 } },
  description => $self->label
    . ", schedule f on host name level defiend and active"    
 );
}

1;

