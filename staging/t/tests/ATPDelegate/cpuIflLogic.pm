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
	
	is($class->cpuIflLogic(undef),0, "test offline cpuIflLogic undef => 0");
	is($class->cpuIflLogic(''),0, "test offline cpuIflLogic '' => 0");	
	is($class->cpuIflLogic(0),0, "test offline cpuIflLogic 0 => 0");
	is($class->cpuIflLogic(1),1, "test offline cpuIflLogic 1 => 1");
	is($class->cpuIflLogic(12.1231),12, "test offline cpuIflLogic 12.1231 => 12");
	is($class->cpuIflLogic(0.1241),0, "test offline cpuIflLogic 0.1241 => 0");
	is($class->cpuIflLogic(-1.1241),0, "test offline cpuIflLogic -1.1241 => 0");
	is($class->cpuIflLogic(-6),0, "test offline cpuIflLogic -6 => 0");
}
1;
