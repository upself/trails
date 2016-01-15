package integration::reconEngine::Tests::TC3;

use strict;
use base 'integration::reconEngine::TestBase';
use Test::More;
use Test::File;
use Test::DatabaseRow;

use Recon::OM::ScarletReconcile;

use integration::reconEngine::TestScarletReconcileNotExist;
use integration::reconEngine::TestAlertClosed;
use integration::reconEngine::TestReconEngineConfig;
use integration::reconEngine::TestReconInstalledSoftwareExist;
use integration::reconEngine::TestAlertOpen;
use integration::reconEngine::TestLogReconQuitNoError;
use integration::reconEngine::TestLogFileClean;

sub _01_story36172_isScarletReconcileDelete : Test(3) {
 my $self = shift;

 my $reconcile = $self->findReconcile;
 my $sr        = Recon::OM::ScarletReconcile->new();
 $sr->id( $reconcile->id );
 $sr->delete( $self->connection );

 integration::reconEngine::TestScarletReconcileNotExist->new($self)->test;
 integration::reconEngine::TestAlertClosed->new($self)->test;

}

sub _02_story36172_launchReconEngineCheckAlertOpen : Test(8) {    
 my $self = shift;

 integration::reconEngine::TestReconEngineConfig->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareExist->new($self)->test;
 integration::reconEngine::TestLogFileClean->new($self)->test;

 $self->launchReconEngine;

 integration::reconEngine::TestAlertOpen->new($self)->test;
 integration::reconEngine::TestLogReconQuitNoError->new($self)->test;

}

sub cleanLogFile : Test( shutdown => 1 ) {
 my $self = shift;

 integration::reconEngine::TestLogFileClean->new($self)->test;
}

1;

