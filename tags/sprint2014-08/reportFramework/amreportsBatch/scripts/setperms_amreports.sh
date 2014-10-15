#!/bin/sh

whoami=`whoami`
if [ "$whoami" != "root" ]
then
	echo "Must be root to execute!"
	exit 1
fi

set -x
chown -R root /opt/IBMIHS/cgi-bin/amreports
chgrp -R root /opt/IBMIHS/cgi-bin/amreports
chmod -R 755 /opt/IBMIHS/cgi-bin/amreports

chown -R eaadmin /opt/amreports
chgrp -R eadt /opt/amreports
chmod -R 775 /opt/amreports

chown -R eaadmin /var/amreports
chgrp -R eadt /var/amreports
chmod -R 775 /var/amreports
set +x

exit 0
