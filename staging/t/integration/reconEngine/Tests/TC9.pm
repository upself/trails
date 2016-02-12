package integration::reconEngine::Tests::TC9;

use strict;
use Base::Utils;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use integration::reconEngine::TestScarletReconcileExist;

sub _01_story39695_runValidationScarletReconcileShouldKept : Test(1) { 
 my $self  = shift;
 my $label = ( caller(0) )[3];

 logfile('/tmp/test.log');
 logging_level('debug');

 $self->installedSoftwareId(252555692);
 my $reconcile = $self->findReconcile();

 my $sr = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

}

sub _02_story39695_scarletOutOfServiceScarletReconcileShouldKept : Test(2) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 $self->setGuidOutOfService;

 $self->installedSoftwareId(252555692);
 my $reconcile = $self->findReconcile();

 my $sr1 = Recon::ScarletReconcile->new(0);
 $sr1->validate( $reconcile->id );

 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;

 $self->resetGuid;
 $self->setParentOutOfService;

 my $sr2 = Recon::ScarletReconcile->new(0);
 $sr2->validate( $reconcile->id );

 integration::reconEngine::TestScarletReconcileExist->new( $self, $label )
   ->test;
}

sub shutdown : Test(shutdown) {
 my $self = shift;
 $self->resetGuid;
}
1;

