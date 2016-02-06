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
 my $label = ( caller(0) )[3];

 $self->connectionFile( $self->connCfgFile );
 $self->setLicenseAPIInvalid;

 integration::reconEngine::TestScarletLicenseAPIInvalid->new($self,$label)->test;

 $self->breakReconcile;
 integration::reconEngine::TestAlertOpen->new($self,$label)->test;
 integration::reconEngine::TestReconEngineConfig->new($self,$label)->test;
 integration::reconEngine::TestLogFileClean->new($self,$label)->test;

 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;    
 integration::reconEngine::TestReconInstalledSoftwareExist->new($self,$label)->test;

 $self->launchReconEngine;
 integration::reconEngine::TestAlertOpen->new($self,$label)->test;
 integration::reconEngine::TestLogReconQuitWithError->new($self,$label)->test;
 integration::reconEngine::TestScarletReconcileNotExist->new($self,$label)->test;
}

sub sweep : Test( shutdown => 3 ) {
 my $self = shift;
 my $label = ( caller(0) )[3];

 integration::reconEngine::TestLogFileClean->new($self),$label->test;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self,$label)->test;

 $self->connectionFile( $self->connCfgFile );
 $self->resetLicenseAPI;

 integration::reconEngine::TestScarletLicenseAPIValid->new($self,$label)->test;
}

1;

