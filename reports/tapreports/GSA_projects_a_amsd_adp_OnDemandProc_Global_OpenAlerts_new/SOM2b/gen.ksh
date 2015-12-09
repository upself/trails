#!/bin/ksh

set -A geo AP EUROPE GCG NA LA MEA UNKNOWN JAPAN
n=3
for g in "${geo[@]}" 
do
		cp base $g$n.sql
		sed "s/:geo:/$g/g" <$g$n.sql >temp.$$ && mv temp.$$ $g$n.sql
done
