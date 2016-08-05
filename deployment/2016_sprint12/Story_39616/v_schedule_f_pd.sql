DROP VIEW EAADMIN.v_schedule_f;
create view EAADMIN.v_schedule_f(installed_software_id,schedule_f_id ) as  
select 
isw.id
, (
select ssf.id from  eaadmin.schedule_f ssf 
where sl.customer_id =  ssf.customer_id and ssf.status_id=2 
and ((sw.software_name = ssf.software_name and ssf.level='HOSTNAME' and ssf.hostname = sl.name )
or (sw.software_name = ssf.software_name and ssf.level='HWBOX' and ssf.serial = hw.serial and ssf.machine_type = mt.name)
or (sw.software_name = ssf.software_name and ssf.level='HWOWNER' and  ssf.hw_owner = hw.owner )
or (sw.software_name = ssf.software_name and ssf.level='PRODUCT') 
or (ssf.level='MANUFACTURER' and ssf.MANUFACTURER = mf.name)
)
order by 
CASE WHEN  sw.software_name = ssf.software_name and ssf.level='HOSTNAME' and ssf.hostname = sl.name  THEN 1 ELSE 
CASE WHEN  sw.software_name = ssf.software_name and ssf.level='HWBOX' and ssf.serial = hw.serial and ssf.machine_type = mt.name THEN 2 ELSE
CASE WHEN  sw.software_name = ssf.software_name and ssf.level='HWOWNER' and  ssf.hw_owner = hw.owner THEN 3 ELSE
CASE WHEN  sw.software_name = ssf.software_name and ssf.level='PRODUCT' THEN 4 ELSE
CASE WHEN ssf.level='MANUFACTURER' and ssf.MANUFACTURER = mf.name THEN 5 ELSE
6 END END END END END
fetch first 1 row only ) as sfid	
from 
EAADMIN.INSTALLED_SOFTWARE isw 
Join EAADMIN.SOFTWARE sw on isw.software_id=sw.software_id
Join EAADMIN.SOFTWARE_LPAR sl  on isw.software_lpar_id=sl.id
Join EAADMIN.MANUFACTURER mf on mf.id=sw.MANUFACTURER_ID
Join EAADMIN.HW_SW_COMPOSITE hwsw on hwsw.software_lpar_id=sl.id
Join EAADMIN.HARDWARE_LPAR hl on hwsw.hardware_lpar_id=hl.id
Join EAADMIN.HARDWARE hw on hl.hardware_id=hw.id
Join EAADMIN.MACHINE_TYPE mt on mt.id=hw.machine_type_id
Where isw.status='ACTIVE' and sl.status='ACTIVE' and sw.status='ACTIVE'
;
GRANT CONTROL ON EAADMIN.v_schedule_f TO USER EAADMIN		
;			
GRANT SELECT ON EAADMIN.v_schedule_f TO GROUP TRAILPRD		
;				
GRANT SELECT ON EAADMIN.v_schedule_f TO GROUP TRAILUPD
;