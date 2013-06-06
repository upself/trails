#!/usr/local/bin/perl -w

use DBI;
use Config::Properties::Simple;
use Getopt::Std;

use strict;

our ($opt_u);
getopts("u:");
usage() unless ( defined $opt_u );

my $cfg = Config::Properties::Simple->new( file => $opt_u . ".ini" );

my $stageDatabase         = $cfg->getProperty('stageDatabase');
my $stageDatabaseUser     = $cfg->getProperty('stageDatabaseUser');
my $stageDatabasePassword = $cfg->getProperty('stageDatabasePassword');

my $reportDatabase         = $cfg->getProperty('reportDatabase');
my $reportDatabaseUser     = $cfg->getProperty('reportDatabaseUser');
my $reportDatabasePassword = $cfg->getProperty('reportDatabasePassword');

# Open a connections
my $dbhReporting = DBI->connect(
	"dbi:DB2:$reportDatabase", "$reportDatabaseUser",
	"$reportDatabasePassword", { RaiseError => 1 }
);
my $dbhStage = DBI->connect(
	"dbi:DB2:$stageDatabase", "$stageDatabaseUser",
	"$stageDatabasePassword", { RaiseError => 1 }
);

my $stmt =
  "Select id, name from eaadmin.bank_account where type = 'TADZ' with ur";
my $sth = $dbhReporting->prepare($stmt);
$sth->execute();
my $bankAccountId;
my $bankName;

$sth->bind_col( 1, \$bankAccountId );
$sth->bind_col( 2, \$bankName );

my %bankAccounts;

while ( $sth->fetch ) {
	$bankAccounts{$bankAccountId} = $bankName;
}

my $bankList;

while ( my ( $bNum, $bName ) = each %bankAccounts ) {
	if ( length($bankList) < 1 ) {
		$bankList = $bNum;
	}
	else {
		$bankList .= ",$bNum";
	}
}

$sth->finish;
my $stmt2 =
"select software_lpar.action,software_lpar.name,bios_serial,software_lpar.id, bank_account_id,software_lpar.customer_id from software_lpar, scan_record, software_lpar_map 
where software_lpar.id = software_lpar_map.software_lpar_id and
scan_record.id = software_lpar_map.scan_record_id and
bank_account_id in ($bankList) with ur;
";
print $stmt2;
my $sth2 = $dbhStage->prepare($stmt2);
$sth2->execute();
my $action;
my $name;
my $serial;
my $softwareLparId;
my $thisBankAccountId;
my $customerId;
$sth2->bind_col( 1, \$action );
$sth2->bind_col( 2, \$name );
$sth2->bind_col( 3, \$serial );
$sth2->bind_col( 4, \$softwareLparId );
$sth2->bind_col( 5, \$thisBankAccountId );
$sth2->bind_col( 6, \$customerId );
my %stageLpar;

while ( $sth2->fetch ) {
	my $serial5 = substr( $serial, -5, 5 );
	my $serial4 = substr( $serial, -4, 4 );
	$stageLpar{$softwareLparId} = {
		action        => "$action",
		name          => "$name",
		serial        => "$serial",
		serial4       => "$serial4",
		serial5       => "$serial5",
		bankAccountId => "$thisBankAccountId",
		customerId    => "$customerId",
	};

	#	print "$serial5 $serial4\n";
}
$sth2->finish;

$dbhStage->disconnect();

my $stmt3 =
"select eaadmin.software_lpar.status, eaadmin.software_lpar.name, bios_serial, scantime, account_number,
customer_name, match_method, eaadmin.software_lpar.id,
eaadmin.country_code.code,
eaadmin.geography.name
from eaadmin.software_lpar
left outer join eaadmin.hw_sw_composite on eaadmin.software_lpar.id = eaadmin.hw_sw_composite.software_lpar_id
join eaadmin.customer on eaadmin.software_lpar.customer_id = eaadmin.customer.customer_id
left join eaadmin.country_code on eaadmin.customer.country_code_id = eaadmin.country_code.id
left outer join eaadmin.region on eaadmin.country_code.region_id = eaadmin.region.id
left outer join eaadmin.geography on eaadmin.region.geography_id = eaadmin.geography.id
where eaadmin.software_lpar.name = ? and eaadmin.software_lpar.customer_id = ?
with ur";

