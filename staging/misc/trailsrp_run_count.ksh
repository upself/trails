echo "trailsrp_run_count.ksh started for trailsrp on <`date '+%Y-%m-%d %H:%M:%S'`>!" > trailsrp_run_count.log
db2 -tvf trailsrp_run_count.sql >> trailsrp_run_count.log
echo "trailsrp_run_count.ksh complete for trailsrp on <`date '+%Y-%m-%d %H:%M:%S'`>!" >> trailsrp_run_count.log