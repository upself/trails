package ATPDelegate::processorCountLogic;

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
	
	is($class->processorCountLogic(undef),undef, "test offline undef => undef");
	is($class->processorCountLogic(''),undef, "test offline '' => undef");	
	is($class->processorCountLogic(0),undef, "test offline 0 => undef");
	is($class->processorCountLogic(1),1, "test offline 1 => undef");
	is($class->processorCountLogic(12.1231),12, "test offline 12.1231 => 12");
	is($class->processorCountLogic(0.1241),undef, "test offline 0.1241 => undef");
	is($class->processorCountLogic(-1.1241),undef, "test offline -1.1241 => undef");
	is($class->processorCountLogic(-6),undef, "test offline -6 => undef");
}
1;