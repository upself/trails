# for testing
#!/usr/bin/perl
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: sasho_mihailov@cz.ibm.com
# ========================================================
use lib "/opt/report/bin";
use File::Copy;
use File::Basename;
use Conf::ReportProperty;
use DBI;

my $thisReportName = $0;

my ( $fileName, $fileDirectory ) = fileparse( $thisReportName, ".pl" );
my $individualTempFileName = "MY_REPORT_TEMP_" . $fileName;

my $cfg = new Conf::ReportProperty();
$cfg->initReportingSystem;

my $reportDatabase = $cfg->stagingDatabase();
my $reportDatabaseUser = $cfg->stagingDatabaseUser();
my $reportDatabasePassword = $cfg->stagingDatabasePassword();
my $db2profile = $cfg->db2profile();
my $tmpDir = $cfg->tmpDir();
# my $testDir = $cfg-> bankacc();

$tmpDir    = "$tmpDir/";

# Report dir to be agreed !!
$reportDir = "/gsa/bejgsa/projects/s/swtools/test/bankaccReport/";
my $testDir = "/opt/report/bin/bankAcc/";

# my $tmpFile1 = $tmpDir . "AllBankTmp1.txt";
my $tmpFile1 = $tmpDir . "p_bank_acc.txt";
my $tmpFile2 = $testDir . "AllBankTmp2.txt";
my $tmpFileT4D1 = $tmpDir . "tad4d_ba.txt";
my $tmpFileT4D2 = $testDir . "T4DBankTmp2.txt";
my $tmpSQL = $tmpDir . $fileName . ".sql";

# for Testing
# my $dataFile = $testDir . "all_bank.tsv";
# my $dataFileT4D = $testDir . "tad4d_bank.tsv";
# Production to be consider!!
my $dataFile = $reportDir . "all_bank.tsv";
my $dataFileT4D = $reportDir . "tad4d_bank.tsv";

my $db2SQL = "
connect to $reportDatabase user $reportDatabaseUser using $reportDatabasePassword;
set schema eaadmin;
export to $tmpFile1 of del modified by nochardel coldelx09
SELECT     
     sr.BANK_ACCOUNT_ID,

     slm.ACTION as action_map,
     count(*) as countHost
FROM      
    EAADMIN.SCAN_RECORD sr 
    left outer join EAADMIN.SOFTWARE_LPAR_MAP slm on sr.id=slm.scan_record_id
group by sr.BANK_ACCOUNT_ID,slm.ACTION
with ur;
export to $tmpFileT4D1 of del modified by nochardel coldelx09
SELECT     
     sr.BANK_ACCOUNT_ID,
     slm.ACTION as action_map,
     sr.NAME as hostname
FROM      
     EAADMIN.SCAN_RECORD sr 
       left outer join EAADMIN.SOFTWARE_LPAR_MAP slm on sr.id=slm.scan_record_id
Where sr.BANK_ACCOUNT_ID in (660,	673,	675,	681,	685,	698,	699,	702,	704,	709,	715,	720,	722,	724,	726,	728,	731,	738,	740,	742,	750,	751,	752,	755,	756,	757,	762,	763,	768,	769,	770,	780,	782,	797,	800,	810,	811,	814,	816,	817,	829,	830,	831,	832,	833,	836,	837,	838,	839,	840,	841,	842,	843,	844,	845,	846,	852,	853,	855,	856,	857,	861,	863,	867,	868,	870,	871,	873,	875,	876,	877,	879,	880,	884,	887,	888,	889,	890,	891,	892,	895,	896,	897,	898,	899,	900,	902,	904,	905,	906,	908,	910,	918,	919,	920,	926,	929,	931,	936,	938,	939,	941,	942,	944,	945,	946,	949,	950,	951,	952,	957,	959,	961,	962,	963,	964,	965,	1088,	1090,	1091,	1092,	1095,	1096,	1097,	1098,	1099,	1100,	1102,	1103,	1104,	1106,	1107,	1108,	1109,	1111,	1112,	1128,	1142,	1145,	1146,	1149,	1151,	1153,	1154,	1156,	1157,	1158,	1159,	1160,	1161,	1162,	1163,	1165,	1170,	1171,	1172,	1173,	1174,	1176,	1177,	1178,	1192,	1193,	1194,	1197,	1201,	1203,	1204,	1293,	1297,	1298,	1301,	1304,	1305,	1306,	1307,	1308,	1311,	1314,	1317,	1321,	1322,	1324,	1325,	1326,	1327,	1328,	1329,	1336,	1337,	1339,	1340,	1342,	1343,	1344,	1345,	1346,	1347,	1348,	1349,	1351)
order by sr.BANK_ACCOUNT_ID,sr.NAME
with ur;
";

system("echo \" $db2SQL \" > $tmpSQL");

system("db2 -tvf $tmpSQL");
system("cat $tmpFile1 > $tmpFile2");
system("cat $tmpFileT4D1 > $tmpFileT4D2");
	
open (BANK, "<", $tmpFile2) or die "cannot open file";
open (OUTPUT, ">", $dataFile) or die "cannot open outputfile";

$count = 0;
$lastId = 0;
$bankText = "";
print OUTPUT "BANK ID\tAction\tHosts\n";

while (<BANK>) {
	chomp;
	my @fields = split /,/;
	$fields[3] =~ s/\"//g;
	if ( ! ($fields[0] eq $lastId ) ) {
		print OUTPUT $str;
		$bankText = "";
	}
	if ( ! $bankText eq "" ) {
		$bankText = "$bankText," . $fields[3];
	} else {
		$bankText = $fields[3];
	} 
	$str = $fields[0]. "\t" . $fields[1] . "\t" . $fields[2] ."\n";
	$lastId = $fields[0];
	$count = $count + 1;
}
close (BANK);
close (OUTPUT);

open (BANK, "<", $tmpFileT4D2) or die "cannot open file";
open (OUTPUT, ">", $dataFileT4D) or die "cannot open outputfile";

$count = 0;
$lastId = 0;
$bankText = "";
print OUTPUT "Bank ID\tAction\tHostname\n";
while (<BANK>) {
	chomp;
	my @fields = split /,/;
	$fields[3] =~ s/\"//g;
	if ( ! ($fields[0] eq $lastId ) ) {
		print OUTPUT $str;
		$bankText = "";
	}
	if ( ! $bankText eq "" ) {
		$bankText = "$bankText," . $fields[3];
	} else {
		$bankText = $fields[3];
	} 
	$str = $fields[0]. "\t" . $fields[1] . "\t" . $fields[2]  ."\n";
	$lastId = $fields[0];
	$count = $count + 1;
}
close (BANK);
close (OUTPUT);