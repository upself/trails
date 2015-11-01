DROP TABLE EAADMIN.SCARLET_RECONCILE
;
------------------------------------------------
-- DDL Statements for table "EAADMIN "."SCARLET_RECONCILE"
------------------------------------------------
CREATE TABLE "EAADMIN"."SCARLET_RECONCILE" (
		"ID" BIGINT NOT NULL,
		"LAST_VALIDATE_TIME" TIMESTAMP NOT NULL
	)
                 DATA CAPTURE CHANGES
                 IN "RECON" INDEX IN "RECONINDEX" ;
------------------------------------------------
-- DDL Statements for table "EAADMIN "."SCARLET_RECONCILE"
------------------------------------------------
COMMIT WORK;

-- DDL Statements for indexes on Table "EAADMIN "."SCARLET_RECONCILE"

CREATE UNIQUE INDEX "EAADMIN "."PKSCARLETRECONCILE11" ON "EAADMIN "."SCARLET_RECONCILE"
                ("ID" ASC) CLUSTER ALLOW REVERSE SCANS;
                
-- DDL Statements for indexes on Table "EAADMIN "."SCARLET_RECONCILE"

CREATE INDEX "EAADMIN "."IDXSCARLETRECONCILE11" ON "EAADMIN "."SCARLET_RECONCILE"
                ("ID" ASC, 
                "LAST_VALIDATE_TIME" ASC) ALLOW REVERSE SCANS;               
             
-- DDL Statements for primary key on Table "EAADMIN "."SCARLET_RECONCILE"

ALTER TABLE "EAADMIN "."SCARLET_RECONCILE"
        ADD CONSTRAINT "CSSCARLETRECONCILE" PRIMARY KEY
                ("ID");

COMMIT WORK;

---------- Privilege For SCARLET_RECONCILE ----------
GRANT REFERENCES ON TABLE "EAADMIN "."SCARLET_RECONCILE"      TO GROUP "TRAILRPT" ; 
GRANT SELECT ON TABLE "EAADMIN "."SCARLET_RECONCILE"          TO GROUP "TRAILRPT" ;      
GRANT REFERENCES ON TABLE "EAADMIN "."SCARLET_RECONCILE"      TO USER eaadmin ;       
GRANT SELECT ON TABLE     "EAADMIN "."SCARLET_RECONCILE"      TO USER eaadmin ; 

COMMIT WORK;





