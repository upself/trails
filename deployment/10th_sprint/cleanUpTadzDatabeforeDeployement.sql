---set all tadz installed_softwares (installed_software with reference from installed_tadz not referenced from mainframe_feature) to status 'TRANSITION' --
update eaadmin.installed_software is set is.status='TRANSITION' where exists (select 1 from installed_tadz it where it.installed_software_id=is.id);

---add to the recon engine (all with status 'TRANSITION')----
insert into eaadmin.recon_installed_sw (CUSTOMER_ID,INSTALLED_SOFTWARE_ID,ACTION,REMOTE_USER,RECORD_TIME) SELECT sl.customer_id, is.id ,'UPDATE','zhysz@cn.ibm.com',CURRENT TIMESTAMP  from eaadmin.installed_software is join eaadmin.software_lpar sl on is.software_lpar_id=sl.id where is.status='TRANSITION' ;

---set status to 'INACTIVE' where status = 'TRANSITION'-----
update eaadmin.installed_software is set is.status='INACTIVE' where is.status = 'TRANSITION' ;