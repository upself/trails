DROP procedure eaadmin.delete_instsw@
DROP TYPE eaadmin.BIGINTLIST@

CREATE TYPE eaadmin.BIGINTLIST AS BIGINT ARRAY[]@
CREATE PROCEDURE eaadmin.delete_instsw(IN p_customerId varchar(30), IN p_age varchar(5), OUT o_total BIGINT, OUT v_line INTEGER)
LANGUAGE SQL
SPECIFIC EAADMIN.DELETE_INSTSW
BEGIN

DECLARE v_tem_total INTEGER DEFAULT 0;
DECLARE v_tem_sf_total INTEGER DEFAULT 0;
DECLARE v_delete_total INTEGER DEFAULT 0;
DECLARE v_round INTEGER DEFAULT 0;
DECLARE INSTIDLIST EAADMIN.BIGINTLIST;
DECLARE SFIDLIST EAADMIN.BIGINTLIST;
DECLARE ULILIST EAADMIN.BIGINTLIST;
DECLARE ULHLIST EAADMIN.BIGINTLIST;

DECLARE v_empty_discr_history INTEGER DEFAULT 0;
DECLARE v_empty_alert_cause_code_h INTEGER DEFAULT 0;
DECLARE v_empty_alert_cause_code INTEGER DEFAULT 0;
DECLARE v_empty_alert_inst_sw_h INTEGER DEFAULT 0;
DECLARE v_empty_alert_inst_sw INTEGER DEFAULT 0;
DECLARE v_empty_installed_filter INTEGER DEFAULT 0;
DECLARE v_empty_installed_signature INTEGER DEFAULT 0;
DECLARE v_empty_installed_dorana INTEGER DEFAULT 0;
DECLARE v_empty_installed_sa INTEGER DEFAULT 0;
DECLARE v_empty_installed_tadz INTEGER DEFAULT 0;
DECLARE v_empty_software_eff INTEGER DEFAULT 0;
DECLARE v_empty_used_license INTEGER DEFAULT 0;
DECLARE v_empty_reconcile_used_license INTEGER DEFAULT 0;
DECLARE v_empty_reconcile INTEGER DEFAULT 0;
DECLARE v_empty_h_used_license INTEGER DEFAULT 0;
DECLARE v_empty_h_reconcile_used_license INTEGER DEFAULT 0;
DECLARE v_empty_reconcile_h INTEGER DEFAULT 0;
DECLARE v_empty_installed_software INTEGER DEFAULT 0;
DECLARE v_empty_orphan_used_license INTEGER DEFAULT 0;
DECLARE v_empty_orphan_h_used_license INTEGER DEFAULT 0;
DECLARE v_empty_schedule_f_h INTEGER DEFAULT 0;
DECLARE v_empty_schedule_f INTEGER DEFAULT 0;

DECLARE v_sql_query_inact_inst_sw VARCHAR(512);
DECLARE v_sql_query_inact_sf VARCHAR(512);
DECLARE v_sql_delete_discr_history VARCHAR(512);
DECLARE v_sql_delete_alert_cause_code_h VARCHAR(640);
DECLARE v_sql_delete_alert_cause_code VARCHAR(640);
DECLARE v_sql_delete_alert_inst_sw_h VARCHAR(640);
DECLARE v_sql_delete_alert_inst_sw VARCHAR(512);
DECLARE v_sql_delete_installed_filter VARCHAR(512);
DECLARE v_sql_delete_installed_signature VARCHAR(512);
DECLARE v_sql_delete_installed_dorana VARCHAR(512);
DECLARE v_sql_delete_installed_sa VARCHAR(512);
DECLARE v_sql_delete_installed_tadz VARCHAR(512);
DECLARE v_sql_delete_software_eff VARCHAR(512);
DECLARE v_sql_delete_used_license VARCHAR(640);
DECLARE v_sql_delete_reconcile_used_license VARCHAR(640);
DECLARE v_sql_delete_reconcile VARCHAR(512);
DECLARE v_sql_delete_h_used_license VARCHAR(640);
DECLARE v_sql_delete_h_reconcile_used_license VARCHAR(640);
DECLARE v_sql_delete_reconcile_h VARCHAR(512);
DECLARE v_sql_delete_installed_software VARCHAR(512);
DECLARE v_sql_delete_orphan_used_license VARCHAR(512);
DECLARE v_sql_delete_orphan_h_used_license VARCHAR(512);
DECLARE v_sql_delete_schedule_f_h VARCHAR(512);
DECLARE v_sql_delete_schedule_f VARCHAR(512);
DECLARE o_res INTEGER;
DECLARE v_sys_result BIGINT;
DECLARE v_account_number VARCHAR(20);
DECLARE v_start_time VARCHAR(14);
DECLARE v_end_time   VARCHAR(14);
DECLARE SQLCODE INTEGER DEFAULT 0; 

