#!/usr/bin/perl
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: dbryson@us.ibm.com
# ========================================================
use File::Copy;
use Getopt::Std;
use Config::Properties::Simple;
use File::Basename;

my $thisReportName = $0;
my $thisUser = getlogin;
my $profileFile = "/home/$thisUser" . "/report.properties";
my ($fileName, $fileDirectory) = fileparse($thisReportName, ".pl");
my $individualTempFileName = "MY_REPORT_TEMP_" . $fileName;

my $cfg = Config::Properties::Simple->new(file => $profileFile); 

use vars qw (
    $opt_r
);

getopt("r");

my $reportDatabase = $cfg->getProperty('reportDatabase');
my $reportDatabaseUser = $cfg->getProperty('reportDatabaseUser');
my $reportDatabasePassword = $cfg->getProperty('reportDatabasePassword');

my $db2profile = $cfg->getProperty('db2profile');
my $tmpDir = $cfg->getProperty("tmpDir");

my $gsaUser = $cfg->getProperty("gsaUser");
my $gsaPassword = $cfg->getProperty("gsaPassword");

$reportDir = "/gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/";
$tmpDir = "$tmpDir";

system ("echo $gsaPassword | gsa_login -c pokgsa -p $gsaUser");
system (". $db2profile");

chdir $reportDir;

open( RUNERR, ">" . $fileName . "_run_err.log" );
$rundate = `date`;
print RUNERR "++++++++++++\n$rundate\n";

%regionsBase = (
	BRAZIL => 4,
	CANADA => 1,    
	UNITED_STATES => 2,
	MEXICO => 3,
	FRANCE => 6,
	GERMANY => 7,   
	ITALY => 8,        
	BENELUX => 9, 
	CEE => 10,    
	NORDIC => 11,        
	SPGI => 12, 
	UKI => 13,     
	ALPS => 21,             
	IGIT => 29,             
	ANZ => 14, 
	KOREA => 16,      
	GCG => 17,              
	ASEAN => 18, 
	INDIA => 20,      
	UNKNOWN => 19,          
	MEA => 30, 
	SSA => 5,
	MENA => 22, 
	JAPAN => 15
);

if ( $opt_r ) {
	%regions = ( $opt_r => $regionsBase{$opt_r} );
} else {
	%regions = %regionsBase;
}

