alter table eaadmin.software_lpar alter column OS_INST_DATE set data type TIMESTAMP;
ALTER TABLE "EAADMIN"."HARDWARE_LPAR" ADD COLUMN VCPU DECIMAL(4 , 0) ;
reorg table eaadmin.software_lpar use TEMPSPACE1;
REORG TABLE EAADMIN.HARDWARE_LPAR use TEMPSPACE1;