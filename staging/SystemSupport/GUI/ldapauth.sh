#!/bin/bash

MAIL=$1
PW=$2
DN=`/usr/bin/ldapsearch -H 'ldap://bluepages.ibm.com' -b 'ou=bluepages,o=ibm.com' "(&(mail=$MAIL))" -x | grep dn | cut -d' ' -f2 `
#echo "$DN\n"
#echo "$PW\n"

AUTH=`/usr/bin/ldapsearch -H 'ldap://bluepages.ibm.com' -b 'ou=bluepages,o=ibm.com' "(&(mail=$MAIL))" -x -D $DN -w $PW | grep $MAIL | grep -v filter | cut -d' ' -f2 | uniq`
AUTH2="${AUTH%\\n}" 
echo $AUTH2

