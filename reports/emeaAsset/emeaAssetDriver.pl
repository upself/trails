#!/usr/bin/perl
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: dbryson@us.ibm.com
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

my $reportDatabase = $cfg->reportDatabase();
my $reportDatabaseUser = $cfg->reportDatabaseUser();
my $reportDatabasePassword = $cfg->reportDatabasePassword();
my $db2profile = $cfg->db2profile();
my $tmpDir = $cfg->tmpDir();
my $gsaUser = $cfg->gsaUser();
my $gsaPassword = $cfg->gsaPassword();
my $reportDir = $cfg->reportDeliveryFolder('emeaAsset');


my $listFile = $reportDir . "emea_list.txt";
my $dataFile = $reportDir . "emea_asset.tsv";

$makeheader = "cat " . $fileDirectory . $fileName . "_header.txt > $dataFile";
system($makeheader);

system("echo $gsaPassword | gsa_login -c pokgsa -p $gsaUser");
system(". $db2profile");

# chdir $reportDir;

open( RUNERR, ">" . $fileName . "_run_err.log" );
$rundate = `date`;
print RUNERR "++++++++++++\n$rundate\n";

#$rundate = `date`;
my $dbh = DBI->connect(
	"dbi:DB2:$reportDatabase", "$reportDatabaseUser",
	"$reportDatabasePassword", { RaiseError => 1 }
);

# set schema
my $sth1 = $dbh->prepare("set schema eaadmin");
$sth1->execute;

$generateFilesSQL =
"select account_number from customer where country_code_id in (select id from eaadmin.country_code where region_id in (select id from eaadmin.region where geography_id in (2,6))) with ur";

my @accountNumbers;

my $sth = $dbh->prepare($generateFilesSQL);
$sth->execute();

open( CSV, ">> $dataFile" );

while ( $array_ref = $sth->fetchrow_arrayref ) {
	foreach my $col (@$array_ref) {
		push( @accountNumbers, $col );
	}
}

$sth->finish;

my $counter = 0;
print "Number of accounts to process: \n" . scalar @accountNumbers . "\n";

