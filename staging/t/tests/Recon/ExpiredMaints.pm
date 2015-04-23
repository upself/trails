package Recon::expired_maints;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'Recon::Delegate::ReconLicenseValidation' };

sub startup : Tests(startup => 1) {
        my $tmp = shift;
        use_ok $tmp->class;
}

sub checkExpiredMaint : Tests(7) {
        my $test = shift;
        my $class = $test->class;

        #can_ok $object,'validateMaintenanceExpiration';
        can_ok $class,'validateMaintenanceExpiration';
        my $object = {};
        bless $object,$class;

        is($object->validateMaintenanceExpiration('SERVER','10',0,-5,undef,undef),0,'checkExpiredMaint: expired');
        is($object->validateMaintenanceExpiration('SERVER','10',0,5,undef,undef),1,'checkExpiredMaint: valid');
        is($object->validateMaintenanceExpiration('SERVER','49',0,-5,undef,undef),1,'checkExpiredMaint: IFL - expiration irrelevant');
        is($object->validateMaintenanceExpiration('SERVER','9',0,-5,undef,undef),1,'checkExpiredMaint: MSU - expiration irrelevant');
        is($object->validateMaintenanceExpiration('WORKSTATION','10',0,-5,undef,undef),1,'checkExpiredMaint: workstation - expiration irrelevant');
        is($object->validateMaintenanceExpiration('SERVER','10',1,-5,undef,undef),1,'checkExpiredMaint: manual reconcile - expiration irrelevant');

}
1;
