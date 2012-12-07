package Test::HardwareLpar::TestHWLparReconQueue;
use strict;
use base qw(Test::Common::StagingBasedTest Test::Common::ReconQueueManager);
use Test::More;

use BRAVO::Loader::Hardware;
use BRAVO::SoftwareLoader;
use BRAVO::OM::HardwareSoftwareComposite;

use Test::Sample::BravoHWSample;
use Test::Sample::BravoHWLparSample;
use Test::Sample::BravoSWLparSample;
use Test::Sample::ReconHWSample;
use Test::Sample::HWSWCompositeSample;

sub test01_newHWLparInQueue : Test(2) {
 diag('>>>test1 start');
 my $self = shift;

 #execute the bravo hw loader and check the queue.
 $self->runBravoHWLoader;

 #check if the new hardware was inserted into queue.
 ok( defined $self->reconHWQueue->id, 'new hardware in recon queue.' );

 #check if the new hardwareLpar was inserted into queue.
 ok( defined $self->reconHWLparQueue->id, 'new hardware lpar in recon queue.' );

 diag('>>>test1 end');
}

sub test02_hwLparStatusChange : Test(no_plan) {
 diag('>>>test2 start');

 my $self = shift;

 $self->runBravoHWLoader;

 for ( my $index = 1 ; $index <= 2 ; $index++ ) {

  $self->cleanReconDB;
  $self->checkReconDBClean;

  my ( $oldStatus, $newStatus ) =
    $self->switchSampleStatus( $self->stagingHWLparSample );
  diag("Staging HW Lpar status changed $oldStatus->$newStatus");

  my ( $oldHWStatus, $newHWStatus ) =
    $self->switchSampleStatus( $self->stagingHWSample );
  diag("Staging HW status changed $oldHWStatus->$newHWStatus");

  #execute the bravo hw loader and check the queue.
  $self->runBravoHWLoader;

  #check if the new hardwareLpar was inserted into queue.
  ok( defined $self->reconHWLparQueue->id, 'hardware lpar in recon queue ' );

  #check if the new hardware was inserted into queue.
  ok( defined $self->reconHWQueue->id, 'hardware in recon queue.' );
 }
 diag('>>test02 end');
}

sub test03_hwLparInScopeStatusChange : Test(no_plan) {
 diag('>>>test3 start');

 my $self = shift;

 #change the staging HW status.
 $self->changeHWStatus(3);

 diag('>>>test 3 end');
}

sub test04_hwLparStatusChangeWithSWLpar : Test(no_plan) {
 diag('>>>test 4 start');
 my $self = shift;

 my $bravoHWLoader = $self->runBravoHWLoader;
 $self->cleanReconDB;
 $self->checkReconDBClean;

 #create bravo sw lpar.
 my $bravoSWLparSample = new Sample::BravoSWLparSample;

 $bravoSWLparSample->connection( $self->getBravoConnection );
 $bravoSWLparSample->customerId(
  $self->stagingSWLparSample->model->customerId );
 $bravoSWLparSample->name( $self->stagingSWLparSample->model->name );

 $bravoSWLparSample->insert;

 ok( $bravoSWLparSample->existLightWeight, 'add bravo sw lpar.' );
 $self->bravoSWLparSample($bravoSWLparSample);

 #create hw sw composite.
 my @loaders     = @{ $bravoHWLoader->hardwareLparLoaders };
 my $bravoHWLpar = $loaders[0]->bravoHardwareLpar;

 my $bravoHWSWCS = new Sample::HWSWCompositeSample;
 $bravoHWSWCS->connection( $self->getBravoConnection );
 $bravoHWSWCS->hardwareLparId( $bravoHWLpar->id );
 $bravoHWSWCS->softwareLparId( $bravoSWLparSample->model->id );
 $bravoHWSWCS->insert;

 ok( $bravoHWSWCS->existLightWeight, 'add hw sw composite. ' );
 $self->bravoHWSWCompositeSample($bravoHWSWCS);

 #change status.
 my ( $oldStatus, $newStatus ) =
   $self->switchSampleStatus( $self->stagingHWLparSample );
 diag("Staging HW Lpar status changed $oldStatus->$newStatus");

 my ( $oldHWStatus, $newHWStatus ) =
   $self->switchSampleStatus( $self->stagingHWSample );
 diag("Staging HW status changed $oldHWStatus->$newHWStatus");

 $self->runBravoHWLoader;

 ok( defined $self->reconHWQueue->id,     'hardware in recon queue.' );
 ok( defined $self->reconHWLparQueue->id, 'hardware lpar in recon queue.' );
 ok( defined $self->reconHWLparQueue->id, 'software lpar in recon queue.' );
 $self->cleanReconDB;
 $self->checkReconDBClean;

 $self->changeHWStatus(4);

 diag('>>>test 4 end');
}

