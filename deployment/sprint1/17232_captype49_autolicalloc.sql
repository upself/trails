-- This isn't necessary to perform, the change of recon rules will still work!

-- However, when the recon rules change, we should probably put entities "elligible" for the new rules to recon queue.
-- In this case, it means a installed SW with machines having some CPU IFL value and open alerts, with applicable licenses
-- This query will help to find them

select c.customer_id, is.id as installed_sw_id
	from ( ( ( ( ( ( ( ( ( eaadmin.installed_software is
				   join eaadmin.software_lpar sl on sl.id = is.software_lpar_id )
                   join eaadmin.hw_sw_composite hsc on hsc.software_lpar_id = is.software_lpar_id )
                   join eaadmin.hardware_lpar hl on hl.id = hsc.hardware_lpar_id )
                   join eaadmin.hardware h on h.id = hl.hardware_id )
                   join eaadmin.software s on s.software_id = is.software_id )
                   join eaadmin.customer c on c.customer_id = sl.customer_id )
                   join eaadmin.schedule_f sf on sf.software_name = s.software_name )
                   left outer join eaadmin.alert_unlicensed_sw aus on is.id = aus.installed_software_id )
                   join eaadmin.license l on l.customer_id = c.customer_id )
                   where h.cpu_ifl is not null and aus.open = 1 and sf.customer_id = c.customer_id and l.cap_type = 49
     with ur;