DECLARE v_stmt_delete_dh STATEMENT;
DECLARE v_stmt_delete_cch STATEMENT;
DECLARE v_stmt_delete_cc STATEMENT;
DECLARE v_stmt_delete_aih STATEMENT;
DECLARE v_stmt_delete_ai STATEMENT;
DECLARE v_stmt_delete_if STATEMENT;
DECLARE v_stmt_delete_iss STATEMENT;
DECLARE v_stmt_delete_id STATEMENT;
DECLARE v_stmt_delete_isa STATEMENT;
DECLARE v_stmt_delete_istd STATEMENT;
DECLARE v_stmt_delete_se STATEMENT;
DECLARE v_stmt_delete_is STATEMENT;
DECLARE v_stmt_delete_ulic STATEMENT;
DECLARE v_stmt_delete_rulic STATEMENT;
DECLARE v_stmt_delete_rc STATEMENT;
DECLARE v_stmt_delete_hulic STATEMENT;
DECLARE v_stmt_delete_hrulic STATEMENT;
DECLARE v_stmt_delete_rch STATEMENT;
DECLARE v_stmt_select_is STATEMENT;
DECLARE v_stmt_delete_orpulic STATEMENT;
DECLARE v_stmt_delete_orphulic STATEMENT;
DECLARE v_stmt_delete_sf_h STATEMENT;
DECLARE v_stmt_delete_sf STATEMENT;
DECLARE ct CURSOR WITH HOLD WITH RETURN FOR s1;
DECLARE cf CURSOR WITH HOLD WITH RETURN FOR s2;

DECLARE CONTINUE HANDLER FOR NOT found SET o_res = SQLCODE;--Empty record
DECLARE EXIT handler FOR SQLexception
   BEGIN
      SET o_res = SQLCODE;
      ROLLBACK;
      SET v_end_time = REPLACE(LTRIM(RTRIM(CHAR(current_date,ISO))),'-','')||REPLACE(LTRIM(RTRIM(CHAR(current_time,ISO))),'.','');
      UPDATE EAADMIN.SYSTEM_SCHEDULE_STATUS
      SET end_time = v_end_time,STATUS = CAST(o_res as CHAR(10)),comments='DB_PROCEDURE DELETE INSTALLED SOFTWARES STOP WITH ERROR'
      WHERE name = 'DELETE INSTSW '||v_account_number
      AND start_time = v_start_time;
      COMMIT;
   END;
   set v_line= 0;
   SET v_account_number = NULL;
   SELECT cast(b.account_number as CHAR(20)) INTO v_account_number  from EAADMIN.CUSTOMER b WHERE b.customer_id = CAST(p_customerId AS BIGINT) ;
   
   SET v_sys_result = NULL;
   SET v_start_time = REPLACE(LTRIM(RTRIM(CHAR(current_date,ISO))),'-','')||REPLACE(LTRIM(RTRIM(CHAR(current_time,ISO))),'.','');
   SELECT a.id INTO v_sys_result  from EAADMIN.SYSTEM_SCHEDULE_STATUS a WHERE a.name = 'DELETE INSTSW '||v_account_number ;
   if(v_sys_result is not null)  then 
   UPDATE EAADMIN.SYSTEM_SCHEDULE_STATUS SET start_time = v_start_time,end_time = null,comments='DB_PROCEDURE DELETE INSTALLED SOFTWARES START',status='0' where id = v_sys_result ;
   else 
   INSERT INTO EAADMIN.SYSTEM_SCHEDULE_STATUS(id,name,comments,start_time,end_time,remote_user,status)
   VALUES(DEFAULT,'DELETE INSTSW '||v_account_number,'DB_PROCEDURE DELETE INSTALLED SOFTWARES START',v_start_time,NULL,'DB_PROCEDURE','0'); 
   end if;
   COMMIT; 
   

