DROP procedure eaadmin.delete_history@
DROP TYPE eaadmin.BINTLIST@

CREATE TYPE eaadmin.BINTLIST AS BIGINT ARRAY[]@
CREATE PROCEDURE eaadmin.delete_history(IN p_customerId varchar(30), IN p_age varchar(5), OUT o_total BIGINT, OUT v_line INTEGER)
LANGUAGE SQL
SPECIFIC EAADMIN.DELETE_HISTORY
BEGIN

DECLARE v_tem_total INTEGER DEFAULT 0;
DECLARE v_tem_sf_total INTEGER DEFAULT 0;
DECLARE v_delete_total INTEGER DEFAULT 0;
DECLARE v_round INTEGER DEFAULT 0;
DECLARE INSTIDLISTONE EAADMIN.BINTLIST;
DECLARE INSTIDLISTTWO EAADMIN.BINTLIST;
DECLARE INSTIDLISTTHR EAADMIN.BINTLIST;
DECLARE INSTIDLISTFOR EAADMIN.BINTLIST;


DECLARE v_empty_h_used_license_o INTEGER DEFAULT 0;
DECLARE v_empty_h_used_license_t INTEGER DEFAULT 0;
DECLARE v_empty_h_used_license_r INTEGER DEFAULT 0;
DECLARE v_empty_h_used_license_f INTEGER DEFAULT 0;
DECLARE v_empty_h_reconcile_used_license_o INTEGER DEFAULT 0;
DECLARE v_empty_h_reconcile_used_license_t INTEGER DEFAULT 0;
DECLARE v_empty_h_reconcile_used_license_r INTEGER DEFAULT 0;
DECLARE v_empty_h_reconcile_used_license_f  INTEGER DEFAULT 0;
DECLARE v_empty_reconcile_h_o INTEGER DEFAULT 0;
DECLARE v_empty_reconcile_h_t INTEGER DEFAULT 0;
DECLARE v_empty_reconcile_h_r INTEGER DEFAULT 0;
DECLARE v_empty_reconcile_h_f INTEGER DEFAULT 0;

DECLARE v_sql_count_affect_inst_sw VARCHAR(1900);
DECLARE v_sql_delete_h_used_license VARCHAR(640);
DECLARE v_sql_delete_h_reconcile_used_license VARCHAR(640);
DECLARE v_sql_delete_reconcile_h VARCHAR(640);
DECLARE o_res INTEGER;
DECLARE v_sys_result BIGINT;
DECLARE v_account_number VARCHAR(20);
DECLARE v_start_time VARCHAR(14);
DECLARE v_end_time   VARCHAR(14);
DECLARE SQLCODE INTEGER DEFAULT 0; 

DECLARE v_stmt_delete_hulic STATEMENT;
DECLARE v_stmt_delete_hrulic STATEMENT;
DECLARE v_stmt_delete_rch STATEMENT;
DECLARE ct CURSOR WITH HOLD WITH RETURN FOR s1;

