DROP TRIGGER SET_PRIORITY_UPD;
CREATE TRIGGER SET_PRIORITY_UPD AFTER  UPDATE OF SOFTWARE_CATEGORY_ID ON SOFTWARE  REFERENCING  OLD AS oldrow  NEW AS newrow  FOR EACH ROW  MODE DB2SQL BEGIN ATOMIC if (newrow.software_category_id != oldrow.software_category_id) then update software set software.priority = (select count(*) from software  as c where newrow.software_category_id = c.software_category_id ) where  software.software_id = newrow.software_id;update software set software.priority  = software.priority - 1 where priority > oldrow.priority and software.software_category_id = oldrow.software_category_id;end if;END;

DROP TRIGGER SETPRIORITY;
CREATE TRIGGER SETPRIORITY NO CASCADE BEFORE  INSERT  ON SOFTWARE  REFERENCING  NEW AS newrow  FOR EACH ROW  MODE DB2SQL BEGIN ATOMIC set newrow.priority = ((select count(*) from software  as c where newrow.software_category_id = c.software_category_id)  +  1 ); END;

--DROP TRIGGER MANUF_UPDATE;
--CREATE TRIGGER MANUF_UPDATE NO CASCADE BEFORE  UPDATE  ON MANUFACTURER  REFERENCING  NEW AS newrow  FOR EACH ROW  MODE DB2SQL BEGIN ATOMIC set newrow.RECORD_TIME = (current timestamp); END;

DROP TRIGGER CHECK_DELETE;
CREATE TRIGGER CHECK_DELETE NO CASCADE BEFORE  DELETE  ON SOFTWARE_CATEGORY  REFERENCING  OLD AS oldrow  FOR EACH ROW  MODE DB2SQL BEGIN ATOMIC declare UNKNOWN_ID INTEGER; set UNKNOWN_ID = (select software_category_id  from software_category as c where c.software_category_name = 'UNKNOWN'); if (UNKNOWN_ID is null) then SIGNAL SQLSTATE '70001'  ('UNKNOWN software category does not exist'); end if; if (oldrow.software_category_name = 'UNKNOWN') then SIGNAL SQLSTATE '70001'  ('UNKNOWN software category can not be removed'); end if; END;

DROP TRIGGER CHECK_DELETE_MANF;
CREATE TRIGGER CHECK_DELETE_MANF NO CASCADE BEFORE  DELETE  ON MANUFACTURER  REFERENCING  OLD AS oldrow  FOR EACH ROW  MODE DB2SQL BEGIN ATOMIC declare UNKNOWN_ID INTEGER; set UNKNOWN_ID = (select manufacturer_id from manufacturer as c where c.manufacturer_name = 'UNKNOWN'); if (UNKNOWN_ID is null) then SIGNAL SQLSTATE '70001'  ('UNKNOWN manufacturer does not exist'); end if; if (oldrow.manufacturer_name = 'UNKNOWN') then SIGNAL SQLSTATE '70001'  ('UNKNOWN manufacturer can not be removed'); end if; END;

--DROP TRIGGER SIG_HISTORY_UPDATE;
--CREATE TRIGGER SIG_HISTORY_UPDATE AFTER  UPDATE  ON SOFTWARE_SIGNATURE  REFERENCING  OLD AS oldrow  OLD_TABLE AS newrow  FOR EACH ROW  MODE DB2SQL insert into SOFTWARE_SIGNATURE_H values (oldrow.software_signature_id,oldrow.software_id,oldrow.tcm_id,oldrow.file_name,oldrow.file_size,oldrow.software_version,oldrow.signature_source,oldrow.checksum_quick,oldrow.checksum_crc32,oldrow.checksum_md5,oldrow.remote_user,CURRENT TIMESTAMP,oldrow.status);

--DROP TRIGGER NEW_FILTER;
--CREATE TRIGGER NEW_FILTER NO CASCADE BEFORE  INSERT  ON SOFTWARE_FILTER  REFERENCING  NEW AS newrow  FOR EACH ROW  MODE DB2SQL BEGIN ATOMIC set newrow.status = 'NEW'; END;

--DROP TRIGGER FLT_HISTORY_UPDATE;
--CREATE TRIGGER FLT_HISTORY_UPDATE AFTER  UPDATE  ON SOFTWARE_FILTER  REFERENCING  OLD AS oldrow  OLD_TABLE AS newrow  FOR EACH ROW  MODE DB2SQL insert into SOFTWARE_FILTER_H values (oldrow.software_filter_id,oldrow.software_id,oldrow.software_name,oldrow.software_version,oldrow.map_software_version,oldrow.remote_user,CURRENT TIMESTAMP,oldrow.status);