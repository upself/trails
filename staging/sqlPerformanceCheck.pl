#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;    
use Database::Connection;
use Base::ConfigManager;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/sqlPerformanceCheck/sqlPerformanceCheck.log";
my $pidFile    = "/tmp/sqlPerformanceCheck.pid";
my $configFile = "/opt/staging/v2/config/sqlPerformanceCheckConfig.txt";

###Initialize properties
my $cfgMgr       = Base::ConfigManager->instance($configFile);
my $server       = $cfgMgr->server;
my $testMode     = $cfgMgr->testMode;
my $applyChanges = $cfgMgr->applyChanges;
my $sleepPeriod  = $cfgMgr->sleepPeriod;

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
  unless validateServer($server);

###Make a daemon.
chdir "/tmp";
umask 0;
defined( my $pid = fork )
  or die "ERROR: Unable to fork: $!";
exit if $pid;
setsid or die "ERROR: Unable to setsid: $!";

####Handle usage and user action.
loaderStart( shift @ARGV, $pidFile );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

###Set the logging level
logging_level( $cfgMgr->debugLevel );

###Set the logfile
logfile($logfile);

###Set the job name of this script to update the status
my $job = 'SQL PERFORMANCE CHECK';
my $systemScheduleStatus;

###Wrap everything in an eval so we can capture in logfile.
eval {
    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    $| = 1;
    while (1) {

        ###Notify system schedule status that we are starting.
        dlog("job=$job");
        if ( $applyChanges == 1 ) {
            ###Notify the scheduler that we are starting
            ilog("starting $job system schedule status");
            $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
            ilog("started $job system schedule status");
        }

        ###Get a connection to bravo
        ilog("getting bravo db connection");
        my $bravoConnection = Database::Connection->new('trails');
        die "Unable to get bravo db connection!\n"
          unless defined $bravoConnection;
        ilog("got bravo db connection");

        ###Add lics with expired maint to recon queue.
        eval {
        	elog(" Start to perform No1 query satament " );
        	my $rc1 = exec_sql_rc( $bravoConnection, querySqlStamentNo1($testMode) );
        	elog(" Got the resultSet of No1 query satament" ) if defined $rc1;
        	
        	elog(" Start to perform No2 query satament " );
        	my $rc2 = exec_sql_rc( $bravoConnection, querySqlStamentNo2($testMode));
        	elog(" Got the resultSet of No2 query satament " ) if defined $rc2;
        	
        	elog(" Start to perform No3 query satament " );
        	my $rc3 = exec_sql_rc( $bravoConnection, querySqlStamentNo3($testMode));
        	elog(" Got the resultSet of No3 query satament " ) if defined $rc3;
        	
        	elog(" Start to perform No4 query satament " );
        	my $rc4 = exec_sql_rc( $bravoConnection, querySqlStamentNo4($testMode));
        	elog(" Got the resultSet of No4 query satament " ) if defined $rc4;
        	
        	elog(" Start to perform No5 query satament " );
        	my $rc5 = exec_sql_rc( $bravoConnection, querySqlStamentNo5($testMode));
        	elog(" Got the resultSet of No5 query satament " ) if defined $rc5;
        	
        	elog(" Start to perform No6 query satament " );
        	my $rc6 = exec_sql_rc( $bravoConnection, querySqlStamentNo6($testMode));
        	elog(" Got the resultSet of No6 query satament " ) if defined $rc6;

        };
        if ($@) {
            ###Close the bravo db connection
            ilog("disconnecting bravo db connection");
            $bravoConnection->disconnect;
           ilog("disconnected bravo db connection");
           die $@;
       }

        ###Close the bravo db connection
        ilog("disconnecting bravo db connection");
        $bravoConnection->disconnect;
        ilog("disconnected bravo db connection");

        ###Check if we should stop.
        last if loaderCheckForStop($pidFile) == 1;
        sleep $sleepPeriod;
    }
};
if ($@) {
    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we had an error
        ilog("erroring $job system schedule status");
        SystemScheduleStatusDelegate->error($systemScheduleStatus);
        ilog("errored $job system schedule status");
    }

    elog($@);
    die $@;
}
else {
    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we are stopping
        ilog("stopping $job system schedule status");
        SystemScheduleStatusDelegate->stop($systemScheduleStatus);
        ilog("stopped $job system schedule status");
    }
}

exit 0;

sub exec_sql_rc {
    my $dbconnection = shift;
    my $methodName = shift;
    my $method = shift;  
    my $rc ;
    ilog(" ***$methodName ***$method **  ");
    eval {
            $dbconnection->prepareSqlQuery( $methodName,$method );
            my $sth = $dbconnection->sql->{ $methodName };
           $rc = $sth->execute();
           $sth->finish;
    };
    if ($@) {
        die "Unable to execute sql command ($method): $@\n";
    }
    return $rc;
}

