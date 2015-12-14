package integration::reconEngine::Story36172_TC1;

use base 'Test::Class';
use Test::More;
use Test::File;
use Test::Cmd::Common;
use Test::DatabaseRow;

use File::Overwrite;

use Base::Utils;
use Base::ConfigManager;
use Recon::LicensingReconEngineCustomer;
use Recon::LicensingInstalledSoftware;
use Recon::OM::Reconcile;
use Recon::Delegate::ReconDelegate;
use Scarlet::LicenseEndpoint;
use integration::reconEngine::ReconInstalledSoftware;

sub TC1 : Tests(16) {
 my $self = shift;

 my $connectionConfig = '/opt/staging/v2/config/connectionConfig.txt';
 file_contains_like(
  $connectionConfig,
  qr{scarlet\.license\s*=\s*http},
  'check connection config - scarlet license api defined'
 );

 my $opt_f = 'integration/reconEngine/Story36172/reconEnginConf.txt';
 file_contains_like( $opt_f, qr{testMode\s*=\s*0},
  'check recon engine config - testMode=0' );
 file_contains_like( $opt_f, qr{debugLevel\s*=\s*debug},
  'check recon engine config - debugLevel=debug' );

 my $accountNo     = '84690';
 my $opt_c         = '7458';
 my $opt_d         = '2099-01-01';
 my $opt_p         = 0;
 my $opt_l         = '/tmp/reconEngine.log.child.7458';
 my $installedSwId = '240451553';
 my $guid          = '96804d13f07b4d1d8371942fc6449ea7';

 $self->{logFile} = $opt_l;
 unlink($opt_l) if ( -e $opt_l );
 file_not_exists_ok( $opt_l, 'log file not exists' );

 $self->configLog( $opt_f, $opt_l );

 my $licenseEndpoint = Scarlet::LicenseEndpoint->new;
 $licenseEndpoint->httpGet( $accountNo, $guid );

 ok(
  $licenseEndpoint->outOfService eq 0,
  'scarlet license endpoint function good'
 );

 my $conn = Database::Connection->new('trails');
 $conn->connect;

 my $reconcile = new Recon::OM::Reconcile;
 $reconcile->installedSoftwareId($installedSwId);
 $reconcile->getByBizKey($conn);

 if ( defined $reconcile->id ) {
  my $is = BRAVO::OM::InstalledSoftware->new();
  $is->id($installedSwId);
  $is->getById($conn);

  my $lis = Recon::LicensingInstalledSoftware->new( $conn, $is, $opt_p );
  $lis->setUp;
  $lis->openAlertUnlicensedSoftware();

  Recon::Delegate::ReconDelegate->breakReconcileById( $conn, $reconcile->id );
 }

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "select * from reconcile where installed_software_id = ?",
   $installedSwId
  ],
  results     => 0,
  description => "installed software $installedSwId not recocniled"
 );

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "select OPEN 
   from alert_unlicensed_sw where installed_software_id = ?",
   $installedSwId
  ],
  tests => { "==" => { OPEN => 1 } },
  description => "open alert exists on installed software $installedSwId"
 );

 my $reconInstalledSoftware =
   integration::reconEngine::ReconInstalledSoftware->new();
 $reconInstalledSoftware->installedSoftwareId($installedSwId);
 $reconInstalledSoftware->customerId($opt_c);
 $reconInstalledSoftware->recordTime( $opt_d . ' 09:00:00' );
 $reconInstalledSoftware->remoteUser('TC1');
 $reconInstalledSoftware->action('LICENSING');
 $reconInstalledSoftware->save($conn);

 $self->{trailsConnection}  = $conn;
 $self->{installedSoftware} = $reconInstalledSoftware;

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "SELECT 
    action, date(record_time) as DATE, customer_id
    FROM recon_installed_sw WHERE installed_software_id = ? 
    and action ='LICENSING'",
   $installedSwId
  ],
  tests => {
   "eq" => { ACTION      => "LICENSING", DATE => $opt_d },
   "==" => { CUSTOMER_ID => $opt_c }
  },
  description => "installed software $installedSwId exist in recon_installed_sw"
 );

 my $reconEngine =
   new Recon::LicensingReconEngineCustomer( $opt_c, $opt_d, $opt_p );
 $reconEngine->recon;

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "select * from reconcile where installed_software_id = ?",
   $installedSwId
  ],
  description => "reconcil built"
 );

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "select count(*) as QTY from 
   reconcile r, 
   reconcile_used_license rul, 
   used_license ul
   where r.id = rul.reconcile_id 
     and rul.used_license_id = ul.id
    and r.installed_software_id = ?", $installedSwId
  ],
  tests       => { ">=" => { QTY => 1 } },
  description => 'used license built'
 );

 row_ok(
  dbh => $conn->dbh,
  sql => [
   "select * from scarlet_reconcile sr, reconcile r
 where sr.id = r.id and r.installed_software_id = ?", $installedSwId
  ],
  description => "scarlet reconcile created"
 );

 file_contains_like(
  $opt_l,
  qr{license\(s\) found from scarlet},
  'check log - fetch license from scarlet'
 );

 file_contains_like(
  $opt_l,
  qr{scarlet reconcile built},
  'check log - scarlet reconcile built'
 );

 file_contains_like(
  $opt_l,
  qr{end closeAlertUnlicensedSoftware},
  'check log - alert closed'
 );

 file_contains_like(
  $opt_l,
  qr{returning to caller},
  'check log - return to caller'
 );
 file_contains_unlike( $opt_l, qr{ERROR}, 'check log - no error' );

}

sub sweep_recon_queue : Test(shutdown) {
 my $self                   = shift;
 my $trailsConn             = $self->{trailsConnection};
 my $reconInstalledSoftware = $self->{installedSoftware};

 if (defined $reconInstalledSoftware
  || defined $trailsConn )
 {
  $reconInstalledSoftware->delete($trailsConn);
 }

 not_row_ok(
  dbh => $trailsConn->dbh,
  sql => [
   "select * from recon_installed_sw where installed_software_id = ?",
   $reconInstalledSoftware->id
  ],
  description => "recon queue swept"    
 );
}

sub sweep_file_system : Test( shutdown => 1 ) {
 my $self = shift;

 my $logFile = $self->{logFile};

 unlink($logFile) if ( -e $logFile );

 file_not_exists_ok( $logFile, 'log file swept' );
}

sub configLog {
 my ( $self, $opt_f, $opt_l ) = @_;

 my $cfgMgr = Base::ConfigManager->instance($opt_f);
 logfile($opt_l);
 logging_level( $cfgMgr->debugLevel );
}

1;

