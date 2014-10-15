#!/bin/sh -x

#
# config vars
#
ENVFILE="/db2/tap/sqllib/db2profile"
PROGRAM="amreports_batch.pl"
LOGFILE="/var/amreports/logs/amreports_batch.log"
NOTIFY="9194236772@messaging.sprintpcs.com"

#
# functions
#
function is_pid_running {
    local pid="$1"
    if [ -z "$pid" -o "$pid" == " " ]; then return 0; fi
    if [ ! -e /proc/$pid ]; then return 0; fi
    return 1
}

function is_running {
    if [ -f $PIDFILE ]
    then
        local pid=`cat $PIDFILE`
        if [ -z "$pid" -o "$pid" == " " ]; then return 0; fi
        if [ ! -e /proc/$pid ]; then return 0; fi
    else
        return 0
    fi
    return 1
}

function setup_env {
    local envfile="$1"
    if [ -z "$envfile" -o "$envfile" == " " ]; then return 0; fi
    . $envfile
    return 1
}

function start_program {
    local program="$1"
    local logfile="$1"
    if [ -z "$program" -o "$program" == " " ]; then return 0; fi
    if [ -z "$logfile" -o "$logfile" == " " ]; then return 0; fi
    nohup $program >$logfile 2>&1 & echo $! >$PIDFILE
    sleep 1
    pid=`cat $PIDFILE`
    is_pid_running "$pid"
    if [ $? -eq 0 ]
    then
        rm -f $PIDFILE
        return 0
    fi
    return 1
}

#
# main
#

# set working dir no matter how called
WRKDIR=`dirname $0`
cd $WRKDIR

# set pidfile
PIDFILE="$WRKDIR/$PROGRAM.pid"

# start program if not already started
is_running
if [ $? -eq 0 ]
then
    setup_env "$ENVFILE"
    start_program "$PROGRAM" "$LOGFILE"
    if [ $? -eq 0 ]
    then
        MSG="ERROR: Unable to start $PROGRAM"
        #echo "$MSG" |mail -s "$MSG" $NOTIFY
        echo "$MSG"
    fi
fi

exit 0