#-----------------
# end of test.
#-----------------

#clean recon DB.
sub teardown01_cleanReconDB : Test( teardown => no_plan ) {
 diag('teardown start');
 my $self = shift;
 $self->cleanReconDB;
 $self->checkReconDBClean;

}

#clean recon DB.
sub teardown02_cleanBravoDB : Test( teardown => no_plan ) {
 my $self = shift;
 $self->cleanBravoDB;
 diag('teardown end');
}

#-----------------
# end of teardown.
#-----------------

sub checkReconDBClean {
 my $self = shift;

 #remove the hw recon queue.
 if ( defined $self->reconHWQueue ) {
  ok( !$self->isHWReconExist( $self->reconHWQueue->id ), 'remove recon hw.' );
  $self->reconHWQueue(undef);
 }

 #remove the hw lpar recon queue.
 if ( defined $self->reconHWLparQueue ) {
  ok( !$self->isHWLparReconExist( $self->reconHWLparQueue->id ),
   'remove recon hw lpar.' );
  $self->reconHWLparQueue(undef);
 }

 #remove the hw recon queue.
 if ( defined $self->reconSWLparQueue ) {
  ok( !$self->isSWLparReconExist( $self->reconSWLparQueue->id ),
   'remove recon sw lpar.' );
  $self->reconSWLparQueue(undef);
 }

}

sub cleanBravoDB {
 my $self = shift;

 my $bravoHWLoader = $self->bravoHWLoader;
 my @loaders       = @{ $bravoHWLoader->hardwareLparLoaders };
 my $bravoHWLpar   = $loaders[0]->bravoHardwareLpar;

 #remove the bravo hw sw composite.
 if ( defined $self->bravoSWLparSample ) {
  my $hwSwCompoiste = new BRAVO::OM::HardwareSoftwareComposite;
  $hwSwCompoiste->hardwareLparId( $bravoHWLpar->id );
  $hwSwCompoiste->softwareLparId( $self->bravoSWLparSample->model->id );
  $hwSwCompoiste->getByBizKey( $self->getBravoConnection );

  $hwSwCompoiste->delete( $self->getBravoConnection )
    if defined $hwSwCompoiste->id;

  $hwSwCompoiste->hardwareLparId(undef);
  $hwSwCompoiste->getById( $self->getBravoConnection )
    if defined $hwSwCompoiste->id;
  ok( !defined $hwSwCompoiste->hardwareLparId,
   'remove bravo sw hw composite.' );

  #remove the bravo sw lpar.
  $self->bravoSWLparSample->remove;
  ok( !$self->bravoSWLparSample->exist, 'remove bravo sw lpar.' );
 }

 #remove the bravo hw lpar.

 my $bravoHWSLparSample = new Sample::BravoHWLparSample;
 $bravoHWSLparSample->connection( $self->getBravoConnection );
 $bravoHWSLparSample->model($bravoHWLpar);
 $bravoHWSLparSample->remove;
 ok( !$bravoHWSLparSample->exist, 'remove bravo hw lpar.' );

 #remove the bravo hw.
 my $bravoHW = $bravoHWLoader->bravoHardware;

 my $bravoHWSample = new Sample::BravoHWSample;
 $bravoHWSample->connection( $self->getBravoConnection );
 $bravoHWSample->model($bravoHW);
 $bravoHWSample->remove;

 ok( !$bravoHWSample->exist, 'remove bravo hw.' );
}

