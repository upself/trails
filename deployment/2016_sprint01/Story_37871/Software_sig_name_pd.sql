drop table EAADMIN.v_installed_software_mqt;

ALTER TABLE "EAADMIN"."SOFTWARE_SIGNATURE" alter column FILE_NAME set data type VARCHAR(255)
;
ALTER TABLE "TRAILSPD_CD"."SOFTWARE_SIGNATURE" alter column FILE_NAME set data type VARCHAR(255)
;
ALTER TABLE "TRAILSPD_CC"."SOFTWARE_SIGNATURE" alter column FILE_NAME set data type VARCHAR(255)
;
ALTER TABLE "EAADMIN"."SOFTWARE_SIGNATURE_H" alter column FILE_NAME set data type VARCHAR(255)
;
ALTER TABLE "TRAILSPD_CD"."SOFTWARE_SIGNATURE_H" alter column FILE_NAME set data type VARCHAR(255)
;
ALTER TABLE "TRAILSPD_CC"."SOFTWARE_SIGNATURE_H" alter column FILE_NAME set data type VARCHAR(255)
;
REORG TABLE EAADMIN.SOFTWARE_SIGNATURE;
REORG TABLE TRAILSPD_CD.SOFTWARE_SIGNATURE;
REORG TABLE TRAILSPD_CC.SOFTWARE_SIGNATURE;
REORG TABLE EAADMIN.SOFTWARE_SIGNATURE_H;
REORG TABLE TRAILSPD_CD.SOFTWARE_SIGNATURE_H;
REORG TABLE TRAILSPD_CC.SOFTWARE_SIGNATURE_H;


