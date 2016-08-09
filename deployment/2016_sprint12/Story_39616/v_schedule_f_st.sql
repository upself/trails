DROP VIEW EAADMIN.v_schedule_f;
create view EAADMIN.v_schedule_f(installed_software_id,schedule_f_id ) as  
select 
isw.id
, ( COALESCE (( 
select ssf.id
 from  eaadmin.schedule_f ssf 
where (sl.customer_id = ssf.customer_id and ssf.status_id=2 )
and (((((sw.software_name = ssf.software_name and ssf.level='HOSTNAME') and (ssf.hostname = sl.name) )
or (((sw.software_name = ssf.software_name and ssf.level='HWBOX') and (ssf.serial = hw.serial) )and (ssf.machine_type = mt.name)))
or ((sw.software_name = ssf.software_name and ssf.level='HWOWNER' )and  (ssf.hw_owner = hw.owner) ))
or (sw.software_name = ssf.software_name and ssf.level='PRODUCT') )
order by  ssf.level fetch first 1 row only ),(select ssf.id from eaadmin.schedule_f ssf where (((sl.customer_id = ssf.customer_id and ssf.status_id=2 ) and (ssf.level='MANUFACTURER')) and ssf.MANUFACTURER = mf.name) ))) as sfid	
from 
EAADMIN.INSTALLED_SOFTWARE isw 
,EAADMIN.SOFTWARE sw
,EAADMIN.SOFTWARE_LPAR sl
,EAADMIN.MANUFACTURER mf
,EAADMIN.HW_SW_COMPOSITE hwsw
,EAADMIN.HARDWARE_LPAR hl
,EAADMIN.HARDWARE hw
,EAADMIN.MACHINE_TYPE mt
Where 
 (isw.software_id=sw.software_id)
And (isw.software_lpar_id=sl.id)
And (mf.id=sw.MANUFACTURER_ID)
And (hwsw.software_lpar_id=sl.id)
And (hwsw.hardware_lpar_id=hl.id)
And (hl.hardware_id=hw.id)
And (mt.id=hw.machine_type_id)
And (isw.status='ACTIVE')
and (sl.status='ACTIVE') 
and (sw.status='ACTIVE')
;
GRANT CONTROL ON EAADMIN.v_schedule_f TO USER EAADMIN		
;			
GRANT SELECT ON EAADMIN.v_schedule_f TO GROUP TRAILUPD
;	
GRANT SELECT ON EAADMIN.v_schedule_f TO GROUP TRAILSTG
;