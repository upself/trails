CREATE VIEW EAADMIN.V_RECON_INVENTORY_QUEUE( PK , ID , FK , CUSTOMER_ID ,ACTION ,TABLE,REMOTE_USER ,RECORD_TIME ) 
AS SELECT 'RECON_HARDWARE' || ACTION || CAST(ID AS CHAR(16)) ,ID ,HARDWARE_ID ,CUSTOMER_ID ,ACTION ,'RECON_HARDWARE' ,REMOTE_USER,RECORD_TIME FROM EAADMIN.RECON_HARDWARE 
UNION ALL 
SELECT 'RECON_HW_LPAR'|| ACTION || CAST(ID AS CHAR(16)) ,ID , HARDWARE_LPAR_ID ,CUSTOMER_ID ,ACTION,'RECON_HW_LPAR' ,REMOTE_USER ,RECORD_TIME FROM EAADMIN.RECON_HW_LPAR 
UNION ALL
SELECT 'RECON_SW_LPAR' || ACTION || CAST(ID AS CHAR(16)) ,ID ,SOFTWARE_LPAR_ID,CUSTOMER_ID ,ACTION ,'RECON_SW_LPAR' ,REMOTE_USER ,RECORD_TIME FROM EAADMIN.RECON_SW_LPAR
UNION ALL 
SELECT 'RECON_INSTALLED_SW' || ACTION || CAST(ID AS CHAR(16)),ID ,INSTALLED_SOFTWARE_ID ,CUSTOMER_ID ,ACTION ,'RECON_INSTALLED_SW' ,REMOTE_USER,RECORD_TIME FROM EAADMIN.RECON_INSTALLED_SW WHERE ACTION <> 'LICENSING'
UNION ALL 
SELECT 'RECON_CUSTOMER' || ACTION || CAST(ID AS CHAR(16)) ,ID,CUSTOMER_ID ,CUSTOMER_ID ,ACTION ,'RECON_CUSTOMER' ,REMOTE_USER ,RECORD_TIME FROM EAADMIN.RECON_CUSTOMER 
UNION ALL 
SELECT 'RECON_LICENSE' || ACTION|| CAST(ID AS CHAR(16)) ,ID ,LICENSE_ID ,CUSTOMER_ID ,ACTION ,'RECON_LICENSE',REMOTE_USER ,RECORD_TIME FROM EAADMIN.RECON_LICENSE WHERE ACTION = 'DELETE'
UNION ALL 
SELECT 'RECON_CUSTOMER_SW'|| ACTION || CAST(ID AS CHAR(16)) ,ID ,SOFTWARE_ID ,CUSTOMER_ID ,ACTION,'RECON_CUSTOMER_SW' ,REMOTE_USER ,RECORD_TIME FROM EAADMIN.RECON_CUSTOMER_SW;