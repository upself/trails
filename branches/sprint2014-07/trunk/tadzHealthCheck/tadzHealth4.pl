#!/usr/local/bin/perl -w

use DBI;
use Config::Properties::Simple;
use Getopt::Std;

use vars qw( $opt_u $opt_f);

getopts("u:f:");
usage() unless ( defined $opt_u $opt_f );

open FILE, "<$opt_f";

my %stageLpar;

my %infrLpar;

while (<FILE>) {
	my $line = $_;

	#	print $line;
	my @vals         = split( ",", $line );
	my $lparName     = $vals[1];
	my $serialNumber = $vals[2];
	my $database     = $vals[3];
	my $lpar         = $vals[4];
	my $smfId        = $vals[5];

	# strip out extra space
	$lparName     =~ tr/ //ds;
	$serialNumber =~ tr/ //ds;
	$database     =~ tr/ //ds;
	$lpar         =~ tr/ //ds;
	$smfId        =~ tr/ //ds;
	$infrLpar{"$serialNumber-$lparName"} = {
		lparName     => "$lparName",
		serialNumber => "$serialNumber",
		database     => "$database",
		lpar         => "$lpar",
		smfId        => "$smfId",
	};
}

close FILE;

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

my $bankList = "";

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
"select software_lpar.action,software_lpar.name,bios_serial,software_lpar.id, bank_account_id from software_lpar, scan_record, software_lpar_map 
where software_lpar.id = software_lpar_map.software_lpar_id and
scan_record.id = software_lpar_map.scan_record_id and
bank_account_id in ($bankList) with ur;
";

my $sth2 = $dbhStage->prepare($stmt2);
$sth2->execute();
my $action;
my $name;
my $serial;
my $softwareLparId;
my $thisBankAccountId;
$sth2->bind_col( 1, \$action );
$sth2->bind_col( 2, \$name );
$sth2->bind_col( 3, \$serial );
$sth2->bind_col( 4, \$softwareLparId );
$sth2->bind_col( 5, \$thisBankAccountId );

while ( $sth2->fetch ) {
	my $serial5 = substr( $serial, -5, 5 );
	my $serial4 = substr( $serial, -4, 4 );
#	$infrLpar{"$serial5-$name"} = {
		$infrLpar{"$serial5-$name"}{stageAction} = "$action";
		$infrLpar{"$serial5-$name"}{stageName} = "$name";
		$infrLpar{"$serial5-$name"}{stageSerial} = "$serial";
		$infrLpar{"$serial5-$name"}{stageSerial4} = "$serial4";
		$infrLpar{"$serial5-$name"}{stageSerial5} = "$serial5";
		$infrLpar{"$serial5-$name"}{stageBankAccountId} = "$thisBankAccountId";
#	};

	#	print "$serial5 $serial4\n";
}
$sth2->finish;

$dbhStage->disconnect();
$dbhReporting->disconnect();

open REPORT, ">$0" . ".txt";

  print REPORT
"key,tadzLparName,tadzSerialNumber,tadzDatabase,tadzLpar,tadzSmfId,stageAction,stageName,stageSerial,stageSerial4,stageSerial5,stageBankAccountId,stageBankAccountName\n";

while ( my ( $key, $swLpar ) = each %infrLpar ) {
	print REPORT "$key,";
	if ( defined $infrLpar{$key}{lparName} ) {
		print REPORT $infrLpar{$key}{lparName} . ",";
		print REPORT $infrLpar{$key}{serialNumber} . ",";
		print REPORT $infrLpar{$key}{database} . ",";
		print REPORT $infrLpar{$key}{lpar} . ",";
		print REPORT $infrLpar{$key}{smfId} . ",";
	}
	else {
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";

	}
	if ( defined $infrLpar{$key}{stageName} ) {
		print REPORT $infrLpar{$key}{stageAction} . ",";
		print REPORT $infrLpar{$key}{stageName} . ",";
		print REPORT $infrLpar{$key}{stageSerial} . ",";
		print REPORT $infrLpar{$key}{stageSerial4} . ",";
		print REPORT $infrLpar{$key}{stageSerial5} . ",";
		print REPORT $infrLpar{$key}{stageBankAccountId} . ",";
		print REPORT $bankAccounts{ $infrLpar{$key}{stageBankAccountId} } . "\n";
	}
	else {
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA,";
		print REPORT "NA\n";
	}
}

close REPORT;
exit 0;

sub usage {
	print "$0 -u <userId> -f <inputFile> \n";
	exit 0;
}

