#!/bin/sh

# Usage: db2_cr_node.sh rtptstxteca01.raleigh.ibm.com TEC tsttecnd tsttec 50000

DB2SVR="$1"
DB2SVRDB="$2"

MYNODE="$3"
MYDB="$4"

DB2PORT=$5
INSTID="tap"

umask 022

echo "Cataloging Node for $MYNODE..."
su - $INSTID "-c db2 catalog tcpip node $MYNODE remote $DB2SVR server $DB2PORT"
echo "Cataloging Database for $MYDB..."
su - $INSTID "-c db2 catalog database $DB2SVRDB as $MYDB at node $MYNODE"

exit 0