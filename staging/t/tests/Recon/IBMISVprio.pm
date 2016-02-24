package Recon::IBMISVprio;

use Test::More;
use base 'Test::Class';
use Database::Connection;
use Recon::ReconEnginePriorityISVSoftware;

sub class1 { 'Recon::Delegate::ReconDelegate' };

sub startup : Tests(startup => 1) {
        my $tmp = shift;
        use_ok $tmp->class1;
}

sub checkIBMISVprio : Tests(6) {
        my $test = shift;
        
        my $connection=Database::Connection->new('trails');
        
        my $class1 = $test->class1;

        #can_ok $object,'getIBMISVprio';
        can_ok $class1,'getIBMISVprio';
        my $object1 = {};
        bless $object1,$class1;

        is($object1->getIBMISVprio($connection,'Tivoli',15246),'IBM','checkIBMISVprio: expired');
        is($object1->getIBMISVprio($connection,'HP',15246),'ISVPRIO','global priority ISV');
#        is($object->getIBMISVprio($connection,467571,1589),'ISVNOPRIO','account level prio ISV');
#        is($object->getIBMISVprio($connection,467571,15246),'ISVNOPRIO','account level prio ISV, wrong customer');
        is($object1->getIBMISVprio($connection,'EPAGE SOLUTIONS',15246),'ISVNOPRIO','no priority ISV');
        
        $connection->disconnect;
        
        my $object2 = new Recon::ReconEnginePriorityISVSoftware;
        
#        can_ok $class2,'retrieveSoftwareIds';
        
        is($object2->retrieveSoftwareIds(3280),7, 'many software IDs'); # array (134205,134206,134207,134208,134209,134210,271729)
        is($object2->retrieveSoftwareIds(402),1, 'one software ID'); # array (120252)

}
1;
