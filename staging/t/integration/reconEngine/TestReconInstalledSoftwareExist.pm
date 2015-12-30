package integration::reconEngine::TestReconInstalledSoftwareExist;

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

 my $reconInstalledSoftware =
   integration::reconEngine::ReconInstalledSoftware->new();
 $reconInstalledSoftware->installedSoftwareId( $self->installedSoftwareId );
 $reconInstalledSoftware->customerId( $self->customerId );
 $reconInstalledSoftware->recordTime( $self->date . ' 09:00:00' );
 $reconInstalledSoftware->remoteUser('TC1');
 $reconInstalledSoftware->action('LICENSING');
 $reconInstalledSoftware->save( $self->connection );    

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
   "eq" => { ACTION      => "LICENSING", DATE => $self->date },
   "==" => { CUSTOMER_ID => $self->customerId }
  },
  description => "installed software exist in recon_installed_sw"
 );
}

1;