create summary table eaadmin.v_installed_software_mqt as (select a.id as software_lpar_id ,a.customer_id as customer_id ,a.name as nodename ,a.model as model ,a.bios_serial ,a.processor_count as processor_count ,a.scantime as scantime ,a.os_minor_vers as os_minor_vers,a.os_sub_vers as os_sub_vers ,a.acquisition_time as acquisition_time ,a.status as software_lpar_status ,b.id as installed_software_id ,b.software_id as software_id ,b.users as users ,b.processor_count as inst_processor_count ,b.authenticated as authenticated ,b.status as inst_status ,b.discrepancy_type_id as discrepancy_type_id ,c.id as installed_product_id,c.software_filter_id as product_id ,c.bank_account_id as bank_account_id ,d.map_software_version as version ,'FILTER' as product_type from EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_filter c ,EAADMIN.software_filter d where a.id = b.software_lpar_id and b.id = c.installed_software_id and c.software_filter_id = d.software_filter_id union all select a.id as software_lpar_id ,a.customer_id as customer_id ,a.name as nodename ,a.model as model ,a.bios_serial ,a.processor_count as processor_count ,a.scantime as scantime ,a.os_minor_vers as os_minor_vers,a.os_sub_vers as os_sub_vers ,a.acquisition_time as acquisition_time ,a.status as software_lpar_status ,b.id as installed_software_id ,b.software_id as software_id ,b.users as users ,b.processor_count as inst_processor_count ,b.authenticated as authenticated ,b.status as inst_status ,b.discrepancy_type_id as discrepancy_type_id ,c.id as installed_product_id,c.software_signature_id as product_id ,c.bank_account_id as bank_account_id ,d.software_version as version ,'SIGNATURE' as product_type from EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_signature c ,EAADMIN.software_signature d where a.id = b.software_lpar_id and b.id = c.installed_software_id and c.software_signature_id = d.software_signature_id union all select a.id as software_lpar_id ,a.customer_id as customer_id ,a.name as nodename ,a.model as model ,a.bios_serial ,a.processor_count as processor_count ,a.scantime as scantime ,a.os_minor_vers as os_minor_vers,a.os_sub_vers as os_sub_vers ,a.acquisition_time as acquisition_time ,a.status as software_lpar_status ,b.id as installed_software_id ,b.software_id as software_id ,b.users as users ,b.processor_count as inst_processor_count ,b.authenticated as authenticated ,b.status as inst_status ,b.discrepancy_type_id as discrepancy_type_id ,c.id as installed_product_id,c.sa_product_id as product_id ,c.bank_account_id as bank_account_id ,d.version as version ,'SOFTAUDIT' as product_type from EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_sa_product c ,EAADMIN.sa_product d where a.id = b.software_lpar_id and b.id = c.installed_software_id and c.sa_product_id = d.id union all select a.id as software_lpar_id ,a.customer_id as customer_id ,a.name as nodename ,a.model as model ,a.bios_serial ,a.processor_count as processor_count ,a.scantime as scantime ,a.os_minor_vers as os_minor_vers,a.os_sub_vers as os_sub_vers ,a.acquisition_time as acquisition_time ,a.status as software_lpar_status ,b.id as installed_software_id ,b.software_id as software_id ,b.users as users ,b.processor_count as inst_processor_count ,b.authenticated as authenticated ,b.status as inst_status ,b.discrepancy_type_id as discrepancy_type_id ,c.id as installed_product_id,c.mainframe_feature_id as product_id ,c.bank_account_id as bank_account_id ,CHAR(d.version) as version ,'TADZ' as product_type from EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_tadz c , EAADMIN.MAINFRAME_VERSION d where a.id = b.software_lpar_id and b.id = c.installed_software_id and c.MAINFRAME_FEATURE_ID=d.id union all select a.id as software_lpar_id ,a.customer_id as customer_id ,a.name as nodename ,a.model as model ,a.bios_serial ,a.processor_count as processor_count ,a.scantime as scantime ,a.os_minor_vers as os_minor_vers,a.os_sub_vers as os_sub_vers ,a.acquisition_time as acquisition_time ,a.status as software_lpar_status ,b.id as installed_software_id ,b.software_id as software_id ,b.users as users ,b.processor_count as inst_processor_count ,b.authenticated as authenticated ,b.status as inst_status ,b.discrepancy_type_id as discrepancy_type_id ,c.id as installed_product_id,c.mainframe_feature_id as product_id ,c.bank_account_id as bank_account_id ,CHAR(d.version) as version ,'TADZ' as product_type from EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_tadz c ,EAADMIN.MAINFRAME_VERSION d , EAADMIN.MAINFRAME_FEATURE e where a.id = b.software_lpar_id and b.id = c.installed_software_id and c.MAINFRAME_FEATURE_ID=e.id and e.version_id=d.id union all select a.id as software_lpar_id ,a.customer_id as customer_id ,a.name as nodename ,a.model as model ,a.bios_serial ,a.processor_count as processor_count ,a.scantime as scantime ,a.os_minor_vers as os_minor_vers,a.os_sub_vers as os_sub_vers ,a.acquisition_time as acquisition_time ,a.status as software_lpar_status ,b.id as installed_software_id ,b.software_id as software_id ,b.users as users ,b.processor_count as inst_processor_count ,b.authenticated as authenticated ,b.status as inst_status ,b.discrepancy_type_id as discrepancy_type_id ,0 as installed_product_id,0 as product_id ,0 as bank_account_id ,'MANUAL' as version ,'MANUAL' as product_type from EAADMIN.software_lpar a ,EAADMIN.installed_software b where a.id = b.software_lpar_id and not exists( select 1 from EAADMIN.installed_filter c where c.installed_software_id = b.id ) and not exists( select 1 from EAADMIN.installed_signature d where d.installed_software_id = b.id ) and not exists( select 1 from EAADMIN.installed_sa_product e where e.installed_software_id = b.id ) and not exists( select 1 from EAADMIN.installed_tadz f where f.installed_software_id = b.id )) DATA INITIALLY DEFERRED REFRESH DEFERRED ENABLE QUERY OPTIMIZATION MAINTAINED BY SYSTEM IN "USERSPACE1" ;


ALTER TABLE "EAADMIN "."V_INSTALLED_SOFTWARE_MQT" DEACTIVATE ROW ACCESS CONTROL;



grant control on EAADMIN.v_installed_software_mqt to user eaadmin;

grant select on EAADMIN.v_installed_software_mqt to user eaadmin;
GRANT SELECT ON eaadmin.v_installed_software_mqt TO GROUP TRAILPRD
;
GRANT SELECT ON eaadmin.v_installed_software_mqt TO GROUP TRAILUPD
;

