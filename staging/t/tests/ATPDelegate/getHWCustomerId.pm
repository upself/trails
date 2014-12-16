package ATPDelegate::getHWCustomerId;

use Test::More;
use base 'Test::Class';
use Database::Connection;
use CNDB::Delegate::CNDBDelegate;

sub class { 'ATP::Delegate::ATPDelegate' }


sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub getHWCustomerId : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
    use_ok $test->class;
    can_ok $class,'getHWCustomerId';

    my %data_customer_number;
    my %data_account_number;
}

sub own_created_data_test : Tests(4) {
	my $test  = shift;
	my $class = $test->class;
	
    my %data_customer_number;
    my %data_account_number;
    
    my %rec1;
    my %rec2;
    my %rec3;
    my %rec4;
    
    $data_account_number{'1111XX' }{'count'} = 1;
    $data_account_number{'1111XX' }{'customerId'} = 11;

    $data_account_number{'2222XX' }{'count'} = 1;
    $data_account_number{'2222XX' }{'customerId'} = 22;
    
    $data_customer_number{'333333'}{'count'} = 1;    	
	$data_customer_number{'333333'}{'CA'} = 33;
	
	%rec1 = (
		country => 'IN',
		customerNumber => '333333'
	);
	
	%rec2 = (
		country => 'CA',
		customerNumber => '333333'
	);
	%rec3 = (
		country => 'AA',
		customerNumber => '2222XX'
	);
	%rec4 = (
		country => 'AA',
		customerNumber => '1212XX'
	);	
			
	is($class->getHWCustomerId(\%data_customer_number,\%data_account_number,%rec1),undef, "getHWCustomerId (offline) : customer number not found");
	is($class->getHWCustomerId(\%data_customer_number,\%data_account_number,%rec2),33, "getHWCustomerId (offline) : customer number found");
	is($class->getHWCustomerId(\%data_customer_number,\%data_account_number,%rec3),22, "getHWCustomerId (offline) : account number found");
	is($class->getHWCustomerId(\%data_customer_number,\%data_account_number,%rec4),undef, "getHWCustomerId (offline) : account number not found");
}

sub semi_online_test : Tests(10) {
	 my $test  = shift;
     my $class = $test->class;
     pass("Semi online test - !! If test fails, check test expected results and data from CNDB first.!!");
     pass("Test connects to cndb and check if customer_number or account_number returns ");
     
     my $connection = Database::Connection->new('cndb');
     isnt($connection,0," cndb connection is set up");
     
     my ($customerNumberMap, $accountNumberMap) = CNDB::Delegate::CNDBDelegate->getCustomerNumberMap;
     
    my %rec1 = ( country => 'US', customerNumber => '1402227' );	
	my %rec2 = ( country => 'CH', customerNumber => 'CINCN06' );
	my %rec3 = ( country => 'US', customerNumber => '1111111' );
	my %rec4 = ( country => 'IN', customerNumber => '175239X' );
	my %rec5 = ( country => 'XX', customerNumber => '175234X' );
	my %rec6 = ( country => 'XX', customerNumber => '175642X' );	
	my %rec7 = ( country => 'XX', customerNumber => '111XXXX' );	
	
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec1),25,"getHWCustomerId : country_number 1402227, country US -> customer: 25");     
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec2),17908,"getHWCustomerId : country_number CINCN06, country CH -> customer: 17908");
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec3),undef,"getHWCustomerId : country_number 1111111, country US -> customer: undef"); 
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec4),17907,"getHWCustomerId : account_number 175239X, country IN -> customer: 17907");
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec5),17906,"getHWCustomerId : account_number 175234X, country XX -> customer: 17906");
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec6),18126,"getHWCustomerId : account_number 175642X, country XX -> customer: 18126");
    is($class->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec7),undef,"getHWCustomerId : account_number 111XXXX, country XX -> customer: undef");
}



1;