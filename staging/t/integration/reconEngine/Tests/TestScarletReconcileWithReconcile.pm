package integration::reconEngine::Tests::TestScarletReconcileWithReconcile;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;
use integration::reconEngine::CmdCleanReconInstalledSoftware;

use Test::More;
use Test::DatabaseRow;

sub setup : Test(startup) {
 my $self = shift;
 $self->{connectionFile} = '/opt/staging/v2/config/connectionConfig.txt';
}

sub restoreConfigFile : Test(shutdown) {
 my $self = shift;

 $self->resetGuid;
 $self->resetParent;
}

sub _01_story38372_lastValidateTimeUpdated : Test(2) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 $self->mockGuidAPI;
 $self->resetParent;

 my $reconcile = $self->findReconcile;

 my $dataObj = Recon::OM::ScarletReconcile->new();
 $dataObj->id( $reconcile->id );
 $dataObj->getByBizKey( $self->connection );
 my $timeBefore = $dataObj->lastValidateTime();

 my $sr = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 $dataObj->getByBizKey( $self->connection );
 my $timeAfter = $dataObj->lastValidateTime();

 row_ok(
  dbh => $self->connection->dbh,
  sql => [ "select * from scarlet_reconcile where id = ?", $reconcile->id ],
  description => $label . ', scarlet reconcile exists'    
 );
 ok( $timeBefore ne $timeAfter, $label . ', last validate time updated' );

}

sub _02_story38372_lastValidateTimeUnchanged : Test(2) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 $self->mockGuidAPI;
 $self->setParentOutOfService;

 my $reconcile = $self->findReconcile;

 my $dataObj = Recon::OM::ScarletReconcile->new();
 $dataObj->id( $reconcile->id );
 $dataObj->getByBizKey( $self->connection );
 my $timeBefore = $dataObj->lastValidateTime();

 my $sr = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 $dataObj->getByBizKey( $self->connection );
 my $timeAfter = $dataObj->lastValidateTime();

 ok(
  defined $timeBefore && defined $timeAfter,
  $label . ', scarlet reconcile defined'
 );
 ok( $timeBefore eq $timeAfter,
  $label . ', last validate time unchange due to parent out of service' );

}

sub _03_story38372_lastValidateTimeUnchanged : Test(2) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 $self->setGuidOutOfService;
 $self->resetParent;

 my $reconcile = $self->findReconcile;

 my $dataObj = Recon::OM::ScarletReconcile->new();
 $dataObj->id( $reconcile->id );
 $dataObj->getByBizKey( $self->connection );
 my $timeBefore = $dataObj->lastValidateTime();

 my $sr = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 $dataObj->getByBizKey( $self->connection );
 my $timeAfter = $dataObj->lastValidateTime();

 ok(
  defined $timeBefore && defined $timeAfter,
  $label . ', scarlet reconcile defined'
 );
 ok( $timeBefore eq $timeAfter,
  $label . ', last validate time unchange due to guid out of service' );

}

sub _04_story38372_scarletReconileWillDelete : Test(2) {
 my $self  = shift;
 my $label = ( caller(0) )[3];

 $self->mockEmptyGuidAPI;
 $self->resetParent;

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;

 my $reconcile = $self->findReconcile;
 my $sr        = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 local $Test::DatabaseRow::dbh = $self->connection->dbh;
 not_row_ok(
  sql => [ 'select * from scarlet_reconcile where id =?', $reconcile->id ],
  description => $label . ', scarlet reconcile deleted'
 );

 row_ok(
  sql => [
   "select * from recon_installed_sw where installed_software_id = ?
   and action='LICENSING'",
   $reconcile->installedSoftwareId
  ],
  description => $label . ', appended to recon installed software'
 );

}

1;