#my $stmt3 = "select id  from eaadmin.software_lpar where name = ? and customer_id = ? with ur";
while ( my ( $stageId, $swLpar ) = each %stageLpar ) {
	my $sth3 = $dbhReporting->prepare($stmt3);
	$sth3->execute( $stageLpar{$stageId}{name}, $stageLpar{$stageId}{customerId} );
	my $status;
	my $LparName;
	my $biosSerial;
	my $scanTime;
	my $accountNumber;
	my $customerName;
	my $matchMethod;
	my $slId;
	my $countryCode;
	my $geography;
	my $matchMade;
	$sth3->bind_col( 1,  \$status );
	$sth3->bind_col( 2,  \$LparName );
	$sth3->bind_col( 3,  \$biosSerial );
	$sth3->bind_col( 4,  \$scanTime );
	$sth3->bind_col( 5,  \$accountNumber );
	$sth3->bind_col( 6,  \$customerName );
	$sth3->bind_col( 7,  \$matchMethod );
	$sth3->bind_col( 8,  \$slId );
	$sth3->bind_col( 9,  \$countryCode );
	$sth3->bind_col( 10, \$geography );

	if ( $sth3->fetch ) {
		if ( defined $matchMethod ) {
			$matchMade = $matchMethod;
		}
		else {
			$matchMade = "NOT MATCHED";
		}
		$stageLpar{$stageId}{trailsSL}              = $slId;
		$stageLpar{$stageId}{trailsStatus}        = $status;
		$stageLpar{$stageId}{trailsLparName}      = $LparName;
		$stageLpar{$stageId}{trailsBiosSerial}    = $biosSerial;
		$stageLpar{$stageId}{trailsScanTime}      = $scanTime;
		$stageLpar{$stageId}{trailsAccountNumber} = $accountNumber;
		$stageLpar{$stageId}{trailsCustomerName}  = $customerName;
		$stageLpar{$stageId}{trailsMatchMethod}   = $matchMade;
		if ( defined $countryCode && length($countryCode) > 1 ) {
			$stageLpar{$stageId}{trailsCountryCode} = $countryCode;
			$stageLpar{$stageId}{trailsGeography}   = $geography;
		}
		else {
			$stageLpar{$stageId}{trailsCountryCode} = "NA";
			$stageLpar{$stageId}{trailsGeography}   = "NA";

		}
	}
	else {
		print "$stageId not found\n";
	}
	$sth3->finish;
}


$dbhReporting->disconnect();

open REPORT, ">$0" . ".txt";

print REPORT
"S-action,S-name,S-serial,S-serial4,S-serial5,S-bankAccountId,S-bankAccountName,T-Status,T-LparName,"
  . "T-BiosSerial,T-ScanTime,T-AccountNumber,T-CustomerName,T-MatchMethod,T-CountryCode,T-Geography\n";

# print the information we have
while ( my ( $slNumPrint, $swLparPrint ) = each %stageLpar ) {
	print REPORT $stageLpar{$slNumPrint}{action} . ",";
	print REPORT $stageLpar{$slNumPrint}{name} . ",";
	print REPORT "\"" . $stageLpar{$slNumPrint}{serial} . "\",";
	print REPORT $stageLpar{$slNumPrint}{serial4} . ",";
	print REPORT $stageLpar{$slNumPrint}{serial5} . ",";
	print REPORT $stageLpar{$slNumPrint}{bankAccountId} . ",";
	print REPORT $bankAccounts{ $stageLpar{$slNumPrint}{bankAccountId} } . ",";
	if ( defined $stageLpar{$slNumPrint}{trailsStatus} ) {
		print REPORT $stageLpar{$slNumPrint}{trailsStatus} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsLparName} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsBiosSerial} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsScanTime} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsAccountNumber} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsCustomerName} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsMatchMethod} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsCountryCode} . ",";
		print REPORT $stageLpar{$slNumPrint}{trailsGeography};
	}
	else {
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA";
	}
	print REPORT "\n";
}
close REPORT;
exit 0;

sub lookupLpar {
	my ($idToLookup) = shift @_;
	while ( my ( $id, $Lpar ) = each %stageLpar ) {
		if (   ( defined $stageLpar{$id}{trailsSL} )
			&& ( $stageLpar{$id}{trailsSL} eq $idToLookup ) )
		{
			return $id;
		}
	}
	return 0;

}

sub usage {
	print "$0 -u <userId>\n";
	exit 0;
}

