package ATPDelegate::hardwareStatusLogic;

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
	

	is($class->hardwareStatusLogic('ACTIVE'),'ACTIVE', "hardwareStatus - ACTIVE => ACTIVE");
	is($class->hardwareStatusLogic('INACTIVE'),'INACTIVE', "hardwareStatus - INACTIVE => INACTIVE");	
	is($class->hardwareStatusLogic('HWCOUNT'),'HWCOUNT', "hardwareStatus - HWCOUNT => HWCOUNT");
	is($class->hardwareStatusLogic('UNLOC8D'),'UNLOC8D', "hardwareStatus - UNLOC8D => UNLOC8D");
	is($class->hardwareStatusLogic('RMVDLPAR'),'RMVDLPAR', "hardwareStatus - RMVDLPAR => RMVDLPAR");
	is($class->hardwareStatusLogic('AAAA'),'ACTIVE', "hardwareStatus - AAAA => ACTIVE");
	is($class->hardwareStatusLogic(''),'ACTIVE', "hardwareStatus - empty string => ACTIVE");
	is($class->hardwareStatusLogic(undef),'ACTIVE', "hardwareStatus - undef => ACTIVE");

}
1;