package integration::reconEngine::Tests::TC6;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use Test::More;
use Test::DatabaseRow;
use integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate;

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

 my $reconcile = $self->findReconcile;
 ok( $reconcile->id, 'reconcile found' );

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new($self)->test;

 integration::reconEngine::TestScarletReconcileExist->new($self)->test;
 is( $reconcile->reconcileTypeId, 5, 'reconile type id is 5' );

 #change reconcile type id from 5 to anyone else.
 #trigger update_reconcile_type will be executed.
 $reconcile->reconcileTypeId(3);
 $reconcile->save( $self->connection );

 #validate reuslt.
 integration::reconEngine::TestScarletReconcileNotExist->new($self)->test;
 integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate->new(
  $self)->test;

}

1;

