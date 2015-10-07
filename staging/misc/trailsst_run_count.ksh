echo "trailsst_run_count.ksh started for trailsst on <`date '+%Y-%m-%d %H:%M:%S'`>!" > trailsst_run_count.log
db2 -tvf trailsst_run_count.sql >> trailsst_run_count.log
echo "trailsst_run_count.ksh complete for trailsst on <`date '+%Y-%m-%d %H:%M:%S'`>!" >> trailsst_run_count.log