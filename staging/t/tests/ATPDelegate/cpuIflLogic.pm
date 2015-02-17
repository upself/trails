package ATPDelegate::cpuIflLogic;

use Test::More;
use base 'Test::Class';

sub class { 'ATP::Delegate::ATPDelegate' }


sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub offline_test_1 : Tests(8) {
	my $test  = shift;
	my $class = $test->class;
	

	is($class->cpuIflLogic(undef),0, "test offline undef => 0");
	is($class->cpuIflLogic(''),0, "test offline '' => 0");	
	is($class->cpuIflLogic(0),0, "test offline 0 => 0");
	is($class->cpuIflLogic(1),1, "test offline 1 => 1");
	is($class->cpuIflLogic(12.1231),12, "test offline 12.1231 => 12");
	is($class->cpuIflLogic(0.1241),0, "test offline 0.1241 => 0");
	is($class->cpuIflLogic(-1.1241),0, "test offline -1.1241 => 0");
	is($class->cpuIflLogic(-0),0, "test offline -0 => 0");
	is($class->cpuIflLogic(+0),0, "test offline +0 => 0");
	is($class->cpuIflLogic('string'),0, "test offline string => 0");
    is($class->cpuIflLogic('12,35'),0, "test offline '12,35' => 0");
    is($class->cpuIflLogic('1.text'),0, "test offline 1.text => 0");



}
1;
