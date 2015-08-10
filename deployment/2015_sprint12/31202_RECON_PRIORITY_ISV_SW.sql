DROP TABLE EAADMIN.RECON_PRIORITY_ISV_SW;

CREATE TABLE EAADMIN.RECON_PRIORITY_ISV_SW(
        CUSTOMER_ID          BIGINT,
        MANUFACTURER_ID      BIGINT NOT NULL ,
        ID                   BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY(
                    START WITH +1
                    INCREMENT BY +1
                    MINVALUE +1
                    MAXVALUE +9223372036854775807
                    NO CYCLE
                    CACHE 20
                    NO ORDER ),
        ACTION               VARCHAR(32) NOT NULL,
        REMOTE_USER          VARCHAR(32) NOT NULL,
        RECORD_TIME          TIMESTAMP NOT NULL
)
DATA CAPTURE CHANGES
IN "RECON" INDEX IN "RECONINDEX" ;

CREATE UNIQUE INDEX UINDEX1_RECON_PRIORITY_ISV_SW ON "EAADMIN"."RECON_PRIORITY_ISV_SW"(ID);
CREATE UNIQUE INDEX UINDEX2_RECON_PRIORITY_ISV_SW ON "EAADMIN"."RECON_PRIORITY_ISV_SW"(CUSTOMER_ID,MANUFACTURER_ID);