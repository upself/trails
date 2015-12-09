package integration::reconEngine::Story36172_TC1;

use base 'Test::Class';
use Test::More;
use Test::File;
use Test::Cmd::Common;
use Test::DatabaseRow;

use Base::Utils;
use Base::ConfigManager;
use Recon::LicensingReconEngineCustomer;
use Scarlet::LicenseEndpoint;

sub TC1 : Tests(7) {
 my $self = shift;

 my $connectionConfig = '/opt/staging/v2/config/connectionConfig.txt';
 file_contains_like( $connectionConfig, qr{scarlet\.license\s*=\s*http} );

 my $opt_f = 'integration/reconEngine/Story36172/reconEnginConf.txt';

 #2 checkers here;
 file_contains_like( $opt_f,
  [ qr{testMode\s*=\s*0}, qr{debugLevel\s*=\s*debug} ] );

 my $opt_c         = '7458';
 my $opt_d         = '2099-01-01';
 my $opt_p         = 0;
 my $opt_l         = '/tmp/reconEngine.log.child.7458';
 my $installedSwId = '240451553';
 my $guid          = '96804d13f07b4d1d8371942fc6449ea7';

 $self->configLog( $opt_f, $opt_l );

 my $scarletEndpoint = Scarlet::LicenseEndpoint->new;
 $scarletEndpoint->httpGet( $opt_c, $guid );

 ok( not $scarletEndpoint->outOfService, 'scarlet status' );    

 my $conn = Database::Connection->new('trails');
 $conn->connect;

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "SELECT 
    action, date(record_time) as DATE, customer_id
    FROM recon_installed_sw WHERE installed_software_id = ?",
   $installedSwId
  ],
  tests => {
   "eq" => { ACTION      => "LICENSING", DATE => $opt_d },
   "==" => { CUSTOMER_ID => $opt_c }
  },
  description => "$installedSwId exist in recon qeuue"
 );

 my $reconEngine =
   new Recon::LicensingReconEngineCustomer( $opt_c, $opt_d, $opt_p );
 $reconEngine->recon;

 file_contains_like( $opt_l, qr{returning to caller} );
 file_contains_unlike( $opt_l, qr{ERROR} );

}

sub configLog {
 my ( $self, $opt_f, $opt_l ) = @_;

 my $cfgMgr = Base::ConfigManager->instance($opt_f);
 logfile($opt_l);
 logging_level( $cfgMgr->debugLevel );
}

1;