DECLARE CONTINUE HANDLER FOR NOT found SET o_res = SQLCODE;--Empty record
DECLARE EXIT handler FOR SQLexception
   BEGIN
      SET o_res = SQLCODE;
      ROLLBACK;
      SET v_end_time = REPLACE(LTRIM(RTRIM(CHAR(current_date,ISO))),'-','')||REPLACE(LTRIM(RTRIM(CHAR(current_time,ISO))),'.','');
      UPDATE EAADMIN.SYSTEM_SCHEDULE_STATUS
      SET end_time = v_end_time,STATUS = CAST(o_res as CHAR(10)),comments='DB_PROCEDURE DELETE History Record STOP WITH ERROR'
      WHERE name = 'DELETE HISTORY '||v_account_number
      AND start_time = v_start_time;
      COMMIT;
   END;
   set v_line= 0;
   SET v_account_number = NULL;
   SELECT cast(b.account_number as CHAR(20)) INTO v_account_number  from EAADMIN.CUSTOMER b WHERE b.customer_id = CAST(p_customerId AS BIGINT) ;
   
   SET v_sys_result = NULL;
   SET v_start_time = REPLACE(LTRIM(RTRIM(CHAR(current_date,ISO))),'-','')||REPLACE(LTRIM(RTRIM(CHAR(current_time,ISO))),'.','');
   SELECT a.id INTO v_sys_result  from EAADMIN.SYSTEM_SCHEDULE_STATUS a WHERE a.name = 'DELETE HISTORY '||v_account_number ;
   if(v_sys_result is not null)  then 
   UPDATE EAADMIN.SYSTEM_SCHEDULE_STATUS SET start_time = v_start_time,end_time = null,comments='DB_PROCEDURE DELETE History Record START',status='0' where id = v_sys_result ;
   else 
   INSERT INTO EAADMIN.SYSTEM_SCHEDULE_STATUS(id,name,comments,start_time,end_time,remote_user,status)
   VALUES(DEFAULT,'DELETE HISTORY '||v_account_number,'DB_PROCEDURE DELETE History Record START',v_start_time,NULL,'DB_PROCEDURE','0'); 
   end if;
   COMMIT; 
   

SET v_sql_count_affect_inst_sw = 'select sum(T.count) from (
select count(is.id) as count from eaadmin.installed_software is
join eaadmin.software_lpar sl on sl.id = is.software_lpar_id
join eaadmin.reconcile rc on rc.installed_software_id = is.id
join eaadmin.reconcile_type rt on rc.reconcile_type_id = rt.id
where
rt.is_manual = 0
and sl.customer_id = '||p_customerId||'
and (current timestamp - '||p_age||'  DAYS > rc.record_time)
and exists (select 1 from eaadmin.reconcile_h rh where rh.installed_software_id = rc.installed_software_id)
union all
select count(is.id) as count
from eaadmin.installed_software is
join eaadmin.software_lpar sl on sl.id = is.software_lpar_id
join eaadmin.reconcile_h rch on rch.installed_software_id = is.id
join eaadmin.reconcile_type rt on rch.reconcile_type_id=rt.id
where rt.is_manual = 1
and rch.MANUAL_BREAK = 1
and sl.customer_id = '||p_customerId||' and (current timestamp - '||p_age||' DAYS > rch.record_time)
union all
select count(is.id) as count
from eaadmin.installed_software is
join eaadmin.software_lpar sl on sl.id = is.software_lpar_id
join eaadmin.alert_unlicensed_sw aus on aus.installed_software_id = is.id and aus.open = 1
join eaadmin.reconcile_h rch on rch.installed_software_id = is.id
join eaadmin.reconcile_type rt on rch.reconcile_type_id=rt.id
where rt.is_manual = 1
and sl.customer_id = '||p_customerId||'
and (current timestamp - '||p_age||' DAYS > aus.creation_time)
union all
select count(is.id) as count
from eaadmin.installed_software is
join eaadmin.software_lpar sl on sl.id = is.software_lpar_id
join eaadmin.reconcile rc on rc.installed_software_id = is.id
join eaadmin.reconcile_h rch on rch.installed_software_id = is.id
join eaadmin.reconcile_type rt on rch.reconcile_type_id = rt.id
where rt.is_manual = 1
and rc.reconcile_type_id <> rch.reconcile_type_id
and sl.customer_id = '||p_customerId||' 
) as T with ur ';
SET v_sql_delete_h_used_license = 'delete from (select 1 from eaadmin.h_used_license o where exists (select count(h_used_license_id) from eaadmin.h_reconcile_used_license hrula where hrula.h_used_license_id=o.id group by h_used_license_id having count(h_used_license_id) =1 ) and  exists (select 1 from eaadmin.h_reconcile_used_license hrul  join eaadmin.reconcile_h rch on hrul.h_reconcile_id=rch.id  where  o.id = hrul.h_used_license_id and rch.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as eaadmin.BINTLIST)) AS X(ids)) ))';
SET v_sql_delete_h_reconcile_used_license = 'delete from (select 1 from eaadmin.h_reconcile_used_license p where exists (select 1 from eaadmin.reconcile_h rch  where p.H_RECONCILE_ID = rch.id and rch.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as eaadmin.BINTLIST)) AS X(ids))))';
SET v_sql_delete_reconcile_h = 'delete from (select 1 from eaadmin.reconcile_h q where q.installed_software_id in (SELECT X.ids FROM UNNEST(cast(? as eaadmin.BINTLIST)) AS X(ids)))';

 PREPARE s1 FROM  v_sql_count_affect_inst_sw;
   OPEN ct;
   FETCH ct into v_tem_total;
    IF SQLCODE <> 0 THEN
    set v_line= 1;
    END IF;
	CLOSE ct;
