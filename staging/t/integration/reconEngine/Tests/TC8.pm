package integration::reconEngine::Tests::TC8;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use Test::More;
use Test::DatabaseRow;

use integration::reconEngine::CmdCreateScheduleFOnProduct;
use integration::reconEngine::CmdDeleteScheduleFOnProduct;
use integration::reconEngine::CmdCreateReconInstalledSw;

sub _01_story39347_attachedToManual : Test(1) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 # $self->createScheduleF;
 # $self->deleteScheduleF;

 #Tivoli Inventory / 35400
 $self->installedSoftwareId(151728581);

 $self->mockLicenseAPI;
 integration::reconEngine::CmdBreakReconcileIfExists->new($self)->execute;
 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 $self->launchReconEngine;

 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;
 
 
 $self->resetLicenseAPI;
}

sub createScheduleF {
 my $self = shift;

 #Tivoli Inventory / 35400
 $self->installedSoftwareId(151728581);
 integration::reconEngine::CmdCreateScheduleFOnProduct->new($self)->execute;

 #IBM Tivoli Configuration Manager / 35400
 $self->installedSoftwareId(39045297);
 integration::reconEngine::CmdCreateScheduleFOnProduct->new($self)->execute;

 #IBM Tivoli Management Framework / 35400
 $self->installedSoftwareId(39045296);
 integration::reconEngine::CmdCreateScheduleFOnProduct->new($self)->execute;
}

sub deleteScheduleF {
 my $self = shift;

 #Tivoli Inventory / 35400
 $self->installedSoftwareId(151728581);
 integration::reconEngine::CmdDeleteScheduleFOnProduct->new($self)->execute;

 #IBM Tivoli Configuration Manager / 35400
 $self->installedSoftwareId(39045297);
 integration::reconEngine::CmdDeleteScheduleFOnProduct->new($self)->execute;

 #IBM Tivoli Management Framework / 35400
 $self->installedSoftwareId(39045296);
 integration::reconEngine::CmdDeleteScheduleFOnProduct->new($self)->execute;
}
1;
