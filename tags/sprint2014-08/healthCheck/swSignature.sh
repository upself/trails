#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=/gsa/pokgsa/projects/e/emea_assets/$BASESTR.bravo
EXPORTSTAGING=/gsa/pokgsa/projects/e/emea_assets/$BASESTR.staging
DIFFBRAVO=/gsa/pokgsa/projects/e/emea_assets/stagingSwSignatureNotInBravo.txt
DIFFSTAGING=/gsa/pokgsa/projects/e/emea_assets/bravoSwSignatureNotInStaging.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
	"select distinct customer.customer_id, name, bank_account_id, software_id from customer, \
	installed_software, software_lpar, installed_signature where \
	installed_software.id = installed_signature.installed_software_id \
	and installed_software.software_lpar_id = software_lpar.id \
	and software_lpar.customer_id = customer.customer_id \
	and software_lpar.status = 'ACTIVE' \
	and customer.status = 'ACTIVE' \
	with ur"    
db2 disconnect $DBBRAVO
set +x

# export staging data
set -x
db2 connect to $DBSTAGING user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTSTAGING of del \
    modified by nochardel coldel\| \
    "select software_lpar.customer_id, software_lpar.name, \
scan_record.bank_account_id, software_signature.software_id \
from software_lpar_map, software_lpar, scan_record, software_signature \
where \
software_lpar_map.software_lpar_id = software_lpar.id \
and software_lpar_map.scan_record_id = scan_record.id \
and software_signature.scan_record_id = scan_record.id \
    with ur"
db2 disconnect $DBSTAGING
set +x

awk -F"|" '
NR==FNR{a[$1$2$3$4]=$1$2$3$4;next}
a[$1$2$3$4]==$1$2$3$4{next}
a[$1$2$3$4]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Bravo software lpar / software not in staging"}
' $EXPORTSTAGING $EXPORTBRAVO > $DIFFSTAGING

awk -F"|" '
NR==FNR{a[$1$2$3$4]=$1$2$3$4;next}
a[$1$2$3$4]==$1$2$3$4{next}
a[$1$2$3$4]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Staging software lpar / software not in BRAVO"}
' $EXPORTBRAVO $EXPORTSTAGING > $DIFFBRAVO

chmod 644 $DIFFBRAVO
chmod 644 $DIFFSTAGING

#mv $DIFFBRAVO $LOGDIR
#mv $DIFFSTAGING $LOGDIR

exit 0