SET v_sql_query_inact_inst_sw = 'select count(is.id) from eaadmin.installed_software is join eaadmin.software_lpar sl on is.software_lpar_id=sl.id join eaadmin.software s on is.software_id=s.software_id where sl.customer_id = '||p_customerId||' and ( (is.status != '''||'ACTIVE'||''' and current timestamp -  '||p_age||' DAYS > is.record_time )   or (sl.status != '''||'ACTIVE'||''' and current timestamp - '||p_age||' DAYS > sl.record_time ) or  (s.status != '''||'ACTIVE'||''') ) with ur';
SET v_sql_query_inact_sf = 'select count(sf.id) from eaadmin.schedule_f sf where sf.customer_id = '||p_customerId||' and current timestamp - '||p_age||' DAYS > sf.record_time and sf.status_id = 1 with ur';

SET v_sql_delete_discr_history = 'delete from (select 1 from eaadmin.software_discrepancy_h a where a.installed_software_id in  (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_alert_cause_code_h = 'delete from (select 1 from  eaadmin.cause_code_h cch where exists (select 1 from eaadmin.cause_code cc join eaadmin.alert_unlicensed_sw aus on cc.alert_id=aus.id  where cch.cause_code_id=cc.id and cc.alert_type_id=17 and aus.installed_software_id in  (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids))))';
SET v_sql_delete_alert_cause_code = 'delete from  (select 1 from  eaadmin.cause_code cc where cc.alert_type_id=17 and exists ( select 1 from eaadmin.alert_unlicensed_sw aus  where cc.alert_id=aus.id and aus.installed_software_id in  (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids))))';
SET v_sql_delete_alert_inst_sw_h = 'delete from  (select 1 from eaadmin.alert_unlicensed_sw aus where aus.installed_software_id in  (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_alert_inst_sw = 'delete from (select 1 from eaadmin.alert_unlicensed_sw e where e.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_installed_filter = 'delete from (select 1 from  eaadmin.installed_filter f where f.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_installed_signature = 'delete from (select 1 from eaadmin.installed_signature g where g.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_installed_dorana =  'delete from (select 1 from eaadmin.installed_dorana_product h where h.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_installed_sa = 'delete from (select 1 from eaadmin.installed_sa_product i where i.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))' ;
SET v_sql_delete_installed_tadz = 'delete from (select 1 from eaadmin.installed_tadz j where j.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))' ;
SET v_sql_delete_software_eff =  'delete from (select 1 from eaadmin.installed_software_eff k where k.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_used_license = 'delete from (select 1 from eaadmin.used_license l where exists (select count(used_license_id) from eaadmin.reconcile_used_license rula where rula.used_license_id=l.id group by used_license_id having count(used_license_id) =1 ) and exists (select 1 from eaadmin.reconcile_used_license rul  join eaadmin.reconcile rc on rul.reconcile_id=rc.id  where rul.USED_LICENSE_ID = l.id and rc.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids))))';
SET v_sql_delete_reconcile_used_license = 'delete from (select 1 from eaadmin.reconcile_used_license m where exists(select 1 from  eaadmin.reconcile rc  where m.RECONCILE_ID = rc.id and rc.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids))))';
SET v_sql_delete_reconcile = 'delete from (select 1 from eaadmin.reconcile n where n.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_h_used_license = 'delete from (select 1 from eaadmin.h_used_license o where exists (select count(h_used_license_id) from eaadmin.h_reconcile_used_license hrula where hrula.h_used_license_id=o.id group by h_used_license_id having count(h_used_license_id) =1 ) and  exists (select 1 from eaadmin.h_reconcile_used_license hrul  join eaadmin.reconcile_h rch on hrul.h_reconcile_id=rch.id  where  o.id = hrul.h_used_license_id and rch.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)) ))';
SET v_sql_delete_h_reconcile_used_license = 'delete from (select 1 from eaadmin.h_reconcile_used_license p where exists (select 1 from eaadmin.reconcile_h rch  where p.H_RECONCILE_ID = rch.id and rch.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids))))';
SET v_sql_delete_reconcile_h = 'delete from (select 1 from eaadmin.reconcile_h q where q.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_installed_software = 'delete from (select 1 from eaadmin.installed_software r where r.id in (SELECT X.ids FROM UNNEST(cast(? as BIGINTLIST)) AS X(ids)))';
SET v_sql_delete_orphan_used_license = 'delete from (select 1 from eaadmin.used_license ul where not exists (select 1 from eaadmin.reconcile_used_license rul where rul.used_license_id=ul.id) and ul.id in (SELECT U.ids FROM  UNNEST(cast(? as BIGINTLIST)) AS U(ids)))';
SET v_sql_delete_orphan_h_used_license = 'delete from (select 1 from eaadmin.h_used_license hul where not exists (select 1 from eaadmin.h_reconcile_used_license hrul where hrul.h_used_license_id=hul.id) and hul.id in (SELECT H.ids FROM  UNNEST(cast(? as BIGINTLIST)) AS H(ids)))';
SET v_sql_delete_schedule_f_h = 'delete from (select 1 from eaadmin.schedule_f_h sfh where sfh.SCHEDULE_F_ID in ( select F.id FROM UNNEST(cast(? as BIGINTLIST)) AS F(id) ))';
SET v_sql_delete_schedule_f = 'delete from (select 1 from eaadmin.schedule_f sf where sf.id in ( select F.id FROM UNNEST(cast(? as BIGINTLIST)) AS F(id) ))';


 PREPARE s1 FROM  v_sql_query_inact_inst_sw;
   OPEN ct;
   FETCH ct into v_tem_total;
    IF SQLCODE <> 0 THEN
    set v_line= 0;
    END IF;
	CLOSE ct;
COMMIT;	
PREPARE s2 FROM  v_sql_query_inact_sf;
   OPEN cf;
   FETCH cf into v_tem_sf_total;
    IF SQLCODE <> 0 THEN
    set v_line= 1;
    END IF;
	CLOSE cf;
COMMIT;
    IF v_tem_total < v_tem_sf_total THEN
	 set v_tem_total = v_tem_sf_total;
	END IF;
LOOPD:LOOP
	  SET v_round = v_round + 1;
	  IF v_tem_total <= 0 THEN      
	  LEAVE LOOPD;
      END IF;
	set INSTIDLIST = ( select ARRAY_AGG(T.id) from (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on is.software_lpar_id=sl.id join eaadmin.software s on is.software_id=s.software_id where sl.customer_id = CAST(p_customerId AS BIGINT) and ( (is.status != 'ACTIVE' and current timestamp -  CAST(p_age AS integer)  DAYS >is.record_time )   or (sl.status != 'ACTIVE' and current timestamp - CAST(p_age AS integer)  DAYS > sl.record_time ) or  (s.status != 'ACTIVE') ) fetch first 1000 row only ) as T );
    set SFIDLIST = ( select ARRAY_AGG(F.id) from (select sf.id from eaadmin.schedule_f sf where sf.customer_id = CAST(p_customerId AS BIGINT) and current timestamp - CAST(p_age AS integer)  DAYS > sf.record_time  and sf.status_id = 1 fetch first 1000 row only ) as F );
	set ULILIST = ( select ARRAY_AGG(U.id) from (select l.id from eaadmin.used_license l where  exists (select 1 from eaadmin.reconcile_used_license rul  join eaadmin.reconcile rc on rul.reconcile_id=rc.id  where rul.USED_LICENSE_ID = l.id and rc.installed_software_id in (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on is.software_lpar_id=sl.id join eaadmin.software s on is.software_id=s.software_id where sl.customer_id = CAST(p_customerId AS BIGINT) and ( (is.status != 'ACTIVE' and current timestamp -  CAST(p_age AS integer)  DAYS >is.record_time )   or (sl.status != 'ACTIVE' and current timestamp - CAST(p_age AS integer)  DAYS > sl.record_time ) or  (s.status != 'ACTIVE') ) fetch first 1000 row only ))) as U );
	set ULHLIST = ( select ARRAY_AGG(H.id) from (select o.id from eaadmin.h_used_license o where   exists (select 1 from eaadmin.h_reconcile_used_license hrul  join eaadmin.reconcile_h rch on hrul.h_reconcile_id=rch.id  where  o.id = hrul.h_used_license_id and rch.installed_software_id in (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on is.software_lpar_id=sl.id join eaadmin.software s on is.software_id=s.software_id where sl.customer_id = CAST(p_customerId AS BIGINT) and ( (is.status != 'ACTIVE' and current timestamp -  CAST(p_age AS integer)  DAYS >is.record_time )   or (sl.status != 'ACTIVE' and current timestamp - CAST(p_age AS integer)  DAYS > sl.record_time ) or  (s.status != 'ACTIVE') ) fetch first 1000 row only ) )) as H );
	set v_line = 2;
	PREPARE v_stmt_delete_dh FROM v_sql_delete_discr_history;
	   PREPARE v_stmt_delete_cch FROM v_sql_delete_alert_cause_code_h;
	     PREPARE v_stmt_delete_cc FROM v_sql_delete_alert_cause_code;
	       PREPARE v_stmt_delete_aih FROM v_sql_delete_alert_inst_sw_h;
	         PREPARE v_stmt_delete_ai FROM v_sql_delete_alert_inst_sw;     
	           PREPARE v_stmt_delete_if FROM v_sql_delete_installed_filter;
		         PREPARE v_stmt_delete_iss FROM v_sql_delete_installed_signature;
		           PREPARE v_stmt_delete_id FROM v_sql_delete_installed_dorana;
			         PREPARE v_stmt_delete_isa FROM v_sql_delete_installed_sa;
			           PREPARE v_stmt_delete_istd FROM v_sql_delete_installed_tadz;
			             PREPARE v_stmt_delete_se FROM v_sql_delete_software_eff;
				           PREPARE v_stmt_delete_ulic FROM v_sql_delete_used_license;
                             PREPARE v_stmt_delete_rulic FROM v_sql_delete_reconcile_used_license;
				               PREPARE v_stmt_delete_rc FROM v_sql_delete_reconcile;
					             PREPARE v_stmt_delete_hulic FROM v_sql_delete_h_used_license;
                                   PREPARE v_stmt_delete_hrulic FROM v_sql_delete_h_reconcile_used_license;
				                     PREPARE v_stmt_delete_rch FROM v_sql_delete_reconcile_h;
					                   PREPARE v_stmt_delete_is FROM v_sql_delete_installed_software;
									     PREPARE v_stmt_delete_orpulic FROM v_sql_delete_orphan_used_license;
									       PREPARE v_stmt_delete_orphulic FROM v_sql_delete_orphan_h_used_license;
									         PREPARE v_stmt_delete_sf_h FROM v_sql_delete_schedule_f_h;
									           PREPARE v_stmt_delete_sf FROM v_sql_delete_schedule_f;
 IF v_empty_discr_history = 0 THEN
	 EXECUTE v_stmt_delete_dh USING INSTIDLIST;
	 IF SQLCODE < 0 THEN 
		 set v_line= 3;
		 LEAVE LOOPD;
     ELSEIF SQLCODE = 100 THEN
	     set v_empty_discr_history = 1;
     END IF;
 END IF;
  COMMIT;
 IF v_empty_alert_cause_code_h = 0 THEN
     EXECUTE v_stmt_delete_cch USING INSTIDLIST;
	 IF SQLCODE < 0 THEN 
     	 set v_line= 4;
		LEAVE LOOPD;
     ELSEIF SQLCODE = 100 THEN
	     set v_empty_alert_cause_code_h = 1;
     END IF;
 END IF;
  COMMIT;
 IF v_empty_alert_cause_code = 0 THEN
 	 EXECUTE v_stmt_delete_cc USING INSTIDLIST;
	 IF SQLCODE < 0 THEN 
     	 set v_line= 5;
		LEAVE LOOPD;
     ELSEIF SQLCODE = 100 THEN
	     set v_empty_alert_cause_code = 1;
     END IF;
 END IF;
  COMMIT;
 IF v_empty_alert_inst_sw_h = 0 THEN
	 EXECUTE v_stmt_delete_aih USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
     	 set v_line= 6;
		LEAVE LOOPD;
     ELSEIF SQLCODE = 100 THEN
	     set v_empty_alert_inst_sw_h = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_alert_inst_sw = 0 THEN
	 EXECUTE v_stmt_delete_ai USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
     	 set v_line= 7;
		LEAVE LOOPD;
      ELSEIF SQLCODE = 100 THEN
	     set v_empty_alert_inst_sw = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_installed_filter = 0 THEN
	 EXECUTE v_stmt_delete_if USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	      set v_line= 8;
		 LEAVE LOOPD;
        ELSEIF SQLCODE = 100 THEN
	     set v_empty_installed_filter = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_installed_signature= 0 THEN
	 EXECUTE v_stmt_delete_iss USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	    set v_line= 9;
		LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_installed_signature = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_installed_dorana = 0 THEN
	 EXECUTE v_stmt_delete_id USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
         set v_line= 10;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_installed_dorana = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_installed_sa= 0 THEN
	 EXECUTE v_stmt_delete_isa USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 11;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_installed_sa = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_installed_tadz = 0 THEN
	 EXECUTE v_stmt_delete_istd USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 12;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_installed_tadz = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_software_eff = 0 THEN
	 EXECUTE v_stmt_delete_se USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	      set v_line= 13;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_software_eff = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_used_license = 0 THEN
	  	 EXECUTE v_stmt_delete_ulic USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 14;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_used_license = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile_used_license = 0 THEN
	  	 EXECUTE v_stmt_delete_rulic USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 15;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile_used_license = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile = 0 THEN
	 EXECUTE v_stmt_delete_rc USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 16;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_used_license = 0 THEN
	  	 EXECUTE v_stmt_delete_hulic USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 17;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_used_license = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_reconcile_used_license = 0 THEN
	  	 EXECUTE v_stmt_delete_hrulic USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 18;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_reconcile_used_license = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile_h = 0 THEN
	 EXECUTE v_stmt_delete_rch USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 19;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile_h = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_installed_software = 0 THEN
	 EXECUTE v_stmt_delete_is USING INSTIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 20;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_installed_software = 1;
     END IF;
 END IF;
  COMMIT;
  IF v_empty_orphan_used_license = 0 THEN
	 EXECUTE v_stmt_delete_orpulic USING ULILIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 21;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_orphan_used_license = 1;
     END IF;
 END IF;
  COMMIT;
  IF v_empty_orphan_h_used_license = 0 THEN
	 EXECUTE v_stmt_delete_orphulic USING ULHLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 22;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_orphan_h_used_license = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_schedule_f_h = 0 THEN
	 EXECUTE v_stmt_delete_sf_h USING SFIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 23;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_schedule_f_h = 1;
     END IF;
 END IF;
IF v_empty_schedule_f = 0 THEN
	 EXECUTE v_stmt_delete_sf USING SFIDLIST;
	  IF SQLCODE < 0 THEN 
	     set v_line= 24;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_schedule_f = 1;
     END IF;
 END IF;
 COMMIT;
	  IF  0 < v_tem_total and v_tem_total <= 1000 THEN 
      SET v_delete_total = v_delete_total + v_tem_total;
	    set v_line= v_round * 1000 + v_line;
      ELSEIF v_tem_total > 1000 THEN	  
	  SET v_delete_total = v_delete_total + 1000;
	    set v_line= v_round + 1026;
      END IF;
	  set v_tem_total = v_tem_total - 1000;
END LOOP LOOPD;
  
  COMMIT;
  
  SET o_total = v_delete_total;

   SET v_end_time = REPLACE(LTRIM(RTRIM(CHAR(current_date,ISO))),'-','')||REPLACE(LTRIM(RTRIM(CHAR(current_time,ISO))),'.','');
   UPDATE EAADMIN.SYSTEM_SCHEDULE_STATUS
   SET end_time = v_end_time,status = '1',comments='DB_PROCEDURE DELETE INSTALLED SOFTWARES STOP'
   WHERE name = 'DELETE INSTSW '||v_account_number
   AND start_time = v_start_time;
   COMMIT;
   
END@
GRANT EXECUTE ON PROCEDURE eaadmin.delete_instsw TO EAADMIN@