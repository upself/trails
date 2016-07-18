Drop view IS_ADMIN.V_INTEGRATED_SW;
create view IS_ADMIN.V_INTEGRATED_SW(sl_id, software_id, manufacturer_id,
software_category_id, software_name, level, status , manufacturer_name,
software_category_name, software_version, file_name,account_number,guid
) as (
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,ss.software_version ,ss.file_name ,cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw,eaadmin.manufacturer mf
,eaadmin.installed_signature isi ,eaadmin.software_signature ss
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb 
where sl.status = 'ACTIVE' and is.status='ACTIVE' and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and isi.installed_software_id = is.id 
and isi.software_signature_id = ss.software_signature_id and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
union all 
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,sf.map_software_version,sf.software_name ,cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw, eaadmin.manufacturer mf
,eaadmin.installed_filter isf ,eaadmin.software_filter sf 
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb
where sl.status = 'ACTIVE' and is.status='ACTIVE' and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and isf.installed_software_id = is.id 
and  isf.software_filter_id = sf.software_filter_id and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
union all 
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,scr.MAP_SOFTWARE_VERSION,scr.SOFTWARE_NAME ,cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw, eaadmin.manufacturer mf
,eaadmin.INSTALLED_SCRIPT isc ,eaadmin.SOFTWARE_SCRIPT scr
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb
where sl.status = 'ACTIVE' and is.status='ACTIVE' and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and isc.installed_software_id = is.id 
and  isc.SOFTWARE_SCRIPT_ID = scr.SOFTWARE_SCRIPT_ID and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
union all 
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,sa.version ,sa.sa_product,cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw, eaadmin.manufacturer mf
,eaadmin.installed_sa_product isa ,eaadmin.sa_product sa 
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb
where sl.status = 'ACTIVE' and is.status='ACTIVE' and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and isa.installed_software_id = is.id 
and  isa.sa_product_id = sa.id and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
union all 
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,CHAR(mv.version) ,'' ,cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw, eaadmin.manufacturer mf
,eaadmin.mainframe_version mv ,eaadmin.installed_tadz it
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb
where sl.status = 'ACTIVE' and is.status='ACTIVE' and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and it.installed_software_id = is.id 
and  it.MAINFRAME_FEATURE_ID = mv.id and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
union all 
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,CHAR(mv.version) ,'' ,cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw, eaadmin.manufacturer mf
,eaadmin.MAINFRAME_FEATURE mfe ,eaadmin.installed_tadz it,eaadmin.mainframe_version mv 
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb
where sl.status = 'ACTIVE' and is.status='ACTIVE' and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and it.installed_software_id = is.id 
and  it.MAINFRAME_FEATURE_ID = mfe.id and mfe.version_id = mv.id and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
union all 
select sl.id ,sw.software_id ,sw.manufacturer_id ,sw.software_category_id ,sw.software_name
,sw.level,sw.status,mf.name
,sc.software_category_name ,is.version ,'',cs.account_number
,kb.guid 
from eaadmin.software_lpar sl ,eaadmin.installed_software is,eaadmin.software sw,eaadmin.manufacturer mf
,eaadmin.software_category sc,eaadmin.customer cs,eaadmin.kb_definition kb 
where sl.status = 'ACTIVE' and is.status='ACTIVE' and is.discrepancy_type_id=2 and sl.id = is.software_lpar_id
and is.software_id = sw.software_id and sw.manufacturer_id = mf.id and sl.customer_id = cs.customer_id
and sc.software_category_id = sw.software_category_id 
);
GRANT SELECT ON TABLE IS_ADMIN.V_INTEGRATED_SW TO USER IS_ADMIN;
GRANT SELECT ON TABLE IS_ADMIN.V_INTEGRATED_SW TO USER EAADMIN;
GRANT SELECT ON TABLE IS_ADMIN.V_INTEGRATED_SW TO GROUP TRAILRPT ; 