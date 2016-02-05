package integration::reconEngine::Tests::TC6;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use Test::More;
use Test::DatabaseRow;
use Recon::ScarletReconcile;
use integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate;
use integration::reconEngine::CmdCreateReconInstalledSw;
use integration::reconEngine::CmdBreakReconcileIfExists;

sub restoreConfigFile : Test( shutdown => 1 ) {
 my $self = shift;

 $self->resetGuid;
 $self->resetLicenseAPI;
 $self->resetParent;

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;
}

sub _01_story39320_scarletReconileWillDelete : Test(6) {
 my $self = shift;

 $self->mockLicenseAPI;
 $self->mockGuidAPI;
 integration::reconEngine::CmdBreakReconcileIfExists->new($self)->execute;
 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 $self->launchReconEngine;

 my $reconcile = $self->findReconcile;
 ok( $reconcile->id, 'reconcile found' );

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;

 integration::reconEngine::TestScarletReconcileExist->new($self)->test;
 is( $reconcile->reconcileTypeId, 5, 'reconile type id is 5' );

 #change reconcile type id from 5 to anyone else.
 $reconcile->reconcileTypeId(3);
 $reconcile->save( $self->connection );

 my $r = Recon::ScarletReconcile->new(0);
 $r->validate( $reconcile->id );    

 #validate reuslt.
 integration::reconEngine::TestScarletReconcileNotExist->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate->new(
  $self)->test;

}

1;

