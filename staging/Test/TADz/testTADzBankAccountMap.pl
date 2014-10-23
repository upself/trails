#!/usr/bin/perl -w
package Test::TADz;

use lib "/opt/staging/v2/";
use Test::More tests => 8;

use Staging::ScanRecordToLparLoader;
use Staging::OM::ScanRecord;
use Sigbank::Delegate::BankAccountDelegate;
use Sigbank::OM::BankAccount;

$scanRecordLoader = Staging::ScanRecordToLparLoader->new;
$bankAccount      = Sigbank::OM::BankAccount->new;
$bankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountById(941);
# @bankAccounts = Sigbank::Delegate::BankAccountDelegate->getBankAccountIdsByType('TADZ');

sub initSr {
	my ( $bankAccountId, $id, $computerId, $name, $serialNumber ) = @_;
	$sr = Staging::OM::ScanRecord->new;
	$sr->bankAccountId($bankAccountId);
	$sr->isManual(0);
	$sr->id($id);
	$sr->computerId($computerId);
	$sr->name($name);
	$sr->serialNumber($serialNumber);
	return $sr;
}

sub getHardwareLparCustomerMap {
	my ( $self, $connection ) = @_;

	my %data;
	my $data2;

	$data2 = ();

	my $shortName = "DONNIE";

	$data2->{"DONNIE.NOT"}->{'serialNumber'} = "010023";
	$data2->{"DONNIE.NOT"}->{'customerId'}   = "32";
	push( @{ $data{ uc($shortName) } }, $data2 );
	$data2->{"DONNIE"}->{'serialNumber'} = "000023";
	$data2->{"DONNIE"}->{'customerId'}   = "3";
	push( @{ $data{ uc($shortName) } }, $data2 );
	$data2->{"DONNIE.COM"}->{'serialNumber'} = "3232323";
	$data2->{"DONNIE.COM"}->{'customerId'}   = "4";
	push( @{ $data{ uc($shortName) } }, $data2 );
	$data2->{"DONNIE.ORG"}->{'serialNumber'} = "111133";
	$data2->{"DONNIE.ORG"}->{'customerId'}   = "7";
	push( @{ $data{ uc($shortName) } }, $data2 );
	$data2->{"DONNIE.NET"}->{'serialNumber'} = "323421";
	$data2->{"DONNIE.NET"}->{'customerId'}   = "8";
	push( @{ $data{ uc($shortName) } }, $data2 );
	return \%data;
}

my $scanRecord1 = initSr( 941, 1, "CCC", "DONNIE", "0000000023" );
my $scanRecord2 = initSr( 941, 1, "CCC", "DONNIE", "3232323" );
my $scanRecord3 = initSr( 941, 1, "CCC", "DONNIE", "NOT SERIAL" );
my $scanRecord4 = initSr( 941, 1, "CCC", "DONNIE", "BADSERIAL" );
my $scanRecord5 = initSr( 941, 1, "CCC", "DONNIE", "AAAA1133" );
$scanRecordLoader->hwLparMap( getHardwareLparCustomerMap() );
$scanRecordLoader->tadzAccountMap( Sigbank::Delegate::BankAccountDelegate->getBankAccountIdsByType('TADZ') );
is( $scanRecordLoader->isTADz(941), 1, 'Should be TADz' );
is( $scanRecordLoader->isTADz(942), 1, 'Should be TADz' );
is( $scanRecordLoader->isTADz(0), 0, 'Should NOT be TADz' );
is( $scanRecordLoader->isTADz(1), 0, 'Should NOT be TADz' );
is( $scanRecordLoader->isTADz(2), 0, 'Should NOT be TADz' );
is( $scanRecordLoader->isTADz(3), 0, 'Should NOT be TADz' );
is( $scanRecordLoader->getCustomerId($scanRecord2),
	4, 'customer lookup test 2' );
is( $scanRecordLoader->getCustomerId($scanRecord3),
	999999, 'customer lookup - bad serial' );


