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
use integration::reconEngine::CmdCreateReconInstalledSw;


sub _01_story36172_reRunReconEngineAgainstClosedAlerts : Test(14) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 integration::reconEngine::TestAlertClosed->new( $self, $label )->test;
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;
 integration::reconEngine::TestReconEngineConfig->new( $self, $label )->test;
 integration::reconEngine::TestLogFileClean->new( $self,      $label )->test;

 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareExist->new( $self, $label )
   ->test;

 $self->launchReconEngine;

 integration::reconEngine::TestAlertClosed->new( $self, $label )
   ->test;    
 integration::reconEngine::TestLogReconQuitNoError->new( $self, $label )->test;
 integration::reconEngine::TestLogScarletSoftwareMap->new( $self, $label )
   ->test;
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;
}

sub sweep : Test( shutdown => 2 ) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 integration::reconEngine::TestLogFileClean->new( $self, $label )->test;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new( $self,
  $label )->test;


}

1;

