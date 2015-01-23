drop view eaadmin.software;

create view eaadmin.software
(
   manufacturer_id,
   software_category_id,
   software_id,
   software_name,
   version,
   priority,
   level,
   type,
   change_justification,
   comments,
   remote_user,
   record_time,
   status,
   vendor_managed,
   product_role,
   pid
) 
as
(
select
	p.manufacturer_id
	,pi.software_category_id
	,p.id
	,siP.name
	,cast(null as varchar(64))
	,pi.priority as priority
	,case when pi.licensable = 1 then 'LICENSABLE' else 'UN-LICENSABLE' end
	,case when pi.software_category_id = 1051 then 'O' else 'A' end
	,'SWKBT'
	,'SW_PRODUCT'
	,'SWKBT'	
	,kbP.modification_time as record_time
	,case when kbP.deleted = 1 then 'INACTIVE' else 'ACTIVE' end
	,case when upper(kbP.custom_2) = 'TRUE' then 1 else 0 end
	,case when siP.product_role is null then 'SOFTWARE_PRODUCT' else siP.product_role end
	,cast(null as varchar(32))
from eaadmin.product p
		join eaadmin.product_info pi on pi.id=p.id
		join eaadmin.software_item siP on siP.id=p.id
		join eaadmin.kb_definition kbP on kbP.id=p.id

union all

select
	mv.manufacturer_id
	,mvpi.software_category_id
	,mv.id
	,siP.name || ' - ' || siMV.name || ' - V'|| RTRIM(CAST(mv.version AS CHAR(64) ))
	,RTRIM(CAST(mv.version AS CHAR(64) ))
	,mvpi.priority as priority
	,case when mvpi.licensable = 1 then 'LICENSABLE' else 'UN-LICENSABLE' end
	,case when mvpi.software_category_id = 1051 then 'O' else 'A' end
	,'TADZ'
	,'MAINFRAME_VERSION'
	,'TADZ'	
	,kbMV.modification_time
	,case when kbMV.deleted = 1 then 'INACTIVE' else 'ACTIVE' end
	,case when upper(kbMV.custom_2) = 'TRUE' then 1 else 0 end
	,case when siMV.product_role is null then 'SOFTWARE_PRODUCT' else siMV.product_role end
	,pidMV.pid
from eaadmin.mainframe_version mv
		join eaadmin.software_item siMV on siMV.id=mv.id
		join eaadmin.software_item siP on siP.id=mv.product_id
		join eaadmin.kb_definition kbMV on kbMV.id=mv.id
		join eaadmin.product_info mvpi on mvpi.id=mv.id
		left outer join eaadmin.software_item_pid sipMV on sipMV.software_item_id = siMV.id
		left outer join eaadmin.pid pidMV on pidMV.id = sipMV.pid_id

union all

select
	mv.manufacturer_id
	,mfpi.software_category_id
	,mf.id
	,siP.name || ' - ' || siMF.name || ' - V' || RTRIM(CAST(mv.version AS CHAR(64) ))
	,RTRIM(CAST(mv.version AS CHAR(64) ))
	,mfpi.priority as priority
	,case when mfpi.licensable = 1 then 'LICENSABLE' else 'UN-LICENSABLE' end
	,case when mfpi.software_category_id = 1051 then 'O' else 'A' end
	,'TADZ'
	,'MAINFRAME_FEATURE'
	,'TADZ'	
	,kbMF.modification_time as record_time
	,case when kbMF.deleted = 1 then 'INACTIVE' else 'ACTIVE' end as status
	,case when upper(kbMF.custom_2) = 'TRUE' then 1 else 0 end as vendor_managed
	,case when siMF.product_role is null then 'SOFTWARE_PRODUCT' else siMF.product_role end
	,pidMV.pid
from eaadmin.mainframe_feature mf
		join eaadmin.mainframe_version mv on mf.version_id=mv.id
		join eaadmin.software_item siMF on siMF.id=mf.id
		join eaadmin.software_item siP on siP.id=mv.product_id
		join eaadmin.kb_definition kbMF on kbMF.id=mf.id
		join eaadmin.product_info mfpi on mfpi.id=mf.id
		left outer join eaadmin.software_item_pid sipMV on sipMV.software_item_id = mv.id
		left outer join eaadmin.pid pidMV on pidMV.id = sipMV.pid_id
);

GRANT SELECT ON EAADMIN.SOFTWARE TO GROUP TRAILRPT;