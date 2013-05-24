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
# 

my $HOME_DIR = "/home/liuhaidl/working/scripts";#set Home Dir value
my $cdFlag = system('cd $HOME_DIR');
if($cdFlag!=0){
 die "Change Directory to $HOME_DIR failed. Exit to the current perl program.\n";
}
else{
 print "Change Directory to $HOME_DIR successfully.\n";
}

#Load required modules
use strict;
use POSIX;
use DBI;
use DBD::DB2;
use DBD::DB2::Constants;
use File::Basename;
use Base::ConfigManager;#Require the Staging Project Package
use Database::Connection;
use HealthCheck::OM::Event;
use HealthCheck::Delegate::EventLoaderDelegate;

#Globals
my $eventRuleDefinitionFile = "/home/liuhaidl/working/scripts/eventCheckRuleDefinition.properties";
my $healthCheckMonitorLogFile = "/home/liuhaidl/working/scripts/healthCheckMonitor.log";
my $pidFile    = "/home/liuhaidl/working/scripts/healthCheckMonitor.pid";
my $configFile = "/home/liuhaidl/working/scripts/healthCheckMonitor.properties";

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
my $trails_dbh;
my $trails_db_url;
my $trails_db_userid;
my $trails_db_password;
my $staging_dbh;
my $staging_db_url;
my $staging_db_userid;
my $staging_db_password;
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

#DB Handler Objects
my $getTotalRecordsInQueue;
my $getTotalCustomersInQueue;
my $getEventMetaData;
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
my $getEventDataForCertainTime;
my $getEventAllDataCnt;
my $getEventAllData;
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

#SQL Statements
my $GET_TOTAL_RECORDS_IN_QUEUE_SQL      = "SELECT COUNT(*) FROM V_RECON_QUEUE WITH UR";
my $GET_TOTAL_CUSTOMERS_IN_QUEUE_SQL    = "SELECT COUNT(DISTINCT CUSTOMER_ID) FROM V_RECON_QUEUE WITH UR";
my $GET_EVENT_META_DATA_SQL             = "SELECT EG.EVENT_GROUP_ID, EG.NAME, ET.EVENT_ID, ET.NAME FROM EVENT_GROUP EG, EVENT_TYPE ET WHERE EG.EVENT_GROUP_ID = ET.EVENT_GROUP_ID ORDER BY EG.EVENT_GROUP_ID, ET.EVENT_ID WITH UR";
#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
my $GET_EVENT_DATA_FOR_CERTAIN_TIME_SQL = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG WHERE EG.NAME = ? AND ET.NAME = ? AND E.EVENT_ID = ET.EVENT_ID AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID AND E.RECORD_TIME >= CURRENT TIMESTAMP - #1 HOURS AND E.RECORD_TIME <= CURRENT TIMESTAMP ORDER BY E.RECORD_TIME DESC WITH UR";# #1 parameter is used to replace with job cron number
my $GET_EVENT_ALL_DATA_COUNT_SQL = "SELECT COUNT(*) FROM EVENT E JOIN EVENT_TYPE ET ON ET.EVENT_ID = E.EVENT_ID JOIN EVENT_GROUP EG ON EG.EVENT_GROUP_ID = ET.EVENT_GROUP_ID WHERE EG.NAME = ? AND ET.NAME = ? WITH UR";
my $GET_EVENT_ALL_DATA_SQL = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG WHERE EG.NAME = ? AND ET.NAME = ? AND E.EVENT_ID = ET.EVENT_ID AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID ORDER BY E.RECORD_TIME DESC FETCH FIRST 100 ROWS ONLY WITH UR";#Added by Larry for HealthCheck And Monitor Module - Phase 2B: Optimize Event ALL Data Query SQL to get the first 100 row records from all row records
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

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
my $FILE_SYSTEM_MONITORING_EVENT_GROUP_ID          = 2;
my $FILE_SYSTEM_THRESHOLD_MONITORING_EVENT_TYPE_ID   = 7;
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End

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
    die $@;
}

