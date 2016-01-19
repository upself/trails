package integration::reconEngine::Tests::TC5;

use strict;
use base 'integration::reconEngine::TestBase';
use Test::More;
use Test::File;
use Test::DatabaseRow;

use integration::reconEngine::TestLogFileClean;
use integration::reconEngine::TestAlertClosed;
use integration::reconEngine::TestReconEngineConfig;
use integration::reconEngine::TestReconInstalledSoftwareExist;
use integration::reconEngine::TestScarletLicenseAPIValid;
use integration::reconEngine::TestScarletReconcileExist;
use integration::reconEngine::TestLogScarletSoftwareMap;

sub _01_story36172_reRunReconEngineAgainstClosedAlerts : Test(14) {    
 my $self = shift;

 integration::reconEngine::TestAlertClosed->new($self)->test;
 integration::reconEngine::TestScarletReconcileExist->new($self)->test;
 integration::reconEngine::TestReconEngineConfig->new($self)->test;
 integration::reconEngine::TestLogFileClean->new($self)->test;
 
 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareExist->new($self)->test;

 $self->launchReconEngine;
 
 integration::reconEngine::TestAlertClosed->new($self)->test;
 integration::reconEngine::TestLogReconQuitNoError->new($self)->test;
 integration::reconEngine::TestLogScarletSoftwareMap->new($self)->test;
 integration::reconEngine::TestScarletReconcileExist->new($self)->test;
}

sub sweep : Test( shutdown => 2 ) {
 my $self = shift;

 integration::reconEngine::TestLogFileClean->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;

}

1;

