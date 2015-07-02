DROP TABLE EAADMIN.REPORT_DELIVERY_TRACKING
;
DROP TABLE EAADMIN.REPORT_DELIVERY_TRACKING_H
;
------------------------------------------------
-- DDL Statements for table "EAADMIN "."REPORT_DELIVERY_TRACKING"
------------------------------------------------

 CREATE TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING"  (
                  "ID" BIGINT NOT NULL ,
                  "CUSTOMER_ID" BIGINT NOT NULL ,
                  "LAST_DELIVERY" TIMESTAMP  NOT NULL ,
                  "REPORTING_CYCLE" VARCHAR(32) NOT NULL ,
                  "NEXT_DELIVERY" TIMESTAMP NOT NULL ,
                  "QMX_REFERENCE" VARCHAR(225) NOT NULL ,
                  "REMOTE_USER"	VARCHAR(32) NOT NULL,
                  "RECORD_TIME" TIMESTAMP  NOT NULL)
                 DATA CAPTURE CHANGES
                 IN "MISC" INDEX IN "MISCINDEX" ;
				 
------------------------------------------------
-- DDL Statements for table "EAADMIN "."REPORT_DELIVERY_TRACKING_H"
------------------------------------------------
COMMIT WORK;

 CREATE TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING_H"  (
                  "ID" BIGINT NOT NULL ,
				  "REPORT_DELIVERY_TRACKING_ID" BIGINT NOT NULL,
				  "CUSTOMER_ID" BIGINT NOT NULL ,
                  "LAST_DELIVERY" TIMESTAMP  NOT NULL ,
                  "REPORTING_CYCLE" VARCHAR(32) NOT NULL ,
                  "NEXT_DELIVERY" TIMESTAMP NOT NULL ,
                  "QMX_REFERENCE" VARCHAR(225) NOT NULL ,
                  "REMOTE_USER"	VARCHAR(32) NOT NULL,
                  "RECORD_TIME" TIMESTAMP  NOT NULL)
                 DATA CAPTURE CHANGES
                 IN "MISC" INDEX IN "MISCINDEX" ;

COMMIT WORK;				 
-- DDL Statements for indexes on Table "EAADMIN "."REPORT_DELIVERY_TRACKING"

CREATE INDEX "EAADMIN "."IDXRETDETRACCSCY01" ON "EAADMIN "."REPORT_DELIVERY_TRACKING"
                ("CUSTOMER_ID" ASC,
                 "REPORTING_CYCLE" ASC) ALLOW REVERSE SCANS;

-- DDL Statements for indexes on Table "EAADMIN "."REPORT_DELIVERY_TRACKING"

CREATE UNIQUE INDEX "EAADMIN "."IDUCUSTOMERID" ON "EAADMIN "."REPORT_DELIVERY_TRACKING"
                ("ID" ASC,
				 "CUSTOMER_ID" ASC) CLUSTER ALLOW REVERSE SCANS;

-- DDL Statements for primary key on Table "EAADMIN "."REPORT_DELIVERY_TRACKING"

ALTER TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING"
        ADD CONSTRAINT "CSIDREPDTRACK" PRIMARY KEY
                ("ID");


COMMIT WORK;

-- DDL Statements for primary key on Table "EAADMIN "."REPORT_DELIVERY_TRACKING_H"

ALTER TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING_H"
        ADD CONSTRAINT "CSNONINSTANCEHT" PRIMARY KEY
                ("ID");

COMMIT WORK
;

--------- Privilege for REPORT_DELIVERY_TRACKING ------
GRANT REFERENCES ON TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING"      TO GROUP "TRAILUPD" ;       
GRANT SELECT ON TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING"          TO GROUP "TRAILSTG" ;     
----------- Privilege for REPORT_DELIVERY_TRACKING_H -------                                                                                           
GRANT REFERENCES ON TABLE "EAADMIN "."REPORT_DELIVERY_TRACKING_H"    TO GROUP "TRAILUPD" ;     
GRANT SELECT ON  TABLE     "EAADMIN "."REPORT_DELIVERY_TRACKING_H"   TO GROUP "TRAILSTG" ;     
        


COMMIT WORK;

CONNECT RESET;

TERMINATE;