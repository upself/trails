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
	
	is($class->processorCountLogic(undef),undef, "processorCountLogic effProc undef => undef");
	is($class->processorCountLogic(''),undef, "processorCountLogic effProc '' => undef");	
	is($class->processorCountLogic(0),undef, "processorCountLogic effProc 0 => undef");
	is($class->processorCountLogic(1),1, "processorCountLogic effProc 1 => undef");
	is($class->processorCountLogic(12.1231),12, "processorCountLogic effProc 12.1231 => 12");
	is($class->processorCountLogic(0.1241),undef, "processorCountLogic effProc 0.1241 => undef");
	is($class->processorCountLogic(-1.1241),undef, "processorCountLogic effProc -1.1241 => undef");
	is($class->processorCountLogic(-6),undef, "processorCountLogic effProc -6 => undef");
}
1;