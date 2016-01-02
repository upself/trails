package integration::reconEngine::Story38372::TC1;

use strict;
use base 'integration::reconEngine::TestBase';

use Recon::ScarletReconcile;
use integration::reconEngine::CmdCleanReconInstalledSoftware;

use Test::More;
use Test::DatabaseRow;

sub setup : Test(startup) {
 my $self = shift;

 $self->{connectionFile} = '/opt/staging/v2/config/connectionConfig.txt';
}

sub cleanConfig : Test(shutdown) {
 my $self = shift;

 $self->resetGuid;
 $self->resetParent;
}

sub _01_lastValidateTimeUpdated : Test(2) {
 my $self = shift;

 $self->mokeGuidAPI;
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
  descrpition => 'scarlet reconcile exists'
 );
 ok( $timeBefore ne $timeAfter, 'last validate time updated' );

}

sub _02_lastValidateTimeUnchanged : Test(2) {
 my $self = shift;

 $self->mokeGuidAPI;
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

 ok( defined $timeBefore && defined $timeAfter, 'scarlet reconcile defined' );
 ok( $timeBefore eq $timeAfter,
  'last validate time unchange due to parent out of service' );

}

sub _03_lastValidateTimeUnchanged : Test(2) {
 my $self = shift;

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

 ok( defined $timeBefore && defined $timeAfter, 'scarlet reconcile defined' );
 ok( $timeBefore eq $timeAfter,
  'last validate time unchange due to guid out of service' );

}

sub _04_scarletReconileWillBreak : Test(2) {    
 my $self = shift;

 $self->mokeEmptyGuidAPI;
 $self->resetParent;

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;

 my $reconcile = $self->findReconcile;
 my $sr        = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 local $Test::DatabaseRow::dbh = $self->connection->dbh;
 not_row_ok(
  sql => [ 'select * from scarlet_reconcile where id =?', $reconcile->id ],
  description => 'scarlet reconcile deleted'
 );

 row_ok(
  sql => [
   "select * from recon_installed_sw where installed_software_id = ?
   and action='LICENSING'",
   $reconcile->installedSoftwareId
  ],
  description => 'appended to recon installed software'
 );

}

sub setParentOutOfService {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.err:9300/guids';
 $self->changeFileProperty( $file, 'scarlet.guids.parents', $api );
}

sub resetParent {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.com:9300/guids';
 $self->changeFileProperty( $file, 'scarlet.guids.parents', $api );
}

sub setGuidOutOfService {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.err:9100/guids';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub mokeGuidAPI {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://localhost:8080/springrest/guid';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub mokeEmptyGuidAPI {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://localhost:8080/springrest/empty/guid';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub resetGuid {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.com:9100/guids';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

1;

