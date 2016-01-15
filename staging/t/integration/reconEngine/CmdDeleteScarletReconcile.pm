package integration::reconEngine::CmdDeleteScarletReconcile;

use strict;

use Database::Connection;
use Recon::OM::ScarletReconcile;

sub new {
 my ( $class, $id, $time ) = @_;
 my $self = {
  _id         => $id,
  _connection => Database::Connection->new('trails')    

 };
 bless $self, $class;

 return $self;
}

sub execute {
 my $self = shift;

 my $connection = $self->{_connection};

 my $r = Recon::OM::ScarletReconcile->new();
 $r->id( $self->{_id} );
 $r->delete($connection);

}

1;
