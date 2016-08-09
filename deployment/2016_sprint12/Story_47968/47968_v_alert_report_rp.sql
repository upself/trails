drop view EAADMIN.v_alert_report;

create view EAADMIN.v_alert_report ( pk ,customer_id ,open ,assigned ,red
,yellow ,green ,display_name ) as
select 'HARDWARE' || cast(a.id as char(16))
, b.customer_id , a.open , case when a.remote_user = 'STAGING' then 0 else
1 end as assigned , case when days(current timestamp) - days(a.creation_time)
> 90 then 1 else 0 end as red , case when days(current timestamp) - days(a.creation_time)
between 46 and 90 then 1 else 0 end as yellow , case when days(current
timestamp) - days(a.creation_time) between 0 and 45 then 1 else 0 end as
green ,'SOM1a: HW WITH HOSTNAME' from EAADMIN.alert_hardware a ,EAADMIN.hardware
b where a.hardware_id = b.id
union all
select 'HW_LPAR' || cast(a.id as
char(16)) , b.customer_id , a.open , case when a.remote_user = 'STAGING'
then 0 else 1 end as assigned , case when days(current timestamp) - days(a.creation_time)
> 90 then 1 else 0 end as Red , case when days(current timestamp) - days(a.creation_time)
between 46 and 90 then 1 else 0 end as yellow , case when days(current
timestamp) - days(a.creation_time) between 0 and 45 then 1 else 0 end as
green ,'SOM2a: HW LPAR WITH SW LPAR' from EAADMIN.alert_hw_lpar a ,EAADMIN.hardware_lpar
b where a.hardware_lpar_id = b.id
union all
select 'SW_LPAR' || cast(a.id
as char(16)) , b.customer_id , a.open , case when a.remote_user = 'STAGING'
then 0 else 1 end as assigned , case when days(current timestamp) - days(a.creation_time)
> 90 then 1 else 0 end as Red , case when days(current timestamp) - days(a.creation_time)
between 46 and 90 then 1 else 0 end as yellow , case when days(current
timestamp) - days(a.creation_time) between 0 and 45 then 1 else 0 end as
green ,'SOM2b: SW LPAR WITH HW LPAR' from EAADMIN.alert_sw_lpar a ,EAADMIN.software_lpar
b where a.software_lpar_id = b.id
union all
select 'EXP_SCAN' || cast(a.id
as char(16)) , b.customer_id , a.open , case when a.remote_user = 'STAGING'
then 0 else 1 end as assigned , case when days(current timestamp) - days(b.scantime)
- c.scan_validity > 90 then 1 else 0 end as Red , case when days ( current
timestamp ) - days(b.scantime) - c.scan_validity between 46 and 90 then
1 else 0 end as Yellow , case when days(current timestamp) - days(b.scantime)
- c.scan_validity between 0 and 45 then 1 else 0 end as Green ,'SOM2c: UNEXPIRED SW LPAR'
from EAADMIN.alert_expired_scan a ,EAADMIN.software_lpar b ,eaadmin.customer
c where a.software_lpar_id = b.id and b.customer_id = c.customer_id
union all 
select case when a.type = 'SCOPE' then 'SWISCOPE' || cast(a.id as char(16))
when a.type = 'IBM' then 'SWIBM' || cast(a.id as char(16)) when a.type
= 'ISVPRIO' then 'SWISVPR' || cast(a.id as char(16)) else 'SWISVNPR' ||
cast(a.id as char(16)) end , c.customer_id , a.open , case when a.remote_user
= 'STAGING' then 0 else 1 end as assigned , case when days(current timestamp)
- days(a.creation_time) > 90 then 1 else 0 end as Red , case when days(current
timestamp) - days(a.creation_time) between 46 and 90 then 1 else 0 end
as Yellow , case when days(current timestamp) - days(a.creation_time) between
0 and 45 then 1 else 0 end as Green , case when a.type = 'IBM' then 'SOM4a: IBM SW INSTANCES REVIEWED'
when a.type = 'SCOPE' then 'SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE'
when a.type = 'ISVPRIO' then 'SOM4b: PRIORITY ISV SW INSTANCES REVIEWED'
else 'SOM4c: ISV SW INSTANCES REVIEWED' end from EAADMIN.alert_unlicensed_sw
a , EAADMIN.installed_software b , EAADMIN.software_lpar c where a.installed_software_id
= b.id and b.software_lpar_id = c.id 
union all
select 'HWCFGDTA' || cast(a.id
as char(16)) , x.customer_id , a.open , case when a.remote_user = 'STAGING'
then 0 else 1 end as assigned , case when days(current timestamp) - days(a.creation_time)
> 90 then 1 else 0 end as red , case when days(current timestamp) - days(a.creation_time)
between 46 and 90 then 1 else 0 end as yellow , case when days(current
timestamp) - days(a.creation_time) between 0 and 45 then 1 else 0 end as
green , 'SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED' from EAADMIN.alert_hardware_cfgdata
a , EAADMIN.hardware b , ( select distinct hardware_id,customer_id from
EAADMIN.hardware_lpar where status='ACTIVE' and lpar_status='ACTIVE'
) x, customer cus where a.hardware_id = b.id and b.id = x.hardware_id and cus.customer_id = x.customer_id and cus.sw_license_mgmt = 'YES';

GRANT CONTROL ON EAADMIN.v_alert_report TO USER EAADMIN		
;			
GRANT SELECT ON EAADMIN.v_alert_report TO GROUP TRAILRPT		
;