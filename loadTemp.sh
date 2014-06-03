#!/bin/sh
TEMPFILE=/tmp/tempSignature_$1.csv
TEMPTABLE=TEMP_SIGNATURE_$1

db2 connect to staging user eaadmin using apr03db2
db2 "load from $TEMPFILE of del replace into $TEMPTABLE NONRECOVERABLE"
db2 terminate