# LOOP THROUGH IT
foreach $key ( keys %regions ) {
	$region = $key;
	$regionId = $regions{$key};
	$makeList = "
connect to $reportDatabase user $reportDatabaseUser using $reportDatabasePassword;
set schema eaadmin;
export to $region of del 
select customer_id from customer where country_code_id in
(select id from eaadmin.country_code where region_id = $regionId
) and status = 'ACTIVE' with ur;
";
my $fileSQL = $tmpDir . "/" . $fileName . "_tmp.sql" ;
	system( "echo \" $makeList . \" > $fileSQL" );
	$generateFiles = "db2 -tvf $fileSQL";
	$compressFile = "zip " . $region . ".zip $region" . ".tsv";
	system($generateFiles);
	$makeheader    = "cat " . $fileDirectory . $fileName . "_header.txt > " . $region . ".tsv";
	system($makeheader);

	open( INPUT, "<" . $region )
	  or die "Cannot open $region";

	while (<INPUT>) {
		chomp;
		$customerId = $_;
		$customerId =~ s/\n|\r|\f//gm;

		$selectFullReconSQL = 
		"
connect to $reportDatabase user $reportDatabaseUser using $reportDatabasePassword;
set schema eaadmin;

export to $customerId of del modified by coldel0x09 
SELECT sl_customer.account_number,
CASE WHEN AUS.Open = 0 THEN 'Blue' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN 'Red' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN 'Yellow' 
ELSE 'Green' 
END 
,aus.creation_time 
, case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) 
else days(aus.record_time) - days(aus.creation_time) 
end 
,sl.name as swLparName 
,h.serial as hwSerial 
,mt.name as hwMachType 
,h.owner as hwOwner 
,h.country as hwCountry 
,mt.type as hwAssetType 
   ,hl.SPLA
   ,hl.SYSPLEX
   ,hl.INTERNET_ICC_FLAG
   ,h.MAST_PROCESSOR_TYPE
   ,h.PROCESSOR_MANUFACTURER
   ,h.PROCESSOR_MODEL
   ,h.NBR_CORES_PER_CHIP
   ,h.NBR_OF_CHIPS_MAX
   ,h.SHARED
,h.hardware_status
,hl.lpar_status
   ,'Not specified' as swOwner
,h.processor_count as hwProcCount 
,h.chips as hwChips 
,case when sle.software_lpar_id is null then sl.processor_count else sle.processor_count end as swLparProcCount 
,instSi.name as instSwName 
,aus.remote_user as alertAssignee 
,aus.comments as alertAssComments 
,instSwMan.name as instSwManName 
,dt.name as instSwDiscrepName 
,case when rt.is_manual = 0 then rt.name || '(AUTO)' when rt.is_manual = 1 then rt.name || '(MANUAL)' end 
,r.remote_user as reconUser 
,r.record_time as reconTime 
,case when rt.is_manual = 0 then 'Auto Close' when rt.is_manual = 1 then r.comments end as reconComments 
,parentSi.name as parentName 
,c.account_number as licAccount 
,l.full_desc as licenseDesc 
,case when l.id is null then '' 
when lsm.id is null then 'No' 
else 'Yes' end as catalogMatch 
,l.prod_name as licProdName 
,l.version as licVersion 
,CONCAT(CONCAT(RTRIM(CHAR(L.Cap_Type)), '-'), CT.Description) 
,ul.used_quantity  
,case when r.id is null then '' 
when r.machine_level = 0 then 'No' 
else 'Yes' end 
, REPLACE(RTRIM(CHAR(DATE(L.Expire_Date), USA)), '/', '-') 
,l.po_number 
,l.cpu_serial 
,case when l.ibm_owned = 0 then 'Customer' 
when l.ibm_owned = 1 then 'IBM' 
else '' end 
,l.ext_src_id ,l.record_time 
from  
eaadmin.software_lpar sl 
left outer join eaadmin.software_lpar_eff sle on 
sl.id = sle.software_lpar_id 
and sle.status = 'ACTIVE' 
and sle.processor_count != 0 
inner join eaadmin.hw_sw_composite hsc on 
sl.id = hsc.software_lpar_id 
inner join eaadmin.hardware_lpar hl on 
hsc.hardware_lpar_id = hl.id 
inner join eaadmin.hardware h on 
hl.hardware_id = h.id 
inner join eaadmin.machine_type mt on 
h.machine_type_id = mt.id 
inner join eaadmin.installed_software is on 
sl.id = is.software_lpar_id 
inner join eaadmin.product_info instPi on 
is.software_id = instPi.id 
inner join eaadmin.product instP on 
instPi.id = instP.id 
inner join eaadmin.software_item instSi on 
instP.id = instSi.id 
inner join eaadmin.manufacturer instSwMan on 
instP.manufacturer_id = instSwMan.id 
inner join eaadmin.discrepancy_type dt on 
is.discrepancy_type_id = dt.id 
inner join eaadmin.alert_unlicensed_sw aus on 
is.id = aus.installed_software_id 
left outer join eaadmin.reconcile r on 
is.id = r.installed_software_id 
left outer join eaadmin.reconcile_type rt on 
r.reconcile_type_id = rt.id 
left outer join eaadmin.installed_software parent on 
r.parent_installed_software_id = parent.id 
left outer join eaadmin.product_info parentPi on 
parent.software_id = parentPi.id 
left outer join eaadmin.product parentP on 
parentPi.id = parentP.id 
left outer join eaadmin.software_item parentSi on 
parentSi.id = parentP.id 
left outer join eaadmin.reconcile_used_license rul on 
r.id = rul.reconcile_id 
left outer join eaadmin.used_license ul on 
rul.used_license_id = ul.id 
left outer join eaadmin.license l on 
ul.license_id = l.id 
left outer join eaadmin.license_sw_map lsm on 
l.id = lsm.license_id 
left outer join eaadmin.capacity_type ct on 
l.cap_type = ct.code 
left outer join eaadmin.customer c on 
l.customer_id = c.customer_id,  
eaadmin.customer sl_customer
where
sl.customer_id = $customerId 
and sl.customer_id = sl_customer.customer_id
and hl.customer_id = $customerId 
and (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id)) 
ORDER BY sl.name
with ur
;";
		

		system( "echo \"" . $selectFullReconSQL . "\"> $fileSQL" );

		$assetCommandLine = "db2 -tvf $fileSQL";
		$reformatCommand  =
		  "cat " . "$customerId >> $region" . ".tsv";
		print $reformatCommand . "\n";
		system($assetCommandLine);
		if ( $? >= 8 ) {
			print RUNERR "failed to run -- Customer Number $customerId \n";
		}
		system($reformatCommand);
		unlink $customerId;

	}

	close INPUT;
	system( "date >> " . $region . ".tsv" );
	system($compressFile);
	unlink($region . ".tsv");
	unlink($region);
	
}

close RUNERR;

