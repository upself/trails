---set all tadz installed_softwares (installed_software with reference from installed_tadz not referenced from mainframe_feature) to status 'TRANSITION' -- run multiple times-----
update eaadmin.installed_software is set is.status='TRANSITION' where is.id in (select iss.id from eaadmin.installed_tadz it join eaadmin.installed_software iss on it.installed_software_id=iss.id where iss.status!='TRANSITION' and status!='INACTIVE'  fetch first 50000 row only )
;
---add to the recon engine (all with status 'TRANSITION')----
insert into eaadmin.recon_installed_sw (CUSTOMER_ID,INSTALLED_SOFTWARE_ID,ACTION,REMOTE_USER,RECORD_TIME) SELECT sl.customer_id, is.id ,'UPDATE','zhysz@cn.ibm.com',CURRENT TIMESTAMP  from eaadmin.installed_software is join eaadmin.software_lpar sl on is.software_lpar_id=sl.id where is.status='TRANSITION' ;

---set status to 'INACTIVE' where status = 'TRANSITION'----- run multiple times-----
update eaadmin.installed_software is set is.status='INACTIVE' where is.id in (select iss.id from installed_software iss where iss.status = 'TRANSITION' fetch first 50000 row only);

---delet all installed_Tadz data --- 
delete from eaadmin.installed_tadz ;