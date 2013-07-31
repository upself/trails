#!/usr/bin/perl
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: dbryson@us.ibm.com
# ========================================================

$reportDir = "/home/dbryson/asset_emea/";
chdir $reportDir;
$rundate = `date`;
$generateFiles = "db2 -tvf /home/dbryson/asset_emea/makeList.sql";
system($generateFiles);
$makeheader = "cat header.txt > $reportDir" . "emea_asset.tsv";
system($makeheader);

open( INPUT, "<" . "/home/dbryson/asset_emea/emea_list.txt" )
  or die "Cannot open emea_list.txt";
open( RUNERR, ">/home/dbryson/asset_emea/run_err.log" );
print RUNERR "++++++++++++\n$rundate\n";

while (<INPUT>) {
	chomp;
	$account_id = $_;
	$account_id =~ s/\n|\r|\f//gm;
# removed references to hardware_lpar_type

	$selectArchiveSQL = "
connect to traherp user dbryson using apr10new;
set schema eaadmin;

export to $reportDir$account_id of del modified by coldel0x09 
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
				,case when software_lpar_eff.status = 'ACTIVE' then software_lpar_eff.processor_count
				 else software_lpar.processor_count end as processor_count
				,hardware.processor_count as hw_processor_count
				,hardware_lpar.ext_id as ext_id
				,hardware_lpar.tech_image_id as tech_image_id
			from
				eaadmin.customer as customer
				,eaadmin.customer_type as customer_type
				,eaadmin.pod as pod
				,eaadmin.software_lpar as software_lpar
				left outer join eaadmin.software_lpar_eff as software_lpar_eff on 
					software_lpar_eff.id = software_lpar.id
				left outer join eaadmin.hw_sw_composite as hw_sw_composite on 
					hw_sw_composite.software_lpar_id = software_lpar.id 
				left outer join eaadmin.hardware_lpar as hardware_lpar on 
					hardware_lpar.id = hw_sw_composite.hardware_lpar_id
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
    with ur;
";
	system( "echo \"" . $selectArchiveSQL . "\"> tmp.sql" );

	$assetCommandLine = "db2 -tvf $reportDir" . "tmp.sql";
	$reformatCommand  =
	  "cat $reportDir" . "$account_id >> $reportDir" . "emea_asset.tsv";
#	print $assetCommandLine . "\n";
	print $reformatCommand . "\n";
	system($assetCommandLine);
	if ($? >= 8 )
	{
        	print RUNERR "failed to run -- Account Number $account_id\n";
	} 
	system($reformatCommand);
	unlink $account_id;

}

close INPUT;
close RUNERR;
system( "date >> $reportDir" . "emea_asset.tsv" );

