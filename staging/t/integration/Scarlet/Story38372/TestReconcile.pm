package integration::Scarlet::Story38372::ScarletProcess;

use strict;
use base qw(Test::Class integration::LogManager);

use Test::DatabaseRow;

use Database::Connection;
use Recon::ScarletReconcile;

sub start : Test(startup) {
 my $self = shift;
 $self->configLog( '/opt/staging/v2/config/scarletProcessConfig.txt',
  '/tmp/scarletProcess.log' );
}

sub clean : Test(shutdown) {
 integration::Scarlet::CmdDeleteScarletReconcile->new(999999)->execute;
}

sub _test : Test(2) {

 my $id         = 999999;
 my $connection = Database::Connection->new('trails');

 my $cmd =
   integration::Scarlet::CmdCreateScarletReconcile->new( $id,
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
  description => "scarlet reconcile exists"
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
  description => "scarlet reconcile deleted"
 );

}

1;
