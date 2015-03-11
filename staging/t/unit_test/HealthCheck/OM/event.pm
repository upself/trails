package t::unit_test::HealthCheck::OM::Event;

use Test::More;
use base 'Test::Class';

sub class { HealthCheck::OM::Event };


sub startup : Tests(startup => 1) {
	my $tmp = shift;
	use_ok $tmp->class; # can use it
}

sub tostring : Tests(5) {
	my $self = shift;
	my $class = $self->class;

    
    $class = new $class();
    can_ok $class,'eventId';  # can we call it
	can_ok $class,'eventValue';  
	can_ok $class,'eventRecordTime';  
	can_ok $class,'toString';  
    $class->eventId("ID");
	$class->eventValue('VALUE');
	$class->eventRecordTime('TIME');
	my $str = $class->toString($class);
	like($str,'/TIME/','Testing conversion of event to string'); #  does it match regex
	is($str,'[Event] eventId=ID,eventValue=VALUE,eventRecordTime=TIME','Testing conversion of event to string'); # is it the same

}
1;