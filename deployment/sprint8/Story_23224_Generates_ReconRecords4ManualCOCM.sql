--The following sql is used to add all the manual COCM reconcile related installed softwares into recon queue

insert into recon_installed_sw(customer_id,installed_software_id,action, remote_user, record_time)
select sl.customer_id, is.id, 'UPDATE', 'STORY_23224', current timestamp
from installed_software is
join reconcile recon on is.id = recon.installed_software_id
join reconcile_type recon_type on recon.reconcile_type_id = recon_type.id
join software_lpar sl on sl.id = is.software_lpar_id
where
 recon.reconcile_type_id = 2;