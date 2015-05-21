package hardwareToBravo::setReconFlagLogic;

use Test::More;
use base 'Test::Class';
use BRAVO::OM::Hardware;
use Staging::OM::Hardware;

sub class { 'BRAVO::Loader::Hardware' }


sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub offline_test_1 : Tests(14) {
	my $test  = shift;
	my $class = $test->class;
	
	my $bravoHardware_1 = new BRAVO::OM::Hardware();
	
	my $stagingHardware_1 = new Staging::OM::Hardware();
	
	fullData($bravoHardware_1,$stagingHardware_1);
	
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),0, " Hardwares are equal.");
	
	$stagingHardware_1->hardwareStatus( 'HWCOUNT' );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Staging hardwareStatus is HWCOUNT, bravo hardwareStatus is not HWCOUNT.");

	$bravoHardware_1->hardwareStatus( 'HWCOUNT' );	
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),0, " Staging hardwareStatus is HWCOUNT, bravo hardwareStatus is HWCOUNT.");
	
	$stagingHardware_1->hardwareStatus( 'testString' );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Bravo hardwareStatus is HWCOUNT, staging hardwareStatus is not HWCOUNT.");
	
	$bravoHardware_1->hardwareStatus( 'testString' );
	$bravoHardware_1->processorCount( 5 );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Processor counts are not equal.");
	
	$stagingHardware_1->processorCount( 5 );
	$stagingHardware_1->chips( 5 );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Chips are not equal.");
	
	$bravoHardware_1->chips( 5 );
	$bravoHardware_1->machineTypeId( 12 );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Machine type ids are not equal.");
	
	$stagingHardware_1->machineTypeId( 12 );
	$stagingHardware_1->model( 'model' );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Models are not equal.");
	
	$bravoHardware_1->model( 'model' );
	$bravoHardware_1->processorType( 'type' );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Processor Types are not equal.");
		
	$stagingHardware_1->processorType( 'type' );
	$stagingHardware_1->cpuMIPS( 5 );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Cpu MIPS are not equal.");

	$bravoHardware_1->cpuMIPS( 5 );
	$bravoHardware_1->cpuMSU( 5 );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " Cpu MSU are not equal.");


	$stagingHardware_1->cpuMSU( 5 );
	$stagingHardware_1->nbrCoresPerChip ( 5 );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),1, " nbrCoresPerChip are not equal.");
	
	$bravoHardware_1->nbrCoresPerChip ( 5 );
	
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),0, " Hardwares are equal.");
	
	$bravoHardware_1->country ( 'country' );
	$bravoHardware_1->cloudName( 'cloud name' );
	is($class->setReconFlagHardwares($stagingHardware_1,$bravoHardware_1),0, " Cauntry and cloudName are equal.");
}

sub fullData {
	my ($bravoHardware,$stagingHardware) = @_;
	
        $bravoHardware->machineTypeId( 123456 );
        $bravoHardware->serial( 123456 );
        $bravoHardware->customerNumber( 'testString' );
        $bravoHardware->owner( 'testString' );
        $bravoHardware->hardwareStatus( 'testString' );
        $bravoHardware->country( 'testString' );
        $bravoHardware->status( 'testString' );
        $bravoHardware->processorCount( 4 );
        $bravoHardware->customerId( 123456 );
        $bravoHardware->model( 'testString' );
        $bravoHardware->classification( 'testString' );
        $bravoHardware->chips( 4 );
        $bravoHardware->processorType( 'testString' );
        $bravoHardware->mastProcessorType( 'testString' );
        $bravoHardware->cpuMIPS( 4 );
        $bravoHardware->cpuMSU( 4 );
        $bravoHardware->cpuGartnerMIPS( 'testString' );
        $bravoHardware->processorManufacturer( 'testString' );
        $bravoHardware->processorModel( 'testString' );
        $bravoHardware->nbrCoresPerChip( 4 );
        $bravoHardware->nbrOfChipsMax( 'testString' );
        $bravoHardware->shared( 'testString' );
        $bravoHardware->sharedProcessor( 'testString' );
        $bravoHardware->cloudName( 'testString' );
        $bravoHardware->chassisId( 4 );
        $bravoHardware->cpuIFL( 4 );
        
        $stagingHardware->machineTypeId( 123456 );
        $stagingHardware->serial( 123456 );
        $stagingHardware->customerNumber( 'testString' );
        $stagingHardware->owner( 'testString' );
        $stagingHardware->hardwareStatus( 'testString' );
        $stagingHardware->country( 'testString' );
        $stagingHardware->status( 'testString' );
        $stagingHardware->processorCount( 4 );
        $stagingHardware->customerId( 123456 );
        $stagingHardware->model( 'testString' );
        $stagingHardware->classification( 'testString' );
        $stagingHardware->chips( 4 );
        $stagingHardware->processorType( 'testString' );
        $stagingHardware->mastProcessorType( 'testString' );
        $stagingHardware->cpuMIPS( 4 );
        $stagingHardware->cpuMSU( 4 );
        $stagingHardware->cpuGartnerMIPS( 'testString' );
        $stagingHardware->processorManufacturer( 'testString' );
        $stagingHardware->processorModel( 'testString' );
        $stagingHardware->nbrCoresPerChip( 4 );
        $stagingHardware->nbrOfChipsMax( 'testString' );
        $stagingHardware->shared( 'testString' );
        $stagingHardware->sharedProcessor( 'testString' );
        $stagingHardware->cloudName( 'testString' );
        $stagingHardware->chassisId( 4 );
        $stagingHardware->cpuIFL( 4 );
        
}

1;