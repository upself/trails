drop view EAADMIN.V_EMEA_BANK;

/*
create view EAADMIN.V_EMEA_BANK as
select
sl.id as software_lpar_id ,b.name bank_name
from eaadmin.geography g ,
eaadmin.region r ,
eaadmin.country_code cc ,
EAADMIN.customer c ,
EAADMIN.software_lpar sl ,
EAADMIN.installed_software is ,
EAADMIN.installed_signature isig ,
EAADMIN.bank_account b
where g.name = 'EMEA'
and g.id = r.geography_id
and r.id = cc.region_id
and cc.id = c.country_code_id
and c.customer_id = sl.customer_id
and sl.id = is.software_lpar_id
and sl.status = 'ACTIVE'
and is.id = isig.installed_software_id
and is.status = 'ACTIVE'
and isig.bank_account_id = b.id
union
select
sl.id as software_lpar_id , b.name bank_name
from eaadmin.geography g ,
eaadmin.region r ,
eaadmin.country_code cc ,
EAADMIN.customer c ,
EAADMIN.software_lpar sl ,
EAADMIN.installed_software is ,
EAADMIN.installed_filter ifil ,
EAADMIN.bank_account b
where g.name = 'EMEA'
and g.id = r.geography_id
and r.id = cc.region_id
and cc.id = c.country_code_id
and c.customer_id = sl.customer_id
and sl.id = is.software_lpar_id
and sl.status = 'ACTIVE'
and is.id = ifil.installed_software_id
and is.status = 'ACTIVE'
and ifil.bank_account_id = b.id
union
select
sl.id as software_lpar_id , b.name bank_name
from eaadmin.geography g ,
eaadmin.region r ,
eaadmin.country_code cc ,
EAADMIN.customer c ,
EAADMIN.software_lpar sl ,
EAADMIN.installed_software is ,
EAADMIN.installed_sa_product isp ,
EAADMIN.bank_account b
where g.name = 'EMEA'
and g.id = r.geography_id
and r.id = cc.region_id
and cc.id = c.country_code_id
and c.customer_id = sl.customer_id
and sl.id = is.software_lpar_id
and sl.status = 'ACTIVE'
and is.id = isp.installed_software_id
and is.status = 'ACTIVE'
and isp.bank_account_id = b.id
union
select
sl.id as software_lpar_id , b.name bank_name
from eaadmin.geography g ,
eaadmin.region r ,
eaadmin.country_code cc ,
EAADMIN.customer c ,
EAADMIN.software_lpar sl ,
EAADMIN.installed_software is ,
EAADMIN.installed_tadz itd ,
EAADMIN.bank_account b
where g.name = 'EMEA'
and g.id = r.geography_id
and r.id = cc.region_id
and cc.id = c.country_code_id
and c.customer_id = sl.customer_id
and sl.id = is.software_lpar_id
and sl.status = 'ACTIVE'
and is.id = itd.installed_software_id
and is.status = 'ACTIVE'
and itd.bank_account_id = b.id
union
select
sl.id as software_lpar_id , b.name bank_name
from eaadmin.geography g ,
eaadmin.region r ,
eaadmin.country_code cc ,
EAADMIN.customer c ,
EAADMIN.software_lpar sl ,
EAADMIN.installed_software is ,
EAADMIN.installed_script iscr ,
EAADMIN.bank_account b
where g.name = 'EMEA'
and g.id = r.geography_id
and r.id = cc.region_id
and cc.id = c.country_code_id
and c.customer_id = sl.customer_id
and sl.id = is.software_lpar_id
and sl.status = 'ACTIVE'
and is.id = iscr.installed_software_id
and is.status = 'ACTIVE'
and iscr.bank_account_id = b.id
;

GRANT SELECT  ON EAADMIN.V_EMEA_BANK to USER  EAADMIN;
GRANT SELECT  ON EAADMIN.V_EMEA_BANK TO GROUP TRAILPRD;
GRANT SELECT  ON EAADMIN.V_EMEA_BANK TO GROUP TRAILUPD;
*/

