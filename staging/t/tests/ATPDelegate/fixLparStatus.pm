package ATPDelegate::fixLparStatus;

use Test::More;
use base 'Test::Class';

sub class { 'ATP::Delegate::ATPDelegate' }


sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub offline_test_1 : Tests(6) {
	my $test  = shift;
	my $class = $test->class;
    can_ok $class,'fixLparStatus';
    my $object = {};
    bless $object,$class;	
	my $status;
	
    $status = $object->fixLparStatus('HWCOUNT','ACTIVE');
	is($status,'ACTIVE', "test offline, physical box=hwcount, lpar status is  active");

    $status = $object->fixLparStatus('HWCOUNT','INACTIVE');
	is($status,'INACTIVE', "test offline, physical box=hwcount, lpar status is inactive");

    $status = $object->fixLparStatus('ACTIVE','ACTIVE');
	is($status,'ACTIVE', "test offline, physical box=active, lpar status is active");

    $status = $object->fixLparStatus('ACTIVE','RANDOM');
	is($status,'ACTIVE', "test offline, physical box=active, lpar status is invalid");

    $status = $object->fixLparStatus('ACTIVE','HWCOUNT');
	is($status,'HWCOUNT', "test offline, physical box=active, lpar status is hwcount");

}
1;
