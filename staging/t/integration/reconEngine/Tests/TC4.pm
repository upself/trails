package integration::reconEngine::Tests::TC4;

use strict;
use base 'integration::reconEngine::TestBase';
use Test::More;
use Test::File;
use Test::DatabaseRow;

use integration::reconEngine::TestScarletLicenseAPIInvalid;
use integration::reconEngine::TestLogFileClean;
use integration::reconEngine::TestAlertOpen;
use integration::reconEngine::TestReconEngineConfig;
use integration::reconEngine::TestReconInstalledSoftwareExist;
use integration::reconEngine::TestScarletLicenseAPIValid;

sub _01_story36172_isScarletAPIInvalid : Test(12) {
 my $self = shift;

 my $value = 'http://localhost:8080/springrest/license/invalid';
 my $key   = 'scarlet.license';
 $self->changeFileProperty( $self->connCfgFile, $key, $value );

 integration::reconEngine::TestScarletLicenseAPIInvalid->new($self)->test;

 $self->breakReconcile;
 integration::reconEngine::TestAlertOpen->new($self)->test;
 integration::reconEngine::TestReconEngineConfig->new($self)->test;
 integration::reconEngine::TestLogFileClean->new($self)->test;

 integration::reconEngine::TestReconInstalledSoftwareExist->new($self)->test;

 $self->launchReconEngine;
 integration::reconEngine::TestAlertOpen->new($self)->test;
 integration::reconEngine::TestLogReconQuitNoError->new($self)->test;
 integration::reconEngine::TestScarletReconcileNotExist->new($self)->test;
}

sub sweep : Test( shutdown => 3 ) {    
 my $self = shift;

 integration::reconEngine::TestLogFileClean->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;

 my $value = 'http://localhost:8080/springrest/license';
 my $key   = 'scarlet.license';
 $self->changeFileProperty( $self->connCfgFile, $key, $value );

 integration::reconEngine::TestScarletLicenseAPIValid->new($self)->test;
}

1;

