#!/bin/sh
me=$$
(sleep 30; kill $me >/dev/null 2>&1) & nuker=$!
openssl s_client -crlf -connect $1
kill $nuker >/dev/null 2>&1
