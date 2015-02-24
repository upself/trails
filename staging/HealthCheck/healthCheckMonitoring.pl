#!/usr/bin/perl -w
#
# This perl script is used to do health check and monitor application/system relates topics for example, current running threads, error number in the log etc
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     ----------------------------------------------------------------------------
# 2013-04-03  Liu Hai(Larry) 1.0.0           This is the initial version for health check and monitor perl script
# 2013-04-05  Liu Hai(Larry) 1.0.1           Implement the alert email sending function and do some code optimization
# 2013-04-06  Liu Hai(Larry) 1.0.2           Add event rule definition, parse and check logic feature 
# 2013-04-07  Liu Hai(Larry) 1.0.3           Add event rule definition, parse and check logic feature
#                                            Go on optimizing code structure
# 2013-04-17  Liu Hai(Larry) 1.1.0           HealthCheck and Monitor Module - Phase 2A: Add Event Group Name: TRAILS_BRAVO_CORE_SCRIPTS + Event Type: CONTINUOUS_RUN_SCRIPTS Feature
# 2013-04-18  Liu Hai(Larry) 1.1.1           HealthCheck and Monitor Module - Phase 2A: Add Log Feature                                           
# 2013-04-19  Liu Hai(Larry) 1.1.2           HealthCheck and Monitor Module - Phase 2A: Add Module Trigger Interval Time Feature
# 2013-04-20  Liu Hai(Larry) 1.1.3           HealthCheck and Monitor Module - Phase 2A1: Add Event Rule Trigger Frequency Feature
# 2013-04-23  Liu Hai(Larry) 1.1.4           HealthCheck and Monitor Module - Phase 2A1: Add Perl File Running Parameters(start/stop/run-once) and Process Running Check Features
# 2013-04-24  Liu Hai(Larry) 1.1.5           HealthCheck and Monitor Module - Phase 2A1 1) Add Multi DB Support Feature
#                                                                                       2) Add Configuration File named 'healthCheckMonitor.properties' Feature for Server Mode parameters etc
###################################################################################################################################################################################################
#                                            Phase 2B Development Formal Tag: 'Added by Larry for HealthCheck And Monitor Module - Phase 2B'
# 2013-05-06  Liu Hai(Larry) 1.2.0           HealthCheck and Monitor Module - Phase 2B: Add Event O/R mapping object
# 2013-05-08  Liu Hai(Larry) 1.2.1           HealthCheck and Monitor Module - Phase 2B: Add EventLoaderDelegate object
#                                                                                       Extend Event Rule Parameters from 5 to 10
#                                                                                       Add swkbt loader into continuous monitoring list on TAP3 server 
# 2013-05-10  Liu Hai(Larry) 1.2.2           HealthCheck and Monitor Module - Phase 2B: Add Start/Stop Script Core Event Rule Check Business Logic
# 2013-05-13  Liu Hai(Larry) 1.2.3           HealthCheck and Monitor Module - Phase 2B: Optimize HealthCheck Monitor Module Logic Code to refer Event object
#                                                                                       Go on implementing phase 2B Event Rule Check Business Logic
# 2013-05-16  Liu Hai(Larry) 1.2.4           HealthCheck and Monitor Module - Phase 2B: Optimize Event ALL Data Query SQL to get the first 100 row records from all row records
###################################################################################################################################################################################################
#                                            Phase 3 Development Formal Tag: 'Added by Larry for HealthCheck And Monitor Module - Phase 3'
# 2013-05-20  Liu Hai(Larry) 1.3.0           HealthCheck and Monitor Module - Phase 3: File System Threshold Monitoring
# 2013-05-23  Liu Hai(Larry) 1.3.1           HealthCheck and Monitor Module - Phase 3: Add Bravo/Trails Server Mode Support
# 2013-05-24  Liu Hai(Larry) 1.3.2           HealthCheck and Monitor Module - Phase 3: Add Alert Email Signature Feature Support
###################################################################################################################################################################################################
#                                            Phase 4 Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 4'
# 2013-05-28  Liu Hai(Larry) 1.4.0           HealthCheck and Monitoring Service Component - Phase 4: Develop Database Monitoring - TrailsRP DB Apply Gap Basic Architecture
#                                                                                                    Rename 'HealthCheck And Monitor Module' key words to 'HealthCheck And Monitoring Service Component' from Phase 4                                                                                                          
#                                                                                                    The name of healthCheckMonitorLogFile has been changed to 'healthCheckMonitoring.log' from 'healthCheckMonitor.log'
#                                                                                                    The name of pidFile has been changed to 'healthCheckMonitoring.pid' from 'healthCheckMonitor.pid'
#                                                                                                    The name of configFile has been changed to 'healthCheckMonitoring.properties' from 'healthCheckMonitor.properties'
# 2013-05-30  Liu Hai(Larry) 1.4.1           HealthCheck and Monitoring Service Component - Phase 4: A new feature to support that there is no alert message generated case. A server running with correct email needs to be sent to notify team that HealthCheck and Monitoring Service Compoment is running correctly and well. 
###################################################################################################################################################################################################
#                                            Phase 5 Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 5'
# 2013-06-04  Liu Hai(Larry) 1.5.0           HealthCheck and Monitoring Service Component - Phase 5: Develop Database Monitoring - CNDB Customer TME_OBJECT_ID Basic Architecture
# 2013-06-05  Liu Hai(Larry) 1.5.1           HealthCheck and Monitoring Service Component - Phase 5: Refacor the way of getting DB connection and executing SQL statements - for example: Database::Connection->new('trails')
###################################################################################################################################################################################################
#                                            Phase 6 Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 6'
# 2013-06-18  Liu Hai(Larry) 1.6.0           HealthCheck and Monitoring Service Component - Phase 6: Go on refactoring the way of getting DB connection and executing SQL statements - for example: Database::Connection->new('trails')
# 2013-06-21  Liu Hai(Larry) 1.6.1           HealthCheck and Monitoring Service Component - Phase 6: Refactor FileSystem Monitoring Function for Bravo/Trails Server using SFTP way 
###################################################################################################################################################################################################
#                                            Phase 7 Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 7'
# 2013-07-03  Liu Hai(Larry) 1.7.0           HealthCheck and Monitoring Service Component - Phase 7: Develop Database Monitoring - TrailsST DB Apply Gap Monitoring Feature Basic Architecture
# 2013-07-04  Liu Hai(Larry) 1.7.1           HealthCheck and Monitoring Service Component - Phase 7: Develop Database Monitoring - TrailsRP DB Apply Gap Monitoring Feature 2 Basic Architecture
# 2013-07-11  Liu Hai(Larry) 1.7.2           HealthCheck and Monitoring Service Component - Phase 7: Go on refactoring the way of getting DB connection and executing SQL statements - for example: Database::Connection->new('trails') 
#                                                                                                    Add DB Exception Feature Support
###################################################################################################################################################################################################
#                                            Phase 7A Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A'
# 2013-08-01  Liu Hai(Larry) 1.7.3           HealthCheck and Monitoring Service Component - Phase 7A: Add the synctime is null case for TrailsRP Replication Error Email Support Feature
#                                                                                                    Adjust the email content for TrailsRP Replication Success Email more meaningful 
###################################################################################################################################################################################################
#                                            Phase 8 Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 8'
# 2013-09-26  Liu Hai(Larry) 1.8.0           HealthCheck and Monitoring Service Component - Phase 8: Design and Develop Application Monitoring - Web Application Running Status Check Basic Architecture and Business Logic
# 2013-09-27  Liu Hai(Larry) 1.8.1           HealthCheck and Monitoring Service Component - Phase 8: Add Some Testing Function Codes only for TAP2 Testing Server
# 2013-09-30  Liu Hai(Larry) 1.8.2           HealthCheck and Monitoring Service Component - Phase 8: Add HTTP 403 Forbidden Return Code for Trails Web Application to understand this case that Trails Web Applcation is also running 
###################################################################################################################################################################################################
#                                            Phase 8A Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A'
# 2013-12-16  Liu Hai(Larry) 1.8.3           HealthCheck and Monitoring Service Component - Phase 8A: Design and Develop Self Healing Business Logic to automatically fix Bravo/Trails Web Application down case
###################################################################################################################################################################################################
#                                            Phase 9 Development Formal Tag: 'Added by Larry for HealthCheck And Monitoring Service Component - Phase 9'
# 2014-01-15  Liu Hai(Larry) 1.9.0           HealthCheck and Monitoring Service Component - Phase 9: Design and Develop Database Monitoring - Database Exception Status Check Basic Architecture and Business Logic 
# 2014-01-21  Liu Hai(Larry) 1.9.1           HealthCheck and Monitoring Service Component - Phase 9: The following new features have been added into this phase
#                                                                                                    1) Database Exception Code List defined to notify DBA team Support
#                                                                                                    2) Monitoring Database Exclusion Duration Time Support
#                                                                                                    3) Database Exception Email Switch for DBA Team Support 
#                                                                                                    
#
########################################################################################################################################################################                                   
#                                            Phase 10 Development Formal Tag: 'Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10'
# 2014-07-02  Tomas 1.10.0                   HealthCheck and Monitoring Service Component - Phase 10: Design and Develop Database Monitoring - Recon Queues Duplicate Data Monitoring and Cleanup Basic Architecture and Business Logic
my $HOME_DIR = "/home/liuhaidl/working/scripts";#set Home Dir value
my $cdFlag = system('cd $HOME_DIR');
if($cdFlag!=0){
 die "Change Directory to $HOME_DIR failed. Exit to the current perl program.\n";
}
else{
 print "Change Directory to $HOME_DIR successfully.\n";
}

#Load required modules
require "/opt/staging/v2/Database/Connection.pm";
use strict;
use POSIX;
use DBI;
use DBD::DB2;
use DBD::DB2::Constants;
use File::Basename;
use Base::ConfigManager;#Require the Staging Project Package
#use Database::Connection;
use HealthCheck::OM::Event;
use HealthCheck::Delegate::EventLoaderDelegate;
use Config::Properties::Simple;

#Globals
my $eventRuleDefinitionFile = "/home/liuhaidl/working/scripts/eventCheckRuleDefinition.properties";
my $healthCheckMonitorLogFile = "/home/liuhaidl/working/scripts/healthCheckMonitoring.log";#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4
my $pidFile    = "/home/liuhaidl/working/scripts/healthCheckMonitoring.pid";#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4
my $configFile = "/home/liuhaidl/working/scripts/healthCheckMonitoring.properties";#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4

my $cfgMgr   = Base::ConfigManager->instance($configFile);
my $configSleepPeriod  = trim($cfgMgr->sleepPeriod);
print "configSleepPeriod: {$configSleepPeriod}\n";
my $configServerMode    = trim($cfgMgr->server);
print "configServerMode: {$configServerMode}\n";

#SERVER MODE
my $TAP          = "TAP";#TAP Server for toStaging Loaders
my $TAP2         = "TAP2";#TAP2 Testing Server
my $TAP3         = "TAP3";#TAP3 Server for toBravo Loaders
my $TAPMF        = "TAPMF";#TAPMF Server
#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
my $BRAVO        = "BRAVO";#BRAVO Server
my $TRAILS       = "TRAILS";#TRAILS Server
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End
my $SERVER_MODE  = $configServerMode;#Set Server Mode Value from configuration file

#HealthCheck and Minitor Module Trigger Interval Time
my $TRIGGER_INTERVAL_TIME = $configSleepPeriod;#Set Trigger Frequency Time from configuration file For example: 3600(Unit: Second)

#TIMESTAMP STYLE
my $STYLE1 = 1;#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
my $STYLE2 = 2;#YYYYMMDDHHMMSS For Example: 20130418103033

#Vars definition
my $staging_connection;#Added by Larry for HealthCheck And Monitor Module - Phase 2B
my @row;
my @row2;
my $totalCnt;
my $loopIndex;
my $eventFiredTime;
my @eventMetaRecords;
my @ruleMetaRecords;
my $currentTimeStamp;
my $DB_ENV;

#SQL Statements
my $GET_TOTAL_RECORDS_IN_QUEUE_SQL      = "SELECT COUNT(*) FROM V_RECON_QUEUE WITH UR";
my $GET_TOTAL_CUSTOMERS_IN_QUEUE_SQL    = "SELECT COUNT(DISTINCT CUSTOMER_ID) FROM V_RECON_QUEUE WITH UR";
my $GET_EVENT_META_DATA_SQL             = "SELECT EG.EVENT_GROUP_ID, EG.NAME, ET.EVENT_ID, ET.NAME FROM EVENT_GROUP EG, EVENT_TYPE ET WHERE EG.EVENT_GROUP_ID = ET.EVENT_GROUP_ID ORDER BY EG.EVENT_GROUP_ID, ET.EVENT_ID WITH UR";
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
my $GET_EVENT_DATA_FOR_CERTAIN_TIME_SQL = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG WHERE EG.NAME = ? AND ET.NAME = ? AND E.EVENT_ID = ET.EVENT_ID AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID AND E.RECORD_TIME >= CURRENT TIMESTAMP - #1 HOURS AND E.RECORD_TIME <= CURRENT TIMESTAMP ORDER BY E.RECORD_TIME DESC WITH UR";# #1 parameter is used to replace with job cron number
my $GET_EVENT_ALL_DATA_COUNT_SQL = "SELECT COUNT(*) FROM EVENT E JOIN EVENT_TYPE ET ON ET.EVENT_ID = E.EVENT_ID JOIN EVENT_GROUP EG ON EG.EVENT_GROUP_ID = ET.EVENT_GROUP_ID WHERE EG.NAME = ? AND ET.NAME = ? WITH UR";
my $GET_EVENT_ALL_DATA_SQL = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG WHERE EG.NAME = ? AND ET.NAME = ? AND E.EVENT_ID = ET.EVENT_ID AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID ORDER BY E.RECORD_TIME DESC FETCH FIRST 100 ROWS ONLY WITH UR";#Added by Larry for HealthCheck And Monitor Module - Phase 2B: Optimize Event ALL Data Query SQL to get the first 100 row records from all row records
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
my $GET_TRAILSRP_DB_APPLY_GAP_SQL = "SELECT DISTINCT CURRENT TIMESTAMP, SYNCHTIME, ((DAYS(CURRENT TIMESTAMP) - DAYS(SYNCHTIME)) * 86400 + (MIDNIGHT_SECONDS(CURRENT TIMESTAMP) - MIDNIGHT_SECONDS(SYNCHTIME))) FROM ASN.IBMSNAP_SUBS_SET";
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
my $GET_CNDB_CUSTOMER_TME_OBJECT_ID_SQL = "SELECT ACCOUNT_NUMBER, TME_OBJECT_ID FROM CUSTOMER WHERE TME_OBJECT_ID LIKE '%#1%'";# #1 parameter is used to replace with searching key for example: 'DEFAULT'
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
my $GET_TRAILSST_DB_APPLY_GAP_SQL = "SELECT DISTINCT CURRENT TIMESTAMP, SYNCHTIME, ((DAYS(CURRENT TIMESTAMP) - DAYS(SYNCHTIME)) * 86400 + (MIDNIGHT_SECONDS(CURRENT TIMESTAMP) - MIDNIGHT_SECONDS(SYNCHTIME))) FROM ASN.IBMSNAP_SUBS_SET";
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End

#The Index Definition For Result Fields
#Total Records Index
my $TOTAL_RECORDS_CNT_INDEX   = 0;
#Total Customers Index
my $TOTAL_CUSTOMERS_CNT_INDEX = 0;
#Event Meta Data Indexes
my $EVENT_GROUP_ID_INDEX   = 0;
my $EVENT_GROUP_NAME_INDEX = 1;
my $EVENT_ID_INDEX         = 2;
my $EVENT_NAME_INDEX       = 3;
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
#Event Data For Certain Time Indexes
my $EVENT_ID_DATA_INDEX            = 0;
my $EVENT_VALUE_DATA_INDEX         = 1;
my $EVENT_RECORD_TIME_DATA_INDEX   = 2;
#Event ALL Data For Certain Event Rule Type Total Count Index
my $EVENT_ALL_DATA_TOTAL_CNT_INDEX = 0;
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

#Event Rule Meta Data Indexes
my $EVENT_RULE_CODE_INDEX                 = 0;#For example, "ERC001"
my $TRIGGERED_EVENT_GROUP_NAME_INDEX	  = 1;#For example, "TRAILS_BRAVO_CORE_SCRIPTS"
my $TRIGGERED_EVENT_NAME_INDEX			  = 2;#For example, "CONTINUOUS_RUN_SCRIPTS"
my $PARAMETER_1_INDEX					  = 3;#For example, "TAP3"
my $PARAMETER_2_INDEX					  = 4;#For example, "reconEngine.pl'softwareToBravo.pl'ipAddressToBravo.pl"
my $PARAMETER_3_INDEX					  = 5;#For example, "TAP"
my $PARAMETER_4_INDEX					  = 6;#For example, "doranaToSwasset.pl'hdiskToStaging.pl'ipAddressToStaging.pl"
my $PARAMETER_5_INDEX					  = 7;#For example, "N/A"
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
my $PARAMETER_6_INDEX					  = 8;#For example, "N/A"
my $PARAMETER_7_INDEX					  = 9;#For example, "N/A"
my $PARAMETER_8_INDEX					  = 10;#For example, "N/A"
my $PARAMETER_9_INDEX					  = 11;#For example, "N/A"
my $PARAMETER_10_INDEX					  = 12;#For example, "N/A"
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End
my $EVENT_RULE_TITLE                      = 13;#For example, "Loader Running Status on @1 Server"
my $EVENT_RULE_MESSAGE                    = 14;#For example, "Loader @2 is currently not running."
my $EVENT_RULE_HANDLING_INSTRUCTION_CODE  = 15;#For example, "E-TBS-CRS-001"
my $EVENT_RULE_TRIGGER_FREQUENCY          = 16;#For example, 1(Unit:Hour)

#Email Content Texts
my $EVENT_RULE_TITLE_TXT                     = "Event Rule Title";
my $EVENT_RULE_MESSAGE_TXT                   = "Event Rule Message";
my $EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT = "Event Rule Handling Instruction Code";

#Email Related Information Indexes And Vars Definition
my $EMAIL_CODE_INDEX             = 0;
my $EMAIL_SUBJECT_INFO_INDEX     = 1;
my $EMAIL_TO_ADDRESS_LIST_INDEX  = 2;
my $EMAIL_CC_ADDRESS_LIST_INDEX  = 3;
my $emailSubjectInfo;
my $emailToAddressList;
my $emailCcAddressList;
my $emailFullContent = "";
my @startAndStopScriptsEmailAlertArray = ();#Added by Larry for HealthCheck And Monitor Module - Phase 2B

#Event Group Name and its children Event Type Names
#Recon Engine - Event Group Name
my $RECON_ENGINE                            = "RECON_ENGINE";
#Recon Engine - its children Event Type Names
my $TOTAL_RECORDS_IN_QUEUE                  = "TOTAL_RECORDS_IN_QUEUE";
my $TOTAL_CUSTOMERS_IN_QUEUE                = "TOTAL_CUSTOMERS_IN_QUEUE";
#Trails/Bravo Core Scripts - Event Group Name
my $TRAILS_BRAVO_CORE_SCRIPTS               = "TRAILS_BRAVO_CORE_SCRIPTS";
#Trails/Bravo Core Scripts - its children Event Type Names
my $CONTINUOUS_RUN_SCRIPTS                  = "CONTINUOUS_RUN_SCRIPTS";#EVENT_TYPE_ID = 1
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
my $ATPTOSTAGING_START_STOP_SCRIPT          = "ATPTOSTAGING_START_STOP_SCRIPT";#EVENT_TYPE_ID = 2
my $SWCMTOSTAGING_START_STOP_SCRIPT         = "SWCMTOSTAGING_START_STOP_SCRIPT";#EVENT_TYPE_ID = 3
my $MOVEMAINFRAME_START_STOP_SCRIPT         = "MOVEMAINFRAME_START_STOP_SCRIPT";#EVENT_TYPE_ID = 4
my $BRAVOREPORTFORK_START_STOP_SCRIPT       = "BRAVOREPORTFORK_START_STOP_SCRIPT";#EVENT_TYPE_ID = 5
my $STAGINGMOVE_START_STOP_SCRIPT           = "STAGINGMOVE_START_STOP_SCRIPT";#EVENT_TYPE_ID = 6
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End
#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
#File System Monitoring - Event Group Name
my $FILE_SYSTEM_MONITORING                  = "FILE_SYSTEM_MONITORING";#EVENT_GROUP_ID = 2
#File System Monitoring - its children Event Type Name
my $FILE_SYSTEM_THRESHOLD_MONITORING        = "FILE_SYSTEM_THRESHOLD_MONITORING";#EVENT_TYPE_ID = 7
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
#Database Monitoring - Event Group Name
my $DATABASE_MONITORING                     = "DATABASE_MONITORING";#EVENT_GROUP_ID = 3
#Database Monitoring - its children Event Type Name
my $TRAILSRP_DB_APPLY_GAP_MONITORING        = "TRAILSRP_DB_APPLY_GAP_MONITORING";#EVENT_TYPE_ID = 8
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
my $CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING  = "CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING";#EVENT_TYPE_ID = 9
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
my $TRAILSST_DB_APPLY_GAP_MONITORING        = "TRAILSST_DB_APPLY_GAP_MONITORING";#EVENT_TYPE_ID = 10
my $TRAILSRP_DB_APPLY_GAP_MONITORING_2      = "TRAILSRP_DB_APPLY_GAP_MONITORING_2";#EVENT_TYPE_ID = 11
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 Start
my $DB_EXCEPTION_STATUS_CHECK_MONITORING    = "DB_EXCEPTION_STATUS_CHECK_MONITORING";#EVENT_TYPE_ID = 13
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 Start
#Application Monitoring - Event Group Name
my $APPLICATION_MONITORING                  = "APPLICATION_MONITORING";#EVENT_GROUP_ID = 4
#Application Monitoring - its children Event Type Name
my $WEBAPP_RUNNING_STATUS_CHECK_MONITORING  = "WEBAPP_RUNNING_STATUS_CHECK_MONITORING";#EVENT_TYPE_ID = 12
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 End

#Event Group ID and its children Event IDs
#Trails/Bravo Core Scripts
my $TRAILS_BRAVO_CORE_SCRIPTS_EVENT_GROUP_ID       = 1;
my $CONTINUOUS_RUN_SCRIPTS_EVENT_TYPE_ID           = 1;
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
my $ATPTOSTAGING_START_STOP_SCRIPT_EVENT_TYPE_ID     = 2;
my $SWCMTOSTAGING_START_STOP_SCRIPT_EVENT_TYPE_ID    = 3;
my $MOVEMAINFRAME_START_STOP_SCRIPT_EVENT_TYPE_ID    = 4;
my $BRAVOREPORTFORK_START_STOP_SCRIPT_EVENT_TYPE_ID  = 5;
my $STAGINGMOVE_START_STOP_SCRIPT_EVENT_TYPE_ID      = 6;
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End
#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
#File System Monitoring
my $FILE_SYSTEM_MONITORING_EVENT_GROUP_ID            = 2;
my $FILE_SYSTEM_THRESHOLD_MONITORING_EVENT_TYPE_ID   = 7;
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
#Database Monitoring
my $DATABASE_MONITORING_EVENT_GROUP_ID               = 3;
my $TRAILSRP_DB_APPLY_GAP_MONITORING_EVENT_TYPE_ID   = 8;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
my $CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING_EVENT_TYPE_ID = 9;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
my $TRAILSST_DB_APPLY_GAP_MONITORING_EVENT_TYPE_ID   = 10;
my $TRAILSRP_DB_APPLY_GAP_MONITORING_2_EVENT_TYPE_ID = 11;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End

#Continuous Run Scripts Special Check List
my $CONTINUOUS_RUN_SCRIPTS_SPECIAL_CHECK_LIST = "swkbt";#Added by Larry for HealthCheck And Monitor Module - Phase 2B

#Comment Char
my $COMMENT_CHAR                     = "#";
#Event Rule Code Definition
my $EVENT_RULE_CODE_DEFINITION       = "ERC";
#Email Information Code Definition
my $EMAIL_CODE_DEFINITION            = "EML";

#Send Email Rule Action Field Indexes
my $EMAIL_RULE_ACTION_CODE_INDEX            = 0;
my $EMAIL_RULE_ACTION_SUBJECT_INDEX         = 1;
my $EMAIL_RULE_ACTION_TO_ADDRESS_LIST_INDEX = 2;
my $EMAIL_RULE_ACTION_CC_ADDRESS_LIST_INDEX = 3;
my $EMAIL_RULE_ACTION_EMAIL_CONTENT_INDEX   = 4;

#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
#Start/Stop Script Loader Status Code List
my $LOADER_STARTED_STATUS_CODE = "STARTED";
my $LOADER_ERRORED_STATUS_CODE = "ERRORED";
my $LOADER_STOPPED_STATUS_CODE = "STOPPED";
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
#File System Information Definition Indexes
my $TOTAL_DISK_INDEX    = 1;
my $USED_DISK_INDEX     = 2;
my $FREE_DISK_INDEX     = 3;
my $USED_DISK_PCT_INDEX = 4;
my $FILE_SYSTEM_INDEX   = 5;
#Event Trigger Rule File System Definition Indexes
my $EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX = 0;
my $EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX   = 1;
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
#TrailsRP DB Apply Gap Indexes
my $TRAILSRP_DB_CURRENT_TIME_INDEX   = 0;
my $TRAILSRP_DB_LAST_SYN_TIME_INDEX  = 1;
my $TRAILSRP_DB_APPLY_GAP_INDEX      = 2;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
#CNDB Customer Indexes
my $CNDB_CUSTOMER_ACCOUNT_NUMBER_INDEX = 0;
my $CNDB_CUSTOMER_TME_OBJECT_ID_INDEX  = 1;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
my $REMOTE_SERVER_FILE_SYSTEM_MONITORING_TURN_ON_FLAG   = "Y";
my $REMOTE_SERVER_FILE_SYSTEM_MONITORING_TURN_OFF_FLAG  = "N";
my $REMOTE_FILE_SFTP_GET_METHOD                         = "SFTP";
my $REMOTE_FILE_GSA_GET_METHOD                          = "GSA";
my $BRAVO_SERVER_FILE_SYSTEM_INFO_FILE                  = "/home/liuhaidl/working/scripts/bravoServerFileSystemUsedDiskInfo.txt";
my $TRAILS_SERVER_FILE_SYSTEM_INFO_FILE                 = "/home/liuhaidl/working/scripts/trailsServerFileSystemUsedDiskInfo.txt";
#Added by Tomas for HealthCheck And Monitoring Service Component - Phase 6a Start
my $TAP3_SERVER_FILE_SYSTEM_INFO_FILE                 = "/home/liuhaidl/working/scripts/tap3ServerFileSystemUsedDiskInfo.txt";
#Added by Tomas for HealthCheck And Monitoring Service Component - Phase 6a End
#File System Information Definition Indexes for 6 Fields
my $FILE_SYSTEM_MOUNT_INDEX_6_FIELDS                    = 1;
my $TOTAL_DISK_INDEX_6_FIELDS                           = 2;
my $USED_DISK_INDEX_6_FIELDS                            = 3;
my $FREE_DISK_INDEX_6_FIELDS                            = 4;
my $USED_DISK_PCT_INDEX_6_FIELDS                        = 5;
my $FILE_SYSTEM_INDEX_6_FIELDS                          = 6;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
#TrailsST DB Apply Gap Indexes
my $TRAILSST_DB_CURRENT_TIME_INDEX   = 0;
my $TRAILSST_DB_LAST_SYN_TIME_INDEX  = 1;
my $TRAILSST_DB_APPLY_GAP_INDEX      = 2;
#TrailsRP DB Email Send Flag
my $TRAILSRP_DB_EMAIL_SENT_FLAG      = "Y";#TrailsRP DB Email Sent Flag
my $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG  = "N";#TrailsRP DB Email Not Sent Flag
my $trailsRPDBEmailSendFlag          = $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG;#Default value is "N"
#AlwaysSendEmail Flag Values
my $SEND_ALL_EMAIL_FLAG              = "Y";#Send All Email Flag
my $ONLY_SEND_ERROR_EMAIL_FLAG       = "N";#Only Send Error Email Flag
#Database Exception Message
my $DB_EXCEPTION_MESSAGE = "Database Exception Message";
#HealthCheck and Monitoring Engine Startup Error Messages
my $HME_ERROR_EMAIL_TITLE          = "HealthCheck and Monitoring Engine Startup Error Email";
my $HME_ERROR_EMAIL_TO_PERSON_LIST = "liuhaidl\@cn.ibm.com,HDRUST\@de.ibm.com,Petr_Soufek\@cz.ibm.com,dbryson\@us.ibm.com,AMTS\@cz.ibm.com,stammelw\@us.ibm.com";
my $HME_ERROR_EMAIL_TXT            = "HealthCheck and Monitoring Engine Startup Error Message";
my $hme_error_mail_message;
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 Start
#Web Application Check Configuration Value Definition Indexes
my $WEBAPP_CHECK_CONFIG_VALUE_WEB_APPNAME_INDEX        = 0;#For example: 'Bravo'
my $WEBAPP_CHECK_CONFIG_VALUE_CONNECT_TIMEOUT_INDEX    = 1;#For example: '15' seconds - CONNECT_TIMEOUT stands for the max http request time
my $WEBAPP_CHECK_CONFIG_VALUE_MAX_TIME_INDEX           = 2;#For example: '20' seconds - MAX_TIME stands for the max transfer time
my $WEBAPP_CHECK_CONFIG_VALUE_URL_INDEX                = 3;#For example: 'http://bravo.boulder.ibm.com/BRAVO/home.do'

#Web Application CURL Unix Command
my $WEBAPP_CURL_COMMAND = "curl --connect-timeout \@connectTimeout --max-time \@maxTime --head --silent \@url";

my $FALSE = 0;#For perl, 0 = false
my $TRUE  = 1;#For perl, 1 = true

#HTTP OK Code
my $HTTP_OK_CODE        = "200";
#HTTP FORBIDDEN Code
#To support this HTTP return code for Trails Web Application, the Trails Web Application is running if this HTTP code has been returned
my $HTTP_FORBIDDEN_CODE = "403";

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A Start
#Self Healing Engine Restart Web Application Operation Definition Indexes
my $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_PROGRAM_NAME_INDEX = 0;#For example: selfHealingEngine.pl
my $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_CODE_INDEX         = 1;#For example: RESTART_BRAVO_WEB_APPLICATION
my $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_PARAMETERS_INDEX   = 2;#For example: ^^^^^^^^^

