--step 1, add the new column.
ALTER TABLE eaadmin.scarlet_reconcile ADD reconcile_md5_hex VARCHAR(50);

--setp 2, execute the perl script setMd5HexForReconcile.pl under path /opt/staging/v2
./setMd5HexForReconcile.pl

--step 3, set the column not null. 
ALTER TABLE eaadmin.scarlet_reconcile ALTER COLUMN reconcile_md5_hex SET NOT NULL;

reorg table eaadmin.scarlet_reconcile