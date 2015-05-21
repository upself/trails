-- as usual, when recon rules change, the existing entities applicable to the change should be put into recon queue
-- the following query finds all installed softwares with existing auto-reconciles and not defined ScheduleF
-- those reconciles should, according to the new rules, be broken (and alerts open)

select sl.customer_id, is.id as installed_sw_id
	from ( ( ( ( ( eaadmin.installed_software is
				   join eaadmin.software_lpar sl on sl.id = is.software_lpar_id )
                   join eaadmin.software s on s.software_id = is.software_id )
			    join eaadmin.reconcile r on r.installed_software_id = is.id )
			    join eaadmin.reconcile_type rt on rt.id = r.reconcile_type_id )
                   left outer join eaadmin.schedule_f sf on sf.software_name = s.software_name and sf.customer_id = sl.customer_id and sf.status_id = 2 )
                   where rt.is_manual = 0 and sf.id is null
     with ur;
