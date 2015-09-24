--this is for story 32034:Run one time script to reset aging on SOM1b
update eaadmin.alert_hardware_cfgdata set creation_time=current timestamp;
update eaadmin.alert_hardware_cfgdata set record_time=current timestamp;
delete from eaadmin.alert_hardware_cfgdata_h;