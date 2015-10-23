--License Primary Component <> Alert Component and recon type id= 5 (ALA)
insert into scarlet_reconcile (id, last_validate_time)
select unique (reconcile.id), current_timestamp
from eaadmin.reconcile reconcile
inner join eaadmin.installed_software installed_software on
reconcile.installed_software_id = installed_software.id
inner join eaadmin.reconcile_used_license reconcile_used_license
on reconcile.id = reconcile_used_license.reconcile_id
inner join eaadmin.used_license used_license on
reconcile_used_license.used_license_id = used_license.id
inner join eaadmin.license_sw_map map on
used_license.license_id = map.license_id
where map.software_id <> installed_software.software_id
and reconcile.reconcile_type_id = 5
