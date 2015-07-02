
package ATPDelegate::fixLparStatus;

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
	
    my %record = (
    "hardwareStatus" => "HWCOUNT",
    "lparStatus" => "ACTIVE",
    );
    $class->fixLparStatus(\%record);
	is($record{lparStatus},'ACTIVE', "test offline, physical box=hwcount, lpar status is  active");

    %record = (
    "hardwareStatus" => "HWCOUNT",
    "lparStatus" => "INACTIVE",
    );
    $class->fixLparStatus(\%record);
	is($record{lparStatus},'INACTIVE', "test offline, physical box=hwcount, lpar status is inactive");

    %record = (
    "hardwareStatus" => "ACTIVE",
    "lparStatus" => "ACTIVE",
    );
    $class->fixLparStatus(\%record);
	is($record{lparStatus},'ACTIVE', "test offline, physical box=active, lpar status is active");

    %record = (
    "hardwareStatus" => "ACTIVE",
    "lparStatus" => "RANDOM",
    );
    $class->fixLparStatus(\%record);
	is($record{lparStatus},'ACTIVE', "test offline, physical box=active, lpar status is invalid");

    %record = (
    "hardwareStatus" => "ACTIVE",
    "lparStatus" => "HWCOUNT",
    );
    $class->fixLparStatus(\%record);
	is($record{lparStatus},'HWCOUNT', "test offline, physical box=active, lpar status is hwcounth");

}
1;
