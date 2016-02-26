export to outputFilePar of del modified by coldel0x09  
 
SELECT  
lparCust.account_number 
,CASE WHEN AUS.Open = 0 THEN 'Blue' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN 'Red' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN 'Yellow' 
ELSE 'Green' END as Alert_status 
,aus.creation_time 
, case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) else days(aus.record_time) - days(aus.creation_time) end as Alert_duration 
, aus.type as alert_type
,sl.name as swLparName 
,hl.name as hwLparName 
,sl.ext_id as SW_EXT_ID 
,hl.ext_id as HW_EXT_ID 
,sl.tech_img_id as SW_TI_ID 
,hl.tech_image_id as HW_TI_ID 
,h.serial as hwSerial 
,mt.name as hwMachType 
,COALESCE ( CAST ( (select 'YES' from eaadmin.reconcile_used_license rul2  
join eaadmin.reconcile r2 on r2.id = rul2.reconcile_id 
join eaadmin.installed_software is2 on is2.id = r2.installed_software_id 
join eaadmin.software_lpar sl2 on sl2.id = is2.software_lpar_id 
where rul2.used_license_id = ul.id and sl2.customer_id != sl.customer_id fetch first 1 rows only) as char(3)), 'NO') as CrossAccountLevel 
,h.MODEL 
,h.CHASSIS_ID 
,h.CLOUD_NAME  
,h.owner as hwOwner 
,h.country as hwCountry 
,mt.type as hwAssetType 
,hl.server_type as Server_Type 
,hl.SPLA 
,hl.VIRTUAL_FLAG 
,hl.VIRTUAL_MOBILITY_RESTRICTION 
,hl.OS_TYPE
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
,h.CPU_IFL 
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
,COALESCE (hle.processor_count,0) hwLparEffProcCount 
,hl.EFFECTIVE_THREADS 
,case when ibmb.id is not null then 
COALESCE( CAST( (select pvui.VALUE_UNITS_PER_CORE from eaadmin.pvu_info pvui where pvui.pvu_id=pvum.pvu_id and 
(case when h.nbr_cores_per_chip = 1 then 'SINGLE-CORE'  
when h.nbr_cores_per_chip = 2 then 'DUAL-CORE'  
when h.nbr_cores_per_chip = 4 then 'QUAD-CORE'  
when h.nbr_cores_per_chip > 0 then 'MULTI-CORE'  
else '' end ) = pvui.PROCESSOR_TYPE  fetch first 1 row only ) as CHAR(8)),'base data missing') else 'Non_IBM Product' end as pvuPerCode 
,s.software_name as primaryComponent 
,s.pid as pid 
, case when ba.version != '8.1' then 'N/A' when insTadz.last_used is null or insTadz.last_used = '1970-01-01' then 'Not used' else cast(insTadz.last_used as char(16)) end as MFSwlastUsed 
, COALESCE ( CAST ( (select scop.description from eaadmin.scope scop join eaadmin.schedule_f sf on sf.scope_id = scop.id 
where sf.customer_id = lparCust.customer_id 
and sf.status_id=2 
and sf.software_name = s.software_name 
and ( ( sf.level = 'PRODUCT' ) 
or (( sf.hostname = sl.name ) and ( level = 'HOSTNAME' )) 
or (( sf.serial = h.serial ) and ( sf.machine_type = mt.name ) and ( sf.level = 'HWBOX' )) 
or (( sf.hw_owner = h.owner ) and ( sf.level ='HWOWNER' )) ) 
order by sf.LEVEL fetch first 1 rows only) as varchar(64) ), 'Not specified' ) as swOwner 
,aus.remote_user as alertAssignee 
,aus.comments as alertAssComments 
,instSwMan.name as instSwManName 
,dt.name as instSwDiscrepName 
,case when rt.is_manual = 0 and sr.id is not null then rt.name || '(SCARLET)' 
when rt.is_manual = 0 and sr.id is null then rt.name || '(AUTO)' 
when rt.is_manual = 1 and sr.id is not null then rt.name || '(SCARLET)' 
when rt.is_manual = 1 and sr.id is null then rt.name || '(MANUAL)' end 
,am.name as allocationMethod 
,r.remote_user as reconUser 
,r.record_time as reconTime 
,case when rt.is_manual = 0 then 'Auto Close' when rt.is_manual = 1 then r.comments end as reconComments 
,parentS.software_name as parentName 
,c.account_number as licAccount 
,l.full_desc as licenseName 
,case when l.id is null then '' when lsm.id is null then 'No' else 'Yes' end as catalogMatch 
,l.prod_name as licProdName 
,l.version as licVersion 
,CONCAT(CONCAT(RTRIM(CHAR(L.Cap_Type)), '-'), CT.Description) as Capacity_type 
,l.environment as Environment 
,ul.used_quantity 
,case when r.id is null then '' 
when r.machine_level = 0 then 'No' else 'Yes' end as Mach_level 
,REPLACE(RTRIM(CHAR(DATE(L.Expire_Date), USA)), '/', '-') as Maint_expir_date 
,l.po_number 
,l.cpu_serial 
,case when l.ibm_owned = 0 then 'Customer' 
when l.ibm_owned = 1 then 'IBM' else '' end as License_owner 
,l.ext_src_id 
,l.record_time 
from 
 eaadmin.software_lpar sl 
 inner join eaadmin.hw_sw_composite hsc on sl.id = hsc.software_lpar_id 
 inner join eaadmin.hardware_lpar hl on hsc.hardware_lpar_id = hl.id 
 left outer join eaadmin.hardware_lpar_eff hle on ( hle.hardware_lpar_id = hl.id and hle.status = 'ACTIVE' ) 
 inner join eaadmin.hardware h on hl.hardware_id = h.id 
 inner join eaadmin.machine_type mt on h.machine_type_id = mt.id 
 inner join eaadmin.installed_software is on sl.id = is.software_lpar_id 
 inner join eaadmin.software s on is.software_id = s.software_id 
 
 inner join eaadmin.manufacturer instSwMan on s.manufacturer_id = instSwMan.id 
 inner join eaadmin.discrepancy_type dt on is.discrepancy_type_id = dt.id 
 inner join eaadmin.alert_unlicensed_sw aus on is.id = aus.installed_software_id
 left outer join eaadmin.installed_tadz insTadz on is.id = insTadz.installed_software_id
 left outer join eaadmin.bank_account ba on insTadz.bank_account_id = ba.id
 left outer join eaadmin.reconcile r on is.id = r.installed_software_id 
 left outer join eaadmin.reconcile_type rt on r.reconcile_type_id = rt.id 
 left outer join eaadmin.scarlet_reconcile sr on r.id = sr.id 
 left outer join eaadmin.allocation_methodology am on r.allocation_methodology_id = am.id 
 left outer join eaadmin.installed_software parent on r.parent_installed_software_id = parent.id 
 left outer join eaadmin.software parentS on parent.software_id = parentS.software_id 
 
 left outer join eaadmin.reconcile_used_license rul on r.id = rul.reconcile_id 
 left outer join eaadmin.used_license ul on rul.used_license_id = ul.id 
 left outer join eaadmin.license l on ul.license_id = l.id 
 left outer join eaadmin.license_sw_map lsm on l.id = lsm.license_id 
 left outer join eaadmin.capacity_type ct on l.cap_type = ct.code 
 left outer join eaadmin.customer c on l.customer_id = c.customer_id 
 left outer join eaadmin.pvu_map pvum on h.MACHINE_TYPE_ID = pvum.MACHINE_TYPE_ID and h.MAST_PROCESSOR_TYPE = pvum.PROCESSOR_BRAND and h.MODEL = pvum.PROCESSOR_MODEL 
 left outer join eaadmin.ibm_brand ibmb on instSwMan.id=ibmb.manufacturer_id 

 inner join eaadmin.customer lparCust on lparCust.customer_id = sl.customer_id 

where 
 (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id)) 
 and lparCust.status='ACTIVE' 
 and lparCust.sw_license_mgmt = 'YES' 
 and sl.customer_id = customerIdPar
 
 ORDER BY lparCust.account_number, 4 desc, parentS.software_name 
 
with ur;