my $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_TURN_ON  = "Y";#var used to store Self Healing Engine Restart Web Application Operation Turn On Flag
my $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_TURN_OFF = "N";#var used to store Self Healing Engine Restart Web Application Operation Turn Off Flag

my $LOADER_EXISTING_PATH   = "/opt/staging/v2/";

my $BRAVO_WEB_APP  = "Bravo";
my $TRAILS_WEB_APP = "Trails";

my $PWD_UNIX_COMMAND = "pwd";
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 Start
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_REAL_NAME_INDEX               = 0;#For example: 'TRAILS'
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_ALIAS_INDEX                   = 1;#For example: 'trails.name'
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_USERID_INDEX                  = 2;#For example: 'trails.user'
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_PASSWORD_INDEX                = 3;#For example: 'trails.password'
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_LOCATED_SERVER_INDEX          = 4;#For example: 'dst20lp05.boulder.ibm.com'
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_LIST_INDEX   = 5;#For example: 'liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com'
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_SWITCH_INDEX = 6;#For example: 'Y' - means turn no the DBA notify email function or 'N' - means turn off the DBA notify email function

my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_TURN_ON      = "Y";#Turn on DBA Team notify email flag
my $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_TURN_OFF     = "N";#Turn off DBA Team notify email flag

my $DB_CONNECTION_COMMAND = "db2 connect to \@1 user \@2 using \@3";

my $DB_CONNECTION_SUCCESS_KEY_MESSAGE = "Database Connection Information";

my %WEEKDAY_HASH = ("Monday"=>1,"Tuesday"=>2,"Wednesday"=>3,"Thursday"=>4,"Friday"=>5,"Saturday"=>6,"Sunday"=>7);
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 End
#Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10 Start
my $RECON_QUEUES_DUPLICATE_DATA_MONITORING_AND_CLEANUP = "RECON_QUEUES_DUPLICATE_DATA_MONITORING_AND_CLEANUP";
my $RECON_QUEUE_DUPLICATE_CHECK_1 = "select count(*) from EAADMIN.recon_sw_lpar r where r.id in(select max(rc.id) from eaadmin.recon_sw_lpar rc where rc.action = 'UPDATE' and rc.remote_user in ('STAGING','TRIGGER') group by rc.software_lpar_id having count(rc.id)>1) with ur";
my $RECON_QUEUE_DUPLICATE_CHECK_2 = "select count(*) from EAADMIN.recon_hw_lpar r where r.id in (select max(rc.id) from eaadmin.recon_hw_lpar rc where rc.action = 'UPDATE' and rc.remote_user in ('STAGING','TRIGGER') group by rc.hardware_lpar_id having count(rc.id)>1) with ur";
my $RECON_QUEUE_DUPLICATE_CHECK_3 = "select count(*) from EAADMIN.recon_license r where r.id in (select max(rc.id) from eaadmin.recon_license rc where rc.action = 'UPDATE' and rc.remote_user in ('STAGING','TRIGGER') group by rc.license_id having count(rc.id)>1) with ur";
my $RECON_QUEUE_DUPLICATE_CHECK_4 = "select count(*) from EAADMIN.recon_hardware r where r.id in (select max(rc.id) from eaadmin.recon_hardware rc where rc.action = 'UPDATE' and rc.remote_user in ('STAGING','TRIGGER') group by rc.hardware_id having count(rc.id)>1) with ur";
my $RECON_QUEUE_DUPLICATE_CHECK_5 = "select count(*) from EAADMIN.recon_customer r where r.id in (select max(rc.id) from eaadmin.recon_customer rc where rc.action = 'UPDATE' and rc.remote_user in ('STAGING','TRIGGER') group by rc.customer_id having count(rc.id)>1) with ur";
my $RECON_QUEUE_DUPLICATE_CHECK_6 = "select count(*) from EAADMIN.recon_installed_sw r where r.id in (select max(rc.id) from eaadmin.recon_installed_sw rc where rc.action = 'UPDATE' and rc.remote_user in ('STAGING','TRIGGER') group by rc.installed_software_id having count(rc.id)>2) with ur";
#Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10 End
my $cfg=Config::Properties::Simple->new(file=>'/opt/staging/v2/config/connectionConfig.txt');       
my %dbs; # To store database login credentials
open(EVENTRULE_DEFINITION_FILE_HANDLER, "<", $eventRuleDefinitionFile ) or die "Event Rule Definition File {$eventRuleDefinitionFile} doesn't exist. Perl script exits due to this reason.";

###Initialize properties
my $sleepPeriod = $TRIGGER_INTERVAL_TIME;#Second/Unit

###Make a daemon.
umask 0;
defined( my $pid = fork )
  or die "ERROR: Unable to fork: $!";
exit if $pid;
#setsid or die "ERROR: Unable to setsid: $!";#Hai comments out for temp

loaderStart(shift @ARGV, $pidFile);#Start HealthCheck and Monitor Process

###Close handles to avoid console output.
#open( STDIN, "/dev/null" )
#  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
#open( STDOUT, "/dev/null" )
#  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
#open( STDERR, "/dev/null" )
#  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

###Wrap everything in an eval so we can capture in logfile.
eval{
	#1.Do event init operation
	init();
    #2.Do event process operation
    process();
    #3.Do event postProcess operation
    postProcess();
};
if ($@) {
    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
    $hme_error_mail_message="$HME_ERROR_EMAIL_TXT: $@";
	sendHMEStartupErrorEmail($HME_ERROR_EMAIL_TITLE,$HME_ERROR_EMAIL_TO_PERSON_LIST,$hme_error_mail_message);
    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
    die $@;
}

exit 0;

#This method is used to do init operation 
sub init{
    #set db2 env path
    setDB2ENVPath();

    #setup db2 environment
    setupDB2Env();

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
    #get DB connection object
	$staging_connection = Database::Connection->new('staging');
	#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

	#Set the loopIndex var init value
	$loopIndex = 0;

    #Log File Operation
	$currentTimeStamp = getCurrentTimeStamp($STYLE2);#Get the current full time using format YYYYMMDDHHMMSS
    $healthCheckMonitorLogFile.= ".$currentTimeStamp";
    open LOG, ">>$healthCheckMonitorLogFile";#Open Log File
	
    #Load Event Meta Data
    loadEventMetaData();

	#Load Event Rule And Email Information Definition                                                                                                                         
    loadEventRuleAndEmailInformationDefinition();
    
}

#This method is used to load event meta data
sub loadEventMetaData{
  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements Start
  @eventMetaRecords = getEventMetaDataFunction($staging_connection);
  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements End

  #Add mock event meta data here to support DB cannot be connected case
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","1","CONTINUOUS_RUN_SCRIPTS")];
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","2","ATPTOSTAGING_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","3","SWCMTOSTAGING_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","4","MOVEMAINFRAME_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","5","BRAVOREPORTFORK_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","6","STAGINGMOVE_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("2","FILE_SYSTEM_MONITORING","7","FILE_SYSTEM_THRESHOLD_MONITORING")];#Added by Larry for HealthCheck And Monitor Module - Phase 3
  #push @eventMetaRecords, [("3","DATABASE_MONITORING","8","TRAILSRP_DB_APPLY_GAP_MONITORING")];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4
  #push @eventMetaRecords, [("3","DATABASE_MONITORING","9","CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING")];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5
  #push @eventMetaRecords, [("3","DATABASE_MONITORING","10","TRAILSST_DB_APPLY_GAP_MONITORING")];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7
  #push @eventMetaRecords, [("3","DATABASE_MONITORING","11","TRAILSRP_DB_APPLY_GAP_MONITORING_2")];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7
  #push @eventMetaRecords, [("4","APPLICATION_MONITORING","12","WEBAPP_RUNNING_STATUS_CHECK_MONITORING")];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8
  #push @eventMetaRecords, [("3","DATABASE_MONITORING","13","DB_EXCEPTION_STATUS_CHECK_MONITORING")];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9
  #push @eventMetaRecords, [("3","DATABASE_MONITORING","14","RECON_QUEUES_DUPLICATE_DATA_MONITORING_AND_CLEANUP")]; # Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10
}

#This method is used to load event rule and email information definition
sub loadEventRuleAndEmailInformationDefinition{
  while (my $congfigLine = <EVENTRULE_DEFINITION_FILE_HANDLER>) {
	#Remove before and after space chars of a string
	$congfigLine = trim($congfigLine);
    #Get the first char of a string
	my $strFirstChar = substr($congfigLine,0,1);
	#Bypass comment line
    if($strFirstChar eq $COMMENT_CHAR){
	  next;
	}

    #Get the first three chars of a string
	my $strCode = substr($congfigLine,0,3);
	
    #Judge if event rule definition line
	if($strCode eq $EVENT_RULE_CODE_DEFINITION){#Event Rule Code "ERC"
		#Split event rule definition using '^' char
	    my @ruleMetaRecord = split(/\^/,$congfigLine);
		push @ruleMetaRecords, [@ruleMetaRecord];
	}
	elsif($strCode eq $EMAIL_CODE_DEFINITION){#Email Information Code "EML"
       #Split email information definition using '^' char
	   my @emailInfos = split(/\^/,$congfigLine);
       $emailSubjectInfo = $emailInfos[$EMAIL_SUBJECT_INFO_INDEX];
       $emailToAddressList = $emailInfos[$EMAIL_TO_ADDRESS_LIST_INDEX];
       $emailCcAddressList = $emailInfos[$EMAIL_CC_ADDRESS_LIST_INDEX];
	}
  }#end of while
}

#This method is used to do event business process
sub process{
   while (1) {
     	$loopIndex++;
        ###Trigger event logic
        eventLogging();
        
		#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 - Add Some Testing Function Codes only for TAP2 Testing Server Start
		#For Testing Purpose on TAP2 Server only Start
		#For TAP2 Testing Server, only let HealthCheck and Monitoring Engine run 1 time for testing purpose
		if(($SERVER_MODE eq $TAP2) && ($loopIndex==1)){
		  last;
		}
        #For Testing Purpose on TAP2 Server only End
		#Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 - Add Some Testing Function Codes only for TAP2 Testing Server End
        
		sleep $sleepPeriod;
    }
}

#This method is used to do event business postProcess for example, close db handlers, close file handers etc
sub postProcess{
 	#Close Event Rule Definition File Handler
	close EVENTRULE_DEFINITION_FILE_HANDLER;
	#Close Log File Handler
	close LOG;
	#Disconnect DB
	$staging_connection->disconnect();#Added by Larry for HealthCheck And Monitor Module - Phase 2B
}

#This core method is used to do business statistic work based on event name 
#and then insert event records into EVENT DB table. 
sub eventLogging{
	 my $eventMetaGroupID;
     my $eventMetaGroupName;
	 my $eventMetaName;
	 my $eventMetaID;
     
     print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
	 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
     print LOG "[$currentTimeStamp]HealhCheck Monitor has been started for a new cycle.\n";
     foreach my $metaEvent (@eventMetaRecords){
		$eventMetaGroupID = $metaEvent->[$EVENT_GROUP_ID_INDEX];
	    $eventMetaGroupName = $metaEvent->[$EVENT_GROUP_NAME_INDEX];
        $eventMetaName = $metaEvent->[$EVENT_NAME_INDEX];
		$eventMetaID = $metaEvent->[$EVENT_ID_INDEX];
	    eventLogicProcess($eventMetaGroupName,$eventMetaName,$eventMetaID);
        $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
        print LOG "[$currentTimeStamp]{Event Group ID: $eventMetaGroupID} + {Event Group Name: $eventMetaGroupName} + {Event ID: $eventMetaID} + {Event Name: $eventMetaName} has been processed.\n";
	 }

     #Append Start And Stop Script Email Alerts Into Email Content
     appendStartAndStopScriptEmailAlertsIntoEmailContent();#Added by Larry for HealthCheck And Monitor Module - Phase 2B 
     
     #Send Out Alert Email
	 if($emailFullContent ne ""){#Send email only email content has value
		#Append Alert Email Signature Into Email Content
        appendAlertEmailSignatureIntoEmailContent();#Added by Larry for HealthCheck And Monitor Module - Phase 3
        sendEmail($emailSubjectInfo,$emailToAddressList,$emailCcAddressList,$emailFullContent);
     }
	 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
	 elsif($emailFullContent eq ""){#A new feature to support that there is no alert message generated case
        #Append Server Normal Running Information Into Email Content
        appendServerNormalRunningInfoIntoEmailContent();
        #Append Alert Email Signature Into Email Content
        appendAlertEmailSignatureIntoEmailContent();
        sendEmail($emailSubjectInfo,$emailToAddressList,$emailCcAddressList,$emailFullContent);
	 }
     #Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End

     #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	 @startAndStopScriptsEmailAlertArray = ();#Reset Start And Stop Script Email Alert Array Object To Empty
	 #Added by Larry for HealthCheck And Monitor Module - Phase 2B End

	 #Reset Email Content To Empty String
	 $emailFullContent = "";
	 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	 print LOG "[$currentTimeStamp]HealhCheck Monitor has been ended for a new cycle.\n";
	 print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";
 }

