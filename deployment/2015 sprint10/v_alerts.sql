drop view v_alerts;

create view EAADMIN.v_alerts
(
   pk ,
   id ,
   fk_id ,
   customer_id ,
   comments ,
   remote_user ,
   alert_age ,
   creation_time ,
   record_time ,
   open ,
   type ,
   display_name ,
   cause_code_alert_type,
   alert_type_code,
   cc_target_date,
   cc_owner,
   cc_update_time,
   cc_remote_user,
   atc_status,
   ac_name,
   ac_show_gui,
   ac_responsibility
)
as
select
'HARDWARE' || cast(a.id as char(16)) ,
a.id ,
a.hardware_id ,
b.customer_id ,
a.comments ,
a.remote_user ,
days(current timestamp) - days(a.creation_time) as ALERT_AGE ,
a.creation_time ,
a.record_time ,
a.open ,
'HARDWARE' ,
'HW w/o HW LPAR',
d.name,
d.code,
c.target_date,
c.owner,
c.record_time,
c.remote_user,
e.status,
f.name,
f.show_in_gui,
g.name
from EAADMIN.alert_hardware a ,
EAADMIN.hardware b,
EAADMIN.cause_code c,
EAADMIN.alert_type d,
EAADMIN.alert_type_cause e,
EAADMIN.alert_cause f,
EAADMIN.alert_cause_responsibility g
where a.hardware_id =b.id
and c.alert_id=a.id
and c.alert_type_id=d.id
and e.alert_type_id=d.id
and f.id=e.alert_cause_id
and g.id=f.alert_cause_responsibility_id
and c.alert_cause_id=f.id
and d.code='HARDWARE'
union
all
select
'HARDWARE_LPAR' || cast(a.id as char(16)) ,
a.id ,
a.hardware_lpar_id ,
b.customer_id ,
a.comments ,
a.remote_user ,
days(current timestamp) - days(a.creation_time) as ALERT_AGE ,
a.creation_time ,
a.record_time ,
a.open ,
'HARDWARE_LPAR' ,
'HW LPAR w/o SW LPAR',
d.name,
d.code,
c.target_date,
c.owner,
c.record_time,
c.remote_user,
e.status,
f.name,
f.show_in_gui,
g.name
from EAADMIN.alert_hw_lpar a ,
EAADMIN.hardware_lpar b,
EAADMIN.cause_code c,
EAADMIN.alert_type d,
EAADMIN.alert_type_cause e,
EAADMIN.alert_cause f,
EAADMIN.alert_cause_responsibility g
where a.hardware_lpar_id= b.id
and c.alert_id=a.id
and c.alert_type_id=d.id
and e.alert_type_id=d.id
and f.id=e.alert_cause_id
and g.id=f.alert_cause_responsibility_id
and c.alert_cause_id=f.id
and d.code='HW_LPAR'
union
all
select
'SOFTWARE_LPAR' || cast(a.id as char(16)) ,
a.id ,
a.software_lpar_id ,
b.customer_id ,
a.comments ,
a.remote_user ,
days(current timestamp) - days(a.creation_time) as ALERT_AGE ,
a.creation_time ,
a.record_time ,
a.open ,
'SOFTWARE_LPAR' ,
'SW LPAR w/o HW LPAR' ,
d.name,
d.code,
c.target_date,
c.owner,
c.record_time,
c.remote_user,
e.status,
f.name,
f.show_in_gui,
g.name
from EAADMIN.alert_sw_lpar a ,
EAADMIN.software_lpar b,
EAADMIN.cause_code c,
EAADMIN.alert_type d,
EAADMIN.alert_type_cause e,
EAADMIN.alert_cause f,
EAADMIN.alert_cause_responsibility g
where a.software_lpar_id = b.id
and c.alert_id=a.id
and c.alert_type_id=d.id
and e.alert_type_id=d.id
and f.id=e.alert_cause_id
and g.id=f.alert_cause_responsibility_id
and c.alert_cause_id=f.id
and d.code='SW_LPAR'
union
all
select
'EXPIRED_SCAN' || cast(a.id as char(16)) ,
a.id ,
a.software_lpar_id ,
b.customer_id ,
a.comments ,
a.remote_user ,
days(current timestamp) - days(b.scantime) - c.scan_validity as ALERT_AGE ,
a.creation_time ,
a.record_time ,
a.open ,
'EXPIRED_SCAN' ,
'Outdated SW LPAR' ,
e.name,
e.code,
d.target_date,
d.owner,
d.record_time,
d.remote_user,
f.status,
g.name,
g.show_in_gui,
h.name
from EAADMIN.alert_expired_scan a ,
EAADMIN.software_lpar b ,
eaadmin.customer c ,
EAADMIN.cause_code d,
EAADMIN.alert_type e,
EAADMIN.alert_type_cause f,
EAADMIN.alert_cause g,
EAADMIN.alert_cause_responsibility h
where b.customer_id = c.customer_id
and a.software_lpar_id= b.id
and d.alert_id=a.id
and d.alert_type_id=e.id
and f.alert_type_id=e.id
and g.id=f.alert_cause_id
and h.id=g.alert_cause_responsibility_id
and d.alert_cause_id=g.id
and e.code='EXP_SCAN'
union
all
select
case when a.type = 'IBM' then 'UNLICENSED_IBM_SW' || cast(a.id as char(16)) else 'UNLICENSED_ISV_SW' || cast(a.id as char(16)) end ,
a.id ,
a.installed_software_id ,
c.customer_id ,
a.comments ,
a.remote_user ,
days(current timestamp) - days(a.creation_time) as ALERT_AGE ,
a.creation_time ,
a.record_time ,
a.open ,
case when a.type = 'IBM' then 'UNLICENSED_IBM_SW' else 'UNLICENSED_ISV_SW' end ,
case when a.type = 'IBM' then 'Unlicensed IBM SW' else 'Unlicensed ISV SW' end ,
e.name,
e.code,
d.target_date,
d.owner,
d.record_time,
d.remote_user,
f.status,
g.name,
g.show_in_gui,
h.name
from EAADMIN.alert_unlicensed_sw a ,
EAADMIN.installed_software b ,
eaadmin.software_lpar c ,
EAADMIN.cause_code d,
EAADMIN.alert_type e,
EAADMIN.alert_type_cause f,
EAADMIN.alert_cause g,
EAADMIN.alert_cause_responsibility h
where b.software_lpar_id = c.id
and a.installed_software_id= b.id
and d.alert_id=a.id
and d.alert_type_id=e.id
and f.alert_type_id=e.id
and g.id=f.alert_cause_id
and h.id=g.alert_cause_responsibility_id
and d.alert_cause_id=g.id
and e.code ='NOLIC'
union
all
select
'ALERT_HARDWARE_CFGDATA' || cast(a.id as char(16)) ,
a.id ,
a.hardware_id ,
b.customer_id ,
a.comments ,
a.remote_user ,
days(current timestamp) - days(a.creation_time) as ALERT_AGE ,
a.creation_time ,
a.record_time ,
a.open ,
'HWCFGDTA' ,
'SOM1b: HW Box Critical Configuration Data Populated',
d.name,
d.code,
c.target_date,
c.owner,
c.record_time,
c.remote_user,
e.status,
f.name,
f.show_in_gui,
g.name
from EAADMIN.alert_hardware_cfgdata a ,
EAADMIN.hardware b,
EAADMIN.cause_code c,
EAADMIN.alert_type d,
EAADMIN.alert_type_cause e,
EAADMIN.alert_cause f,
EAADMIN.alert_cause_responsibility g
where a.hardware_id=b.id
and c.alert_id=a.id
and c.alert_type_id=d.id
and e.alert_type_id=d.id
and f.id=e.alert_cause_id
and g.id=f.alert_cause_responsibility_id
and c.alert_cause_id=f.id
and d.code='HWCFGDTA'
; 

select * from v_alerts fetch first 30 rows only with ur;
