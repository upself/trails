package Recon::expired_maints;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'Recon::Delegate::ReconLicenseValidation' };

sub startup : Tests(startup => 1) {
	my $tmp = shift;
	use_ok $tmp->class;
}

sub checkExpiredMaint : Tests(6) {
	my $test = shift;
	my $class = $test->class;
	
	can_ok $class,'checkExpiredMaint';
	
	is($class->validateMaintenanceExpiration('SERVER','10',0,-5,123,321),0,'checkExpiredMaint: expired');
	is($class->validateMaintenanceExpiration('SERVER','10',0,5,123,321),1,'checkExpiredMaint: valid');
	is($class->validateMaintenanceExpiration('SERVER','49',0,-5,123,321),1,'checkExpiredMaint: IFL - expiration irrelevant');
	is($class->validateMaintenanceExpiration('SERVER','9',0,-5,123,321),1,'checkExpiredMaint: MSU - expiration irrelevant');
	is($class->validateMaintenanceExpiration('WORKSTATION','10',0,-5,123,321),1,'checkExpiredMaint: workstation - expiration irrelevant');
	is($class->validateMaintenanceExpiration('SERVER','10',1,-5,123,321),1,'checkExpiredMaint: manual reconcile - expiration irrelevant');
	
}
1;