#This method is used to do event logic process
#For any new event, you need to add new business logic here
sub eventLogicProcess{
  my($groupName,$eventName,$eventID) = @_;
  if($groupName eq $RECON_ENGINE && $eventName eq $TOTAL_RECORDS_IN_QUEUE){#Event Group: "RECON_ENGINE" + Event Type: "TOTAL_RECORDS_IN_QUEUE"
      
	  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
	  eval{
	     #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Refacor the way of getting DB connection and executing SQL statements Start
	     my $trails_connection;#var used to store Trails DB connection object

	     #Get Trails DB Connection 
         $trails_connection = Database::Connection->new('trails');

         #Get the total record number in the queue
         $totalCnt = getTotalRecordCountInQueueFunction($trails_connection);
	
         #Disconnect Trails DB Connection 
	     $trails_connection->disconnect();
	     #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Refacor the way of getting DB connection and executing SQL statements End      
	     $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	     print LOG "[$currentTimeStamp]{TotalRecordsInQueue Number: $totalCnt} is for {Event Group Name: $groupName} + {Event Name: $eventName}.\n";
	     $eventFiredTime = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
         $eventFiredTime.=".000000"; 
	     #Insert record into the EVENT DB TABLE
         #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	     my $event = new HealthCheck::OM::Event();
	     $event->eventId($eventID);#set eventId
         $event->eventValue($totalCnt);#set eventValue
	     $event->eventRecordTime($eventFiredTime);#set eventRecordTime
	     $event->insert($staging_connection);
         #Added by Larry for HealthCheck And Monitor Module - Phase 2B End
         $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	     print LOG "[$currentTimeStamp]Event Record - {EVENT_ID: $eventID} + {VALUE: $totalCnt} + {RECORD_TIME: $eventFiredTime} has been inserted into EVENT DB Table successfully.\n";
	     #Event Rule Check
	     eventRuleCheck($groupName,$eventName,$totalCnt);
	  };#end eval
	  if($@){
	     $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
	     $emailFullContent.="$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $groupName} + {Event Name: $eventName}.\n";#append database exception message into email content
		 $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				    
         $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
         print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $groupName} + {Event Name: $eventName}.\n"; 
	  }
	  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
   }
   elsif($groupName eq $RECON_ENGINE && $eventName eq $TOTAL_CUSTOMERS_IN_QUEUE){#Event Group: "RECON_ENGINE" + Event Type: "TOTAL_CUSTOMERS_IN_QUEUE"
      #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
	  eval{
         #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Refacor the way of getting DB connection and executing SQL statements Start
         my $trails_connection;#var used to store Trails DB connection object

	     #Get Trails DB Connection 
         $trails_connection = Database::Connection->new('trails');

         #Get the total customer number in the queue
         $totalCnt = getTotalCustomerCountInQueueFunction($trails_connection);
	
         #Disconnect Trails DB Connection 
	     $trails_connection->disconnect();
	     #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Refacor the way of getting DB connection and executing SQL statements End
	     $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
         print LOG "[$currentTimeStamp]{TotalCustomersInQueue Number: $totalCnt} is for {Event Group Name: $groupName} + {Event Name: $eventName}.\n";
         $eventFiredTime = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
         $eventFiredTime.=".000000"; 
	     #Insert record into the EVENT DB TABLE
         #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	     my $event = new HealthCheck::OM::Event();
	     $event->eventId($eventID);#set eventId
         $event->eventValue($totalCnt);#set eventValue
	     $event->eventRecordTime($eventFiredTime);#set eventRecordTime
	     $event->insert($staging_connection);
         #Added by Larry for HealthCheck And Monitor Module - Phase 2B End
         print LOG "[$currentTimeStamp]Event Record - {EVENT_ID: $eventID} + {VALUE: $totalCnt} + {RECORD_TIME: $eventFiredTime} has been inserted into EVENT DB Table successfully.\n";
	     #Event Rule Check
	     eventRuleCheck($groupName,$eventName,$totalCnt);
      };#end eval
	  if($@){
	     $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
	     $emailFullContent.="$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $groupName} + {Event Name: $eventName}.\n";#append database exception message into email content
		 $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				    
         $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
         print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $groupName} + {Event Name: $eventName}.\n"; 
	  }
	  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
   }
   elsif($groupName eq $TRAILS_BRAVO_CORE_SCRIPTS && $eventName eq $CONTINUOUS_RUN_SCRIPTS){#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "CONTINUOUS_RUN_SCRIPTS"
  	  #For Event Type "CONTINUOUS_RUN_SCRIPTS",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
   elsif(($groupName eq $TRAILS_BRAVO_CORE_SCRIPTS && $eventName eq $ATPTOSTAGING_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "ATPTOSTAGING_START_STOP_SCRIPT"
       ||($groupName eq $TRAILS_BRAVO_CORE_SCRIPTS && $eventName eq $SWCMTOSTAGING_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "SWCMTOSTAGING_START_STOP_SCRIPT"
	   ||($groupName eq $TRAILS_BRAVO_CORE_SCRIPTS && $eventName eq $MOVEMAINFRAME_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "MOVEMAINFRAME_START_STOP_SCRIPT"
	   ||($groupName eq $TRAILS_BRAVO_CORE_SCRIPTS && $eventName eq $BRAVOREPORTFORK_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "BRAVOREPORTFORK_START_STOP_SCRIPT"
	   ||($groupName eq $TRAILS_BRAVO_CORE_SCRIPTS && $eventName eq $STAGINGMOVE_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "STAGINGMOVE_START_STOP_SCRIPT"
	   ){
  	  #For "Start/Stop Scripts",the eventValue value is not needed. It needs to be queried from EVENT DB table
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   #Added by Larry for HealthCheck And Monitor Module - Phase 2B End
   #Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
   elsif($groupName eq $FILE_SYSTEM_MONITORING && $eventName eq $FILE_SYSTEM_THRESHOLD_MONITORING){#Event Group: "FILE_SYSTEM_MONITORING" + Event Type: "FILE_SYSTEM_THRESHOLD_MONITORING"
  	  #For Event Type "FILE_SYSTEM_THRESHOLD_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   #Added by Larry for HealthCheck And Monitor Module - Phase 3 End
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
   elsif($groupName eq $DATABASE_MONITORING && $eventName eq $TRAILSRP_DB_APPLY_GAP_MONITORING){#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSRP_DB_APPLY_GAP_MONITORING"
  	  #For Event Type "TRAILSRP_DB_APPLY_GAP_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
   elsif($groupName eq $DATABASE_MONITORING && $eventName eq $CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING){#Event Group: "DATABASE_MONITORING" + Event Type: "CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING"
  	  #For Event Type "CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
   elsif($groupName eq $DATABASE_MONITORING && $eventName eq $TRAILSST_DB_APPLY_GAP_MONITORING){#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSST_DB_APPLY_GAP_MONITORING"
  	  #For Event Type "TRAILSST_DB_APPLY_GAP_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   elsif($groupName eq $DATABASE_MONITORING && $eventName eq $TRAILSRP_DB_APPLY_GAP_MONITORING_2){#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSRP_DB_APPLY_GAP_MONITORING_2"
  	  #For Event Type "TRAILSRP_DB_APPLY_GAP_MONITORING_2",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   }
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 Start
   elsif($groupName eq $APPLICATION_MONITORING && $eventName eq $WEBAPP_RUNNING_STATUS_CHECK_MONITORING){#Event Group: "APPLICATION_MONITORING" + Event Type: "WEBAPP_RUNNING_STATUS_CHECK_MONITORING"
  	  #For Event Type "WEBAPP_RUNNING_STATUS_CHECK_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   } 
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 End
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 Start
   elsif($groupName eq $DATABASE_MONITORING && $eventName eq $DB_EXCEPTION_STATUS_CHECK_MONITORING){#Event Group: "DATABASE_MONITORING" + Event Type: "DB_EXCEPTION_STATUS_CHECK_MONITORING"
  	  #For Event Type "DB_EXCEPTION_STATUS_CHECK_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   } 
   #Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 End
   #Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10 Start
   elsif($groupName eq $DATABASE_MONITORING && $eventName eq $RECON_QUEUES_DUPLICATE_DATA_MONITORING_AND_CLEANUP){#Event Group: "DATABASE_MONITORING" + Event Type: "DB_EXCEPTION_STATUS_CHECK_MONITORING"
  	  #For Event Type "DB_EXCEPTION_STATUS_CHECK_MONITORING",the eventValue value is not needed.
	  #So set 0 for eventValue var
	  eventRuleCheck($groupName,$eventName,0);
   } 
   #Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10 End
   #A piece of code template which is used for 'New Event Group' + 'New Event Type' business logic
   #elsif($groupName eq "SAMPLE_GROUP_NAME" && $eventName eq "SAMPLE_EVENT_NAME"){#Event Group: "SAMPLE_GROUP_NAME" + Event Type: "SAMPLE_EVENT_NAME"
   #Add 'New Event Group' + 'New Event Type' business logic here
   #}
 }

#This method is used to do event rule check
#For any new event rule, you need to add new business logic here
sub eventRuleCheck{
 my ($triggerEventGroup,$triggerEventName,$triggerEventValue) = @_;

     $triggerEventGroup = trim($triggerEventGroup);#Remove space chars
     $triggerEventName = trim($triggerEventName);#Remove space chars

     #Event Rule Check Logic
	 #Temp Vars Definition For Event Rule
	 my $metaRuleCode;#For example, "ERC001"
	 my $metaRuleTriggerEventGroup;#For example, "TRAILS_BRAVO_CORE_SCRIPTS"
	 my $metaRuleTriggerEventName;#For example, "CONTINUOUS_RUN_SCRIPTS"
	 my $metaRuleParameter1;#For example, "TAP3"
     my $metaRuleParameter2;#For example, "reconEngine.pl'softwareToBravo.pl'ipAddressToBravo.pl"
     my $metaRuleParameter3;#For example, "TAP"
     my $metaRuleParameter4;#For example, "doranaToSwasset.pl'hdiskToStaging.pl'ipAddressToStaging.pl"
     my $metaRuleParameter5;#For example, "N/A"
	 #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
     my $metaRuleParameter6;#For example, "N/A"
     my $metaRuleParameter7;#For example, "N/A"
     my $metaRuleParameter8;#For example, "N/A"
     my $metaRuleParameter9;#For example, "N/A"
     my $metaRuleParameter10;#For example, "N/A"
	 #Added by Larry for HealthCheck And Monitor Module - Phase 2B End
 	 my $metaRuleTitle;#For example, "Loader Running Status on @1 Server"
	 my $metaRuleMessage;#For example, "Loader @2 is currently not running."
     my $metaRuleHandlingInstrcutionCode;#For example, "E-TBS-CRS-001"
	 my $metaRuleTriggerFrequency;#For example, 1(Unit:Hour)

 	 foreach my $metaRule (@ruleMetaRecords){#Go loop event rules
	      $metaRuleCode = trim($metaRule->[$EVENT_RULE_CODE_INDEX]);#Remove space chars
	      $metaRuleTriggerEventGroup = trim($metaRule->[$TRIGGERED_EVENT_GROUP_NAME_INDEX]);#Remove space chars
          $metaRuleTriggerEventName = trim($metaRule->[$TRIGGERED_EVENT_NAME_INDEX]);#Remove space chars
          $metaRuleParameter1 = trim($metaRule->[$PARAMETER_1_INDEX]);#Remove space chars
		  $metaRuleParameter2 = trim($metaRule->[$PARAMETER_2_INDEX]);#Remove space chars
          $metaRuleParameter3 = trim($metaRule->[$PARAMETER_3_INDEX]);#Remove space chars
		  $metaRuleParameter4 = trim($metaRule->[$PARAMETER_4_INDEX]);#Remove space chars
		  $metaRuleParameter5 = trim($metaRule->[$PARAMETER_5_INDEX]);#Remove space chars
		  #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
          $metaRuleParameter6 = trim($metaRule->[$PARAMETER_6_INDEX]);#Remove space chars
          $metaRuleParameter7 = trim($metaRule->[$PARAMETER_7_INDEX]);#Remove space chars
		  $metaRuleParameter8 = trim($metaRule->[$PARAMETER_8_INDEX]);#Remove space chars
		  $metaRuleParameter9 = trim($metaRule->[$PARAMETER_9_INDEX]);#Remove space chars
		  $metaRuleParameter10 = trim($metaRule->[$PARAMETER_10_INDEX]);#Remove space chars
		  #Added by Larry for HealthCheck And Monitor Module - Phase 2B End
	      $metaRuleTitle = trim($metaRule->[$EVENT_RULE_TITLE]);#Remove space chars
          $metaRuleMessage = trim($metaRule->[$EVENT_RULE_MESSAGE]);#Remove space chars
          $metaRuleHandlingInstrcutionCode = trim($metaRule->[$EVENT_RULE_HANDLING_INSTRUCTION_CODE]);#Remove space chars
          $metaRuleTriggerFrequency = trim($metaRule->[$EVENT_RULE_TRIGGER_FREQUENCY]);#Remove space chars

          #if(triggerEventGroup == metaRuleTriggerEventGroup) && (triggerEventName == metaRuleTriggerEventName)
		  #then collect the sent email content
	      if($triggerEventGroup eq $metaRuleTriggerEventGroup 
	       &&$triggerEventName eq $metaRuleTriggerEventName
		   &&($loopIndex % $metaRuleTriggerFrequency == 0)#Judge if the trigger frequency has been reached - Event Rule Trigger Frequency Feature
		  )
		  {#judge if equals

             #The following print comments are used for debug
	         print LOG "Event Rule Code: $metaRuleCode\n";
             print LOG "Event Rule Parameter 1: $metaRuleParameter1\n";
             print LOG "Event Rule Parameter 2: $metaRuleParameter2\n";
		     print LOG "Event Rule Parameter 3: $metaRuleParameter3\n";
			 print LOG "Event Rule Parameter 4: $metaRuleParameter4\n";
		     print LOG "Event Rule Parameter 5: $metaRuleParameter5\n";
             print LOG "Event Rule Parameter 6: $metaRuleParameter6\n";
			 print LOG "Event Rule Parameter 7: $metaRuleParameter7\n";
			 print LOG "Event Rule Parameter 8: $metaRuleParameter8\n";
			 print LOG "Event Rule Parameter 9: $metaRuleParameter9\n";
			 print LOG "Event Rule Parameter 10: $metaRuleParameter10\n";
             print LOG "Event Rule Trigger Frequency(Hours): $metaRuleTriggerFrequency\n";
             
			 #############THE FOLLOWING PIECE OF CODE IS THE RULE CORE BUSINESS LOGIC!!!!!!################################
			 if(($triggerEventGroup eq $TRAILS_BRAVO_CORE_SCRIPTS) && ($triggerEventName eq $CONTINUOUS_RUN_SCRIPTS))#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "CONTINUOUS_RUN_SCRIPTS"
			 {
			     #Define vars
				 my @loaderList;
				 my $loaderName;
				 my $returnProcessNum;
				 my $processedRuleTitle;
				 my $processedRuleMessage;
				 my @emailAlertMessageArray = ();
				 my $emailAlertMessageCount;
				
			     if($SERVER_MODE eq $metaRuleParameter1){#TAP3 Server
                    @loaderList = split(/\'/,$metaRuleParameter2);#TAP3 Server for toBravo loaders
                 }
				 elsif($SERVER_MODE eq $metaRuleParameter3){#TAP Server
				    @loaderList = split(/\'/,$metaRuleParameter4);#TAP Server for toStaging loaders
				 }

                 foreach $loaderName (@loaderList){#go loop for loader list
			        $processedRuleTitle = $metaRuleTitle;#reset the defined meta rule message to processedRuleTitle var for every loop
					$processedRuleMessage = $metaRuleMessage;#reset the defined meta rule message to processedRuleMessage var for every loop
                    
					#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
					my $specialLoaderNameMatched = ($loaderName=~ m/$CONTINUOUS_RUN_SCRIPTS_SPECIAL_CHECK_LIST/);#$CONTINUOUS_RUN_SCRIPTS_SPECIAL_CHECK_LIST = "swkbt"
					if($specialLoaderNameMatched == 1){
					  print LOG "Matched special loader name[$CONTINUOUS_RUN_SCRIPTS_SPECIAL_CHECK_LIST] is LoaderName: $loaderName\n";
                      $returnProcessNum = `ps -ef|grep $loaderName|wc -l`;#calculate the number of running processes for certain loader name
					  $returnProcessNum--;#decrease the unix command itself from the total calculated process number
					}
					else{
					  $returnProcessNum = `ps -ef|grep $loaderName|grep start|wc -l`;#calculate the number of running processes for certain loader name
					}
                    #Added by Larry for HealthCheck And Monitor Module - Phase 2B End

					chomp($returnProcessNum);#remove the return line char
                    $returnProcessNum--;#decrease the unix command itself from the total calculated process number
					$currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                  	print LOG "[$currentTimeStamp]Return Process Number is $returnProcessNum for linux command \"ps \-ef\|grep $loaderName\|grep start\|wc -l\".\n";
				    if($returnProcessNum==0){#if the number of return processes is 0 for certain loader name, it means that it is not running
					   print LOG "LoaderName: {$loaderName}\n";
                       $processedRuleTitle =~ s/\@1/$SERVER_MODE/g;
					   $processedRuleMessage =~ s/\@2/$loaderName/g;
					   push @emailAlertMessageArray,"$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email message array
					   print LOG "$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
					   print LOG "$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $metaRuleHandlingInstrcutionCode\n";
					   print LOG "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";
                       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                       print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $metaRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
				    }#end of if($returnProcessNum==0)
				 }#end of foreach $loaderName (@tap3LoaderList)
                 
				 $emailAlertMessageCount = scalar(@emailAlertMessageArray);
                 if($emailAlertMessageCount > 0){#Append email content if has email alert message
			          $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                      $processedRuleTitle = $metaRuleTitle;
                      $processedRuleTitle =~ s/\@1/$SERVER_MODE/g;
                      $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
					  $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $metaRuleHandlingInstrcutionCode\n";#append event rule handling instruction code into email content
                      foreach my $emailAlertMessage (@emailAlertMessageArray){#go loop for email alert message
					    $emailFullContent.="$emailAlertMessage";#append event rule message into email content
                      }  
					  $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
			     }
			 }
			 #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
			 elsif((($triggerEventGroup eq $TRAILS_BRAVO_CORE_SCRIPTS && $triggerEventName eq $ATPTOSTAGING_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "ATPTOSTAGING_START_STOP_SCRIPT"
                 ||($triggerEventGroup eq $TRAILS_BRAVO_CORE_SCRIPTS && $triggerEventName eq $SWCMTOSTAGING_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "SWCMTOSTAGING_START_STOP_SCRIPT"
	             ||($triggerEventGroup eq $TRAILS_BRAVO_CORE_SCRIPTS && $triggerEventName eq $MOVEMAINFRAME_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "MOVEMAINFRAME_START_STOP_SCRIPT"
				 ||($triggerEventGroup eq $TRAILS_BRAVO_CORE_SCRIPTS && $triggerEventName eq $BRAVOREPORTFORK_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "BRAVOREPORTFORK_START_STOP_SCRIPT"
                 ||($triggerEventGroup eq $TRAILS_BRAVO_CORE_SCRIPTS && $triggerEventName eq $STAGINGMOVE_START_STOP_SCRIPT)#Event Group: "TRAILS_BRAVO_CORE_SCRIPTS" + Event Type: "STAGINGMOVE_START_STOP_SCRIPT"
	            )&&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
                  my $getEventDataConvertedSQL = $GET_EVENT_DATA_FOR_CERTAIN_TIME_SQL;
				  my $eventRecordCnt = 0;#set 0 as the initial value for Event Record Count
                  my $ruleServerMode = $metaRuleParameter1;#server mode - for example: TAP
				  my $loaderCronNumber = $metaRuleParameter2;#loader cron number - for example: 48(Hours)
				  my $ruleTitle = $metaRuleTitle;#rule title - for example: Loader Running Status on @1 Server
				  my $loaderNotStartedMessage = $metaRuleParameter3;#loader not started message - for example: Loader @2 did not start as setup in cron for every @3 hours. Last start at @4 Last stop at @5.
                  my $loaderNotStartedHandlingInstructionCode = $metaRuleParameter4;#loader not started handling instruction code - for example: E-TBS-ATS-001
				  my $loaderFailedMessage = $metaRuleParameter5;#loader failed message - for example: Loader @2 ran failed at @3.
				  my $loaderFailedHandlingInstructionCode = $metaRuleParameter6;#loader failed handling instruction code - for example: E-TBS-ATS-002 
                  my $loaderName = $metaRuleParameter7;#loader name - for example: atpToStaging.pl
				  my $loaderAlwaysRunFailesMessage = $metaRuleParameter8;#loader always run failes message - for example: Loader @2 always runs failed. There is no successful run record which has been found for it.

                  my $processedRuleTitle;#var used to store processed rule title
				  my $processedRuleMessage;#var used to store processed rule message
				  my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code
                  
				  my @totalCntRow;#var used to store the query total count row
				  my $eventDataAllCnt;#var used to store the total count for certain event rule type 
				  my $startTimeForTheLastSuccessRun = "";#var used to store the start time for the last successfully run. The initial value is empty string
                  my $endTimeForTheLastSuccessRun = "";#var used to store the end time for the last successfully run. The initial value is empty string
                  my $startTimeForTheLastSuccessRunFindFlag = 0;#var used to store the start time for the last successfully run find flag. The initial value is 0: false
				  my $endTimeForTheLastSuccessRunFindFlag = 0;#var used to store the end time for the last successfully run find flag. The initial value is 0: false
				  my $loaderStatusCode;#var used to store loader status code - for example: "STARTED"
				  my $loaderErrorFlag = 0;#var used to store loader error flag. The initial value is 0: false
				  my $loaderErrorTime;#var used to store loader error time
				  
				  $getEventDataConvertedSQL =~ s/\#1/$loaderCronNumber/g;
                  print LOG "Converted Get Event Data SQL: $getEventDataConvertedSQL\n";
				  
				  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements Start
                  #Get Event Data For Certain Time
             	  my @eventRows = getEventDataForCertainTimeFunction($staging_connection,$triggerEventGroup,$triggerEventName,$getEventDataConvertedSQL);
                  
				  foreach my $eventRow (@eventRows){
			          $eventRecordCnt++;
					  $loaderStatusCode = trim($eventRow->[$EVENT_VALUE_DATA_INDEX]);#Remove space chars for loader status code
					  if($loaderStatusCode eq $LOADER_ERRORED_STATUS_CODE#"ERRORED" Loader Status Code
					  &&($eventRecordCnt == 1)){#check if the first record
					     $loaderErrorFlag = 1;
                         $loaderErrorTime = $eventRow->[$EVENT_RECORD_TIME_DATA_INDEX];#get the loader error time
						 print LOG "{Error Time: $loaderErrorTime} for {Loader Name: $loaderName} has been found.\n";
					  }
				  }#end foreach my $eventRow (@eventRows)
				  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements End
                  
				  if($eventRecordCnt==0){#It means that the loader has not started yet
            
			          #Get the total count for certain event rule type 
					  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 - Refacor the way of getting DB connection and executing SQL statements Start
					  $eventDataAllCnt = getEventAllDataCountFunction($staging_connection,$triggerEventGroup,$triggerEventName);
					  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 - Refacor the way of getting DB connection and executing SQL statements End
					  print LOG "{Total Count: $eventDataAllCnt} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}\n";
                      
					  if($eventDataAllCnt!=0){#trigger event rule check only if the loader has been ran before
						  $processedRuleTitle = $ruleTitle;
						  $processedRuleTitle =~ s/\@1/$ruleServerMode/g;#replace @1 with server mode value - for example: TAP
					      push @startAndStopScriptsEmailAlertArray,"$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into start and stop scripts email alert array
					      print LOG "$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
                      
                          $processedRuleHandlingInstructionCode = $loaderNotStartedHandlingInstructionCode;
                          push @startAndStopScriptsEmailAlertArray,"$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into start and stop scripts email alert array
                          print LOG "$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
					  
                          #Get the start time and stop time of the last successfully run for certain loader
						  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 - Refacor the way of getting DB connection and executing SQL statements Start
					      my @eventAllDataRows = getEventAllDataFunction($staging_connection,$triggerEventGroup,$triggerEventName);
						  
						  foreach my $eventRow (@eventAllDataRows){
						
							 $loaderStatusCode = trim($eventRow->[$EVENT_VALUE_DATA_INDEX]);#Remove space chars for loader status code
							 print LOG "{Loader Status Code: $loaderStatusCode}\n";
                            
							 #Terminate the loop when the last successfully run start time and end time for loader have been found
                             if($startTimeForTheLastSuccessRunFindFlag && $endTimeForTheLastSuccessRunFindFlag){
							    print LOG "{Start Time For The Last Success Run: $startTimeForTheLastSuccessRun} + {End Time For The Last Success Run: $endTimeForTheLastSuccessRun} for {Loader Name: $loaderName} has been found.\n";
							    last;  
							 }
                         
							 if($loaderStatusCode eq $LOADER_STOPPED_STATUS_CODE){#"STOPPED" Loader Status Code
							    $endTimeForTheLastSuccessRunFindFlag = 1;
                                $endTimeForTheLastSuccessRun =  $eventRow->[$EVENT_RECORD_TIME_DATA_INDEX];#get the last successfully run end time
							 }
                             elsif($loaderStatusCode eq $LOADER_STARTED_STATUS_CODE#"STARTED" Loader Status Code
							     &&($endTimeForTheLastSuccessRunFindFlag == 1)){#The "STOPPED" record has been found already   	
                                $startTimeForTheLastSuccessRunFindFlag = 1; 							   
                                $startTimeForTheLastSuccessRun =  $eventRow->[$EVENT_RECORD_TIME_DATA_INDEX];#get the last successfully run start time 
                             }
							 else{
							    #Reset the last run start time and end time flags and values
							    $endTimeForTheLastSuccessRunFindFlag = 0;
							    $startTimeForTheLastSuccessRunFindFlag = 0;
                                $endTimeForTheLastSuccessRun = "";
                                $startTimeForTheLastSuccessRun = "";
							 }
                          }#end foreach my $eventRow (@eventAllDataRows)
						  #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 - Refacor the way of getting DB connection and executing SQL statements End
                          
						  if($startTimeForTheLastSuccessRunFindFlag && $endTimeForTheLastSuccessRunFindFlag){#support the last successfully ran record has been found case
							 $processedRuleMessage = $loaderNotStartedMessage;
                             $processedRuleMessage =~ s/\@2/$loaderName/g;#replace @2 with loader name - for example: atpToStaging.pl
                             $processedRuleMessage =~ s/\@3/$loaderCronNumber/g;#replace @3 with loader cron number - for example: 48(Hours)
                             $processedRuleMessage =~ s/\@4/$startTimeForTheLastSuccessRun/g;#replace @4 with loader last successfully run start time - for example: 2013-05-10-04.29.38.000000
						     $processedRuleMessage =~ s/\@5/$endTimeForTheLastSuccessRun/g;#replace @5 with loader last successfully run end time - for example: 2013-05-10-04.31.08.000000
                          }
						  else{#support the last successfully ran record has not been found case
						     $processedRuleMessage = $loaderAlwaysRunFailesMessage;
                             $processedRuleMessage =~ s/\@2/$loaderName/g;#replace @2 with loader name - for example: atpToStaging.pl
						  }

					      push @startAndStopScriptsEmailAlertArray,"$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n\n";#append event rule message into start and stop scripts email alert array
					      print LOG "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";

					      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                          print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
					  }#end if($eventDataAllCnt!=0)
                  }#end if($eventRecordCnt==0)
				  else{#$eventRecordCnt > 0 case
				     if($loaderErrorFlag){#support loader error run case
					    $processedRuleTitle = $ruleTitle;
						$processedRuleTitle =~ s/\@1/$ruleServerMode/g;#replace @1 with server mode value - for example: TAP
					    push @startAndStopScriptsEmailAlertArray,"$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into start and stop scripts email alert array
					    print LOG "$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";

                        $processedRuleHandlingInstructionCode = $loaderFailedHandlingInstructionCode;
                        push @startAndStopScriptsEmailAlertArray,"$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into start and stop scripts email alert array
                        print LOG "$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
						
                        $processedRuleMessage = $loaderFailedMessage;
                        $processedRuleMessage =~ s/\@2/$loaderName/g;#replace @2 with loader name - for example: atpToStaging.pl
                        $processedRuleMessage =~ s/\@3/$loaderErrorTime/g;#replace @3 with loader error time - for example: 2013-05-10-04.29.38.000000
						push @startAndStopScriptsEmailAlertArray,"$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n\n";#append event rule message into start and stop scripts email alert array
					    print LOG "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";

					    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                        print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
					 }#end if($loaderErrorFlag)
				  }#end else #$eventRecordCnt > 0 case
          	 }
			 #Added by Larry for HealthCheck And Monitor Module - Phase 2B End
			 #Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
             elsif($triggerEventGroup eq $FILE_SYSTEM_MONITORING && $triggerEventName eq $FILE_SYSTEM_THRESHOLD_MONITORING){#Event Group: "FILE_SYSTEM_MONITORING" + Event Type: "FILE_SYSTEM_THRESHOLD_MONITORING"
         		 my $serverMode = $SERVER_MODE;#var used to store server mode - for example: 'TAP'
				 my $monitorFileSystemList = "";#var used to store monitor file system list - for example: '/db2/cndb~95%'/db2/staging~95%'/db2/swasset~95%'/db2/tap~90%'/var/bravo~90%'/var/ftp~90%'/var/http_reports~90%'/var/staging~90%' #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6
                 my @monitorFileSystemListArray;#array used to store monitor file system list array
				 my $fileSystemDefinition;#var used to store one monitoring file system definition - for example: '/db2/cndb~95%'
				 my @fileSystemDefinitionArray;#array used to store the parsed file system definition- for ecxample: '(/db2/cndb,95%)'
				 my $fileSystem;#var used to store one monitoring file system - for example: '/db2/cndb'
				 my $threshold;#var used to store one monitoring file system threshold - for example: '95%'
                 my $usedPct;#var used to store the current used file system percentage - for example: 6%
				 my @fileSystemEmailAlertMessageArray = ();#array used to store the file system email alert messages
				 my $fileSystemEmailAlertMessageCount;#var used to store the count of the file system email alert messages
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
				 my $remoteServerFileSystemMonitoringFlag = $metaRuleParameter7;#var used to store the remote server file system monitor flag 'Y' or 'N' 
				 my $remoteFileGetMethod = $metaRuleParameter8;#var used to store the remote file get method for Bravo/Trails server. For example, SFTP or GSA
				 #Vars Definition for Bravo Server
				 my @bravoServerFileSystemRecords = ();
				 my @bravoServerFileSystemRecord;
                 my $bravoServerMonitoringFileSystemList;#var used to store bravo server monitoring file system list - "/opt/bravo~90%'/var/bravo~95%'/var/ftp/scan~90%"
                 my @bravoServerMonitoringFileSystemListArray;#array used to store bravo server monitoring file system list array - ("/opt/bravo~90%","/var/bravo~95%","/var/ftp/scan~90%") 
				 my @parsedBravoServerMonitoringFileSystemArray;#array used to store parsed bravo server monitoring file system array - for example, ("/opt/bravo","90"%)
                 my @parsedBravoServerMonitoringFileSystemListArray;#array used to store parsed bravo server monitoring file system list array - (("/opt/bravo","90%"),("/var/bravo","95%"),("/var/ftp/scan","90%"))
                 my @bravoServerFileSystemEmailAlertMessageArray = ();#array used to store the bravo server file system email alert messages
				 my $bravoServerFileSystemEmailAlertMessageArrayCount = 0;#var used to store the count of the bravo server file system email alert messages
				 #Vars Definition for Trails Server
                 my @trailsServerFileSystemRecords = ();
				 my @trailsServerFileSystemRecord;
                 my $trailsServerMonitoringFileSystemList;#var used to store trails server monitoring file system list - "/opt/trails~90%'/var/trails~95%"
                 my @trailsServerMonitoringFileSystemListArray;#array used to store trails server monitoring file system list array - ("/opt/trails~90%","/var/trails~95%") 
				 my @parsedTrailsServerMonitoringFileSystemArray;#array used to store parsed trails server monitoring file system array - for example, ("/opt/trails","90"%)
                 my @parsedTrailsServerMonitoringFileSystemListArray;#array used to store parsed trails server monitoring file system list array - (("/opt/trails","90%"),("/var/trails","95%"))
                 my @trailsServerFileSystemEmailAlertMessageArray = ();#array used to store the trails server file system email alert messages
				 my $trailsServerFileSystemEmailAlertMessageArrayCount = 0;#var used to store the count of the trails server file system email alert messages
				 #Vars Definition for Trails Server
                 my @tap3ServerFileSystemRecords = ();
				 my @tap3ServerFileSystemRecord;
                 my $tap3ServerMonitoringFileSystemList;#var used to store trails server monitoring file system list - "/opt/trails~90%'/var/trails~95%"
                 my @tap3ServerMonitoringFileSystemListArray;#array used to store trails server monitoring file system list array - ("/opt/trails~90%","/var/trails~95%") 
				 my @parsedTap3ServerMonitoringFileSystemArray;#array used to store parsed trails server monitoring file system array - for example, ("/opt/trails","90"%)
                 my @parsedTap3ServerMonitoringFileSystemListArray;#array used to store parsed trails server monitoring file system list array - (("/opt/trails","90%"),("/var/trails","95%"))
                 my @tap3ServerFileSystemEmailAlertMessageArray = ();#array used to store the trails server file system email alert messages
				 my $tap3ServerFileSystemEmailAlertMessageArrayCount = 0;#var used to store the count of the trails server file system email alert messages
			     #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End

				 my $processedRuleTitle;#var used to store processed rule title - for example: 'Filespace monitoring on @1 Server'
				 my $processedRuleMessage;#var used to store processed rule message - for example: 'Filespace equal to or above @2 for @3 has been reached.'
				 my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code - for example: 'E-FSM-FST-001'
				 
                 $processedRuleTitle = $metaRuleTitle;
                 $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
                 push @fileSystemEmailAlertMessageArray, "$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				 print LOG "The Processed Rule Title: {$processedRuleTitle}\n";

                 $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                 push @fileSystemEmailAlertMessageArray, "$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				 print LOG "The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

			     if($serverMode eq $metaRuleParameter1){#TAP Server
                    $monitorFileSystemList = $metaRuleParameter2;#Filesystem Monitor List: '/db2/cndb~95%'/db2/staging~95%'/db2/swasset~95%'/db2/tap~90%'/var/bravo~90%'/var/ftp~90%'/var/http_reports~90%'/var/staging~90%'
				 }
				 elsif($serverMode eq $metaRuleParameter3){#BRAVO Server
                    $monitorFileSystemList = $metaRuleParameter4;#Filesystem Monitor List: '/opt/bravo~90%'/var/bravo~95%'/var/ftp/scan~90%'
				 }
                 elsif($serverMode eq $metaRuleParameter5){#TRAILS Server
					$monitorFileSystemList = $metaRuleParameter6;#Filesystem Monitor List: '/opt/trails~90%'/var/trails~95%'
				 }
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
				 elsif($serverMode eq $metaRuleParameter9){#TAP3 Server
                    $monitorFileSystemList = $metaRuleParameter10;#Filesystem Monitor List: '/boot~90%'/opt/reports~90%'/opt/tap~90%'/var/staging~90%'/opt/staging~90%'/usr~90%'/var~90%'/tmp~90%'/opt~90%'/home~90%D for TAP3
				 }
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End
                 #elsif($serverMode eq $metaRuleParameter9){#TAP2 Server
                 #   $monitorFileSystemList = $metaRuleParameter10;#TBD for TAP2
				 #}

				 print LOG "File System Monitor Server Mode: {$serverMode}\n";
                 print LOG "File System Monitor List: {$monitorFileSystemList}\n";
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
		         print LOG "Remote Server File System Monitor Flag: {$remoteServerFileSystemMonitoringFlag}\n";
				
				 if($monitorFileSystemList ne ""){#only do file system using percentage check when monitroing file system list has been defined for target server for example, TAP
				    @monitorFileSystemListArray = split(/\'/,$monitorFileSystemList);
				    foreach $fileSystemDefinition (@monitorFileSystemListArray){#go loop for file system list array
                      print LOG "File System Definition: {$fileSystemDefinition}\n";
                      @fileSystemDefinitionArray = split(/\~/,$fileSystemDefinition);
                      $fileSystem = $fileSystemDefinitionArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX];#file system - for example: '/db2/cndb'
                      $fileSystem = trim($fileSystem);#Remove space chars
				      print LOG "File System: {$fileSystem}\n";
                      $threshold = $fileSystemDefinitionArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX];#file system monitoring threshold - for example: '95%'
                      $threshold = trim($threshold);#Remove space chars
                      print LOG "Threshold: {$threshold}\n";

				      if($serverMode eq $TAP || $serverMode eq $TAP2){#If TAP or TAP2 server, then the information of file system using percentage is gotten from local server directly  
				         my $matchedFileSystem = `df -h|grep $fileSystem`;
				         chomp $matchedFileSystem;#remove the return line char
                         $matchedFileSystem = trim($matchedFileSystem);#Remove space chars
				         if($matchedFileSystem ne ""){
				            print LOG "Matched File System: {$matchedFileSystem} for File System: {$fileSystem}\n";
					 
					        #Sample Record: {12G  9.5G  1.7G  86% /db2/cndb}
                            $usedPct = `df -h|grep $fileSystem|awk '{print \$$USED_DISK_PCT_INDEX;}'`;#$USED_DISK_PCT_INDEX = 4;
                            chomp $usedPct;
                            $usedPct = trim($usedPct);
					        print LOG "The File System Used Percentage: {$usedPct} for File System: {$fileSystem}\n";

					        if(compareUsedDiskPctWithFileSystemThreshold($usedPct,$threshold) >=0){#if the current used file system percentage >= file system defined threshold value, then trigger the event rule alert message #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6
					           print LOG "The File System Used Percentage: {$usedPct} is great then or equal to the file system defined threshold value: {$threshold}\n";

						       $processedRuleMessage = $metaRuleMessage;
                               $processedRuleMessage =~ s/\@2/$usedPct/g;#replace @2 with the current used file system percentage value - for example: '98%'
                               $processedRuleMessage =~ s/\@3/$fileSystem/g;#replace @3 with the monitoring file system value - for example: '/db2/cndb'
                               $processedRuleMessage =~ s/\@4/$threshold/g;#replace @4 with the monitoring file system threshold value - for example: '95%' 

						       push @fileSystemEmailAlertMessageArray, "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";
                               print LOG "The Processed Rule Message: {$processedRuleMessage}\n";
					        }#end if($usedPct ge $threshold) 
				         }#end if($matchedFileSystem ne "") 
				         else{#the file system doesn't exist
				           print LOG "File System: {$fileSystem} doesn't exist for $serverMode server.\n";
				         }#end else
				      }#end if($serverMode eq $TAP || $serverMode eq $TAP2)
				    }#end foreach $fileSystemDefinition (@monitorFileSystemListArray)
				 }#end if($monitorFileSystemList ne "")

                 if(($remoteServerFileSystemMonitoringFlag eq $REMOTE_SERVER_FILE_SYSTEM_MONITORING_TURN_ON_FLAG) #$REMOTE_SERVER_FILE_SYSTEM_MONITORING_TURN_ON_FLAG = "Y"
                  &&($serverMode eq $TAP || $serverMode eq $TAP2)){#Only TAP or TAP2 Server can trigger the remote server file system monitoring logic
                    print LOG "The Remote Server File System Monitoring Function has been turned on for Bravo, Trails and TAP3 servers.\n";
                    print LOG "Remote File Get Method: {$remoteFileGetMethod}\n";
					
					#Bravo Server File System Used Disk Monitoring Logic Feature Start 
					$bravoServerMonitoringFileSystemList = $metaRuleParameter4;#Bravo Server - Filesystem Monitoring List: "/opt/bravo~90%'/var/bravo~95%'/var/ftp/scan~90%"
             		if($bravoServerMonitoringFileSystemList ne ""){
                       @bravoServerMonitoringFileSystemListArray = split(/\'/,$bravoServerMonitoringFileSystemList);
				       foreach my $bravoServerMonitoringFileSystemDefinition (@bravoServerMonitoringFileSystemListArray){#go loop for file system list array
                          print LOG "Bravo Server - Monitoring File System Definition: {$bravoServerMonitoringFileSystemDefinition}\n";
                          @parsedBravoServerMonitoringFileSystemArray = split(/\~/,$bravoServerMonitoringFileSystemDefinition);
                          my $bravoServerMonitoringFileSystem = $parsedBravoServerMonitoringFileSystemArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX];#monitoring file system - for example: "/opt/bravo"
                          $bravoServerMonitoringFileSystem = trim($bravoServerMonitoringFileSystem);#Remove space chars
				          print LOG "Bravo Server - Monitoring File System: {$bravoServerMonitoringFileSystem}\n";
                          my $bravoServerMonitoringFileSystemThreshold = $parsedBravoServerMonitoringFileSystemArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX];#monitoring file system threshold - for example: "90%"
                          $bravoServerMonitoringFileSystemThreshold = trim($bravoServerMonitoringFileSystemThreshold);#Remove space chars
                          print LOG "Bravo Server - Monitoring File System Threshold: {$bravoServerMonitoringFileSystemThreshold}\n";

						  push @parsedBravoServerMonitoringFileSystemListArray, [@parsedBravoServerMonitoringFileSystemArray];
                       }#end 

                       #Read File System Using Percentage Information of the download files from Bravo and Trails Servers
					   #Open Bravo Server File System Information File Handler
				       open(BRAVO_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER, "<", $BRAVO_SERVER_FILE_SYSTEM_INFO_FILE ) or die "Bravo Server File System Information File {$BRAVO_SERVER_FILE_SYSTEM_INFO_FILE} doesn't exist. Perl script exits due to this reason.";
                       #Read Record From Bravo Server File System Information File
					   while (my $bravoServerFileSystemUsedPctInfoRecord = <BRAVO_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER>){
						  @bravoServerFileSystemRecord = ();#Reset @bravoServerFileSystemRecord Object Array to be Empty Every Time

					      chomp $bravoServerFileSystemUsedPctInfoRecord;
						  #Remove before and after space chars of a string
						  $bravoServerFileSystemUsedPctInfoRecord = trim($bravoServerFileSystemUsedPctInfoRecord);
						  print LOG "Bravo Server - File System Used Percentage Information Record: {$bravoServerFileSystemUsedPctInfoRecord}\n";
                          my $bravoServerColumnCnt = `echo $bravoServerFileSystemUsedPctInfoRecord|awk '{print NF;}'`;
						  chomp $bravoServerColumnCnt;
                          $bravoServerColumnCnt = trim($bravoServerColumnCnt);
						  print LOG "Bravo Server - The Number of Columns for File System Used Percentage Information Record: {$bravoServerColumnCnt}\n";

	                      my $bravoServerUsedDiskPct;
                          my $bravoServerFileSystem;
						
						  if($bravoServerColumnCnt == 5){
						     $bravoServerUsedDiskPct = `echo $bravoServerFileSystemUsedPctInfoRecord|awk '{print \$$USED_DISK_PCT_INDEX;}'`;
							 $bravoServerFileSystem = `echo $bravoServerFileSystemUsedPctInfoRecord|awk '{print \$$FILE_SYSTEM_INDEX;}'`;
						   }
						   elsif($bravoServerColumnCnt == 6){
						     $bravoServerUsedDiskPct = `echo $bravoServerFileSystemUsedPctInfoRecord|awk '{print \$$USED_DISK_PCT_INDEX_6_FIELDS;}'`;
							 $bravoServerFileSystem = `echo $bravoServerFileSystemUsedPctInfoRecord|awk '{print \$$FILE_SYSTEM_INDEX_6_FIELDS;}'`;
						   }
						  
                           chomp $bravoServerFileSystem;
                           $bravoServerFileSystem = trim($bravoServerFileSystem);
	                       print LOG "Bravo Server - File System: {$bravoServerFileSystem}\n";
						   push @bravoServerFileSystemRecord, $bravoServerFileSystem;

						   chomp $bravoServerUsedDiskPct;
                           $bravoServerUsedDiskPct = trim($bravoServerUsedDiskPct);
	                       print LOG "Bravo Server - Used Disk Percentage: {$bravoServerUsedDiskPct}\n";
						   push @bravoServerFileSystemRecord, $bravoServerUsedDiskPct;

                           push @bravoServerFileSystemRecords, [@bravoServerFileSystemRecord]; 
                       }#end of while

                       #Close Bravo Server File System Information File Handler
					   close BRAVO_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER;
					   
					   #Compare the Defined File System Monitoring Threshold with the Current File System Used Percentage Value
					   my $parsedBravoServerMonitoringFileSystemListArrayCnt = scalar(@parsedBravoServerMonitoringFileSystemListArray);
					   print LOG "Bravo Server - The Count of Defined Monitoring File System List: {$parsedBravoServerMonitoringFileSystemListArrayCnt}\n";
					   my $bravoServerFileSystemRecordsCnt = scalar(@bravoServerFileSystemRecords);
                       print LOG "Bravo Server - The Count of File System List: {$bravoServerFileSystemRecordsCnt}\n";
					   if(($parsedBravoServerMonitoringFileSystemListArrayCnt > 0)
					    &&($bravoServerFileSystemRecordsCnt > 0)){#only go loop file system list array when the count of it is > 0
					       
						   foreach my $parsedBravoServerMonitoringFileSystemArrayAddress (@parsedBravoServerMonitoringFileSystemListArray){
                           my $bravoServerMonitoringFileSystem = trim($parsedBravoServerMonitoringFileSystemArrayAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX]);
                           print LOG "Bravo Server - the Defined Monitoring File System: {$bravoServerMonitoringFileSystem}\n";
						   my $bravoServerMonitoringFileSystemThreshold = trim($parsedBravoServerMonitoringFileSystemArrayAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX]);
                          
                           foreach my $bravoServerFileSystemRecordAddress (@bravoServerFileSystemRecords){
						      my $bravoServerFileSystem = trim($bravoServerFileSystemRecordAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX]);
                              print LOG "Bravo Server - the Current File System: {$bravoServerFileSystem}\n";
							  my $bravoServerUsedDiskPct = trim($bravoServerFileSystemRecordAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX]);
							  if($bravoServerMonitoringFileSystem eq $bravoServerFileSystem){#judge if the current file system is the defined monitoring file system 
							     print LOG "Bravo Server - the Current File System: {$bravoServerFileSystem} is equal to the Defined Monitoring File System: {$bravoServerMonitoringFileSystem}\n";
							     print LOG "Bravo Server - the Current File System Used Disk Percentage: {$bravoServerUsedDiskPct}\n";
								 print LOG "Bravo Server - the Defined Monitoring File System Threshold: {$bravoServerMonitoringFileSystemThreshold}\n";

								 if(compareUsedDiskPctWithFileSystemThreshold($bravoServerUsedDiskPct,$bravoServerMonitoringFileSystemThreshold) >=0){
								    print LOG "Bravo Server - the Current File System Used Disk Percentage: {$bravoServerUsedDiskPct} is great then or equal to the Defined Monitoring File System Threshold: {$bravoServerMonitoringFileSystemThreshold}\n";
                                    
									$processedRuleMessage = $metaRuleMessage;
                                    $processedRuleMessage =~ s/\@2/$bravoServerUsedDiskPct/g;#replace @2 with the current used file system percentage value - for example: '98%'
                                    $processedRuleMessage =~ s/\@3/$bravoServerMonitoringFileSystem/g;#replace @3 with the monitoring file system value - for example: '/db2/cndb'
                                    $processedRuleMessage =~ s/\@4/$bravoServerMonitoringFileSystemThreshold/g;#replace @4 with the monitoring file system threshold value - for example: '95%'
									
                                    push @bravoServerFileSystemEmailAlertMessageArray, "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage";
                                 }
							  }#end if($bravoServerMonitoringFileSystem eq $bravoServerFileSystem)
						   }#end foreach my $bravoServerFileSystemRecordAddress (@bravoServerFileSystemRecords)
					   }#end foreach my $parsedBravoServerMonitoringFileSystemArrayAddress (@parsedBravoServerMonitoringFileSystemListArray)
					   }#end if($parsedBravoServerMonitoringFileSystemListArrayCnt > 0)
                    }#end if($bravoServerMonitoringFileSystemList ne "")
                    #Bravo Server File System Used Disk Monitoring Logic Feature End
					
                    #Trails Server File System Used Disk Monitoring Logic Feature Start
                    $trailsServerMonitoringFileSystemList = $metaRuleParameter6;#Trails Server - Filesystem Monitoring List: "/opt/trails~90%'/var/trails~95%"
             		if($trailsServerMonitoringFileSystemList ne ""){
                       @trailsServerMonitoringFileSystemListArray = split(/\'/,$trailsServerMonitoringFileSystemList);
				       foreach my $trailsServerMonitoringFileSystemDefinition (@trailsServerMonitoringFileSystemListArray){#go loop for file system list array
                          print LOG "Trails Server - Monitoring File System Definition: {$trailsServerMonitoringFileSystemDefinition}\n";
                          @parsedTrailsServerMonitoringFileSystemArray = split(/\~/,$trailsServerMonitoringFileSystemDefinition);
                          my $trailsServerMonitoringFileSystem = $parsedTrailsServerMonitoringFileSystemArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX];#monitoring file system - for example: "/opt/trails"
                          $trailsServerMonitoringFileSystem = trim($trailsServerMonitoringFileSystem);#Remove space chars
				          print LOG "Trails Server - Monitoring File System: {$trailsServerMonitoringFileSystem}\n";
                          my $trailsServerMonitoringFileSystemThreshold = $parsedTrailsServerMonitoringFileSystemArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX];#monitoring file system threshold - for example: "90%"
                          $trailsServerMonitoringFileSystemThreshold = trim($trailsServerMonitoringFileSystemThreshold);#Remove space chars
                          print LOG "Trails Server - Monitoring File System Threshold: {$trailsServerMonitoringFileSystemThreshold}\n";

						  push @parsedTrailsServerMonitoringFileSystemListArray, [@parsedTrailsServerMonitoringFileSystemArray];
                       }#end 

                       #Read File System Using Percentage Information of the download files from Trails and Trails Servers
					   #Open Trails Server File System Information File Handler
				       open(TRAILS_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER, "<", $TRAILS_SERVER_FILE_SYSTEM_INFO_FILE ) or die "Trails Server File System Information File {$TRAILS_SERVER_FILE_SYSTEM_INFO_FILE} doesn't exist. Perl script exits due to this reason.";
                       #Read Record From Trails Server File System Information File
					   while (my $trailsServerFileSystemUsedPctInfoRecord = <TRAILS_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER>){
						  @trailsServerFileSystemRecord = ();#Reset @trailsServerFileSystemRecord Object Array to be Empty Every Time

					      chomp $trailsServerFileSystemUsedPctInfoRecord;
						  #Remove before and after space chars of a string
						  $trailsServerFileSystemUsedPctInfoRecord = trim($trailsServerFileSystemUsedPctInfoRecord);
						  print LOG "Trails Server - File System Used Percentage Information Record: {$trailsServerFileSystemUsedPctInfoRecord}\n";
                          my $trailsServerColumnCnt = `echo $trailsServerFileSystemUsedPctInfoRecord|awk '{print NF;}'`;
						  chomp $trailsServerColumnCnt;
                          $trailsServerColumnCnt = trim($trailsServerColumnCnt);
						  print LOG "Trails Server - The Number of Columns for File System Used Percentage Information Record: {$trailsServerColumnCnt}\n";

	                      my $trailsServerUsedDiskPct;
                          my $trailsServerFileSystem;
						
						  if($trailsServerColumnCnt == 5){
						     $trailsServerUsedDiskPct = `echo $trailsServerFileSystemUsedPctInfoRecord|awk '{print \$$USED_DISK_PCT_INDEX;}'`;
							 $trailsServerFileSystem = `echo $trailsServerFileSystemUsedPctInfoRecord|awk '{print \$$FILE_SYSTEM_INDEX;}'`;
						   }
						   elsif($trailsServerColumnCnt == 6){
						     $trailsServerUsedDiskPct = `echo $trailsServerFileSystemUsedPctInfoRecord|awk '{print \$$USED_DISK_PCT_INDEX_6_FIELDS;}'`;
							 $trailsServerFileSystem = `echo $trailsServerFileSystemUsedPctInfoRecord|awk '{print \$$FILE_SYSTEM_INDEX_6_FIELDS;}'`;
						   }
						  
                           chomp $trailsServerFileSystem;
                           $trailsServerFileSystem = trim($trailsServerFileSystem);
	                       print LOG "Trails Server - File System: {$trailsServerFileSystem}\n";
						   push @trailsServerFileSystemRecord, $trailsServerFileSystem;

						   chomp $trailsServerUsedDiskPct;
                           $trailsServerUsedDiskPct = trim($trailsServerUsedDiskPct);
	                       print LOG "Trails Server - Used Disk Percentage: {$trailsServerUsedDiskPct}\n";
						   push @trailsServerFileSystemRecord, $trailsServerUsedDiskPct;

                           push @trailsServerFileSystemRecords, [@trailsServerFileSystemRecord]; 
                       }#end of while

                       #Close Trails Server File System Information File Handler
					   close TRAILS_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER;
					   
					   #Compare the Defined File System Monitoring Threshold with the Current File System Used Percentage Value
					   my $parsedTrailsServerMonitoringFileSystemListArrayCnt = scalar(@parsedTrailsServerMonitoringFileSystemListArray);
					   print LOG "Trails Server - The Count of Defined Monitoring File System List: {$parsedTrailsServerMonitoringFileSystemListArrayCnt}\n";
					   my $trailsServerFileSystemRecordsCnt = scalar(@trailsServerFileSystemRecords);
                       print LOG "Trails Server - The Count of File System List: {$trailsServerFileSystemRecordsCnt}\n";
					   if(($parsedTrailsServerMonitoringFileSystemListArrayCnt > 0)
					    &&($trailsServerFileSystemRecordsCnt > 0)){#only go loop file system list array when the count of it is > 0
					       
						   foreach my $parsedTrailsServerMonitoringFileSystemArrayAddress (@parsedTrailsServerMonitoringFileSystemListArray){
                           my $trailsServerMonitoringFileSystem = trim($parsedTrailsServerMonitoringFileSystemArrayAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX]);
                           print LOG "Trails Server - the Defined Monitoring File System: {$trailsServerMonitoringFileSystem}\n";
						   my $trailsServerMonitoringFileSystemThreshold = trim($parsedTrailsServerMonitoringFileSystemArrayAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX]);
                          
                           foreach my $trailsServerFileSystemRecordAddress (@trailsServerFileSystemRecords){
						      my $trailsServerFileSystem = trim($trailsServerFileSystemRecordAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX]);
                              print LOG "Trails Server - the Current File System: {$trailsServerFileSystem}\n";
							  my $trailsServerUsedDiskPct = trim($trailsServerFileSystemRecordAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX]);
							  if($trailsServerMonitoringFileSystem eq $trailsServerFileSystem){#judge if the current file system is the defined monitoring file system 
							     print LOG "Trails Server - the Current File System: {$trailsServerFileSystem} is equal to the Defined Monitoring File System: {$trailsServerMonitoringFileSystem}\n";
							     print LOG "Trails Server - the Current File System Used Disk Percentage: {$trailsServerUsedDiskPct}\n";
								 print LOG "Trails Server - the Defined Monitoring File System Threshold: {$trailsServerMonitoringFileSystemThreshold}\n";

								 if(compareUsedDiskPctWithFileSystemThreshold($trailsServerUsedDiskPct,$trailsServerMonitoringFileSystemThreshold) >=0){
								    print LOG "Trails Server - the Current File System Used Disk Percentage: {$trailsServerUsedDiskPct} is great then or equal to the Defined Monitoring File System Threshold: {$trailsServerMonitoringFileSystemThreshold}\n";
                                    
									$processedRuleMessage = $metaRuleMessage;
                                    $processedRuleMessage =~ s/\@2/$trailsServerUsedDiskPct/g;#replace @2 with the current used file system percentage value - for example: '98%'
                                    $processedRuleMessage =~ s/\@3/$trailsServerMonitoringFileSystem/g;#replace @3 with the monitoring file system value - for example: '/db2/cndb'
                                    $processedRuleMessage =~ s/\@4/$trailsServerMonitoringFileSystemThreshold/g;#replace @4 with the monitoring file system threshold value - for example: '95%'
									
                                    push @trailsServerFileSystemEmailAlertMessageArray, "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage";
                                 }
							  }#end if($trailsServerMonitoringFileSystem eq $bravoServerFileSystem)
						   }#end foreach my $bravoServerFileSystemRecordAddress (@bravoServerFileSystemRecords)
					   }#end foreach my $parsedTrailsServerMonitoringFileSystemArrayAddress (@parsedTrailsServerMonitoringFileSystemListArray)
					   }#end if($parsedTrailsServerMonitoringFileSystemListArrayCnt > 0)
                    }#end if($trailsServerMonitoringFileSystemList ne "") 
                    #Trails Server File System Used Disk Monitoring Logic Feature End

					#TAP3 Server File System Used Disk Monitoring Logic Feature Start
                    $tap3ServerMonitoringFileSystemList = $metaRuleParameter10;#TAP3 Server - Filesystem Monitoring List: "/boot~90%'/opt/reports~90%'/opt/tap~90%'/var/staging~90%'/opt/staging~90%'/usr~90%'/var~90%'/tmp~90%'/opt~90%'/home~90%"
             		if($tap3ServerMonitoringFileSystemList ne ""){
                       @tap3ServerMonitoringFileSystemListArray = split(/\'/,$tap3ServerMonitoringFileSystemList);
				       foreach my $tap3ServerMonitoringFileSystemDefinition (@tap3ServerMonitoringFileSystemListArray){#go loop for file system list array
                          print LOG "TAP3 Server - Monitoring File System Definition: {$tap3ServerMonitoringFileSystemDefinition}\n";
                          @parsedTap3ServerMonitoringFileSystemArray = split(/\~/,$tap3ServerMonitoringFileSystemDefinition);
                          my $tap3ServerMonitoringFileSystem = $parsedTap3ServerMonitoringFileSystemArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX];#monitoring file system - for example: "/opt/TAP3"
                          $tap3ServerMonitoringFileSystem = trim($tap3ServerMonitoringFileSystem);#Remove space chars
				          print LOG "TAP3 Server - Monitoring File System: {$tap3ServerMonitoringFileSystem}\n";
                          my $tap3ServerMonitoringFileSystemThreshold = $parsedTap3ServerMonitoringFileSystemArray[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX];#monitoring file system threshold - for example: "90%"
                          $tap3ServerMonitoringFileSystemThreshold = trim($tap3ServerMonitoringFileSystemThreshold);#Remove space chars
                          print LOG "TAP3 Server - Monitoring File System Threshold: {$tap3ServerMonitoringFileSystemThreshold}\n";

						  push @parsedTap3ServerMonitoringFileSystemListArray, [@parsedTap3ServerMonitoringFileSystemArray];
                       }#end 

                       #Read File System Using Percentage Information of the download files from Tap3 Servers
					   #Open Tap3 Server File System Information File Handler
				       open(TAP3_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER, "<", $TAP3_SERVER_FILE_SYSTEM_INFO_FILE ) or die "Tap3 Server File System Information File {$TAP3_SERVER_FILE_SYSTEM_INFO_FILE} doesn't exist. Perl script exits due to this reason.";
                       #Read Record From Tap3 Server File System Information File
					   while (my $tap3ServerFileSystemUsedPctInfoRecord = <TAP3_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER>){
						  @tap3ServerFileSystemRecord = ();#Reset @tap3ServerFileSystemRecord Object Array to be Empty Every Time

					      chomp $tap3ServerFileSystemUsedPctInfoRecord;
						  #Remove before and after space chars of a string
						  $tap3ServerFileSystemUsedPctInfoRecord = trim($tap3ServerFileSystemUsedPctInfoRecord);
						  print LOG "Tap3 Server - File System Used Percentage Information Record: {$tap3ServerFileSystemUsedPctInfoRecord}\n";
                          my $tap3ServerColumnCnt = `echo $tap3ServerFileSystemUsedPctInfoRecord|awk '{print NF;}'`;
						  chomp $tap3ServerColumnCnt;
                          $tap3ServerColumnCnt = trim($tap3ServerColumnCnt);
						  print LOG "Tap3 Server - The Number of Columns for File System Used Percentage Information Record: {$tap3ServerColumnCnt}\n";

	                      my $tap3ServerUsedDiskPct;
                          my $tap3ServerFileSystem;
						
						  if($tap3ServerColumnCnt == 5){
						     $tap3ServerUsedDiskPct = `echo $tap3ServerFileSystemUsedPctInfoRecord|awk '{print \$$USED_DISK_PCT_INDEX;}'`;
							 $tap3ServerFileSystem = `echo $tap3ServerFileSystemUsedPctInfoRecord|awk '{print \$$FILE_SYSTEM_INDEX;}'`;
						   }
						   elsif($tap3ServerColumnCnt == 6){
						     $tap3ServerUsedDiskPct = `echo $tap3ServerFileSystemUsedPctInfoRecord|awk '{print \$$USED_DISK_PCT_INDEX_6_FIELDS;}'`;
							 $tap3ServerFileSystem = `echo $tap3ServerFileSystemUsedPctInfoRecord|awk '{print \$$FILE_SYSTEM_INDEX_6_FIELDS;}'`;
						   }
						  
                           chomp $tap3ServerFileSystem;
                           $tap3ServerFileSystem = trim($tap3ServerFileSystem);
	                       print LOG "Tap3 Server - File System: {$tap3ServerFileSystem}\n";
						   push @tap3ServerFileSystemRecord, $tap3ServerFileSystem;

						   chomp $tap3ServerUsedDiskPct;
                           $tap3ServerUsedDiskPct = trim($tap3ServerUsedDiskPct);
	                       print LOG "Tap3 Server - Used Disk Percentage: {$tap3ServerUsedDiskPct}\n";
						   push @tap3ServerFileSystemRecord, $tap3ServerUsedDiskPct;

                           push @tap3ServerFileSystemRecords, [@tap3ServerFileSystemRecord]; 
                       }#end of while

                       #Close Tap3 Server File System Information File Handler
					   close TAP3_SERVER_FILE_SYSTEM_INFO_FILE_HANDLER;
					   
					   #Compare the Defined File System Monitoring Threshold with the Current File System Used Percentage Value
					   my $parsedTap3ServerMonitoringFileSystemListArrayCnt = scalar(@parsedTap3ServerMonitoringFileSystemListArray);
					   print LOG "Tap3 Server - The Count of Defined Monitoring File System List: {$parsedTap3ServerMonitoringFileSystemListArrayCnt}\n";
					   my $tap3ServerFileSystemRecordsCnt = scalar(@tap3ServerFileSystemRecords);
                       print LOG "Tap3 Server - The Count of File System List: {$tap3ServerFileSystemRecordsCnt}\n";
					   if(($parsedTap3ServerMonitoringFileSystemListArrayCnt > 0)
					    &&($tap3ServerFileSystemRecordsCnt > 0)){#only go loop file system list array when the count of it is > 0
					       
						   foreach my $parsedTap3ServerMonitoringFileSystemArrayAddress (@parsedTap3ServerMonitoringFileSystemListArray){
                           my $tap3ServerMonitoringFileSystem = trim($parsedTap3ServerMonitoringFileSystemArrayAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX]);
                           print LOG "Tap3 Server - the Defined Monitoring File System: {$tap3ServerMonitoringFileSystem}\n";
						   my $tap3ServerMonitoringFileSystemThreshold = trim($parsedTap3ServerMonitoringFileSystemArrayAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX]);
                          
                           foreach my $tap3ServerFileSystemRecordAddress (@tap3ServerFileSystemRecords){
						      my $tap3ServerFileSystem = trim($tap3ServerFileSystemRecordAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_FILE_SYSTEM_INDEX]);
                              print LOG "Tap3 Server - the Current File System: {$tap3ServerFileSystem}\n";
							  my $tap3ServerUsedDiskPct = trim($tap3ServerFileSystemRecordAddress->[$EVENT_TRIGGER_RULE_FILE_SYSTEM_MONITOR_THRESHOLD_INDEX]);
							  if($tap3ServerMonitoringFileSystem eq $tap3ServerFileSystem){#judge if the current file system is the defined monitoring file system 
							     print LOG "Tap3 Server - the Current File System: {$tap3ServerFileSystem} is equal to the Defined Monitoring File System: {$tap3ServerMonitoringFileSystem}\n";
							     print LOG "Tap3 Server - the Current File System Used Disk Percentage: {$tap3ServerUsedDiskPct}\n";
								 print LOG "Tap3 Server - the Defined Monitoring File System Threshold: {$tap3ServerMonitoringFileSystemThreshold}\n";

								 if(compareUsedDiskPctWithFileSystemThreshold($tap3ServerUsedDiskPct,$tap3ServerMonitoringFileSystemThreshold) >=0){
								    print LOG "Tap3 Server - the Current File System Used Disk Percentage: {$tap3ServerUsedDiskPct} is great then or equal to the Defined Monitoring File System Threshold: {$tap3ServerMonitoringFileSystemThreshold}\n";
                                    
									$processedRuleMessage = $metaRuleMessage;
                                    $processedRuleMessage =~ s/\@2/$tap3ServerUsedDiskPct/g;#replace @2 with the current used file system percentage value - for example: '98%'
                                    $processedRuleMessage =~ s/\@3/$tap3ServerMonitoringFileSystem/g;#replace @3 with the monitoring file system value - for example: '/db2/cndb'
                                    $processedRuleMessage =~ s/\@4/$tap3ServerMonitoringFileSystemThreshold/g;#replace @4 with the monitoring file system threshold value - for example: '95%'
									
                                    push @tap3ServerFileSystemEmailAlertMessageArray, "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage";
                                 }
							  }#end if($tap3ServerMonitoringFileSystem eq $bravoServerFileSystem)
						   }#end foreach my $bravoServerFileSystemRecordAddress (@bravoServerFileSystemRecords)
					   }#end foreach my $parsedTap3ServerMonitoringFileSystemArrayAddress (@parsedTap3ServerMonitoringFileSystemListArray)
					   }#end if($parsedTap3ServerMonitoringFileSystemListArrayCnt > 0)
                    }#end if($tap3ServerMonitoringFileSystemList ne "") 
                    #TAP3 Server File System Used Disk Monitoring Logic Feature End


				 }#end if($remoteServerFileSystemMonitoringFlag eq $REMOTE_SERVER_FILE_SYSTEM_MONITORING_TURN_ON_FLAG)
				 else{
				    print LOG "The Remote Server File System Monitroing Function has been turned off for Bravo and Trails servers.\n";  
				 }#end else
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End 
				  
				 #append file system email alert messages into the email content
                 $fileSystemEmailAlertMessageCount = scalar(@fileSystemEmailAlertMessageArray);
                 if($fileSystemEmailAlertMessageCount > 2){#append email content if has file system email alert message. Please note that here the fileSystemEmailAlertMessageCount should > 2, not > 0, because of the event rule title and event rule handling instruction code have been added into this array already.
                    $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                    foreach my $fileSystemEmailAlertMessage (@fileSystemEmailAlertMessageArray){#go loop for file system email alert message
	                   $emailFullContent.="$fileSystemEmailAlertMessage";#append file system email alert message into email content
                    }
					
                    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
					#Append Bravo Server File System Alert Messages into Email Content
					$bravoServerFileSystemEmailAlertMessageArrayCount = scalar(@bravoServerFileSystemEmailAlertMessageArray);
					if($bravoServerFileSystemEmailAlertMessageArrayCount > 0){
					   $emailFullContent.="\n";#append a new break line into email content
                       
					   $processedRuleTitle = $metaRuleTitle;
                       $processedRuleTitle =~ s/\@1/$BRAVO/g;#replace @1 with BRAVO server mode value
                       $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				       print LOG "Bravo Server - The Processed Rule Title: {$processedRuleTitle}\n";

                       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				       print LOG "Bravo Server - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                       foreach my $bravoServerFileSystemEmailAlertMessage (@bravoServerFileSystemEmailAlertMessageArray){#go loop for bravo server file system email alert message
	                      $emailFullContent.="$bravoServerFileSystemEmailAlertMessage\n";#append bravo server file system email alert message into email content
                          print LOG "Bravo Server - The Processed Rule Message: {$bravoServerFileSystemEmailAlertMessage}\n";
                       }#end foreach my $bravoServerFileSystemEmailAlertMessage (@bravoServerFileSystemEmailAlertMessageArray)
					}

					#Append Trails Server File System Alert Messages into Email Content
                    $trailsServerFileSystemEmailAlertMessageArrayCount = scalar(@trailsServerFileSystemEmailAlertMessageArray);
					if($trailsServerFileSystemEmailAlertMessageArrayCount > 0){
					   $emailFullContent.="\n";#append a new break line into email content
                       
					   $processedRuleTitle = $metaRuleTitle;
                       $processedRuleTitle =~ s/\@1/$TRAILS/g;#replace @1 with TRAILS server mode value
                       $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				       print LOG "Trails Server - The Processed Rule Title: {$processedRuleTitle}\n";

                       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				       print LOG "Trails Server - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                       foreach my $trailsServerFileSystemEmailAlertMessage (@trailsServerFileSystemEmailAlertMessageArray){#go loop for trails server file system email alert message
	                      $emailFullContent.="$trailsServerFileSystemEmailAlertMessage\n";#append trails server file system email alert message into email content
                          print LOG "Trails Server - The Processed Rule Message: {$trailsServerFileSystemEmailAlertMessage}\n";
                       }#end foreach my $trailsServerFileSystemEmailAlertMessage (@trailsServerFileSystemEmailAlertMessageArray)
					}
					
					#Append Tap3 Server File System Alert Messages into Email Content
                    $tap3ServerFileSystemEmailAlertMessageArrayCount = scalar(@tap3ServerFileSystemEmailAlertMessageArray);
					if($tap3ServerFileSystemEmailAlertMessageArrayCount > 0){
					   $emailFullContent.="\n";#append a new break line into email content
                       
					   $processedRuleTitle = $metaRuleTitle;
                       $processedRuleTitle =~ s/\@1/$TAP3/g;#replace @1 with TAP3 server mode value
                       $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				       print LOG "Tap3 Server - The Processed Rule Title: {$processedRuleTitle}\n";

                       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				       print LOG "Tap3 Server - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                       foreach my $tap3ServerFileSystemEmailAlertMessage (@tap3ServerFileSystemEmailAlertMessageArray){#go loop for tap3 server file system email alert message
	                      $emailFullContent.="$tap3ServerFileSystemEmailAlertMessage\n";#append tap3 server file system email alert message into email content
                          print LOG "Tap3 Server - The Processed Rule Message: {$tap3ServerFileSystemEmailAlertMessage}\n";
                       }#end foreach my $tap3ServerFileSystemEmailAlertMessage (@tap3ServerFileSystemEmailAlertMessageArray)
					}
					#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End
	                $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
                 }#end if($fileSystemEmailAlertMessageCount > 2)
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
				 else{
				    $bravoServerFileSystemEmailAlertMessageArrayCount = scalar(@bravoServerFileSystemEmailAlertMessageArray);
				    $trailsServerFileSystemEmailAlertMessageArrayCount = scalar(@trailsServerFileSystemEmailAlertMessageArray);
				    $tap3ServerFileSystemEmailAlertMessageArrayCount = scalar(@tap3ServerFileSystemEmailAlertMessageArray);
                    if($trailsServerFileSystemEmailAlertMessageArrayCount > 0 || $bravoServerFileSystemEmailAlertMessageArrayCount > 0 || $tap3ServerFileSystemEmailAlertMessageArrayCount > 0){
	  			    	$emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                    }
                    if($trailsServerFileSystemEmailAlertMessageArrayCount > 0){
					   #Append Trails Server File System Alert Messages into Email Content
					   $processedRuleTitle = $metaRuleTitle;
                       $processedRuleTitle =~ s/\@1/$TRAILS/g;#replace @1 with TRAILS server mode value
                       $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				       print LOG "Trails Server - The Processed Rule Title: {$processedRuleTitle}\n";

                       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				       print LOG "Trails Server - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                       foreach my $trailsServerFileSystemEmailAlertMessage (@trailsServerFileSystemEmailAlertMessageArray){#go loop for trails server file system email alert message
	                      $emailFullContent.="$trailsServerFileSystemEmailAlertMessage\n";#append trails server file system email alert message into email content
                          print LOG "Trails Server - The Processed Rule Message: {$trailsServerFileSystemEmailAlertMessage}\n";
                       }#end foreach my $trailsServerFileSystemEmailAlertMessage (@trailsServerFileSystemEmailAlertMessageArray)

					}#end if($trailsServerFileSystemEmailAlertMessageArrayCount > 0)
					if($bravoServerFileSystemEmailAlertMessageArrayCount > 0){
                       #Append Bravo Server File System Alert Messages into Email Content
					   $processedRuleTitle = $metaRuleTitle;
                       $processedRuleTitle =~ s/\@1/$BRAVO/g;#replace @1 with BRAVO server mode value
                       $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				       print LOG "Bravo Server - The Processed Rule Title: {$processedRuleTitle}\n";

                       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				       print LOG "Bravo Server - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                       foreach my $bravoServerFileSystemEmailAlertMessage (@bravoServerFileSystemEmailAlertMessageArray){#go loop for bravo server file system email alert message
	                      $emailFullContent.="$bravoServerFileSystemEmailAlertMessage\n";#append bravo server file system email alert message into email content
                          print LOG "Bravo Server - The Processed Rule Message: {$bravoServerFileSystemEmailAlertMessage}\n";
                       }#end foreach my $bravoServerFileSystemEmailAlertMessage (@bravoServerFileSystemEmailAlertMessageArray)
					   
					}#end if($bravoServerFileSystemEmailAlertMessageArrayCount > 0)
                    if($tap3ServerFileSystemEmailAlertMessageArrayCount > 0){
                       #Append Trails Server File System Alert Messages into Email Content
                 	   $processedRuleTitle = $metaRuleTitle;
                       $processedRuleTitle =~ s/\@1/$TAP3/g;#replace @1 with TRAILS server mode value
                       $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				       print LOG "TAP3 Server - The Processed Rule Title: {$processedRuleTitle}\n";

                       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				       print LOG "TAP3 Server - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                       foreach my $tap3ServerFileSystemEmailAlertMessage (@tap3ServerFileSystemEmailAlertMessageArray){#go loop for trails server file system email alert message
	                      $emailFullContent.="$tap3ServerFileSystemEmailAlertMessage\n";#append trails server file system email alert message into email content
                          print LOG "Tap3 Server - The Processed Rule Message: {$tap3ServerFileSystemEmailAlertMessage}\n";
                       }#end foreach my $tap3ServerFileSystemEmailAlertMessage (@tap3ServerFileSystemEmailAlertMessageArray)
					   
					}#end if($tap3ServerFileSystemEmailAlertMessageArrayCount > 0)
				 }#end else
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End
                 if($trailsServerFileSystemEmailAlertMessageArrayCount > 0 || $bravoServerFileSystemEmailAlertMessageArrayCount > 0 || $tap3ServerFileSystemEmailAlertMessageArrayCount > 0){
	  			   	$emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
                 }
                 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
			 }
             #Added by Larry for HealthCheck And Monitor Module - Phase 3 End
			 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
             elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $TRAILSRP_DB_APPLY_GAP_MONITORING)#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSRP_DB_APPLY_GAP_MONITORING"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
                 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Server Mode: {$serverMode}\n";
				 my $warningTrailsRPDBApplyGap = $metaRuleParameter2;#var used to store warning trailsRP DB Apply Gap - for example: '3600'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Warning Gap: {$warningTrailsRPDBApplyGap}\n";
				 my $warningEventRuleMessage = $metaRuleParameter3;#var used to store warning event rule message - for example: 'Apply Gap of TrailsRP too high. Current Apply Gap is: <@2 hrs and @3 mins>'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Warning Event Rule Message: {$warningEventRuleMessage}\n";
                 my $warningEventRuleHandlingInstructionCode = $metaRuleParameter4;#var used to store warning event rule handling instruction code - for example: 'W-DBM-TRP-001'
                 print LOG "TrailsRP DB Apply Gap Monitoring - Warning Event Rule Handling Instruction Code: {$warningEventRuleHandlingInstructionCode}\n";
                 my $errorTrailsRPDBApplyGap = $metaRuleParameter5;#var used to store error trailsRP DB Apply Gap - for example: '36000'
                 print LOG "TrailsRP DB Apply Gap Monitoring - Error Gap: {$errorTrailsRPDBApplyGap}\n";
				 my $errorEventRuleMessage = $metaRuleParameter6;#var used to store error event rule message - for example: 'Apply Gap is out of sync. Current Apply Gap is: <@2 hrs and @3 mins>'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Error Event Rule Message: {$errorEventRuleMessage}\n";
                 my $errorEventRuleHandlingInstructionCode = $metaRuleParameter7;#var used to store error event rule handling instruction code - for example: 'E-DBM-TRP-001'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Error Event Rule Handling Instruction Code: {$errorEventRuleHandlingInstructionCode}\n";
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A Start 
				 my $errorEventRuleMessageForReplicationFailed = $metaRuleParameter8;#var used to store error event rule message for replication failed - for example: 'Replication FAILED.'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Error Event Rule Message For Replication Failed: {$errorEventRuleMessageForReplicationFailed}\n";
                 my $errorEventRuleHandlingInstructionCodeForReplicationFailed = $metaRuleParameter9;#var used to store error event rule handling instruction code for replication failed - for example: 'E-DBM-TRP-002'
				 print LOG "TrailsRP DB Apply Gap Monitoring - Error Event Rule Handling Instruction Code For Replication Failed: {$errorEventRuleHandlingInstructionCodeForReplicationFailed}\n";
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A End

				 my $trailsrp_connection;#var used to store TrailsRP DB connection object
				 my @trailsRPDBApplyGapRow;#array used to store trailsRP DB apply gap row
			     my $trailsRPDBCurrentTime;#var used to store trailsRP DB current time - for example: 2013-05-28-05.39.55.103602
            	 my $trailsRPDBLastSYNTime;#var used to store trailsRP DB last syn time - for example: 2013-05-28-05.39.31.701318
            	 my $trailsRPDBApplyGapSecs;#var used to store trailsRP DB apply gap seconds - for example: 24 seconds
			     
				 my $processedRuleTitle;#var used to store processed rule title - for example: 'TrailsRP Database Apply Gap Monitoring on @1 Server'
				 my $processedRuleMessage;#var used to store processed rule message - for example: 'Apply Gap of TrailsRP too high. Current Apply Gap is: <@2 hrs and @3 mins>'
				 my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code - for example: 'W-DBM-TRP-001'

				 my $trailsRPDBApplyGapHours;#var used to store trailsRP DB apply gap hours - for example: 5 hours
				 my $trailsRPDBApplyGapMins;#var used to store trailsRP DB apply gap mins - for example: 5 mins
				 my $trailsRPDBApplyGapRemainingSecs;#var used to store trailsRP DB apply gap remaining secs: $trailsRPDBApplyGapRemainingSecs =$trailsRPDBApplyGapSecs%3600 - for example: 360 seconds 
			      
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
				 eval{
				    #move all the DB operations within the business logic scope for Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSRP_DB_APPLY_GAP_MONITORING"
                    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements Start
				    #Get TrailsRP DB Connection 
                    $trailsrp_connection = Database::Connection->new('trailsrp');

                    #Get TrailsRP DB Apply Gap Row
				    @trailsRPDBApplyGapRow = getTrailsRPDBApplyGapFunction($trailsrp_connection);
				    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements End
             
				    #get trailsRP DB current time, last syn time and apply gap seconds
                    $trailsRPDBCurrentTime = $trailsRPDBApplyGapRow[$TRAILSRP_DB_CURRENT_TIME_INDEX];
                    $trailsRPDBLastSYNTime = $trailsRPDBApplyGapRow[$TRAILSRP_DB_LAST_SYN_TIME_INDEX];
				    $trailsRPDBApplyGapSecs = $trailsRPDBApplyGapRow[$TRAILSRP_DB_APPLY_GAP_INDEX];

                    #Disconnect TrailsRP DB Connection 
				    $trailsrp_connection->disconnect();
                    
					if(defined $trailsRPDBLastSYNTime){#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A  
				      print LOG "{TrailsRP Database Apply Gap Seconds: $trailsRPDBApplyGapSecs} from {LAST_SYN_TIME: $trailsRPDBLastSYNTime} with {CURRENT_TIME: $trailsRPDBCurrentTime}\n";
                 
                      $processedRuleTitle = $metaRuleTitle;
                      $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
                      print LOG "The Processed Event Rule Title: {$processedRuleTitle}\n";
			    
				      if(($trailsRPDBApplyGapSecs > $warningTrailsRPDBApplyGap) && ($trailsRPDBApplyGapSecs <= $errorTrailsRPDBApplyGap)){#trailsRP DB Apply Waining Gap has been reached
                         print LOG "{TrailsRP DB Apply Waining Gap: $trailsRPDBApplyGapSecs} has been reached with {Warning Apply Gap Threshold: $warningTrailsRPDBApplyGap}\n";
				   		
                         $processedRuleHandlingInstructionCode = $warningEventRuleHandlingInstructionCode;
                         print LOG "The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                         $processedRuleMessage = $warningEventRuleMessage;
                         $trailsRPDBApplyGapHours = int($trailsRPDBApplyGapSecs/3600);#calculate the trailsRP DB warning apply gap hours
					     print LOG "The calculated TrailsRP DB Warning Apply Gap Hours: {$trailsRPDBApplyGapHours}\n";
					     $trailsRPDBApplyGapRemainingSecs = $trailsRPDBApplyGapSecs%3600;#calculate the trailsRP DB warning apply gap remaining seconds
                         print LOG "The calculated TrailsRP DB Warning Apply Gap Remaining Seconds: {$trailsRPDBApplyGapRemainingSecs}\n"; 
                         $trailsRPDBApplyGapMins =  int($trailsRPDBApplyGapRemainingSecs/60) + 1;#calculate the trailsRP DB warning apply gap remaining mins - please note that here we need to always + 1 min to support the remaning seconds < 60 seconds case 
                         print LOG "The calculated TrailsRP DB Warning Apply Gap Mins: {$trailsRPDBApplyGapMins}\n";
                         $processedRuleMessage =~ s/\@2/$trailsRPDBApplyGapHours/g;#replace @2 with trailsRP DB warning apply gap hours - for example: 5(hours)
                         $processedRuleMessage =~ s/\@3/$trailsRPDBApplyGapMins/g;#replace @3 with trailsRP DB warning apply gap mins - for example: 5(mins)  
                         print LOG "The Processed Event Rule Message: {$processedRuleMessage}\n";

				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			             $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                         $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
				         $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				      }#end if(($trailsRPDBApplyGapSecs > $warningTrailsRPDBApplyGap) && ($trailsRPDBApplyGapSecs <= $errorTrailsRPDBApplyGap)) 
				      elsif($trailsRPDBApplyGapSecs > $errorTrailsRPDBApplyGap){#trailsRP DB Apply Error Gap has been reached
                         print LOG "{TrailsRP DB Apply Error Gap: $trailsRPDBApplyGapSecs} has been reached with {Error Apply Gap Threshold: $errorTrailsRPDBApplyGap}\n";
					
                         $processedRuleHandlingInstructionCode = $errorEventRuleHandlingInstructionCode;
					     print LOG "The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                         $processedRuleMessage =  $errorEventRuleMessage;
					     $trailsRPDBApplyGapHours = int($trailsRPDBApplyGapSecs/3600);#calculate the trailsRP DB error apply gap hours
					     print LOG "The calculated TrailsRP DB Error Apply Gap Hours: {$trailsRPDBApplyGapHours}\n";
					     $trailsRPDBApplyGapRemainingSecs = $trailsRPDBApplyGapSecs%3600;#calculate the trailsRP DB error apply gap remaining seconds
                         print LOG "The calculated TrailsRP DB Error Apply Gap Remaining Seconds: {$trailsRPDBApplyGapRemainingSecs}\n"; 
                         $trailsRPDBApplyGapMins =  int($trailsRPDBApplyGapRemainingSecs/60) + 1;#calculate the trailsRP DB error apply gap remaining mins - please note that here we need to always + 1 min to support the remaning seconds < 60 seconds case 
                         print LOG "The calculated TrailsRP DB Error Apply Gap Mins: {$trailsRPDBApplyGapMins}\n";
                         $processedRuleMessage =~ s/\@2/$trailsRPDBApplyGapHours/g;#replace @2 with trailsRP DB error apply gap hours - for example: 10(hours)
                         $processedRuleMessage =~ s/\@3/$trailsRPDBApplyGapMins/g;#replace @3 with trailsRP DB error apply gap mins - for example: 10(mins)  
                         print LOG "The Processed Event Rule Message: {$processedRuleMessage}\n";
				
				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			             $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                         $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
				         $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				      }#end elsif($trailsRPDBApplyGapSecs > $errorTrailsRPDBApplyGap)
					}#end if(defined $trailsRPDBLastSYNTime)#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A
					#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A Start
					#Support the synctime is null case
					else{
					   
					  $processedRuleTitle = $metaRuleTitle;
                      $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
                      print LOG "The Processed Event Rule Title: {$processedRuleTitle}\n";
                      
                      $processedRuleHandlingInstructionCode = $errorEventRuleHandlingInstructionCodeForReplicationFailed;
					  print LOG "The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                      $processedRuleMessage =  $errorEventRuleMessageForReplicationFailed;
					  print LOG "The Processed Event Rule Message: {$processedRuleMessage}\n";

                      $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			          $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                      $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
				      $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				      $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
					}
					#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A End 
					
				    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
				 };#end eval
				 if($@){
				    $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			        $emailFullContent.="$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n";#append database exception message into email content
				    $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				    
                    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n"; 
				 }
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
             }
             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End
			 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
             elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING)#Event Group: "DATABASE_MONITORING" + Event Type: "CNDB_CUSTOMER_TME_OBJECT_ID_MONITORING"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
				 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "CNDB Customer TME_OBJECT_ID Monitoring - Server Mode: {$serverMode}\n";
				 my $searchKeyword = $metaRuleParameter2;#var used to store search keyword - for example: DEFAULT
                 print LOG "CNDB Customer TME_OBJECT_ID Monitoring - Search Keyword: {$searchKeyword}\n";
				 
				 my $getCNDBCustomerTMEObjectIDSQL = $GET_CNDB_CUSTOMER_TME_OBJECT_ID_SQL;
				 my $cndb_connection;#var used to store CNDB connection object
				 my @customerRows;#array used to store customer rows object
				 my $customerRowsCnt;#var used to store the number of customer rows object
				 my $customerRow;#var used to store customerRow memory address
				 my $accountNumber;#var used to store account number
				 my $tmeObjectID;#var used to store TME_Object_ID

				 my $processedRuleTitle;#var used to store processed rule title - for example: 'CNDB Customer TME_OBJECT_ID Monitoring on @1 Server'
				 my $processedRuleMessage;#var used to store processed rule message - for example: 'Bank Account @2 contains the reserved TME_OBJECT_ID values: @3'
				 my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code - for example: 'W-DBM-CCT-001'
                
         		 $getCNDBCustomerTMEObjectIDSQL =~ s/\#1/$searchKeyword/g;
                 print LOG "CNDB Customer TME_OBJECT_ID Monitoring - Converted Get CNDB Customer TMEObjectID SQL: {$getCNDBCustomerTMEObjectIDSQL}\n";

                 $processedRuleTitle = $metaRuleTitle;
                 $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
                 print LOG "CNDB Customer TME_OBJECT_ID Monitoring - The Processed Event Rule Title: {$processedRuleTitle}\n"; 
                 
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
	             eval{
                    #Get CNDB Connection
                    $cndb_connection = Database::Connection->new('cndb');
                    
                    #Get Customer Rows Object
				    @customerRows = getCNDBCustomerTMEObjectIDFunction($cndb_connection,$getCNDBCustomerTMEObjectIDSQL);
                 
				    #Calculate the number of Customer Rows Object
                    $customerRowsCnt = scalar(@customerRows);
             
			        if($customerRowsCnt > 0){#judge if has customer rows 
                       $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			           $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                    
				       $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
			           print LOG "CNDB Customer TME_OBJECT_ID Monitoring - The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";
                       $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
			
					   foreach $customerRow (@customerRows){
                           $accountNumber = $customerRow->[$CNDB_CUSTOMER_ACCOUNT_NUMBER_INDEX];
					       print LOG "CNDB Customer TME_OBJECT_ID Monitoring - Account Number: {$accountNumber}\n";
					       $tmeObjectID = $customerRow->[$CNDB_CUSTOMER_TME_OBJECT_ID_INDEX];
                           print LOG "CNDB Customer TME_OBJECT_ID Monitoring - TME_Object_ID: {$tmeObjectID}\n";
                        
						   $processedRuleMessage = $metaRuleMessage;
     					   $processedRuleMessage =~ s/\@2/$accountNumber/g;#replace @2 with account number value - for example: 152880
						   $processedRuleMessage =~ s/\@3/$searchKeyword/g;#replace @3 with search keyword value - for example: DEFAULT
                           $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
                           print LOG "CNDB Customer TME_OBJECT_ID Monitoring - The Processed Event Rule Message: {$processedRuleMessage}\n";
				       }#end foreach $customerRow (@customerRows)

                       $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
                    }#end if($customerRowsCnt > 0)
				 
				    #Disconnect CNDB Connection 
				    $cndb_connection->disconnect();
                 
				    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
				 };#end eval
	             if($@){
	                $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
	                $emailFullContent.="$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n";#append database exception message into email content
		            $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				    
                    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n"; 
	             }
	             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
             }
             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End
			 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
             elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $TRAILSST_DB_APPLY_GAP_MONITORING)#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSST_DB_APPLY_GAP_MONITORING"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
                 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "TrailsST DB Apply Gap Monitoring - Server Mode: {$serverMode}\n";
				 my $warningTrailsSTDBApplyGap = $metaRuleParameter2;#var used to store warning trailsST DB Apply Gap - for example: '3600'
				 print LOG "TrailsST DB Apply Gap Monitoring - Warning Gap: {$warningTrailsSTDBApplyGap}\n";
				 my $warningEventRuleMessage = $metaRuleParameter3;#var used to store warning event rule message - for example: 'Apply Gap of TrailsST too high. Current Apply Gap is: <@2 hrs and @3 mins>'
				 print LOG "TrailsST DB Apply Gap Monitoring - Warning Event Rule Message: {$warningEventRuleMessage}\n";
                 my $warningEventRuleHandlingInstructionCode = $metaRuleParameter4;#var used to store warning event rule handling instruction code - for example: 'W-DBM-TST-001'
                 print LOG "TrailsST DB Apply Gap Monitoring - Warning Event Rule Handling Instruction Code: {$warningEventRuleHandlingInstructionCode}\n";
                 my $errorTrailsSTDBApplyGap = $metaRuleParameter5;#var used to store error trailsST DB Apply Gap - for example: '36000'
                 print LOG "TrailsST DB Apply Gap Monitoring - Error Gap: {$errorTrailsSTDBApplyGap}\n";
				 my $errorEventRuleMessage = $metaRuleParameter6;#var used to store error event rule message - for example: 'Apply Gap is out of sync. Current Apply Gap is: <@2 hrs and @3 mins>'
				 print LOG "TrailsST DB Apply Gap Monitoring - Error Event Rule Message: {$errorEventRuleMessage}\n";
                 my $errorEventRuleHandlingInstructionCode = $metaRuleParameter7;#var used to store error event rule handling instruction code - for example: 'E-DBM-TST-001'
				 print LOG "TrailsST DB Apply Gap Monitoring - Error Event Rule Handling Instruction Code: {$errorEventRuleHandlingInstructionCode}\n";
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A Start 
				 my $errorEventRuleMessageForReplicationFailed = $metaRuleParameter8;#var used to store error event rule message for replication failed - for example: 'Replication FAILED.'
				 print LOG "TrailsST DB Apply Gap Monitoring - Error Event Rule Message For Replication Failed: {$errorEventRuleMessageForReplicationFailed}\n";
                 my $errorEventRuleHandlingInstructionCodeForReplicationFailed = $metaRuleParameter9;#var used to store error event rule handling instruction code for replication failed - for example: 'E-DBM-TST-002'
				 print LOG "TrailsST DB Apply Gap Monitoring - Error Event Rule Handling Instruction Code For Replication Failed: {$errorEventRuleHandlingInstructionCodeForReplicationFailed}\n";
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A End
				  
				 my $trailsst_connection;#var used to store TrailsST DB connection object
				 my @trailsSTDBApplyGapRow;#array used to store trailsST DB apply gap row
			     my $trailsSTDBCurrentTime;#var used to store trailsST DB current time - for example: 2013-05-28-05.39.55.103602
            	 my $trailsSTDBLastSYNTime;#var used to store trailsST DB last syn time - for example: 2013-05-28-05.39.31.701318
            	 my $trailsSTDBApplyGapSecs;#var used to store trailsST DB apply gap seconds - for example: 24 seconds
			     
				 my $processedRuleTitle;#var used to store processed rule title - for example: 'TrailsST Database Apply Gap Monitoring on @1 Server'
				 my $processedRuleMessage;#var used to store processed rule message - for example: 'Apply Gap of TrailsST too high. Current Apply Gap is: <@2 hrs and @3 mins>'
				 my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code - for example: 'W-DBM-TST-001'

				 my $trailsSTDBApplyGapHours;#var used to store trailsST DB apply gap hours - for example: 5 hours
				 my $trailsSTDBApplyGapMins;#var used to store trailsST DB apply gap mins - for example: 5 mins
				 my $trailsSTDBApplyGapRemainingSecs;#var used to store trailsST DB apply gap remaining secs: $trailsSTDBApplyGapRemainingSecs =$trailsSTDBApplyGapSecs%3600 - for example: 360 seconds 
			     
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
	             eval{ 
				    #move all the DB operations within the business logic scope for Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSST_DB_APPLY_GAP_MONITORING"
                    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements Start
				    #Get TrailsST DB Connection 
                    $trailsst_connection = Database::Connection->new('trailsst');

                    #Get TrailsST DB Apply Gap Row
				    @trailsSTDBApplyGapRow = getTrailsSTDBApplyGapFunction($trailsst_connection);
				    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 - Refacor the way of getting DB connection and executing SQL statements End
             
				    #get trailsST DB current time, last syn time and apply gap seconds
                    $trailsSTDBCurrentTime = $trailsSTDBApplyGapRow[$TRAILSST_DB_CURRENT_TIME_INDEX];
                    $trailsSTDBLastSYNTime = $trailsSTDBApplyGapRow[$TRAILSST_DB_LAST_SYN_TIME_INDEX];
				    $trailsSTDBApplyGapSecs = $trailsSTDBApplyGapRow[$TRAILSST_DB_APPLY_GAP_INDEX];

                    #Disconnect TrailsST DB Connection 
				    $trailsst_connection->disconnect();
                    
					if(defined $trailsSTDBLastSYNTime){#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A
				      print LOG "{TrailsST Database Apply Gap Seconds: $trailsSTDBApplyGapSecs} from {LAST_SYN_TIME: $trailsSTDBLastSYNTime} with {CURRENT_TIME: $trailsSTDBCurrentTime}\n";
                 
                      $processedRuleTitle = $metaRuleTitle;
                      $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
                      print LOG "The Processed Event Rule Title: {$processedRuleTitle}\n";
			    
				      if(($trailsSTDBApplyGapSecs > $warningTrailsSTDBApplyGap) && ($trailsSTDBApplyGapSecs <= $errorTrailsSTDBApplyGap)){#trailsST DB Apply Waining Gap has been reached
                         print LOG "{TrailsST DB Apply Waining Gap: $trailsSTDBApplyGapSecs} has been reached with {Warning Apply Gap Threshold: $warningTrailsSTDBApplyGap}\n";
				   		
                         $processedRuleHandlingInstructionCode = $warningEventRuleHandlingInstructionCode;
                         print LOG "The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                         $processedRuleMessage = $warningEventRuleMessage;
                         $trailsSTDBApplyGapHours = int($trailsSTDBApplyGapSecs/3600);#calculate the trailsST DB warning apply gap hours
					     print LOG "The calculated TrailsST DB Warning Apply Gap Hours: {$trailsSTDBApplyGapHours}\n";
					     $trailsSTDBApplyGapRemainingSecs = $trailsSTDBApplyGapSecs%3600;#calculate the trailsST DB warning apply gap remaining seconds
                         print LOG "The calculated TrailsST DB Warning Apply Gap Remaining Seconds: {$trailsSTDBApplyGapRemainingSecs}\n"; 
                         $trailsSTDBApplyGapMins =  int($trailsSTDBApplyGapRemainingSecs/60) + 1;#calculate the trailsST DB warning apply gap remaining mins - please note that here we need to always + 1 min to support the remaning seconds < 60 seconds case 
                         print LOG "The calculated TrailsST DB Warning Apply Gap Mins: {$trailsSTDBApplyGapMins}\n";
                         $processedRuleMessage =~ s/\@2/$trailsSTDBApplyGapHours/g;#replace @2 with trailsST DB warning apply gap hours - for example: 5(hours)
                         $processedRuleMessage =~ s/\@3/$trailsSTDBApplyGapMins/g;#replace @3 with trailsST DB warning apply gap mins - for example: 5(mins)  
                         print LOG "The Processed Event Rule Message: {$processedRuleMessage}\n";

				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			             $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                         $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
				         $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				      }#end if(($trailsSTDBApplyGapSecs > $warningTrailsSTDBApplyGap) && ($trailsSTDBApplyGapSecs <= $errorTrailsSTDBApplyGap)) 
				      elsif($trailsSTDBApplyGapSecs > $errorTrailsSTDBApplyGap){#trailsST DB Apply Error Gap has been reached
                         print LOG "{TrailsST DB Apply Error Gap: $trailsSTDBApplyGapSecs} has been reached with {Error Apply Gap Threshold: $errorTrailsSTDBApplyGap}\n";
					
                         $processedRuleHandlingInstructionCode = $errorEventRuleHandlingInstructionCode;
					     print LOG "The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                         $processedRuleMessage =  $errorEventRuleMessage;
					     $trailsSTDBApplyGapHours = int($trailsSTDBApplyGapSecs/3600);#calculate the trailsST DB error apply gap hours
					     print LOG "The calculated TrailsST DB Error Apply Gap Hours: {$trailsSTDBApplyGapHours}\n";
					     $trailsSTDBApplyGapRemainingSecs = $trailsSTDBApplyGapSecs%3600;#calculate the trailsST DB error apply gap remaining seconds
                         print LOG "The calculated TrailsST DB Error Apply Gap Remaining Seconds: {$trailsSTDBApplyGapRemainingSecs}\n"; 
                         $trailsSTDBApplyGapMins =  int($trailsSTDBApplyGapRemainingSecs/60) + 1;#calculate the trailsST DB error apply gap remaining mins - please note that here we need to always + 1 min to support the remaning seconds < 60 seconds case 
                         print LOG "The calculated TrailsST DB Error Apply Gap Mins: {$trailsSTDBApplyGapMins}\n";
                         $processedRuleMessage =~ s/\@2/$trailsSTDBApplyGapHours/g;#replace @2 with trailsST DB error apply gap hours - for example: 10(hours)
                         $processedRuleMessage =~ s/\@3/$trailsSTDBApplyGapMins/g;#replace @3 with trailsST DB error apply gap mins - for example: 10(mins)  
                         print LOG "The Processed Event Rule Message: {$processedRuleMessage}\n";
				
				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			             $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                         $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
				         $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				         $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				      }#end elsif($trailsSTDBApplyGapSecs > $errorTrailsSTDBApplyGap)
					}#end if(defined $trailsSTDBLastSYNTime)#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A
					#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A Start
					#Support the synctime is null case
					else{
					   
					  $processedRuleTitle = $metaRuleTitle;
                      $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
                      print LOG "The Processed Event Rule Title: {$processedRuleTitle}\n";
                      
                      $processedRuleHandlingInstructionCode = $errorEventRuleHandlingInstructionCodeForReplicationFailed;
					  print LOG "The Processed Event Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";

                      $processedRuleMessage =  $errorEventRuleMessageForReplicationFailed;
					  print LOG "The Processed Event Rule Message: {$processedRuleMessage}\n";

                      $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			          $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";#append event rule title into email content
                      $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";#append event rule handling instruction code into email content  
				      $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				      $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
					}
					#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A End 

				    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
				 };#end eval
	             if($@){
	                $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
	                $emailFullContent.="$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n";#append database exception message into email content
		            $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				    
                    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n"; 
	             }
	             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
             }
			 elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $TRAILSRP_DB_APPLY_GAP_MONITORING_2)#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSRP_DB_APPLY_GAP_MONITORING_2"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
		         #Develop TrailsRP DB Apply Gap Monitoring Feature 2 Logic Here...
				 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Server Mode: {$serverMode}\n";
				 my $applyGapErrorThreshold = $metaRuleParameter2;#var used to store trailsRP DB Apply Gap Error Threshold - for example: '172800'
				 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Apply Gap Error Threshold: {$applyGapErrorThreshold}\n";
				 my $errorEmailTitle = $metaRuleParameter3;#var used to store Error Email Title - for example: 'TRAILSRP Replication - ERROR'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Error Email Title: {$errorEmailTitle}\n";
				 my $errorEmailToPersonList = $metaRuleParameter4;#var used to store Error Email To Person List - for example: 'liuhaidl@cn.ibm.com,HDRUST@de.ibm.com,Petr_Soufek@cz.ibm.com,dbryson@us.ibm.com,AMTS@cz.ibm.com,stammelw@us.ibm.com'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Error Email To Person List: {$errorEmailToPersonList}\n";
                 my $errorEmailContentMessage = $metaRuleParameter5;#var used to store Error Email Content Message - for example: 'Apply Gap is out of sync. Current Apply Gap is: <@1 hrs and @2 mins>'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Error Email Content Message: {$errorEmailContentMessage}\n";
				 my $successEmailTitle = $metaRuleParameter6;#var used to store Success Email Title - for example: 'TRAILSRP Replication - SUCCESS'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Success Email Title: {$successEmailTitle}\n";
				 my $successEmailToPersonList = $metaRuleParameter7;#var used to store Success Email To Person List - for example: 'liuhaidl@cn.ibm.com,HDRUST@de.ibm.com,Petr_Soufek@cz.ibm.com,dbryson@us.ibm.com,AMTS@cz.ibm.com,stammelw@us.ibm.com'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Success Email To Person List: {$successEmailToPersonList}\n";
                 my $successEmailContentMessage = $metaRuleParameter8;#var used to store Success Email Content Message - for example: 'Apply Gap is within @1 hours [Configured Threshold Value]. Current Apply Gap is: <@2 hrs and @3 mins>'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Success Email Content Message: {$successEmailContentMessage}\n";
				 my $alwaysSendEmailFlag = $metaRuleParameter9;#var used to store Always Send Email Flag - for example: 'Y'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Always Send Email Flag: {$alwaysSendEmailFlag}\n";
				 my $eventTriggerDay = $metaRuleParameter10;#var used to store Event Trigger Day - for example: 'Monday'
                 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Event Trigger Day: {$eventTriggerDay}\n";
                 my $currentDay = `date +"%A"`;#var used to store Current Day - for example: 'Monday'
				 chomp($currentDay);;#remove the return line char
				 $currentDay = trim($currentDay);#Remove space chars
				 print LOG "TrailsRP DB Apply Gap Monitoring 2 - Current Day: {$currentDay}\n";
			
				 my $trailsrp_connection;#var used to store TrailsRP DB connection object
				 my @trailsRPDBApplyGapRow;#array used to store trailsRP DB apply gap row
			     my $trailsRPDBCurrentTime;#var used to store trailsRP DB current time - for example: 2013-05-28-05.39.55.103602
            	 my $trailsRPDBLastSYNTime;#var used to store trailsRP DB last syn time - for example: 2013-05-28-05.39.31.701318
            	 my $trailsRPDBApplyGapSecs;#var used to store trailsRP DB apply gap seconds - for example: 24 seconds

				 my $trailsRPDBApplyGapHours;#var used to store trailsRP DB apply gap hours - for example: 5 hours
				 my $trailsRPDBApplyGapMins;#var used to store trailsRP DB apply gap mins - for example: 5 mins
				 my $trailsRPDBApplyGapRemainingSecs;#var used to store trailsRP DB apply gap remaining secs: $trailsRPDBApplyGapRemainingSecs =$trailsRPDBApplyGapSecs%3600 - for example: 360 seconds 
			     
				 my $sendEmailTitle;#var used to store send email title - for example: 'TRAILSRP Replication - SUCCESS'
				 my $sendEmailToPersonList;#var used to store send email to person list - 'liuhaidl@cn.ibm.com,HDRUST@de.ibm.com,Petr_Soufek@cz.ibm.com,dbryson@us.ibm.com,AMTS@cz.ibm.com,stammelw@us.ibm.com'
				 my $processedSendEmailContent;#var used to store processed send email content - for example: 'Apply Gap is out of sync. Current Apply Gap is: <@1 hrs and @2 mins>'
                 my $finalSendEmailContent;#var used to store final send email content
                 
                 my $defineApplyGapErrorThresholdHours;#var used to store the define apply gap error threshold hours

				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support Start
				 eval{  
				    #Get TrailsRP DB Connection 
                    $trailsrp_connection = Database::Connection->new('trailsrp');

                    #Get TrailsRP DB Apply Gap Row
				    @trailsRPDBApplyGapRow = getTrailsRPDBApplyGapFunction($trailsrp_connection);
				
				    #get trailsRP DB current time, last syn time and apply gap seconds
                    $trailsRPDBCurrentTime = $trailsRPDBApplyGapRow[$TRAILSRP_DB_CURRENT_TIME_INDEX];
                    $trailsRPDBLastSYNTime = $trailsRPDBApplyGapRow[$TRAILSRP_DB_LAST_SYN_TIME_INDEX];
				    $trailsRPDBApplyGapSecs = $trailsRPDBApplyGapRow[$TRAILSRP_DB_APPLY_GAP_INDEX];

                    #Disconnect TrailsRP DB Connection 
				    $trailsrp_connection->disconnect();
				    
					#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A Start
					if(defined $trailsRPDBLastSYNTime){
					  print LOG "TrailsRP DB Apply Gap Monitoring 2 - {TrailsRP Database Apply Gap Seconds: $trailsRPDBApplyGapSecs} from {LAST_SYN_TIME: $trailsRPDBLastSYNTime} with {CURRENT_TIME: $trailsRPDBCurrentTime}\n";
            	    
                      if(($trailsRPDBApplyGapSecs >= $applyGapErrorThreshold)#trailsRP DB Apply Error Gap has been reached
				       &&($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG)#only send trailsRP DB Apply Error Email Once a time
				       &&($eventTriggerDay eq $currentDay)){#trigger to send trailsRP DB Apply Error Email on Monday for every week  
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - {TrailsRP DB Apply Gap: $trailsRPDBApplyGapSecs} has been reached with {Error Apply Gap Threshold: $applyGapErrorThreshold}\n";
                    
				         $sendEmailTitle = $errorEmailTitle;
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Send Error Email Title: {$sendEmailTitle}\n";

                         $sendEmailToPersonList = $errorEmailToPersonList;
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Send Error Email To Person List: {$sendEmailToPersonList}\n";
                    
                         $processedSendEmailContent = $errorEmailContentMessage;
                         $trailsRPDBApplyGapHours = int($trailsRPDBApplyGapSecs/3600);#calculate the trailsRP DB error apply gap hours
			             print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Error Apply Gap Hours: {$trailsRPDBApplyGapHours}\n";
				         $trailsRPDBApplyGapRemainingSecs = $trailsRPDBApplyGapSecs%3600;#calculate the trailsRP DB error apply gap remaining seconds
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Error Apply Gap Remaining Seconds: {$trailsRPDBApplyGapRemainingSecs}\n"; 
                         $trailsRPDBApplyGapMins =  int($trailsRPDBApplyGapRemainingSecs/60) + 1;#calculate the trailsRP DB error apply gap remaining mins - please note that here we need to always + 1 min to support the remaning seconds < 60 seconds case 
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Error Apply Gap Mins: {$trailsRPDBApplyGapMins}\n";
                         $processedSendEmailContent =~ s/\@1/$trailsRPDBApplyGapHours/g;#replace @1 with trailsRP DB error apply gap hours - for example: 50(hours)
                         $processedSendEmailContent =~ s/\@2/$trailsRPDBApplyGapMins/g;#replace @2 with trailsRP DB error apply gap mins - for example: 5(mins)
						 $processedSendEmailContent .="\n";
                         $processedSendEmailContent .="Please see the following WIKI link for instructions:\n";
                         $processedSendEmailContent .="https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/Asset%20Management%20Support/page/Handling%20Instruction%20for%20TrailsRP%20and%20TrailsST%20DBs";
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Processed Send Error Email Content: {$processedSendEmailContent}\n";
                         
						 $finalSendEmailContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                         $finalSendEmailContent.="$processedSendEmailContent\n";
                         $finalSendEmailContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                      
			             #Send TrailsRP DB Apply Gap Email
			             sendEmail($sendEmailTitle,$sendEmailToPersonList,"",$finalSendEmailContent);
					
					     #Set the TrailsRP DB Email Send Flag to "Y"
					     $trailsRPDBEmailSendFlag = $TRAILSRP_DB_EMAIL_SENT_FLAG;
					     print LOG "TrailsRP DB Apply Gap Monitoring 2 - Email Send Flag: {$TRAILSRP_DB_EMAIL_SENT_FLAG}\n";
		              }#end if(($trailsRPDBApplyGapSecs >= $applyGapErrorThreshold) && ($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG) && ($eventTriggerDay eq $currentDay))
				      elsif(($trailsRPDBApplyGapSecs < $applyGapErrorThreshold)#trailsRP DB Apply Error Gap has not been reached
					      &&($alwaysSendEmailFlag eq $SEND_ALL_EMAIL_FLAG)#only send trailsRP success email when $alwaysSendEmailFlag = 'Y'
					      &&($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG)#only send trailsRP DB Apply Error Email Once a time
                          &&($eventTriggerDay eq $currentDay)){#trigger to send trailsRP DB Apply Error Email on Monday for every week  
				         print LOG "TrailsRP DB Apply Gap Monitoring 2 - {TrailsRP DB Apply Gap: $trailsRPDBApplyGapSecs} has not been reached with {Error Apply Gap Threshold: $applyGapErrorThreshold}\n";

						 $sendEmailTitle = $successEmailTitle;
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Send Success Email Title: {$sendEmailTitle}\n";

                         $sendEmailToPersonList = $successEmailToPersonList;
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Send Success Email To Person List: {$sendEmailToPersonList}\n";  

                         $processedSendEmailContent = $successEmailContentMessage;
						 $defineApplyGapErrorThresholdHours = int($applyGapErrorThreshold/3600);#calculate the trailsRP DB define apply gap error threshold hours
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Define Apply Gap Error Threshold Hours: {$defineApplyGapErrorThresholdHours}\n"; 
                         $trailsRPDBApplyGapHours = int($trailsRPDBApplyGapSecs/3600);#calculate the trailsRP DB success apply gap hours
			             print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Success Apply Gap Hours: {$trailsRPDBApplyGapHours}\n";
				         $trailsRPDBApplyGapRemainingSecs = $trailsRPDBApplyGapSecs%3600;#calculate the trailsRP DB success apply gap remaining seconds
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Success Apply Gap Remaining Seconds: {$trailsRPDBApplyGapRemainingSecs}\n"; 
                         $trailsRPDBApplyGapMins =  int($trailsRPDBApplyGapRemainingSecs/60) + 1;#calculate the trailsRP DB success apply gap remaining mins - please note that here we need to always + 1 min to support the remaning seconds < 60 seconds case 
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The calculated TrailsRP DB Success Apply Gap Mins: {$trailsRPDBApplyGapMins}\n";
                         $processedSendEmailContent =~ s/\@1/$defineApplyGapErrorThresholdHours/g;#replace @1 with trailsRP DB define apply gap error threshold hours - for example: 48(hours)
						 $processedSendEmailContent =~ s/\@2/$trailsRPDBApplyGapHours/g;#replace @2 with trailsRP DB success apply gap hours - for example: 5(hours)
                         $processedSendEmailContent =~ s/\@3/$trailsRPDBApplyGapMins/g;#replace @3 with trailsRP DB success apply gap mins - for example: 5(mins)  
                         print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Processed Send Success Email Content: {$processedSendEmailContent}\n";

                         $finalSendEmailContent.="------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			             $finalSendEmailContent.="$processedSendEmailContent\n";
                         $finalSendEmailContent.="------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			     
			             #Send TrailsRP DB Apply Gap Email
			             sendEmail($sendEmailTitle,$sendEmailToPersonList,"",$finalSendEmailContent);
					
					     #Set the TrailsRP DB Email Send Flag to "Y"
					     $trailsRPDBEmailSendFlag = $TRAILSRP_DB_EMAIL_SENT_FLAG;
					     print LOG "TrailsRP DB Apply Gap Monitoring 2 - Email Send Flag: {$TRAILSRP_DB_EMAIL_SENT_FLAG}\n";
				      }#end elsif(($trailsRPDBApplyGapSecs < $applyGapErrorThreshold) && ($alwaysSendEmailFlag eq $SEND_ALL_EMAIL_FLAG)) && ($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG) && ($eventTriggerDay eq $currentDay)) 
					}#end if(defined $trailsRPDBLastSYNTime)
					#Support the synctime is null case
					else{
                      if(($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG)#only send trailsRP DB Apply Error Email Once a time
					   &&($eventTriggerDay eq $currentDay)){#only trigger this event rule on Monday
					    print LOG "TrailsRP DB Apply Gap Monitoring 2 - TrailsRP DB Apply Gap Last SYN Time is NULL\n";

					    $sendEmailTitle = $errorEmailTitle;
                        print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Send Error Email Title: {$sendEmailTitle}\n";

                        $sendEmailToPersonList = $errorEmailToPersonList;
                        print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Send Error Email To Person List: {$sendEmailToPersonList}\n";
                    
                        $processedSendEmailContent.= "Replication FAILED: ";
					    $processedSendEmailContent.= "please see the following WIKI link for instructions:\n";
                        $processedSendEmailContent.= "https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/Asset%20Management%20Support/page/Handling%20Instruction%20for%20TrailsRP%20and%20TrailsST%20DBs";
					    print LOG "TrailsRP DB Apply Gap Monitoring 2 - The Processed Send Error Email Content: {$processedSendEmailContent}\n";

                        $finalSendEmailContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			            $finalSendEmailContent.="$processedSendEmailContent\n";
                        $finalSendEmailContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content

                        #Send TrailsRP DB Apply Gap Email
			            sendEmail($sendEmailTitle,$sendEmailToPersonList,"",$finalSendEmailContent);
					
					    #Set the TrailsRP DB Email Send Flag to "Y"
					    $trailsRPDBEmailSendFlag = $TRAILSRP_DB_EMAIL_SENT_FLAG;
					    print LOG "TrailsRP DB Apply Gap Monitoring 2 - Email Send Flag: {$TRAILSRP_DB_EMAIL_SENT_FLAG}\n";
                      }#end if(($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG) && ($eventTriggerDay eq $currentDay)) 
					}#end else
                    #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A End 
            
				    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                    print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
				 };#end eval
				 if($@
				 &&($trailsRPDBEmailSendFlag eq $TRAILSRP_DB_EMAIL_NOT_SENT_FLAG)
				 &&($eventTriggerDay eq $currentDay)){
                  
					$sendEmailTitle = $errorEmailTitle; 
					$sendEmailToPersonList = $errorEmailToPersonList;
				    $finalSendEmailContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			        $finalSendEmailContent.="$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n";#append database exception message into email content
				    $finalSendEmailContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
			        
					#Send TrailsRP DB Apply Gap Email
			        sendEmail($sendEmailTitle,$sendEmailToPersonList,"",$finalSendEmailContent);
                     
                    #Set the TrailsRP DB Email Send Flag to "Y"
					$trailsRPDBEmailSendFlag = $TRAILSRP_DB_EMAIL_SENT_FLAG;
                    print LOG "TrailsRP DB Apply Gap Monitoring 2 - Email Send Flag: {$TRAILSRP_DB_EMAIL_SENT_FLAG}\n";
                    
					$currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
					print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n"; 
				 }
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 - Add DB Exception Feature Support End
			 } 
             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End
			 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 Start
             elsif(($triggerEventGroup eq $APPLICATION_MONITORING && $triggerEventName eq $WEBAPP_RUNNING_STATUS_CHECK_MONITORING)#Event Group: "APPLICATION_MONITORING" + Event Type: "WEBAPP_RUNNING_STATUS_CHECK_MONITORING"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
                 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "Web Application Running Status Check Monitoring - The Server Mode: {$serverMode}\n";
				 my $webAppsCheckConfigValues = $metaRuleParameter2;#var used to store web application check configuration values - for example: "TAP2^Bravo~15~20~http://bravo.boulder.ibm.com/BRAVO/home.do'Trails~15~20~http://trails.boulder.ibm.com/TRAILS/"
				 print LOG "Web Application Running Status Check Monitoring - The Web Applications Check Configuration Values: {$webAppsCheckConfigValues}\n";

                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A Start
				 my $loaderExistingPath = $LOADER_EXISTING_PATH;#var used to store loader existing
			     my $selfHealingEngineSwitch = $metaRuleParameter3;#var used to store Self Healing Engine Switch(Y/N) - For example: Y
				 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Switch: {$selfHealingEngineSwitch}\n";
                 my $selfHealingEngineRestartBravoWebAppOperationDefinition = $metaRuleParameter4;#var used to store Self Healing Engine Restart Bravo Web Application Operation Definition - For example: selfHealingEngine.pl'RESTART_BRAVO_WEB_APPLICATION'~~~~~~~~~
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Bravo Web Application Operation Definition: {$selfHealingEngineRestartBravoWebAppOperationDefinition}\n";
                 my @selfHealingEngineRestartBravoWebAppOperationDefinitionArray = split(/\'/,$selfHealingEngineRestartBravoWebAppOperationDefinition);
				 my $selfHealingEngineRestartBravoWebAppOperationProgramName = trim($selfHealingEngineRestartBravoWebAppOperationDefinitionArray[$SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_PROGRAM_NAME_INDEX]);
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Bravo Web Application Operation Program Name: {$selfHealingEngineRestartBravoWebAppOperationProgramName}\n";
				 my $selfHealingEngineRestartBravoWebAppOperationCode = trim($selfHealingEngineRestartBravoWebAppOperationDefinitionArray[$SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_CODE_INDEX]);
				 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Bravo Web Application Operation Code: {$selfHealingEngineRestartBravoWebAppOperationCode}\n";
                 my $selfHealingEngineRestartBravoWebAppOperationParams = trim($selfHealingEngineRestartBravoWebAppOperationDefinitionArray[$SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_PARAMETERS_INDEX]);
				 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Bravo Web Application Operation Parameters: {$selfHealingEngineRestartBravoWebAppOperationParams}\n";
                 #For Self Healing Engine Operation Parameters Definition and HME Operaiton Parameters Definiton, the definiton rule is the same using '^' char in the configuration file
				 #So in order to avoid this conflict about configuration parse for HME, the Self Healing Engine Operation Parameters have been defined using char '~' and then convert all the chars '~' to the target ones '^'
				 $selfHealingEngineRestartBravoWebAppOperationParams =~ s/\~/\^/g;#replace all the chars '~' with '^' - for example: from '^^^^^^^^^' to '~~~~~~~~~' 
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Bravo Web Application Converted Operation Parameters: {$selfHealingEngineRestartBravoWebAppOperationParams}\n";
                 my $selfHealingEngineRestartBravoWebAppOperationExecutionCommand = "$loaderExistingPath$selfHealingEngineRestartBravoWebAppOperationProgramName $selfHealingEngineRestartBravoWebAppOperationCode $selfHealingEngineRestartBravoWebAppOperationParams";#For example "./selfHealingEngine.pl RESTART_BRAVO_WEB_APPLICATION ^^^^^^^^^"
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Bravo Web Application Operation Execution Command: {$selfHealingEngineRestartBravoWebAppOperationExecutionCommand}\n";
 
                 my $selfHealingEngineRestartTrailsWebAppOperationDefinition = $metaRuleParameter5;#var used to store Self Healing Engine Restart Trails Web Application Operation Definition - For example: selfHealingEngine.pl'RESTART_TRAILS_WEB_APPLICATION'~~~~~~~~~
				 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Trails Web Application Operation Definition:: {$selfHealingEngineRestartTrailsWebAppOperationDefinition}\n";
				 my @selfHealingEngineRestartTrailsWebAppOperationDefinitionArray = split(/\'/,$selfHealingEngineRestartTrailsWebAppOperationDefinition);
				 my $selfHealingEngineRestartTrailsWebAppOperationProgramName = trim($selfHealingEngineRestartTrailsWebAppOperationDefinitionArray[$SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_PROGRAM_NAME_INDEX]);
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Trails Web Application Operation Program Name: {$selfHealingEngineRestartTrailsWebAppOperationProgramName}\n";
				 my $selfHealingEngineRestartTrailsWebAppOperationCode = trim($selfHealingEngineRestartTrailsWebAppOperationDefinitionArray[$SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_CODE_INDEX]);
				 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Trails Web Application Operation Code: {$selfHealingEngineRestartTrailsWebAppOperationCode}\n";
                 my $selfHealingEngineRestartTrailsWebAppOperationParams = trim($selfHealingEngineRestartTrailsWebAppOperationDefinitionArray[$SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_PARAMETERS_INDEX]);
				 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Trails Web Application Operation Parameters: {$selfHealingEngineRestartTrailsWebAppOperationParams}\n";
                 #For Self Healing Engine Operation Parameters Definition and HME Operaiton Parameters Definiton, the definiton rule is the same using '^' char in the configuration file
				 #So in order to avoid this conflict about configuration parse for HME, the Self Healing Engine Operation Parameters have been defined using char '~' and then convert all the chars '~' to the target ones '^'
				 $selfHealingEngineRestartTrailsWebAppOperationParams =~ s/\~/\^/g;#replace all the chars '~' with '^' - for example: from '^^^^^^^^^' to '~~~~~~~~~' 
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Trails Web Application Converted Operation Parameters: {$selfHealingEngineRestartTrailsWebAppOperationParams}\n";
         		 my $selfHealingEngineRestartTrailsWebAppOperationExecutionCommand = "$loaderExistingPath$selfHealingEngineRestartTrailsWebAppOperationProgramName $selfHealingEngineRestartTrailsWebAppOperationCode $selfHealingEngineRestartTrailsWebAppOperationParams";#For example "./selfHealingEngine.pl RESTART_TRAILS_WEB_APPLICATION ^^^^^^^^^"
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Trails Web Application Operation Execution Command: {$selfHealingEngineRestartBravoWebAppOperationExecutionCommand}\n";
 				 
				 my $selfHealingEngineRestartWebAppOperationSuccessMessage = $metaRuleParameter6;#var used to store Self Healing Engine Restart Web Application Operation Success Message - For example: The Self Healing Engine - Restart Web Application @3 Operation has been executed successfully.
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Web Application Operation Success Message: {$selfHealingEngineRestartWebAppOperationSuccessMessage}\n";
				 my $selfHealingEngineRestartWebAppOperationFailMessage = $metaRuleParameter7;#var used to store Self Healing Engine Restart Web Application Operation Fail Message - For example: The Self Healing Engine - Restart Web Application @3 Operation has been executed failed due to reason: @4.
                 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Web Application Operation Fail Message: {$selfHealingEngineRestartWebAppOperationFailMessage}\n";
            	 
				 my $selfHealingEngineRestartWebAppOperationProcessedMessage;#var used to store Self Healing Engine Restart Web Application Operation Processed Message
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A End

				 my $processedRuleTitle;#var used to store processed rule title - for example: 'Web Applications Running Status Check on @1 Server'
				 my $processedRuleMessage;#var used to store processed rule message - for example: 'Web Application @2 is currently not running.'
				 my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code - for example: 'E-APM-WAC-001'
                 my @webAppErrorMessageArray = ();#array used to store webApp Error Message - For example: 'Web Application Bravo is currently not running.'
				 my $webAppErrorMessageArrayCnt;#var used to store the count of webApp Error Message
            	 
                 my @webAppsCheckConfigValuesArray = split(/\'/,$webAppsCheckConfigValues);
				 foreach my $webAppsCheckConfigValuesArrayItem (@webAppsCheckConfigValuesArray){
				   print LOG "Web Application Running Status Check Monitoring - The Web Application Check Configuration Values: {$webAppsCheckConfigValuesArrayItem}\n";
				 
				   $processedRuleMessage = $metaRuleMessage;#Reset to metaRuleMessage for every loop
                   
                   my $processedCURL = $WEBAPP_CURL_COMMAND;#Reset CURL initial value for every loop

				   my @webAppsCheckConfigValuesArrayItemArray = split(/\~/,$webAppsCheckConfigValuesArrayItem);

				   my $webAppName = trim($webAppsCheckConfigValuesArrayItemArray[$WEBAPP_CHECK_CONFIG_VALUE_WEB_APPNAME_INDEX]);#remove spaces
                   print LOG "Web Application Running Status Check Monitoring - The Web Application Check Configuration Value - webAppName: {$webAppName}\n";
				  
				   my $connectTimeout = $webAppsCheckConfigValuesArrayItemArray[$WEBAPP_CHECK_CONFIG_VALUE_CONNECT_TIMEOUT_INDEX];
				   print LOG "Web Application Running Status Check Monitoring - The Web Application Check Configuration Value - connectTimeout: {$connectTimeout}\n";
				   $processedCURL =~ s/\@connectTimeout/$connectTimeout/g;#replace @connectTimeout with connect timeout value - for example: 15
				  
				   my $maxTime = $webAppsCheckConfigValuesArrayItemArray[$WEBAPP_CHECK_CONFIG_VALUE_MAX_TIME_INDEX];
				   print LOG "Web Application Running Status Check Monitoring - The Web Application Check Configuration Value - maxTime: {$maxTime}\n";
				   $processedCURL =~ s/\@maxTime/$maxTime/g;#replace @maxTime with maxTime value - for example: 20
				  
				   my $url = $webAppsCheckConfigValuesArrayItemArray[$WEBAPP_CHECK_CONFIG_VALUE_URL_INDEX];
				   print LOG "Web Application Running Status Check Monitoring - The Web Application Check Configuration Value - url: {$url}\n";
                   $processedCURL =~ s/\@url/$url/g;#replace @url with URL value - for example: http://bravo.boulder.ibm.com/BRAVO/home.do

                   print LOG "Web Application Running Status Check Monitoring - The Processed Unix Command CURL: {$processedCURL}\n";

                   #Invoke the processed CURL unix command
				   my @webReturnMsgs = `$processedCURL`;
                   my $webAppRunningFlag = $FALSE;#Set false as the inital value
                    
                   print LOG "Web Application Running Status Check Monitoring - Start to check Web Return Message with HTTP_OK_CODE: {$HTTP_OK_CODE} or HTTP_FORBIDDEN_CODE: {$HTTP_FORBIDDEN_CODE}\n"; 
                   foreach my $webReturnMsg (@webReturnMsgs){
					 trim($webReturnMsg);#Remove before and after space chars of a string
                     $webReturnMsg =~ s/[\r\n]//g;#Remove \r\n chars for HTML data line. Please note that HTML data line default uses '\r\n' as the ending chars. 
					 print LOG "Web Application Running Status Check Monitoring - Web Return Message: {$webReturnMsg}\n";
					
					 if($webReturnMsg =~ /$HTTP_OK_CODE/#Judge if the web return message includes HTTP_OK_CODE '200'
					  ||$webReturnMsg =~ /$HTTP_FORBIDDEN_CODE/){#Judge if the web return message includes HTTP_FORBIDDEN_CODE '403'
                       $webAppRunningFlag = $TRUE;
					   last;
					 }
                   }#end foreach my $webReturnMsg (@webReturnMsgs)

                   if($webAppRunningFlag == $TRUE){
                     print LOG "Web Application Running Status Check Monitoring - The Web Application $webAppName is currently running.\n"; 
					 
                     #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 - Add Some Testing Function Codes only for TAP2 Testing Server Start
					 #For Testing Purpose on TAP2 Server only Start
					 #For TAP2 Testing Server, whatever there are actual webApp Error Messages or not, always generates webApp Error Messages about Alert Email Content for testing purpose 
					 if($SERVER_MODE eq $TAP2){
                       $processedRuleMessage =~ s/\@2/$webAppName/g;#replace @2 with web application name value - for example: 'Bravo'
					   push @webAppErrorMessageArray, $processedRuleMessage;
                       
                       #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A Start
                       #Please note that the following codes have been added for Testing Purpose on TAP2 Server only
					   #The Self Healing Engine Restart Web Application Operation Automatically Started here
					   if(($selfHealingEngineSwitch eq $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_TURN_ON)#Self Healing Engine Restart Web Application Feature has been turn on
					    &&($webAppName eq $BRAVO_WEB_APP||$webAppName eq $TRAILS_WEB_APP)#Restart Web Application Self Healing Operation only used for Bravo/Trails Web Application
					     ){

					     #Switch to the target perl execution folder - '/opt/staging/v2/'  
					     chdir $loaderExistingPath;
		                 print LOG "Web Application Running Status Check Monitoring - The Target Folder: {$loaderExistingPath} has been switched.\n";
                       
					     #Check the current folder information	 
					     my @pwdReturnMsgs = `$PWD_UNIX_COMMAND`;
					     foreach my $pwdReturnMsg(@pwdReturnMsgs){
					       chomp($pwdReturnMsg);
					       print LOG "Web Application Running Status Check Monitoring - The Current Folder: {$pwdReturnMsg}\n";
					     }#end foreach my $pwdReturnMsg(@pwdReturnMsgs)

					     my $restartWebAppExecCmd;#var used to to store restart web application execution command
					     if($webAppName eq $BRAVO_WEB_APP){
					       $restartWebAppExecCmd = $selfHealingEngineRestartBravoWebAppOperationExecutionCommand;#"./selfHealingEngine.pl RESTART_BRAVO_WEB_APPLICATION ^^^^^^^^^"
					     }#end if($webAppName eq $BRAVO_WEB_APP)
					     else{
					       $restartWebAppExecCmd = $selfHealingEngineRestartTrailsWebAppOperationExecutionCommand;#"./selfHealingEngine.pl RESTART_TRAILS_WEB_APPLICATION ^^^^^^^^^"
					     }#end else

					     my $restartWebAppCmdExecResult = system($restartWebAppExecCmd);
                         if($restartWebAppCmdExecResult == 0){
					       print LOG "Web Application Running Status Check Monitoring - The Restart Web Application Unix Command {$restartWebAppExecCmd} has been executed successfully.\n";
					       $selfHealingEngineRestartWebAppOperationProcessedMessage = $selfHealingEngineRestartWebAppOperationSuccessMessage;
						   $selfHealingEngineRestartWebAppOperationProcessedMessage =~ s/\@2/$webAppName/g;#replace @2 with web application name value - for example: 'Bravo'
						   push @webAppErrorMessageArray, "*** $selfHealingEngineRestartWebAppOperationProcessedMessage ***";
						   print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Web Application Operation Processed Message: {$selfHealingEngineRestartWebAppOperationProcessedMessage}\n"; 
					     }#end if($restartWebAppCmdExecResult == 0)
					     else{
					       print LOG "Web Application Running Status Check Monitoring - The Restart Web Application Unix Command {$restartWebAppExecCmd} has been executed failed.\n";
                           $selfHealingEngineRestartWebAppOperationProcessedMessage = $selfHealingEngineRestartWebAppOperationFailMessage;
                           $selfHealingEngineRestartWebAppOperationProcessedMessage =~ s/\@2/$webAppName/g;#replace @2 with web application name value - for example: 'Bravo'
                           $selfHealingEngineRestartWebAppOperationProcessedMessage =~ s/\@3/"The Restart Web Application Unix Command: {$restartWebAppExecCmd} has been executed failed."/g;
                           push @webAppErrorMessageArray, "*** $selfHealingEngineRestartWebAppOperationProcessedMessage ***";
                           print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Web Application Operation Processed Message: {$selfHealingEngineRestartWebAppOperationProcessedMessage}\n"; 
					     }#end else

                         #Switch back to the HME home folder - '/home/liuhaidl/working/scripts'  
					     chdir $HOME_DIR;
		                 print LOG "Web Application Running Status Check Monitoring - The HealthCheck and Monitoring Engine Home Folder: {$HOME_DIR} has been switched back.\n";
                      
					     #Check the current folder information	 
					     @pwdReturnMsgs = `$PWD_UNIX_COMMAND`;
					     foreach my $pwdReturnMsg(@pwdReturnMsgs){
					       chomp($pwdReturnMsg);
					       print LOG "Web Application Running Status Check Monitoring - The Current Folder: {$pwdReturnMsg}\n";
					     }#end foreach my $pwdReturnMsg(@pwdReturnMsgs)
					   }#end if(($selfHealingEngineSwitch eq $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_TURN_ON) &&($webAppName eq $BRAVO_WEB_APP||$webAppName eq $TRAILS_WEB_APP))
                       #The Self Healing Engine Restart Web Application Operation Automatically Ended here
                       #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A End
					 }#end if($SERVER_MODE eq $TAP2)
					 #For Testing Purpose on TAP2 Server only End
					 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 - Add Some Testing Function Codes only for TAP2 Testing Server End
				   }#end if($webAppRunningFlag == $TRUE)
				   else{
					 $processedRuleMessage =~ s/\@2/$webAppName/g;#replace @2 with web application name value - for example: 'Bravo'
					 push @webAppErrorMessageArray, $processedRuleMessage;
				     print LOG "Web Application Running Status Check Monitoring - The Web Application $webAppName is currently not running.\n";
					 
					 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A Start
					 #The Self Healing Engine Restart Web Application Operation Automatically Started here
					 if(($selfHealingEngineSwitch eq $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_TURN_ON)#Self Healing Engine Restart Web Application Feature has been turn on
					  &&($webAppName eq $BRAVO_WEB_APP||$webAppName eq $TRAILS_WEB_APP)#Restart Web Application Self Healing Operation only used for Bravo/Trails Web Application
					   ){

					   #Switch to the target perl execution folder - '/opt/staging/v2/'  
					   chdir $loaderExistingPath;
		               print LOG "Web Application Running Status Check Monitoring - The Target Folder: {$loaderExistingPath} has been switched.\n";
                       
					   #Check the current folder information	 
					   my @pwdReturnMsgs = `$PWD_UNIX_COMMAND`;
					   foreach my $pwdReturnMsg(@pwdReturnMsgs){
					     chomp($pwdReturnMsg);
					     print LOG "Web Application Running Status Check Monitoring - The Current Folder: {$pwdReturnMsg}\n";
					   }#end foreach my $pwdReturnMsg(@pwdReturnMsgs)

					   my $restartWebAppExecCmd;#var used to to store restart web application execution command
					   if($webAppName eq $BRAVO_WEB_APP){
					     $restartWebAppExecCmd = $selfHealingEngineRestartBravoWebAppOperationExecutionCommand;#"./selfHealingEngine.pl RESTART_BRAVO_WEB_APPLICATION ^^^^^^^^^"
					   }#end if($webAppName eq $BRAVO_WEB_APP)
					   else{
					     $restartWebAppExecCmd = $selfHealingEngineRestartTrailsWebAppOperationExecutionCommand;#"./selfHealingEngine.pl RESTART_TRAILS_WEB_APPLICATION ^^^^^^^^^"
					   }#end else

					   my $restartWebAppCmdExecResult = system($restartWebAppExecCmd);
                       if($restartWebAppCmdExecResult == 0){
					     print LOG "Web Application Running Status Check Monitoring - The Restart Web Application Unix Command {$restartWebAppExecCmd} has been executed successfully.\n";
					     $selfHealingEngineRestartWebAppOperationProcessedMessage = $selfHealingEngineRestartWebAppOperationSuccessMessage;
						 $selfHealingEngineRestartWebAppOperationProcessedMessage =~ s/\@2/$webAppName/g;#replace @2 with web application name value - for example: 'Bravo'
						 push @webAppErrorMessageArray, "*** $selfHealingEngineRestartWebAppOperationProcessedMessage ***";
						 print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Web Application Operation Processed Message: {$selfHealingEngineRestartWebAppOperationProcessedMessage}\n"; 
					   }#end if($restartWebAppCmdExecResult == 0)
					   else{
					     print LOG "Web Application Running Status Check Monitoring - The Restart Web Application Unix Command {$restartWebAppExecCmd} has been executed failed.\n";
                         $selfHealingEngineRestartWebAppOperationProcessedMessage = $selfHealingEngineRestartWebAppOperationFailMessage;
                         $selfHealingEngineRestartWebAppOperationProcessedMessage =~ s/\@2/$webAppName/g;#replace @2 with web application name value - for example: 'Bravo'
                         $selfHealingEngineRestartWebAppOperationProcessedMessage =~ s/\@3/"The Restart Web Application Unix Command: {$restartWebAppExecCmd} has been executed failed."/g;
                         push @webAppErrorMessageArray, "*** $selfHealingEngineRestartWebAppOperationProcessedMessage ***";
                         print LOG "Web Application Running Status Check Monitoring - The Self Healing Engine Restart Web Application Operation Processed Message: {$selfHealingEngineRestartWebAppOperationProcessedMessage}\n"; 
					   }#end else

                       #Switch back to the HME home folder - '/home/liuhaidl/working/scripts'  
					   chdir $HOME_DIR;
		               print LOG "Web Application Running Status Check Monitoring - The HealthCheck and Monitoring Engine Home Folder: {$HOME_DIR} has been switched back.\n";
                      
					   #Check the current folder information	 
					   @pwdReturnMsgs = `$PWD_UNIX_COMMAND`;
					   foreach my $pwdReturnMsg(@pwdReturnMsgs){
					     chomp($pwdReturnMsg);
					     print LOG "Web Application Running Status Check Monitoring - The Current Folder: {$pwdReturnMsg}\n";
					   }#end foreach my $pwdReturnMsg(@pwdReturnMsgs)
					 }#end if(($selfHealingEngineSwitch eq $SELF_HEALING_ENGINE_RESTART_WEB_APP_OPERATION_TURN_ON) &&($webAppName eq $BRAVO_WEB_APP||$webAppName eq $TRAILS_WEB_APP))
                     #The Self Healing Engine Restart Web Application Operation Automatically Ended here
					 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8A End
				   }#end else
         		 }#end foreach my $webAppsCheckConfigValuesArrayItem (@webAppsCheckConfigValuesArray)
                 
				 #Calculate the count of webApp Error Message
				 $webAppErrorMessageArrayCnt = scalar(@webAppErrorMessageArray);
				 
                 $processedRuleTitle = $metaRuleTitle;
                 $processedRuleTitle =~ s/\@1/$serverMode/g;#replace @1 with server mode value - for example: TAP
				 print LOG "Web Application Running Status Check Monitoring - The Processed Rule Title: {$processedRuleTitle}\n";

				 #Generate the alert email content when $webAppErrorMessageArrayCnt >0  
				 if($webAppErrorMessageArrayCnt >0){
				   
                   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
				   $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
                   
         		   $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                   $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				   print LOG "Web Application Running Status Check Monitoring - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n";
                   
				   foreach $processedRuleMessage (@webAppErrorMessageArray){
                     $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";
                     print LOG "Web Application Running Status Check Monitoring - The Processed Rule Message: {$processedRuleMessage}\n";
				   }
				   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				 }
				   
				 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
		     }#end elsif(($triggerEventGroup eq $APPLICATION_MONITORING && $triggerEventName eq $WEBAPP_RUNNING_STATUS_CHECK_MONITORING) && ($SERVER_MODE eq $metaRuleParameter1)) 
             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 8 End
			 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 Start
             elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $DB_EXCEPTION_STATUS_CHECK_MONITORING)#Event Group: "DATABASE_MONITORING" + Event Type: "DB_EXCEPTION_STATUS_CHECK_MONITORING"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
				 my $cfg=Config::Properties::Simple->new(file=>'/opt/staging/v2/config/connectionConfig.txt');
				 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "Database Exception Status Check Monitoring - The Server Mode: {$serverMode}\n";
			     my $monitoringDBsDefinitionList = $metaRuleParameter2;#var used to store monitoring databases definition list - for example: 'TRAILS~TRAILSPD~eaadmin~Gr77nday~dst20lp05.boulder.ibm.com~liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com'STAGING~STAGING~eaadmin~apr03db2~dst20lp05.boulder.ibm.com~liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com'
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Databases Definition List: {$monitoringDBsDefinitionList}\n";
				 my $monitoringDBExceptionCodeList = $metaRuleParameter3;#var used to store monitoring database exception code list to be notified to DBA team - for example: 'SQL1032N'SQL30081N'
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exception Code List: {$monitoringDBExceptionCodeList}\n";
				 my @monitoringDBExceptionCodeArray = split(/\'/,$monitoringDBExceptionCodeList);#array used to store monitoring database exception code array to be notified to DBA team - for example: ['SQL1032N','SQL30081N']
                 my $monitoringDBExclusionStartTime = $metaRuleParameter4;#var used to store monitoring database exclusion start time - for example: 'Sun'03'
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion Start Time: {$monitoringDBExclusionStartTime}\n";
                 my $monitoringDBExclusionEndTime = $metaRuleParameter5;#var used to store monitoring database exclusion end time - for example: 'Sun'10'
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion End Time: {$monitoringDBExclusionEndTime}\n";
				 my $monitoringDBExceptionEmailTitle = $metaRuleParameter6;#var used to store monitoring database exception email title - for example: 'The Database Exception Email for Database @2 on server @3'
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exception Email Title: {$monitoringDBExceptionEmailTitle}\n";
                 my $monitoringDBExceptionEmailContent = $metaRuleParameter7;#var used to store monitoring database exception email content - for example: 'The Database @2 on server @3 has exception: @4'
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exception Email Content: {$monitoringDBExceptionEmailContent}\n";
	 
				 my $processedRuleTitle;#var used to store processed rule title - for example: 'Database Exception Status Check on @1 Server'
                 my $processedRuleMessage;#var used to store processed rule message - for example: 'The Database @2 on server @3 has exception: @4'
				 my $processedRuleHandlingInstructionCode;#var used to store processed rule handling instruction code - for example: 'E-DBM-DEC-001'
                 my @monitoringDBsErrorMessageArray = ();#array used to store monitoring databases Error Messages - For example: 'The Database @2 on server @3 has exception: @4'
				 my $monitoringDBsErrorMessageArrayCnt;#var used to store the count of monitoring databases Error Messages
				 my $monitoringDBsBypassFlag = $FALSE;#var used to store the monitoring databases bypass flag

                 $processedRuleTitle = $metaRuleTitle;
				 $processedRuleTitle =~ s/\@1/$SERVER_MODE/g;
			     $processedRuleHandlingInstructionCode = $metaRuleHandlingInstrcutionCode;
                 
                 my @monitoringDBExclusionStartTimeArray = split(/\'/,$monitoringDBExclusionStartTime);
                 my $monitoringDBExclusionStartWeekday = trim($monitoringDBExclusionStartTimeArray[0]);#For example: 'Sunday'
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion Start Weekday: {$monitoringDBExclusionStartWeekday}\n";
                 my $monitoringDBExclusionStartWeekdayNumber = getCurrentWeekdayNumber($monitoringDBExclusionStartWeekday);#For example: 7 = Sunday
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion Start Weekday Number: {$monitoringDBExclusionStartWeekdayNumber}\n";
                 my $monitoringDBExclusionStartHour = trim($monitoringDBExclusionStartTimeArray[1]);#For example: '03'
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion Start Hour: {$monitoringDBExclusionStartHour}\n";

                 my @monitoringDBExclusionEndTimeArray = split(/\'/,$monitoringDBExclusionEndTime);
                 my $monitoringDBExclusionEndWeekday = trim($monitoringDBExclusionEndTimeArray[0]);#For example: 'Sunday'
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion End Weekday: {$monitoringDBExclusionEndWeekday}\n";
				 my $monitoringDBExclusionEndWeekdayNumber = getCurrentWeekdayNumber($monitoringDBExclusionEndWeekday);#For example: 7 = Sunday
				 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion End Weekday Number: {$monitoringDBExclusionEndWeekdayNumber}\n";
                 my $monitoringDBExclusionEndHour = trim($monitoringDBExclusionEndTimeArray[1]);#For example: '10'
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exclusion End Hour: {$monitoringDBExclusionEndHour}\n";
                 
				 my $dateObject = &getTime();#Get the hash address of current system time object
				 my $currentWeekday = $dateObject->{wday};
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Current Weekday: {$currentWeekday}\n";
				 my $currentWeekdayNumber = getCurrentWeekdayNumber($currentWeekday);
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Current Weekday Number: {$currentWeekdayNumber}\n";
                 my $currentHour = $dateObject->{hour};
                 print LOG "Database Exception Status Check Monitoring - The Monitoring Database Current Hour: {$currentHour}\n";
				 
                 #judge if the current time is in the monitoring exclusion duratime time
                 if(($currentWeekdayNumber>$monitoringDBExclusionStartWeekdayNumber)&&($currentWeekdayNumber<$monitoringDBExclusionEndWeekdayNumber)){
				   $monitoringDBsBypassFlag = $TRUE;
				 }
				 elsif(($monitoringDBExclusionStartWeekdayNumber==$monitoringDBExclusionEndWeekdayNumber)&&($currentWeekdayNumber==$monitoringDBExclusionStartWeekdayNumber)&&($currentHour ge $monitoringDBExclusionStartHour)&&($currentHour le $monitoringDBExclusionEndHour)){
				   $monitoringDBsBypassFlag = $TRUE;
				 }
				 elsif(($currentWeekdayNumber==$monitoringDBExclusionStartWeekdayNumber)&&($currentHour ge $monitoringDBExclusionStartHour)&&($currentWeekdayNumber<$monitoringDBExclusionEndWeekdayNumber)){
                   $monitoringDBsBypassFlag = $TRUE;
				 }
				 elsif(($currentWeekdayNumber==$monitoringDBExclusionEndWeekdayNumber)&&($currentHour le $monitoringDBExclusionEndHour)&&($currentWeekdayNumber>$monitoringDBExclusionStartWeekdayNumber)){
				   $monitoringDBsBypassFlag = $TRUE;
				 }

			     if($monitoringDBsBypassFlag == $FALSE)
				 {
                   print LOG "Database Exception Status Check Monitoring - The Current Time {$currentWeekday $currentHour} is not in the monitoring exclusion duration time {$monitoringDBExclusionStartWeekday $monitoringDBExclusionStartHour,$monitoringDBExclusionEndWeekday $monitoringDBExclusionEndHour}\n";
                   print LOG "Database Exception Status Check Monitoring - The Database Monitoring Operation should be done.\n";

				   #set monitoring db profile
				   my $monitoringDBProfile;#var used to store db monitoring profile
                   if($serverMode eq $TAP){#TAP DB Profile
				     $monitoringDBProfile = "/db2/tap/sqllib/db2profile";  	    
				   }#end if($serverMode eq $TAP)
				   elsif($serverMode eq $TAP2){#TAP2 DB Profile 
				     $monitoringDBProfile = "/home/tap/sqllib/db2profile";   
				   }#end elsif($serverMode eq $TAP2)
                   print LOG "Database Exception Status Check Monitoring - The Monitoring Database Profile: {$monitoringDBProfile}\n"; 
             
                   #1.set db2profile
                   `. $monitoringDBProfile`;
                   print LOG "Database Exception Status Check Monitoring - The Monitoring Database Profile {$monitoringDBProfile} has been set.\n"; 

				   my @monitoringDBsDefinitionArray = split(/\&/,$monitoringDBsDefinitionList);
				   my $monitoringDBDefinition;#var used to store monitoring database definition - for example: 'TRAILS~TRAILSPD~eaadmin~Gr77nday~dst20lp05.boulder.ibm.com~liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com'
				   foreach $monitoringDBDefinition(@monitoringDBsDefinitionArray){
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Definition: {$monitoringDBDefinition}\n";
				     my @monitoringDBDefinitionArray = split(/\~/,$monitoringDBDefinition);
				     my $monitoringDBtmp = $monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_ALIAS_INDEX];#For example: 'trails.name'
				     my $monitoringDBtmp2 =  $cfg->getProperty("$monitoringDBtmp");#For example: 'TRAILS'
				     my $monitoringDBAlias = trim($monitoringDBtmp2);#For example: 'TRAILS'
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Alias: {$monitoringDBAlias}\n";
				     $monitoringDBtmp = $monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_REAL_NAME_INDEX];#For example: 'TRAILSPD'
				     my $monitoringDBRealName = trim($monitoringDBtmp);#For example: 'TRAILS'
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Real Name: {$monitoringDBRealName}\n";
				     $monitoringDBtmp = $monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_USERID_INDEX];#For example: 'trails.user'
				     $monitoringDBtmp2 =  $cfg->getProperty("$monitoringDBtmp");#For example: 'eaadmin'
				     my $monitoringDBUserId = trim($monitoringDBtmp2);#For example: 'eaadmin'
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database UserId: {$monitoringDBUserId}\n";
				     $monitoringDBtmp = $monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_PASSWORD_INDEX];#For example: 'trails.password'
				     $monitoringDBtmp2 =  $cfg->getProperty("$monitoringDBtmp");#For example: 'Gr77nday'
				     my $monitoringDBPassword = trim($monitoringDBtmp2);#For example: 'Gr77nday'
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Password: {$monitoringDBPassword}\n";
				     my $monitoringDBLocatedServer = trim($monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_LOCATED_SERVER_INDEX]);#For example: 'dst20lp05.boulder.ibm.com'
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Located Server: {$monitoringDBLocatedServer}\n";
				     my $monitoringDBDBANotifyEmailList = trim($monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_LIST_INDEX]);#For example: 'liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com|liuhaidl@cn.ibm.com'
				     print LOG "Database Exception Status Check Monitoring - The Monitoring Database DBA Notify Email List: {$monitoringDBDBANotifyEmailList}\n";
				     my @monitoringDBDBANotifyEmailArray = split(/\,/,$monitoringDBDBANotifyEmailList);
				     foreach my $monitoringDBDBANotifyEmail(@monitoringDBDBANotifyEmailArray){
                       print LOG "Database Exception Status Check Monitoring - The Monitoring Database DBA Notify Email: {$monitoringDBDBANotifyEmail}\n";
				     }#end foreach my $monitoringDBDBANotifyEmail(@monitoringDBDBANotifyEmailArray)
                     my $monitoringDBDBANotifyEmailSwitch = trim($monitoringDBDefinitionArray[$DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_SWITCH_INDEX]);#For example: 'Y' - means turn no the DBA notify email function or 'N' - means turn off the DBA notify email function
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database DBA Notify Email Switch: {$monitoringDBDBANotifyEmailSwitch}\n";

				     my $monitoringDBConnectionProcessedCommand = $DB_CONNECTION_COMMAND;
                     $monitoringDBConnectionProcessedCommand =~ s/\@1/$monitoringDBAlias/g;#replace #1 with monitoring database alias - for example: 'TRAILS'
                     $monitoringDBConnectionProcessedCommand =~ s/\@2/$monitoringDBUserId/g;#replace #2 with monitoring database userid - for example: 'eaadmin'
				     $monitoringDBConnectionProcessedCommand =~ s/\@3/$monitoringDBPassword/g;#replace #3 with monitoring database password - for example: 'Gr77nday'
                     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Connection Processed Command: {$monitoringDBConnectionProcessedCommand}\n";
				   
                     #2.connect to target monitoring database
				     my $monitoringDBConnReturnMsg = `$monitoringDBConnectionProcessedCommand`;
				     print LOG "Database Exception Status Check Monitoring - The Monitoring Database Connection Return Message: {$monitoringDBConnReturnMsg}\n";
                   
				     if(index($monitoringDBConnReturnMsg,$DB_CONNECTION_SUCCESS_KEY_MESSAGE)>-1){#DB Connection Success
                       print LOG "Database Exception Status Check Monitoring - The Monitoring Database {$monitoringDBAlias} has been connected successfully.\n"; 
				     }#end if(index($monitoringDBConnReturnMsg,$DB_CONNECTION_SUCCESS_KEY_MESSAGE)>-1)
				     else{#DB Connection Failure
					   print LOG "Database Exception Status Check Monitoring - The Monitoring Database {$monitoringDBAlias} has been connected failed.\n";
                       $processedRuleMessage = $metaRuleMessage;#For example: 'The Database @2 on server @3 has exception: @4'
                       $processedRuleMessage =~ s/\@2/$monitoringDBRealName/g;#replace @2 with monitoring database real name - for example: 'TRAILS'
                       $processedRuleMessage =~ s/\@3/$monitoringDBLocatedServer/g;#replace @3 with monitoring database located server - for example: 'dst20lp05.boulder.ibm.com'
					   $processedRuleMessage =~ s/\@4/$monitoringDBConnReturnMsg/g;#replace @4 with monitoring database connection return message
                       push @monitoringDBsErrorMessageArray,$processedRuleMessage;#append event rule message into email message array

					   #judge if the DB exception is the one which defined to notify DBA team
					   foreach my $monitoringDBExceptionCode(@monitoringDBExceptionCodeArray){
						   print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exception Code {$monitoringDBExceptionCode}\n";
					     if(index($monitoringDBConnReturnMsg,$monitoringDBExceptionCode)>-1){
						   print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exception Code {$monitoringDBExceptionCode} has been included into the Database Connection Return Message: {$monitoringDBConnReturnMsg}\n";
						   print LOG "Database Exception Status Check Monitoring - The Monitoring Database Exception Code {$monitoringDBExceptionCode} is one Database Exception which should be notified to DBA team.\n";
						  
						   #Send Database Exception Email to DBA team related persons
						   my $processMonitoringDBExceptionEmailTitle = $monitoringDBExceptionEmailTitle;#For example: 'The Database Exception Email for Database @2 on server @3'
                           $processMonitoringDBExceptionEmailTitle =~ s/\@2/$monitoringDBRealName/g;#replace @2 with monitoring database real name - for example: 'TRAILS'
                           $processMonitoringDBExceptionEmailTitle =~ s/\@3/$monitoringDBLocatedServer/g;#replace @3 with monitoring database located server - for example: 'dst20lp05.boulder.ibm.com'
                           print LOG "Database Exception Status Check Monitoring - The Processed Monitoring Database Exception Email Title {$processMonitoringDBExceptionEmailTitle}\n";
                           
                           my $processMonitoringDBExceptionEmailContent = $monitoringDBExceptionEmailContent;#For example: 'The Database @2 on server @3 has exception: @4'
						   $processMonitoringDBExceptionEmailContent =~ s/\@2/$monitoringDBRealName/g;#replace @2 with monitoring database real name - for example: 'TRAILS'
                           $processMonitoringDBExceptionEmailContent =~ s/\@3/$monitoringDBLocatedServer/g;#replace @3 with monitoring database located server - for example: 'dst20lp05.boulder.ibm.com'
						   $processMonitoringDBExceptionEmailContent =~ s/\@4/$monitoringDBConnReturnMsg/g;#replace @4 with monitoring database connection return message
                           print LOG "Database Exception Status Check Monitoring - The Processed Monitoring Database Exception Email Content {$processMonitoringDBExceptionEmailContent}\n";
                           
                           my $processMonitoringDBExceptionEmailFinalContent = "";
						   $processMonitoringDBExceptionEmailFinalContent.="-----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			               $processMonitoringDBExceptionEmailFinalContent.="$processMonitoringDBExceptionEmailContent\n";
                           $processMonitoringDBExceptionEmailFinalContent.="-----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                           
						   if($monitoringDBDBANotifyEmailSwitch eq $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_TURN_ON){#Email Notify Funciton has been turn on
							 print LOG "Database Exception Status Check Monitoring - The Database Exception Email Notify Function has been turn on for DBA team.\n";
							 sendEmail($processMonitoringDBExceptionEmailTitle,$monitoringDBDBANotifyEmailList,"",$processMonitoringDBExceptionEmailFinalContent);
						     print LOG "Database Exception Status Check Monitoring - The Database Exception Email for Database {$monitoringDBRealName} on Server {$monitoringDBLocatedServer} has been sent to {$monitoringDBDBANotifyEmailList} DBA Team Related Persons Successfully.\n";
						   }#end if($monitoringDBDBANotifyEmailSwitch eq $DB_EXPCEPTION_CHECK_CONFIG_VALUE_MONITORING_DB_DBA_NOTIFY_EMAIL_TURN_ON)
						   else{#Email Notify Funciton has been turn off
						     print LOG "Database Exception Status Check Monitoring - The Database Exception Email Notify Function has been turn off. So the Database Exception Notify Email has not been sent for DBA team.\n";  
						   }#end else
						 
						   last;
						 }#end if(index($monitoringDBConnReturnMsg,$DB_CONNECTION_SUCCESS_KEY_MESSAGE)>-1)
					   }
                        
				     }#end else
                   }#end foreach $monitoringDBDefinition(@monitoringDBsDefinitionArray)

                   #Calculate the count of webApp Error Message
				   $monitoringDBsErrorMessageArrayCnt = scalar(@monitoringDBsErrorMessageArray);

                   #Generate the alert email content when $monitoringDBsErrorMessageArrayCnt>0  
				   if($monitoringDBsErrorMessageArrayCnt>0){
				   
                     $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
				     $emailFullContent.="$EVENT_RULE_TITLE_TXT: $processedRuleTitle\n";
				     print LOG "Database Exception Status Check Monitoring - The Processed Rule Title: {$processedRuleTitle}\n";
                   
         		     $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $processedRuleHandlingInstructionCode\n";
				     print LOG "Database Exception Status Check Monitoring - The Processed Rule Handling Instruction Code: {$processedRuleHandlingInstructionCode}\n"; 
				   
				     foreach $processedRuleMessage (@monitoringDBsErrorMessageArray){
                       $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage";
                       print LOG "Database Exception Status Check Monitoring - The Processed Rule Message: {$processedRuleMessage}\n";
				     }
				     $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				   }#end if($monitoringDBsErrorMessageArrayCnt>0)
				 }#end if(($currentWeekdayNumber<=$monitoringDBExclusionStartWeekdayNumber)&&($currentHour lt $monitoringDBExclusionStartHour)||($currentWeekdayNumber>=$monitoringDBExclusionEndWeekdayNumber)&&($currentHour gt $monitoringDBExclusionEndHour))
                 else {
				   print LOG "Database Exception Status Check Monitoring - The Current Time {$currentWeekday $currentHour} is in the monitoring exclusion duration time {$monitoringDBExclusionStartWeekday $monitoringDBExclusionStartHour,$monitoringDBExclusionEndWeekday $monitoringDBExclusionEndHour}\n";
				   print LOG "Database Exception Status Check Monitoring - The Database Monitoring Operation should be bypassed.\n";
				 }

                 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
			 }#end elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $DB_EXCEPTION_STATUS_CHECK_MONITORING) && ($SERVER_MODE eq $metaRuleParameter1)) 
             #Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 End
             #Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10 Start
             elsif(($triggerEventGroup eq $DATABASE_MONITORING && $triggerEventName eq $RECON_QUEUES_DUPLICATE_DATA_MONITORING_AND_CLEANUP)#Event Group: "DATABASE_MONITORING" + Event Type: "TRAILSRP_DB_APPLY_GAP_MONITORING"
				 &&($SERVER_MODE eq $metaRuleParameter1)){#trigger rule only if the running server is equal to the rule setting server - for example: TAP
                 my $serverMode = $metaRuleParameter1;#var used to store trigger server mode - for example: 'TAP'
				 print LOG "Recon queues duplicate data monitoring - Server Mode: {$serverMode}\n";
				 my $AllowSelfHealingExecution = $metaRuleParameter2;#var used to store flag if SHE can be invoked
				 print LOG "Recon queues duplicate data monitoring - Allow SelfHealingEngine: {$AllowSelfHealingExecution }\n";
				 my $executeSelfHealingEngine = $metaRuleParameter3;#var used to store the command for invoking SHE
				 $executeSelfHealingEngine =~ s/\~/\^/g;#replace all the chars '~' with '^' - for example: from '^^^^^^^^^' to '~~~~~~~~~' 
				 $executeSelfHealingEngine =~ s/\'/\ /g;
				 $executeSelfHealingEngine = 'cd /opt/staging/v2/ && ./'.$executeSelfHealingEngine;#switching to right directory to SHE

				 print LOG "Recon queues duplicate data monitoring - Command for invoking SelfHealingEngine: {$executeSelfHealingEngine}\n";
                 my $SuccesMessage = $metaRuleParameter4;#var used to store message to display when SHE succesfuly ran
                 print LOG "Recon queues duplicate data monitoring - Success Message: {$SuccesMessage }\n";
                 my $FailedMessage = $metaRuleParameter5;#var used to store message to display when SHE failed
                 print LOG "Recon queues duplicate data monitoring - Failed Message: {$FailedMessage}\n";
				 my $DuplicatesInfoMessageAfterCleanup = $metaRuleParameter6;#var used to store message to put in HME mail
				 print LOG "Recon queues duplicate data monitoring - Duplicates info message after SHE call: {$DuplicatesInfoMessageAfterCleanup}\n";
                 my $MessageTitle = $metaRuleParameter7;#var used to store message Title
				 $MessageTitle =~ s/\@1/$SERVER_MODE/g;# Add server mode into message title, for example 'TAP'
				 print LOG "Recon queues duplicate data monitoring - Message title: {$MessageTitle}\n";
				 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A Start 
				 my $DuplicatesInfoMessage = $metaRuleParameter8;#var used to store message to put in HME mail
				 print LOG "Recon queues duplicate data monitoring - Duplicate info message before cleanup: {$DuplicatesInfoMessage}\n";
                 #Added by Larry for HealthCheck And Monitoring Service Component - Phase 7A End
                 my $bravo_connection = Database::Connection->new('trails');
                 my @Duplicate;
                 my @NumbersOfDuplicates;
                 my $FlagDuplicatesExist = $FALSE ;
                 my $FlagSHEError = $FALSE ;

                 print LOG "Starting query 1\n";
                 $bravo_connection->prepareSqlQuery('Recon duplicate 1', $RECON_QUEUE_DUPLICATE_CHECK_1);
                 my $sth = $bravo_connection->sql->{'Recon duplicate 1'};
                 $sth->execute();
                 while (@Duplicate = $sth->fetchrow_array()){
                   push @NumbersOfDuplicates, $Duplicate[0];  
                 }
                 $sth->finish;

                 print LOG "End of query 1\n";
                 print LOG "Starting query 2\n";
                 $bravo_connection->prepareSqlQuery('Recon duplicate 2', $RECON_QUEUE_DUPLICATE_CHECK_2);
                 $sth = $bravo_connection->sql->{'Recon duplicate 2'};
                 $sth->execute();
                 while (@Duplicate = $sth->fetchrow_array()){
                   push @NumbersOfDuplicates, $Duplicate[0];  
                 }
                 $sth->finish;

                 print LOG "End of query 2\n";
                 print LOG "Starting query 3\n";
                 $bravo_connection->prepareSqlQuery('Recon duplicate 3', $RECON_QUEUE_DUPLICATE_CHECK_3);
                 $sth = $bravo_connection->sql->{'Recon duplicate 3'};
                 $sth->execute();
                 while (@Duplicate = $sth->fetchrow_array()){
                   push @NumbersOfDuplicates, $Duplicate[0];  
                 }
                 $sth->finish;
                 print LOG "End of query 3\n";
                 print LOG "Starting query 4\n";

                 $bravo_connection->prepareSqlQuery('Recon duplicate 4', $RECON_QUEUE_DUPLICATE_CHECK_4);
                 $sth = $bravo_connection->sql->{'Recon duplicate 4'};
                 $sth->execute();
                 while (@Duplicate = $sth->fetchrow_array()){
                   push @NumbersOfDuplicates, $Duplicate[0];  
                 }
                 $sth->finish;
                 print LOG "End of query 4\n";
                 print LOG "Starting query 5\n";

                 $bravo_connection->prepareSqlQuery('Recon duplicate 5', $RECON_QUEUE_DUPLICATE_CHECK_5);
                 $sth = $bravo_connection->sql->{'Recon duplicate 5'};
                 $sth->execute();
                 while (@Duplicate = $sth->fetchrow_array()){
                   push @NumbersOfDuplicates, $Duplicate[0];  
                 }
                 $sth->finish;
                 print LOG "End of query 5\n";
                 print LOG "Starting query 6\n";

                 $bravo_connection->prepareSqlQuery('Recon duplicate 6', $RECON_QUEUE_DUPLICATE_CHECK_6);
                 $sth = $bravo_connection->sql->{'Recon duplicate 6'};
                 $sth->execute();
                 while (@Duplicate = $sth->fetchrow_array()){
                   push @NumbersOfDuplicates, $Duplicate[0];  
                 }
                 $sth->finish;
                 print LOG "End of query 6\n";

                 my $i;
				 foreach $i(@NumbersOfDuplicates) {
			       if($i > 0) {
                     print LOG "Duplicates in queues found\n" ;
                     $FlagDuplicatesExist = $TRUE ;
                   }
                 }

                 my @NumbersOfDuplicates2;

                 if($FlagDuplicatesExist){
                   if($AllowSelfHealingExecution){
					    print LOG "Invoking SHE to remove duplicate recon queues.\n";
  						my $CmdExecResult = system($executeSelfHealingEngine);
                        if($CmdExecResult == 0){
					      print LOG "SHE command to remove duplicates in recond queues was SUCCESSFUL.\n";
					      print LOG "Checking duplicates again.\n";

     		              print LOG "Starting query 1\n";
                          $bravo_connection->prepareSqlQuery('After Recon duplicate 1', $RECON_QUEUE_DUPLICATE_CHECK_1);
                          my $sth = $bravo_connection->sql->{'After Recon duplicate 1'};
                          $sth->execute();
                          while (@Duplicate = $sth->fetchrow_array()){
                            push @NumbersOfDuplicates2, $Duplicate[0];  
                          }
                          $sth->finish;
		                  print LOG "End of query 1\n";
     		              print LOG "Starting query 2\n";

                          $bravo_connection->prepareSqlQuery('After Recon duplicate 2', $RECON_QUEUE_DUPLICATE_CHECK_2);
                          $sth = $bravo_connection->sql->{'After Recon duplicate 2'};
                          $sth->execute();
                          while (@Duplicate = $sth->fetchrow_array()){
                            push @NumbersOfDuplicates2, $Duplicate[0];  
                          }
                          $sth->finish;
		                  print LOG "End of query 2\n";
     		              print LOG "Starting query 3\n";

                          $bravo_connection->prepareSqlQuery('After Recon duplicate 3', $RECON_QUEUE_DUPLICATE_CHECK_3);
                          $sth = $bravo_connection->sql->{'After Recon duplicate 3'};
                          $sth->execute();
                          while (@Duplicate = $sth->fetchrow_array()){
                            push @NumbersOfDuplicates2, $Duplicate[0];  
                          }
                          $sth->finish;

		                  print LOG "End of query 3\n";
     		              print LOG "Starting query 4\n";
                          $bravo_connection->prepareSqlQuery('After Recon duplicate 4', $RECON_QUEUE_DUPLICATE_CHECK_4);
                          $sth = $bravo_connection->sql->{'After Recon duplicate 4'};
                          $sth->execute();
                          while (@Duplicate = $sth->fetchrow_array()){
                            push @NumbersOfDuplicates2, $Duplicate[0];  
                          }
                          $sth->finish;

		                  print LOG "End of query 4\n";
     		              print LOG "Starting query 5\n";
                          $bravo_connection->prepareSqlQuery('After Recon duplicate 5', $RECON_QUEUE_DUPLICATE_CHECK_5);
                          $sth = $bravo_connection->sql->{'After Recon duplicate 5'};
                          $sth->execute();
                          while (@Duplicate = $sth->fetchrow_array()){
                            push @NumbersOfDuplicates2, $Duplicate[0];  
                          }
                          $sth->finish;

		                  print LOG "End of query 5\n";
     		              print LOG "Starting query 6\n";
                          $bravo_connection->prepareSqlQuery('After Recon duplicate 6', $RECON_QUEUE_DUPLICATE_CHECK_6);
                          $sth = $bravo_connection->sql->{'After Recon duplicate 6'};
                          $sth->execute();
                          while (@Duplicate = $sth->fetchrow_array()){
                            push @NumbersOfDuplicates2, $Duplicate[0];  
                          }
                          $sth->finish;
		                  print LOG "End of query 6\n";
                 
                 
					    }#end if($restartWebAppCmdExecResult == 0)
					    else{
					      print LOG "SHE command to remove duplicates in recond queues FAILED\n";
                          $FlagSHEError = $TRUE ;
					    }#end else	
                   }else{
					 print LOG "There are duplicates in recon queue, but we are forbidden to run SHE to fix it.\n";
                   }

                 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 print LOG "[$currentTimeStamp]$DB_EXCEPTION_MESSAGE: $@ happened for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName}.\n"; 

				 $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			     $emailFullContent.="$EVENT_RULE_TITLE_TXT: $MessageTitle\n";#append event rule title into email content
         		 $emailFullContent.="$EVENT_RULE_HANDLING_INSTRUCTION_CODE_TXT: $metaRuleHandlingInstrcutionCode\n";

                 my $DuplicatesInfoMessageTmp = $DuplicatesInfoMessage;
                 $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates[0]/g;
                 $DuplicatesInfoMessageTmp =~ s/\@3/SW LPAR/g;
                 $DuplicatesInfoMessageTmp =~ s/\@4/RECON_SW_LPAR/g;
				 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

                 $DuplicatesInfoMessageTmp = $DuplicatesInfoMessage;
                 $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates[1]/g;
                 $DuplicatesInfoMessageTmp =~ s/\@3/HW LPAR/g;
                 $DuplicatesInfoMessageTmp =~ s/\@4/RECON_HW_LPAR/g;
				 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

                 $DuplicatesInfoMessageTmp = $DuplicatesInfoMessage;
                 $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates[2]/g;
                 $DuplicatesInfoMessageTmp =~ s/\@3/LICENSE/g;
                 $DuplicatesInfoMessageTmp =~ s/\@4/RECON_LICENSE/g;
				 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

                 $DuplicatesInfoMessageTmp = $DuplicatesInfoMessage;
                 $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates[3]/g;
                 $DuplicatesInfoMessageTmp =~ s/\@3/HW/g;
                 $DuplicatesInfoMessageTmp =~ s/\@4/RECON_HARDWARE/g;
				 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

                 $DuplicatesInfoMessageTmp = $DuplicatesInfoMessage;
                 $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates[4]/g;
                 $DuplicatesInfoMessageTmp =~ s/\@3/CUSTOMER/g;
                 $DuplicatesInfoMessageTmp =~ s/\@4/RECON_CUSTOMER/g;
				 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

                 $DuplicatesInfoMessageTmp = $DuplicatesInfoMessage;
                 $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates[5]/g;
                 $DuplicatesInfoMessageTmp =~ s/\@3/INSTALLED SW/g;
                 $DuplicatesInfoMessageTmp =~ s/\@4/RECON_INSTALLED_SW/g;
				 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

                 my $mail_line;
                 if($FlagSHEError == $TRUE){
                   $mail_line = $FailedMessage;
                   $mail_line =~ s/\@5/'SHE failed during recon queues cleanup'/g;
				 }else{
                   $mail_line = $SuccesMessage;
				 }
                 $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $mail_line\n";
                   
				   if($FlagSHEError == $FALSE){
					   $DuplicatesInfoMessageTmp = $DuplicatesInfoMessageAfterCleanup;
					   $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates2[0]/g;
					   $DuplicatesInfoMessageTmp =~ s/\@3/SW LPAR/g;
					   $DuplicatesInfoMessageTmp =~ s/\@4/RECON_SW_LPAR/g;
					   $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content
			
					   $DuplicatesInfoMessageTmp = $DuplicatesInfoMessageAfterCleanup;
					   $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates2[1]/g;
					   $DuplicatesInfoMessageTmp =~ s/\@3/HW LPAR/g;
					   $DuplicatesInfoMessageTmp =~ s/\@4/RECON_HW_LPAR/g;
					   $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content
					   
					   $DuplicatesInfoMessageTmp = $DuplicatesInfoMessageAfterCleanup;
					   $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates2[2]/g;
					   $DuplicatesInfoMessageTmp =~ s/\@3/LICENSE/g;
					   $DuplicatesInfoMessageTmp =~ s/\@4/RECON_LICENSE/g;
					   $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content
						
					   $DuplicatesInfoMessageTmp = $DuplicatesInfoMessageAfterCleanup;
					   $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates2[3]/g;
					   $DuplicatesInfoMessageTmp =~ s/\@3/HW/g;
					   $DuplicatesInfoMessageTmp =~ s/\@4/RECON_HARDWARE/g;
					   $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content
			
					   $DuplicatesInfoMessageTmp = $DuplicatesInfoMessageAfterCleanup;
					   $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates2[4]/g;
					   $DuplicatesInfoMessageTmp =~ s/\@3/CUSTOMER/g;
					   $DuplicatesInfoMessageTmp =~ s/\@4/RECON_CUSTOMER/g;
					   $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content

					   $DuplicatesInfoMessageTmp = $DuplicatesInfoMessageAfterCleanup;
					   $DuplicatesInfoMessageTmp =~ s/\@2/$NumbersOfDuplicates2[5]/g;
					   $DuplicatesInfoMessageTmp =~ s/\@3/INSTALLED SW/g;
					   $DuplicatesInfoMessageTmp =~ s/\@4/RECON_INSTALLED_SW/g;
					   $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $DuplicatesInfoMessageTmp\n";#append event rule message into email content
				   }#end if($FlagSHEError == $FALSE)
				   
				   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				 }
			 }
                 #Added by Tomas for HealthCheck And Monitoring Service Component - Phase 10 End
			 elsif($triggerEventValue > $metaRuleParameter1){#Default Rule Check Logic Here
                 my $processedRuleMessage = $metaRuleMessage;#set the defined meta rule message to processedRuleMessage var
			     
				 $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
			     $emailFullContent.="$EVENT_RULE_TITLE_TXT: $metaRuleTitle\n";#append event rule title into email content
			     #Replace @1 param using Event Value and @2 param using Event Time for email content
		         $processedRuleMessage =~ s/\@1/$triggerEventValue/g;
                 $eventFiredTime = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 $processedRuleMessage =~ s/\@2/$eventFiredTime/g;
			     $emailFullContent.="$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";#append event rule message into email content
				 $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
				 print LOG "$EVENT_RULE_TITLE_TXT: $metaRuleTitle\n";
				 print LOG "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";
                 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $metaRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
			 }
			 #A piece of code template which is used for 'New Event Group' + 'New Event Type' business logic
			 #elsif($triggerEventGroup eq "SAMPLE_GROUP_NAME" && $triggerEventName eq "SAMPLE_EVENT_NAME"){#Event Group: "SAMPLE_GROUP_NAME" + Event Type: "SAMPLE_EVENT_NAME"
			 #Add 'New Event Group' + 'New Event Type' business logic here 
			 #}
			 ############THE ABOVE PIECE OF CODE IS THE RULE CORE BUSINESS LOGIC!!!!!!################################
          }#end of judge if equals
       }#end of metaRule foreach
}

