DROP TABLE EAADMIN.NON_INSTANCE
;
DROP TABLE EAADMIN.NON_INSTANCE_H
;
------------------------------------------------
-- DDL Statements for table "EAADMIN "."NON_INSTANCE"
------------------------------------------------

 CREATE TABLE "EAADMIN "."NON_INSTANCE"  (
                  "ID" BIGINT NOT NULL,
                  "SOFTWARE_ID" BIGINT NOT NULL ,
                  "MANUFACTURER_ID" BIGINT NOT NULL ,
                  "RESTRICTION" VARCHAR(8) NOT NULL ,
                  "CAPACITY_TYPE_CODE" SMALLINT NOT NULL ,
                  "BASE_ONLY" SMALLINT NOT NULL ,
                  "STATUS_ID" BIGINT NOT NULL ,
				  "REMOTE_USER"	VARCHAR(32) NOT NULL,
                  "RECORD_TIME" TIMESTAMP  NOT NULL)
                 DATA CAPTURE CHANGES
                 IN "MISC" INDEX IN "MISCINDEX" ;
				 
------------------------------------------------
-- DDL Statements for table "EAADMIN "."NON_INSTANCE_H"
------------------------------------------------
COMMIT WORK;

 CREATE TABLE "EAADMIN "."NON_INSTANCE_H"  (
                  "ID" BIGINT NOT NULL ,
				  "NON_INSTANCE_ID" BIGINT NOT NULL ,
                  "SOFTWARE_ID" BIGINT NOT NULL ,
                  "MANUFACTURER_ID" BIGINT NOT NULL ,
                  "RESTRICTION" VARCHAR(8) NOT NULL ,
                  "CAPACITY_TYPE_CODE" SMALLINT NOT NULL ,
                  "BASE_ONLY" SMALLINT NOT NULL ,
                  "STATUS_ID" BIGINT NOT NULL ,
				  "REMOTE_USER"	VARCHAR(32) NOT NULL,
                  "RECORD_TIME" TIMESTAMP  NOT NULL)
                 DATA CAPTURE CHANGES
                 IN "MISC" INDEX IN "MISCINDEX" ;

COMMIT WORK;				 
-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCESW11" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCERE21" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
				 "RESTRICTION" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCECC31" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "CAPACITY_TYPE_CODE" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCEBS41" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "BASE_ONLY" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCESW12" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
				 "RESTRICTION" ASC,
                 "BASE_ONLY" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCESW13" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "CAPACITY_TYPE_CODE" ASC,
                 "BASE_ONLY" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCESW14" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "CAPACITY_TYPE_CODE" ASC,
				 "RESTRICTION" ASC,
                 "BASE_ONLY" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCESW15" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "BASE_ONLY" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE INDEX "EAADMIN "."IDXNONINSTANCECC32" ON "EAADMIN "."NON_INSTANCE"
                 ("CAPACITY_TYPE_CODE" ASC,
				 "RESTRICTION" ASC,
                 "BASE_ONLY" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE"

CREATE UNIQUE INDEX "EAADMIN "."PKNONINSTANCE" ON "EAADMIN "."NON_INSTANCE"
                ("ID" ASC) CLUSTER ALLOW REVERSE SCANS;

-- DDL Statements for primary key on Table "EAADMIN "."NON_INSTANCE"

ALTER TABLE "EAADMIN "."NON_INSTANCE"
        ADD CONSTRAINT "CSNONINSTANCE" PRIMARY KEY
                ("ID");
				
-- DDL Statements for unique index for SFOTWARE_ID plus CAPACITY_TYPE_CODE 			
CREATE UNIQUE INDEX "EAADMIN "."IFUSWIDCAPCODEID01" ON "EAADMIN "."NON_INSTANCE"
                ("SOFTWARE_ID" ASC,
                 "CAPACITY_TYPE_CODE" ASC) ALLOW REVERSE SCANS;

COMMIT WORK;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE_H"

CREATE INDEX "EAADMIN "."IDXNONINSTANCEHSW11" ON "EAADMIN "."NON_INSTANCE_H"
                ("SOFTWARE_ID" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE_H"

CREATE INDEX "EAADMIN "."IDXNONINSTANCEHRE21" ON "EAADMIN "."NON_INSTANCE_H"
                ("SOFTWARE_ID" ASC,
				 "RESTRICTION" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE_H"

CREATE INDEX "EAADMIN "."IDXNONINSTANCEHCC31" ON "EAADMIN "."NON_INSTANCE_H"
                ("SOFTWARE_ID" ASC,
                 "CAPACITY_TYPE_CODE" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE_H"

CREATE INDEX "EAADMIN "."IDXNONINSTANCEHBS41" ON "EAADMIN "."NON_INSTANCE_H"
                ("SOFTWARE_ID" ASC,
                 "BASE_ONLY" ASC,
                 "STATUS_ID" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE_H"

CREATE INDEX "EAADMIN"."IDXNONINSTANCEHP01" ON "EAADMIN "."NON_INSTANCE_H"                                            
   ("NON_INSTANCE_ID" ASC) ALLOW REVERSE SCANS COLLECT SAMPLED DETAILED STATISTICS;    

-- DDL Statements for indexes on Table "EAADMIN "."NON_INSTANCE_H"   

CREATE UNIQUE INDEX "EAADMIN "."PKNONINSTANCEHT" ON "EAADMIN "."NON_INSTANCE_H"
                ("ID" ASC) CLUSTER ALLOW REVERSE SCANS;

-- DDL Statements for primary key on Table "EAADMIN "."NON_INSTANCE_H"

ALTER TABLE "EAADMIN "."NON_INSTANCE_H"
        ADD CONSTRAINT "CSNONINSTANCEHT" PRIMARY KEY
                ("ID");

COMMIT WORK
;
--------- Privilege for Non_instance ------
GRANT REFERENCES ON TABLE "EAADMIN "."NON_INSTANCE"      TO GROUP "TRAILUPD" ;       
GRANT SELECT ON TABLE "EAADMIN "."NON_INSTANCE"          TO GROUP "TRAILSTG" ;     
----------- Privilege for Non_instance_h -------                                                                                           
GRANT REFERENCES ON TABLE "EAADMIN "."NON_INSTANCE_H"    TO GROUP "TRAILUPD" ;     
GRANT SELECT ON  TABLE     "EAADMIN "."NON_INSTANCE_H"   TO GROUP "TRAILSTG" ;     
        

COMMIT WORK;

CONNECT RESET;

TERMINATE;