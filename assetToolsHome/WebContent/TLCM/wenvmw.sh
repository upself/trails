################################################################################
## 	Licensed Materials - Property of IBM
##
##    TIVOCIT00
##
## 	(C) Copyright IBM Corp. 2005-2007 All Rights Reserved.
##
##	US Government Users Restricted Rights - Use, duplication,
## 	or disclosure restricted by GSA ADP Schedule Contract with
## 	IBM Corp.
##
################################################################################

#!/bin/sh

# VMware Server was found and is a supported version
VMWARE_FOUND=0

# VMware Server not found on host system
VMWARE_NOT_FOUND=100

# VMware Server version is not compliant
VMWARE_NOT_SUPPORTED=105

# VmPerl Scripting API not found or configured properly
VMPERL_NOT_FOUND=120

function usage()
{
    echo "Usage: $1 [-v | --verbose | --debug]"
}

# redirects output to a file
function verbose()
{
    if [ $VERBOSE -eq 1 ]; then
        echo $1 >> $OUTPUTFILE
    fi
}

function do_exit()
{
    if [ -z "$CACHE_LD_LIBRARY_PATH" ]; then
        unset -v LD_LIBRARY_PATH
    else
        LD_LIBARY_PATH=$CACHE_LD_LIBRARY_PATH
    fi

    exit $1
}

# checks if a VMware Server is available
function checkVMware()
{
    # if VMware ESX 2.5.x Server is installed via RPM this variable is not empty
    VMWAREESX_RPM=`rpm -qa | grep -i vmware-esx-[2-3]\.[0-9]\..-`

    # if VMware GSX 3.[1-9].x Server is installed via RPM this variable is not empty
    VMWAREGSX_RPM=`rpm -qa | grep -i vmware-gsx-[2-3]\.[1-9]\..-`

    # if VMware GSX 3.[1-9].x Server is installed via RPM this variable is not empty
    VMWARESERVER_RPM=`rpm -qa | grep -i vmware-server-1\.[0-9]\..-`

    # checks for a non RPM installation of VMware Servers
    if [ -z "$VMWAREESX_RPM" ] && [ -z "$VMWAREGSX_RPM" ] && [ -z "$VMWARESERVER_RPM" ]; then

        #check if "wmware" command can be called from everywhere
        which vmware > /dev/null 2>&1

        # the command runs successful
        if [ $? -eq 0 ]; then

            # tries to obtain VMware ESX Server version
            VMWAREESX_VER=`vmware -v | grep -i vmware\ esx\ server\ [2-3]\.[0-9]\..`

            # tries to obtain VMware GSX Server version
            VMWAREGSX_VER=`vmware -v | grep -i vmware\ gsx\ server\ 3\.[1-9]\..`

            # tries to obtain VMware GSX Server version
            VMWARESERVER_VER=`vmware -v | grep -i vmware\ server\ 1\.[0-9]\..`

            # checks for enabler supported versions
            if [ -z "$VMWAREESX_VER" ] && [ -z "$VMWAREGSX_VER" ] && [ -z "$VMWARESERVER_VER" ]; then

                verbose "OK: only VMware GSX 3.[1-9].x or ESX 2.5.x , ESX 3.x or VMvare Server 1.x are supported."
                return $VMWARE_NOT_SUPPORTED
            else
                verbose "OK: found VMware GSX 3.[1-9].x or ESX 2.5.x or ESX 3.x or VMware Server 1.X non RPM installation."
            fi
        else
            verbose "OK: VMware GSX or ESX or VMware Server not found on this system."
            return $VMWARE_NOT_FOUND
        fi
    else
        verbose "OK: found VMware GSX 3.1+ or ESX 2.5.x or ESX 3.x or VMware Server 1.X RPM installation."
    fi
    
    #check if VmPerl API is installed

    perl -e 'use VMware::VmPerl;' >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        verbose "ERROR: VmPerl Scripting API not installed."
        return $VMPERL_NOT_FOUND
    fi

    return $VMWARE_FOUND;
}

if [ $# -gt 1 ]; then
    usage $0
    do_exit -1
fi

if [ $# -eq 1 ] && [ "$1" != "-v" ] && [ "$1" != "--verbose" ] && [ "$1" != "--debug" ]; then
    usage $0
    do_exit -1
fi

# checks if CITENABLER_HOME is set
if [ -z $CITENABLER_HOME ]; then

    BASE_NAME=`basename $0`
    DIR_NAME=`dirname $0`

    cd $DIR_NAME

    if [ `pwd` != "/" ]; then
        FULL_NAME=`pwd`/$BASE_NAME
    else
        FULL_NAME=/$BASE_NAME
    fi

    # builds the home full path
    FULL_DIR=`dirname $FULL_NAME`
    CITENABLER_HOME=$FULL_DIR

    export CITENABLER_HOME

    cd -
fi

if [ ! -d $CITENABLER_HOME ]; then
    echo "$CITENABLER_HOME not exists or is not a directory"
    do_exit -1
fi

OUTPUTFILE="./en_out.txt"

if [ "$1" == "-v" ] || [ "$1" == "--verbose" ] || [ "$1" == "--debug" ]; then
    VERBOSE=1
else
    VERBOSE=0
fi

verbose "----------------------------------------------------------"
verbose "Started on `date`"
verbose "----------------------------------------------------------"

checkVMware
VMWARE_CHECK=$?

# exits if VMware Server is not present
# or is it a not supported version
if [ $VMWARE_CHECK -ne $VMWARE_FOUND ]; then
    do_exit $VMWARE_CHECK
fi

# checks if dispatcher exists and is executable
if [ ! -x $CITENABLER_HOME/dispatcher ]; then
    verbose "ERROR: the file $CITENABLER_HOME/dispatcher does not exists or is not executable"
    do_exit -1
fi

#in case libstdc++ v.5 is not istalled in standard location, these are best guesses:
CACHE_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
declare -x LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/vmware/vpx:"

# checks if dmidecode is avalable
if [ ! -e /usr/sbin/dmidecode ]; then
    $CITENABLER_HOME/dispatcher $1
else
    $CITENABLER_HOME/dispatcher --dmidecode $1
fi

RC=$?

if [ $RC -ne 0 ]; then
    rm -f out
    verbose "ERROR: dispatcher return code = $RC"
    do_exit $RC
fi

do_exit 0