#This core method is used to send email to corresponding persons based on certain defined business parameters and rules
sub sendEmail{
  my ($emailSubject,$toEmailAddress,$ccEmailAddress,$emailContent) = @_;
  #system("echo \"$emailContent\" | mail -s \"$emailSubject\" -c \"$ccEmailAddress\" \"$toEmailAddress\"");#For Email CC Address List Function, It doesn't work.
  system("echo \"$emailContent\" | mail -s \"$emailSubject\" \"$toEmailAddress\"");
  $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
  print LOG "[$currentTimeStamp]HealthCheck and Monitor Email with subject \"$emailSubject\" has been sent to users \"$toEmailAddress\" successfully.\n";
}

#This method is used to generate the certain format time value
sub getTime
{
    #The function time() returns the amount of accumulate second from 1/1/1970
    my $time = shift || time();
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
    
    $mon ++;
    $sec  = ($sec<10)?"0$sec":$sec;#Second[0,59]
    $min  = ($min<10)?"0$min":$min;#minitue[0,59]
    $hour = ($hour<10)?"0$hour":$hour;#Hour[0,23]
    $mday = ($mday<10)?"0$mday":$mday;#Day[1,31]
    $mon  = ($mon<9)?"0$mon":$mon;#Month[0,11]
    $year+=1900;#From 1900 year
    
    #$wday is accumulated from Saturday, stands for which day of one week[0-6]
    #$yday is accumulated from 1/1£¬stands for which day of one year[0,364]
    #$isdst is a flag
    my $weekday = ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')[$wday];#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9
    return { 'second' => $sec,
             'minute' => $min,
             'hour'   => $hour,
             'day'    => $mday,
             'month'  => $mon,
             'year'   => $year,
             'weekNo' => $wday,
             'wday'   => $weekday,
             'yday'   => $yday,
             'date'   => "$year$mon$mday",
		     'fullTime1' => "$year-$mon-$mday-$hour.$min.$sec",
             'fullTime2' => "$year$mon$mday$hour$min$sec"
          };
}

