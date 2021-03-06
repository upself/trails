drop view eaadmin.v_alert_report;

create view EAADMIN.v_alert_report
(
   pk ,customer_id ,open ,assigned ,red ,yellow ,green ,display_name
)
as
select
'HARDWARE' || cast(a.id as char(16)) ,
b.customer_id ,
a.open ,
case when a.remote_user = 'STAGING' then 0 else 1 end as assigned ,
case when days(current timestamp) - days(a.creation_time) > 90 then 1 else 0 end as red ,
case when days(current timestamp) - days(a.creation_time) between 46
and 90 then 1 else 0 end as yellow ,
case when days(current timestamp) - days(a.creation_time) between 0
and 45 then 1 else 0 end as green ,'HW w/o HW LPAR'
from EAADMIN.alert_hardware a ,EAADMIN.hardware b
where a.hardware_id = b.id
union
all
select
'HARDWARE_LPAR' || cast(a.id as char(16)) ,
b.customer_id ,
a.open ,
case when a.remote_user = 'STAGING' then 0 else 1 end as assigned ,
case when days(current timestamp) - days(a.creation_time) > 90 then 1 else 0 end as Red ,
case when days(current timestamp) - days(a.creation_time) between 46
and 90 then 1 else 0 end as yellow ,
case when days(current timestamp) - days(a.creation_time) between 0
and 45 then 1 else 0 end as green ,'HW LPAR w/o SW LPAR'
from EAADMIN.alert_hw_lpar a ,EAADMIN.hardware_lpar b
where a.hardware_lpar_id = b.id
union
all
select
'SOFTWARE_LPAR' || cast(a.id as char(16)) ,
b.customer_id ,
a.open ,
case when a.remote_user = 'STAGING' then 0 else 1 end as assigned ,
case when days(current timestamp) - days(a.creation_time) > 90 then 1 else 0 end as Red ,
case when days(current timestamp) - days(a.creation_time) between 46
and 90 then 1 else 0 end as yellow ,
case when days(current timestamp) - days(a.creation_time) between 0
and 45 then 1 else 0 end as green ,'SW LPAR w/o HW LPAR'
from EAADMIN.alert_sw_lpar a ,EAADMIN.software_lpar b
where a.software_lpar_id = b.id
union
all
select
'EXPIRED_SCAN' || cast(a.id as char(16)) ,
b.customer_id ,
a.open ,
case when a.remote_user = 'STAGING' then 0 else 1 end as assigned ,
case when days(current timestamp) - days(b.scantime) - c.scan_validity > 90 then 1 else 0 end as Red ,
case when days
(
   current timestamp
)
- days(b.scantime) - c.scan_validity between 46
and 90 then 1 else 0 end as Yellow ,
case when days(current timestamp) - days(b.scantime) - c.scan_validity between 0
and 45 then 1 else 0 end as Green ,'Outdated SW LPAR'
from EAADMIN.alert_expired_scan a ,EAADMIN.software_lpar b ,eaadmin.customer c
where a.software_lpar_id = b.id
and b.customer_id = c.customer_id
union
all
select
case when a.type = 'IBM' then 'UNLICENSED_IBM_SW' || cast(a.id as char(16)) else 'UNLICENSED_ISV_SW' || cast(a.id as char(16)) end ,
c.customer_id ,
a.open ,
case when a.remote_user = 'STAGING' then 0 else 1 end as assigned ,
case when days(current timestamp) - days(a.creation_time) > 90 then 1 else 0 end as Red ,
case when days(current timestamp) - days(a.creation_time) between 46
and 90 then 1 else 0 end as Yellow ,
case when days(current timestamp) - days(a.creation_time) between 0
and 45 then 1 else 0 end as Green ,
case when a.type = 'IBM' then 'Unlicensed IBM SW' else 'Unlicensed ISV SW' end
from EAADMIN.alert_unlicensed_sw a ,
EAADMIN.installed_software b ,
EAADMIN.software_lpar c
where a.installed_software_id = b.id
and b.software_lpar_id = c.id
union
all
select
'ALERT_HARDWARE_CFGDATA' || cast(a.id as char(16)) ,
b.customer_id ,
a.open ,
case when a.remote_user = 'STAGING' then 0 else 1 end as assigned ,
case when days(current timestamp) - days(a.creation_time) > 90 then 1 else 0 end as red ,
case when days(current timestamp) - days(a.creation_time) between 46
and 90 then 1 else 0 end as yellow ,
case when days(current timestamp) - days(a.creation_time) between 0
and 45 then 1 else 0 end as green ,'SOM1b: HW Box Critical Configuration Data Populated'
from EAADMIN.alert_hardware_cfgdata a ,
EAADMIN.hardware b
where a.hardware_id = b.id
;
