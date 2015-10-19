#!/bin/bash
qty=`ps -ef|grep $1|wc -l`
echo "`date` , $qty"