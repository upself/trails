. /home/eaadmin/sqllib/db2profile;
if [ ! -d /tmp/report ]
then
	mkdir /tmp/report;
fi
cd /opt/staging/v2;
./reconSummary.pl
mutt -a /tmp/report/reconSum.tsv -s "Recon Summary Report" jain@us.ibm.com lisar@us.ibm.com lamora@us.ibm.com antucker@us.ibm.com yankee@us.ibm.com darcyb@us.ibm.com jadams2@us.ibm.com < /opt/staging/v2/scripts/reconSummaryEmailText
