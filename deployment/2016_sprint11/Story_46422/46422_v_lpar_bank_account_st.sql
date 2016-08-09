drop view EAADMIN.V_LPAR_BANK_ACCOUNT;

create view EAADMIN.V_LPAR_BANK_ACCOUNT
(
   id , software_lpar_id , bank_account_id
)
as
select
distinct concat(cast(a.id as char(32)) , cast(a.bank_account_id as char(32))) as id ,
a.id as software_lpar_id ,
a.bank_account_id as bank_account_id
from
(
   select
   b.id ,d.bank_account_id
   from EAADMIN.software_lpar b ,
   EAADMIN.installed_software c ,
   EAADMIN.installed_signature d
   where b.status = 'ACTIVE'
   and c.status = 'ACTIVE'
   and b.id = c.software_lpar_id
   and c.id = d.installed_software_id
   union
   all
   select
   b.id , d.bank_account_id
   from EAADMIN.software_lpar b ,
   EAADMIN.installed_software c ,
   EAADMIN.installed_filter d
   where b.status = 'ACTIVE'
   and c.status = 'ACTIVE'
   and b.id = c.software_lpar_id
   and c.id = d.installed_software_id
   union
   all
   select
   b.id , d.bank_account_id
   from EAADMIN.software_lpar b ,
   EAADMIN.installed_software c ,
   EAADMIN.installed_sa_product d
   where b.status = 'ACTIVE'
   and c.status = 'ACTIVE'
   and b.id = c.software_lpar_id
   and c.id = d.installed_software_id
   union
   all
   select
   b.id , d.bank_account_id
   from EAADMIN.software_lpar b ,
   EAADMIN.installed_software c ,
   EAADMIN.installed_tadz d
   where b.status = 'ACTIVE'
   and c.status = 'ACTIVE'
   and b.id = c.software_lpar_id
   and c.id = d.installed_software_id
   union
   all
   select
   b.id , d.bank_account_id
   from EAADMIN.software_lpar b ,
   EAADMIN.installed_software c ,
   EAADMIN.installed_script d
   where b.status = 'ACTIVE'
   and c.status = 'ACTIVE'
   and b.id = c.software_lpar_id
   and c.id = d.installed_software_id
   union
   all
   select
   b.id , d.bank_account_id
   from EAADMIN.software_lpar b ,
   EAADMIN.installed_software c ,
   EAADMIN.installed_vm_product d
   where b.status = 'ACTIVE'
   and c.status = 'ACTIVE'
   and b.id = c.software_lpar_id
   and c.id = d.installed_software_id
)
as a
;

GRANT SELECT ON TABLE "EAADMIN "."V_LPAR_BANK_ACCOUNT"          TO GROUP "TRAILRPT" ;       
GRANT SELECT ON TABLE "EAADMIN "."V_LPAR_BANK_ACCOUNT"      	TO USER eaadmin ;  