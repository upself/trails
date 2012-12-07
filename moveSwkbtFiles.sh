#!/bin/sh

mv /var/ftp/swkbt/* /var/http_reports/SwKb/
chown www.www /var/http_reports/SwKb/*

find /var/http_reports/SwKb/* -mtime +14 -exec rm {} \;