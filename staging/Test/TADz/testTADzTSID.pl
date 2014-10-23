#!/usr/bin/perl -w
package Test::TADz;

use lib "/opt/staging/v2/";
use Test::More tests => 24;

use Sigbank::Delegate::BankAccountDelegate;
use Sigbank::OM::BankAccount;
use Scan::Delegate::ScanTADzDelegate;
use Recon::Lpar;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::HardwareLpar;
$laptop = 0;

$bankAccount1 = Sigbank::OM::BankAccount->new;
$bankAccount2 = Sigbank::OM::BankAccount->new;
$bankAccount3 = Sigbank::OM::BankAccount->new;
$bankAccount4 = Sigbank::OM::BankAccount->new;

$bankAccount1->databaseName("P0DDB2C");
$bankAccount1->name("BANK1");
$bankAccount1->id(1);
$bankAccount2->databaseName("AAZDDBEP");
$bankAccount2->name("BANK2");
$bankAccount2->id(2);
$bankAccount3->databaseName("EGN0DBS0");
$bankAccount3->name("BANK3");
$bankAccount3->id(3);
$bankAccount4->databaseName("NO_DB2");
$bankAccount4->name("BANK4");
$bankAccount4->id(4);

$softwareLpar1 = BRAVO::OM::SoftwareLpar->new;
$softwareLpar1->techImgId("ABCD");

$hardwareLpar1 = BRAVO::OM::HardwareLpar->new;
$hardwareLpar1->techImageId("ABCD");

$lparReconSoftware = Recon::Lpar->new;
$lparReconSoftware->softwareLpar($softwareLpar1);

$lparReconHardware = Recon::Lpar->new;
$lparReconHardware->hardwareLpar($hardwareLpar1);

my $trailsConnection;
my $stagingConnection;

# laptop setup
if ($laptop) {
	loadTechImgIdLaptop();
}
else {
	$trailsConnection  = Database::Connection->new('trails');
	$stagingConnection = Database::Connection->new('staging');
	$lparReconSoftware->connection($trailsConnection);
	ScanTADzDelegate->loadTechImgId($stagingConnection);
	$lparReconHardware->connection($trailsConnection);

}

sub loadTechImgIdLaptop {
	ScanTADzDelegate->insertTechImgId("AAAA", "DONNIE", 1 );
	ScanTADzDelegate->insertTechImgId("BBBB", "BILL",   2 );
	ScanTADzDelegate->insertTechImgId("CCCC", "HOLGER", 3 );
	return 3;
}

sub initSr {
	my ( $bankAccountId, $id, $computerId, $name, $serialNumber, $techImgId,
		$extId )
	  = @_;
	$sr = Staging::OM::ScanRecord->new;
	$sr->bankAccountId($bankAccountId);
	$sr->isManual(0);
	$sr->id($id);
	$sr->computerId($computerId);
	$sr->name($name);
	$sr->serialNumber($serialNumber);
	$sr->techImgId($techImgId);
	$sr->extId($extId);
	return $sr;
}

my $scanRecord1 = initSr( 1, 1, "CCC", "DONNIE", "0000000023", "AAAA", "AAAA" );
my $scanRecord2 = initSr( 2, 1, "CCC", "DONNIE", "3232323",    "BBBB", "BBBB" );
my $scanRecord3 = initSr( 3, 1, "CCC", "DONNIE", "NOT SERIAL", "CCCC", "CCCC" );
my $scanRecord4 = initSr( 1, 1, "CCC", "DONNIE", "BADSERIAL",, );
my $scanRecord5 = initSr( 2, 1, "CCC", "DONNIE", "AAAA1133", "EEEE", "EEEE" );
my $scanRecord6 = initSr( 3, 1, "CCC", "DONNIE", "AAAA1133", "MEEEE", "MEEEE" );

my $infra1 = ScanTADzDelegate->getTADzInfrastructure($bankAccount1);
my $infra2 = ScanTADzDelegate->getTADzInfrastructure($bankAccount2);
my $infra3 = ScanTADzDelegate->getTADzInfrastructure($bankAccount3);
my $infra4 = ScanTADzDelegate->getTADzInfrastructure($bankAccount4);
my $infra5 = ScanTADzDelegate->getTADzInfrastructure(undef);