exit 0;

#This method is used to do init operation 
sub init{
    #set db2 env path
    setDB2ENVPath();

    #setup db2 environment
    setupDB2Env();

    #set DB connection information
    setDBConnInfo();

    #connect to DB
	$trails_dbh = DBI->connect( "$trails_db_url", "$trails_db_userid", "$trails_db_password" ) || die "Trails connection failed with error: $DBI::errstr";
    $staging_dbh = DBI->connect( "$staging_db_url", "$staging_db_userid", "$staging_db_password" ) || die "Staging connection failed with error: $DBI::errstr";

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

	#Generate SQL Query Object
    #Get Total Records In Queue
    $getTotalRecordsInQueue = $trails_dbh->prepare($GET_TOTAL_RECORDS_IN_QUEUE_SQL);
    #Get Total Customers In Queue
    $getTotalCustomersInQueue = $trails_dbh->prepare($GET_TOTAL_CUSTOMERS_IN_QUEUE_SQL);
	#Get Event Meta Data
    $getEventMetaData = $staging_dbh->prepare($GET_EVENT_META_DATA_SQL);#Comment out temp for phase 2a1 without DB table created
	
    #Load Event Meta Data
    loadEventMetaData();

	#Load Event Rule And Email Information Definition
    loadEventRuleAndEmailInformationDefinition();
}

