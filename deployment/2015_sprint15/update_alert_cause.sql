 -- Update alert_cause prefix
 -- Auther: Jackie vndwbwan@cn.ibm.com
 -- Description: Please make sure to update TRAILSPD && TRAILSRP && TRAILSST
 -- Rule: Given the Cause Codes with the Prefix '1'
 --		The prefixes should be migrated to "SOM1a"
 --		Given the Cause Codes with the Prefix '2'
 --		The prefixes should be migrated to "SOM2a"
 --		Given the Cause Codes with the Prefix '3'
 --		The prefixes should be migrated to "SOM2b"
 --		Given the Cause Codes with the Prefix '4'
 --		The prefixes should be migrated to "SOM2c"
 --		Given the Cause Codes with the Prefix '5'
 --		They should be migrated to "SOM4a"
 --		Given the Cause Codes with the Prefix '5+6'
 --		They should be migrated to "SOM4x" 
 UPDATE EAADMIN.ALERT_CAUSE SET NAME=(
  	CASE 
  		WHEN LEFT(NAME,1) = '1' THEN 'SOM1a' || RIGHT(NAME,LENGTH(NAME)-1)
  		WHEN LEFT(NAME,1) = '2' THEN 'SOM2a' || RIGHT(NAME,LENGTH(NAME)-1)
  		WHEN LEFT(NAME,1) = '3' THEN 'SOM2b' || RIGHT(NAME,LENGTH(NAME)-1)
  		WHEN LEFT(NAME,1) = '4' THEN 'SOM2c' || RIGHT(NAME,LENGTH(NAME)-1)
  		WHEN LEFT(NAME,1) = '5' AND LEFT(NAME,3) <> '5+6'  THEN 'SOM4a' || RIGHT(NAME,LENGTH(NAME)-1)
  		WHEN LEFT(NAME,3) = '5+6' THEN 'SOM4x' || RIGHT(NAME,LENGTH(NAME)-3)
  		ELSE NAME 
  	END
  )
