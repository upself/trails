#!/usr/bin/perl -w
use File::Copy;
use Config::Properties::Simple;
use File::Basename;
use DBI;

my $thisReportName = $0;
# getlogin will NOT work when ran from cron
my ($login, $pass, $uid, $gid) = getpwuid($<);
my $thisUser = $login;
my $profileFile    = "/opt/staging/v2/config/connectionConfig.txt";
my ( $fileName, $fileDirectory ) = fileparse( $thisReportName, ".pl" );
my $individualTempFileName = "MY_REPORT_TEMP_" . $fileName;

my $cfg = Config::Properties::Simple->new( file => $profileFile );

my $reportDatabase         = $cfg->getProperty('reportDatabase');
my $reportDatabaseUser     = $cfg->getProperty('reportDatabaseUser');
my $reportDatabasePassword = $cfg->getProperty('reportDatabasePassword');

my $db2profile = $cfg->getProperty('db2profile');
my $tmpDir     = $cfg->getProperty("tmpDir");

my $gsaUser     = $cfg->getProperty("gsaUser");
my $gsaPassword = $cfg->getProperty("gsaPassword");

system("echo $gsaPassword | gsa_login -c pokgsa -p $gsaUser");
system(". $db2profile");

$reportDir = "/gsa/pokgsa/projects/e/emea_assets/";

# for testing
$reportDir = "/opt/reports/bin/";
$tmpDir    = "$tmpDir/";

my $tmpFile1 = $tmpDir . "/emeaBankTmp1.txt";
my $tmpFile2 = $tmpDir . "/emeaBankTmp2.txt";
my $tmpSQL = $tmpDir ."/". $fileName . ".sql";

my $dataFile = $reportDir . "asset_bank.tsv";

my $db2SQL = "
connect to $reportDatabase user $reportDatabaseUser using $reportDatabasePassword;
set schema eaadmin;
export to $tmpFile1 of del 
select distinct * from 
(
select software_lpar.id,account_number, customer_name, software_lpar.name, 
bank_account.name as bankname from
customer, software_lpar, installed_filter,installed_software,
bank_account
where
customer.customer_id = software_lpar.customer_id
and software_lpar.status = 'ACTIVE'
and installed_software.status = 'ACTIVE'
and bank_account.id = installed_filter.bank_account_id
and installed_software.software_lpar_id = software_lpar.id
and installed_filter.installed_software_id = installed_software.id
and customer.customer_id in 
(select customer_id from customer where country_code_id in (select id from 
eaadmin.country_code where region_id in (select id from eaadmin.region where 
geography_id in (2,6))))

union
select software_lpar.id, account_number, customer_name, software_lpar.name, 
bank_account.name as bankname from
customer, software_lpar, installed_sa_product,installed_software,
bank_account
where
customer.customer_id = software_lpar.customer_id
and software_lpar.status = 'ACTIVE'
and installed_software.status = 'ACTIVE'
and bank_account.id = installed_sa_product.bank_account_id
and installed_software.software_lpar_id = software_lpar.id
and installed_sa_product.installed_software_id = installed_software.id
and customer.customer_id in 
(select customer_id from customer where country_code_id in (select id from 
eaadmin.country_code where region_id in (select id from eaadmin.region where 
geography_id in (2,6))))

union
select software_lpar.id, account_number, customer_name, software_lpar.name, 
bank_account.name as bankname from
customer, software_lpar, installed_signature,installed_software,
bank_account
where
customer.customer_id = software_lpar.customer_id
and software_lpar.status = 'ACTIVE'
and installed_software.status = 'ACTIVE'
and bank_account.id = installed_signature.bank_account_id
and installed_software.software_lpar_id = software_lpar.id
and installed_signature.installed_software_id = installed_software.id
and customer.customer_id in 
(select customer_id from customer where country_code_id in (select id from 
eaadmin.country_code where region_id in (select id from eaadmin.region where 
geography_id in (2,6))))
)
as t 
with ur;
";

system("echo \" $db2SQL \" > $tmpSQL");

system("db2 -tvf $tmpSQL");
system("cat $tmpFile1 | sort > $tmpFile2");

open (BANK, "<", $tmpFile2) or die "cannot open file";
open (OUTPUT, ">", $dataFile) or die "cannot open outputfile";

$count = 0;
$lastId = 0;
$bankText = "";
print OUTPUT "ACCOUNT NUMBER\tACCOUNT NAME\tHOST\tBANK ACCOUNT\n";

while (<BANK>) {
	chomp;
	my @fields = split /,/;
	$fields[4] =~ s/\"//g;
	if ( ! ($fields[0] eq $lastId ) ) {
		print OUTPUT $str;
		$bankText = "";
	}
	if ( ! $bankText eq "" ) {
		$bankText = "$bankText," . $fields[4];
	} else {
		$bankText = $fields[4];
	} 
	$str = $fields[1] . "\t" . $fields[2] . "\t" .  $fields[3] . "\t" . "\"" . $bankText . "\"\n";
	$lastId = $fields[0];
	$count = $count + 1;
}
close (BANK);
close (OUTPUT);