#This sub trim() method is used to remove before and after space chars of a string
sub trim
{  
   my $trimString = shift;
   if(!defined $trimString)
   {
     $trimString = "";
   }
  
   $trimString =~s/^\s+//;
   $trimString =~s/\s+$//;
   return $trimString;
}

#This method is used to get current timestamp value
sub getCurrentTimeStamp{
   my $timeStampStyle = shift;
   my $dateObject = &getTime();#Get the hash address of current system time object
   my $currentTimeStamp;
   if($timeStampStyle == $STYLE1){#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
      $currentTimeStamp = $dateObject->{fullTime1};
   }
   elsif($timeStampStyle == $STYLE2){#YYYYMMDDHHMMSS For Example: 20130418103033
      $currentTimeStamp = $dateObject->{fullTime2};
   }
   
   return $currentTimeStamp;
}

#This method is used to start process
sub loaderStart{

	###Set usage message.
    my $baseName = basename($0);
    my $msg = "Usage: $baseName [run-once|start|stop]\n";

    ###Check action argument was passed by user.
    my $action = shift;
    die $msg if ( !defined $action || $action =~ m/^\s+$/ );
   
    ###Check pid file argument.
    my $pidFile = shift;
    die "ERROR: Must pass pidFile arg to loaderStart sub!!\n"
        if ( !defined $pidFile || $pidFile =~ m/^\s+$/ );
 
    ###Handle action.
    if (   $action eq "run-once"
        || $action eq "start" )
    {

        ###Make sure not already running.
        if ( -e "$pidFile" ){

            ###Check pid is running.
            my $pid;
            open( PIDFILE, "<$pidFile" )
                or die "ERROR: Unable to read pid file $pidFile: $!";
            while (<PIDFILE>) {
                chomp;
                next unless /^pid=/;
                $pid = ( split(/\=/) )[1];
            }
            close(PIDFILE);
            die "ERROR: Unable to get pid from pid file $pidFile!!\n"
                unless defined $pid;

            if ( -e "/proc/$pid" ){

                ###Already running.
                print "$pid for Loader $baseName is already running.\n";
                exit 0;
            }

            ###Not running, remove pid file.
            unlink "$pidFile";
        }

        ###Create pid file.
        open( PIDFILE, ">$pidFile" )
            or die "ERROR: Unable to write pid file $pidFile: $!";
        print PIDFILE "pid=$$\n";
        print PIDFILE "STOP\n"
            if $action eq "run-once";
        close(PIDFILE);
    }
    elsif ( $action eq "stop" ){

        ###Respond to user based on pid file existance.
        if ( -e "$pidFile" ){

            ###Check pid is running.
            my $pid;
            open( PIDFILE, "<$pidFile" )
                or die "ERROR: Unable to read pid file $pidFile: $!";
            while (<PIDFILE>) {
                chomp;
                next unless /^pid=/;
                $pid = ( split(/\=/) )[1];
            }
            close(PIDFILE);
            die "ERROR: Unable to get pid from pid file $pidFile!!\n"
                unless defined $pid;

            if ( !-e "/proc/$pid" ){#process is not running

                ###Not running, remove pid file.
                print "Loader $baseName is not currently running.\n";
                unlink "$pidFile";
                exit 0;
            }
			else{#process is running
			  my $optFlag = system("kill $pid");
			  if($optFlag==0){
			    print "Loader $baseName has been stopped succesfully.\n";
				
				###Flag pid file for stop.
				open( PIDFILE, ">>$pidFile" ) or die "ERROR: Unable to append to pid file $pidFile: $!";
				print PIDFILE "STOP\n";
				close(PIDFILE);
				#print "Alterted loader to stop after current load, "
                #. "please wait for process to stop gracefully.\n";
			  }
			  else{
			    print "Loader $baseName has been stopped failed.\n";
			  }
			}
            exit 0;
        }
        else {
            print "Loader $baseName is not currently running.\n";
            exit 0;
        }
    }
    else {
        die $msg;
    }
}

