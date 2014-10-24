#!/bin/sh

set -x
tar -cvf /tmp/amreports.tar /opt/amreports
tar -rvf /tmp/amreports.tar /var/amreports
tar -rvf /tmp/amreports.tar /opt/IBMIHS/cgi-bin/amreports
set +x

exit 0