print "\nP0DDB2C mapping\n";
is( $infra1, "AG", "P0DDB2C mapped to AG" );
print "\nAG FULL SQL:" . ScanTADzDelegate->getCorrectSQL( $infra1, 0, $bankAccount1 ) . "\n";
print "\nAAZDDBEP mapping\n";
is( $infra2, "ANZ", "AAZDDBEP mapped to ANZ" );
print "\nANZ FULL SQL:" . ScanTADzDelegate->getCorrectSQL( $infra2, 0, $bankAccount2 ) . "\n";
print "\nEGN0DBS0 mapping\n";
is( $infra3, "EMEA", "EGN0DBS0 mapped to EMEA" );
print "\nEMEA Delta SQL:"
  . ScanTADzDelegate->getCorrectSQL( $infra3, 1,$bankAccount3 ) . "\n";
print "\nInvalid databaseName mapping\n";
is( $infra4, "ERROR", "NO_DB2 worked" );
print "\nblank bankAccount mapping\n";
is( $infra5, "ERROR", "BLANK BANK ACCOUNT WORKED" );

if ( !$laptop ) {
	is( ScanTADzDelegate->loadTechImgId($stagingConnection), 3,
		"Map test ran but expected to fail on server as it is a dynamic value"
	);
}
else {
	is( 1, 1, "Running on laptop -- loadTechImgId not tested" );
}

if ( $laptop ) {
print
  "\nLPAR_NAME and matching hardware_lpar name same before and after match\n";
} else {
	print "\nLPAR_NAME and matching not valid on server disregard the next tests\n";
}
is( ScanTADzDelegate->mapTSID( $scanRecord1, $bankAccount1 ),
	"DONNIE", "AAAA mapped correctly" );
is( $scanRecord1->name,     "DONNIE",       "LPAR_NAME correct in ScanRecord" );
is( $scanRecord1->objectId, "CUSTOMER_ID1", "CUSTOMER_ID set in ObjectId" );

print "\nLPAR_NAME changed due to TSID match\n";
is( ScanTADzDelegate->mapTSID( $scanRecord2, $bankAccount2 ),
	"BILL", "BBBB mapped correctly" );
is( $scanRecord2->objectId, "CUSTOMER_ID2", "CUSTOMER_ID set in ObjectId" );

#is ($scanRecord2->name, "BILL", "LPAR_NAME correct in ScanRecord");
is( ScanTADzDelegate->getTSIDCustomerId($scanRecord2),
	2, "Retreive customer number from ObjectId" );

print "\nLPAR_NAME changed due to TSID match\n";
is( ScanTADzDelegate->mapTSID( $scanRecord3, $bankAccount3 ),
	"HOLGER", "CCCC mapped correctly" );
is( ScanTADzDelegate->getTSIDCustomerId($scanRecord3),
	3, "Retreive customer number from ObjectId" );
is( $scanRecord3->objectId, "CUSTOMER_ID3", "CUSTOMER_ID set in ObjectId" );

print "\nBlank TSID passed\n";
is(
	ScanTADzDelegate->mapTSID( $scanRecord4, $bankAccount1 ),
	"BLANK_TSID",
	"Blank TSID behaved correctly"
);
is( $scanRecord4->objectId, "BANK1", "Object ID mapped to bank account name" );
is( ScanTADzDelegate->getTSIDCustomerId($scanRecord4),
	0, "No customer number from ObjectId" );

print "\nValid TSID but does not match HARDWARE_LPAR.TECH_IMG_ID\n";
is(
	ScanTADzDelegate->mapTSID( $scanRecord5, $bankAccount2 ),
	"NO_MATCH",
	"Not found TSID behaved correctly"
);
is( $scanRecord5->objectId, "BANK2", "Object ID mapped to bank account name" );

print "\nTSID but not valid due to too many characters\n";
is( ScanTADzDelegate->mapTSID( $scanRecord6, $bankAccount3 ),
	"INVALID", "Invalid TSID behaved correctly" );
is( $scanRecord6->objectId, "BANK3", "Object ID mapped to bank account name" );

# Check composite building logic
if ( $laptop ) {
	print "Running on laptop thus remaining tests worthless. Disregard errors past this point\n";
}
$lparReconSoftware->findUniqueExtIdMatch();
if ( defined $lparReconSoftware->hardwareLpar ) {
	is( $lparReconSoftware->hardwareLpar->name, "TEST",
"Pulled hardware lpar by TSID -- Only passes if not connected to database using dummy data"
	);
}
else {
	is( 1, 1,
"Must be on server -- findUniqueExtIdMatch test bypassed when connected to database"
	);
}

# Check composite building logic
$lparReconHardware->findUniqueExtIdMatch();
if ( defined $lparReconHardware->softwareLpar ) {
	is( $lparReconHardware->softwareLpar->name, "TEST",
"Pulled software lpar by TSID -- Only passes if not connected to database using dummy data"
	);
}
else {
	is( 1, 1,
"Must be on server -- findUniqueExtIdMatch test bypassed when connected to database"
	);
}

