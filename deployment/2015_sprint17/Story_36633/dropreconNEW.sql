-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_CUSTOMER;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_CUSTOMER'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_CUSTOMER_LOG;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_CUSTOMER_LOG'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_CUSTOMER_SW;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_CUSTOMER_SW'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_HARDWARE;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_HARDWARE'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_HS_COMPOSITE;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_HS_COMPOSITE'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_HW_LPAR;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_HW_LPAR'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_INSTALLED_SW;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_INSTALLED_SW'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_LICENSE;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_LICENSE'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_PVU;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_PVU'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_SOFTWARE;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_SOFTWARE'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


-- CONNECT TO TRAILSPD USER XXXX USING XXXX ;


DROP TABLE TRAILSPD_CC.RECON_SW_LPAR;


DELETE FROM NEWASN.IBMSNAP_REGISTER WHERE SOURCE_OWNER = 'EAADMIN' AND SOURCE_TABLE = 'RECON_SW_LPAR'  AND SOURCE_VIEW_QUAL = 0;


-- COMMIT;