#This method is used to set DB2 ENV path
sub setDB2ENVPath{
    if($SERVER_MODE eq $TAP){#TAP Server
      $DB_ENV = '/db2/tap/sqllib/db2profile';
    }
	elsif($SERVER_MODE eq $TAP2){#TAP2 Server
	  $DB_ENV = '/home/tap/sqllib/db2profile';
	}
    elsif($SERVER_MODE eq $TAP3){#TAP3 Server
	  $DB_ENV = '/home/eaadmin/sqllib/db2profile';
	}
	elsif($SERVER_MODE eq $TAPMF){#TAPMF Server
	  $DB_ENV = '/db2/cndb/sqllib/db2profile'; 
	}
	#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
    elsif($SERVER_MODE eq $BRAVO){#BRAVO Server
	  $DB_ENV = '/home/eaadmin/sqllib/db2profile';
	}
	elsif($SERVER_MODE eq $TRAILS){#TRAILS Server
	  $DB_ENV = '/home/eaadmin/sqllib/db2profile';
	}
	#Added by Larry for HealthCheck And Monitor Module - Phase 3 End
}

#This method is used to setup DB2 into System ENV var
sub setupDB2Env {
    die "ERROR: Unable to setup DB2 env !!"
        unless -e "$DB_ENV";
    my @elements = `. $DB_ENV; env`;
    foreach my $elem (@elements) {
        chomp $elem;
        my ($elementKey,$elementVal) = split(/=/, $elem);
        next unless defined($elementKey);
        $ENV{"$elementKey"} = "$elementVal";
    }
    return 1;
}

