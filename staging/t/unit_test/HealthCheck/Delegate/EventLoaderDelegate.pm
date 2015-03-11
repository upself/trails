package t::unit_test::HealthCheck::Delegate::EventLoaderDelegate;

use Test::More;
use base 'Test::Class';

sub class { 'HealthCheck::Delegate::EventLoaderDelegate' };


sub startup : Tests(startup => 1) {
	my $tmp = shift;
	use_ok $tmp->class;
}

sub getTime : Tests(2) {
	my $test = shift;
	my $class = $test->class;
	
	can_ok $class,'getTime';  # can we call it
    my $timestamp = 155611;   
    my $dateObject = $class->getTime(timestamp);
    is($dateObject->{date},'09','getTime: Testing if September is returned as 09 or 9');
}
1;