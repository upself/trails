echo "trailspd_run_count.ksh started for trailspd on <`date '+%Y-%m-%d %H:%M:%S'`>!" > trailspd_run_count.log
db2 -tvf trailspd_run_count.sql >> trailspd_run_count.log
echo "trailspd_run_count.ksh complete for trailspd on <`date '+%Y-%m-%d %H:%M:%S'`>!" >> trailspd_run_count.log