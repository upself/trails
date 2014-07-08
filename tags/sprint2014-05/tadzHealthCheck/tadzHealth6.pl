#!/usr/local/bin/perl -w

use DBI;
use Config::Properties::Simple;
use Getopt::Std;

use strict;  

our ( $opt_u );
getopts("u:");
usage() unless ( defined $opt_u );


my $cfg = Config::Properties::Simple->new(file => $opt_u .  ".ini"); 

my $stageDatabase = $cfg->getProperty('stageDatabase');
my $stageDatabaseUser = $cfg->getProperty('stageDatabaseUser');
my $stageDatabasePassword = $cfg->getProperty('stageDatabasePassword');

my $reportDatabase = $cfg->getProperty('reportDatabase');
my $reportDatabaseUser = $cfg->getProperty('reportDatabaseUser');
my $reportDatabasePassword = $cfg->getProperty('reportDatabasePassword');

# Open a connections 
my $dbhReporting = DBI->connect("dbi:DB2:$reportDatabase", "$reportDatabaseUser", "$reportDatabasePassword", {RaiseError => 1});
my $dbhStage = DBI->connect("dbi:DB2:$stageDatabase", "$stageDatabaseUser", "$stageDatabasePassword", {RaiseError => 1});

my $stmt = "Select id, name from eaadmin.bank_account where type = 'TADZ' with ur";
my $sth = $dbhReporting->prepare($stmt);
$sth->execute();
my $bankAccountId;
my $bankName;

$sth->bind_col(1, \$bankAccountId);
$sth->bind_col(2, \$bankName);

my %bankAccounts;

while ( $sth->fetch ) {
	$bankAccounts{$bankAccountId} = $bankName;
}

my $bankList;

while ( my ($bNum, $bName) = each %bankAccounts ) {
		if (length($bankList) < 1 ) {
			$bankList = $bNum;
		} else {
			$bankList .= ",$bNum";
		}	
}

$sth->finish;

$dbhReporting->disconnect();

my $stmt2 = "select id, computer_id, name,serial_number,scan_time,bank_account_id,action from scan_record where 
bank_account_id in ($bankList) with ur;
";
print $stmt2;
my $sth2 = $dbhStage->prepare($stmt2);
$sth2->execute();
my $id;
my $computerId;
my $name;
my $serial;
my $scanTime;
my $thisBankAccountId;
my $action;
$sth2->bind_col(1, \$id);
$sth2->bind_col(2, \$computerId);
$sth2->bind_col(3, \$name);
$sth2->bind_col(4, \$serial);
$sth2->bind_col(5, \$scanTime);
$sth2->bind_col(6, \$thisBankAccountId);
$sth2->bind_col(7, \$action);
my %stageScanRecord;
while ( $sth2->fetch) {
	my $serial5 = substr($serial, -5, 5);
	my $serial4 = substr($serial, -4, 4);
	$stageScanRecord{$computerId} = {
		action => "$action",
		name => "$name",
		serial => "$serial", 
		serial4 => "$serial4", 
		serial5 => "$serial5",
		scanTime => "$scanTime",
		bankAccountId => "$thisBankAccountId",
		id => "$id",
	};	
#	print "$serial5 $serial4\n";
}
$sth2->finish;

$dbhStage->disconnect();



open REPORT, ">$0" . ".txt";

print REPORT "S-computerId,S-id,S-action,S-name,S-serial,S-serial4,S-serial5,S-scanTime,S-bankAccountId,S-bankAccountName\n";

# print the information we have
while ( my ($slNumPrint, $swLparPrint) = each %stageScanRecord ) {
	print REPORT $slNumPrint . ",";
	print REPORT $stageScanRecord{$slNumPrint}{id} . ",";
	print REPORT $stageScanRecord{$slNumPrint}{action} . ",";
	print REPORT $stageScanRecord{$slNumPrint}{name} . ",";
	print REPORT "\"" . $stageScanRecord{$slNumPrint}{serial} . "\",";
	print REPORT $stageScanRecord{$slNumPrint}{serial4} . ",";
	print REPORT $stageScanRecord{$slNumPrint}{serial5} . ",";
	print REPORT $stageScanRecord{$slNumPrint}{scanTime} . ",";	
	print REPORT $stageScanRecord{$slNumPrint}{bankAccountId} . ",";	
	print REPORT $bankAccounts{$stageScanRecord{$slNumPrint}{bankAccountId}} . ",";
	print REPORT "\n";
}
close REPORT;
exit 0;


sub usage {
	print "$0 -u <userId>\n";
	exit 0;
}


