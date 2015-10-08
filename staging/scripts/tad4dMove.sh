#/bin/bash
#
#
# This script will be used to monitor uploads to a specified directory
# and move them to another directory for downloading.
#
# Things to consider:
#       1. Was the uploaded files uploaded in a sub directory.
#       2. Are the files being uploaded complete.
#       3. Move the files to the specified directory
#          with the proper permissions.
#
#
#-------------------------------------------------------------------------------#
#
# Functions
#
#-------------------------------------------------------------------------------#
calc_time() {
        AGE_LAST_CHANGED=`expr ${CURRTIME} - ${FILE_LAST_CHANGED}`
        if [ ${AGE_LAST_CHANGED} -lt ${ACCEPTED_AGE} ];
        then
                OK_TO_MOVE=N
        else
                OK_TO_MOVE=Y
        fi
}
check_date() {
        FILE_LAST_CHANGED=`stat -t ${NEWFILE} |awk '{print $13}'`
}
#-------------------------------------------------------------------------------#
#
# Vairables will go here
#
#-------------------------------------------------------------------------------#
UPUSER=up_user
DOWNUSER=down_user
#
UPPATH=/var/ftp/scan/tad4d
DOWNPATH=/var/ftp/EMEA/SCANS_INCOMING

CURRTIME=`date +%s`
ACCEPTED_AGE=500        # 5 minutes of no activity according to date modified

find $UPPATH -name '* *' | while read i
do
 if test -n "$i" ; then
# echo " find it!"
           j=`echo -n "$i" | sed -e 's/ /_/'` # replace spaces of filename
           mv "$i" "$j"
fi
done

for f in $( ls ${UPPATH} ); do
#--- File is in Main Upload directory ---#
    if [ -f ${UPPATH}/$f ]; then
            NEWFILE=${UPPATH}/${f}
            echo "${NEWFILE} is a file"
            check_date
            calc_time

            if [ ${OK_TO_MOVE} = "Y" ];
            then
                    mv ${NEWFILE} ${DOWNPATH}
                    echo "mv ${NEWFILE} ${DOWNPATH} "
                    chgrp emeaweb ${DOWNPATH}/*
            else
                    echo "File date is too new to move better wait"
                    echo "next pass of cronjob should move this file"
            fi
    fi
done
