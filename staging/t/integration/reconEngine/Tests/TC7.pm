package integration::reconEngine::Tests::TC7;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use Test::More;
use Test::DatabaseRow;
use BRAVO::OM::ScheduleF;

use integration::reconEngine::TestScheduleFOnHostDefinedActive;
use integration::reconEngine::TestScarletReconcileNotExist;
use integration::reconEngine::TestScarletReconcileExist;
use integration::reconEngine::TestReconcileOnMachineLevel;
use integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate;

use integration::reconEngine::CmdCreateScheduleFOnHostname;
use integration::reconEngine::CmdDeleteScheduleFOnHostname;
use integration::reconEngine::CmdBreakReconcileIfExists;    

sub setup : Test( setup => 12 ) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 #IBM Tivoli Monitoring - Windows OS Agent/IWPPRN01
 $self->installedSoftwareId(240451553);
 $self->openAlerts;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/IWPPRN01
 $self->installedSoftwareId(260521374);
 $self->openAlerts;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/DM91GW026P
 $self->installedSoftwareId(258668102);
 $self->openAlerts;

 $self->mockGuidAPI;
 $self->mockLicenseAPI;
}

sub openAlerts {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 integration::reconEngine::CmdBreakReconcileIfExists->new($self)->execute;
 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;

 integration::reconEngine::TestReconInstalledSoftwareNotExist->new( $self,
  $label )->test;
 integration::reconEngine::TestLogFileClean->new( $self, $label )->test;
 integration::reconEngine::TestAlertOpen->new( $self,    $label )->test;
}

sub teardown : Test(teardown) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 #IBM Tivoli Monitoring - Windows OS Agent/IWPPRN01
 $self->installedSoftwareId(240451553);
 integration::reconEngine::CmdDeleteScheduleFOnHostname->new($self)->execute;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/IWPPRN01
 $self->installedSoftwareId(260521374);
 integration::reconEngine::CmdDeleteScheduleFOnHostname->new($self)->execute;

}

#Story 39096, should not build Machine Level reconcilation
#when the Schedule F existed on the Hostname level
sub _01_story39096_reconcileShouldNotBuilt : Test(2) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 #IBM Tivoli Monitoring - Windows OS Agent/IWPPRN01
 $self->installedSoftwareId(240451553);

 integration::reconEngine::CmdCreateScheduleFOnHostname->new($self)->execute;
 integration::reconEngine::TestScheduleFOnHostDefinedActive->new( $self,
  $label )->test;

 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 $self->launchReconEngine;

 integration::reconEngine::TestScarletReconcileNotExist->new( $self, $label )
   ->test;

}

sub _02_story39096_reconcileShouldNotBuiltWithBenifitRun : Test(5) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/IWPPRN01
 $self->installedSoftwareId(260521374);
 integration::reconEngine::CmdCreateScheduleFOnHostname->new($self)->execute;
 integration::reconEngine::TestScheduleFOnHostDefinedActive->new( $self,
  $label )->test;

 #IBM Tivoli Monitoring - Windows OS Agent/IWPPRN01
 $self->installedSoftwareId(240451553);
 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 $self->launchReconEngine;

 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;
 integration::reconEngine::TestReconcileOnMachineLevel->new( $self, $label )
   ->test;

 $self->installedSoftwareId(260521374);
 integration::reconEngine::TestScarletReconcileNotExist->new( $self, $label )
   ->test;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/DM91GW026P
 $self->installedSoftwareId(258668102);
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

}

sub _03_story39096_scarletReconcileDeleteAfterValidation : Test(9) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 #IBM Tivoli Monitoring - Windows OS Agent/IWPPRN01
 $self->installedSoftwareId(240451553);
 integration::reconEngine::CmdCreateReconInstalledSw->new($self)->execute;
 $self->launchReconEngine;

 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/DM91GW026P
 $self->installedSoftwareId(258668102);
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/IWPPRN01
 $self->installedSoftwareId(260521374);
 integration::reconEngine::CmdCreateScheduleFOnHostname->new($self)->execute;
 integration::reconEngine::TestScheduleFOnHostDefinedActive->new( $self,
  $label )->test;
 integration::reconEngine::TestReconcileOnMachineLevel->new( $self, $label )
   ->test;
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

 my $reconcile = $self->findReconcile;
 my $r         = Recon::ScarletReconcile->new(0);
 $r->validate( $reconcile->id );

 integration::reconEngine::TestScarletReconcileNotExist->new( $self, $label )
   ->test;
 integration::reconEngine::TestReconInstalledSoftwareExistWithoutDate->new(
  $self, $label )->test;

 $self->installedSoftwareId(258668102);
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

 $self->installedSoftwareId(240451553);
 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;
}

sub restoreConfigFile : Test( shutdown => 3 ) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 $self->resetGuid;
 $self->resetLicenseAPI;
 $self->resetParent;

 #IBM Tivoli Monitoring - Windows OS Agent/IWPPRN01
 $self->installedSoftwareId(240451553);
 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new( $self,
  $label )->test;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/IWPPRN01
 $self->installedSoftwareId(260521374);
 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new( $self,
  $label )->test;

#IBM License Metric Tool and Tivoli Asset Discovery for Distributed Agent/DM91GW026P
 $self->installedSoftwareId(258668102);
 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;
 integration::reconEngine::TestReconInstalledSoftwareNotExist->new( $self,
  $label )->test;

}

1;

