#!/bin/sh

LOG="/home/liuhaidl/working/scripts/trailsServerFileSystemUsedDiskInfo.txt"
hLOG="/home/liuhaidl/working/scripts/trailsServerFileSystemUsedDiskInfoHistory.txt"
HOSTNAME="TRAILS.BOULDER.IBM.COM"

df -h | grep '[0-9]%' > ${LOG}
echo "TRAILS Server '${HOSTNAME}' Disc Utilization Alerts captured $(date)" >> ${hLOG}
df -h | grep '[0-9]%' >> ${hLOG}