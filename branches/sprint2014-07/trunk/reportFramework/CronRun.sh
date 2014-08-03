:
if [ -f /home/eaadmin/sqllib/db2profile ]; then
	. /home/eaadmin/sqllib/db2profile
fi
DIR="/opt/reports/bin/"
REPORT=`basename "$1"`
fullName=$DIR$1
fullLog="/opt/reports/log/"$REPORT".log"
echo $fullName $fullLog
shift
$fullName $@ >$fullLog 2>&1

