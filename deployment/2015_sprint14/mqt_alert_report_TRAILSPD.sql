DROP TABLE EAADMIN.MQT_ALERT_REPORT;

CREATE SUMMARY TABLE EAADMIN.MQT_ALERT_REPORT
(
   ID,
   CUSTOMER_ID,
   DISPLAY_NAME,
   ASSET_TYPE,
   RECORD_TIME,
   ASSIGNED,
   RED,
   YELLOW,
   GREEN,
   RED91,
   RED121,
   RED151,
   RED181,
   RED366,
   ASSET_TOTAL
)
AS
(
   SELECT
   ID ,
   CUSTOMER_ID ,
   DISPLAY_NAME ,
   ASSET_TYPE ,
   CURRENT TIMESTAMP ,
   ASSIGNED ,
   RED ,
   YELLOW ,
   GREEN ,
   RED91 ,
   RED121 ,
   RED151 ,
   RED181 ,
   RED366 ,
   ASSET_TOTAL
   FROM
   (
      SELECT
      'HARDWARE' || CASE WHEN H.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM1a: HW WITH HOSTNAME' AS DISPLAY_NAME ,
      CASE WHEN H.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN AH.REMOTE_USER IS NULL THEN NULL WHEN AH.REMOTE_USER = 'STAGING' THEN 0 ELSE 1 END ) AS ASSIGNED ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) > 90 THEN 1 ELSE 0 END ) AS RED ,
      SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) BETWEEN 46 AND 90 THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) < 46 THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) > 365 THEN 1 ELSE 0 END) AS RED366 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) BETWEEN 181 AND 365 THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) BETWEEN 151 AND 180 THEN 1 ELSE 0 END) AS RED151 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) BETWEEN 121 AND 150 THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AH.CREATION_TIME) BETWEEN 91 AND 120 THEN 1 ELSE 0 END) AS RED91 ,
      SUM( CASE WHEN H.HARDWARE_STATUS = 'ACTIVE' THEN 1 ELSE 0 END ) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.HARDWARE H ON H.CUSTOMER_ID = C.CUSTOMER_ID AND H.STATUS = 'ACTIVE' AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.ALERT_HARDWARE AH ON AH.HARDWARE_ID = H.ID AND AH.OPEN = 1 LEFT OUTER
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      GROUP BY 'HARDWARE' || CASE WHEN H.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN H.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'HARDWARE' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM1a: HW WITH HOSTNAME' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'HARDWARE' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM1a: HW WITH HOSTNAME' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'HW_LPAR' || CASE WHEN HL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2a: HW LPAR WITH SW LPAR' AS DISPLAY_NAME ,
      CASE WHEN HL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN AHL.REMOTE_USER IS NULL THEN NULL WHEN AHL.REMOTE_USER = 'STAGING' THEN 0 ELSE 1 END ) AS ASSIGNED ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) > 90 THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) BETWEEN 46 AND 90 THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) < 46 THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) > 365 THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) BETWEEN 181 AND 365 THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) BETWEEN 151 AND 180 THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) BETWEEN 121 AND 150 THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHL.CREATION_TIME) BETWEEN 91 AND 120 THEN 1 ELSE 0 END ) AS RED91 ,
      SUM( CASE WHEN H.HARDWARE_STATUS = 'ACTIVE' AND HL.LPAR_STATUS != 'HWCOUNT' THEN 1 ELSE 0 END ) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C JOIN
      EAADMIN.HARDWARE_LPAR HL ON HL.CUSTOMER_ID = C.CUSTOMER_ID AND HL.STATUS = 'ACTIVE' 
										AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE'
      JOIN EAADMIN.HARDWARE H ON H.ID = HL.HARDWARE_ID LEFT OUTER
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID LEFT OUTER
      JOIN EAADMIN.ALERT_HW_LPAR AHL ON AHL.HARDWARE_LPAR_ID = HL.ID AND AHL.OPEN = 1
      GROUP BY 'HW_LPAR' || CASE WHEN HL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN HL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'HW_LPAR' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2a: HW LPAR WITH SW LPAR' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'HW_LPAR' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2a: HW LPAR WITH SW LPAR' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SW_LPAR' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2b: SW LPAR WITH HW LPAR' AS DISPLAY_NAME ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN ASL.REMOTE_USER IS NULL THEN NULL WHEN ASL.REMOTE_USER = 'STAGING' THEN 0 ELSE 1 END ) AS ASSIGNED ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) > 90 THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) BETWEEN 46 AND 90 THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) < 46 THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) > 365 THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) BETWEEN 181 AND 365 THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) BETWEEN 151 AND 180 THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) BETWEEN 121 AND 150 THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(ASL.CREATION_TIME) BETWEEN 91 AND 120 THEN 1 ELSE 0 END ) AS RED91 ,
      COUNT(SL.ID) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.SOFTWARE_LPAR SL ON SL.CUSTOMER_ID = C.CUSTOMER_ID 
				AND SL.STATUS = 'ACTIVE' AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.ALERT_SW_LPAR ASL ON SL.ID = ASL.SOFTWARE_LPAR_ID AND ASL.OPEN = 1 LEFT OUTER
      JOIN EAADMIN.HW_SW_COMPOSITE HSC ON SL.ID = HSC.SOFTWARE_LPAR_ID LEFT OUTER
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.ID = HSC.HARDWARE_LPAR_ID LEFT OUTER
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID LEFT OUTER
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      GROUP BY 'SW_LPAR' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'SW_LPAR' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2b: SW LPAR WITH HW LPAR' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SW_LPAR' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2b: SW LPAR WITH HW LPAR' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'EXP_SCAN' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2c: UNEXPIRED SW LPAR' AS DISPLAY_NAME ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN AES.REMOTE_USER IS NULL THEN NULL WHEN AES.REMOTE_USER = 'STAGING' THEN 0 ELSE 1 END ) AS ASSIGNED ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY > 90 THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY BETWEEN 46 AND 90 THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY BETWEEN 0 AND 45 THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY > 365 THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY BETWEEN 181 AND 365 THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY BETWEEN 151 AND 180 THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY BETWEEN 121 AND 150 THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN AES.ID IS NOT NULL AND DAYS(CURRENT TIMESTAMP) - DAYS(SL.SCANTIME) - C.SCAN_VALIDITY BETWEEN 91 AND 120 THEN 1 ELSE 0 END ) AS RED91 ,
      COUNT(SL.ID) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C JOIN EAADMIN.SOFTWARE_LPAR SL ON C.CUSTOMER_ID = SL.CUSTOMER_ID
			AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' AND SL.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.ALERT_EXPIRED_SCAN AES ON AES.SOFTWARE_LPAR_ID = SL.ID AND AES.OPEN = 1 LEFT OUTER
      JOIN EAADMIN.HW_SW_COMPOSITE HSC ON SL.ID = HSC.SOFTWARE_LPAR_ID LEFT OUTER
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.ID = HSC.HARDWARE_LPAR_ID LEFT OUTER
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID LEFT OUTER
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      GROUP BY 'EXP_SCAN' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'EXP_SCAN' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2c: UNEXPIRED SW LPAR' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'EXP_SCAN' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM2c: UNEXPIRED SW LPAR' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWISCOPE' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE' AS DISPLAY_NAME ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN ( AUS.REMOTE_USER IS NULL ) THEN NULL
				WHEN ( AUS.REMOTE_USER != 'STAGING' ) THEN 1 ELSE 0 END ) AS ASSIGNED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 90 ) THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 46 AND 90) THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) < 46) THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 365) THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 181 AND 365 ) THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 151 AND 180 ) THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 121 AND 150 ) THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 91 AND 120 ) THEN 1 ELSE 0 END ) AS RED91 ,
      SUM( CASE WHEN ( PI.LICENSABLE = 1 ) THEN 1 ELSE 0 END ) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.SOFTWARE_LPAR SL ON SL.CUSTOMER_ID = C.CUSTOMER_ID AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' AND SL.STATUS = 'ACTIVE'
      JOIN EAADMIN.HW_SW_COMPOSITE HSC ON SL.ID = HSC.SOFTWARE_LPAR_ID
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.ID = HSC.HARDWARE_LPAR_ID AND HL.STATUS = 'ACTIVE' AND HL.LPAR_STATUS != 'HWCOUNT'
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID AND H.STATUS = 'ACTIVE'
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      JOIN EAADMIN.INSTALLED_SOFTWARE IS ON SL.ID = IS.SOFTWARE_LPAR_ID AND IS.STATUS = 'ACTIVE'
      JOIN EAADMIN.PRODUCT_INFO PI ON IS.SOFTWARE_ID = PI.ID LEFT OUTER
      JOIN EAADMIN.ALERT_UNLICENSED_SW AUS ON AUS.INSTALLED_SOFTWARE_ID = IS.ID AND AUS.TYPE = 'SCOPE' AND AUS.OPEN = 1
      GROUP BY 'SWISCOPE' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'SWISCOPE' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWISCOPE' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWIBM' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4a: IBM SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN ( AUS.REMOTE_USER IS NULL ) THEN NULL
				WHEN ( AUS.REMOTE_USER != 'STAGING' ) THEN 1 ELSE 0 END ) AS ASSIGNED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 90 ) THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 46 AND 90) THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) < 46) THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 365) THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 181 AND 365 ) THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 151 AND 180 ) THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 121 AND 150 ) THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 91 AND 120 ) THEN 1 ELSE 0 END ) AS RED91 ,
      SUM( CASE WHEN ( ( IB.ID IS NOT NULL ) AND ( SFP.ID IS NULL ) AND ( SFH.ID IS NULL ) ) THEN 1 ELSE 0 END ) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.SOFTWARE_LPAR SL ON SL.CUSTOMER_ID = C.CUSTOMER_ID AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' AND SL.STATUS = 'ACTIVE'
      JOIN EAADMIN.HW_SW_COMPOSITE HSC ON SL.ID = HSC.SOFTWARE_LPAR_ID
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.ID = HSC.HARDWARE_LPAR_ID AND HL.STATUS = 'ACTIVE' AND HL.LPAR_STATUS != 'HWCOUNT'
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID AND H.STATUS = 'ACTIVE'
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      JOIN EAADMIN.INSTALLED_SOFTWARE IS ON SL.ID = IS.SOFTWARE_LPAR_ID AND IS.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.PRODUCT P ON P.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_VERSION MV ON MV.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_FEATURE MF ON MF.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_VERSION MFV ON MFV.ID = MF.VERSION_ID LEFT OUTER
      JOIN EAADMIN.IBM_BRAND IB ON IB.MANUFACTURER_ID = COALESCE ( P.MANUFACTURER_ID, MV.MANUFACTURER_ID, MFV.MANUFACTURER_ID ) LEFT OUTER
      JOIN EAADMIN.SCHEDULE_F SFP ON SFP.SOFTWARE_ID = IS.SOFTWARE_ID AND SFP.CUSTOMER_ID = SL.CUSTOMER_ID
					AND SFP.STATUS_ID = 2 AND SFP.LEVEL = 'PRODUCT' AND SFP.SCOPE_ID = 1 LEFT OUTER
      JOIN EAADMIN.SCHEDULE_F SFH ON SFH.SOFTWARE_ID = IS.SOFTWARE_ID AND SFH.CUSTOMER_ID = SL.CUSTOMER_ID
					AND SFH.STATUS_ID = 2 AND SFH.LEVEL = 'HOSTNAME' AND SFH.HOSTNAME = SL.NAME AND SFH.SCOPE_ID = 1 LEFT OUTER
      JOIN EAADMIN.ALERT_UNLICENSED_SW AUS ON AUS.INSTALLED_SOFTWARE_ID = IS.ID AND AUS.TYPE = 'IBM' AND AUS.OPEN = 1
      GROUP BY 'SWIBM' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'SWIBM' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4a: IBM SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWIBM' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4a: IBM SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWISVPR' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4b: PRIORITY ISV SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN ( AUS.REMOTE_USER IS NULL ) THEN NULL
				WHEN ( AUS.REMOTE_USER != 'STAGING' ) THEN 1 ELSE 0 END ) AS ASSIGNED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 90 ) THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 46 AND 90) THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) < 46) THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 365) THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 181 AND 365 ) THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 151 AND 180 ) THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 121 AND 150 ) THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 91 AND 120 ) THEN 1 ELSE 0 END ) AS RED91 ,
      SUM( CASE WHEN ( ( PIS.ID IS NOT NULL ) AND ( SFP.ID IS NULL ) AND ( SFH.ID IS NULL ) ) THEN 1 ELSE 0 END ) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.SOFTWARE_LPAR SL ON SL.CUSTOMER_ID = C.CUSTOMER_ID AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' AND SL.STATUS = 'ACTIVE'
      JOIN EAADMIN.HW_SW_COMPOSITE HSC ON SL.ID = HSC.SOFTWARE_LPAR_ID
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.ID = HSC.HARDWARE_LPAR_ID AND HL.STATUS = 'ACTIVE' AND HL.LPAR_STATUS != 'HWCOUNT'
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID AND H.STATUS = 'ACTIVE'
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      JOIN EAADMIN.INSTALLED_SOFTWARE IS ON SL.ID = IS.SOFTWARE_LPAR_ID AND IS.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.PRODUCT P ON P.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_VERSION MV ON MV.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_FEATURE MF ON MF.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_VERSION MFV ON MFV.ID = MF.VERSION_ID LEFT OUTER
      JOIN EAADMIN.PRIORITY_ISV_SW PIS ON PIS.MANUFACTURER_ID = COALESCE ( P.MANUFACTURER_ID, MV.MANUFACTURER_ID, MFV.MANUFACTURER_ID ) LEFT OUTER
      JOIN EAADMIN.SCHEDULE_F SFP ON SFP.SOFTWARE_ID = IS.SOFTWARE_ID AND SFP.CUSTOMER_ID = SL.CUSTOMER_ID
					AND SFP.STATUS_ID = 2 AND SFP.LEVEL = 'PRODUCT' AND SFP.SCOPE_ID = 1 LEFT OUTER
      JOIN EAADMIN.SCHEDULE_F SFH ON SFH.SOFTWARE_ID = IS.SOFTWARE_ID AND SFH.CUSTOMER_ID = SL.CUSTOMER_ID
					AND SFH.STATUS_ID = 2 AND SFH.LEVEL = 'HOSTNAME' AND SFH.HOSTNAME = SL.NAME AND SFH.SCOPE_ID = 1 LEFT OUTER
      JOIN EAADMIN.ALERT_UNLICENSED_SW AUS ON AUS.INSTALLED_SOFTWARE_ID = IS.ID AND AUS.TYPE = 'ISVPRIO' AND AUS.OPEN = 1
      WHERE ( ( ( PIS.LEVEL = 'GLOBAL' ) AND ( PIS.CUSTOMER_ID IS NULL ) ) OR
			  ( ( PIS.LEVEL = 'ACCOUNT' ) AND ( PIS.CUSTOMER_ID = SL.CUSTOMER_ID ) ) )
      GROUP BY 'SWISVPR' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'SWISVPR' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4b: PRIORITY ISV SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWISVPR' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4b: PRIORITY ISV SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL      
      SELECT
      'SWISVNPR' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4c: ISV SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END AS ASSET_TYPE ,
      SUM( CASE WHEN ( AUS.REMOTE_USER IS NULL ) THEN NULL
				WHEN ( AUS.REMOTE_USER != 'STAGING' ) THEN 1 ELSE 0 END ) AS ASSIGNED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 90 ) THEN 1 ELSE 0 END ) AS RED ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 46 AND 90) THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) < 46) THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) > 365) THEN 1 ELSE 0 END ) AS RED366 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 181 AND 365 ) THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 151 AND 180 ) THEN 1 ELSE 0 END ) AS RED151 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 121 AND 150 ) THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN ( DAYS(CURRENT TIMESTAMP) - DAYS(AUS.CREATION_TIME) BETWEEN 91 AND 120 ) THEN 1 ELSE 0 END ) AS RED91 ,
      SUM( CASE WHEN ( ( IB.ID IS NULL ) AND ( PIS.ID IS NULL ) AND ( SFP.ID IS NULL ) AND ( SFH.ID IS NULL ) ) THEN 1 ELSE 0 END ) AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.SOFTWARE_LPAR SL ON SL.CUSTOMER_ID = C.CUSTOMER_ID AND C.SW_LICENSE_MGMT = 'YES' AND C.STATUS = 'ACTIVE' AND SL.STATUS = 'ACTIVE'
      JOIN EAADMIN.HW_SW_COMPOSITE HSC ON SL.ID = HSC.SOFTWARE_LPAR_ID
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.ID = HSC.HARDWARE_LPAR_ID AND HL.STATUS = 'ACTIVE' AND HL.LPAR_STATUS != 'HWCOUNT'
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID AND H.STATUS = 'ACTIVE'
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      JOIN EAADMIN.INSTALLED_SOFTWARE IS ON SL.ID = IS.SOFTWARE_LPAR_ID AND IS.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.PRODUCT P ON P.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_VERSION MV ON MV.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_FEATURE MF ON MF.ID = IS.SOFTWARE_ID LEFT OUTER
      JOIN EAADMIN.MAINFRAME_VERSION MFV ON MFV.ID = MF.VERSION_ID LEFT OUTER
      JOIN EAADMIN.IBM_BRAND IB ON IB.MANUFACTURER_ID = COALESCE ( P.MANUFACTURER_ID, MV.MANUFACTURER_ID, MFV.MANUFACTURER_ID ) LEFT OUTER
      JOIN EAADMIN.PRIORITY_ISV_SW PIS ON PIS.MANUFACTURER_ID = COALESCE ( P.MANUFACTURER_ID, MV.MANUFACTURER_ID, MFV.MANUFACTURER_ID )
				AND ( ( ( PIS.LEVEL = 'GLOBAL' ) AND ( PIS.CUSTOMER_ID IS NULL ) ) OR
			  ( ( PIS.LEVEL = 'ACCOUNT' ) AND ( PIS.CUSTOMER_ID = SL.CUSTOMER_ID ) ) ) LEFT OUTER
      JOIN EAADMIN.SCHEDULE_F SFP ON SFP.SOFTWARE_ID = IS.SOFTWARE_ID AND SFP.CUSTOMER_ID = SL.CUSTOMER_ID
					AND SFP.STATUS_ID = 2 AND SFP.LEVEL = 'PRODUCT' AND SFP.SCOPE_ID = 1 LEFT OUTER
      JOIN EAADMIN.SCHEDULE_F SFH ON SFH.SOFTWARE_ID = IS.SOFTWARE_ID AND SFH.CUSTOMER_ID = SL.CUSTOMER_ID
					AND SFH.STATUS_ID = 2 AND SFH.LEVEL = 'HOSTNAME' AND SFH.HOSTNAME = SL.NAME AND SFH.SCOPE_ID = 1 LEFT OUTER
      JOIN EAADMIN.ALERT_UNLICENSED_SW AUS ON AUS.INSTALLED_SOFTWARE_ID = IS.ID AND AUS.TYPE IN ( 'ISV', 'ISVNOPRIO' ) AND AUS.OPEN = 1
      GROUP BY 'SWISVNPR' || CASE WHEN SL.CUSTOMER_ID IS NULL THEN '_NON-WORKSTATION_' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN '_NON-WORKSTATION_' ELSE '_WORKSTATION_' END || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID ,
      CASE WHEN SL.CUSTOMER_ID IS NULL THEN 'NON-WORKSTATION' WHEN MT.TYPE != 'WORKSTATION' OR MT.TYPE IS NULL THEN 'NON-WORKSTATION' ELSE MT.TYPE END
      UNION
      ALL
      SELECT
      'SWISVNPR' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4c: ISV SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'SWISVNPR' || '_WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM4c: ISV SW INSTANCES REVIEWED' AS DISPLAY_NAME ,
      'WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
      UNION
      ALL
      SELECT
      'HWCFGDTA' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      SUM( CASE WHEN AHC.REMOTE_USER IS NULL THEN NULL WHEN AHC.REMOTE_USER = 'STAGING' THEN 0 ELSE 1 END ) AS ASSIGNED ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) > 90 THEN 1 ELSE 0 END ) AS RED ,
      SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) BETWEEN 46 AND 90 THEN 1 ELSE 0 END ) AS YELLOW ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) < 46 THEN 1 ELSE 0 END ) AS GREEN ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) > 365 THEN 1 ELSE 0 END) AS RED366 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) BETWEEN 181 AND 365 THEN 1 ELSE 0 END ) AS RED181 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) BETWEEN 151 AND 180 THEN 1 ELSE 0 END) AS RED151 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) BETWEEN 121 AND 150 THEN 1 ELSE 0 END ) AS RED121 ,
      SUM( CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AHC.CREATION_TIME) BETWEEN 91 AND 120 THEN 1 ELSE 0 END) AS RED91 ,
      SUM( CASE WHEN ( H.HARDWARE_STATUS = 'ACTIVE' AND MT.TYPE != 'WORKSTATION' ) THEN 1 ELSE 0 END )
      AS ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      JOIN EAADMIN.HARDWARE_LPAR HL ON HL.CUSTOMER_ID = C.CUSTOMER_ID AND HL.STATUS = 'ACTIVE' AND C.STATUS = 'ACTIVE' AND C.SW_LICENSE_MGMT = 'YES'
      JOIN EAADMIN.HARDWARE H ON HL.HARDWARE_ID = H.ID AND H.STATUS = 'ACTIVE' LEFT OUTER
      JOIN EAADMIN.ALERT_HARDWARE_CFGDATA AHC ON AHC.HARDWARE_ID = H.ID  AND AHC.OPEN = 1 LEFT OUTER
      JOIN EAADMIN.MACHINE_TYPE MT ON H.MACHINE_TYPE_ID = MT.ID
      GROUP BY 'HWCFGDTA' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) ,
      C.CUSTOMER_ID
      UNION
      ALL
      SELECT
      'HWCFGDTA' || '_NON-WORKSTATION_' || CAST(C.CUSTOMER_ID AS CHAR(16)) AS ID ,
      C.CUSTOMER_ID AS CUSTOMER_ID ,
      'SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED' AS DISPLAY_NAME ,
      'NON-WORKSTATION' AS ASSET_TYPE ,
      0 as ASSIGNED ,
      0 as RED ,
      0 as YELLOW ,
      0 as GREEN ,
      0 as RED366 ,
      0 as RED181 ,
      0 as RED151 ,
      0 as RED121 ,
      0 as RED91 ,
      0 as ASSET_TOTAL
      FROM EAADMIN.CUSTOMER C
      WHERE C.SW_LICENSE_MGMT = 'YES'
      AND C.STATUS = 'ACTIVE'
   )
   AS T
)
DATA INITIALLY DEFERRED REFRESH DEFERRED ENABLE QUERY OPTIMIZATION MAINTAINED BY SYSTEM IN "MISC" INDEX IN "MISCINDEX"
;

ALTER TABLE "EAADMIN "."MQT_ALERT_REPORT" DEACTIVATE ROW ACCESS CONTROL;		
			
SET INTEGRITY FOR "EAADMIN"."MQT_ALERT_REPORT" IMMEDIATE CHECKED;		
		
GRANT CONTROL ON EAADMIN.MQT_ALERT_REPORT TO USER EAADMIN		
;		
GRANT REFERENCES ON EAADMIN.MQT_ALERT_REPORT TO GROUP TRAILPRD		
;		
GRANT SELECT ON EAADMIN.MQT_ALERT_REPORT TO GROUP TRAILPRD		
;		
GRANT REFERENCES ON EAADMIN.MQT_ALERT_REPORT TO GROUP TRAILUPD		
;		
GRANT SELECT ON EAADMIN.MQT_ALERT_REPORT TO GROUP TRAILUPD
;
