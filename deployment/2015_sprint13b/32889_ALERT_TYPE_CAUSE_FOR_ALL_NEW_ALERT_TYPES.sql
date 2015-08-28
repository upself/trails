--Add existing shared cause codes from 'UNLICENSED SW' alert type for New Alert Type: SOM4a: IBM SW Instances Reviewed(7=SWIBM)
delete from ALERT_TYPE_CAUSE
where ALERT_TYPE_ID = (select ID from ALERT_TYPE where CODE = 'SWIBM')
and ALERT_CAUSE_ID in (select ID from ALERT_CAUSE where NAME like '%5+6%');

insert into ALERT_TYPE_CAUSE select (select ID from ALERT_TYPE where code = 'SWIBM'), ID, 'ACTIVE'
from ALERT_CAUSE
where NAME like '%5+6%' order by ID;

--Add existing shared cause codes from 'UNLICENSED SW' alert type for New Alert Type: SOM4b: Priority ISV SW Instances Reviewed(58=SWISVPR)
delete from ALERT_TYPE_CAUSE
where ALERT_TYPE_ID = (select ID from ALERT_TYPE where CODE = 'SWISVPR')
and ALERT_CAUSE_ID in (select ID from ALERT_CAUSE where NAME like '%5+6%');

insert into ALERT_TYPE_CAUSE select (select ID from ALERT_TYPE where CODE = 'SWISVPR'), ID, 'ACTIVE'
from ALERT_CAUSE
where NAME like '%5+6%' order by ID;

--Add existing shared cause codes from 'UNLICENSED SW' alert type for New Alert Type: SOM4c: ISV SW Instances Reviewed(59=SWISVNPR)
delete from ALERT_TYPE_CAUSE
where ALERT_TYPE_ID = (select ID from ALERT_TYPE where CODE = 'SWISVNPR')
and ALERT_CAUSE_ID in (select ID from ALERT_CAUSE where NAME like '%5+6%');

insert into ALERT_TYPE_CAUSE select (select ID from ALERT_TYPE where CODE = 'SWISVNPR'), ID, 'ACTIVE'
from ALERT_CAUSE
where NAME like '%5+6%' order by ID;

--Add dedicated cause code '5 Sub Capacity reporting Dist; On boarding in progress' for New Alert Type: SOM4a: IBM SW Instances Reviewed(7=SWIBM)
delete from ALERT_TYPE_CAUSE
where ALERT_TYPE_ID = (select ID from ALERT_TYPE where CODE = 'SWIBM')
and ALERT_CAUSE_ID in (select ID from ALERT_CAUSE where NAME = '5 Sub Capacity reporting Dist; On boarding in progress');

insert into ALERT_TYPE_CAUSE select (select ID from ALERT_TYPE where CODE = 'SWIBM'), ID, 'ACTIVE'
from ALERT_CAUSE
where NAME = '5 Sub Capacity reporting Dist; On boarding in progress';