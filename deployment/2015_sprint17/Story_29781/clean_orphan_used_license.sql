--clean the orphan used license which inroduced by the defect of MLA.
delete from used_license ul 
where not exists
(select 1 from reconcile_used_license rul where rul.used_license_id = ul.id )
