:

if [ -f /db2/tap/sqllib/db2profile ]; then
	. /db2/tap/sqllib/db2profile
fi

cd /home/dbryson/fullRecon2
/home/dbryson/gsa_web.sh
/usr/bin/perl fullReconDriver2.pl
