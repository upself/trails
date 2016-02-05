package integration::reconEngine::Tests::TC6;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use Test::More;
use Test::DatabaseRow;
use Recon::ScarletReconcile;
use integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate;
use integration::reconEngine::TestScarletReconcileExist;
use integration::reconEngine::CmdCreateReconInstalledSw;
use integration::reconEngine::CmdBreakReconcileIfExists;

sub restoreConfigFile : Test( shutdown => 1 ) {
 my $self = shift;
 my $label = ( caller(0) )[3];

 $self->resetGuid;
 $self->resetLicenseAPI;
 $self->resetParent;

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;
}

sub _01_story39320_scarletReconileWillDelete : Test(7) {
 my $self = shift;
 my $label = ( caller(0) )[3];

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

 my $r = Recon::ScarletReconcile->new(0);
 $r->validate( $reconcile->id );

 #reconcile not changed scarlet reconcile should not deleted.
 integration::reconEngine::TestScarletReconcileExist->new($self)->test;

 #change reconcile type id from 5 to anyone else.
 $reconcile->reconcileTypeId(3);
 $reconcile->save( $self->connection );

 my $r2 = Recon::ScarletReconcile->new(0);
 $r2->validate( $reconcile->id );

 #reconcile changed scarlet reconcile will deleted.
 integration::reconEngine::TestScarletReconcileNotExist->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate->new(
  $self)->test;

}
1;

