#!/usr/local/bin/expect
# This script takes 3 arguments, hostname, username, password and return output of "df -h" on STDOUT
set host [lindex $argv 0]
set user [lindex $argv 1]
set pass [lindex $argv 2]
spawn  ssh $user@$host "df -h"
expect "password:"
send "$pass\n";
interact

