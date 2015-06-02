package licenseToBravo::setReconFlagLogic;

use Test::More;
use base 'Test::Class';
use BRAVO::OM::License;
use BRAVO::Loader::License;

sub class { 'BRAVO::Loader::License' };

my $bravoLicense;
my $stagingLicense;
my $licenseLoader;

sub startup : Tests(startup => 2) {
    my $test = shift;
    use_ok $test->class;

	my $class = $test->class;
	can_ok $class,'compareLicensesAndSetFlags';
	
	$bravoLicense = new BRAVO::OM::License();
	$stagingLicense = new BRAVO::OM::License();
	$licenseLoader = new BRAVO::Loader::License( 1, 1, 1, 2 );
	
	  

}

sub sameLicenses : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);
	is($licenseLoader->saveBravoLicense,0, " Licenses are same, loader will not process license to trailspd.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are same, loader will not add this license to recon queue.");
	
}

sub differentLicenses : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	

	$stagingLicense->capType(2);
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);	
	is($licenseLoader->saveBravoLicense,1, " Licenses not are same, loader will process license to trailspd and add it to recon queue.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are not same, but loader will not add delete flag to recon queue.");	
	
}



sub stagingLicenseIsInactive : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	$licenseLoader->saveBravoLicense(0);
	$licenseLoader->addToReconDeleteFlag(0);	
	$stagingLicense->status('INACTIVE');
	$bravoLicense->status('ACTIVE');
	
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);
	is($licenseLoader->saveBravoLicense,1, " Licences has different status and license will be added to recon and process to trailspd.");
	is($licenseLoader->addToReconDeleteFlag,1, " Licences has different status and license will be added to recon with delete flag.");

}

sub differentLicensesCapType : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	
	$stagingLicense->capType(2);
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);	
	is($licenseLoader->saveBravoLicense,1, " Licenses not are same, loader will process license to trailspd and add it to recon queue.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are not same, but loader will not add delete flag to recon queue.");	
	
}

sub differentLicensesIbmOwned : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	
	$stagingLicense->ibmOwned(0);
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);	
	is($licenseLoader->saveBravoLicense,1, " Licenses not are same, loader will process license to trailspd and add it to recon queue.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are not same, but loader will not add delete flag to recon queue.");	
	
}

sub differentLicensesTryAndBuy : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	
	$stagingLicense->tryAndBuy(0);
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);	
	is($licenseLoader->saveBravoLicense,1, " Licenses not are same, loader will process license to trailspd and add it to recon queue.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are not same, but loader will not add delete flag to recon queue.");	
	
}

sub differentLicensesRecordTime : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	
	$stagingLicense->recordTime('2003-05-31');
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);	
	is($licenseLoader->saveBravoLicense,0, " Licenses not are same (only record time changed), loader will not process license to trailspd and add it to recon queue.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are not same, but loader will not add delete flag to recon queue.");	
	
}

sub differentLicensesPid : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
	
	prepareTestEnvironment();
	
	$stagingLicense->pid('p26190id');
	$licenseLoader->bravoLicense($stagingLicense);
	$licenseLoader->compareLicensesAndSetFlags($bravoLicense);	
	is($licenseLoader->saveBravoLicense,1, " Licenses not are same (only PID changed), loader will not process license to trailspd and add it to recon queue.");
	is($licenseLoader->addToReconDeleteFlag,0, " Licenses are not same, but loader will not add delete flag to recon queue.");	
	
}

sub prepareTestEnvironment {
	$licenseLoader->saveBravoLicense(0);
	$licenseLoader->addToReconDeleteFlag(0);

	$stagingLicense->status('ACTIVE');
	$bravoLicense->status('ACTIVE');	
	
	fullData($bravoLicense,$stagingLicense);  
	
}

sub fullData {
	my ($bravoLicense,$stagingLicense) = @_;
	
		$bravoLicense->id( 1111 );
		$bravoLicense->extSrcId( 'testString' );
		$bravoLicense->licType( 'testString' );
		$bravoLicense->capType( 1 );
		$bravoLicense->customerId( 123 );
		$bravoLicense->quantity( 12 );
		$bravoLicense->ibmOwned( 1 );
		$bravoLicense->draft( 1 );
		$bravoLicense->pool( 1 );
		$bravoLicense->tryAndBuy( 1 );
		$bravoLicense->expireDate( '2003-05-30' );
		$bravoLicense->endDate( '2003-05-30' );
		$bravoLicense->poNumber( 'testString' );
		$bravoLicense->prodName( 'testString' );
		$bravoLicense->fullDesc( 'testString' );
		$bravoLicense->version( 'testString' );
		$bravoLicense->cpuSerial( 'testString' );
		$bravoLicense->lparName( 'testString' );
		$bravoLicense->licenseStatus( 1 );
		$bravoLicense->recordTime( '2003-05-30' );
		$bravoLicense->agreementType( 'testString' );
		$bravoLicense->environment('testString' );
		$bravoLicense->status( 'testString' );
		$bravoLicense->pid( 'testString' );
        
		$stagingLicense->id( 1111 );
		$stagingLicense->extSrcId( 'testString' );
		$stagingLicense->licType( 'testString' );
		$stagingLicense->capType( 1 );
		$stagingLicense->customerId( 123 );
		$stagingLicense->quantity( 12 );
		$stagingLicense->ibmOwned( 1 );
		$stagingLicense->draft( 1 );
		$stagingLicense->pool( 1 );
		$stagingLicense->tryAndBuy( 1 );
		$stagingLicense->expireDate( '2003-05-30' );
		$stagingLicense->endDate( '2003-05-30' );
		$stagingLicense->poNumber( 'testString' );
		$stagingLicense->prodName( 'testString' );
		$stagingLicense->fullDesc( 'testString' );
		$stagingLicense->version( 'testString' );
		$stagingLicense->cpuSerial( 'testString' );
		$stagingLicense->lparName( 'testString' );
		$stagingLicense->licenseStatus( 1 );
		$stagingLicense->recordTime( '2003-05-30' );
		$stagingLicense->agreementType( 'testString' );
		$stagingLicense->environment('testString' );
		$stagingLicense->status( 'testString' );
        $stagingLicense->pid( 'testString' );
}

1;