foreach my $accountNumber (@accountNumbers) {
	print $accountNumber . "\n";
	my $account_id = $accountNumber;
	my $getDataSQL = "
			select 
				customer.account_number as account_number
				,customer.customer_name as customer_name
				,customer_type.customer_type_name as customer_type
				,pod.pod_name as pod_name
				,software_lpar.name as name
				,machine_type.type as type
				,hardware.serial as serial
				,software_lpar.bios_serial as bios_serial
				,case when hardware_lpar.id is null then 'N' 
				 else 'Y' end as hwflag                                    
				,'Y' as swflag
				,hardware.hardware_status as hardware_status
				,machine_type.name as machine_type_name
				,hardware.customer_number as customer_number
				,date(software_lpar.scantime) as scan_time
				,COALESCE (hle.processor_count,0) as processor_count
				,hardware.processor_count as hw_processor_count
				,hardware_lper.os_type as os_type
				,hardware_lpar.ext_id as ext_id
				,hardware_lpar.tech_image_id as tech_image_id
			from
				eaadmin.customer as customer
				,eaadmin.customer_type as customer_type
				,eaadmin.pod as pod
				,eaadmin.software_lpar as software_lpar
				left outer join eaadmin.hw_sw_composite as hw_sw_composite on 
					hw_sw_composite.software_lpar_id = software_lpar.id 
				left outer join eaadmin.hardware_lpar as hardware_lpar on 
					hardware_lpar.id = hw_sw_composite.hardware_lpar_id
				left outer join eaadmin.hadrware_lpar_eff hle on
					( hardware_lpar.id = hle.hardware_lpar_id and hle.status = 'ACTIVE' )
				left outer join eaadmin.hardware as hardware on 
					hardware.id = hardware_lpar.hardware_id
				left outer join eaadmin.machine_type as machine_type on 
					hardware.machine_type_id = machine_type.id
			where 
				customer.account_number = $account_id
				and customer.customer_type_id = customer_type.customer_type_id
				and customer.pod_id = pod.pod_id
				and customer.customer_id = software_lpar.customer_id
				and software_lpar.status = 'ACTIVE'
				and ( hardware.id is null OR hardware.hardware_status <> 'REMOVED' )
				and ( hardware_lpar.id is null OR hardware_lpar.status in ('ACTIVE', 'INACTIVE', 'HWCOUNT', 'ON-HOLD'))
			union
			select 
				customer.account_number as account_number
				,customer.customer_name as customer_name
				,customer_type.customer_type_name as customer_type
				,pod.pod_name as pod_name
				,hardware_lpar.name as name
				,machine_type.type as type
				,hardware.serial as serial
				,'' as bios_serial
				,'Y' as hwflag                                    
				,'N' as swflag
				,hardware.hardware_status as hardware_status
				,machine_type.name as machine_type_name
				,hardware.customer_number as customer_number
				,date(nullif(1,1)) as scan_time
				,0 as processor_count
				,hardware.processor_count as hw_processor_count
				,hardware_lpar.ext_id as ext_id
				,hardware_lpar.tech_image_id as tech_image_id
			from
				eaadmin.customer as customer
				,eaadmin.customer_type as customer_type
				,eaadmin.pod as pod
				,eaadmin.hardware_lpar as hardware_lpar
				,eaadmin.hardware as hardware
				,eaadmin.machine_type as machine_type
			where 
				customer.account_number = $account_id
				and customer.customer_type_id = customer_type.customer_type_id
				and customer.pod_id = pod.pod_id
				and hardware_lpar.hardware_id = hardware.id
				and customer.customer_id = hardware_lpar.customer_id
				and hardware.machine_type_id = machine_type.id
				and hardware_lpar.status = 'ACTIVE'
				and hardware.hardware_status <> 'REMOVED'
				and hardware.status in ('ACTIVE', 'INACTIVE', 'HWCOUNT', 'ON-HOLD')
				and not exists( select 1 from hw_sw_composite a where a.hardware_lpar_id = hardware_lpar.id )
			union
			select 
				customer.account_number as account_number
				,customer.customer_name as customer_name
				,customer_type.customer_type_name as customer_type
				,pod.pod_name as pod_name
				,'No LPAR' as name
				,machine_type.type as type
				,hardware.serial as serial
				,'' as bios_serial
				,'Y' as hwflag
				,'N' as swflag
				,hardware.hardware_status as hardware_status
				,machine_type.name as machine_type_name
				,hardware.customer_number as customer_number
				,date(nullif(1,1)) as scan_time
				,0 as processor_count
				,0 as hw_processor_count
				,'' as ext_id
				,'' as tech_image_id
			from
				eaadmin.customer as customer
				,eaadmin.customer_type as customer_type
				,eaadmin.pod as pod
				,eaadmin.hardware as hardware
				,eaadmin.machine_type as machine_type
			where
				customer.account_number = $account_id
				and customer.customer_type_id = customer_type.customer_type_id
				and customer.pod_id = pod.pod_id
				and hardware.machine_type_id = machine_type.id
				and customer.customer_id = hardware.customer_id
				and hardware.hardware_status <> 'REMOVED'
				and not exists( select 1 from hardware_lpar a where a.hardware_id = hardware.id )
    with ur";
	my $sth3 = $dbh->prepare($getDataSQL);
	$sth3->execute();
	my @recordSet;
	while ( $array_ref = $sth3->fetchrow_arrayref ) {
		push( @recordSet, [@$array_ref] );
	}
	$sth3->finish;
	foreach $rec (@recordSet) {
		my $colNumber = 0;
		foreach my $col (@$rec) {

# required to keep the formatting consistent after completely encapsulating into perl on 8-2-2013
			if ( $colNumber++ == 13 ) {
				$col =~ tr/\-//d;
			}
			print CSV $col . "\t";
		}
		print CSV "\n";
	}
	$counter++;

	#    if ($counter > 5 ) {
	#    	$sth3->finish;
	#    	$sth1->finish;
	#    	$dbh->disconnect();
	#    	close CVS;
	#    	exit;
	#    }
}
$sth1->finish;
$dbh->disconnect();
close CVS;
close RUNERR;
system("date >> $dataFile");
