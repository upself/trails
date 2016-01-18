package Recon::scheduleFbyISW;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'Recon::Delegate::ReconDelegate' };

sub startup : Tests(startup => 1) {
        my $tmp = shift;
        use_ok $tmp->class;
}

sub checkExpiredMaint : Tests(7) {
        my $test = shift;
        my $class = $test->class;

        #can_ok $object,'getScheduleFScopeByISW';
        can_ok $class,'getScheduleFScopeByISW';
        my $object = {};
        bless $object,$class;

        is($object->getScheduleFScopeByISW(36931055),("IBMOIBMM", "HOSTNAME"),'IBMOIBMM, hostname level');
        is($object->getScheduleFScopeByISW(),1,'checkExpiredMaint: valid');
        is($object->getScheduleFScopeByISW(),1,'checkExpiredMaint: IFL - expiration irrelevant');
        is($object->getScheduleFScopeByISW(),1,'checkExpiredMaint: MSU - expiration irrelevant');
        is($object->getScheduleFScopeByISW(),1,'checkExpiredMaint: workstation - expiration irrelevant');
        is($object->getScheduleFScopeByISW(),1,'checkExpiredMaint: manual reconcile - expiration irrelevant');

}
1;
