DROP TABLE EAADMIN.PRIORITY_ISV_SW
;
DROP TABLE EAADMIN.PRIORITY_ISV_SW_H
;
------------------------------------------------
-- DDL Statements for table "EAADMIN "."PRIORITY_ISV_SW"
------------------------------------------------

 CREATE TABLE "EAADMIN "."PRIORITY_ISV_SW"  (
                  "ID" BIGINT NOT NULL,
                  "LEVEL" VARCHAR(8) NOT NULL ,
				  "CUSTOMER_ID" BIGINT ,
                  "MANUFACTURER_ID" BIGINT NOT NULL ,
                  "EVIDENCE_LOCATION" VARCHAR(128) NOT NULL ,
                  "STATUS_ID" BIGINT NOT NULL,
				  "BUSINESS_JUSTIFICATION" VARCHAR(256) NOT NULL,
                  "REMOTE_USER"	VARCHAR(32) NOT NULL,
                  "RECORD_TIME" TIMESTAMP  NOT NULL)
                 DATA CAPTURE CHANGES
                 IN "MISC" INDEX IN "MISCINDEX" ;
				 
------------------------------------------------
-- DDL Statements for table "EAADMIN "."PRIORITY_ISV_SW_H"
------------------------------------------------
COMMIT WORK;

 CREATE TABLE "EAADMIN "."PRIORITY_ISV_SW_H"  (
                  "ID" BIGINT NOT NULL ,
				  "PRIORITY_ISV_SW_ID" BIGINT NOT NULL ,
                  "LEVEL" VARCHAR(8) NOT NULL ,
				  "CUSTOMER_ID" BIGINT ,
                  "MANUFACTURER_ID" BIGINT NOT NULL ,
                  "EVIDENCE_LOCATION" VARCHAR(128) NOT NULL ,
                  "STATUS_ID" BIGINT NOT NULL,
				  "BUSINESS_JUSTIFICATION" VARCHAR(256) NOT NULL,
                  "REMOTE_USER"	VARCHAR(32) NOT NULL,
                  "RECORD_TIME" TIMESTAMP  NOT NULL)
                 DATA CAPTURE CHANGES
                 IN "MISC" INDEX IN "MISCINDEX" ;

COMMIT WORK;				 
-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW"

CREATE INDEX "EAADMIN "."IDXPRIORITYISV01" ON "EAADMIN "."PRIORITY_ISV_SW"
                ("MANUFACTURER_ID" ASC,
				 "LEVEL" ASC,
                 "CUSTOMER_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW"

CREATE INDEX "EAADMIN "."IDXPRIORITYISV21" ON "EAADMIN "."PRIORITY_ISV_SW"
                ("MANUFACTURER_ID" ASC,
                 "LEVEL" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW"

CREATE INDEX "EAADMIN "."IDXPRIORITYISV31" ON "EAADMIN "."PRIORITY_ISV_SW"
                ("MANUFACTURER_ID" ASC,
                 "CUSTOMER_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW"

CREATE UNIQUE INDEX "EAADMIN "."PKPRIORITYISV" ON "EAADMIN "."PRIORITY_ISV_SW"
                ("ID" ASC) CLUSTER ALLOW REVERSE SCANS;

-- DDL Statements for primary key on Table "EAADMIN "."PRIORITY_ISV_SW"
ALTER TABLE "EAADMIN "."PRIORITY_ISV_SW"
        ADD CONSTRAINT "CSPRIORITYISVSW" PRIMARY KEY
                ("ID");
COMMIT WORK;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW_H"

CREATE INDEX "EAADMIN "."IDXPRIORITYISVH11" ON "EAADMIN "."PRIORITY_ISV_SW_H"
                ("MANUFACTURER_ID" ASC,
				 "LEVEL" ASC,
                 "CUSTOMER_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW_H"

CREATE INDEX "EAADMIN "."IDXPRIORITYISVH21" ON "EAADMIN "."PRIORITY_ISV_SW_H"
                ("MANUFACTURER_ID" ASC,
                 "LEVEL" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW_H"

CREATE INDEX "EAADMIN "."IDXPRIORITYISVH31" ON "EAADMIN "."PRIORITY_ISV_SW_H"
                ("MANUFACTURER_ID" ASC,
                 "CUSTOMER_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW_H"

CREATE INDEX "EAADMIN "."IDXPRIORITYISVH41" ON "EAADMIN "."PRIORITY_ISV_SW_H"
                ("PRIORITY_ISV_SW_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."PRIORITY_ISV_SW_H"   

CREATE UNIQUE INDEX "EAADMIN "."PKPRIORITYISVH" ON "EAADMIN "."PRIORITY_ISV_SW_H"
                ("ID" ASC) CLUSTER ALLOW REVERSE SCANS;
-- DDL Statements for primary key on Table "EAADMIN "."PRIORITY_ISV_SW_H"
ALTER TABLE "EAADMIN "."PRIORITY_ISV_SW_H"
        ADD CONSTRAINT "CSPRIORITYISVSWH" PRIMARY KEY
                ("ID");
				
COMMIT WORK
;
--------- Privilege for PRIORITY_ISV_SW ------
GRANT REFERENCES ON TABLE "EAADMIN "."PRIORITY_ISV_SW"      TO GROUP "TRAILUPD" ;       
GRANT SELECT ON TABLE "EAADMIN "."PRIORITY_ISV_SW"          TO GROUP "TRAILSTG" ;     
----------- Privilege for PRIORITY_ISV_SW_H -------                                                                                           
GRANT REFERENCES ON TABLE "EAADMIN "."PRIORITY_ISV_SW_H"    TO GROUP "TRAILUPD" ;     
GRANT SELECT ON  TABLE     "EAADMIN "."PRIORITY_ISV_SW_H"   TO GROUP "TRAILSTG" ;     
        

COMMIT WORK;
