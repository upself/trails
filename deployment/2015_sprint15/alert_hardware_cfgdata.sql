--this is for story 32034:Run one time script to reset aging on SOM1b
update alert_hardware_cfgdata set creation_time=current timestamp;
update alert_hardware_cfgdata set record_time=current timestamp;
delete from alert_hardware_cfgdata_h;