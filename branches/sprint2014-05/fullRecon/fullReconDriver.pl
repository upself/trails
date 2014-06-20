#!/usr/bin/perl
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: dbryson@us.ibm.com
# Service attendant: KFaler@US.IBM.com
#  r1 trac 298 region list adjustments
#  r2 trac 99 add swOwner
#  r3 trac 251 add proc elements
#  r4 union fr, etc
#  r5 simultaneous runtime member
#  r5a simultaneous runtime member
#  rt8 new region base, all new processing
# ========================================================
use File::Copy;
use Getopt::Std;
use Config::Properties::Simple;
use File::Basename;
use ReportProperty;

my $report = new ReportProperty();
$report->initReportingSystem;

my $fileName = $report->thisReport;
my $fileDirectory = $report->thisDir;

use vars qw ( $opt_r $opt_t);
getopts("r:t:");


my $reportDatabase = $report->reportDatabase;
my $reportDatabaseUser = $report->reportDatabaseUser;
my $reportDatabasePassword = $report->reportDatabasePassword;

my $tmpDir = $report->tmpDir;

$finalDir = $report->reportDeliveryFolder;
$errDir = $report->thisDir;
$reportDir = "/tmp/";

chdir $reportDir;

open( RUNERR, ">" . $errDir . $fileName . "_run_err.log" );
$rundate = `date`;
print RUNERR "++++++++++++\n$rundate\n";

