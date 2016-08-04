drop view eaadmin.v_alert_red_aging;

create view eaadmin.v_alert_red_aging ( 
id , customer_id , account_number
, customer_name , customer_type , display_name , alert_age , machine_type
, serial , hardware_lpar_name , software_lpar_name , software_name ) 
as select T.id , T.customer_id , c.account_number , c.customer_name , ct.customer_type_name
, T.display_name , T.alert_age , T.machine_type , T.serial , T.hardware_lpar_name
, T.software_lpar_name , T.software_name 
from 
( 
select 'HARDWARE' || CAST(H.ID
AS CHAR(16)) as id , 'HW W/O HW LPAR' as display_name , h.customer_id as
customer_id , days(current_timestamp) - days(ah.creation_time) as alert_age
, mt.name as machine_type , h.serial as serial , '' as hardware_lpar_name
, '' as software_lpar_name , '' as software_name from eaadmin.alert_hardware
ah , eaadmin.hardware h , eaadmin.machine_type mt where ah.open = 1 and
days(current timestamp) - days(ah.creation_time) > 90 and ah.hardware_id
= h.id and h.machine_type_id = mt.id 
union all 
select 'ALERT_HARDWARE_CFGDATA'
|| CAST(H.ID AS CHAR(16)) as id , 'SOM1b: HW Box Critical Configuration Data Populated'
as display_name , x.customer_id as customer_id , days(current_timestamp)
- days(ah.creation_time) as alert_age , mt.name as machine_type , h.serial
as serial , '' as hardware_lpar_name , '' as software_lpar_name , '' as
software_name from eaadmin.alert_hardware_cfgdata ah , eaadmin.hardware
h , eaadmin.machine_type mt, ( select distinct hl.hardware_id,hl.customer_id from EAADMIN.hardware_lpar hl
, EAADMIN.customer c where hl.status='ACTIVE' and hl.lpar_status = 'ACTIVE' 
and c.customer_id=hl.customer_id and c.sw_license_mgmt = 'YES'  ) x
where ah.open = 1 and days(current timestamp)
- days(ah.creation_time) > 90 and ah.hardware_id = h.id and h.machine_type_id
= mt.id and x.hardware_id=h.id
union all 
select 'HARDWARE_LPAR' || CAST(HL.ID AS CHAR(16)) as
id , 'HW LPAR W/O SW LPAR' as display_name , hl.customer_id as customer_id
, days(current_timestamp) - days(ahl.creation_time) as alert_age , mt.name
as machine_type , h.serial as serial , hl.name as hardware_lpar_name ,
'' as software_lpar_name , '' as software_name from eaadmin.alert_hw_lpar
ahl , eaadmin.hardware_lpar hl , eaadmin.hardware h , eaadmin.machine_type
mt where ahl.open = 1 and days(current timestamp) - days(ahl.creation_time)
> 90 and ahl.hardware_lpar_id = hl.id and hl.hardware_id = h.id and h.machine_type_id
= mt.id 
union all 
select 'SOFTWARE_LPAR' || CAST(SL.ID AS CHAR(16)) as
id , 'SW LPAR W/O HW LPAR' as display_name , sl.customer_id as customer_id
, days(current_timestamp) - days(asl.creation_time) as alert_age , '' as
machine_type , '' as serial , '' as hardware_lpar_name , sl.name as software_lpar_name
, '' as software_name from eaadmin.alert_sw_lpar asl , eaadmin.software_lpar
sl where asl.open = 1 and days(current timestamp) - days(asl.creation_time)
> 90 and asl.software_lpar_id = sl.id 
union all 
select 'EXPIRED_SCAN' ||
CAST(SL.ID AS CHAR(16)) as id , 'OUTDATED SW LPAR' as display_name , sl.customer_id
as customer_id , days(current timestamp) - days(sl.scantime) - c.scan_validity
as alert_age , mt.name as machine_type ,h.serial as serial ,hl.name as
hardware_lpar_name , sl.name as software_lpar_name , '' as software_name
from eaadmin.customer c , eaadmin.alert_expired_scan aes , eaadmin.software_lpar
sl left outer join eaadmin.hw_sw_composite hsc on hsc.software_lpar_id
= sl.id left outer join eaadmin.hardware_lpar hl on hsc.hardware_lpar_id
= hl.id left outer join eaadmin.hardware h on hl.hardware_id = h.id left
outer join eaadmin.machine_type mt on h.machine_type_id = mt.id where aes.open
= 1 and days(current timestamp) - days(sl.scantime) - c.scan_validity >
90 and aes.software_lpar_id = sl.id and sl.customer_id = c.customer_id
union all 
SELECT case when aus.type = 'IBM' then 'UNLICENSED_IBM_SW' else
'UNLICENSED_ISV_SW' END || CAST(is.id AS CHAR(16)) as id , case when aus.type
= 'IBM' then 'UNLICENSED_IBM_SW' else 'UNLICENSED_ISV_SW' END as display_name
,sl.customer_id as customer_id ,days(current_timestamp) - days(aus.creation_time)
as alert_age ,mt.name as machine_type ,h.serial as serial ,hl.name as hardware_lpar_name
,sl.name as software_lpar_name ,si.name as software_name from eaadmin.alert_unlicensed_sw
aus , eaadmin.installed_software is , eaadmin.software_lpar sl , eaadmin.hw_sw_composite
hsc , eaadmin.hardware_lpar hl , eaadmin.hardware h , eaadmin.machine_type
mt , eaadmin.software_item si where aus.open = 1 and days(current timestamp)
- days(aus.creation_time) > 90 and aus.installed_software_id = is.id and
is.software_lpar_id = sl.id and sl.id = hsc.software_lpar_id and hl.id
= hsc.hardware_lpar_id and h.id = hl.hardware_id and h.machine_type_id
= mt.id and is.software_id = si.id ) as T , eaadmin.customer c , eaadmin.customer_type
ct where c.customer_id = T.customer_id and c.customer_type_id = ct.customer_type_id;