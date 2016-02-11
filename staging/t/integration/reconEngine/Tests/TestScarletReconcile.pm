package integration::reconEngine::Tests::TestScarletReconcile;

use strict;
use base qw(Test::Class integration::LogManager);

use Test::DatabaseRow;
use Test::More;

use Database::Connection;
use Recon::ScarletReconcile;

use integration::reconEngine::CmdCreateScarletReconcile;
use integration::reconEngine::CmdDeleteScarletReconcile;

sub start : Test(startup) {
 my $self = shift;
 $self->configLog( '/opt/staging/v2/config/scarletProcessConfig.txt',
  '/tmp/scarletProcess.log' );
}

sub clean : Test(shutdown) {
 integration::reconEngine::CmdDeleteScarletReconcile->new(999999)->execute;
}

sub story38372_orphanScarletReconcileDeleted : Test(2) {
 my $label = ( caller(0) )[3];

 my $id         = 999999;
 my $connection = Database::Connection->new('trails');

 my $cmd =
   integration::reconEngine::CmdCreateScarletReconcile->new( $id,
  '2099-09-09 09:00:00' );
 $cmd->execute;

 row_ok(
  dbh => $connection->dbh,
  sql => [
   'select count(*) as QTY 
    from scarlet_reconcile sr
    where sr.id = ?',
   $id
  ],
  tests       => { ">" => { QTY => 0 } },
  description => $label . ", scarlet reconcile exists" 
 );

 my $r = Recon::ScarletReconcile->new(0);
 $r->validate($id);

 not_row_ok(
  dbh => $connection->dbh,
  sql => [
   'select *  
    from scarlet_reconcile sr
    where sr.id = ?',
   $id
  ],
  description => $label . ", scarlet reconcile deleted"
 );

}

1;
