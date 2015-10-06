update eaadmin.cause_code set alert_type_id = ( select id from eaadmin.alert_type where code = 'SWISCOPE' ) where id in ( select cc.id from eaadmin.cause_code cc join eaadmin.alert_unlicensed_sw aus where cc.alert_type_id = 17 and aus.type = 'SCOPE' );
update eaadmin.cause_code set alert_type_id = ( select id from eaadmin.alert_type where code = 'SWIBM' ) where id in ( select cc.id from eaadmin.cause_code cc join eaadmin.alert_unlicensed_sw aus where cc.alert_type_id = 17 and aus.type = 'IBM' );
update eaadmin.cause_code set alert_type_id = ( select id from eaadmin.alert_type where code = 'SWISVPR' ) where id in ( select cc.id from eaadmin.cause_code cc join eaadmin.alert_unlicensed_sw aus where cc.alert_type_id = 17 and aus.type = 'ISVPRIO' );
update eaadmin.cause_code set alert_type_id = ( select id from eaadmin.alert_type where code = 'SWISVNPR' ) where id in ( select cc.id from eaadmin.cause_code cc join eaadmin.alert_unlicensed_sw aus where cc.alert_type_id = 17 and aus.type = 'ISVNOPRIO' );  
insert into eaadmin.alert_type_cause values (17,183,'ACTIVE');