#This method is used to load event meta data
sub loadEventMetaData{
  #Comment out temp for phase 2a1 without DB table created start
  $getEventMetaData->execute();

  while(@row2 = $getEventMetaData->fetchrow_array()){
    my @eventMetaRecord;
    push @eventMetaRecord, $row2[$EVENT_GROUP_ID_INDEX];
    push @eventMetaRecord, $row2[$EVENT_GROUP_NAME_INDEX];
    push @eventMetaRecord, $row2[$EVENT_ID_INDEX];
    push @eventMetaRecord, $row2[$EVENT_NAME_INDEX];
  
  	push @eventMetaRecords, [@eventMetaRecord];
  }

  $getEventMetaData->finish;
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","1","CONTINUOUS_RUN_SCRIPTS")];
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","2","ATPTOSTAGING_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","3","SWCMTOSTAGING_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","4","MOVEMAINFRAME_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","5","BRAVOREPORTFORK_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("1","TRAILS_BRAVO_CORE_SCRIPTS","6","STAGINGMOVE_START_STOP_SCRIPT")];#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #push @eventMetaRecords, [("2","FILE_SYSTEM_MONITORING","7","FILE_SYSTEM_THRESHOLD_MONITORING")];#Added by Larry for HealthCheck And Monitor Module - Phase 3
  #Comment out temp for phase 2a1 without DB table created end
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
        
		#For testing purpose start
		if($loopIndex==3){
		  last;
		}
        #For testing purpose end
        
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
	$trails_dbh->disconnect();
	$staging_dbh->disconnect();
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
        sendAlertEmail($emailSubjectInfo,$emailToAddressList,$emailCcAddressList,$emailFullContent);
     }

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
	  #Get the total record number in the queue
	  $getTotalRecordsInQueue->execute();
	  @row = $getTotalRecordsInQueue->fetchrow_array();
	  $totalCnt = $row[$TOTAL_RECORDS_CNT_INDEX];
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
	  #Close DB handers
	  $getTotalRecordsInQueue->finish;
	  #Event Rule Check
	  eventRuleCheck($groupName,$eventName,$totalCnt);
   }
   elsif($groupName eq $RECON_ENGINE && $eventName eq $TOTAL_CUSTOMERS_IN_QUEUE){#Event Group: "RECON_ENGINE" + Event Type: "TOTAL_CUSTOMERS_IN_QUEUE"
      #Get the total customer number in the queue
      $getTotalCustomersInQueue->execute();
	  @row = $getTotalCustomersInQueue->fetchrow_array();
      $totalCnt = $row[$TOTAL_CUSTOMERS_CNT_INDEX];
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
      #Close DB handers
	  $getTotalCustomersInQueue->finish;
	  #Event Rule Check
	  eventRuleCheck($groupName,$eventName,$totalCnt);
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
	      $metaRuleCode = trim($metaRule->[$TRIGGERED_EVENT_GROUP_NAME_INDEX]);#Remove space chars
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

					chomp($returnProcessNum);;#remove the return line char
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
                  print LOG "Converted SQL: $getEventDataConvertedSQL\n";
				 
				  #Get Event Data For Certain Time
                  $getEventDataForCertainTime = $staging_dbh->prepare($getEventDataConvertedSQL);
	              $getEventDataForCertainTime->execute($triggerEventGroup,$triggerEventName);

				  while(my @row = $getEventDataForCertainTime->fetchrow_array()){
			          $eventRecordCnt++;
                      $loaderStatusCode = trim($row[$EVENT_VALUE_DATA_INDEX]);#Remove space chars for loader status code
					  if($loaderStatusCode eq $LOADER_ERRORED_STATUS_CODE#"ERRORED" Loader Status Code
					  &&($eventRecordCnt == 1)){#check if the first record
					     $loaderErrorFlag = 1;
                         $loaderErrorTime = $row[$EVENT_RECORD_TIME_DATA_INDEX];#get the loader error time
						 print LOG "{Error Time: $loaderErrorTime} for {Loader Name: $loaderName} has been found.\n";
					  }
				  }#end while(my @row = $getEventDataForCertainTime->fetchrow_array())
                  $getEventDataForCertainTime->finish;
                  
				  if($eventRecordCnt==0){#It means that the loader has not started yet
            
					  #Get the total count for certain event rule type 
					  $getEventAllDataCnt = $staging_dbh->prepare($GET_EVENT_ALL_DATA_COUNT_SQL);
                      $getEventAllDataCnt->execute($triggerEventGroup,$triggerEventName);
                      @totalCntRow = $getEventAllDataCnt->fetchrow_array();
					  $eventDataAllCnt = $totalCntRow[$EVENT_ALL_DATA_TOTAL_CNT_INDEX];
                      $getEventAllDataCnt->finish;
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
					      $getEventAllData = $staging_dbh->prepare($GET_EVENT_ALL_DATA_SQL);
                          $getEventAllData->execute($triggerEventGroup,$triggerEventName);
                          
						  while(my @eventRow = $getEventAllData->fetchrow_array()){
			                
							 $loaderStatusCode = trim($eventRow[$EVENT_VALUE_DATA_INDEX]);#Remove space chars for loader status code
							 print LOG "{Loader Status Code: $loaderStatusCode}\n";
                            
							 #Terminate the loop when the last successfully run start time and end time for loader have been found
                             if($startTimeForTheLastSuccessRunFindFlag && $endTimeForTheLastSuccessRunFindFlag){
							    print LOG "{Start Time For The Last Success Run: $startTimeForTheLastSuccessRun} + {End Time For The Last Success Run: $endTimeForTheLastSuccessRun} for {Loader Name: $loaderName} has been found.\n";
							    last;  
							 }
                         
							 if($loaderStatusCode eq $LOADER_STOPPED_STATUS_CODE){#"STOPPED" Loader Status Code
							    $endTimeForTheLastSuccessRunFindFlag = 1;
                                $endTimeForTheLastSuccessRun =  $eventRow[$EVENT_RECORD_TIME_DATA_INDEX];#get the last successfully run end time
							 }
                             elsif($loaderStatusCode eq $LOADER_STARTED_STATUS_CODE#"STARTED" Loader Status Code
							     &&($endTimeForTheLastSuccessRunFindFlag == 1)){#The "STOPPED" record has been found already   	
                                $startTimeForTheLastSuccessRunFindFlag = 1; 							   
                                $startTimeForTheLastSuccessRun =  $eventRow[$EVENT_RECORD_TIME_DATA_INDEX];#get the last successfully run start time 
                             }
							 else{
							    #Reset the last run start time and end time flags and values
							    $endTimeForTheLastSuccessRunFindFlag = 0;
							    $startTimeForTheLastSuccessRunFindFlag = 0;
                                $endTimeForTheLastSuccessRun = "";
                                $startTimeForTheLastSuccessRun = "";
							 }
                          }#end while(my @eventRow = $getEventAllData->fetchrow_array())
						  $getEventAllData->finish;
                          
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
				 my $monitorFileSystemList;#var used to store monitor file system list - for example: '/db2/cndb~95%'/db2/staging~95%'/db2/swasset~95%'/db2/tap~90%'/var/bravo~90%'/var/ftp~90%'/var/http_reports~90%'/var/staging~90%' 
                 my @monitorFileSystemListArray;#array used to store monitor file system list array
				 my $fileSystemDefinition;#var used to store one monitoring file system definition - for example: '/db2/cndb~95%'
				 my @fileSystemDefinitionArray;#array used to store the parsed file system definition- for ecxample: '(/db2/cndb,95%)'
				 my $fileSystem;#var used to store one monitoring file system - for example: '/db2/cndb'
				 my $threshold;#var used to store one monitoring file system threshold - for example: '95%'
                 my $usedPct;#var used to store the current used file system percentage - for example: 6%
				 my @fileSystemEmailAlertMessageArray = ();#array used to store the file system email alert messages
				 my $fileSystemEmailAlertMessageCount;#var used to store the count of the file system email alert messages

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
				 elsif($serverMode eq $metaRuleParameter7){#TAP3 Server
                    $monitorFileSystemList = $metaRuleParameter8;#TBD for TAP3
				 }
                 elsif($serverMode eq $metaRuleParameter9){#TAP2 Server
                    $monitorFileSystemList = $metaRuleParameter10;#TBD for TAP2
				 }

				 print LOG "File System Monitor Server Mode: {$serverMode}\n";
                 print LOG "File System Monitor List: {$monitorFileSystemList}\n";
                   
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

					  if($usedPct ge $threshold){#if the current used file system percentage >= file system defined threshold value, then trigger the event rule alert message
					     print LOG "The File System Used Percentage: {$usedPct} is great then or equal to the file system defined threshold value: {$threshold}\n";

						 $processedRuleMessage = $metaRuleMessage;
                         $processedRuleMessage =~ s/\@2/$usedPct/g;#replace @2 with the current used file system percentage value - for example: '98%'
                         $processedRuleMessage =~ s/\@3/$fileSystem/g;#replace @3 with the monitoring file system value - for example: '/db2/cndb'
                         $processedRuleMessage =~ s/\@4/$threshold/g;#replace @4 with the monitoring file system threshold value - for example: '95%' 

						 push @fileSystemEmailAlertMessageArray, "$EVENT_RULE_MESSAGE_TXT: $processedRuleMessage\n";
                         print LOG "The Processed Rule Message: {$processedRuleMessage}\n";
					  }
				   }
				   else{#the file system doesn't exist
				     print LOG "File System: {$fileSystem} doesn't exist for $serverMode server.\n";
				   }

                 }
				 
				 #append file system email alert messages into the email content
                 $fileSystemEmailAlertMessageCount = scalar(@fileSystemEmailAlertMessageArray);
                 if($fileSystemEmailAlertMessageCount > 0){#append email content if has file system email alert message
                    $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
                    foreach my $fileSystemEmailAlertMessage (@fileSystemEmailAlertMessageArray){#go loop for file system email alert message
	                   $emailFullContent.="$fileSystemEmailAlertMessage";#append file system email alert message into email content
                    }  
	                $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
                 }

                 $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
                 print LOG "[$currentTimeStamp]{Event Rule Code: $metaRuleCode} + {Event Rule Title: $processedRuleTitle} for {Event Group Name: $triggerEventGroup} + {Event Name: $triggerEventName} has been triggered.\n";
			 }
             #Added by Larry for HealthCheck And Monitor Module - Phase 3 End
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