sub querySqlStamentNo1 {
    my ($testMode) = @_;
    my $query = 'select
hl.name as hostname
,hl.lpar_status
,mt.name as hwMachType 
,h.owner as hwOwner 
,h.country as hwCountry 
,mt.type as hwAssetType 
,h.hardware_status
,hl.lpar_status
,h.processor_count as hwProcCount 
,h.chips as hwChips
,h.serial as hwSerial 
from
eaadmin.hardware_lpar hl
inner join eaadmin.hw_sw_composite hsc on 
hl.id = hsc.hardware_lpar_id 
inner join eaadmin.hardware h on 
hl.hardware_id = h.id 
inner join eaadmin.machine_type mt on 
h.machine_type_id = mt.id 
and hl.customer_id = 5062
    ';
    return ( 'sqlStamentNo1', $query );
}

sub querySqlStamentNo2 {
    my ($testMode) = @_;
    my $query = 'select sl_customer.account_number, sl.name, instSi.name, disc.name 
from 
eaadmin.customer sl_customer
,eaadmin.software_lpar sl
inner join eaadmin.installed_software is on 
sl.id = is.software_lpar_id 
inner join eaadmin.DISCREPANCY_TYPE disc on
is.DISCREPANCY_TYPE_ID = disc.id
inner join eaadmin.product_info instPi on 
is.software_id = instPi.id 
inner join eaadmin.product instP on 
instPi.id = instP.id 
inner join eaadmin.software_item instSi on 
instP.id = instSi.id
inner join eaadmin.manufacturer instSwMan on 
instP.manufacturer_id = instSwMan.id  
left outer join eaadmin.KB_DEFINITION kbdef on instPi.ID=kbdef.ID
where
sl.customer_id = sl_customer.customer_id
and sl_customer.customer_id = 5062
with ur
    ';
    return ( 'sqlStamentNo2', $query );
}

sub querySqlStamentNo3 {
    my ($testMode) = @_;
    my $query = 'SELECT sl_customer.account_number,
CASE WHEN AUS.Open = 0 THEN \'Blue\' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN \'Red\' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN \'Yellow\' 
ELSE \'Green\' 
END 
,aus.creation_time 
, case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) 
else days(aus.record_time) - days(aus.creation_time) 
end 
,sl.name as swLparName 
,aus.remote_user as alertAssignee 
from 
eaadmin.customer sl_customer
,eaadmin.software_lpar sl
inner join eaadmin.installed_software is on sl.id = is.software_lpar_id 
inner join eaadmin.alert_unlicensed_sw aus on is.id = aus.installed_software_id 
where
sl.customer_id = sl_customer.customer_id
and sl_customer.customer_id = 5062
with ur
    ';
    return ( 'sqlStamentNo3', $query );
}

sub querySqlStamentNo4 {
    my ($testMode) = @_;
    my $query = 'select count(license0_.ID) as col_0_0_
from eaadmin.LICENSE license0_
left outer join eaadmin.LICENSE_SW_MAP license0_1_ on license0_.ID=license0_1_.LICENSE_ID
where license0_.ID in
(select license1_.ID
from eaadmin.LICENSE license1_
left outer join eaadmin.LICENSE_SW_MAP license1_1_ on license1_.ID=license1_1_.LICENSE_ID
inner join eaadmin.CUSTOMER account2_ on license1_.CUSTOMER_ID=account2_.CUSTOMER_ID
left outer join eaadmin.USED_LICENSE usedlicens3_ on license1_.ID=usedlicens3_.LICENSE_ID
where (account2_.CUSTOMER_ID = 5062)
and license1_.STATUS=\'ACTIVE\'
group by license1_.ID , license1_.QUANTITY
having coalesce(license1_.QUANTITY-sum(usedlicens3_.USED_QUANTITY), license1_.QUANTITY)>0)
with ur
    ';
    return ( 'sqlStamentNo4', $query );
}

