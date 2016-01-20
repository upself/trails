package integration::reconEngine::Tests::TC4;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);
use Test::More;
use Test::File;
use Test::DatabaseRow;

use integration::reconEngine::TestScarletLicenseAPIInvalid;
use integration::reconEngine::TestLogFileClean;
use integration::reconEngine::TestAlertOpen;
use integration::reconEngine::TestReconEngineConfig;
use integration::reconEngine::TestReconInstalledSoftwareExist;
use integration::reconEngine::TestScarletLicenseAPIValid;
use integration::reconEngine::TestLogReconQuitWithError;

sub _01_story36172_isScarletAPIInvalid : Test(12) {
 my $self = shift;

 $self->connectionFile( $self->connCfgFile );
 $self->setLicenseAPIInvalid;

 integration::reconEngine::TestScarletLicenseAPIInvalid->new($self)->test;

 $self->breakReconcile;
 integration::reconEngine::TestAlertOpen->new($self)->test;
 integration::reconEngine::TestReconEngineConfig->new($self)->test;
 integration::reconEngine::TestLogFileClean->new($self)->test;

 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;    
 integration::reconEngine::TestReconInstalledSoftwareExist->new($self)->test;

 $self->launchReconEngine;
 integration::reconEngine::TestAlertOpen->new($self)->test;
 integration::reconEngine::TestLogReconQuitWithError->new($self)->test;
 integration::reconEngine::TestScarletReconcileNotExist->new($self)->test;
}

sub sweep : Test( shutdown => 3 ) {
 my $self = shift;

 integration::reconEngine::TestLogFileClean->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;

 $self->connectionFile( $self->connCfgFile );
 $self->resetLicenseAPI;

 integration::reconEngine::TestScarletLicenseAPIValid->new($self)->test;
}

1;

