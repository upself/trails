package integration::reconEngine::TestBase;

use strict;
use base
  qw(Test::Class
  integration::reconEngine::Properties
  integration::LogManager
  integration::TestUtils);
use Test::More;
use Test::File;
use Test::Cmd::Common;
use Test::DatabaseRow;

use File::Overwrite;
use Config::Properties;

use Base::Utils;
use Base::ConfigManager;

use Recon::LicensingReconEngineCustomer;
use Recon::LicensingInstalledSoftware;
use Recon::OM::Reconcile;
use Recon::Delegate::ReconDelegate;

use Scarlet::LicenseEndpoint;

sub init : Test(startup) {
 my $self = shift;

 $self->isPool(0);
 $self->installedSoftwareId(240451553);
 $self->customerId(7458);
 $self->date('2099-01-01');
 $self->reconConfigFile('integration/reconEngine/Tests/reconEnginConf.txt');
 $self->logFile('/tmp/reconEngine.log');
 $self->connCfgFile('/opt/staging/v2/config/connectionConfig.txt');
 $self->connection( Database::Connection->new('trails') );

 $self->connection->connect;
 $self->configDebugLevel( $self->logFile );    

}

sub breakReconcile {
 my $self = shift;

 my $reconcile = $self->findReconcile();

 if ( defined $reconcile->id ) {
  my $is = BRAVO::OM::InstalledSoftware->new();
  $is->id( $self->installedSoftwareId );
  $is->getById( $self->connection );

  my $lis =
    Recon::LicensingInstalledSoftware->new( $self->connection, $is,
   $self->isPool );
  $lis->setUp;

  $self->breakMachineLevelReconcile($lis);

  $lis->openAlertUnlicensedSoftware();
  Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
   $reconcile->id );
 }

}

sub breakMachineLevelReconcile {
 my $self = shift;
 my $lis  = shift;

 my $reconciles =
   $lis->getExistingMachineLevelRecon(
  $lis->installedSoftwareReconData->scopeName );

 foreach my $reconcileId ( sort keys %{$reconciles} ) {
  my $r = new Recon::OM::Reconcile();
  $r->id($reconcileId);
  $r->getById( $self->connection );

  my $installedSoftware = new BRAVO::OM::InstalledSoftware();
  $installedSoftware->id( $r->installedSoftwareId );
  $installedSoftware->getById( $self->connection );

  my $recon =
    Recon::LicensingInstalledSoftware->new( $self->connection,
   $installedSoftware );
  $recon->setUp;

  $recon->openAlertUnlicensedSoftware();
  Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
   $r->id );
 }
}

sub findReconcile {
 my $self = shift;

 my $reconcile = new Recon::OM::Reconcile;
 $reconcile->installedSoftwareId( $self->installedSoftwareId );
 $reconcile->getByBizKey( $self->connection );

 return $reconcile;
}

sub singleResultQuery {
 my $self      = shift;
 my $queryName = shift;
 my $query     = shift;

 if ( ref($query) eq 'ARRAY' ) {
  $self->connection->prepareSqlQuery( $queryName, $query->[0] );
 }
 else {
  $self->connection->prepareSqlQuery( $queryName, $query );
 }
 my $sth = $self->connection->sql->{$queryName};
 my $result;
 $sth->bind_columns( \$result );
 if ( ref($query) eq 'ARRAY' && scalar @{$query} >= 1 ) {
  for ( my $i = 1 ; $i < scalar @{$query} ; $i++ ) {
   $sth->bind_param( $i, $query->[$i] );
  }
 }
 $sth->execute();
 $sth->fetchrow_arrayref;
 $sth->finish;

 return $result;
}

sub launchReconEngine {
 my $self        = shift;
 my $reconEngine =
   new Recon::LicensingReconEngineCustomer( $self->customerId, $self->date,
  $self->isPool );
 $reconEngine->recon;
}

1;

