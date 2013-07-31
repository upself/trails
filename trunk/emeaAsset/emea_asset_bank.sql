connect to traherp user dbryson using apr10new;
set schema eaadmin;
export to /home/dbryson/asset_emea/bank_data.txt of del 
select distinct * from 
(
select software_lpar.id,account_number, customer_name, software_lpar.name, 
bank_account.name as bankname from
customer, software_lpar, installed_filter,installed_software,
bank_account
where
customer.customer_id = software_lpar.customer_id
and software_lpar.status = 'ACTIVE'
and installed_software.status = 'ACTIVE'
and bank_account.id = installed_filter.bank_account_id
and installed_software.software_lpar_id = software_lpar.id
and installed_filter.installed_software_id = installed_software.id
and customer.customer_id in 
(select customer_id from customer where country_code_id in (select id from 
eaadmin.country_code where region_id in (select id from eaadmin.region where 
geography_id = 2)))

union
select software_lpar.id, account_number, customer_name, software_lpar.name, 
bank_account.name as bankname from
customer, software_lpar, installed_sa_product,installed_software,
bank_account
where
customer.customer_id = software_lpar.customer_id
and software_lpar.status = 'ACTIVE'
and installed_software.status = 'ACTIVE'
and bank_account.id = installed_sa_product.bank_account_id
and installed_software.software_lpar_id = software_lpar.id
and installed_sa_product.installed_software_id = installed_software.id
and customer.customer_id in 
(select customer_id from customer where country_code_id in (select id from 
eaadmin.country_code where region_id in (select id from eaadmin.region where 
geography_id = 2)))

union
select software_lpar.id, account_number, customer_name, software_lpar.name, 
bank_account.name as bankname from
customer, software_lpar, installed_signature,installed_software,
bank_account
where
customer.customer_id = software_lpar.customer_id
and software_lpar.status = 'ACTIVE'
and installed_software.status = 'ACTIVE'
and bank_account.id = installed_signature.bank_account_id
and installed_software.software_lpar_id = software_lpar.id
and installed_signature.installed_software_id = installed_software.id
and customer.customer_id in 
(select customer_id from customer where country_code_id in (select id from 
eaadmin.country_code where region_id in (select id from eaadmin.region where 
geography_id = 2)))
)
as t 
with ur;
