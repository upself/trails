#!/bin/sh

geo=( AP EUROPE GCG NA LA MEA UNKNOWN JAPAN )
n=1
for g in "${geo[@]}" 
do
		cp base $g$n.sql
		sed -i "s/:geo:/$g/g" $g$n.sql
done
