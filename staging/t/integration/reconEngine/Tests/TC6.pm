package integration::reconEngine::Tests::TC6;

use strict;
use base qw(integration::reconEngine::TestBase
  integration::ScarletAPIManager);

use Recon::ScarletReconcile;

use Test::More;
use Test::DatabaseRow;

sub restoreConfigFile : Test(shutdown) {
 my $self = shift;

 $self->resetGuid;
 $self->resetLicenseAPI;
 $self->resetParent;
}

sub _01_story39320_scarletReconileWillDelete : Test(3) {
 my $self = shift;

 local $TODO = "Story 39320 feature to be added. ";    
 $self->mockGuidAPI;
 $self->resetParent;
 my $reconcile = $self->findReconcile;
 ok( $reconcile->id, 'reconcile found' );

 #change reconcile type id to 3 which is not auto allocation.
 $reconcile->reconcileTypeId(3);
 $reconcile->save( $self->connection );

 integration::reconEngine::CmdCleanReconInstalledSoftware->new($self)->execute;

 #launch scarlet reconcile.
 my $sr = Recon::ScarletReconcile->new(0);
 $sr->validate( $reconcile->id );

 #validate reuslt.
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

1;