COMMIT;	

LOOPD:LOOP
	  SET v_round = v_round + 1;
	  IF v_tem_total <= 0 THEN    	  
	  LEAVE LOOPD;
      END IF;
	set INSTIDLISTONE = ( select ARRAY_AGG(T.id) from (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on sl.id = is.software_lpar_id join eaadmin.reconcile rc on rc.installed_software_id = is.id join eaadmin.reconcile_type rt on rc.reconcile_type_id = rt.id where rt.is_manual = 0 and sl.customer_id =  CAST(p_customerId AS BIGINT) and (current timestamp - CAST(p_age AS integer) DAYS > rc.record_time) and exists (select 1 from eaadmin.reconcile_h rh where rh.installed_software_id = rc.installed_software_id) fetch first 100 row only) as T );
    	set INSTIDLISTTWO = ( select ARRAY_AGG(T.id) from (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on sl.id = is.software_lpar_id join eaadmin.reconcile_h rch on rch.installed_software_id = is.id join eaadmin.reconcile_type rt on rch.reconcile_type_id=rt.id where rt.is_manual = 1 and rch.MANUAL_BREAK = 1 and sl.customer_id = CAST(p_customerId AS BIGINT) and (current timestamp - CAST(p_age AS integer) DAYS > rch.record_time) fetch first 100 row only) as T );
           	set INSTIDLISTTHR = ( select ARRAY_AGG(T.id) from (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on sl.id = is.software_lpar_id join eaadmin.alert_unlicensed_sw aus on aus.installed_software_id = is.id and aus.open = 1 join eaadmin.reconcile_h rch on rch.installed_software_id = is.id join eaadmin.reconcile_type rt on rch.reconcile_type_id=rt.id where rt.is_manual = 1 and sl.customer_id = CAST(p_customerId AS BIGINT) and (current timestamp - CAST(p_age AS integer) DAYS > aus.creation_time) fetch first 100 row only) as T );
               	set INSTIDLISTFOR = ( select ARRAY_AGG(T.id) from (select is.id from eaadmin.installed_software is join eaadmin.software_lpar sl on sl.id = is.software_lpar_id join eaadmin.reconcile rc on rc.installed_software_id = is.id join eaadmin.reconcile_h rch on rch.installed_software_id = is.id join eaadmin.reconcile_type rt on rch.reconcile_type_id = rt.id where rt.is_manual = 1 and rc.reconcile_type_id <> rch.reconcile_type_id and sl.customer_id = CAST(p_customerId AS BIGINT) fetch first 100 row only) as T );

	set v_line = 2;
	             PREPARE v_stmt_delete_hulic FROM v_sql_delete_h_used_license;
                       PREPARE v_stmt_delete_hrulic FROM v_sql_delete_h_reconcile_used_license;
				               PREPARE v_stmt_delete_rch FROM v_sql_delete_reconcile_h;
	