sub runBravoHWLoader {
 my $self          = shift;
 my $bravoHWLoader =
   new BRAVO::Loader::Hardware( $self->getStagingConnection,
  $self->getBravoConnection, $self->stagingHWSample->model );

 #set the latest bravo hw loader.
 $self->bravoHWLoader($bravoHWLoader);

 $bravoHWLoader->logic;
 $bravoHWLoader->save;

 #refresh the recon hw in memory.
 my $bravoHW = $bravoHWLoader->bravoHardware;
 my $hwRecon = $self->getReconQueueByHW( $bravoHW->id, 'UPDATE' );
 $self->reconHWQueue($hwRecon);

 #refresh the recon hw lpar in memory.
 my @loaders     = @{ $bravoHWLoader->hardwareLparLoaders };
 my $bravoHWLpar = $loaders[0]->bravoHardwareLpar;
 my $hwLparRecon = $self->getReconQueueByHWLpar( $bravoHWLpar->id, 'UPDATE' );
 $self->reconHWLparQueue($hwLparRecon);

 #refresh the recon sw lpar in memory.
 if ( defined $self->bravoSWLparSample ) {
  my $swLparRecon =
    $self->getReconQueueBySWLpar( $self->bravoSWLparSample->model->id, 'DEEP' );
  $self->reconSWLparQueue($swLparRecon);
 }

 diag('-bravo hw loader exectued.-');
 return $bravoHWLoader;
}

#called by changeHWStatus in super.
sub beforeHWStatusChange {
 my $self = shift;

 $self->runBravoHWLoader;
 $self->cleanReconDB;
 $self->checkReconDBClean;
}

#called by changeHWStatus in super.
sub afterHWStatusChange {
 my ( $self, $oldStatus, $newStatus, $switcher ) = @_;

 diag("Staging hardware status changed $oldStatus->$newStatus");

 #execute the bravo hw loader and check the queue.
 $self->runBravoHWLoader;

 #check if the new hardware was inserted into queue.
 if ( $switcher == 3 ) {
  ok( defined $self->reconHWQueue->id, 'hardware in recon queue.' );
 }

 if ( $switcher == 4 ) {
  ok( defined $self->reconHWQueue->id, 'hardware in recon queue.' );

  my $opposite = 0;

  $opposite = 1 if ( $oldStatus eq 'INACTIVE' && $newStatus eq 'ACTIVE' );
  $opposite = 1 if ( $oldStatus eq 'ACTIVE'   && $newStatus eq 'INACTIVE' );

  if ($opposite) {
   ok(
    !defined $self->reconHWLparQueue->id,
    'hardware lpar not in recon queue.'
   );
   ok(
    !defined $self->reconSWLparQueue->id,
    'software lpar not in recon queue.'
   );
  }
  else {
   ok( defined $self->reconHWLparQueue->id, 'hardware lpar in recon queue.' );
   ok( defined $self->reconSWLparQueue->id, 'software lpar in recon queue.' );
  }

 }

}

sub bravoHWLoader {
 my $self = shift;
 if (@_) { $self->{_bravoHWLoader} = shift }
 return $self->{_bravoHWLoader};
}

sub bravoSWLparSample {
 my $self = shift;
 if (@_) { $self->{_bravoSWLparSample} = shift }
 return $self->{_bravoSWLparSample};
}

sub bravoHWSWCompositeSample {
 my $self = shift;
 if (@_) { $self->{_bravoHWSWCompositeSample} = shift }
 return $self->{_bravoHWSWCompositeSample};
}

1;
