-- This will put out a list of customer IDs and iSW IDs, that have  license reconciles with customers, whose pool relationships have been deleted
-- and are no longer valid.

select c.account_number, is.id as installed_sw_id, r.id as reconcile_id
	from ( ( ( ( ( ( ( ( ( ( ( ( eaadmin.installed_software is
				   join eaadmin.software_lpar sl on sl.id = is.software_lpar_id )
                   join eaadmin.hw_sw_composite hsc on hsc.software_lpar_id = is.software_lpar_id )
                   join eaadmin.hardware_lpar hl on hl.id = hsc.hardware_lpar_id )
                   join eaadmin.hardware h on h.id = hl.hardware_id )
                   join eaadmin.software s on s.software_id = is.software_id )
                   join eaadmin.customer c on c.customer_id = sl.customer_id )
                   join eaadmin.schedule_f sf on sf.software_name = s.software_name and sf.customer_id = c.customer_id and sf.status_id = 2 )
                   join eaadmin.reconcile r on r.installed_software_id = is.id )
                   join eaadmin.reconcile_used_license rul on rul.reconcile_id = r.id )
                   join eaadmin.used_license ul on ul.id = rul.used_license_id )
                   join eaadmin.license l on l.id = ul.license_id )
                   join eaadmin.account_pool ap on ap.member_account_id = sl.customer_id and ap.master_account_id = l.customer_id )
                   where r.reconcile_type_id in ( 1, 5 ) and ap.logical_delete_ind = 1
     with ur;

-- For each each customer id "$C" and ins. SW id "$I", run the following command:

insert into recon_installed_sw (customer_id, installed_software_id, action, remote_user, record_time) values ( $C, $I, 'UPDATE', 'myyysha', '2015-03-16 07:30:00' );
