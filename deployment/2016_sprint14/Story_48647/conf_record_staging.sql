DROP TABLE EAADMIN.CONFIG_RECORD;
------------------------------------------------
-- DDL Statements for Table "EAADMIN "."CONFIG_RECORD"
------------------------------------------------
 

CREATE TABLE "EAADMIN "."CONFIG_RECORD"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
			"NAME" VARCHAR(255) NOT NULL,
            "SERIAL_NUMBER" VARCHAR(128) NOT NULL,
            "SOFTWARE_LPAR_ID" BIGINT ,
            "VCPU" INTEGER,
            "VMWARE_CLUSTER" VARCHAR(255),
            "VM_CAN_MIGRATE" SMALLINT,
            "HYPER_THREADING" SMALLINT,
			"BANK_ACCOUNT_ID" BIGINT NOT NULL,
			"COMPUTER_ID" VARCHAR(255) NOT NULL,
			"ACTION" VARCHAR(32) 
)   
IN "SOFTWARELPAR" INDEX IN "INDEX1" ; 


-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE UNIQUE INDEX "EAADMIN "."IF1CONFIGIDRECORD" ON "EAADMIN "."CONFIG_RECORD" 
		("BANK_ACCOUNT_ID" ASC,
		 "NAME" ASC,
		 "SERIAL_NUMBER" ASC)		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE INDEX "EAADMIN "."IF2CONFIGIDRECORD" ON "EAADMIN "."CONFIG_RECORD" 
		("BANK_ACCOUNT_ID" ASC,
		 "ACTION" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE UNIQUE INDEX "EAADMIN "."IN01CFREIDPK" ON "EAADMIN "."CONFIG_RECORD" 
		("ID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;
-- DDL Statements for Primary Key on Table "EAADMIN "."CONFIG_RECORD"

ALTER TABLE "EAADMIN "."CONFIG_RECORD" 
	ADD CONSTRAINT "CT01CFREIDPK" PRIMARY KEY
		("ID");
-- DDL Statements for unique constraint on Table "EAADMIN "."CONFIG_RECORD"
 ALTER TABLE "EAADMIN "."CONFIG_RECORD" 
      ADD CONSTRAINT "UNI01CFREIDPK" UNIQUE(NAME, SERIAL_NUMBER, BANK_ACCOUNT_ID);


-- DDL Statements for Aliases based on Table "EAADMIN "."CONFIG_RECORD"

CREATE ALIAS "STAGING "."CONFIG_RECORD" FOR TABLE "EAADMIN "."CONFIG_RECORD";




--------------------------------------------
-- Authorization Statements on Tables/Views 
--------------------------------------------

 
GRANT DELETE ON TABLE "EAADMIN "."CONFIG_RECORD" TO USER "EAADMIN " ;

GRANT INSERT ON TABLE "EAADMIN "."CONFIG_RECORD" TO USER "EAADMIN " ;

GRANT SELECT ON TABLE "EAADMIN "."CONFIG_RECORD" TO USER "EAADMIN " ;

GRANT UPDATE ON TABLE "EAADMIN "."CONFIG_RECORD" TO USER "EAADMIN " ;


