drop view eaadmin.v_alerts;

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
   cc_id,
   atc_status,
   ac_name,
   ac_show_gui,
   ac_responsibility
)
as
select
'HARDWARE' || cast(ah.id as char(16)) ,
ah.id ,
ah.hardware_id ,
h.customer_id ,
ah.comments ,
ah.remote_user ,
days(current timestamp) - days(ah.creation_time) as ALERT_AGE ,
ah.creation_time ,
ah.record_time ,
ah.open ,
'HARDWARE' ,
'HW w/o HW LPAR',
at.name,
at.code,
cc.target_date,
cc.owner,
cc.record_time,
cc.remote_user,
cc.id,
atc.status,
ac.name,
ac.show_in_gui,
acr.name
from EAADMIN.alert_hardware ah ,
EAADMIN.hardware h,
EAADMIN.cause_code cc,
EAADMIN.alert_type at,
EAADMIN.alert_type_cause atc,
EAADMIN.alert_cause ac,
EAADMIN.alert_cause_responsibility acr
where ah.hardware_id =h.id
and cc.alert_id=ah.id
and cc.alert_type_id=at.id
and atc.alert_type_id=at.id
and ac.id=atc.alert_cause_id
and acr.id=ac.alert_cause_responsibility_id
and cc.alert_cause_id=ac.id
and at.code='HARDWARE'
union
all
select
'ALERT_HARDWARE_CFGDATA' || cast(ahc.id as char(16)) ,
ahc.id ,
ahc.hardware_id ,
h.customer_id ,
ahc.comments ,
ahc.remote_user ,
days(current timestamp) - days(ahc.creation_time) as ALERT_AGE ,
ahc.creation_time ,
ahc.record_time ,
ahc.open ,
'HWCFGDTA' ,
'SOM1b: HW Box Critical Configuration Data Populated',
at.name,
at.code,
cc.target_date,
cc.owner,
cc.record_time,
cc.remote_user,
cc.id,
atc.status,
ac.name,
ac.show_in_gui,
acr.name
from EAADMIN.alert_hardware_cfgdata ahc ,
EAADMIN.hardware h,
EAADMIN.cause_code cc,
EAADMIN.alert_type at,
EAADMIN.alert_type_cause atc,
EAADMIN.alert_cause ac,
EAADMIN.alert_cause_responsibility acr
where ahc.hardware_id=h.id
and cc.alert_id=ahc.id
and cc.alert_type_id=at.id
and atc.alert_type_id=at.id
and ac.id=atc.alert_cause_id
and acr.id=ac.alert_cause_responsibility_id
and cc.alert_cause_id=ac.id
and at.code='HWCFGDTA'
union
all
select
'HARDWARE_LPAR' || cast(ahl.id as char(16)) ,
ahl.id ,
ahl.hardware_lpar_id ,
hl.customer_id ,
ahl.comments ,
ahl.remote_user ,
days(current timestamp) - days(ahl.creation_time) as ALERT_AGE ,
ahl.creation_time ,
ahl.record_time ,
ahl.open ,
'HARDWARE_LPAR' ,
'HW LPAR w/o SW LPAR',
at.name,
at.code,
cc.target_date,
cc.owner,
cc.record_time,
cc.remote_user,
cc.id,
atc.status,
ac.name,
ac.show_in_gui,
acr.name
from EAADMIN.alert_hw_lpar ahl ,
EAADMIN.hardware_lpar hl,
EAADMIN.cause_code cc,
EAADMIN.alert_type at,
EAADMIN.alert_type_cause atc,
EAADMIN.alert_cause ac,
EAADMIN.alert_cause_responsibility acr
where ahl.hardware_lpar_id= hl.id
and cc.alert_id=ahl.id
and cc.alert_type_id=at.id
and atc.alert_type_id=at.id
and ac.id=atc.alert_cause_id
and acr.id=ac.alert_cause_responsibility_id
and cc.alert_cause_id=ac.id
and at.code='HW_LPAR'
union
all
select
'SOFTWARE_LPAR' || cast(asl.id as char(16)) ,
asl.id ,
asl.software_lpar_id ,
sl.customer_id ,
asl.comments ,
asl.remote_user ,
days(current timestamp) - days(asl.creation_time) as ALERT_AGE ,
asl.creation_time ,
asl.record_time ,
asl.open ,
'SOFTWARE_LPAR' ,
'SW LPAR w/o HW LPAR' ,
at.name,
at.code,
cc.target_date,
cc.owner,
cc.record_time,
cc.remote_user,
cc.id,
atc.status,
ac.name,
ac.show_in_gui,
acr.name
from EAADMIN.alert_sw_lpar asl ,
EAADMIN.software_lpar sl,
EAADMIN.cause_code cc,
EAADMIN.alert_type at,
EAADMIN.alert_type_cause atc,
EAADMIN.alert_cause ac,
EAADMIN.alert_cause_responsibility acr
where asl.software_lpar_id = sl.id
and cc.alert_id=asl.id
and cc.alert_type_id=at.id
and atc.alert_type_id=at.id
and ac.id=atc.alert_cause_id
and acr.id=ac.alert_cause_responsibility_id
and cc.alert_cause_id=ac.id
and at.code='SW_LPAR'
union
all
select
'EXPIRED_SCAN' || cast(aes.id as char(16)) ,
aes.id ,
aes.software_lpar_id ,
sl.customer_id ,
aes.comments ,
aes.remote_user ,
days(current timestamp) - days(sl.scantime) - c.scan_validity as ALERT_AGE ,
aes.creation_time ,
aes.record_time ,
aes.open ,
'EXPIRED_SCAN' ,
'Outdated SW LPAR' ,
at.name,
at.code,
cc.target_date,
cc.owner,
cc.record_time,
cc.remote_user,
cc.id,
atc.status,
ac.name,
ac.show_in_gui,
acr.name
from EAADMIN.alert_expired_scan aes ,
EAADMIN.software_lpar sl ,
eaadmin.customer c ,
EAADMIN.cause_code cc,
EAADMIN.alert_type at,
EAADMIN.alert_type_cause atc,
EAADMIN.alert_cause ac,
EAADMIN.alert_cause_responsibility acr
where sl.customer_id = c.customer_id
and aes.software_lpar_id= sl.id
and cc.alert_id=aes.id
and cc.alert_type_id=at.id
and atc.alert_type_id=at.id
and ac.id=atc.alert_cause_id
and acr.id=ac.alert_cause_responsibility_id
and cc.alert_cause_id=ac.id
and at.code='EXP_SCAN'
union
all
select
case when aus.type = 'IBM' then 'UNLICENSED_IBM_SW' || cast(aus.id as char(16))
	 when aus.type = 'SCOPE' then 'UNDEFINED_SCOPE' || cast(aus.id as char(16))
	 when aus.type = 'ISVPRIO' then 'UNLICENSED_ISV_PRIO_SW' || cast(aus.id as char(16))
	else 'UNLICENSED_ISV_NOPRIO_SW' || cast(aus.id as char(16)) end ,