%regionsBase = (
#	ANZ_IMT => 1,
#	ASEAN_IMT => 2,
#	BENELUX_IMT => 3,
#	CANADA_IMT => 4,
#	CEE_IMT => 5,
#	DACH_IMT => 6,
#	FRANCE_IMT => 7,
#	GREATER_CHINA => 8,
#	ISA_IMT => 9,
#	ITALY_IMT => 10,
#	JAPAN_IMT => 11,
#	KOR_IMT => 12,
#	LA => 13,
#	MEA => 14,
#	NORDICS_IMT => 15,
#	SPGI_IMT => 16,
#	UKI_IMT => 17,
#	UNKNOWN => 19,
	US_IMT => 18
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
	my $regionFile = $tmpDir .'/'. $region;
	my $regionDataFile = $reportDir . $region . ".tsv";
	$makeList = "
connect to $reportDatabase user $reportDatabaseUser using $reportDatabasePassword;
set schema eaadmin;
export to $regionFile of del 
select cu.customer_id from customer cu where cu.country_code_id in
(select ctry.id from country_code ctry where ctry.region_id = $regionId)
and cu.status = 'ACTIVE'
and cu.sw_license_mgmt = 'YES'
and exists (select 1 from software_lpar sl where cu.customer_id = sl.customer_id and sl.status='ACTIVE') with ur;
";
my $fileSQL = $tmpDir . '/' . $fileName . "_tmp.sql" ;
	system( "echo \" $makeList . \" > $fileSQL" );

#chmod 0744, $fileSQL;

	$generateFiles = "db2 -tvf $fileSQL";
	$compressFile = "zip -j " . $reportDir . $region . ".zip $regionDataFile";
	system($generateFiles);
	$makeheader    = "cat " . $fileDirectory . "fullReconDriver_header.txt > $regionDataFile";
	system($makeheader);

	open( INPUT, "<" . $regionFile )
	  or die "Cannot open $region";
	
	
	my $testAccount=undef;  
	if($opt_t){
	  $testAccount = $opt_t
	}


    my $counter = 0;
	while (<INPUT>) {
	    $counter++;
	    last 
	      if (defined $testAccount && $counter> $testAccount);
		chomp;
		$customerId = $_;
		$customerId =~ s/\n|\r|\f//gm;
		my $customerFile = $tmpDir .'/'. $customerId;

		$selectFullReconSQL = 
		"
connect to $reportDatabase user $reportDatabaseUser using $reportDatabasePassword;
set schema eaadmin;

export to $customerFile of del modified by coldel0x09 

SELECT 
sl_customer.account_number
,CASE WHEN AUS.Open = 0 THEN 'Blue'
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN 'Red'
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN 'Yellow'
ELSE 'Green' END
,aus.creation_time
, case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) else days(aus.record_time) - days(aus.creation_time) end
,sl.name as swLparName
,h.serial as hwSerial
,mt.name as hwMachType
,h.MODEL
,h.CHASSIS_ID
,h.CLOUD_NAME 
,h.owner as hwOwner
,h.country as hwCountry
,mt.type as hwAssetType
,hl.SPLA
,hl.VIRTUAL_FLAG
,hl.VIRTUAL_MOBILITY_RESTRICTION
,hl.SYSPLEX
,hl.CLUSTER_TYPE
,hl.BACKUPMETHOD
,hl.INTERNET_ICC_FLAG
,hl.CAPPED_LPAR
,h.MAST_PROCESSOR_TYPE
,h.PROCESSOR_MANUFACTURER
,h.PROCESSOR_MODEL
,h.NBR_CORES_PER_CHIP
,h.NBR_OF_CHIPS_MAX
,h.SHARED_PROCESSOR
,h.CPU_MIPS
,h.CPU_GARTNER_MIPS
,h.CPU_MSU
,hl.PART_MIPS
,hl.PART_GARTNER_MIPS
,hl.PART_MSU
,h.SHARED
,h.hardware_status
,hl.lpar_status
,h.processor_count as hwProcCount
,h.chips as hwChips
,case when sle.software_lpar_id is null then sl.processor_count else sle.processor_count end as swLparProcCount
,case when ibmb.id is not null then
COALESCE( CAST( (select pvui.VALUE_UNITS_PER_CORE from eaadmin.pvu_info pvui where pvui.pvu_id=pvum.pvu_id and
(case when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) = 1 then 'SINGLE-CORE'
when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) = 2 then 'DUAL-CORE'
when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) = 4 then 'QUAD-CORE'
when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) > 0 then 'MULTI-CORE'
else '' end ) = pvui.PROCESSOR_TYPE  fetch first 1 row only ) as CHAR(8)),'base data missing') else 'Non_IBM Product' end as pvuPerCode
,instSi.name as instSwName
, COALESCE ( CAST ( (select scop.description from eaadmin.scope scop join eaadmin.schedule_f sf on sf.scope_id = scop.id
where sf.customer_id = $customerId
and sf.status_id=2
and sf.software_name = parentSi.name
and ( ( sf.level = 'PRODUCT' )
or (( sf.hostname = sl.name ) and ( level = 'HOSTNAME' ))
or (( sf.serial = h.serial ) and ( sf.machine_type = mt.name ) and ( sf.level = 'HWBOX' ))
or (( sf.hw_owner = h.owner ) and ( sf.level ='HWOWNER' )) )
order by sf.LEVEL fetch first 1 rows only) as varchar(64) ), 'Not specified' ) as swOwner
,aus.remote_user as alertAssignee
,aus.comments as alertAssComments
,instSwMan.name as instSwManName
,dt.name as instSwDiscrepName
,case when rt.is_manual = 0 then rt.name || '(AUTO)'
when rt.is_manual = 1 then rt.name || '(MANUAL)' end
,am.name as allocationMethod
,r.remote_user as reconUser
,r.record_time as reconTime
,case when rt.is_manual = 0 then 'Auto Close' when rt.is_manual = 1 then r.comments end as reconComments
,parentSi.name as parentName
,c.account_number as licAccount
,l.full_desc as licenseDesc
,case when l.id is null then '' when lsm.id is null then 'No' else 'Yes' end as catalogMatch
,l.prod_name as licProdName
,l.version as licVersion
,CONCAT(CONCAT(RTRIM(CHAR(L.Cap_Type)), '-'), CT.Description)
,ul.used_quantity
,case when r.id is null then ''
when r.machine_level = 0 then 'No' else 'Yes' end
,REPLACE(RTRIM(CHAR(DATE(L.Expire_Date), USA)), '/', '-')
,l.po_number
,l.cpu_serial
,case when l.ibm_owned = 0 then 'Customer'
when l.ibm_owned = 1 then 'IBM' else '' end
,l.ext_src_id
,l.record_time
from
 eaadmin.software_lpar sl
 left outer join eaadmin.software_lpar_eff sle on sl.id = sle.software_lpar_id and sle.status = 'ACTIVE' and sle.processor_count != 0
 inner join eaadmin.hw_sw_composite hsc on sl.id = hsc.software_lpar_id
 inner join eaadmin.hardware_lpar hl on hsc.hardware_lpar_id = hl.id
 inner join eaadmin.hardware h on hl.hardware_id = h.id
 inner join eaadmin.machine_type mt on h.machine_type_id = mt.id
 inner join eaadmin.installed_software is on sl.id = is.software_lpar_id
 inner join eaadmin.product_info instPi on is.software_id = instPi.id
 inner join eaadmin.product instP on instPi.id = instP.id
 inner join eaadmin.software_item instSi on instP.id = instSi.id
 inner join eaadmin.manufacturer instSwMan on instP.manufacturer_id = instSwMan.id
 inner join eaadmin.discrepancy_type dt on is.discrepancy_type_id = dt.id
 inner join eaadmin.alert_unlicensed_sw aus on is.id = aus.installed_software_id
 left outer join eaadmin.reconcile r on is.id = r.installed_software_id
 left outer join eaadmin.reconcile_type rt on r.reconcile_type_id = rt.id
 left outer join eaadmin.allocation_methodology am on r.allocation_methodology_id = am.id
 left outer join eaadmin.installed_software parent on r.parent_installed_software_id = parent.id
 left outer join eaadmin.product_info parentPi on parent.software_id = parentPi.id
 left outer join eaadmin.product parentP on parentPi.id = parentP.id
 left outer join eaadmin.software_item parentSi on parentSi.id = parentP.id
 left outer join eaadmin.reconcile_used_license rul on r.id = rul.reconcile_id
 left outer join eaadmin.used_license ul on rul.used_license_id = ul.id
 left outer join eaadmin.license l on ul.license_id = l.id
 left outer join eaadmin.license_sw_map lsm on l.id = lsm.license_id
 left outer join eaadmin.capacity_type ct on l.cap_type = ct.code
 left outer join eaadmin.customer c on l.customer_id = c.customer_id
 left outer join eaadmin.pvu_map pvum on h.MACHINE_TYPE_ID = pvum.MACHINE_TYPE_ID and h.MAST_PROCESSOR_TYPE = pvum.PROCESSOR_BRAND and h.MODEL = pvum.PROCESSOR_MODEL
 left outer join eaadmin.ibm_brand ibmb on instSwMan.id=ibmb.manufacturer_id
, eaadmin.customer sl_customer

where
 sl.customer_id = $customerId and hl.customer_id = $customerId and sl.customer_id = sl_customer.customer_id
and (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id))

 ORDER BY 4 desc, parentSi.name

with ur
;";
		

		system( "echo \"" . $selectFullReconSQL . "\"> $fileSQL" );

		$assetCommandLine = "db2 -tvf $fileSQL";
		$reformatCommand  =
		  "cat " . "$customerFile >> $regionDataFile";
		print $reformatCommand . "\n";
		system($assetCommandLine);
		if ( $? >= 8 ) {
			print RUNERR "failed to run -- Customer Number $customerId \n";
		}
		system($reformatCommand);
		unlink $customerFile;

	}

	close INPUT;
	system( "date >> $regionDataFile" );
	system($compressFile);
	unlink($regionDataFile);
	unlink($regionFile);

	unlink($fileSQL);
	move($regionFile . ".zip",$finalDir . $region . ".zip");

}

close RUNERR;