#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
#This method is used to append start and stop script email alerts into email content
sub appendStartAndStopScriptEmailAlertsIntoEmailContent{
   my $startAndStopScriptEmailAlertsMessageCount = scalar(@startAndStopScriptsEmailAlertArray);
   my $countIndex = 0; 
   if($startAndStopScriptEmailAlertsMessageCount > 0){#append email content if has start and stop script email alert message
       $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
       foreach my $startAndStopScriptEmailAlertMessage (@startAndStopScriptsEmailAlertArray){#go loop for start and stop script email alert message
         $countIndex++;
	     if($countIndex==$startAndStopScriptEmailAlertsMessageCount){
	       my $startAndStopScriptEmailAlertMessageTemp = substr($startAndStopScriptEmailAlertMessage,0,length($startAndStopScriptEmailAlertMessage)-1);#remove the last return line char '\n'
	       $emailFullContent.="$startAndStopScriptEmailAlertMessageTemp";#append start and stop script email alert message into email content   
	     }
	     else{
	       $emailFullContent.="$startAndStopScriptEmailAlertMessage";#append start and stop script email alert message into email content
	     }
       }
       $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
   }
}
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
#This method is used to append alert email signature into the end of email content
sub appendAlertEmailSignatureIntoEmailContent{
   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
   $emailFullContent.="The following are some very useful Resource Links:\n";
   $emailFullContent.="Error/Warning Event Instruction Codes Mapping List Wiki Link:\n";
   $emailFullContent.="https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/Asset%20Management%20Support/page/Error%20or%20Warning%20Event%20Instruction%20Codes%20Mapping%20List\n\n";
   $emailFullContent.="Filesystem Monitoring Threshold Definition List Wiki Link:\n";
   $emailFullContent.="https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/Asset%20Management%20Support/page/Filesystem%20Monitoring\n";
   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
}
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 Start
#This method is used to append server normal running information into email content
sub appendServerNormalRunningInfoIntoEmailContent{
   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
   $emailFullContent.="The Health Condition of $SERVER_MODE server is perfect! There is no alert message generated for it.\n";
   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
}
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 4 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 Start
#my $GET_EVENT_DATA_FOR_CERTAIN_TIME_SQL = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG WHERE EG.NAME = ? AND ET.NAME = ? AND E.EVENT_ID = ET.EVENT_ID AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID AND E.RECORD_TIME >= CURRENT TIMESTAMP - #1 HOURS AND E.RECORD_TIME <= CURRENT TIMESTAMP ORDER BY E.RECORD_TIME DESC WITH UR";# #1 parameter is used to replace with job cron number
sub getEventDataForCertainTimeFunction{
  my ($connection, $eventGroup, $eventName, $querySQL) = @_;
  my @eventRows = ();
  my @eventRow;
  $connection->prepareSqlQuery(queryEventDataForCertainTime($querySQL));
  my $sth = $connection->sql->{eventDataForCertainTimeSQL};

  $sth->execute($eventGroup,$eventName);
  while (@eventRow = $sth->fetchrow_array()){
     push @eventRows, [@eventRow];  
  }
  $sth->finish;
  return @eventRows;
}

