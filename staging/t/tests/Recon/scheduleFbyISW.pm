package Recon::scheduleFbyISW;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'Recon::Delegate::ReconDelegate' };

sub startup : Tests(startup => 1) {
        my $tmp = shift;
        use_ok $tmp->class;
}

sub scheduleFbyISW : Tests(5) {
        my $test = shift;
        my $class = $test->class;

        my $connection=Database::Connection->new('trails');

        #can_ok $object,'getScheduleFScopeByISW';
        can_ok $class,'getScheduleFScopeByISW';
        my $object = {};
        bless $object,$class;

#        is($object->getScheduleFScopeByISW($connection,36931055),("IBMOIBMM", "HOSTNAME"),'IBMOIBMM, hostname level');
#        is($object->getScheduleFScopeByISW($connection,192584978),("CUSTOCUSTM", "HWBOX"),'CUSTOCUSTM, HW box level');
        is($object->getScheduleFScopeByISW($connection,242996005),("CUSTOCUSTM", "HWOWNER"), 'CUSTOCUSTM, HW owner level');
        is($object->getScheduleFScopeByISW($connection,57253331),("IBMOIBMMSWCO", "PRODUCT"), 'IBMOIBMMSWCO, product level');
        is($object->getScheduleFScopeByISW($connection,251326833),("CUSTOCUSTM", "MANUFACTURER" ), 'manufacturer level - this test will fail when testing data change');
        is($object->getScheduleFScopeByISW($connection,272310147),("IBMOIBMM", "PRODUCT"), 'manufacturer level skipped, when supposed to');
#        is($object->getScheduleFScopeByISW($connection,120406970),( undef, undef),'undefined ScheduleF');

		$connection->disconnect;
}
1;
