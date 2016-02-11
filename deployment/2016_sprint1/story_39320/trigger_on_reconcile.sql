--execute the command by 
--db2 -td@ -f trigger_on_reconcile.sql 

DROP TRIGGER eaadmin.update_reconcile_type;

CREATE TRIGGER eaadmin.update_reconcile_type AFTER
UPDATE OF RECONCILE_TYPE_ID ON RECONCILE
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW MODE DB2SQL
WHEN (old_row.reconcile_type_id = 5 AND new_row.reconcile_type_id <> 5)

BEGIN ATOMIC
    DECLARE rid INT DEFAULT 0;
    
	SET rid = (select id 
	    from scarlet_reconcile where id = old_row.id);
	    
	    select sl.customer_id,'TRIGGER:update_reconcile_type', 'LICENSING', is.id, current timestamp
	    from reconcile r, installed_software is, software_lpar sl
	    where r.installed_software_id  = is.id
	    and is.software_lpar_id  = sl.id
	    and r.id  = rid;

	
	IF rid <> 0 OR rid <> null THEN 
	 delete from scarlet_reconcile where id = rid;
	 
	 insert into recon_installed_sw (customer_id, remote_user,action, installed_software_id,record_time)
	 select sl.customer_id,'TRIGGER:update_reconcile_type', 'LICENSING', is.id, current timestamp
	 from reconcile r, installed_software is, software_lpar sl
	 where r.installed_software_id  = is.id
	 and is.software_lpar_id  = sl.id
	 and r.id  = rid;
	 
	END IF;
END
@