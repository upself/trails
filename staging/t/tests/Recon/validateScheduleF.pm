package Recon::validateScheduleF;

use Test::More;
use base 'Test::Class';
use Database::Connection;

sub class { 'Recon::Delegate::ReconLicenseValidation' };

sub startup : Tests(startup => 1) {
        my $tmp = shift;
        use_ok $tmp->class;
}

sub scheduleFbyISW : Tests(14) {
        my $test = shift;
        my $class = $test->class;

#        my $connection=Database::Connection->new('trails');

        can_ok $class,'validateScheduleF';
        my $object = {};
        bless $object,$class;

		# my ( $self, $ibmOwned, $swComplianceMgmt, $scopeName, $scopeLevel, $reconcileId, $isManual, $isMachineLevel )

        is($object->validateScheduleF(1, 'YES', 'IBMOIBMM', 4, 12345, 1, 1),0,'machine level invalid on hostname ScheduleF');
        is($object->validateScheduleF(1, 'YES', 'IBMOIBMM', 1, 12345, 1, 1),1,'machine level valid on product ScheduleF');
        is($object->validateScheduleF(0, 'YES', 'IBMO3RDM', 1, 12345, 0, 1),0,'IBMO3RDM invalid for autoreconcile');
        is($object->validateScheduleF(0, 'NO', 'IBMO3RDM', 1, 12345, 1, 1),0,'IBMO3RDM invalid for customer license');
        is($object->validateScheduleF(1, 'NO', 'IBMO3RDM', 1, 12345, 1, 1),1,'IBMO3RDM valid');
        is($object->validateScheduleF(0, 'YES', 'CUSTOCUSTM', 1, 12345, 0, 1),0,'CUSTOCUSTM invalid for autoreconcile');
        is($object->validateScheduleF(1, 'YES', 'CUSTOCUSTM', 1, 12345, 1, 1),0,'CUSTOCUSTM invalid for IBM owned license');
        is($object->validateScheduleF(1, 'YES', 'CUSTOIBMM', 1, 12345, 0, 1),0,'CUSTOIBMM invalid for IBM owned license');
        is($object->validateScheduleF(0, 'YES', 'CUSTOIBMM', 1, 12345, 0, 1),1,'CUSTOIBMM valid');
        is($object->validateScheduleF(1, 'NO', 'CUSTO3RDM', 1, 12345, 0, 1),0,'CUSTO3RDM invalid for compliance mgmt = NO and IBM-owned license');
        is($object->validateScheduleF(0, 'YES', 'CUSTO3RDM', 1, 12345, 0, 1),0,'CUSTO3RDM invalid for compliance mgmt = YES');
        is($object->validateScheduleF(0, 'NO', 'CUSTO3RDM', 1, 12345, 0, 1),1,'CUSTO3RDM valid');
        is($object->validateScheduleF(0, 'NO', 'XYZ', 1, 12345, 0, 1),0,'invalid scheduleF name');

#		$connection->disconnect;
}
1;
