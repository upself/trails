package t::unit_test::ATPDelegate::getHWLparCustomerId;

use Test::More;
use base 'Test::Class';

sub class { 'ATP::Delegate::ATPDelegate' }


sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub getHWLparCustomerId : Tests(2) {
	my $test  = shift;
	my $class = $test->class;
    use_ok $test->class;
    can_ok $class,'getHWLparCustomerId';

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
		lparCustomerNumber => '333333'
	);
	
	%rec2 = (
		country => 'CA',
		lparCustomerNumber => '333333'
	);
	%rec3 = (
		country => 'AA',
		lparCustomerNumber => '2222XX'
	);
	%rec4 = (
		country => 'AA',
		lparCustomerNumber => '1212XX'
	);	
			
	is($class->getHWLparCustomerId(\%data_customer_number,\%data_account_number,%rec1),undef, "getHWLparCustomerId (offline) : customer number not found");
	is($class->getHWLparCustomerId(\%data_customer_number,\%data_account_number,%rec2),33, "getHWLparCustomerId (offline) : customer number found");
	is($class->getHWLparCustomerId(\%data_customer_number,\%data_account_number,%rec3),22, "getHWLparCustomerId (offline) : account number found");
	is($class->getHWLparCustomerId(\%data_customer_number,\%data_account_number,%rec4),undef, "getHWLparCustomerId (offline) : account number not found");
}

1;