package Recon::IBMISVprio;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'Recon::Delegate::ReconDelegate' };

sub startup : Tests(startup => 1) {
        my $tmp = shift;
        use_ok $tmp->class;
}

sub checkIBMISVprio : Tests(6) {
        my $test = shift;
        my $class = $test->class;
        
        my $connection=Database::Connection->new('trails');

        #can_ok $object,'getIBMISVprio';
        can_ok $class,'getIBMISVprio';
        my $object = {};
        bless $object,$class;

        is($object->getIBMISVprio($connection,3536,15246),'IBM','checkIBMISVprio: expired');
        is($object->getIBMISVprio($connection,467799,15246),'ISVPRIO','global priority ISV');
        is($object->getIBMISVprio($connection,467571,1589),'ISVNOPRIO','account level prio ISV');
        is($object->getIBMISVprio($connection,467571,15246),'ISVNOPRIO','account level prio ISV, wrong customer');
        is($object->getIBMISVprio($connection,999,15246),'ISVNOPRIO','no priority ISV');

}
1;
