---Clean up the existing DB records for 'UNLICENSED SW' alert type for Story 37616
delete from EAADMIN.ALERT_TYPE_CAUSE where alert_type_id = 17;
delete from EAADMIN.ALERT_TYPE where id = 17;