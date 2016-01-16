package integration::reconEngine::Tests::TC2;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);
use Test::More;
use Test::File;
use Test::DatabaseRow;

use integration::reconEngine::TestReconInstalledSoftwareExist;
use integration::reconEngine::TestScarletReconcileExist;
use integration::reconEngine::TestReconcileUsedLicenseExist;
use integration::reconEngine::TestLogScarletSoftwareMap;
use integration::reconEngine::TestLogAlertClosed;
use integration::reconEngine::TestLogReconQuitNoError;

sub _01_story36172_isScarletReconcileBuilt : Test(1) {
 my $self = shift;

 integration::reconEngine::TestScarletReconcileExist->new($self)->test;
}

sub _02_story36172_isReconQueueReady : Test(1) {
 my $self = shift;
 integration::reconEngine::TestReconInstalledSoftwareExist->new($self)->test;
}

sub _03_story36172_setInvalidAPIInConnectionConfig : Test(1) {
 my $self = shift;

 $self->setLicenseAPIInvalid;

 file_contains_like( $self->connectionFile, qr{scarlet.license.*invalid},
  'check connection config - license api set to invalid' );

}

sub _04_story36172_launchReconEngine : Test(8) {
 my $self = shift;

 my $reconEngine =
   new Recon::LicensingReconEngineCustomer( $self->customerId, $self->date,
  $self->isPool );
 $reconEngine->recon;

 integration::reconEngine::TestReconcileUsedLicenseExist->new($self)->test;
 integration::reconEngine::TestScarletReconcileExist->new($self)->test;
 integration::reconEngine::TestLogScarletSoftwareMap->new($self)->test;
 integration::reconEngine::TestLogAlertClosed->new($self)->test;
 integration::reconEngine::TestLogReconQuitNoError->new($self)->test;
}

sub restoreConnectionConfig : Test( shutdown => 1 ) {
 my $self = shift;

 $self->resetLicenseAPI;

 file_contains_like(
  $self->connectionFile, qr{scarlet.license.*license},    
  'check connection config - license api restored'
 );
}

sub shutdown : Test( shutdown => 1 ) {
 my $self = shift;
 integration::reconEngine::TestLogFileClean->new($self)->test;
}

1;

