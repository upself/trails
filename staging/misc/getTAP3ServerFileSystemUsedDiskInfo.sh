#!/bin/sh

LOG="/home/liuhaidl/working/scripts/TAP3ServerFileSystemUsedDiskInfo.txt"
hLOG="/home/liuhaidl/working/scripts/TAP3ServerFileSystemUsedDiskInfoHistory.txt"
HOSTNAME="TAP3.BOULDER.IBM.COM"

df -h | grep '[0-9]%' > ${LOG}
echo "Server '${HOSTNAME}' Disc Utilization Alerts captured $(date)" >> ${hLOG}
df -h | grep '[0-9]%' >> ${hLOG}
