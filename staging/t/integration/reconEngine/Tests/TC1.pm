package integration::reconEngine::Tests::TC1;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);
use Test::More;
use Test::File;
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

use integration::reconEngine::TestReconInstalledSoftwareExist;
use integration::reconEngine::TestScarletReconcileExist;
use integration::reconEngine::TestReconcileUsedLicenseExist;
use integration::reconEngine::TestReconEngineConfig;
use integration::reconEngine::TestReconInstalledSoftwareNotExist;
use integration::reconEngine::TestAlertOpen;
use integration::reconEngine::TestScarletLicenseAPIDefined;
use integration::reconEngine::TestLogReconQuitNoError;
use integration::reconEngine::TestLogScarletBuilt;
use integration::reconEngine::TestLogAlertClosed;
use integration::reconEngine::TestLogFileClean;

use integration::reconEngine::CmdCreateReconInstalledSw;
use integration::reconEngine::CmdCleanReconInstalledSoftware;

sub _01_story36172_checkConfiguration : Test(5) {
 my $self = shift;

 $self->{connectionFile} = "/opt/staging/v2/config/connectionConfig.txt";
 $self->resetLicenseAPI;
 integration::reconEngine::TestScarletLicenseAPIDefined->new($self)->test;

 my $accountNo       = '84690';
 my $guid            = '96804d13f07b4d1d8371942fc6449ea7';
 my $licenseEndpoint = Scarlet::LicenseEndpoint->new;
 $licenseEndpoint->httpGet( $accountNo, $guid );

 is( $licenseEndpoint->outOfService,
  0, 'scarlet license endpoint function good' )
   or return 'scarlet not reachalbe';

 integration::reconEngine::TestReconEngineConfig->new($self)->test;
 integration::reconEngine::TestLogFileClean->new($self)->test;
}

sub _04_story36172_isReconcileValid : Test(2) {
 my $self = shift;

 $self->breakReconcile;

 integration::reconEngine::TestAlertOpen->new($self)->test;
}

sub _05_story36172_isReconQueueReady : Test(1) {
 my $self = shift;
 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 
 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareExist->new($self)->test;
}

sub _06_story36172_launchReconEngineCheck : Test(8) {
 my $self = shift;

 $self->mockGuidAPI;
 $self->mockLicenseAPI;
 my $reconEngine =
   new Recon::LicensingReconEngineCustomer( $self->customerId, $self->date,
  $self->isPool );
 $reconEngine->recon;

 integration::reconEngine::TestReconcileUsedLicenseExist->new($self)->test;
 integration::reconEngine::TestScarletReconcileExist->new($self)->test;

 integration::reconEngine::TestLogScarletBuilt->new($self)->test;
 integration::reconEngine::TestLogAlertClosed->new($self)->test;
 integration::reconEngine::TestLogReconQuitNoError->new($self)->test;

}

sub shutdown : Test( shutdown => 2 ) {
 my $self = shift;
 $self->resetGuid;
 $self->resetLicenseAPI;

 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;
 integration::reconEngine::TestLogFileClean->new($self)->test;
}

1;