sub queryEventDataForCertainTime{
  my $query = shift;
  print LOG "[queryEventDataForCertainTime] Query SQL: {$query}\n";
  return ('eventDataForCertainTimeSQL', $query);
}

#my $GET_CNDB_CUSTOMER_TME_OBJECT_ID_SQL = "SELECT ACCOUNT_NUMBER, TME_OBJECT_ID FROM CUSTOMER WHERE TME_OBJECT_ID LIKE '%#1%'";# #1 parameter is used to replace with searching key for example: 'DEFAULT'
sub getCNDBCustomerTMEObjectIDFunction{
  my ($connection, $querySQL) = @_;
  my @customerRows = ();
  my @customerRow;
  $connection->prepareSqlQuery(queryCNDBCustomerTMEObjectID($querySQL));
  my $sth = $connection->sql->{cndbCustomerTMEObjectIDSQL};

  $sth->execute();
  while (@customerRow = $sth->fetchrow_array()){
     push @customerRows, [@customerRow];  
  }
  $sth->finish;
  return @customerRows;
}

sub queryCNDBCustomerTMEObjectID{
  my $query = shift;
  print LOG "[queryCNDBCustomerTMEObjectID] Query SQL: {$query}\n";
  return ('cndbCustomerTMEObjectIDSQL', $query);
}

#my $GET_TRAILSRP_DB_APPLY_GAP_SQL = "SELECT DISTINCT CURRENT TIMESTAMP, SYNCHTIME, ((DAYS(CURRENT TIMESTAMP) - DAYS(SYNCHTIME)) * 86400 + (MIDNIGHT_SECONDS(CURRENT TIMESTAMP) - MIDNIGHT_SECONDS(SYNCHTIME))) FROM ASN.IBMSNAP_SUBS_SET";
sub getTrailsRPDBApplyGapFunction{
  my $connection = shift;
  my @trailsRPDBApplyGapRow;
  $connection->prepareSqlQuery(queryTrailsRPDBApplyGap());
  my $sth = $connection->sql->{trailsRPDBApplyGapSQL};

  $sth->execute();
  @trailsRPDBApplyGapRow = $sth->fetchrow_array();
  $sth->finish;
  return @trailsRPDBApplyGapRow;
}

sub queryTrailsRPDBApplyGap{
  print LOG "[queryTrailsRPDBApplyGap] Query SQL: {$GET_TRAILSRP_DB_APPLY_GAP_SQL}\n";
  return ('trailsRPDBApplyGapSQL', $GET_TRAILSRP_DB_APPLY_GAP_SQL);
}

#my $GET_EVENT_META_DATA_SQL = "SELECT EG.EVENT_GROUP_ID, EG.NAME, ET.EVENT_ID, ET.NAME FROM EVENT_GROUP EG, EVENT_TYPE ET WHERE EG.EVENT_GROUP_ID = ET.EVENT_GROUP_ID ORDER BY EG.EVENT_GROUP_ID, ET.EVENT_ID WITH UR";
sub getEventMetaDataFunction{
  my $connection = shift;
  my @eventMetaRecords = ();
  my @eventMetaRecord;
  $connection->prepareSqlQuery(queryEventMetaData());
  my $sth = $connection->sql->{eventMetaDataSQL};

  $sth->execute();
  while (@eventMetaRecord = $sth->fetchrow_array()){
     push @eventMetaRecords, [@eventMetaRecord];  
  }
  $sth->finish;
  return @eventMetaRecords;
}

sub queryEventMetaData{
  print LOG "[queryEventMetaData] Query SQL: {$GET_EVENT_META_DATA_SQL}\n";
  return ('eventMetaDataSQL', $GET_EVENT_META_DATA_SQL);
}
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 5 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 - Refacor the way of getting DB connection and executing SQL statements Start
#my $GET_EVENT_ALL_DATA_COUNT_SQL = "SELECT COUNT(*) FROM EVENT E JOIN EVENT_TYPE ET ON ET.EVENT_ID = E.EVENT_ID JOIN EVENT_GROUP EG ON EG.EVENT_GROUP_ID = ET.EVENT_GROUP_ID WHERE EG.NAME = ? AND ET.NAME = ? WITH UR";
sub getEventAllDataCountFunction{
  my $connection = shift;
  my $eventGroupName = shift;
  my $eventTypeName = shift;
  my @eventAllDataCountRow;
  my $eventAllDataCount;
  
  $connection->prepareSqlQuery(queryEventAllDataCount());
  my $sth = $connection->sql->{eventAllDataCountSQL};

  $sth->execute($eventGroupName,$eventTypeName);
  @eventAllDataCountRow = $sth->fetchrow_array();
  $eventAllDataCount = $eventAllDataCountRow[$EVENT_ALL_DATA_TOTAL_CNT_INDEX];  
  
  $sth->finish;
  return $eventAllDataCount;
}

sub queryEventAllDataCount{
  print LOG "[queryEventAllDataCount] Query SQL: {$GET_EVENT_ALL_DATA_COUNT_SQL}\n";
  return ('eventAllDataCountSQL', $GET_EVENT_ALL_DATA_COUNT_SQL);
}

#my $GET_EVENT_ALL_DATA_SQL = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG WHERE EG.NAME = ? AND ET.NAME = ? AND E.EVENT_ID = ET.EVENT_ID AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID ORDER BY E.RECORD_TIME DESC FETCH FIRST 100 ROWS ONLY WITH UR";
sub getEventAllDataFunction{
  my $connection = shift;
  my $eventGroupName = shift;
  my $eventTypeName = shift;
  my @eventAllDataRecords = ();
  my @eventAllDataRecord;
  
  $connection->prepareSqlQuery(queryEventAllData());
  my $sth = $connection->sql->{eventAllDataSQL};

  $sth->execute($eventGroupName,$eventTypeName);
  while (@eventAllDataRecord = $sth->fetchrow_array()){
     push @eventAllDataRecords, [@eventAllDataRecord];  
  }
  
  $sth->finish;
  return @eventAllDataRecords;
}

sub queryEventAllData{
  print LOG "[queryEventAllData] Query SQL: {$GET_EVENT_ALL_DATA_SQL}\n";
  return ('eventAllDataSQL', $GET_EVENT_ALL_DATA_SQL);
}
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 - Refacor the way of getting DB connection and executing SQL statements End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 Start
#The following method is used to compare the used disk percentage with the defined file system threshold
sub compareUsedDiskPctWithFileSystemThreshold{
   my $usedDiskPct = shift;
   my $fileSystemThreshold = shift;
   my $usedDiskPctValue;
   my $fileSystemThresholdValue;
   my $compareResultValue;
   
   $usedDiskPct = trim($usedDiskPct);#for example, 96%
   print LOG "The Used Disk Percentage: {$usedDiskPct}\n";
   $fileSystemThreshold = trim($fileSystemThreshold);#for example, 90%
   print LOG "The Defined File System Threshold: {$fileSystemThreshold}\n";
   
   $usedDiskPctValue = substr($usedDiskPct,0,length($usedDiskPct)-1);#for example, 96
   print LOG "The Used Disk Percentage Value: {$usedDiskPctValue}\n";
   
   $fileSystemThresholdValue = substr($fileSystemThreshold,0,length($fileSystemThreshold)-1);#for example, 90
   print LOG "The Defined File System Threshold Value: {$fileSystemThresholdValue}\n";

   if($usedDiskPctValue > $fileSystemThresholdValue){
      $compareResultValue = 1;
      print LOG "The Used Disk Percentage Value: {$usedDiskPctValue} > The Defined File System Threshold Value: {$fileSystemThresholdValue}. The Compare Result Return Value: {$compareResultValue}\n";
   }
   elsif($usedDiskPctValue == $fileSystemThresholdValue){
      $compareResultValue = 0;
      print LOG "The Used Disk Percentage Value: {$usedDiskPctValue} == The Defined File System Threshold Value: {$fileSystemThresholdValue}. The Compare Result Return Value: {$compareResultValue}\n";
   }
   elsif($usedDiskPctValue < $fileSystemThresholdValue){
      $compareResultValue = -1;
      print LOG "The Used Disk Percentage Value: {$usedDiskPctValue} < The Defined File System Threshold Value: {$fileSystemThresholdValue}. The Compare Result Return Value: {$compareResultValue}\n";
   }
  
   return $compareResultValue;
}
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 6 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 Start
#my $GET_TRAILSST_DB_APPLY_GAP_SQL = "SELECT DISTINCT CURRENT TIMESTAMP, SYNCHTIME, ((DAYS(CURRENT TIMESTAMP) - DAYS(SYNCHTIME)) * 86400 + (MIDNIGHT_SECONDS(CURRENT TIMESTAMP) - MIDNIGHT_SECONDS(SYNCHTIME))) FROM ASN.IBMSNAP_SUBS_SET";
sub getTrailsSTDBApplyGapFunction{
  my $connection = shift;
  my @trailsSTDBApplyGapRow;
  $connection->prepareSqlQuery(queryTrailsSTDBApplyGap());
  my $sth = $connection->sql->{trailsSTDBApplyGapSQL};

  $sth->execute();
  @trailsSTDBApplyGapRow = $sth->fetchrow_array();
  $sth->finish;
  return @trailsSTDBApplyGapRow;
}

sub queryTrailsSTDBApplyGap{
  print LOG "[queryTrailsSTDBApplyGap] Query SQL: {$GET_TRAILSST_DB_APPLY_GAP_SQL}\n";
  return ('trailsSTDBApplyGapSQL', $GET_TRAILSST_DB_APPLY_GAP_SQL);
}

#my $GET_TOTAL_RECORDS_IN_QUEUE_SQL = "SELECT COUNT(*) FROM V_RECON_QUEUE WITH UR";
sub getTotalRecordCountInQueueFunction{
  my $connection = shift;
  my @totalRecordCountRowInQueue;
  my $totalRecordCountInQueue;
  
  $connection->prepareSqlQuery(queryTotalRecordCountInQueue());
  my $sth = $connection->sql->{totalRecordCountInQueueSQL};

  $sth->execute();
  @totalRecordCountRowInQueue = $sth->fetchrow_array();
  $totalRecordCountInQueue = $totalRecordCountRowInQueue[$TOTAL_RECORDS_CNT_INDEX]; 
  $sth->finish;
  return $totalRecordCountInQueue;
}

sub queryTotalRecordCountInQueue{
  print LOG "[queryTotalRecordCountInQueue] Query SQL: {$GET_TOTAL_RECORDS_IN_QUEUE_SQL}\n";
  return ('totalRecordCountInQueueSQL', $GET_TOTAL_RECORDS_IN_QUEUE_SQL);
}

#my $GET_TOTAL_CUSTOMERS_IN_QUEUE_SQL = "SELECT COUNT(DISTINCT CUSTOMER_ID) FROM V_RECON_QUEUE WITH UR";
sub getTotalCustomerCountInQueueFunction{
  my $connection = shift;
  my @totalCustomerCountRowInQueue;
  my $totalCustomerCountInQueue;
  
  $connection->prepareSqlQuery(queryTotalCustomerCountInQueue());
  my $sth = $connection->sql->{totalCustomerCountInQueueSQL};

  $sth->execute();
  @totalCustomerCountRowInQueue = $sth->fetchrow_array();
  $totalCustomerCountInQueue = $totalCustomerCountRowInQueue[$TOTAL_CUSTOMERS_CNT_INDEX]; 
  $sth->finish;
  return $totalCustomerCountInQueue;
}

sub queryTotalCustomerCountInQueue{
  print LOG "[queryTotalCustomerCountInQueue] Query SQL: {$GET_TOTAL_CUSTOMERS_IN_QUEUE_SQL}\n";
  return ('totalCustomerCountInQueueSQL', $GET_TOTAL_CUSTOMERS_IN_QUEUE_SQL);
}

#This method is used to send HME startup error email 
sub sendHMEStartupErrorEmail{
  my ($emailSubject,$toEmailAddress,$emailContent) = @_;
  system("echo \"$emailContent\" | mail -s \"$emailSubject\" \"$toEmailAddress\"");
}
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 7 End

#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 Start
sub getCurrentWeekdayNumber{
 my $currentWeekday = shift;
 my $currentWeekdayNumber =-1;#default value = -1
 foreach my $weekdayKey(keys %WEEKDAY_HASH)  
 {  
	if($currentWeekday eq $weekdayKey){
      $currentWeekdayNumber=$WEEKDAY_HASH{$weekdayKey};
	}#end if($currentWeekday eq $weekdayKey) 
 }#end foreach my $weekdayKey(keys %WEEKDAY_HASH)
 return $currentWeekdayNumber;
}
#Added by Larry for HealthCheck And Monitoring Service Component - Phase 9 End
