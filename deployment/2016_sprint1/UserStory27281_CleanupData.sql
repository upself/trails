--The following SQLs are used to clean up 'SW LPAR NO PROCESSOR' Data Exception data in related DB Tables
delete from eaadmin.cause_code where alert_type_id = 1;
delete from eaadmin.alert_software_lpar where id in (select id from eaadmin.alert where alert_type_id = 1);
delete from eaadmin.h_alert where alert_type_id = 1;
delete from eaadmin.alert where alert_type_id = 1;
delete from eaadmin.alert_type_cause where alert_type_id = 1;
delete from eaadmin.alert_type where id = 1;
--Regenerate statistics information under DBA role
runstats on table eaadmin.cause_code on all columns with distribution on all columns and detailed indexes all allow write access util_impact_priority 50;
runstats on table eaadmin.alert_software_lpar on all columns with distribution on all columns and detailed indexes all allow write access util_impact_priority 50;
runstats on table eaadmin.h_alert on all columns with distribution on all columns and detailed indexes all allow write access util_impact_priority 50;
runstats on table eaadmin.alert on all columns with distribution on all columns and detailed indexes all allow write access util_impact_priority 50;
runstats on table eaadmin.alert_type_cause on all columns with distribution on all columns and detailed indexes all allow write access util_impact_priority 50;
runstats on table eaadmin.alert_type on all columns with distribution on all columns and detailed indexes all allow write access util_impact_priority 50;