sub querySqlStamentNo5 {
    my ($testMode) = @_;
    my $query = 'SELECT sl_customer.account_number,
CASE WHEN AUS.Open = 0 THEN \'Blue\' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN \'Red\' 
WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN \'Yellow\' 
ELSE \'Green\' 
END 
,aus.creation_time 
, case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) 
else days(aus.record_time) - days(aus.creation_time) 
end 
,sl.name as swLparName 
,h.serial as hwSerial 
,mt.name as hwMachType 
,h.owner as hwOwner 
,h.country as hwCountry 
,mt.type as hwAssetType 
,h.hardware_status
,hl.lpar_status
,h.processor_count as hwProcCount 
,h.chips as hwChips 
,case when sle.software_lpar_id is null then sl.processor_count else sle.processor_count end as swLparProcCount 
,instSi.name as instSwName 
,aus.remote_user as alertAssignee 
,aus.comments as alertAssComments 
,instSwMan.name as instSwManName 
,dt.name as instSwDiscrepName 
,case when rt.is_manual = 0 then rt.name || \'(AUTO)\' when rt.is_manual = 1 then rt.name || \'(MANUAL)\' end 
,r.remote_user as reconUser 
,r.record_time as reconTime 
,case when rt.is_manual = 0 then \'Auto Close\' when rt.is_manual = 1 then r.comments end as reconComments 
,parentSi.name as parentName 
,c.account_number as licAccount 
,l.full_desc as licenseDesc 
,case when l.id is null then \'\' 
when lsm.id is null then \'No\' 
else \'Yes\' end as catalogMatch 
,l.prod_name as licProdName 
,l.version as licVersion 
,CONCAT(CONCAT(RTRIM(CHAR(L.Cap_Type)), \'-\'), CT.Description) 
,ul.used_quantity  
,case when r.id is null then \'\' 
when r.machine_level = 0 then \'No\' 
else \'Yes\' end 
, REPLACE(RTRIM(CHAR(DATE(L.Expire_Date), USA)), \'/\', \'-\') 
,l.po_number 
,l.cpu_serial 
,case when l.ibm_owned = 0 then \'Customer\' 
when l.ibm_owned = 1 then \'IBM\' 
else \'\' end 
,l.ext_src_id ,l.record_time 
from  
eaadmin.software_lpar sl 
left outer join eaadmin.software_lpar_eff sle on 
sl.id = sle.software_lpar_id 
and sle.status = \'ACTIVE\' 
and sle.processor_count != 0 
inner join eaadmin.hw_sw_composite hsc on 
sl.id = hsc.software_lpar_id 
inner join eaadmin.hardware_lpar hl on 
hsc.hardware_lpar_id = hl.id 
inner join eaadmin.hardware h on 
hl.hardware_id = h.id 
inner join eaadmin.machine_type mt on 
h.machine_type_id = mt.id 
inner join eaadmin.installed_software is on 
sl.id = is.software_lpar_id 
inner join eaadmin.product_info instPi on 
is.software_id = instPi.id 
inner join eaadmin.product instP on 
instPi.id = instP.id 
inner join eaadmin.software_item instSi on 
instP.id = instSi.id 
inner join eaadmin.manufacturer instSwMan on 
instP.manufacturer_id = instSwMan.id 
inner join eaadmin.discrepancy_type dt on 
is.discrepancy_type_id = dt.id 
inner join eaadmin.alert_unlicensed_sw aus on 
is.id = aus.installed_software_id 
left outer join eaadmin.reconcile r on 
is.id = r.installed_software_id 
left outer join eaadmin.reconcile_type rt on 
r.reconcile_type_id = rt.id 
left outer join eaadmin.installed_software parent on 
r.parent_installed_software_id = parent.id 
left outer join eaadmin.product_info parentPi on 
parent.software_id = parentPi.id 
left outer join eaadmin.product parentP on 
parentPi.id = parentP.id 
left outer join eaadmin.software_item parentSi on 
parentSi.id = parentP.id 
left outer join eaadmin.reconcile_used_license rul on 
r.id = rul.reconcile_id 
left outer join eaadmin.used_license ul on 
rul.used_license_id = ul.id 
left outer join eaadmin.license l on 
ul.license_id = l.id 
left outer join eaadmin.license_sw_map lsm on 
l.id = lsm.license_id 
left outer join eaadmin.capacity_type ct on 
l.cap_type = ct.code 
left outer join eaadmin.customer c on 
l.customer_id = c.customer_id,  
eaadmin.customer sl_customer
where
sl.customer_id = 4723 
and sl.customer_id = sl_customer.customer_id
and hl.customer_id = 4723 
and (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id)) 
ORDER BY sl.name
with ur';
    return ( 'sqlStamentNo5', $query );
}

sub querySqlStamentNo6 {
    my ($testMode) = @_;
    my $query = 'select sl_customer.account_number, sl.name, sw.software_name, disc.name 
from 
eaadmin.customer sl_customer
,eaadmin.software_lpar sl
inner join eaadmin.installed_software is on 
sl.id = is.software_lpar_id 
inner join eaadmin.DISCREPANCY_TYPE disc on
is.DISCREPANCY_TYPE_ID = disc.id
inner join eaadmin.software sw on 
is.software_id = sw.software_id
where
sl.customer_id = sl_customer.customer_id
and sl_customer.customer_id = 5062
with ur';
    return ( 'sqlStamentNo6', $query );
}