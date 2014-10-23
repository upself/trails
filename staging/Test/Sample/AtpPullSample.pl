
use Test::More 'no_plan';
use Test::Common::MockConnection;
use ATP::Delegate::ATPDelegate;


 BEGIN { use_ok( 'ATP::Delegate::ATPDelegate' ); }
 require_ok( 'ATP::Delegate::ATPDelegate' );

$self->{stagingConnection} = Test::Common::MockConnection->new('staging');
$self->{bravoConnection}   = Test::Common::MockConnection->new('trails');

print "Staging Connection user " . $self->{stagingConnection}->user . "\n";
ATPDelegate->getData($self->{stagingConnection}, undef);
 