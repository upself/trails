#!/bin/sh

###########################################################################
##
##	Author	:	Ondrej Zivnustka
##	Date	:	2014/09/30	
##
##	Description : Script generates SQL files for following alert reports:
##
##	<GEO>1_HW_No_LPAR_alert
##	<GEO>2_HW_LPAR_No_SW_LPAR_alert
##	<GEO>3_SW_LPAR_No_HW_LPAR_alert
##	<GEO>4_Outdated_SW_LPAR_alert
##	<GEO>5_Unlicensed_IBM_SW_alert
##	<GEO>6_Unlicensed_ISV_SW_alert
##
##
##	Help:
##	With first parametr 'clean' script just clean sql reports.
##	In other cases script generates new SQL files.
##
############################################################################

## 	Global array of reports.

REPORT[0]='HW_NO_LPAR:1'
REPORT[1]='HW_LPAR_NO_SW_LPAR:2'
REPORT[2]='SW_LPAR_NO_HW_LPAR:3'
REPORT[3]='OUTDATED_SW_LPAR:4'
REPORT[4]='UNLICENSED_IBM_SW:5'
REPORT[5]='UNLICENSED_ISV_SW:6'

##	Global array of GEOs.
GEO[0]='AG'
GEO[1]='AP'
GEO[2]='EMEA'
GEO[3]='EUROPE'
GEO[4]='GCG'
GEO[5]='JAPAN'
GEO[6]='LA'
GEO[7]='MEA'
GEO[8]='NA'
GEO[9]='UNKNOWN'

TMP=tmp.out

clean() {
	rm ./$1$3.sql
}

generate_report() {
	rm ./$1$3.sql
	cp ./$2 ./$1$3.sql
	sed "s/::GEO::/$1/g" ./$1$3.sql > $TMP && mv $TMP ./$1$3.sql
}

#############################################################################
##
##	Main
##
#############################################################################

if [ "$1" = "clean" ]
then
	for geo_name in "${GEO[@]}"
	do
		for report_type in "${REPORT[@]}"
		do
			NUMBER=${report_type#*:}
			NAME=${report_type%%:*}
			clean $geo_name $NAME $NUMBER
		done
	done

else

for geo_name in "${GEO[@]}"
do
	for report_type in "${REPORT[@]}"
	do
		NUMBER=${report_type#*:}
		NAME=${report_type%%:*}
		generate_report $geo_name $NAME $NUMBER
	done
done

fi
