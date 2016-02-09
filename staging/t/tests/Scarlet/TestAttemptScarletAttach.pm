package Scarlet::TestAttemptScarletAttach;

use strict;
use Base::Utils;
use base qw(Test::Class
  integration::ScarletAPIManager
  integration::reconEngine::Properties);
use Test::More;
use Test::DatabaseRow;

use Recon::Attempt::ScarletAttach;
use BRAVO::OM::InstalledSoftware;
use integration::reconEngine::CmdBreakReconcileIfExists;

sub testGetAccountNoGuid : Test(5) {
 my $self = shift;

 $self->mockLicenseAPI();

 my $conn = Database::Connection->new('trails');

 my $is = BRAVO::OM::InstalledSoftware->new;
 $is->id(151728581);
 $is->getById($conn);

 my $sa         = Recon::Attempt::ScarletAttach->new($is);
 my $result     = $sa->getAccountNoGuid;
 my $resultKeys = [ keys %{$result} ];

 is( scalar @{$resultKeys}, 4, 'reuslt size good' );
 is( $result->{accountNo}, 35400, 'account correct' );
 is( $result->{guid}, '152bff38a573430482bc30f8be9ee1fd', 'guid correct' );
 is( $result->{hardwareId},     '569389',  'hardware id correct' );
 is( $result->{softwareLparId}, '2332154', 'software lpar correct' );

}


sub testAttempt : Test(1) {
 my $self = shift;

 $self->installedSoftwareId(151728581);
 $self->connection( Database::Connection->new('trails') );

 $self->mockLicenseAPI();
 integration::reconEngine::CmdBreakReconcileIfExists->new($self)->execute;

 my $is = BRAVO::OM::InstalledSoftware->new;
 $is->id( $self->installedSoftwareId );
 $is->getById( $self->connection );

 my $sa     = Recon::Attempt::ScarletAttach->new($is);
 my $result = $sa->attempt;

 row_ok(
  dbh => $self->connection->dbh,
  sql => [
   'select count(*) as QTY 
    from reconcile r, scarlet_reconcile sr
    where r.id = sr.id and r.installed_software_id =?',
   $self->installedSoftwareId
  ],
  tests       => { ">" => { QTY => 0 } },
  description => " scarlet reconcile exists"
 );
}

sub teardown : Test(shutdown) {
 my $self = shift;
 $self->resetLicenseAPI;
}

1;
