--this is for story 32034:Run one time script to reset aging on SOM1b
update alert_hardware_cfgdata set creation_time=current timestamp where open=1;
delete table alert_hardware_cfgdata_h;