aus.id ,
aus.installed_software_id ,
sl.customer_id ,
aus.comments ,
aus.remote_user ,
days(current timestamp) - days(aus.creation_time) as ALERT_AGE ,
aus.creation_time ,
aus.record_time ,
aus.open ,
case when aus.type = 'IBM' then 'UNLICENSED_IBM_SW'
	 when aus.type = 'SCOPE' then 'UNDEFINED_SCOPE'
	 when aus.type = 'ISVPRIO' then 'UNLICENSED_ISV_PRIO_SW'
	else 'UNLICENSED_ISV_NOPRIO_SW' end ,
case when aus.type = 'IBM' then 'SOM4a: IBM SW Instances Reviewed'
	 when aus.type = 'SCOPE' then 'SOM3: SW Instances with Defined Contract Scope'
	 when aus.type = 'ISVPRIO' then 'SOM4b: Priority ISV SW Instances Reviewed'
	else 'SOM4c: ISV SW Instances Reviewed' end ,
at.name,
at.code,
cc.target_date,
cc.owner,
cc.record_time,
cc.remote_user,
cc.id,
atc.status,
ac.name,
ac.show_in_gui,
acr.name
from EAADMIN.alert_unlicensed_sw aus ,
EAADMIN.installed_software is ,
eaadmin.software_lpar sl ,
EAADMIN.cause_code cc,
EAADMIN.alert_type at,
EAADMIN.alert_type_cause atc,
EAADMIN.alert_cause ac,
EAADMIN.alert_cause_responsibility acr
where is.software_lpar_id = sl.id
and aus.installed_software_id= is.id
and cc.alert_id=aus.id
and cc.alert_type_id=at.id
and atc.alert_type_id=at.id
and ac.id=atc.alert_cause_id
and acr.id=ac.alert_cause_responsibility_id
and cc.alert_cause_id=ac.id
and at.code ='NOLIC'
; 


GRANT CONTROL ON EAADMIN.V_ALERT_RED_AGING TO USER EAADMIN
;
GRANT SELECT ON EAADMIN.V_ALERT_RED_AGING TO GROUP TRAILSTG
;
GRANT SELECT ON EAADMIN.V_ALERT_RED_AGING TO GROUP TRAILUPD
; 
GRANT CONTROL ON EAADMIN.V_ALERTS TO USER EAADMIN
;
GRANT SELECT ON EAADMIN.V_ALERTS TO GROUP TRAILSTG
;
GRANT SELECT ON EAADMIN.V_ALERTS TO GROUP TRAILUPD
; 
GRANT CONTROL ON EAADMIN.V_ALERT_REPORT TO USER EAADMIN
;
GRANT SELECT ON EAADMIN.V_ALERT_REPORT TO GROUP TRAILSTG
;
GRANT SELECT ON EAADMIN.V_ALERT_REPORT TO GROUP TRAILUPD
; 