#This core method is used to send alert emails to corresponding persons based on certain defined business parameters and rules
sub sendAlertEmail{
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
    my $weekday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];
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

#This method is used to set DB Connection Information
sub setDBConnInfo{
    if($SERVER_MODE eq $TAP){#TAP Server
       $trails_db_url      = "dbi:DB2:TRAILS";
       $trails_db_userid   = "eaadmin";
       $trails_db_password = "Green8ay";

	   $staging_db_url      = "dbi:DB2:STAGING";
       $staging_db_userid   = "eaadmin";
       $staging_db_password = "apr03db2"
    }
	elsif($SERVER_MODE eq $TAP2){#TAP2 Server
	   $trails_db_url      = "dbi:DB2:TRAILSPD";
       $trails_db_userid   = "eaadmin";
       $trails_db_password = "may2012a";

       $staging_db_url      = "dbi:DB2:STAGING";
       $staging_db_userid   = "eaadmin";
       $staging_db_password = "apr03db2"
	}
    elsif($SERVER_MODE eq $TAP3){#TAP3 Server
	   $trails_db_url      = "dbi:DB2:TRAILS";
       $trails_db_userid   = "eaadmin";
       $trails_db_password = "Green8ay";

	   $staging_db_url      = "dbi:DB2:STAGINGR";
       $staging_db_userid   = "eaadmin";
       $staging_db_password = "apr03db2"
	}
	elsif($SERVER_MODE eq $TAPMF){#TAPMF Server
	   #TBD
	   $trails_db_url      = "";
       $trails_db_userid   = "";
       $trails_db_password = "";

	   $staging_db_url      = "";
       $staging_db_userid   = "";
       $staging_db_password = ""
	}
	#Added by Larry for HealthCheck And Monitor Module - Phase 3 Start
	elsif($SERVER_MODE eq $BRAVO){#BRAVO Server
       $trails_db_url      = "dbi:DB2:TRAILS";
       $trails_db_userid   = "eaadmin";
       $trails_db_password = "Green8ay";

	   $staging_db_url      = "dbi:DB2:STAGING";
       $staging_db_userid   = "eaadmin";
       $staging_db_password = "apr03db2"
    }
	elsif($SERVER_MODE eq $TRAILS){#TRAILS Server
       $trails_db_url      = "dbi:DB2:TRAILS";
       $trails_db_userid   = "eaadmin";
       $trails_db_password = "Green8ay";

	   $staging_db_url      = "dbi:DB2:STAGING";
       $staging_db_userid   = "eaadmin";
       $staging_db_password = "apr03db2"
    }
	#Added by Larry for HealthCheck And Monitor Module - Phase 3 End
}

#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
#This method is used to append start and stop script email alerts into email content
sub appendStartAndStopScriptEmailAlertsIntoEmailContent{
   my $startAndStopScriptEmailAlertsMessageCount = scalar(@startAndStopScriptsEmailAlertArray);
   if($startAndStopScriptEmailAlertsMessageCount > 0){#append email content if has start and stop script email alert message
       $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n";#append seperate line into email content
       foreach my $startAndStopScriptEmailAlertMessage (@startAndStopScriptsEmailAlertArray){#go loop for start and stop script email alert message
	     $emailFullContent.="$startAndStopScriptEmailAlertMessage";#append start and stop script email alert message into email content
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
   $emailFullContent.="https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/Asset%20Management%20Support/page/Filesystem%20Monitoring\n\n";
   $emailFullContent.="----------------------------------------------------------------------------------------------------------------------------------------------------------\n\n";#append seperate line into email content
}
#Added by Larry for HealthCheck And Monitor Module - Phase 3 End