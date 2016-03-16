Drop view EAADMIN.v_installed_software;
create view EAADMIN.v_installed_software ( software_lpar_id ,customer_id
,nodename ,model ,bios_serial , sysplex, processor_count ,scantime ,os_minor_vers
,os_sub_vers ,acquisition_time ,software_lpar_status ,os_inst_date ,installed_software_id
,software_id ,users ,inst_processor_count ,authenticated ,inst_status ,discrepancy_type_id
,installed_product_id ,product_id ,bank_account_id ,version ,product_type
) as select a.id ,a.customer_id ,a.name ,a.model ,a.bios_serial ,a.sysplex ,a.processor_count
,a.scantime ,a.os_minor_vers ,a.os_sub_vers ,a.acquisition_time ,a.status
,a.os_inst_date ,b.id ,b.software_id ,b.users ,b.processor_count ,b.authenticated
,b.status ,b.discrepancy_type_id ,c.id ,c.software_filter_id ,c.bank_account_id
,d.map_software_version ,'FILTER' from EAADMIN.software_lpar a ,EAADMIN.installed_software
b ,EAADMIN.installed_filter c ,EAADMIN.software_filter d where a.id = b.software_lpar_id
and b.id = c.installed_software_id and c.software_filter_id = d.software_filter_id
union all select a.id ,a.customer_id ,a.name ,a.model ,a.bios_serial ,a.sysplex ,a.processor_count
,a.scantime ,a.os_minor_vers ,a.os_sub_vers ,a.acquisition_time ,a.status
,a.os_inst_date ,b.id ,b.software_id ,b.users ,b.processor_count ,b.authenticated
,b.status ,b.discrepancy_type_id ,c.id ,c.software_signature_id ,c.bank_account_id
,d.software_version ,'SIGNATURE' from EAADMIN.software_lpar a ,EAADMIN.installed_software
b ,EAADMIN.installed_signature c ,EAADMIN.software_signature d where a.id
= b.software_lpar_id and b.id = c.installed_software_id and c.software_signature_id
= d.software_signature_id union all select a.id ,a.customer_id ,a.name
,a.model ,a.bios_serial ,a.sysplex ,a.processor_count ,a.scantime ,a.os_minor_vers
,a.os_sub_vers ,a.acquisition_time ,a.status ,a.os_inst_date ,b.id ,b.software_id
,b.users ,b.processor_count ,b.authenticated ,b.status ,b.discrepancy_type_id
,c.id ,c.sa_product_id ,c.bank_account_id ,d.version ,'SOFTAUDIT' from
EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_sa_product
c ,EAADMIN.sa_product d where a.id = b.software_lpar_id and b.id = c.installed_software_id
and c.sa_product_id = d.id union all select a.id ,a.customer_id ,a.name
,a.model ,a.bios_serial ,a.sysplex ,a.processor_count ,a.scantime ,a.os_minor_vers
,a.os_sub_vers ,a.acquisition_time ,a.status ,a.os_inst_date ,b.id ,b.software_id
,b.users ,b.processor_count ,b.authenticated ,b.status ,b.discrepancy_type_id
,c.id ,c.mainframe_feature_id ,c.bank_account_id ,CHAR(d.version),'TADZ'
from EAADMIN.software_lpar a ,EAADMIN.installed_software b ,EAADMIN.installed_tadz
c , EAADMIN.MAINFRAME_VERSION d where a.id = b.software_lpar_id and b.id
= c.installed_software_id and c.MAINFRAME_FEATURE_ID=d.id union all select
a.id ,a.customer_id ,a.name ,a.model ,a.bios_serial ,a.sysplex ,a.processor_count
,a.scantime ,a.os_minor_vers ,a.os_sub_vers ,a.acquisition_time ,a.status
,a.os_inst_date ,b.id ,b.software_id ,b.users ,b.processor_count ,b.authenticated
,b.status ,b.discrepancy_type_id ,c.id ,c.mainframe_feature_id ,c.bank_account_id
,CHAR(d.version),'TADZ' from EAADMIN.software_lpar a ,EAADMIN.installed_software
b ,EAADMIN.installed_tadz c ,EAADMIN.MAINFRAME_VERSION d , EAADMIN.MAINFRAME_FEATURE
e where a.id = b.software_lpar_id and b.id = c.installed_software_id and
c.MAINFRAME_FEATURE_ID=e.id and e.version_id=d.id union all select a.id
,a.customer_id ,a.name ,a.model ,a.bios_serial ,a.sysplex ,a.processor_count ,a.scantime
,a.os_minor_vers ,a.os_sub_vers ,a.acquisition_time ,a.status ,a.os_inst_date
,b.id ,b.software_id ,b.users ,b.processor_count ,b.authenticated ,b.status
,b.discrepancy_type_id ,0 ,0 ,0 ,'MANUAL' ,'MANUAL' from EAADMIN.software_lpar
a ,EAADMIN.installed_software b where a.id = b.software_lpar_id and not
exists ( select 1 from EAADMIN.installed_filter c where c.installed_software_id
= b.id ) and not exists( select 1 from EAADMIN.installed_signature d where
d.installed_software_id = b.id ) and not exists( select 1 from EAADMIN.installed_sa_product
e where e.installed_software_id = b.id ) and not exists( select 1 from
EAADMIN.installed_tadz f where f.installed_software_id = b.id ) with ur;

grant control on EAADMIN.v_installed_software to user eaadmin;

grant select on EAADMIN.v_installed_software to user eaadmin;
GRANT SELECT ON eaadmin.v_installed_software TO GROUP TRAILPRD
;
GRANT SELECT ON eaadmin.v_installed_software TO GROUP TRAILUPD
;