IF v_empty_h_used_license_o = 0 THEN
	  	 EXECUTE v_stmt_delete_hulic USING INSTIDLISTONE;
	  IF SQLCODE < 0 THEN 
	     set v_line= 3;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_used_license_o = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_used_license_t = 0 THEN
	  	 EXECUTE v_stmt_delete_hulic USING INSTIDLISTTWO;
	  IF SQLCODE < 0 THEN 
	     set v_line= 4;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_used_license_t = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_used_license_r = 0 THEN
	  	 EXECUTE v_stmt_delete_hulic USING INSTIDLISTTHR;
	  IF SQLCODE < 0 THEN 
	     set v_line= 5;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_used_license_r = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_used_license_f = 0 THEN
	  	 EXECUTE v_stmt_delete_hulic USING INSTIDLISTFOR;
	  IF SQLCODE < 0 THEN 
	     set v_line= 6;
		 LEAVE LOOPD;
          ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_used_license_f = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_reconcile_used_license_o = 0 THEN
	  	 EXECUTE v_stmt_delete_hrulic USING INSTIDLISTONE;
	  IF SQLCODE < 0 THEN 
	     set v_line= 7;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_reconcile_used_license_o = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_reconcile_used_license_t = 0 THEN
	  	 EXECUTE v_stmt_delete_hrulic USING INSTIDLISTTWO;
	  IF SQLCODE < 0 THEN 
	     set v_line= 8;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_reconcile_used_license_t = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_reconcile_used_license_r = 0 THEN
	  	 EXECUTE v_stmt_delete_hrulic USING INSTIDLISTTHR;
	  IF SQLCODE < 0 THEN 
	     set v_line= 9;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_reconcile_used_license_r = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_h_reconcile_used_license_f = 0 THEN
	  	 EXECUTE v_stmt_delete_hrulic USING INSTIDLISTFOR;
	  IF SQLCODE < 0 THEN 
	     set v_line= 10;
		 LEAVE LOOPD;
           ELSEIF SQLCODE = 100 THEN
	     set v_empty_h_reconcile_used_license_f = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile_h_o = 0 THEN
	 EXECUTE v_stmt_delete_rch USING INSTIDLISTONE;
	  IF SQLCODE < 0 THEN 
	     set v_line= 11;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile_h_o = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile_h_t = 0 THEN
	 EXECUTE v_stmt_delete_rch USING INSTIDLISTTWO;
	  IF SQLCODE < 0 THEN 
	     set v_line= 12;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile_h_t = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile_h_r = 0 THEN
	 EXECUTE v_stmt_delete_rch USING INSTIDLISTTHR;
	  IF SQLCODE < 0 THEN 
	     set v_line= 13;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile_h_r = 1;
     END IF;
 END IF;
  COMMIT;
IF v_empty_reconcile_h_f = 0 THEN
	 EXECUTE v_stmt_delete_rch USING INSTIDLISTFOR;
	  IF SQLCODE < 0 THEN 
	     set v_line= 14;
		 LEAVE LOOPD;
         ELSEIF SQLCODE = 100 THEN
	     set v_empty_reconcile_h_f = 1;
     END IF;
 END IF;
  COMMIT;
  
	  IF  0 < v_tem_total and v_tem_total <= 100 THEN 
      SET v_delete_total = v_delete_total + v_tem_total;
	   set v_line= v_round * 1000 + v_line;
      ELSEIF v_tem_total > 100 THEN	  
	  SET v_delete_total = v_delete_total + 100;
      END IF;
	  set v_tem_total = v_tem_total - 100;
END LOOP LOOPD;
  
  COMMIT;
  
  SET o_total = v_delete_total;

   SET v_end_time = REPLACE(LTRIM(RTRIM(CHAR(current_date,ISO))),'-','')||REPLACE(LTRIM(RTRIM(CHAR(current_time,ISO))),'.','');
   UPDATE EAADMIN.SYSTEM_SCHEDULE_STATUS
   SET end_time = v_end_time,status = '1',comments='DB_PROCEDURE DELETE History Record STOP'
   WHERE name = 'DELETE HISTORY '||v_account_number
   AND start_time = v_start_time;
   COMMIT;
   
END@
GRANT EXECUTE ON PROCEDURE eaadmin.delete_history TO EAADMIN@