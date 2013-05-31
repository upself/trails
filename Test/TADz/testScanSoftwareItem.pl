#!/usr/bin/perl -w
package Test::TADz;

use lib "/opt/staging/v2/";
use Test::More tests => 0;

use Staging::ScanSoftwareItemLoader;
use Staging::OM::ScanSoftwareItem;
use Sigbank::Delegate::BankAccountDelegate;
use Sigbank::OM::BankAccount;
use Staging::Delegate::StagingDelegate;

my $bankAccount =
  Sigbank::Delegate::BankAccountDelegate->getBankAccountById(941);

my $connection        = Database::Connection->new($bankAccount);
my $stagingConnection = Database::Connection->new('staging');

my $scanSoftwareItemLoader = Staging::ScanSoftwareItemLoader->new('GEC');

# load the source data -- this is only testing if things in STAGING are incorrectly being counted as
# needing an update.
$scanSoftwareItemLoader->list(
	ScanSoftwareItemDelegate->getScanSoftwareItemData(
		$connection, $bankAccount, 0
	)
);

foreach my $key ( keys %{ $scanSoftwareItemLoader->list } ) {
	print $key . "\n";
}
$stagingConnection->prepareSqlQuery(
	Staging::Delegate::StagingDelegate->queryScanSoftwareItemData(
		0, $bankAccount->id
	)
);

###Define our fields
my @fields = (qw(id scanRecordId guId lastUsed useCount action bankAccountId));

###Get the statement handle
my $sth = $stagingConnection->sql->{scanSoftwareItemData};

###Bind our columns
my %rec;
$sth->bind_columns( map { \$rec{$_} } @fields );

$sth->execute();
while ( $sth->fetchrow_arrayref ) {
	print $rec{id} . "\n";
	my $st = new Staging::OM::ScanSoftwareItem();
	$st->id( $rec{id} );
	$st->scanRecordId( $rec{scanRecordId} );
	$st->guId( $rec{guId} );
	$st->lastUsed( $rec{lastUsed} );
	$st->useCount( $rec{useCount} );
	$st->action( $rec{action} );
	my $key = $rec{scanRecordId} . '|' . $rec{guId};

	if ( exists $scanSoftwareItemLoader->list->{$key} ) {
		if ( !$st->equals( $scanSoftwareItemLoader->list->{$key} ) ) {
			print $st->toString()
			  . $scanSoftwareItemLoader->list->{$key}->toString();
			print "$key Does not equal\n";
		}
	}

}

print "Finished\n";
