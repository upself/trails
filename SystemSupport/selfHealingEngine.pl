#!/usr/bin/perl -w
#
# This perl script is used to provide a Self Healing Engine Support Feature 
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     -------------------------------------------------------------------------------------------------------------------
# 2013-07-30  Liu Hai(Larry) 1.0.0           Design and implement the basic architecture for Self Healing Engine
# 2013-08-05  Liu Hai(Larry) 1.0.1           Add 'Database::Connection' Object to support Multi Databases
#                                            Add 'Update' business logic for 'OPERATION_QUEUE' DB Table
# 2013-08-08  Liu Hai(Larry) 1.0.2           Add Log Support Feature to generate a New Log File for every day
# 2013-08-15  Liu Hai(Larry) 1.0.3           Add 'RESTART_LOADER' Support Feature
# 2013-08-20  Liu Hai(Larry) 1.0.4           Remove 'RESTART_LOADER' Support Feature and Add 'RESTART_LOADER_ON_TAP_SERVER' and 'RESTART_LOADER_ON_TAP3_SERVER' Support Features
#                                            Add Configuration File named 'selfHealingEngine.properties' Feature for Server Mode parameter
# 2013-12-24  Liu Hai(Larry) 1.0.5           1) There is a bug found in the program. For Restart Loader on TAP Server Operation, there is no need to decrease 1 count like below:
#                                               #$targetLoaderRunningProcessCnt--;#decrease the unix command itself from the total calculated target loader running process count
#                                               Comment out the above code line to fix bug
#                                            2) Print out the restart loader process running message
# 2013-12-27  Liu Hai(Larry) 1.0.6           Add the following new loaders into authorized loader list:
#                                            1) atpToStaging.pl
# 2013-12-27  Liu Hai(Larry) 1.0.7           A. Add the following new loaders into authorized loader list:
#                                            1) swcmToStaging.pl
#                                            B. Add the loader running mode(start/run-once) support feature
# 2014-03-10  Liu Hai(Larry) 1.0.8           A. Add the following new loaders into authorized loader list:
#                                            1) capTypeToBravo.pl
# 2014-03-25  Liu Hai(Larry) 1.0.9           Add Post Check to judge if all the related loader processes have been killed fully and successfully, retry to kill all the related processes one time, 
#                                            if still cannot kill fully, then generates the error message
###################################################################################################################################################################################################
#                                            Phase 2 Development Formal Tag: 'Added by Larry for Self Healing Service Component - Phase 2'
# 2013-08-28  Liu Hai(Larry) 1.2.0           Self Healing Service Component - Phase 2: Restart Loader on TAP3 Server
# 2013-09-06  Liu Hai(Larry) 1.2.1           Self Healing Service Component - Phase 2: Add Post Check Support Feature to judge if the target loader has been restarted successfully or not
# 2013-09-30  Liu Hai(Larry) 1.2.2           Self Healing Service Component - Phase 2: For TAP3 Server, there is no root privilege granted. So the 'sudo' unix command needs to be used to get temp root privilege to execute special unix commands 
# 2014-03-26  Liu Hai(Larry) 1.2.3           Add Post Check to judge if all the related loader processes have been killed fully and successfully, retry to kill all the related processes one time, 
#                                            if still cannot kill fully, then generates the error message
###################################################################################################################################################################################################
#                                            Phase 3 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 3'
# 2013-10-14  Liu Hai(Larry) 1.3.0           System Support And Self Healing Service Components - Phase 3 - Operation Parameters Input String whatever Operation Parameters have values or not. The Operation Parameters String has included 10 values using ^ char to seperate. For example: TI30326-36768^reconEngine.pl^^^^^^^^
#                                            System Support And Self Healing Service Components - Phase 3 - Add 'RESTART_CHILD_LOADER_ON_TAP_SERVER' Support Feature
# 2013-11-18  Liu Hai(Larry) 1.3.2           Add the feature support when the input operation parameters have ' ' space chars in them - For example - "Test 2". 
#                                            There is a bug found when there are ' ' space chars in operation parameters, then there is a parse error for Self Healing Engine to get the input Operation Parameters
#                                            Solution: replace all the ' ' chars using '~' special chars for temp and then convert them back for Self Healing Engine 
# 2013-12-11  Liu Hai(Larry) 1.3.3           Change the -f value from 12 to 1 to support full load all the time for child loader
#                                            my $RESTART_CHILD_LOADER_INVOKED_COMMAND = "#1 -b #2 -f 1 -t 0 -d 1 -a 1 -l #3 -c #4";
#                                            Per Eugen, if 'Restart Child Loader on TAP Server' SSC feature has been used, it means that the full load for this child loader is needed.
#
###################################################################################################################################################################################################
#                                            Phase 4 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 4'
# 2013-11-08  Liu Hai(Larry) 1.4.0           System Support And Self Healing Service Components - Phase 4 - Add 'RESTART_IBMIHS_ON_TAP_SERVER' Support Feature 
###################################################################################################################################################################################################
#                                            Phase 5 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 5'
# 2013-11-20  Liu Hai(Larry) 1.5.0           System Support And Self Healing Service Components - Phase 5 - Add 'RESTART_BRAVO_WEB_APPLICATION' Support Feature  
#                                            System Support And Self Healing Service Components - Phase 5 - Add 'RESTART_TRAILS_WEB_APPLICATION' Support Feature
###################################################################################################################################################################################################
#                                            Phase 6 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 6'
# 2014-01-27  Liu Hai(Larry) 1.6.0           System Support And Self Healing Service Components - Phase 6 - Add 'STAGING_BRAVO_DATA_SYNC' Support Feature  
###################################################################################################################################################################################################
#                                            Phase 6A Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 6A'
# 2014-02-25  Liu Hai(Larry) 1.6.1           System Support And Self Healing Service Components - Phase 6A - Add GSA SSE Shared Log Folder Support Feature  
###################################################################################################################################################################################################
#                                            Phase 7 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 7'
# 2014-03-11  Liu Hai(Larry) 1.7.0           System Support And Self Healing Service Components - Phase 7 - Add 'ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE' Support Feature  
#
###################################################################################################################################################################################################
#                                            Phase 8 Development Formal Tag: 'Added by Tomas for System Support And Self Healing Service Components - Phase 8'
# 2014-03-11  Tomas Sima(Tomas) 1.8.0        System Support And Self Healing Service Components - Phase 8 - Add 'REMOVE_CERTAIN_BANK_ACCOUNT' Support Feature  
#

#Load required modules
use strict;
use DBI;
use Database::Connection;
use Base::ConfigManager;
use Net::Telnet;#Added by Larry for System Support And Self Healing Service Components - Phase 5
use Net::SCP::Expect;#Added by Larry for System Support And Self Healing Service Components - Phase 6A

#Globals
my $selfHealingEngineLogFile    = "/var/staging/logs/systemSupport/selfHealingEngine.log";
my $selfHealingEngineConfigFile = "/opt/staging/v2/config/selfHealingEngine.properties";

#SERVER MODE
my $TAP  = "TAP";#TAP Server for toStaging Loaders
my $TAP2 = "TAP2";#TAP2 Testing Server
my $TAP3 = "TAP3";#TAP3 Server for toBravo Loaders
my $SERVER_MODE;

my $SUDO_CMD_PREFIX        = "sudo";#Added by Larry for Self Healing Service Component - Phase 2
my $LOADER_EXISTING_PATH   = "/opt/staging/v2/";
my $LOADER_EXISTING_PATH_2 = "/opt/staging/v2";#Added by Larry for System Support And Self Healing Service Components - Phase 3
my $START_ALL_SHELL_NAME   = "start-all.sh";#Added by Larry for Self Healing Service Component - Phase 2

#Operation Status Code List
my $OPERATION_STATUS_ADDED_CODE       = "ADDED";
my $OPERATION_STATUS_PROGRESSING_CODE = "PROGRESSING";
my $OPERATION_STATUS_FAILED_CODE      = "FAILED";
my $OPERATION_STATUS_DONE_CODE        = "DONE";
#Self Healing Engine Parameter Definition Indexes
my $PARAMETER_OPERATOIN_ID_INDEX                      = 1;
my $PARAMETER_OPERATOIN_NAME_CODE_INDEX               = 2;
my $PARAMETER_OPERATOIN_MERGED_PARAMETERS_VALUE_INDEX = 3;
#SelfHealingEngine Inovked Modes
my $QUEUE_MODE   = "QUEUE_MODE";
my $COMMAND_MODE = "COMMAND_MODE";
#Statements for 'OPERATION_QUEUE.COMMENTS' column
my $PROGRESSING_COMMENTS = "This Operation is being progressed.";
my $FAILED_COMMENTS      = "This Operatoin is failed due to reason:<br>";
my $DONE_COMMENTS        = "This Operation has been finished successfully.";

#TIMESTAMP STYLE
my $STYLE1 = 1;#YYYY-MM-DD-HH.MM.SS For Example: 2013-06-18-10.30.33
my $STYLE2 = 2;#YYYYMMDDHHMMSS For Example: 20130618103033
my $STYLE3 = 3;#YYYYMMDD For Example: 20130618

#NO PARAMETER STRING
my $NO_PARAM = "NO_PARAM";

#Operation Code List
#Loader Group
my $RESTART_LOADER_ON_TAP_SERVER              = "RESTART_LOADER_ON_TAP_SERVER";
my $RESTART_LOADER_ON_TAP3_SERVER             = "RESTART_LOADER_ON_TAP3_SERVER";
my $RESTART_CHILD_LOADER_ON_TAP_SERVER        = "RESTART_CHILD_LOADER_ON_TAP_SERVER";#Added by Larry for System Support And Self Healing Service Components - Phase 3
#Database Group
my $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT = "DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT";
my $COMPOSITE_BUILDER                         = "COMPOSITE_BUILDER";
my $UPDATE_SW_LICENSES_STATUS                 = "UPDATE_SW_LICENSES_STATUS";
#Server Group
my $RESTART_IBMIHS_ON_TAP_SERVER              = "RESTART_IBMIHS_ON_TAP_SERVER";#Added by Larry for System Support And Self Healing Service Components - Phase 4
#Added by Larry for System Support And Self Healing Service Components - Phase 5 Start
#Application Group
my $RESTART_BRAVO_WEB_APPLICATION             = "RESTART_BRAVO_WEB_APPLICATION";
my $RESTART_TRAILS_WEB_APPLICATION            = "RESTART_TRAILS_WEB_APPLICATION";
#Added by Larry for System Support And Self Healing Service Components - Phase 5 End
#Added by Larry for System Support And Self Healing Service Components - Phase 6 Start
#Tool Group
my $STAGING_BRAVO_DATA_SYNC                               = "STAGING_BRAVO_DATA_SYNC";
#Added by Larry for System Support And Self Healing Service Components - Phase 6 End
my $ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE = "ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE";#Added by Larry for System Support And Self Healing Service Components - Phase 7
my $REMOVE_CERTAIN_BANK_ACCOUNT = "REMOVE_CERTAIN_BANK_ACCOUNT"; #Added by Tomas for System Support And Self Healing Service Components - Phase 8

#SQL Statement
my $UPDATE_CERTAIN_OPERATION_STATUS_SQL                = "UPDATE OPERATION_QUEUE SET OPERATION_STATUS = ?, OPERATION_UPDATE_TIME = CURRENT TIMESTAMP, COMMENTS = ? WHERE OPERATION_ID = ?";
my $GET_COUNT_NUMBER_FOR_CERTAIN_BANK_ACCOUNT_NAME_SQL = "SELECT COUNT(*) FROM BANK_ACCOUNT WHERE NAME = ? WITH UR";#Added by Larry for System Support And Self Healing Service Components - Phase 3

#Queue Invoke Mode Input Parameters Index
#Sample for Queue Invoke Mode
#/opt/staging/v2/selfHealingEngine.pl 1 RESTART_LOADER_ON_TAP_SERVER TI30326-36768^reconEngine.pl
my $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_ID_INDEX                      = 1;#For example: "1"
my $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_NAME_CODE_INDEX               = 2;#For example: "RESTART_LOADER_ON_TAP_SERVER"
my $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_MERGED_PARAMETERS_VALUE_INDEX = 3;#For example: "TI30326-36768^reconEngine.pl" or "reconEngine.pl"

#Command Invoke Mode Input Parameters Index
#Sample for Command Invoke Mode
#/opt/staging/v2/selfHealingEngine.pl RESTART_LOADER_ON_TAP_SERVER reconEngine.pl
my $COMMAND_INVOKE_MODE_INPUT_PARAMETER_OPERATION_NAME_CODE_INDEX               = 1;#For example: "RESTART_LOADER_ON_TAP_SERVER"
my $COMMAND_INVOKE_MODE_INPUT_PARAMETER_OPERATION_MERGED_PARAMETERS_VALUE_INDEX = 2;#For example: "reconEngine.pl"

#Operation Result Values
my $OPERATION_FAIL    = 0;
my $OPERATION_SUCCESS = 1;

my $FALSE = 0;
my $TRUE  = 1;

#Vars Definition
my $DB_ENV;
my $currentTimeStamp;
my $currentDate;
my $bravoConnection;
my $stagingConnection;

my $parameterOperationId                    = -1;#var used to store parameter Operation ID. Init default value is -1
my $parameterOperationNameCode              = "";#var used to store parameter Operation Name Code. Init default value is ""
my $parameterOperationMergedParametersValue = "";#var used to store parameter Operation Merged Parameters Value. Init default value is ""

my $selfHealingEngineInvokedMode;#var used to store selfHealingEngine Invoked Mode

#Config File
my $cfgMgr;
my $configServerMode;
my $configNonDebugLogPath;#Added by Larry for System Support And Self Healing Service Components - Phase 3

#Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
#Operation Parameter Indexes
my $OPERATION_PARAMETER_1_INDEX  = 0;
my $OPERATION_PARAMETER_2_INDEX  = 1;
my $OPERATION_PARAMETER_3_INDEX  = 2;
my $OPERATION_PARAMETER_4_INDEX  = 3;
my $OPERATION_PARAMETER_5_INDEX  = 4;
my $OPERATION_PARAMETER_6_INDEX  = 5;
my $OPERATION_PARAMETER_7_INDEX  = 6;
my $OPERATION_PARAMETER_8_INDEX  = 7;
my $OPERATION_PARAMETER_9_INDEX  = 8;
my $OPERATION_PARAMETER_10_INDEX = 9;

#'Restart Loader on TAP Server' Operation Parameter Definition Indexes
my $RESTART_LOADER_ON_TAP_SERVER_RELATED_TICKET_NUMBER_INDEX = 0;#Related Ticket Number(Optional) - For example: TI30620-56800
my $RESTART_LOADER_ON_TAP_SERVER_LOADER_NAME_INDEX           = 1;#Loader Name(Required) - For example: doranaToSwasset.pl

#'Restart Loader on TAP3 Server' Operation Parameter Definition Indexes
my $RESTART_LOADER_ON_TAP3_SERVER_RELATED_TICKET_NUMBER_INDEX = 0;#Related Ticket Number(Optional) - For example: TI30620-56800
my $RESTART_LOADER_ON_TAP3_SERVER_LOADER_NAME_INDEX           = 1;#Loader Name(Required) - For example: reconEngine.pl

#'Restart Child Loader on TAP Server' Operation Parameter Definition Indexes
my $RESTART_CHILD_LOADER_ON_TAP_SERVER_RELATED_TICKET_NUMBER_INDEX = 0;#Related Ticket Number(Optional) - For example: TI30620-56800
my $RESTART_CHILD_LOADER_ON_TAP_SERVER_CHILD_LOADER_NAME_INDEX     = 1;#Child Loader Name(Required) - For example: softwareFilterToStagingChild.pl
my $RESTART_CHILD_LOADER_ON_TAP_SERVER_BANK_ACCOUNT_NAME_INDEX     = 2;#Bank Account Name(Required) - For example: GTAASCCM
my $RESTART_CHILD_LOADER_ON_TAP_SERVER_DEBUG_OPTION_INDEX          = 3;#Debug Option(Required) - For example: YES or NO
my $RESTART_CHILD_LOADER_ON_TAP_SERVER_LOG_FILE_INDEX              = 4;#Log File(Optional) - For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM

my $RESTART_CHILD_LOADER_INVOKED_COMMAND = "#1 -b #2 -f 1 -t 0 -d 1 -a 1 -l #3 -c #4";#var used to store Restart Child Loader Invoked Command #Added by Larry for System Support And Self Healing Service Components - Phase 3 - 1.3.3
#Invoked Command Parameter Definition Indexes
my $INVOKED_COMMAND_RESTART_CHILD_LOADER_NAME_REPLACE_STRING = "#1";
my $INVOKED_COMMAND_RESTART_BANK_ACCOUNT_NAME_REPLACE_STRING = "#2";
my $INVOKED_COMMAND_RESTART_LOG_FILE_REPLACE_STRING          = "#3";
my $INVOKED_COMMAND_RESTART_CONFIG_FILE_REPLACE_STRING       = "#4";

my $LOADER_CONFIG_FILE_EXISTING_PATH = "/opt/staging/v2/config/";#var used to store Loader Configuration File Existing Path
my $REPLACED_STRING               = "Child.pl";
my $REPLACE_CONFIG_STRING         = "Config.txt";
my $REPLACE_DEBUG_CONFIG_STRING   = "ConfigDebug.txt";

my $DEBUG_OPTION_YES = "YES";
my $DEBUG_OPTION_NO  = "NO";

my $HOME_PATH = "/home";
my $BACKSLASH = "\\";
my $SLASH     = "/";
#Added by Larry for System Support And Self Healing Service Components - Phase 3 End

#Added by Larry for System Support And Self Healing Service Components - Phase 4 Start
#Business Unix Commands
my $CALCULATE_IBMIHS_RUNNING_COUNT     = "ps -ef |grep 'httpd -d'|grep -v grep|wc -l";
my $GET_IBMIHS_RUNNING_PROCESS_ID_LIST = "ps -ef |grep 'httpd -d'|grep -v grep|awk '{print \$2}'";
my $START_IBMIHS_SERVER_ON_TAP2_SERVER = "/opt/IBMIHS/bin/apachectl start"; 
my $START_IBMIHS_SERVER_ON_TAP_SERVER  = "/IHSV61/IBMIHS/bin/apachectl start";
#Added by Larry for System Support And Self Healing Service Components - Phase 4 End

#Added by Larry for System Support And Self Healing Service Components - Phase 5 Start
#Constants
#Execution Unix Commands
my $STOP_TOMCAT_FOR_BRAVO   = "sudo /sbin/service tomcat55_bravo stop";
my $START_TOMCAT_FOR_BRAVO  = "sudo /sbin/service tomcat55_bravo start";
my $STOP_TOMCAT_FOR_TRAILS  = "sudo /sbin/service tomcat55_trails stop";
my $START_TOMCAT_FOR_TRAILS = "sudo /sbin/service tomcat55_trails start";

#Target Web Application Host Server
my $TAPMF_HOST_SERVER  = "tapmf.boulder.ibm.com";
my $BRAVO_HOST_SERVER  = "bravo.boulder.ibm.com";
my $TRAILS_HOST_SERVER = "trails.boulder.ibm.com";
#Server Default Telnet Port
my $PORT = 23;

#Target Web Application Dump File Folder
my $TAPMF_DUMP_FILE_FOLDER = "/tmp";
my $BRAVO_DUMP_FILE_FOLDER = "/var/bravo/tmp";
my $TRAILS_DUMP_FILE_FOLDER = "/var/trails/tmp";

#Return Error Mode
my $RETURN_ERROR_MODE = "return";
#Return Message Match Strings
my $LOGIN = "/[l|L]ogin:/";
my $PASSWORD = "/[p|P]assword:/";
my $MATCH = "Match";
#General Prompt Pattern
my $PROMPT = '/[\?>] ?$|\? ?$|\$ ?$|[\?\>] ?$|\% +$|hp\)\s*$/';
my $SHELL_XTERM_TYPE = "xterm";

my $EXECUTE_SUCCESS_STRING = "done";
my $EXECUTE_SUCCESS = 1;
my $EXECUTE_FAIL    = 0;

#Command Monitor Timeout Time
my $COMMAND_MONITOR_TIMEOUT = 300;

#Telnet Related Files
my $TELNET_DUMP_FILE   = "/var/staging/logs/systemSupport/telnetRemoteBravoTrailsWebServerDump.log";
my $TELNET_OUTPUT_FILE= "/var/staging/logs/systemSupport/telnetRemoteBravoTrailsWebServerOutput.log";
my $TELNET_INPUT_FILE  = "/var/staging/logs/systemSupport/telnetRemoteBravoTrailsWebServerInput.log";
my $TELNET_OPTION_FILE = "/var/staging/logs/systemSupport/telnetRemoteBravoTrailsWebServerOption.log";

#Userids and Passwords used to logon the remote server using Telnet Mode
#TAPMF Web Application Testing Server
my $TAPMF_SERVER_USERID   = 'liuhaidl';
my $TAPMF_SERVRE_PASSWORD = 'abcd1256';
#Bravo Web Application PROD Server
my $BRAVO_SERVER_USERID   = 'asket';
my $BRAVO_SERVRE_PASSWORD = 'Zlivtom7';
#Trails Web Application PROD Server
my $TRAILS_SERVER_USERID   = 'liuhaidl';
my $TRAILS_SERVRE_PASSWORD = 'abcd1256';

#Vars
my $operationErrorFlag = $FALSE;#var used to store operation error flag(TRUE or FALSE)

#Move the following two vars from the local vars to global ones
my $operationResultFlag = $OPERATION_SUCCESS;#Set the init default value is "OPERATION_SUCCESS"
my $operationFailedComments = "";#var used to store operation comments 
#Added by Larry for System Support And Self Healing Service Components - Phase 5 End

#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7 Start
my $LOADER_START_MODE    = "start";
my $LOADER_RUN_ONCE_MODE = "run-once";
my $loaderRunningMode;#var used to store loader running mode - For example: "start/stop/run-once"
my $RUN_ONCE_LOADER_LIST = "/swcmToStaging.pl/";#var used to store run-once loader list - For example: "swcmToStaging.pl"
#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7 End

#Added by Larry for System Support And Self Healing Service Components - Phase 6 Start
#Staging Bravo Data SYNC Script Existing Path
my $STAGING_BRAVO_DATA_SYNC_SCRIPT_HOME_PATH           = "/opt/staging/v2/";
#Staging Bravo Data SYNC Script PATH Name
my $STAGING_BRAVO_DATA_SYNC_SCRIPT_PATH_NAME           = "./misc/stagingSyncGENAdvanceChild.pl";
#Staging Bravo Data SYNC Default Log Path
my $STAGING_BRAVO_DATA_SYNC_DEFAULT_LOG_PATH           = "/var/staging/logs/stagingSyncGENAdvance/";
#Staging Bravo Data SYNC Default Log Name Prefix
my $STAGING_BRAVO_DATA_SYNC_DEFAULT_LOG_NAME_PREFIX    = "stagingSyncGENAdvanceChild.log";
#Staging Bravo Data SYNC Script Marks
my $STAGING_BRAVO_DATA_SYNC_SCRIPT_ACCOUNT_NUMBER_MAKR = "-a";
my $STAGING_BRAVO_DATA_SYNC_SCRIPT_HOSTNAME_MAKR       = "-h";
my $STAGING_BRAVO_DATA_SYNC_SCRIPT_LOG_FILE_MAKR       = "-l";

my $GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_SQL = "SELECT COUNT(*) FROM CUSTOMER WHERE ACCOUNT_NUMBER = ? AND STATUS = 'ACTIVE' WITH UR";
my $GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_AND_HOSTNAME_SQL = "SELECT COUNT(*) FROM SOFTWARE_LPAR SL, CUSTOMER C WHERE C.ACCOUNT_NUMBER = ? AND SL.NAME = ? AND C.CUSTOMER_ID = SL.CUSTOMER_ID AND C.STATUS = 'ACTIVE' AND SL.STATUS ='ACTIVE' WITH UR";
#Added by Larry for System Support And Self Healing Service Components - Phase 6 End

#Added by Larry for System Support And Self Healing Service Components - Phase 6A Start
my $GSA_SERVER                           = "jpngsa.ibm.com";
my $GSA_LOG_SHARED_FOLDER_PATH           = "/gsa/jpngsa/projects/a/amsw/sse/logs";
my $GSA_WEB_HTTPS_LOG_SHARED_FOLDER_PATH = "https://jpngsa.ibm.com/projects/a/amsw/sse/logs";
my $GSA_USERID                           = "liuhaidl";
my $GSA_PASSWORD                         = "abcd1234";
#Added by Larry for System Support And Self Healing Service Components - Phase 6A End

#Added by Larry for System Support And Self Healing Service Components - Phase 7 Start
my %RECONTABLES = () ;
$RECONTABLES{'RECON_INSTALLED_SW'} = 1;
$RECONTABLES{'RECON_SW_LPAR'} = 2;
$RECONTABLES{'RECON_HW_LPAR'} = 3;
$RECONTABLES{'RECON_HARDWARE'} = 4;
$RECONTABLES{'RECON_SOFTWARE'} = 5;
$RECONTABLES{'RECON_CUSTOMER_SW'} = 6;
$RECONTABLES{'RECON_LICENSE'} = 7;

my $seINstSwbyId = "select b.customer_id,a.id from installed_software a,software_lpar b where a.software_lpar_id=b.id and a.id in (?) with ur";
my $seSWLparbyId = "select a.customer_id,a.id from software_lpar a where a.id in (?) with ur";
my $seHWLparbyId = "select a.customer_id,a.id from hardware_lpar a where a.id in (?) with ur";
my $seHWbyId =  "select a.customer_id,a.id from hardware a where a.id in (?) with ur";
my $seSWbyId =  "select a.id from SOFTWARE_ITEM a where a.id in (?) with ur";
my $seCSSWbyId =  "select a.customer_id,a.software_id from schedule_f a where a.id in (?) with ur";
my $seLicbyId =  "select a.customer_id,a.id from license a where a.id in (?) with ur";
my $isINstSwbyId = "INSERT INTO EAADMIN.recon_installed_sw (CUSTOMER_ID,INSTALLED_SOFTWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $isSWLparbyId = "INSERT INTO EAADMIN.recon_sw_lpar(CUSTOMER_ID,SOFTWARE_LPAR_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $isHWLparbyId = "INSERT INTO EAADMIN.recon_hw_lpar(CUSTOMER_ID,HARDWARE_LPAR_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $isHWbyId = "INSERT INTO EAADMIN.recon_hardware(CUSTOMER_ID,HARDWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $isSWbyId = "INSERT INTO EAADMIN.recon_software(SOFTWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values ( ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $isCSSWbyId = "INSERT INTO EAADMIN.recon_customer_sw(CUSTOMER_ID,SOFTWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $isLicbyId = "INSERT INTO EAADMIN.recon_license(CUSTOMER_ID,LICENSE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'Operation Support GUI',CURRENT TIMESTAMP)";
my $queryReINstSw = "SELECT * FROM recon_installed_sw WHERE  installed_software_id = ?";
my $queryReSWLpar = "SELECT * FROM recon_sw_lpar WHERE software_lpar_id = ?";
my $queryReHWLpar = "SELECT * FROM recon_hw_lpar WHERE hardware_lpar_id = ?";
my $queryReHW = "SELECT * FROM recon_hardware WHERE hardware_id = ?";
my $queryReSW = "SELECT * FROM recon_software WHERE software_id = ?";
my $queryReCSSW = "SELECT * FROM recon_customer_sw WHERE customer_id = ? and software_id = ? ";
my $queryReLic = "SELECT * FROM recon_license WHERE license_id = ?";
#Added by Larry for System Support And Self Healing Service Components - Phase 7 End

#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 Start
my $FAIL    = 0;
my $SUCCESS = 1;
my $HAS_CHILD_LOADER_LIST_ON_TAP_SERVER = "/hdiskToStaging.pl^ipAddressToStaging.pl^memModToStaging.pl^processorToStaging.pl^scanRecordToStaging.pl^softwareFilterToStaging.pl^softwareManualToStaging.pl^softwareSignatureToStaging.pl^softwareTlcmzToStaging.pl^softwareDoranaToStaging.pl^scanSoftwareItemToStaging.pl/";
my $LOADER_REPLACE_STRING  = ".pl";
my $LOADER_REPLACED_STRING = "Child.pl";
#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 End

#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 Start
my $HAS_CHILD_LOADER_LIST_ON_TAP3_SERVER = "/ipAddressToBravo.pl^memModToBravo.pl^hardwareToBravo.pl^hdiskToBravo.pl^processorToBravo.pl/";
#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 End

#Added by Tomas for System Support And Self Healing Service Components - Phase 8 - Start
my $BATCH_SIZE = 1000;
my $QUERY_ACCOUNT_ID_BY_NAME = "select ID from BANK_ACCOUNT where NAME = ? and CONNECTION_TYPE = ? and STATUS = 'ACTIVE'";
my $QUERY_DELETE_ACCOUNT_1 = "update hdisk hd set hd.action='DELETE' where hd.id in (select hhd.id from hdisk hhd join scan_record sr on hhd.scan_record_id=sr.id where sr.bank_account_id = ? and sr.action<>'DELETE' and hhd.action <> 'DELETE' fetch first $BATCH_SIZE row only);";
my $QUERY_DELETE_ACCOUNT_2 = "update ip_address ip set ip.action='DELETE' where ip.id in (select iip.id from ip_address iip join scan_record sr on iip.scan_record_id=sr.id where sr.bank_account_id = ? and sr.action<>'DELETE' and iip.action <> 'DELETE' fetch first $BATCH_SIZE row only);";
my $QUERY_DELETE_ACCOUNT_3 = "update mem_mod mm set mm.action='DELETE' where mm.id in (select mmm.id from mem_mod mmm join scan_record sr on mmm.scan_record_id=sr.id where sr.bank_account_id = ? and sr.action<>'DELETE' and mmm.action <> 'DELETE' fetch first $BATCH_SIZE row only);";
my $QUERY_DELETE_ACCOUNT_4 = "update processor ps set ps.action='DELETE' where ps.id in (select pps.id from processor pps join scan_record sr on pps.scan_record_id=sr.id where sr.bank_account_id = ? and sr.action<>'DELETE' and pps.action <> 'DELETE' fetch first $BATCH_SIZE row only);";
my $QUERY_DELETE_ACCOUNT_5 = "update software_signature s set s.action='DELETE' where s.id in (select ss.id from software_signature ss join scan_record sr on ss.scan_record_id=sr.id where sr.bank_account_id = ? and sr.action<>'DELETE' and ss.action <> 'DELETE' fetch first $BATCH_SIZE row only );";
my $QUERY_DELETE_ACCOUNT_6 = "update software_filter f set f.action='DELETE' where f.id in (select ft.id from software_filter ft join scan_record sr on ft.scan_record_id=sr.id where sr.bank_account_id = ? and sr.action<>'DELETE' and ft.action <> 'DELETE' fetch first $BATCH_SIZE row only ) ;";
my $QUERY_DELETE_ACCOUNT_7 = "update scan_record set action='DELETE' where bank_account_id = ? and action<>'DELETE';";
my $QUERY_DELETE_ACCOUNT_8 = "UPDATE BANK_ACCOUNT SET STATUS = 'INACTIVE', REMOTE_USER = 'Operation GUI', RECORD_TIME = CURRENT TIMESTAMP where name = ";
#Added by Tomas for System Support And Self Healing Service Components - Phase 8 - End

main();

#This is the main method of Self Healing Engine
sub main{
  init();
  process();
  postProcess();
}

#This method is used to do init operations
sub init{
  #Log File Operation
  $currentDate = getCurrentTimeStamp($STYLE3);#Get the current date using format YYYYMMDD
  $selfHealingEngineLogFile.= ".$currentDate";
  open LOG, ">>$selfHealingEngineLogFile";#Open Log File

  #Get the 'selfHealingEngine.properties' config object
  $cfgMgr   = Base::ConfigManager->instance($selfHealingEngineConfigFile);
  #Get the config Server Mode
  $configServerMode = trim($cfgMgr->server);
  print LOG "Config Server Mode: {$configServerMode}\n";
  #Set Server Mode Value from configuration file
  $SERVER_MODE  = $configServerMode;
  #Get the config Non Debug Log Path
  $configNonDebugLogPath = trim($cfgMgr->nonDebugLogPath);
  print LOG "Config Non Debug Log Path: {$configNonDebugLogPath}\n";
  
  #set db2 env path
  setDB2ENVPath();

  #Setup DB2 environment
  setupDB2Env();
  ###Get bravo db connection
  $bravoConnection = Database::Connection->new('trails');
  ###Get staging db connection
  $stagingConnection = Database::Connection->new('staging');
}

#This method is used to do Self Healing Engine Business Process
sub process{
  my $parameterCnt = scalar(@ARGV);
  my $loopIndex = 1;
  print LOG "The count of the selfHealingEngine input parameters: {$parameterCnt}\n";
  #If the count of input parameters is 3, it means that the invoked mode for SelfHealingEngine is 'Queue' mode.
  #Sample: /opt/staging/v2/selfHealingEngine.pl "1 RESTART_LOADER_ON_TAP_SERVER reconEngine.pl"
  #1. Input Operation ID Parameter = "1"
  #2. Input Operation Name Code Parameter = "RESTART_LOADER_ON_TAP_SERVER"
  #3. Input Operation Merged Parameter Values Parameter "reconEngine.pl"
  if($parameterCnt ==3){
    $selfHealingEngineInvokedMode = $QUEUE_MODE;#Queue Mode
	print LOG "The selfHealingEngine Invoke Mode is {$QUEUE_MODE}\n";
  }
  #If the count of input parameters is 2, it means that the invoked mode for SelfHealingEngine is 'Command' mode.
  #Sample: /opt/staging/v2/selfHealingEngine.pl "RESTART_LOADER_ON_TAP_SERVER reconEngine.pl"
  #1. Input Operation Name Code Parameter = "RESTART_LOADER_ON_TAP_SERVER"
  #2. Input Operation Merged Parameter Values Parameter "reconEngine.pl"
  else{
    $selfHealingEngineInvokedMode = $COMMAND_MODE;#Command Mode
	print LOG "The selfHealingEngine Invoke Mode is {$COMMAND_MODE}\n";
  }
 
 if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
    foreach my $parameter (@ARGV){
	  if($loopIndex == $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_ID_INDEX){#Parameter Operation ID - for example: "1"
	    $parameterOperationId = $parameter;
        print LOG "The input Operation ID parameter: {$parameterOperationId}\n";
      }
	  elsif($loopIndex == $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_NAME_CODE_INDEX){#Parameter Operation Name Code - for example: "RESTART_LOADER_ON_TAP_SERVER"
        $parameterOperationNameCode = $parameter;
        print LOG "The input Operation Name Code parameter: {$parameterOperationNameCode}\n";
	  }
	  elsif($loopIndex == $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_MERGED_PARAMETERS_VALUE_INDEX){#Parameter Operation Merged Parameters Value - for example: "reconEngine.pl"
        $parameterOperationMergedParametersValue = $parameter;
        print LOG "The input Operation Merged Parameters Value parameter: {$parameterOperationMergedParametersValue}\n";
		#Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
        $parameterOperationMergedParametersValue =~ s/\~/ /g;
	    print LOG "The converted input Operation Merged Parameters Value parameter: {$parameterOperationMergedParametersValue}\n";
        #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
	  }
      $loopIndex++; 
    }
  }
  elsif($selfHealingEngineInvokedMode eq $COMMAND_MODE){
	foreach my $parameter (@ARGV){
	  if($loopIndex == $COMMAND_INVOKE_MODE_INPUT_PARAMETER_OPERATION_NAME_CODE_INDEX){#Parameter Operation Name Code - for example: "RESTART_LOADER_ON_TAP_SERVER"
	    $parameterOperationNameCode = $parameter;
        print LOG "The input Operation Name Code parameter: {$parameterOperationNameCode}\n";
      }
	  elsif($loopIndex == $COMMAND_INVOKE_MODE_INPUT_PARAMETER_OPERATION_MERGED_PARAMETERS_VALUE_INDEX){#Parameter Operation Merged Parameters Value - for example: "reconEngine.pl"
        $parameterOperationMergedParametersValue = $parameter;
        print LOG "The input Operation Merged Parameters Value parameter: {$parameterOperationMergedParametersValue}\n";
	  }
	  $loopIndex++; 
    }
  }
  
  #Invoke the coreOperationProcess method to do operation process
  coreOperationProcess($parameterOperationNameCode,$parameterOperationMergedParametersValue);
  #sleep 60;#For Multi Processes Testing Purpose to sleep 60 secs

  #Seperate Line for every SelfHealing Operation
  print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
}

#This method is used to do core operation process 
sub coreOperationProcess{
  my $operationNameCode = shift;
  my $operationMergedParametersValue = shift;
  $operationResultFlag = $OPERATION_SUCCESS;#Set the init default value is "OPERATION_SUCCESS"
  $operationFailedComments = "";#var used to store operation comments
  my $operationStartedFlag = $FALSE;#var used to store operation started flag when Operation has been started to process($operationStartedFlag = $TURE means that the Operation has been started to process) 
  my $operationSuccessSpecialComments = "";#var used to store operation success special comments
  my $operationSuccessSpecialFlag = $FALSE;#var used to store operation success special flag
	
  $operationNameCode = trim($operationNameCode);#Remove space chars
  $operationMergedParametersValue = trim($operationMergedParametersValue);#Remove space chars

  my @operationParametersArray = split(/\^/,$operationMergedParametersValue);
  my $operationParametersCnt = scalar(@operationParametersArray);
  print LOG "The Operation Name Code: {$operationNameCode}\n";
  print LOG "The Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
  print LOG "The Count of Operation Parameters: {$operationParametersCnt}\n";

  #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
  my $operationParameter1;
  my $operationParameter2;
  my $operationParameter3;
  my $operationParameter4;
  my $operationParameter5;
  my $operationParameter6;
  my $operationParameter7;
  my $operationParameter8;
  my $operationParameter9;
  my $operationParameter10;

  $operationParameter1 = trim($operationParametersArray[$OPERATION_PARAMETER_1_INDEX]);
  $operationParameter2 = trim($operationParametersArray[$OPERATION_PARAMETER_2_INDEX]);
  $operationParameter3 = trim($operationParametersArray[$OPERATION_PARAMETER_3_INDEX]);
  $operationParameter4 = trim($operationParametersArray[$OPERATION_PARAMETER_4_INDEX]);
  $operationParameter5 = trim($operationParametersArray[$OPERATION_PARAMETER_5_INDEX]);
  $operationParameter6 = trim($operationParametersArray[$OPERATION_PARAMETER_6_INDEX]);
  $operationParameter7 = trim($operationParametersArray[$OPERATION_PARAMETER_7_INDEX]);
  $operationParameter8 = trim($operationParametersArray[$OPERATION_PARAMETER_8_INDEX]);
  $operationParameter9 = trim($operationParametersArray[$OPERATION_PARAMETER_9_INDEX]);
  $operationParameter10 = trim($operationParametersArray[$OPERATION_PARAMETER_10_INDEX]);

  print LOG "The Operation Parameter 1: {$operationParameter1}\n";
  print LOG "The Operation Parameter 2: {$operationParameter2}\n";
  print LOG "The Operation Parameter 3: {$operationParameter3}\n";
  print LOG "The Operation Parameter 4: {$operationParameter4}\n";
  print LOG "The Operation Parameter 5: {$operationParameter5}\n";
  print LOG "The Operation Parameter 6: {$operationParameter6}\n";
  print LOG "The Operation Parameter 7: {$operationParameter7}\n";
  print LOG "The Operation Parameter 8: {$operationParameter8}\n";
  print LOG "The Operation Parameter 9: {$operationParameter9}\n";
  print LOG "The Operation Parameter 10: {$operationParameter10}\n";
  #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
  
  eval{
  
	#############THE FOLLOWING PIECE OF CODE IS THE OPERATION CORE BUSINESS LOGIC!!!!!!################################
    if(($operationNameCode eq $RESTART_LOADER_ON_TAP_SERVER)#RESTART_LOADER_ON_TAP_SERVER
	 &&($SERVER_MODE eq $TAP || $SERVER_MODE eq $TAP2)){#TAP Server or Support TAP2 Testing Server Case
      
	  if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
        #Operation has been started to be processed
        updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
        $operationStartedFlag = $TRUE;#Operation has been started to process
      }
      
	  my $relatedTicketNumber;#var used to store related ticket number #Added by Larry for System Support And Self Healing Service Components - Phase 3
	  my $restartLoaderName;#var used to store restart loader name
	  my @validLoaderList = getValidLoaderListOnTAPServer();#array used to store valid loader list on TAP Server
	  my $validLoaderFlag = $FALSE;#Set 0(0 = False) as default value
	  my $loaderExistingPath = $LOADER_EXISTING_PATH;#var used to store loader existing path
	  my $restartLoaderFullCommand;#var used to store restart loader full command  - For example: "/opt/staging/v2/reconEngine.pl start"
	  my $killLoaderFlag = $SUCCESS;#var used to store the kill loader flag - For example: SUCCESS or FAIL #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9
	  my $restartChildLoaderName;#var used to store restart child loader name #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9

      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	  print LOG "[$currentTimeStamp]Operation has been started to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
      
      #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
      $relatedTicketNumber = trim($operationParametersArray[$RESTART_LOADER_ON_TAP_SERVER_RELATED_TICKET_NUMBER_INDEX]);#Related Ticket Number(Optional) - For example: TI30620-56800
      print LOG "The Restart Loader on TAP Server - The Operation Parameter - Related Ticket Number: {$relatedTicketNumber}\n";

      $restartLoaderName = trim($operationParametersArray[$RESTART_LOADER_ON_TAP_SERVER_LOADER_NAME_INDEX]);#Loader Name(Required) - For example: doranaToSwasset.pl
      if($restartLoaderName eq ""){
	    $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
        $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
        $operationFailedComments.="The Operation Parameter - Loader Name is required. It cannot be empty. For example: {doranaToSwasset.pl}";
		print LOG "The Restart Loader on TAP Server - The Operation Parameter - Loader Name is required. It cannot be empty. For example: {doranaToSwasset.pl}\n";
	  }#end if($restartLoaderName eq "")
	  else{
	    print LOG "The Restart Loader on TAP Server - The Operation Parameter - Loader Name: {$restartLoaderName}\n";
	  }#end else
	  #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
    
      if($operationResultFlag == $OPERATION_SUCCESS){#Only Operation Success case will go into the "Restart Loader" business logic
	    foreach my $validLoaderName (@validLoaderList){
		  if($restartLoaderName eq $validLoaderName){
		    print LOG "The Restart Loader on TAP Server - The Restart Loader Name: {$restartLoaderName} is equal to the valid Loader Name: {$validLoaderName}\n";
			print LOG "The Restart Loader on TAP Server - The Restart Loader Name: {$restartLoaderName} is a valid Loader Name on TAP Server.\n";
            $validLoaderFlag = $TRUE;#Set 1(1 = True) to vaildLoaderFlag
			last;
		  }
		  else{
		    print LOG "The Restart Loader on TAP Server - The Restart Loader Name: {$restartLoaderName} is not equal to the valid Loader Name: {$validLoaderName}\n";
		  }
		}#end foreach my $validLoaderName (@validLoaderList)

		if($validLoaderFlag == $FALSE){#Restart Loader is not a valid loader
		  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		  $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
          $operationFailedComments.="The Restart Loader Name: {$restartLoaderName} is not a valid Loader Name on TAP Server.\n"; 
		  print LOG "The Restart Loader on TAP Server - The Restart Loader Name: {$restartLoaderName} is not a valid Loader Name on TAP Server.\n";
		}
		else{#Restart Loader is a valid loader
          #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7 Start
		  if(index($RUN_ONCE_LOADER_LIST,$restartLoaderName)>-1){#judge if the target restart loader name is in the run-once loader list, then set the loader running mode to 'run-once' 
		    $loaderRunningMode = $LOADER_RUN_ONCE_MODE;
          }#end if($RUN_ONCE_LOADER_LIST.indexOf($restartLoaderName)>0)
		  else{
            $loaderRunningMode = $LOADER_START_MODE;
		  }#end else
		  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7 End

          #1. Find out and Kill all the parent processes for the target loader name - For example: "reconEngine.pl"
		  my @targetLoaderPids = `ps -ef|grep $restartLoaderName|grep $loaderRunningMode|grep -v grep|awk '{print \$2}'`;#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7
          my $targetLoaderPidsCnt = scalar(@targetLoaderPids);
		  if($targetLoaderPidsCnt == 0){
		    print LOG "The Restart Loader on TAP Server - There is no parent process running currently for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9
		  }
		  else{
		    print LOG "The Restart Loader on TAP Server - There are $targetLoaderPidsCnt parent processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9

		    my $targetLoaderPidIndex = 1;
		    foreach my $targetLoaderPid(@targetLoaderPids){
		      chomp($targetLoaderPid);#remove the return line char
		      trim($targetLoaderPid);#Remove space chars
		      print LOG "The Restart Loader on TAP Server - [$targetLoaderPidIndex]Parent PID: {$targetLoaderPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9
              my $cmdExecResult = system("kill -9 $targetLoaderPid");
			  if($cmdExecResult == 0){
                print LOG "The Restart Loader on TAP Server - The Parent PID: {$targetLoaderPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9
              }
			  else{
			    print LOG "The Restart Loader on TAP Server - The Parent PID: {$targetLoaderPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9
                #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 Start
                $killLoaderFlag = $FAIL;
				last;
				#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 End
			  }
              $targetLoaderPidIndex++;
		    }#end foreach my $targetLoaderPid(@targetLoaderPids)
		  }#end else

          #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 Start
		  #1.1. If all the parent processes have not been fullly killed, then retry one time to kill all the remaining parent processes
		  if($killLoaderFlag == $FAIL){
            $killLoaderFlag = $SUCCESS;#Reset killLoaderFlag to $SUCCESS value
            my @targetLoaderRemainingParentPids = `ps -ef|grep $restartLoaderName|grep $loaderRunningMode|grep -v grep|awk '{print \$2}'`;
            my $targetLoaderRemainingParentPidsCnt = scalar(@targetLoaderRemainingParentPids);
            if($targetLoaderRemainingParentPidsCnt == 0){
		      print LOG "The Restart Loader on TAP Server - There is no remaining parent process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		    }#end if ($targetLoaderRemainingParentPidsCnt == 0)
		    else{
		      print LOG "The Restart Loader on TAP Server - There are $targetLoaderPidsCnt remaining parent processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";
              
			  my $targetLoaderRemainingParentPidIndex = 1;
			  my $targetLoaderRemainingParentKilledFailPid = "";
		      foreach my $targetLoaderRemainingParentPid(@targetLoaderRemainingParentPids){
		        chomp($targetLoaderRemainingParentPid);#remove the return line char
		        trim($targetLoaderRemainingParentPid);#Remove space chars
		        print LOG "The Restart Loader on TAP Server - [$targetLoaderRemainingParentPidIndex]Remaining Parent PID: {$targetLoaderRemainingParentPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";
                my $cmdExecResult = system("kill -9 $targetLoaderRemainingParentPid");
			    if($cmdExecResult == 0){
                  print LOG "The Restart Loader on TAP Server - The Remaining Parent PID: {$targetLoaderRemainingParentPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";
                }
			    else{
			      print LOG "The Restart Loader on TAP Server - The Remaining Parent PID: {$targetLoaderRemainingParentPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";
                  $killLoaderFlag = $FAIL;
				  $targetLoaderRemainingParentKilledFailPid = $targetLoaderRemainingParentPid;
				  last;
			    }
                $targetLoaderRemainingParentPidIndex++;
		      }#end foreach my $targetLoaderRemainingParentPid(@targetLoaderPids)
			  
			  #If retry to kill the remaining parent processes still failed, then generates the error message
              if($killLoaderFlag == $FAIL){
			    $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                if($operationFailedComments ne ""){
                  $operationFailedComments.="The Target Loader {$restartLoaderName} Running Parent Process PID {$targetLoaderRemainingParentKilledFailPid} has been killed failed.\n";
			    }#end if($operationFailedComments ne "")
			    else{
		          $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                  $operationFailedComments.="The Target Loader {$restartLoaderName} Running Parent Process PID {$targetLoaderRemainingParentKilledFailPid} has been killed failed.\n";
			    }#end else
			  }#end if($killLoaderFlag == $FAIL)
		    }#end else
		  }#end if($killLoaderFlag == $FAIL)
         
		  #1.2. If the target loader parent processes have been killed fully and successfully, then go on killing the child processes
          if(($killLoaderFlag == $SUCCESS)&&(index($HAS_CHILD_LOADER_LIST_ON_TAP_SERVER,$restartLoaderName)>-1)){
		    $restartChildLoaderName = $restartLoaderName;
			$restartChildLoaderName =~ s/$LOADER_REPLACE_STRING/$LOADER_REPLACED_STRING/g;
			print LOG "The Restart Loader on TAP Server - The Target Loader {$restartLoaderName} has Child Loader with name {$restartChildLoaderName}.\n";
            
			my @targetChildLoaderPids = `ps -ef|grep $restartChildLoaderName|grep -v grep|awk '{print \$2}'`;
            my $targetChildLoaderPidsCnt = scalar(@targetChildLoaderPids);
		    if($targetChildLoaderPidsCnt == 0){
		      print LOG "The Restart Loader on TAP Server - There is no child process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		    }#end if($targetChildLoaderPidsCnt == 0)
			else{
			  print LOG "The Restart Loader on TAP Server - There are $targetChildLoaderPidsCnt child processes running currently with Restart Child Loader Name {$restartChildLoaderName} of the Restart Loader Name: {$restartLoaderName}.\n";

		      my $targetChildLoaderPidIndex = 1;
		      foreach my $targetChildLoaderPid(@targetChildLoaderPids){
		        chomp($targetChildLoaderPid);#remove the return line char
		        trim($targetChildLoaderPid);#Remove space chars
		        print LOG "The Restart Loader on TAP Server - [$targetChildLoaderPidIndex]Child PID: {$targetChildLoaderPid} needs to be killed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                my $cmdExecResult = system("kill -9 $targetChildLoaderPid");
			    if($cmdExecResult == 0){
                  print LOG "The Restart Loader on TAP Server - The Child PID: {$targetChildLoaderPid} has been killed successfully for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                }
			    else{
			      print LOG "The Restart Loader on TAP Server - The Child PID: {$targetChildLoaderPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                  $killLoaderFlag = $FAIL;
				  last;
			    }
                $targetChildLoaderPidIndex++;
		      }#end foreach my $targetChildLoaderPid(@targetChildLoaderPids)
			}#end else

            #1.3. If all the child processes have not been fullly killed, then retry one time to kill all the remaining child processes
			if($killLoaderFlag == $FAIL){
			  $killLoaderFlag = $SUCCESS;#Reset killLoaderFlag to $SUCCESS value
              my @targetLoaderRemainingChildPids = `ps -ef|grep $restartChildLoaderName|grep -v grep|awk '{print \$2}'`;
              my $targetLoaderRemainingChildPidsCnt = scalar(@targetLoaderRemainingChildPids);
              if($targetLoaderRemainingChildPidsCnt == 0){
			    print LOG "The Restart Loader on TAP Server - There is no remaining child process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
			  }#end if($targetLoaderRemainingChildPidsCnt == 0)
			  else{
                print LOG "The Restart Loader on TAP Server - There are $targetLoaderRemainingChildPidsCnt remaining child processes running currently with Restart Child Loader Name {$restartChildLoaderName} of the Restart Loader Name: {$restartLoaderName}.\n";
                
			    my $targetLoaderRemainingChildPidIndex = 1;
                my $targetLoaderRemainingChildKilledFailPid = "";
		        foreach my $targetLoaderRemainingChildPid(@targetLoaderRemainingChildPids){
		          chomp($targetLoaderRemainingChildPid);#remove the return line char
		          trim($targetLoaderRemainingChildPid);#Remove space chars
		          print LOG "The Restart Loader on TAP Server - [$targetLoaderRemainingChildPidIndex]Remaining Child PID: {$targetLoaderRemainingChildPid} needs to be killed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                  my $cmdExecResult = system("kill -9 $targetLoaderRemainingChildPid");
			      if($cmdExecResult == 0){
                    print LOG "The Restart Loader on TAP Server - The Remaining Child PID: {$targetLoaderRemainingChildPid} has been killed successfully for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                  }
			      else{
			        print LOG "The Restart Loader on TAP Server - The Remaining Child PID: {$targetLoaderRemainingChildPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                    $killLoaderFlag = $FAIL;
					$targetLoaderRemainingChildKilledFailPid = $targetLoaderRemainingChildPid;
				    last;
			      }
                  $targetLoaderRemainingChildPidIndex++;
		        }#end foreach my $targetLoaderRemainingChildPid(@targetLoaderRemainingChildPids)

				#If retry to kill the remaining parent processes still failed, then generates the error message
                if($killLoaderFlag == $FAIL){
			      $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                  if($operationFailedComments ne ""){
                    $operationFailedComments.="The Target Loader {$restartLoaderName} Running Child Process PID {$targetLoaderRemainingChildKilledFailPid} has been killed failed.\n";
			      }#end if($operationFailedComments ne "")
			      else{
		            $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                    $operationFailedComments.="The Target Loader {$restartLoaderName} Running Child Process PID {$targetLoaderRemainingChildKilledFailPid} has been killed failed.\n";
			      }#end else
			    }#end if($killLoaderFlag == $FAIL)
			  }#end else
			}#end if($killLoaderFlag == $FAIL)
		  }#if(($killLoaderFlag == $SUCCESS)&&(index($HAS_CHILD_LOADER_LIST_ON_TAP_SERVER,$restartLoaderName)>-1))
          #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 End
           
		  #2. Start target loader using loader full name - For exmaple: "/opt/staging/v2/reconEngine.pl"
          #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 Start
		  if($killLoaderFlag == $SUCCESS){
            #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 End
		    $restartLoaderFullCommand = $loaderExistingPath;
            $restartLoaderFullCommand.= $restartLoaderName;
            $restartLoaderFullCommand.= " $loaderRunningMode";#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7
		    print LOG "The Restart Loader on TAP Server - The Restart Loader Full Unix Command: {$restartLoaderFullCommand}\n";
		    my $restartLoaderFullCommandExecutedResult = system("$restartLoaderFullCommand");
            print LOG "The Restart Loader on TAP Server - The Unix Command {$restartLoaderFullCommand} executed result is {$restartLoaderFullCommandExecutedResult}\n";
		    if($restartLoaderFullCommandExecutedResult == 0){#Execute Successfully
              print LOG "The Restart Loader on TAP Server - The Unix Command {$restartLoaderFullCommand} has been executed successfully.\n";

			  #Added by Larry for Self Healing Service Component - Phase 2 Start
			  #Sleep 10 seconds to give the target loader startup time
			  sleep 10;
		
			  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.5 Start
              my @loaderRunningProcessesMsg = `ps -ef|grep $restartLoaderName|grep $loaderRunningMode|grep -v grep`;#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7
			  foreach my $loaderRunningProcessMsg (@loaderRunningProcessesMsg){
                chomp($loaderRunningProcessMsg); 
			    print LOG "The Restart Loader on TAP Server - The Loader {$restartLoaderName} Running Process Message: {$loaderRunningProcessMsg}\n";
              }
			  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.5 End

			  #Add Post Check Support Feature to judge if the target loader has been restarted successfully or not
			  my $targetLoaderRunningProcessCnt = `ps -ef|grep $restartLoaderName|grep $loaderRunningMode|grep -v grep|wc -l`;#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7
			  chomp($targetLoaderRunningProcessCnt);#remove the return line char
			  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.5 Start
              #This is a bug. For Restart Loader on TAP Server Operation, there is no need to decrease 1 count.
			  #$targetLoaderRunningProcessCnt--;#decrease the unix command itself from the total calculated target loader running process count
              #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.5 End
			  if($targetLoaderRunningProcessCnt > 0){#The target loader has been restarted successfully case
			     print LOG "The Restart Loader on TAP Server - There are $targetLoaderRunningProcessCnt processes which have been created for the target loader {$restartLoaderName} to run.\n";
			     print LOG "The Restart Loader on TAP Server - The Target Loader {$restartLoaderName} has been restarted successfully.\n";
			  }
			  else{#The target loader has been started failed case
                 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                 #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 Start
			     if($operationFailedComments ne ""){
                   $operationFailedComments.="The Target Loader {$restartLoaderName} has been restarted failed on TAP Server. Please contact AM developer to check this loader log to find the failed reason. Thanks!\n";
			     }#end if($operationFailedComments ne "")
			     else{
		           $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                   $operationFailedComments.="The Target Loader {$restartLoaderName} has been restarted failed on TAP Server. Please contact AM developer to check this loader log to find the failed reason. Thanks!\n";
			     }#end else
			     #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 End
			     print LOG "The Restart Loader on TAP Server - There is no process which has been created for the target loader {$restartLoaderName} to run.\n";
			     print LOG "The Restart Loader on TAP Server - The Target Loader {$restartLoaderName} has been restarted failed. Please check this loader log to find the failed reason on TAP Server.\n";
			  }
			  #Added by Larry for Self Healing Service Component - Phase 2 End
		    }
		    else{#Execute Failed
              $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		      #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 Start
			  if($operationFailedComments ne ""){
                $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n"; 
              }#end if($operationFailedComments ne "")
			  else{
			    $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n";
			  }   
			  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9 End
		      print LOG "The Restart Loader on TAP Server - The Unix Command {$restartLoaderFullCommand} has been executed failed.\n";
		    }
		  }#end if($killLoaderFlag == $SUCCESS)#Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.9
		}
	  }#end if($operationResultFlag == $OPERATION_SUCCESS) 

      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	  print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end if($operationNameCode eq $RESTART_LOADER_ON_TAP_SERVER)
	#Added by Larry for Self Healing Service Component - Phase 2 Start
    elsif(($operationNameCode eq $RESTART_LOADER_ON_TAP3_SERVER)#RESTART_LOADER_ON_TAP3_SERVER
	    &&($SERVER_MODE eq $TAP3 ||$SERVER_MODE eq $TAP2)){#TAP3 Server or Support TAP2 Server Testing Purpose 
     
	 if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
        #Operation has been started to be processed
        updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
        $operationStartedFlag = $TRUE;#Operation has been started to process
      }

      my $relatedTicketNumber;#var used to store related ticket number #Added by Larry for System Support And Self Healing Service Components - Phase 3
	  my $restartLoaderName;#var used to store restart loader name
	  my @validLoaderList = getValidLoaderListOnTAP3Server();#array used to store valid loader list on TAP3 Server
	  my $validLoaderFlag = $FALSE;#Set 0(0 = False) as default value
	  my $loaderExistingPath = $LOADER_EXISTING_PATH;#var used to store loader existing path
	  my $restartLoaderFullCommand;#var used to store restart loader full command  - For example: "sudo /opt/staging/v2/start-all.sh"
	  my $killLoaderFlag = $SUCCESS;#var used to store the kill loader flag - For example: SUCCESS or FAIL #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3
	  my $restartChildLoaderName;#var used to store restart child loader name #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3

      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	  print LOG "[$currentTimeStamp]Operation has been started to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    
      #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
      $relatedTicketNumber = trim($operationParametersArray[$RESTART_LOADER_ON_TAP3_SERVER_RELATED_TICKET_NUMBER_INDEX]);#Related Ticket Number(Optional) - For example: TI30620-56800
      print LOG "The Restart Loader on TAP3 Server - The Operation Parameter - Related Ticket Number: {$relatedTicketNumber}\n";

      $restartLoaderName = trim($operationParametersArray[$RESTART_LOADER_ON_TAP3_SERVER_LOADER_NAME_INDEX]);#Loader Name(Required) - For example: reconEngine.pl
      if($restartLoaderName eq ""){
	    $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
        $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
        $operationFailedComments.="The Operation Parameter - Loader Name is required. It cannot be empty. For example: {reconEngine.pl}";
		print LOG "The Restart Loader on TAP3 Server - The Operation Parameter - Loader Name is required. It cannot be empty. For example: {reconEngine.pl}\n";
	  }#end if($restartLoaderName eq "")
	  else{
	    print LOG "The Restart Loader on TAP3 Server - The Operation Parameter - Loader Name: {$restartLoaderName}\n";
	  }#end else
	  #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
 
      if($operationResultFlag == $OPERATION_SUCCESS){#Only Operation Success case will go into the "Restart Loader" business logic
	    foreach my $validLoaderName (@validLoaderList){
		  if($restartLoaderName eq $validLoaderName){
		    print LOG "The Restart Loader on TAP3 Server - The Restart Loader Name: {$restartLoaderName} is equal to the valid Loader Name: {$validLoaderName}\n";
			print LOG "The Restart Loader on TAP3 Server - The Restart Loader Name: {$restartLoaderName} is a valid Loader Name on TAP3 Server.\n";
            $validLoaderFlag = $TRUE;#Set 1(1 = True) to vaildLoaderFlag
			last;
		  }
		  else{
		    print LOG "The Restart Loader on TAP3 Server - The Restart Loader Name: {$restartLoaderName} is not equal to the valid Loader Name: {$validLoaderName}\n";
		  }
		}#end foreach my $validLoaderName (@validLoaderList)

		if($validLoaderFlag == $FALSE){#Restart Loader is not a valid loader
		  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		  $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
          $operationFailedComments.="The Restart Loader Name: {$restartLoaderName} is not a valid Loader Name on TAP3 Server.\n"; 
		  print LOG "The Restart Loader on TAP3 Server - The Restart Loader Name: {$restartLoaderName} is not a valid Loader Name on TAP3 Server.\n";
		}
		else{#Restart Loader is a valid loader
		  #1. Find out and Kill all the parent processes for the target loader name - For example: "reconEngine.pl"
		  my @targetLoaderPids = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|awk '{print \$2}'`;
          my $targetLoaderPidsCnt = scalar(@targetLoaderPids);
		  if($targetLoaderPidsCnt == 0){
		    print LOG "The Restart Loader on TAP3 Server - There is no parent process running currently for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3
		  }
		  else{
		    print LOG "The Restart Loader on TAP3 Server - There are $targetLoaderPidsCnt parent processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3

            my $targetLoaderPidIndex = 1;
		    foreach my $targetLoaderPid(@targetLoaderPids){
		      chomp($targetLoaderPid);#remove the return line char
		      trim($targetLoaderPid);#Remove space chars
		      print LOG "The Restart Loader on TAP3 Server - [$targetLoaderPidIndex]Parent PID: {$targetLoaderPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3
              my $cmdExecResult = system("kill -9 $targetLoaderPid");
			  if($cmdExecResult == 0){
                print LOG "The Restart Loader on TAP3 Server - The Parent PID: {$targetLoaderPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3
              }
			  else{
			    print LOG "The Restart Loader on TAP3 Server - The Parent PID: {$targetLoaderPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3
				#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 Start
                $killLoaderFlag = $FAIL;
				last;
				#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 End
			  }
              $targetLoaderPidIndex++;
		    }#end foreach my $targetLoaderPid(@targetLoaderPids)
		  }#end else
		  
          #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 Start
		  #1.1. If all the parent processes have not been fullly killed, then retry one time to kill all the remaining parent processes
		  if($killLoaderFlag == $FAIL){
            $killLoaderFlag = $SUCCESS;#Reset killLoaderFlag to $SUCCESS value
            my @targetLoaderRemainingParentPids = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|awk '{print \$2}'`;
            my $targetLoaderRemainingParentPidsCnt = scalar(@targetLoaderRemainingParentPids);
            if($targetLoaderRemainingParentPidsCnt == 0){
		      print LOG "The Restart Loader on TAP3 Server - There is no remaining parent process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		    }#end if ($targetLoaderRemainingParentPidsCnt == 0)
		    else{
		      print LOG "The Restart Loader on TAP3 Server - There are $targetLoaderPidsCnt remaining parent processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";
              
			  my $targetLoaderRemainingParentPidIndex = 1;
			  my $targetLoaderRemainingParentKilledFailPid = "";
		      foreach my $targetLoaderRemainingParentPid(@targetLoaderRemainingParentPids){
		        chomp($targetLoaderRemainingParentPid);#remove the return line char
		        trim($targetLoaderRemainingParentPid);#Remove space chars
		        print LOG "The Restart Loader on TAP3 Server - [$targetLoaderRemainingParentPidIndex]Remaining Parent PID: {$targetLoaderRemainingParentPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";
                my $cmdExecResult = system("kill -9 $targetLoaderRemainingParentPid");
			    if($cmdExecResult == 0){
                  print LOG "The Restart Loader on TAP3 Server - The Remaining Parent PID: {$targetLoaderRemainingParentPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";
                }
			    else{
			      print LOG "The Restart Loader on TAP3 Server - The Remaining Parent PID: {$targetLoaderRemainingParentPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";
                  $killLoaderFlag = $FAIL;
				  $targetLoaderRemainingParentKilledFailPid = $targetLoaderRemainingParentPid;
				  last;
			    }
                $targetLoaderRemainingParentPidIndex++;
		      }#end foreach my $targetLoaderRemainingParentPid(@targetLoaderPids)
			  
			  #If retry to kill the remaining parent processes still failed, then generates the error message
              if($killLoaderFlag == $FAIL){
			    $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                if($operationFailedComments ne ""){
                  $operationFailedComments.="The Target Loader {$restartLoaderName} Running Parent Process PID {$targetLoaderRemainingParentKilledFailPid} has been killed failed.\n";
			    }#end if($operationFailedComments ne "")
			    else{
		          $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                  $operationFailedComments.="The Target Loader {$restartLoaderName} Running Parent Process PID {$targetLoaderRemainingParentKilledFailPid} has been killed failed.\n";
			    }#end else
			  }#end if($killLoaderFlag == $FAIL)
		    }#end else
		  }#end if($killLoaderFlag == $FAIL)
         
		  #1.2. If the target loader parent processes have been killed fully and successfully, then go on killing the child processes
          if(($killLoaderFlag == $SUCCESS)&&(index($HAS_CHILD_LOADER_LIST_ON_TAP3_SERVER,$restartLoaderName)>-1)){
		    $restartChildLoaderName = $restartLoaderName;
			$restartChildLoaderName =~ s/$LOADER_REPLACE_STRING/$LOADER_REPLACED_STRING/g;
			print LOG "The Restart Loader on TAP3 Server - The Target Loader {$restartLoaderName} has Child Loader with name {$restartChildLoaderName}.\n";
            
			my @targetChildLoaderPids = `ps -ef|grep $restartChildLoaderName|grep -v grep|awk '{print \$2}'`;
            my $targetChildLoaderPidsCnt = scalar(@targetChildLoaderPids);
		    if($targetChildLoaderPidsCnt == 0){
		      print LOG "The Restart Loader on TAP3 Server - There is no child process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		    }#end if($targetChildLoaderPidsCnt == 0)
			else{
			  print LOG "The Restart Loader on TAP3 Server - There are $targetChildLoaderPidsCnt child processes running currently with Restart Child Loader Name {$restartChildLoaderName} of the Restart Loader Name: {$restartLoaderName}.\n";

		      my $targetChildLoaderPidIndex = 1;
		      foreach my $targetChildLoaderPid(@targetChildLoaderPids){
		        chomp($targetChildLoaderPid);#remove the return line char
		        trim($targetChildLoaderPid);#Remove space chars
		        print LOG "The Restart Loader on TAP3 Server - [$targetChildLoaderPidIndex]Child PID: {$targetChildLoaderPid} needs to be killed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                my $cmdExecResult = system("kill -9 $targetChildLoaderPid");
			    if($cmdExecResult == 0){
                  print LOG "The Restart Loader on TAP3 Server - The Child PID: {$targetChildLoaderPid} has been killed successfully for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                }
			    else{
			      print LOG "The Restart Loader on TAP3 Server - The Child PID: {$targetChildLoaderPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                  $killLoaderFlag = $FAIL;
				  last;
			    }
                $targetChildLoaderPidIndex++;
		      }#end foreach my $targetChildLoaderPid(@targetChildLoaderPids)
			}#end else

            #1.3. If all the child processes have not been fullly killed, then retry one time to kill all the remaining child processes
			if($killLoaderFlag == $FAIL){
			  $killLoaderFlag = $SUCCESS;#Reset killLoaderFlag to $SUCCESS value
              my @targetLoaderRemainingChildPids = `ps -ef|grep $restartChildLoaderName|grep -v grep|awk '{print \$2}'`;
              my $targetLoaderRemainingChildPidsCnt = scalar(@targetLoaderRemainingChildPids);
              if($targetLoaderRemainingChildPidsCnt == 0){
			    print LOG "The Restart Loader on TAP3 Server - There is no remaining child process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
			  }#end if($targetLoaderRemainingChildPidsCnt == 0)
			  else{
                print LOG "The Restart Loader on TAP3 Server - There are $targetLoaderRemainingChildPidsCnt remaining child processes running currently with Restart Child Loader Name {$restartChildLoaderName} of the Restart Loader Name: {$restartLoaderName}.\n";
                
			    my $targetLoaderRemainingChildPidIndex = 1;
                my $targetLoaderRemainingChildKilledFailPid = "";
		        foreach my $targetLoaderRemainingChildPid(@targetLoaderRemainingChildPids){
		          chomp($targetLoaderRemainingChildPid);#remove the return line char
		          trim($targetLoaderRemainingChildPid);#Remove space chars
		          print LOG "The Restart Loader on TAP3 Server - [$targetLoaderRemainingChildPidIndex]Remaining Child PID: {$targetLoaderRemainingChildPid} needs to be killed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                  my $cmdExecResult = system("kill -9 $targetLoaderRemainingChildPid");
			      if($cmdExecResult == 0){
                    print LOG "The Restart Loader on TAP3 Server - The Remaining Child PID: {$targetLoaderRemainingChildPid} has been killed successfully for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                  }
			      else{
			        print LOG "The Restart Loader on TAP3 Server - The Remaining Child PID: {$targetLoaderRemainingChildPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}.\n";
                    $killLoaderFlag = $FAIL;
					$targetLoaderRemainingChildKilledFailPid = $targetLoaderRemainingChildPid;
				    last;
			      }
                  $targetLoaderRemainingChildPidIndex++;
		        }#end foreach my $targetLoaderRemainingChildPid(@targetLoaderRemainingChildPids)

				#If retry to kill the remaining parent processes still failed, then generates the error message
                if($killLoaderFlag == $FAIL){
			      $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                  if($operationFailedComments ne ""){
                    $operationFailedComments.="The Target Loader {$restartLoaderName} Running Child Process PID {$targetLoaderRemainingChildKilledFailPid} has been killed failed.\n";
			      }#end if($operationFailedComments ne "")
			      else{
		            $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                    $operationFailedComments.="The Target Loader {$restartLoaderName} Running Child Process PID {$targetLoaderRemainingChildKilledFailPid} has been killed failed.\n";
			      }#end else
			    }#end if($killLoaderFlag == $FAIL)
			  }#end else
			}#end if($killLoaderFlag == $FAIL)
		  }#if(($killLoaderFlag == $SUCCESS)&&(index($HAS_CHILD_LOADER_LIST_ON_TAP3_SERVER,$restartLoaderName)>-1))
          #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 End

          #2. Start target loader using start-all.sh due that there is no root privilege granted on TAP3 Server we need to use 'sudo' unix command to get temp root privilege - For exmaple: "sudo /opt/staging/v2/start-all.sh"
		  #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 Start
		  if($killLoaderFlag == $SUCCESS){
			if($SERVER_MODE eq $TAP3){
              $restartLoaderFullCommand = "$SUDO_CMD_PREFIX ";#append "sudo " when TAP3 server
            }#end if($SERVER_MODE eq $TAP3)
			else{
              $restartLoaderFullCommand = "";#append "" when TAP2 server
			}#end else
			#Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 End
		    $restartLoaderFullCommand.= $loaderExistingPath;#Append the '/opt/staging/v2/' loader existing path
            $restartLoaderFullCommand.= $START_ALL_SHELL_NAME;#Append the 'start-all.sh' shell name
		    print LOG "The Restart Loader on TAP3 Server - The Restart Loader Full Unix Command: {$restartLoaderFullCommand}\n";
		    my $restartLoaderFullCommandExecutedResult = system("$restartLoaderFullCommand");
            print LOG "The Restart Loader on TAP3 Server - The Unix Command {$restartLoaderFullCommand} executed result is {$restartLoaderFullCommandExecutedResult}\n";
		    if($restartLoaderFullCommandExecutedResult == 0){#Execute Successfully
              print LOG "The Restart Loader on TAP3 Server - The Unix Command {$restartLoaderFullCommand} has been executed successfully.\n";

			  #Added by Larry for Self Healing Service Component - Phase 2 Start
			  #Sleep 120 seconds to give the target loader startup time
			  sleep 120;
              #Add Post Check Support Feature to judge if the target loader has been restarted successfully or not
			  my $targetLoaderRunningProcessCnt = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|wc -l`;
			  chomp($targetLoaderRunningProcessCnt);#remove the return line char
              $targetLoaderRunningProcessCnt--;#decrease the unix command itself from the total calculated target loader running process count
			  if($targetLoaderRunningProcessCnt > 0){#The target loader has been restarted successfully case
			     print LOG "The Restart Loader on TAP3 Server - There are $targetLoaderRunningProcessCnt processes which have been created for the target loader {$restartLoaderName} to run.\n";
			     print LOG "The Restart Loader on TAP3 Server - The Target Loader {$restartLoaderName} has been restarted successfully.\n";
			  }
			  else{#The target loader has been started failed case
				 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		         #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 Start
			     if($operationFailedComments ne ""){
				   $operationFailedComments.="The Target Loader {$restartLoaderName} has been restarted failed on TAP3 Server. Please contact AM developer to check this loader log to find the failed reason. Thanks!\n";
			     }
				 else{
                   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                   $operationFailedComments.="The Target Loader {$restartLoaderName} has been restarted failed on TAP3 Server. Please contact AM developer to check this loader log to find the failed reason. Thanks!\n";
			     }
				 #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 End
				 print LOG "The Restart Loader on TAP3 Server - There is no process which has been created for the target loader {$restartLoaderName} to run.\n";
			     print LOG "The Restart Loader on TAP3 Server - The Target Loader {$restartLoaderName} has been restarted failed. Please check this loader log to find the failed reason on TAP3 Server.\n";
			  }
			  #Added by Larry for Self Healing Service Component - Phase 2 End
		    }
		    else{#Execute Failed
			  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
              #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 Start
			  if($operationFailedComments ne ""){
			    $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n"; 
			  }
			  else{
			    $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n"; 
			  }
              #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3 End
		      print LOG "The Restart Loader on TAP3 Server - The Unix Command {$restartLoaderFullCommand} has been executed failed.\n";
		    }
		  }#end if($killLoaderFlag == $SUCCESS) #Added by Larry for System Support And Self Healing Service Components - Phase 2 - 1.2.3
		}
	  }#end if($operationResultFlag == $OPERATION_SUCCESS) 

      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	  print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";

    }#end elsif($operationNameCode eq $RESTART_LOADER_ON_TAP3_SERVER)
	#Added by Larry for Self Healing Service Component - Phase 2 End
	#Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
    elsif($operationNameCode eq $RESTART_CHILD_LOADER_ON_TAP_SERVER){#RESTART_CHILD_LOADER_ON_TAP_SERVER
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }

	   my $relatedTicketNumber;#var used to store related ticket number - For example: TI30620-56800
	   my $restartChildLoaderName;#var used to store restart child loader name - For example: softwareFilterToStagingChild.pl
       my $bankAccountName;#var used to store bank account name - For example: GTAASCCM
	   my $debugOption;#var used to store debug option - For example: Yes or No
	   my $upperCaseDebugOption;#var used to store upper case debug option - For example: YES or NO
	   my $logFile;#var used to store log file - For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM
	   my @validChildLoaderList = getValidChildLoaderListOnTAPServer();#array used to store valid child loader list on TAP Server
	   my $validChildLoaderFlag = $FALSE;#Set 0(0 = False) as default value
	   my $processedInvokedCommand;#var used to store processed invoked command
	   my $invokedCommandRestartChildLoaderFullName;#var used to store invoked command restart child loader full name - For example: /opt/staging/v2/softwareFilterToStagingChild.pl
       my $invokedCommandBankAccountName;#var used to store invoked command bank account name - For example: GTAASCCM
       my $invokedCommandLogFile;#var used to store invoked command log file - For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM
	   my $invokedCommandLoaderFullConfigFile;#var used to store invoked command loader full configuration file - /opt/staging/v2/config/softwareFilterToStagingConfig.txt
	   my $invokedCommandLoaderConfigFile;#var used to store invoked command loader configuration file - softwareFilterToStagingConfig.txt
	   my $certainBankAccountNameCount;#var used to store certain bank account name count
	   my $inputParameterValuesValidationFlag = $TRUE;#Set 1(1 = TURE) as default value
       my $nonDebugLogFile;#var used to store non debug log file - For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM 

       #Input Operation Parameter Values Check
       $relatedTicketNumber = trim($operationParametersArray[$RESTART_CHILD_LOADER_ON_TAP_SERVER_RELATED_TICKET_NUMBER_INDEX]);#Related Ticket Number(Optional) - For example: TI30620-56800
       print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Related Ticket Number: {$relatedTicketNumber}\n";

       $restartChildLoaderName = trim($operationParametersArray[$RESTART_CHILD_LOADER_ON_TAP_SERVER_CHILD_LOADER_NAME_INDEX]);#Child Loader Name(Required) - For example: softwareFilterToStagingChild.pl
       if($restartChildLoaderName eq ""){
         $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
	     $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
         $operationFailedComments.="The Operation Parameter - Child Loader Name is required. It cannot be empty. For example: {softwareFilterToStagingChild.pl}<br>";
		 print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Child Loader Name is required. It cannot be empty. For example: {softwareFilterToStagingChild.pl}\n";
	   }#end if($restartLoaderName eq "")
	   else{
	     print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Child Loader Name: {$restartChildLoaderName}\n";
	   }#end else
	   
       $bankAccountName = trim($operationParametersArray[$RESTART_CHILD_LOADER_ON_TAP_SERVER_BANK_ACCOUNT_NAME_INDEX]);#Bank Account Name(Required) - For example: GTAASCCM
       if($bankAccountName eq ""){
         $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
	     $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 if($operationFailedComments ne ""){
		   $operationFailedComments.="The Operation Parameter - Bank Account Name is required. It cannot be empty. For example: {GTAASCCM}<br>";  
		 }#end if($operationFailedComments ne "")
		 else{
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
           $operationFailedComments.="The Operation Parameter - Bank Account Name is required. It cannot be empty. For example: {GTAASCCM}<br>";
		 }#end else
  		 print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Bank Account Name is required. It cannot be empty. For example: {GTAASCCM}\n";
	   }#end if($restartLoaderName eq "")
	   else{
	     print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Bank Account Name: {$bankAccountName}\n";
	   }#end else
      
	   $debugOption = trim($operationParametersArray[$RESTART_CHILD_LOADER_ON_TAP_SERVER_DEBUG_OPTION_INDEX]);#Debug Option(Required) - For example: YES or NO
       if($debugOption eq ""){
         $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
	     $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 if($operationFailedComments ne ""){
		   $operationFailedComments.="The Operation Parameter - Debug Option is required. It cannot be empty. For example: {YES}<br>";  
		 }#end if($operationFailedComments ne "")
		 else{
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
           $operationFailedComments.="The Operation Parameter - Debug Option is required. It cannot be empty. For example: {YES}<br>";
		 }#end else
  		 print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Debug Option is required. It cannot be empty. For example: {YES}\n";
	   }#end if($restartLoaderName eq "")
	   else{
	     print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Debug Option: {$debugOption}\n";
	   }#end else
	  
	   $logFile = trim($operationParametersArray[$RESTART_CHILD_LOADER_ON_TAP_SERVER_LOG_FILE_INDEX]);#Log File(Required) - For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCC
    
       if($operationResultFlag == $OPERATION_SUCCESS){#Only all the input Operation Parameters have values, then go into the input Operation Parameter Values Validation Check Business Logic
         #Restart Child Loader Validation Check  
	     foreach my $validChildLoaderName (@validChildLoaderList){
		   if($restartChildLoaderName eq $validChildLoaderName){
		     print LOG "The Restart Child Loader on TAP Server - The Restart Child Loader Name: {$restartChildLoaderName} is equal to the valid Child Loader Name: {$validChildLoaderName}\n";
			 print LOG "The Restart Child Loader on TAP Server - The Restart Child Loader Name: {$restartChildLoaderName} is a valid Child Loader Name on TAP Server.\n";
             $validChildLoaderFlag = $TRUE;#Set 1(1 = True) to $validChildLoaderFlag
			 last;
		   }
		   else{
		     print LOG "The Restart Child Loader on TAP Server - The Restart Child Loader Name: {$restartChildLoaderName} is not equal to the valid Child Loader Name: {$validChildLoaderName}\n";
		   }
		 }#end foreach my $validChildLoaderName (@validChildLoaderList)
         
		 if($validChildLoaderFlag == $FALSE){#Restart Child Loader is not a valid child loader
           $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE 
		   $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="The Restart Child Loader Name: {$restartChildLoaderName} is not a valid Child Loader Name on TAP Server.<br>";   
  		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
             $operationFailedComments.="The Restart Child Loader Name: {$restartChildLoaderName} is not a valid Child Loader Name on TAP Server.<br>";
		   }#end else
		   print LOG "The Restart Child Loader on TAP Server - The Restart Child Loader Name: {$restartChildLoaderName} is not a valid Child Loader Name on TAP Server.\n";
		 }#end if($validChildLoaderFlag == $FALSE) 

		 #Bank Account Name Validation Check
         $certainBankAccountNameCount = getCountNumberForCertainBankAccountNameFunction($bravoConnection,$bankAccountName);
		 if(!defined $certainBankAccountNameCount){
           $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
           $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="There is no bank account defined with bank account name: {$bankAccountName}<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
             $operationFailedComments.="There is no bank account defined with bank account name: {$bankAccountName}<br>";
		   }#end else
		   print LOG "The Restart Child Loader on TAP Server - There is no bank account defined with bank account name: {$bankAccountName}\n";
		 }#end if(!defined $certainBankAccountNameCount)
		 else{
		   if($certainBankAccountNameCount == 0){
             $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		     $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		     if($operationFailedComments ne ""){
		       $operationFailedComments.="There is no bank account defined with bank account name: {$bankAccountName}<br>";  
		     }#end if($operationFailedComments ne "")
		     else{
		       $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
               $operationFailedComments.="There is no bank account defined with bank account name: {$bankAccountName}<br>";
		     }#end else
		     print LOG "The Restart Child Loader on TAP Server - There is no bank account defined with bank account name: {$bankAccountName}\n";
		   }#end if($certainBankAccountNameCount == 0)
		   elsif($certainBankAccountNameCount == 1){
		     print LOG "The Restart Child Loader on TAP Server - There is one bank account defined with bank account name: {$bankAccountName}\n";
		   }#end elsif($certainBankAccountNameCount == 1)
		   else{
             $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
             $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		     if($operationFailedComments ne ""){
		       $operationFailedComments.="There are more than one bank account defined with bank account name: {$bankAccountName}<br>";  
		     }#end if($operationFailedComments ne "")
		     else{
		       $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
               $operationFailedComments.="There are more than one bank account defined with bank account name: {$bankAccountName}<br>";
		     }#end else
		     print LOG "The Restart Child Loader on TAP Server - There are more than one bank account defined with bank account name: {$bankAccountName}\n";
		   }#end else
		 }#end else
          
         #Debug Option Validation Check
		 $upperCaseDebugOption = uc($debugOption);#Upper case debug option value - For example: change from 'Yes' to 'YES'
		 if($upperCaseDebugOption ne $DEBUG_OPTION_YES && $upperCaseDebugOption ne $DEBUG_OPTION_NO){
		   $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
           $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="The input debug option: {$debugOption} is not valid. The valid values are {YES} and {NO}.<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
             $operationFailedComments.="The input debug option: {$debugOption} is not valid. The valid values are {YES} and {NO}.<br>";
		   }#end else
		   print LOG "The Restart Child Loader on TAP Server - The input debug option: {$debugOption} is not valid. The valid values are {YES} and {NO}.\n";
		 }#end if($debugOption ne $DEBUG_OPTION_YES && $debugOption ne $DEBUG_OPTION_NO)
         
		 #Log File Validation Check
         if($upperCaseDebugOption eq $DEBUG_OPTION_NO){#If Debug = NO, then the log file will be set to be a default value - For example, /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM. And also the log file check will be bypassed 
		   my $processedParentLoaderName = $restartChildLoaderName;
		   $processedParentLoaderName =~ s/$REPLACED_STRING//g;
		   my $processedNonDebugLogFileName = $processedParentLoaderName.".log.".$bankAccountName;
		   $nonDebugLogFile = $configNonDebugLogPath.$processedParentLoaderName."/".$processedNonDebugLogFileName;
		   $logFile = $nonDebugLogFile;
           print LOG "The Restart Child Loader on TAP Server - The Non Debug Fixed Log File: {$logFile}\n";
	     }#end if($upperCaseDebugOption eq $DEBUG_OPTION_NO)
		 else{
		   my $logFileValidFlag = $TRUE;#var used to store the log file valid falg. set $TRUE as the initial default value
           
		   #If the log file value is empty, then set the default log file value '/var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM'
           if($logFile eq ""){
             my $processedParentLoaderName = $restartChildLoaderName;
		     $processedParentLoaderName =~ s/$REPLACED_STRING//g;
		     my $processedDefaultDebugLogFileName = $processedParentLoaderName.".log.".$bankAccountName;
		     $logFile = $configNonDebugLogPath.$processedParentLoaderName."/".$processedDefaultDebugLogFileName;
             $logFileValidFlag = $FALSE;#Set log file valid flag to FALSE for {Log File: '' + Debug Option: 'YES'} Case to bypass all the Log File Check Validations
             print LOG "The Restart Child Loader on TAP Server - The Default Debug Log File {$logFile} has been set due that the Log File Value is empty for Debug Option {YES} Case.\n";    
		   }#end if($logFile eq "")
           else{
             print LOG "The Restart Child Loader on TAP Server - The Operation Parameter - Log File: {$logFile}\n";
           }#end else
    
           #Check if the log file includes the invalid file path char '\'
		   if($logFileValidFlag == $TRUE){
             my $backslashIndexPosition;#var used to store the backslash index position value
             $backslashIndexPosition = index($logFile,$BACKSLASH);
		     if($backslashIndexPosition!=-1){
		       $logFileValidFlag = $FALSE;
		       $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       if($operationFailedComments ne ""){
		         $operationFailedComments.="The Log File: {$logFile} is not valid. There is invalid file path char '\\' in it.<br>";  
		       }#end if($operationFailedComments ne "")
		       else{
		         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                 $operationFailedComments.="The Log File: {$logFile} is not valid. There is invalid file path char '\\' in it.<br>";
		       }#end else
		       print LOG "The Restart Child Loader on TAP Server - The Log File: {$logFile} is not valid. There is invalid file path char '\\' in it.\n"; 
		     }#end if($backslashIndexPosition!=-1)
		   }#end if($logFileValidFlag == $TRUE)

           #Check if the log file is a valid one which includes '/home'. It means that the log file can only be outputed into the '/home' folder path
           if($logFileValidFlag == $TRUE){
		     my $logFileStrLength = length($logFile);
		     if($logFileStrLength <= 6){#The valid log file must include '/home/' substring in it. So the vaild length of log file must > 6. For example: '/home/log.txt'
               $logFileValidFlag = $FALSE;
		       $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       if($operationFailedComments ne ""){
		         $operationFailedComments.="The Log File: {$logFile} is not valid. The valid log file should be under {/home} in your personal account folder. For example: {/home/liuhaidl/logs/sampleLog.txt}<br>";  
		       }#end if($operationFailedComments ne "")
		       else{
		         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                 $operationFailedComments.="The Log File: {$logFile} is not valid. The valid log file should be under {/home} in your personal account folder. For example: {/home/liuhaidl/logs/sampleLog.txt}<br>";
		       }#end else
		       print LOG "The Restart Child Loader on TAP Server - The Log File: {$logFile} is not valid. The valid log file should be under {/home} in your personal account folder. For example: {/home/liuhaidl/logs/sampleLog.txt}\n";  
		     }#end if($subLogFileStr ne $HOME_PATH)
		   }#end if($logFileValidFlag == $TRUE)

		   if($logFileValidFlag == $TRUE){
		     my $subLogFileStr = substr($logFile,0,5);
		     if($subLogFileStr ne $HOME_PATH){#The valid log file must include '/home/' substring in it. So the vaild length of log file must > 6. For example: '/home/log.txt'
               $logFileValidFlag = $FALSE;
		       $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       if($operationFailedComments ne ""){
		         $operationFailedComments.="The Log File: {$logFile} is not valid. The valid log file should be under {/home} in your personal account folder. For example: {/home/liuhaidl/logs/sampleLog.txt}<br>";  
		       }#end if($operationFailedComments ne "")
		       else{
		         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                 $operationFailedComments.="The Log File: {$logFile} is not valid. The valid log file should be under {/home} in your personal account folder. For example: {/home/liuhaidl/logs/sampleLog.txt}<br>";
		       }#end else
		       print LOG "The Restart Child Loader on TAP Server - The Log File: {$logFile} is not valid. The valid log file should be under {/home} in your personal account folder. For example: {/home/liuhaidl/logs/sampleLog.txt}\n";  
		     }#end if($subLogFileStr ne $HOME_PATH)
		   }#end if($logFileValidFlag == $TRUE)

		   if($logFileValidFlag == $TRUE){
		     my $logFileLastChar = substr($logFile,length($logFile)-1,1);
		     if($logFileLastChar eq $SLASH){#The valid log file cannot be a file path - For example: '/home/liuhaidl/logs/sampleLog.txt'
               $logFileValidFlag = $FALSE;
		       $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       if($operationFailedComments ne ""){
		         $operationFailedComments.="The Log File: {$logFile} is not valid. The valid log file cannot be a file folder. It should like this example: {/home/liuhaidl/logs/sampleLog.txt}<br>";  
		       }#end if($operationFailedComments ne "")
		       else{
		         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                 $operationFailedComments.="The Log File: {$logFile} is not valid. The valid log file cannot be a file folder. It should like this example: {/home/liuhaidl/logs/sampleLog.txt}<br>";
		       }#end else
		       print LOG "The Restart Child Loader on TAP Server - The Log File: {$logFile} is not valid. The valid log file cannot be a file folder. It should like this example: {/home/liuhaidl/logs/sampleLog.txt}\n";  
		     }#end if($subLogFileStr ne $HOME_PATH)
		   }#end if($logFileValidFlag == $TRUE)
        
		   #Check if the log path exists or not
           if($logFileValidFlag == $TRUE){
		     my $lastSlashIndexPosition = rindex($logFile,$SLASH);
		     my $logPath = substr($logFile,0,$lastSlashIndexPosition);
             print LOG "The Restart Child Loader on TAP Server - The Target Output Log File Path: {$logPath}\n";
		     if(-e $logPath){
		       print LOG "The Restart Child Loader on TAP Server - The Target Output Log File Path: {$logPath} exists.\n";    
		     }#end if(-e $logPath)
		     else{
               $logFileValidFlag = $FALSE;
		       $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       if($operationFailedComments ne ""){
		         $operationFailedComments.="The Target Output Log File Path: {$logPath} doesn't exist.<br>";  
		       }#end if($operationFailedComments ne "")
		       else{
		         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                 $operationFailedComments.="The Target Output Log File Path: {$logPath} doesn't exist.<br>";
		       }#end else
		       print LOG "The Restart Child Loader on TAP Server - The Target Output Log File Path: {$logPath} doesn't exist.\n";
		     }#end else
		   }#end if($logFileValidFlag == $TRUE)
		 }#end else
		
	     if($inputParameterValuesValidationFlag == $TRUE){#Restart Child Loader when all the necessary parameters of the target loader are valid
           #1. Check if the target child loader is running or not. If so, kill it.
           my @targetChildLoaderPids = `ps -ef|grep $restartChildLoaderName|grep $bankAccountName|grep -v grep|awk '{print \$2}'`;
		   print LOG "The Restart Child Loader on TAP Server - The Unix Command `ps -ef|grep $restartChildLoaderName|grep $bankAccountName|grep -v grep|awk '{print \$2}' has been invoked.\n";
           foreach my $targetChildLoaderPid(@targetChildLoaderPids){
             chomp($targetChildLoaderPid);#remove the return line char
		     trim($targetChildLoaderPid);#Remove space chars

             my $targetChildLoaderPidRunningCnt = `ps -ef|grep $targetChildLoaderPid|grep -v grep|wc -l`;
			 print LOG "The Restart Child Loader on TAP Server - The Unix Command `ps -ef|grep $targetChildLoaderPid|grep -v grep|wc -l` has been invoked.\n";
             chomp($targetChildLoaderPidRunningCnt);#remove the return line char
		     trim($targetChildLoaderPidRunningCnt);#Remove space chars
			 $targetChildLoaderPidRunningCnt--;
			 if($targetChildLoaderPidRunningCnt <= 0){
			   print LOG "The Restart Child Loader on TAP Server - There is no process which is running for pid: {$targetChildLoaderPid}\n";  
			 }#end if($targetChildLoaderPidRunningCnt <= 0)
			 else{
			   print LOG "The Restart Child Loader on TAP Server - There is $targetChildLoaderPidRunningCnt process which is running for pid: {$targetChildLoaderPid}\n";
               my $killTargetChildLoaderPidCmdExecResult = system('kill -9 $targetChildLoaderPid');

			   if($killTargetChildLoaderPidCmdExecResult == 0){
                 print LOG "The Restart Child Loader on TAP Server - PID: {$targetChildLoaderPid} has been killed successfully for the Restart Child Loader Name: {$restartChildLoaderName}\n";
               }#end if($killTargetChildLoaderPidCmdExecResult == 0)
			   else{
                 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		         if($operationFailedComments ne ""){
		           $operationFailedComments.="PID: {$targetChildLoaderPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}<br>";  
		         }#end if($operationFailedComments ne "")
		         else{
		           $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                   $operationFailedComments.="PID: {$targetChildLoaderPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}<br>";
		         }#end else
			     print LOG "The Restart Child Loader on TAP Server - PID: {$targetChildLoaderPid} has been killed failed for the Restart Child Loader Name: {$restartChildLoaderName}\n";
			   }#end else               
		     }#end else
           }#end foreach my $targetChildLoaderPid(@targetChildLoaderPids)

		   if($operationResultFlag == $OPERATION_SUCCESS){
             #2. Generate The Target Invoked Command 
		     $processedInvokedCommand = $RESTART_CHILD_LOADER_INVOKED_COMMAND;
		   
		     $invokedCommandRestartChildLoaderFullName = "./".$restartChildLoaderName;#For example: ./softwareFilterToStagingChild.pl - Please note that we need to use the relative path './' to invoke perl loader, or some necessary packages cannot be found
             print LOG "The Restart Child Loader on TAP Server - The Invoked Command Restart Child Loader Full Name: {$invokedCommandRestartChildLoaderFullName}\n";

             $invokedCommandBankAccountName = $bankAccountName;#For example: GTAASCCM
		     print LOG "The Restart Child Loader on TAP Server - The Invoked Command Bank Account Name: {$invokedCommandBankAccountName}\n";

             $invokedCommandLogFile = $logFile;#For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM
		     print LOG "The Restart Child Loader on TAP Server - The Invoked Command Log File: {$invokedCommandLogFile}\n";

             $invokedCommandLoaderConfigFile = $restartChildLoaderName;
             if($upperCaseDebugOption eq $DEBUG_OPTION_YES){
		       $invokedCommandLoaderConfigFile =~ s/$REPLACED_STRING/$REPLACE_DEBUG_CONFIG_STRING/g;
		     }#end if($upperCaseDebugOption eq $DEBUG_OPTION_YES)
		     else{
		       $invokedCommandLoaderConfigFile =~ s/$REPLACED_STRING/$REPLACE_CONFIG_STRING/g;
		     }#end else
 
             $invokedCommandLoaderFullConfigFile = $LOADER_CONFIG_FILE_EXISTING_PATH.$invokedCommandLoaderConfigFile;
		     print LOG "The Restart Child Loader on TAP Server - The Invoked Command Loader Full Configuration File: {$invokedCommandLoaderFullConfigFile}\n";

             $processedInvokedCommand =~ s/$INVOKED_COMMAND_RESTART_CHILD_LOADER_NAME_REPLACE_STRING/$invokedCommandRestartChildLoaderFullName/g;
             $processedInvokedCommand =~ s/$INVOKED_COMMAND_RESTART_BANK_ACCOUNT_NAME_REPLACE_STRING/$invokedCommandBankAccountName/g;
		     $processedInvokedCommand =~ s/$INVOKED_COMMAND_RESTART_LOG_FILE_REPLACE_STRING/$invokedCommandLogFile/g;
             $processedInvokedCommand =~ s/$INVOKED_COMMAND_RESTART_CONFIG_FILE_REPLACE_STRING/$invokedCommandLoaderFullConfigFile/g;
             print LOG "The Restart Child Loader on TAP Server - The Processed Invoked Command: {$processedInvokedCommand}\n"; 
       
             #3. Restart Child Loader
             #Switch to the /opt/staging/v2 folder first
		     my $switchFolderCmdExecResult = system('cd $LOADER_EXISTING_PATH_2');
		     if($switchFolderCmdExecResult == 0){
               print LOG "The Restart Child Loader on TAP Server - The Target Folder: {$LOADER_EXISTING_PATH_2} has been switched successfully.\n";
			   #Restart the target Child Loader
		       my $restartChildLoaderCmdExecResult = system("$processedInvokedCommand");
               if($restartChildLoaderCmdExecResult == 0){
                 print LOG "The Restart Child Loader on TAP Server - The Processed Invoked Command: {$processedInvokedCommand} has been executed successfully.\n";
               }#end if($restartChildLoaderCmdExecResult == 0)
		       else{
                 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		         if($operationFailedComments ne ""){
		           $operationFailedComments.="The Processed Invoked Command: {$processedInvokedCommand} has been executed failed.<br>";  
		         }#end if($operationFailedComments ne "")
		         else{
		           $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                   $operationFailedComments.="The Processed Invoked Command: {$processedInvokedCommand} has been executed failed.<br>";
		         }#end else 
		         print LOG "The Restart Child Loader on TAP Server - The Processed Invoked Command: {$processedInvokedCommand} has been executed failed.\n";
		       }#end else   
		     }#end if($switchFolderCmdExecResult == 0)
		     else{
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       if($operationFailedComments ne ""){
		         $operationFailedComments.="The Target Folder: {$LOADER_EXISTING_PATH_2} has been switched failed.<br>";  
		       }#end if($operationFailedComments ne "")
		       else{
		         $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                 $operationFailedComments.="The Target Folder: {$LOADER_EXISTING_PATH_2} has been switched failed.<br>";
		       }#end else 
		       print LOG "The Restart Child Loader on TAP Server - The Target Folder: {$LOADER_EXISTING_PATH_2} has been switched failed.\n";
		     }#end else

		      #4. Change the group of the log file to 'users' to let the log file downloaded
			  my $changeGroupCommand = "chgrp users $logFile";
		      my $logFileChangedGroupFlag = system("$changeGroupCommand");
              if($logFileChangedGroupFlag == 0){
                print LOG "The Restart Child Loader on TAP Server - The Group of the Log File: {$logFile} has been changed to 'users' successfully.\n";  
		      }#end if($logFileChangedGroupFlag == 0)
		      else{
		        $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		        if($operationFailedComments ne ""){
		          $operationFailedComments.="The Group of the Log File: {$logFile} has been changed to 'users' failed.<br>";  
		        }#end if($operationFailedComments ne "")
		        else{
		          $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                  $operationFailedComments.="The Group of the Log File: {$logFile} has been changed to 'users' failed.<br>";
		        }#end else
		        print LOG "The Restart Child Loader on TAP Server - The Group of the Log File: {$logFile} has been changed to 'users' failed.\n";
		      }#end else

			  #5. Set Operation Success Specail Comments to include Log File Value
			  if($operationResultFlag == $OPERATION_SUCCESS){
                $operationSuccessSpecialFlag = $TRUE;
			    $operationSuccessSpecialComments = $DONE_COMMENTS."<br>";
                $operationSuccessSpecialComments.="The Log File {$logFile} has been successfully generated.";
				print LOG "The Restart Child Loader on TAP Server - The Operation Success Special Comments: $operationSuccessSpecialComments\n";
    		  }#end if($operationResultFlag == $OPERATION_SUCCESS)
		   }#end if($operationResultFlag == $OPERATION_SUCCESS)
	     }#end if($inputParameterValuesValidationFlag == $TRUE)
       }#end if($operationResultFlag == $OPERATION_SUCCESS)
       
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $RESTART_CHILD_LOADER_ON_TAP_SERVER) 
    #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
	#Added by Larry for System Support And Self Healing Service Components - Phase 4 Start
	elsif($operationNameCode eq $RESTART_IBMIHS_ON_TAP_SERVER){#RESTART_IBMIHS_ON_TAP_SERVER
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }

       my $calculateIBMIHSRunningCount;#var used to store IBMIHS running count
	   my @ibmIHSRunningProcessIdList;#array used to store IBMIHS running process id list
       
	   #1. Check if there are some running processes for IBM IHS Server, if so, then kill them first.
       $calculateIBMIHSRunningCount = `$CALCULATE_IBMIHS_RUNNING_COUNT`;
	   print LOG "The Restart IBM HTTP Server on TAP Server - The Unix Command {$CALCULATE_IBMIHS_RUNNING_COUNT} has been executed.\n";    
       chomp($calculateIBMIHSRunningCount);#Remove the return line char
	   trim($calculateIBMIHSRunningCount);#Remove space chars 
       if($calculateIBMIHSRunningCount <=0){
	     print LOG "The Restart IBM HTTP Server on TAP Server - The IBM HTTP Server is not running currently.\n";    
	   }
	   else{
	     print LOG "The Restart IBM HTTP Server on TAP Server - There are {$calculateIBMIHSRunningCount} IBM HTTP Server Processes are running.\n";
		 
		 @ibmIHSRunningProcessIdList = `$GET_IBMIHS_RUNNING_PROCESS_ID_LIST`;
		 print LOG "The Restart IBM HTTP Server on TAP Server - The Unix Command {$GET_IBMIHS_RUNNING_PROCESS_ID_LIST} has been executed.\n";    
		 my $ibmIHSRunningPidIndex = 1;
		 foreach my $ibmIHSRunningProcessId(@ibmIHSRunningProcessIdList){
		   chomp($ibmIHSRunningProcessId);#remove the return line char
		   trim($ibmIHSRunningProcessId);#Remove space chars
		   print LOG "The Restart IBM HTTP Server on TAP Server - [$ibmIHSRunningPidIndex]PID: {$ibmIHSRunningProcessId} needs to be killed for IBM HTTP Server.\n";
           my $cmdExecResult = system("kill -9 $ibmIHSRunningProcessId");
		   if($cmdExecResult == 0){
             print LOG "The Restart IBM HTTP Server on TAP Server - PID: {$ibmIHSRunningProcessId} has been killed successfully for IBM HTTP Server.\n";
           }
		   else{
			 print LOG "The Restart IBM HTTP Server on TAP Server - PID: {$ibmIHSRunningProcessId} has been killed failed for IBM HTTP Server.\n";
		   }
           $ibmIHSRunningPidIndex++;
	     }#end foreach my $ibmIHSRunningProcessId(@ibmIHSRunningProcessIdList)
       }#end else

       #2. Start IBMIHS Server
	   if($SERVER_MODE eq $TAP2){#TAP2 Testing Server
	     `$START_IBMIHS_SERVER_ON_TAP2_SERVER`;
         print LOG "The Restart IBM HTTP Server on TAP Server - The Unix Command {$START_IBMIHS_SERVER_ON_TAP2_SERVER} has been executed.\n";
	   }
	   elsif($SERVER_MODE eq $TAP){#TAP PROD Server
	     `$START_IBMIHS_SERVER_ON_TAP_SERVER`;
         print LOG "The Restart IBM HTTP Server on TAP Server - The Unix Command {$START_IBMIHS_SERVER_ON_TAP_SERVER} has been executed.\n";
	   }
       
	   #3. Check if the IBMIHS Server has been restart successfully or not
       $calculateIBMIHSRunningCount = `$CALCULATE_IBMIHS_RUNNING_COUNT`;
	   print LOG "The Restart IBM HTTP Server on TAP Server - The Unix Command {$CALCULATE_IBMIHS_RUNNING_COUNT} has been executed.\n";    
       chomp($calculateIBMIHSRunningCount);#Remove the return line char
	   trim($calculateIBMIHSRunningCount);#Remove space chars 
       if($calculateIBMIHSRunningCount <=0){
         $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
         $operationFailedComments.="The IBM HTTP Server on TAP Server has been restarted failed.<br>";
		 $operationFailedComments.="Please check the IBM HTTP Server log to find failed reason and fix issue."; 
	     print LOG "The Restart IBM HTTP Server on TAP Server - The IBM HTTP Server on TAP Server has been restarted failed.\n";
	   }
	   else{
		 print LOG "The Restart IBM HTTP Server on TAP Server - The IBM HTTP Server on TAP Server has been restarted successfully.\n";    
	     print LOG "The Restart IBM HTTP Server on TAP Server - There are {$calculateIBMIHSRunningCount} IBM HTTP Server Processes are running.\n";
	   }
	  
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $RESTART_IBMIHS_ON_TAP_SERVER)
    #Added by Larry for System Support And Self Healing Service Components - Phase 4 End
    #Added by Larry for System Support And Self Healing Service Components - Phase 5 Start
    elsif($operationNameCode eq $RESTART_BRAVO_WEB_APPLICATION#RESTART_BRAVO_WEB_APPLICATION
		||$operationNameCode eq $RESTART_TRAILS_WEB_APPLICATION#RESTART_TRAILS_WEB_APPLICATION
	){
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
       
	   #Vars	  
	   my $telnet;#var used to store telnet Object
       my @msgReturnLines;#array used to store telnet return messages
       my $targetHostServer;#var used to store target web application host server
       my $executeStopCommand;#var used to store execute stop command
       my $executeStartCommand;#var used to store execute start command
       my $executeResultValue;#var used to store the execute result value
	   my $telnetUserId;#var used to store telnet userid
       my $telnetPassword;#var used to store telnet password
	   my $dumpFileFolder;#var used to store dump file folder

       #Business Logic Code started from here
	   if($SERVER_MODE eq $TAP2){#TAP2 Testing Server
		  $targetHostServer = $TAPMF_HOST_SERVER;
          $telnetUserId = $TAPMF_SERVER_USERID;
          $telnetPassword = $TAPMF_SERVRE_PASSWORD;
          $dumpFileFolder = $TAPMF_DUMP_FILE_FOLDER;
		}#end if($SERVER_MODE eq $TAP2)
		elsif($SERVER_MODE eq $TAP){#TAP PROD Server
		  if($operationNameCode eq $RESTART_BRAVO_WEB_APPLICATION){#Restart Bravo Web Application Operation
			$targetHostServer = $BRAVO_HOST_SERVER;
			$telnetUserId = $BRAVO_SERVER_USERID;
            $telnetPassword = $BRAVO_SERVRE_PASSWORD;
            $dumpFileFolder = $BRAVO_DUMP_FILE_FOLDER;
		  }
		  elsif($operationNameCode eq $RESTART_TRAILS_WEB_APPLICATION){#Restart Trails Web Application Operation
			$targetHostServer = $TRAILS_HOST_SERVER;
			$telnetUserId = $TRAILS_SERVER_USERID;
            $telnetPassword = $TRAILS_SERVRE_PASSWORD;
            $dumpFileFolder = $TRAILS_DUMP_FILE_FOLDER;
		  }
		}#end elsif($SERVER_MODE eq $TAP)
		printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Host Server: {$targetHostServer}.");
		printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - Telnet the Remote {$targetHostServer} Server started.");

		if($operationNameCode eq $RESTART_BRAVO_WEB_APPLICATION){#Restart Bravo Web Application Operation
		  $executeStopCommand = $STOP_TOMCAT_FOR_BRAVO;
		  $executeStartCommand = $START_TOMCAT_FOR_BRAVO;
		}#end if($operationNameCode eq $RESTART_BRAVO_WEB_APPLICATION)
		elsif($operationNameCode eq $RESTART_TRAILS_WEB_APPLICATION){#Restart Trails Web Application Operation
		  $executeStopCommand = $STOP_TOMCAT_FOR_TRAILS;
		  $executeStartCommand = $START_TOMCAT_FOR_TRAILS;
		}#end elsif($operationNameCode eq $RESTART_TRAILS_WEB_APPLICATION)
		printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Execute Stop Command: {$executeStopCommand} has been set.");
		printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Execute Start Command: {$executeStartCommand} has been set.");

		#Create Telnet Object
		$telnet=new Net::Telnet('Host'=>$targetHostServer
							   ,'Port'=>$PORT);

		#Set Timeout Time
		$telnet->timeout($COMMAND_MONITOR_TIMEOUT);

		#Set Error Return Code
		$telnet->errmode($RETURN_ERROR_MODE);

		#Set Telnet Object Log Parameters
		$telnet->dump_log($TELNET_DUMP_FILE);
		$telnet->output_log($TELNET_OUTPUT_FILE);
		$telnet->input_log($TELNET_INPUT_FILE);
		$telnet->option_log($TELNET_OPTION_FILE);

		$telnet->waitfor($MATCH=>$LOGIN) or &error("Match Telnet Return Message for Login Userid with Regex String {$LOGIN}",$telnet->errmsg);

		if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 1
		  $telnet->print($telnetUserId);#Login Userid
		  printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Userid {$telnetUserId} has been set to login the Remote {$targetHostServer} Server.");

		  $telnet->waitfor($MATCH=>$PASSWORD) or &error("Match Telnet Return Message for Login Password with Regex String {$PASSWORD}",$telnet->errmsg);
		  if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 2
			$telnet->print($telnetPassword);#Login Password
			printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Password {$telnetPassword} has been set to login the Remote {$targetHostServer} Server.");
			printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - Login the Remote {$targetHostServer} Server Successfully.");

			#Set the Shell Term Type
			$telnet->waitfor($PROMPT) or &error("Match Telnet Return Message for Shell Term Type with Regex String {$PROMPT}",$telnet->errmsg); 
			if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 3
			  $telnet->print($SHELL_XTERM_TYPE);
			 
			  #Change to the target dump file folder
              $telnet->waitfor($PROMPT) or &error("Match Telnet Return Message for Basic Input Line with Regex String {$PROMPT}",$telnet->errmsg);

			  if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 3A
                $telnet->print("cd $dumpFileFolder");
                printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Dump File Folder {$dumpFileFolder} has been switched on {$targetHostServer} Server.");

			    #Execute the Stop Tomcat for Bravo/Trails Unix Command
			    $telnet->waitfor($PROMPT) or &error("Match Telnet Return Message for Basic Input Line with Regex String {$PROMPT}",$telnet->errmsg);

			    if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 4
				  $telnet->print($executeStopCommand);

				  $telnet->waitfor($MATCH=>$PASSWORD) or &error("Match Telnet Return Message for Sudo Password with Regex String {$PASSWORD}",$telnet->errmsg);

				  if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 5
				    $telnet->print($telnetPassword);#Login Password

				    @msgReturnLines = $telnet->waitfor($PROMPT) or &error("Match Telnet Return Message for Web Application Stop Status with Regex String {$PROMPT}",$telnet->errmsg);
                    printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Web Application Stop Messages have been returned successfully.");
				   
				    if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 6
					  my $msgReturnLineIndex = 1;
					  my $successStringPosition;
					  $executeResultValue = $EXECUTE_FAIL;#set the initail value to be fail
				   
					  foreach my $msgReturnLine(@msgReturnLines){
					    chomp($msgReturnLine);
					    print LOG "The Restart Remote Bravo/Tails Web Application - The Web Application Stop Message Return Line[$msgReturnLineIndex]: {$msgReturnLine}\n";
					    $msgReturnLineIndex++;
					  
					    $successStringPosition = index($msgReturnLine,$EXECUTE_SUCCESS_STRING);
					    if($successStringPosition!=-1){
						  $executeResultValue = $EXECUTE_SUCCESS;
						  last;
					    }#end if($successStringPosition!=-1)
					  }#end foreach my $msgReturnLine(@msgReturnLines)

					  if($executeResultValue == $EXECUTE_SUCCESS){
					     printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Execute Stop Command {$executeStopCommand} has been executed successfully.");
		 
					     #Execute the Start Tomcat for Bravo/Trails Unix Command 
					     $telnet->print($executeStartCommand);
					     @msgReturnLines = $telnet->waitfor($PROMPT) or &error("Match Telnet Return Message for Web Application Start Status with Regex String {$PROMPT}",$telnet->errmsg);
                         printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Web Application Start Messages have been returned successfully.");
				
              	         if($operationErrorFlag == $FALSE){#$operationErrorFlag == $FALSE - 7
						   my $msgReturnLineIndex = 1;
						   my $successStringPosition;
						   $executeResultValue = $EXECUTE_FAIL;#set the initail value to be fail

						   foreach my $msgReturnLine(@msgReturnLines){
						     chomp($msgReturnLine);
						     print LOG "The Restart Remote Bravo/Tails Web Application - The Web Application Start Message Return Line[$msgReturnLineIndex]: {$msgReturnLine}\n";
						     $msgReturnLineIndex++;
						  
						     $successStringPosition = index($msgReturnLine,$EXECUTE_SUCCESS_STRING);
						     if($successStringPosition!=-1){
						 	   $executeResultValue = $EXECUTE_SUCCESS;
						 	   last;
						     }#end if($successStringPosition!=-1)
						   }#end foreach my $msgReturnLine(@msgReturnLines)
						
						   if($executeResultValue == $EXECUTE_SUCCESS){ 
						     printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Execute Start Command {$executeStartCommand} has been executed successfully.");
						   }#end if($executeResultValue == $EXECUTE_SUCCESS)
						   else{
						     $operationErrorFlag = $TRUE;
					         $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                             $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                             $operationFailedComments.="The Target Execute Start Command {$executeStartCommand} has been executed failed.";
						     printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Execute Start Command {$executeStartCommand} has been executed failed.");
					       }
					     }#end if($operationErrorFlag == $FALSE) - 7
					   }#end if($executeResultValue == $EXECUTE_SUCCESS)
					   else{
					      $operationErrorFlag = $TRUE;
						  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
                          $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
                          $operationFailedComments.="The Target Execute Stop Command {$executeStopCommand} has been executed failed.";
						  printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Target Execute Stop Command {$executeStopCommand} has been executed failed.");
				       }
				    }#$operationErrorFlag == $FALSE - 6
				  }#$operationErrorFlag == $FALSE - 5
			    }#$operationErrorFlag == $FALSE - 4
              }#$operationErrorFlag == $FALSE - 3A 
			}#$operationErrorFlag == $FALSE - 3   
		  }#$operationErrorFlag == $FALSE - 2
		}#$operationErrorFlag == $FALSE - 1

		if($operationErrorFlag == $FALSE){
		  printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Remote Web Application Restart Operation has been finished successfully.");
		}else{
		  printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Remote Web Application Restart Operation has been finished failed.");
		}

	   #Sleep 300 seconds to make sure the sudo password expired for every time to run 
	   sleep 300;
	
       $telnet->print("exit");
	   $telnet->close();

	   printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - Telnet the Remote {$targetHostServer} Server ended.");
	   #Business Logic Code ended from here
 
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $RESTART_BRAVO_WEB_APPLICATION || $operationNameCode eq $RESTART_TRAILS_WEB_APPLICATION)
    #Added by Larry for System Support And Self Healing Service Components - Phase 5 End
	#Added by Larry for System Support And Self Healing Service Components - Phase 6 Start
	elsif($operationNameCode eq $STAGING_BRAVO_DATA_SYNC#STAGING_BRAVO_DATA_SYNC
	){
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }

       my $relatedTicketNumber;#var used to store related ticket number - For example: TI30620-56800
	   my $accountNumber;#var used to store account number - For example: 135120
	   my $hostname;#var used to store hostname - For example: zhysztpc
	   my $logFile;#var used to store log file - For example: /var/staging/logs/stagingSyncGENAdvance/stagingSyncGENAdvanceChild.log.135120
       my $inputParameterValuesValidationFlag = $TRUE;#var used to store input parameter values validation flag - set $TRUE as the default value
	   my $processedInvokedCommand;#var used to store processed invoked command

	   $relatedTicketNumber = $operationParameter1;
	   print LOG "The Staging Bravo Data SYNC - The Operation Parameter - The Related Ticket Number: {$relatedTicketNumber}\n";
       
	   #Account Number Validation Check
	   $accountNumber = $operationParameter2;
	   print LOG "The Staging Bravo Data SYNC - The Operation Parameter - The Account Number: {$accountNumber}\n";
	   my $certainAccountNumberCountNumber = getCountNumberForCertainAccountNumberFunction($bravoConnection,$accountNumber);
	   if($certainAccountNumberCountNumber == 0){
		 $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 if($operationFailedComments ne ""){
		   $operationFailedComments.="There is no account defined with account number: {$accountNumber}<br>";  
		 }#end if($operationFailedComments ne "")
		 else{
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		   $operationFailedComments.="There is no account defined with account number: {$accountNumber}<br>";
		 }#end else
		 print LOG "The Staging Bravo Data SYNC - There is no account defined with account number: {$accountNumber}\n";
	   }#end if($certainAccountNumberCountNumber == 0)
	   elsif($certainAccountNumberCountNumber == 1){
		 print LOG "The Staging Bravo Data SYNC - There is one account defined with account number: {$accountNumber}\n";
	   }#end elsif($certainAccountNumberCountNumber == 1)
	   else{
		 $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 if($operationFailedComments ne ""){
		   $operationFailedComments.="There are more than one account defined with account number: {$accountNumber}<br>";  
		 }#end if($operationFailedComments ne "")
		 else{
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		   $operationFailedComments.="There are more than one account defined with account number: {$accountNumber}<br>";
		 }#end else
		 print LOG "The Staging Bravo Data SYNC - There are more than one account defined with account number: {$accountNumber}\n";
	   }#end else
 
	     #Account Number and Host Name Validation Check
         $hostname = $operationParameter3;
	     print LOG "The Staging Bravo Data SYNC - The Operation Parameter - The Hostname: {$hostname}\n";
	   if($hostname ne ""){
         my $countNumberForCertainAccountNumberAndHostname = getCountNumberForCertainAccountNumberAndHostnameFunction($bravoConnection,$accountNumber,$hostname);
         if($countNumberForCertainAccountNumberAndHostname == 0){
		   $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		   $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="There is no software lpar defined with account number: {$accountNumber} and hostname: {$hostname}<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		     $operationFailedComments.="There is no software lpar defined with account number: {$accountNumber} and hostname: {$hostname}<br>";
		   }#end else
		   print LOG "The Staging Bravo Data SYNC - There is no software lpar defined with account number: {$accountNumber} and hostname: {$hostname}\n";
	     }#end if($countNumberForCertainAccountNumberAndHostname == 0)
	     elsif($countNumberForCertainAccountNumberAndHostname == 1){
		   print LOG "The Staging Bravo Data SYNC - There is one software lpar defined with account number: {$accountNumber} and hostname: {$hostname}\n";
	     }#end elsif($countNumberForCertainAccountNumberAndHostname == 1)
	     else{
		   $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		   $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="There are more than one software lpar defined with account number: {$accountNumber} and hostname: {$hostname}<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		     $operationFailedComments.="There are more than one software lpar defined with account number: {$accountNumber} and hostname: {$hostname}<br>";
		   }#end else
		   print LOG "The Staging Bravo Data SYNC - There are more than one software lpar defined with account number: {$accountNumber} and hostname: {$hostname}\n";
	     }#end else
	   }#end if($hostname ne "")
	  
	   $logFile = $STAGING_BRAVO_DATA_SYNC_DEFAULT_LOG_PATH.$STAGING_BRAVO_DATA_SYNC_DEFAULT_LOG_NAME_PREFIX.".".$accountNumber;
	   print LOG "The Staging Bravo Data SYNC - The Default Log File: {$logFile} has been set.\n";
   
       #If all the input parameter values are valid, then invokes the target 'Staging Bravo Data SYN Script'  
	   if($inputParameterValuesValidationFlag == $TRUE){
		 #1. Generate the target processed invoked command - For example: "./misc/stagingSyncGENAdvanceChild.pl -a 135120 -h zhysztpc -l /var/staging/logs/stagingSyncGENAdvance/stagingSyncGENAdvance.log.135120"
	     $processedInvokedCommand = "";
         $processedInvokedCommand.=$STAGING_BRAVO_DATA_SYNC_SCRIPT_PATH_NAME;#append "./misc/stagingSyncGENAdvanceChild.pl"
         $processedInvokedCommand.=" $STAGING_BRAVO_DATA_SYNC_SCRIPT_ACCOUNT_NUMBER_MAKR $accountNumber";#append "-a 135120"
		 if($hostname ne ""){
		   $processedInvokedCommand.=" $STAGING_BRAVO_DATA_SYNC_SCRIPT_HOSTNAME_MAKR $hostname";#append "-h zhysztpc" 
		 }
         $processedInvokedCommand.=" $STAGING_BRAVO_DATA_SYNC_SCRIPT_LOG_FILE_MAKR $logFile";#append "-l /var/staging/logs/stagingSyncGENAdvance/stagingSyncGENAdvance.log.135120"
         print LOG "The Staging Bravo Data SYNC - The Processed Invoked Command {$processedInvokedCommand}\n";

		 #2. Invoke the target processed command  
		 #Switch to the /opt/staging/v2 folder first
		 my $switchFolderCmdExecResult = system('cd $STAGING_BRAVO_DATA_SYNC_SCRIPT_HOME_PATH');
		 if($switchFolderCmdExecResult == 0){
		   print LOG "The Staging Bravo Data SYNC - The Target Folder: {$STAGING_BRAVO_DATA_SYNC_SCRIPT_HOME_PATH} has been switched successfully.\n";
		   #Invoke the target staging bravo data sync script
		   my $invokeStagingBravoDataSYNCScriptCmdExecResult = system("$processedInvokedCommand");
		   if($invokeStagingBravoDataSYNCScriptCmdExecResult == 0){
			 print LOG "The Staging Bravo Data SYNC - The Processed Invoked Command: {$processedInvokedCommand} has been executed successfully.\n";
           }#end if($invokeStagingBravoDataSYNCScriptCmdExecResult == 0)
		   else{
			 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
			 if($operationFailedComments ne ""){
			   $operationFailedComments.="The Processed Invoked Command: {$processedInvokedCommand} has been executed failed.<br>";  
			 }#end if($operationFailedComments ne "")
			 else{
			   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
			   $operationFailedComments.="The Processed Invoked Command: {$processedInvokedCommand} has been executed failed.<br>";
			 }#end else 
			 print LOG "The Staging Bravo Data SYNC - The Processed Invoked Command: {$processedInvokedCommand} has been executed failed.\n";
		   }#end else   
		 }#end if($switchFolderCmdExecResult == 0)
		 else{
		   $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
			 $operationFailedComments.="The Target Folder: {$STAGING_BRAVO_DATA_SYNC_SCRIPT_HOME_PATH} has been switched failed.<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
			 $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
			 $operationFailedComments.="The Target Folder: {$STAGING_BRAVO_DATA_SYNC_SCRIPT_HOME_PATH} has been switched failed.<br>";
		   }#end else 
		   print LOG "The Staging Bravo Data SYNC - The Target Folder: {$STAGING_BRAVO_DATA_SYNC_SCRIPT_HOME_PATH} has been switched failed.\n";
		 }#end else
         
		 #3. Change the group of the log file to 'users' to let the log file downloaded
		 my $changeGroupCommand = "chgrp users $logFile";
		 my $logFileChangedGroupFlag = system("$changeGroupCommand");
		 if($logFileChangedGroupFlag == 0){
		   print LOG "The Staging Bravo Data SYNC - The Group of the Log File: {$logFile} has been changed to 'users' successfully.\n";  
		 }#end if($logFileChangedGroupFlag == 0)
		 else{
		   $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="The Group of the Log File: {$logFile} has been changed to 'users' failed.<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
			 $operationFailedComments.="The Group of the Log File: {$logFile} has been changed to 'users' failed.<br>";
		   }#end else
		   print LOG "The Staging Bravo Data SYNC - The Group of the Log File: {$logFile} has been changed to 'users' failed.\n";
		 }#end else

         #Added by Larry for System Support And Self Healing Service Components - Phase 6A Start
		 #3.1 Copy the target log file to the GSA Log Shared Folder Path
		 #The parameter 'auto_yes'=>1 is used to set the default value 'yes' for question "Are you sure you want to continue connecting (yes/no)?" when the program accesses the target server the first time
		 eval{
		   my $scpe = Net::SCP::Expect->new('auto_yes'=>1);
           $scpe->login($GSA_USERID,$GSA_PASSWORD);  
           $scpe->scp($logFile,"$GSA_SERVER:$GSA_LOG_SHARED_FOLDER_PATH");
           print LOG "The Staging Bravo Data SYNC - The Log File {$logFile} has been copied to the GSA SSE Shared Log Folder Path {$GSA_WEB_HTTPS_LOG_SHARED_FOLDER_PATH} successfully.\n";
		 };
		 if($@){
           $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="The Log File {$logFile} has been copied to the GSA SSE Shared Log Folder Path {$GSA_WEB_HTTPS_LOG_SHARED_FOLDER_PATH} failed.<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
			 $operationFailedComments.="The Log File {$logFile} has been copied to the GSA SSE Shared Log Folder Path {$GSA_WEB_HTTPS_LOG_SHARED_FOLDER_PATH} failed.<br>";
		   }#end else
		   print LOG "The Staging Bravo Data SYNC - The Log File {$logFile} has been copied to the GSA SSE Shared Log Folder Path {$GSA_WEB_HTTPS_LOG_SHARED_FOLDER_PATH} failed.\n";  
		 }#end if($@)
		 #Added by Larry for System Support And Self Healing Service Components - Phase 6A End

		 #4. Set Operation Success Specail Comments to include Log File Value
		 if($operationResultFlag == $OPERATION_SUCCESS){
		   $operationSuccessSpecialFlag = $TRUE;
		   $operationSuccessSpecialComments = $DONE_COMMENTS."<br>";
		   $operationSuccessSpecialComments.="The Log File {$logFile} has been successfully generated.<br>";
		   #Added by Larry for System Support And Self Healing Service Components - Phase 6A Start
		   $operationSuccessSpecialComments.="This Log File has also been copied to the GSA SSE Shared Log Folder Path:<br>";
           $operationSuccessSpecialComments.="{$GSA_WEB_HTTPS_LOG_SHARED_FOLDER_PATH}";
		   #Added by Larry for System Support And Self Healing Service Components - Phase 6A End
		   
		   print LOG "The Staging Bravo Data SYNC - The Operation Success Special Comments: $operationSuccessSpecialComments\n";
		 }#end if($operationResultFlag == $OPERATION_SUCCESS)
	   }#end if($inputParameterValuesValidationFlag == $TRUE)

	   $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $STAGING_BRAVO_DATA_SYNC)
	#Added by Larry for System Support And Self Healing Service Components - Phase 6 End
	#Added by Larry for System Support And Self Healing Service Components - Phase 7 Start
    elsif($operationNameCode eq $ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE){#ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
	    
  	   my $relatedTicketNumber;#var used to store related ticket number - For example: TI30620-56800
	   my $reconQueueName;#var used to store recon queue name - For example: recon_installed_sw
	   my $reconQueueUpperCaseName;#var used to store upper case recon queue name - For example: RECON_INSTALLED_SW
	   my $relatedIdList;#var used to store related id list - For example: recon installed software id - 103590
	   my $inputParameterValuesValidationFlag = $TRUE;#var used to store input parameter values validation flag - set $TRUE as the default value
	   my $processedInvokedCommand;#var used to store processed invoked command

	   my $customerId = ''; 
	   my $objectId;
	   my $action;
	   my $insertion;
	   my $queryname;
	   my $insername;
	   my $querystatement;
	   my $inserstatement;
	   my $queryreconname;
	   my $queryrecons;
	   my $objectname;
              
       my @existedIdsArray = ();
	   my @successInsertIdsArray = ();
	   my @failInsertIdsArray = ();
	   my @finishedIdsArray = ();

	   $relatedTicketNumber = $operationParameter1;
	   print LOG "The Add Specific Account Related Id List Into Recon Queue - The Operation Parameter - The Related Ticket Number: {$relatedTicketNumber}\n";
       
	   #Recon Queue Name Validation Check
       $reconQueueName = $operationParameter2;
	   print LOG "The Add Specific Account Related Id List Into Recon Queue - The Operation Parameter - The Recon Queue Name: {$reconQueueName}\n";
	   $reconQueueUpperCaseName = uc($reconQueueName);#Upper case recon queue name - For example: change from 'recon_installed_sw' to 'RECON_INSTALLED_SW'

       if(exists($RECONTABLES{$reconQueueUpperCaseName})){
	     print LOG "The Add Specific Account Related Id List Into Recon Queue - The Input Recon Queue Name {$reconQueueName} is a valid Recon Queue Name.\n";     
	   }#end if(exists($RECONTABLES{$reconQueueName})
	   else{
	     $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 if($operationFailedComments ne ""){
		   $operationFailedComments.="The Input Recon Queue Name {$reconQueueName} is not a valid Recon Queue Name.<br>";  
		 }#end if($operationFailedComments ne "")
		 else{
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		   $operationFailedComments.="The Input Recon Queue Name {$reconQueueName} is not a valid Recon Queue Name.<br>";
		 }#end else
		 print LOG "The Add Specific Account Related Id List Into Recon Queue - The Input Recon Queue Name {$reconQueueName} is not a valid Recon Queue Name.\n";  
	   }

       #Related Id List Validation Check
       $relatedIdList = $operationParameter3;
	   print LOG "The Add Specific Account Related Id List Into Recon Queue - The Operation Parameter - The Related Id List: {$relatedIdList}\n";
       #Check if the input related Id List exists the invalid char
	   if(($relatedIdList=~/[a-zA-z!\@\#\$\%\^\&\*\(\) \-\=\_\+\[\]\{\}\;\"\:\'\<\>\.\?\/]/)
		 ||($relatedIdList eq ",")
		 ||($relatedIdList=~/^,/)
	     ||($relatedIdList=~/,$/)
	     ||(index($relatedIdList,",,")>-1)
	     ){
	     $inputParameterValuesValidationFlag = $FALSE;#Set input parameter values validation flag = FALSE
		 $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		 if($operationFailedComments ne ""){
		   $operationFailedComments.="The Input Related Id List {$relatedIdList} is not valid. The valid ones like these two examples: 111 or 111,222,333(Please note that if the Id List includes more than one id, they need to be linked using ',' char)<br>";  
		 }#end if($operationFailedComments ne "")
		 else{
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		   $operationFailedComments.="The Input Related Id List {$relatedIdList} is not valid. The valid ones like these two examples: 111 or 111,222,333(Please note that if the Id List includes more than one id, they need to be linked using ',' char)<br>";
		 }#end else
		 print LOG "The Add Specific Account Related Id List Into Recon Queue - The Input Related Id List {$relatedIdList} is not valid. The valid ones like these two examples: 111 or 111,222,333(Please note that if the Id List includes more than one id, they need to be linked using ',' char)\n";            
	   }#end if($relatedIdList=~/[a-zA-z!\@\#\$\%\^\&\*\(\) \-\=\_\+\[\]\{\}\;\"\:\'\<\>\.\?\/]/)
	   else{
	     print LOG "The Add Specific Account Related Id List Into Recon Queue - The Input Related Id List {$relatedIdList} Format is valid.\n";
	   }
       
	   #If all the necessary input parameter values are valid, then executes related recon records insert operation
       if($inputParameterValuesValidationFlag == $TRUE){
	     #1. Set recon insert operation related values
		 if($reconQueueUpperCaseName eq 'RECON_INSTALLED_SW'){ $objectname = 'installed_software';$queryname = 'seINstSwbyId'; $insername = 'isINstSwbyId' ; $queryreconname = 'queryReINstSw' ; $querystatement = $seINstSwbyId; $inserstatement = $isINstSwbyId ; $queryrecons = $queryReINstSw ;}
	     elsif($reconQueueUpperCaseName eq 'RECON_SW_LPAR'){ $objectname = 'software_lpar';$queryname = 'seSWLparbyId'; $insername = 'isSWLparbyId' ; $queryreconname = 'queryReSWLpar' ; $querystatement = $seSWLparbyId; $inserstatement = $isSWLparbyId ;  $queryrecons = $queryReSWLpar ;}
	     elsif($reconQueueUpperCaseName eq 'RECON_HW_LPAR'){ $objectname = 'hardware_lpar';$queryname = 'seHWLparbyId'; $insername = 'isHWLparbyId' ; $queryreconname = 'queryReHWLpar' ;$querystatement = $seHWLparbyId; $inserstatement = $isHWLparbyId ;  $queryrecons = $queryReHWLpar ;}
	     elsif($reconQueueUpperCaseName eq 'RECON_HARDWARE'){ $objectname = 'hardware';$queryname = 'seHWbyId'; $insername = 'isHWbyId' ; $queryreconname = 'queryReHW' ; $querystatement = $seHWbyId; $inserstatement = $isHWbyId ;  $queryrecons = $queryReHW ;}
	     elsif($reconQueueUpperCaseName eq 'RECON_SOFTWARE'){ $objectname = 'software';$queryname = 'seSWbyId'; $insername = 'isSWbyId' ; $queryreconname = 'queryReSW' ; $querystatement = $seSWbyId; $inserstatement = $isSWbyId ;  $queryrecons = $queryReSW ;}
	     elsif($reconQueueUpperCaseName eq 'RECON_CUSTOMER_SW'){ $objectname = 'schedule';$queryname = 'seCSSWbyId'; $insername = 'isCSSWbyId' ; $queryreconname = 'queryReCSSW' ; $querystatement = $seCSSWbyId; $inserstatement = $isCSSWbyId ;  $queryrecons = $queryReCSSW ;}
	     elsif($reconQueueUpperCaseName eq 'RECON_LICENSE'){ $objectname = 'license';$queryname = 'seLicbyId'; $insername = 'isLicbyId' ; $queryreconname = 'queryReLic' ; $querystatement = $seLicbyId; $inserstatement = $isLicbyId ;  $queryrecons = $queryReLic ;}

         my $tname = substr($reconQueueUpperCaseName,6);
		 $action = 'UPDATE';
	     $querystatement =~ s/\?/$relatedIdList/;
         print LOG "The Add Specific Account Related Id List Into Recon Queue - The Query Statement SQL: {$querystatement}\n";
		 my @rs = exec_sql_rs($bravoConnection,$queryname,$querystatement);
         if($#rs>0){
		   for my $i (0 .. $#rs){
	  	     next if $i == 0;
	  	     if($queryreconname eq 'queryReSW'){
		       $objectId = $rs[$i][0]; 
		     }#end if($queryreconname eq 'queryReSW')
	  	     else{
			   $customerId = $rs[$i][0];
			   $objectId = $rs[$i][1];
		     }#end else
	         
		     my @rd;
	         if($queryreconname eq 'queryReCSSW'){
	           @rd = exec_sql_rs($bravoConnection,$queryreconname,$queryrecons,$objectId,$customerId);
	         }#end if($queryreconname eq 'queryReCSSW')
		     else{
	           @rd = exec_sql_rs($bravoConnection,$queryreconname,$queryrecons,$objectId);	
	         }#end else

	         if($#rd>0){
	           print LOG "The Add Specific Account Related Id List Into Recon Queue - The Recon Record with customerId: {$customerId} and $tname\_Id: {$objectId} has already been in $reconQueueUpperCaseName queue.\n";
	           push @existedIdsArray,$objectId;
			   push @finishedIdsArray,$objectId;
			 }#end if($#rd>0)
		     else{
	           my $rc;
	     	   if($insername eq 'isSWbyId'){
	             $rc = exec_sql_rc($bravoConnection,$insername,$inserstatement,$objectId,$action);
	     	   }#end if($insername eq 'isSWbyId')
			   else{
	     	     $rc = exec_sql_rc($bravoConnection,$insername,$inserstatement,$objectId,$action,$customerId);
	     	   }#end else

	    	   if($rc==1){
                 print LOG "The Add Specific Account Related Id List Into Recon Queue - Insert Into $reconQueueUpperCaseName with customerId: {$customerId} and $tname\_Id: {$objectId} successfully.\n";
			     push @successInsertIdsArray,$objectId;
				 push @finishedIdsArray,$objectId;
			   }#if($rc==1)
			   else{
			     print LOG "The Add Specific Account Related Id List Into Recon Queue - Insert Into $reconQueueUpperCaseName with customerId: {$customerId} and $tname\_Id: {$objectId} failed.\n";
			     push @failInsertIdsArray,$objectId;
				 push @finishedIdsArray,$objectId;
			   }#end else
		     }#end else
		   }#end for my $i (0 .. $#rs)

		   #Generate Operation Success Specail Comments
		   if($operationResultFlag == $OPERATION_SUCCESS){
		     $operationSuccessSpecialFlag = $TRUE;
		     $operationSuccessSpecialComments = $DONE_COMMENTS."<br>";

			 #Generate Existed Id List Specail Comments
			 my $existedIdList = "";
			 my $existedIdIndex = 1;
			 my $existedIdListLength = scalar(@existedIdsArray);
			 if($existedIdListLength>0){
			   foreach my $existedId (@existedIdsArray){
			     if($existedIdIndex!=$existedIdListLength){
			       $existedIdList.="$existedId,";   
			     }#end if($existedIdIndex!=$existedIdListLength)
			     else{
			       $existedIdList.="$existedId";     
			     }#end else
                 $existedIdIndex++;
			   }#end foreach my $existedId (@existedIdsArray)
               print LOG "The Add Specific Account Related Id List Into Recon Queue - The Existed Id List in the Recon Queue: {$existedIdList}\n"; 
			   $operationSuccessSpecialComments.="The Existed Id List in the Recon Queue: {$existedIdList}<br>";
             }#end if($existedIdListLength>0)
			 
			 #Generate Success Insert Id List Specail Comments
			 my $successInsertIdList = "";
             my $successInsertIdIndex = 1;
			 my $successInsertIdListLength = scalar(@successInsertIdsArray);
			 if($successInsertIdListLength>0){
			   foreach my $successInsertId (@successInsertIdsArray){
			     if($successInsertIdIndex!=$successInsertIdListLength){
			       $successInsertIdList.="$successInsertId,";   
			     }#end if($successInsertIdIndex!=$successInsertIdListLength)
			     else{
			       $successInsertIdList.="$successInsertId";     
			     }#end else
                 $successInsertIdIndex++;
			   }#end foreach my $successInsertId (@successInsertIdsArray)
               print LOG "The Add Specific Account Related Id List Into Recon Queue - The Success Insert Id List to the Recon Queue: {$successInsertIdList}\n"; 
			   $operationSuccessSpecialComments.="The Success Insert Id List to the Recon Queue: {$successInsertIdList}<br>";
             }#end if($successInsertIdListLength>0)

             #Generate Fail Insert Id List Specail Comments
             my $failInsertIdList = "";
             my $failInsertIdIndex = 1;
			 my $failInsertIdListLength = scalar(@failInsertIdsArray);
			 if($failInsertIdListLength>0){
			   foreach my $failInsertId (@failInsertIdsArray){
			     if($failInsertIdIndex!=$failInsertIdListLength){
			       $failInsertIdList.="$failInsertId,";   
			     }#end if($failInsertIdIndex!=$failInsertIdListLength)
			     else{
			       $failInsertIdList.="$failInsertId";     
			     }#end else
                 $failInsertIdIndex++;
			   }#end foreach my $failInsertId (@failInsertIdsArray)
               print LOG "The Add Specific Account Related Id List Into Recon Queue - The Fail Insert Id List to the Recon Queue: {$failInsertIdList}\n"; 
			   $operationSuccessSpecialComments.="The Fail Insert Id List to the Recon Queue: {$failInsertIdList}<br>";
		     }#end if($failInsertIdListLength>0)

             #Generate Invalid Id List Specail Comments
             my @relatedIdListArray = split(/\,/,$relatedIdList);
			 my $existFlag = $FALSE;
			 my $invalidIdList = "";
			
		     foreach my $relatedId (@relatedIdListArray){
			   foreach my $finishedId (@finishedIdsArray){
                 if($relatedId eq $finishedId){
				   $existFlag = $TRUE;
				   last;
				 }#end if($relatedId eq $finishedId)
			   }# end foreach my $finishedId (@finishedIdsArray)

			   if($existFlag == $FALSE){
			     $invalidIdList.= "$relatedId,";
               }#end if($existFlag == $FALSE)

               $existFlag = $FALSE;#Reset existFlag value to False
			 }#end foreach my $relatedId (@relatedIdListArray)

			 #Only append Invalid Id List to the Special Comments when Invalid Id List has value
			 if(length($invalidIdList)>1){
               $invalidIdList = substr($invalidIdList,0,length($invalidIdList)-1);
               print LOG "The Add Specific Account Related Id List Into Recon Queue - The Input Id List: {$invalidIdList} is not valid due that these ids don't exist.\n"; 
			   $operationSuccessSpecialComments.="The Input Id List: {$invalidIdList} is not valid due that these ids don't exist.<br>";
             }

		     print LOG "The Add Specific Account Related Id List Into Recon Queue - The Operation Success Special Comments: $operationSuccessSpecialComments\n";
		   }#end if($operationResultFlag == $OPERATION_SUCCESS)
           
	  	 }#end if($#rs>0)
		 else{
		   $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   if($operationFailedComments ne ""){
		     $operationFailedComments.="There is no record existed based on the input Related Id List: {$relatedIdList}<br>";  
		   }#end if($operationFailedComments ne "")
		   else{
		     $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
		     $operationFailedComments.="There is no record existed based on the input Related Id List: {$relatedIdList}<br>";
		   }#end else
		   print LOG "The Add Specific Account Related Id List Into Recon Queue - There is no record existed based on the input Related Id List: {$relatedIdList}\n";      
		 }
	   }

       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT)
	#Added by Larry for System Support And Self Healing Service Components - Phase 7 End
    elsif($operationNameCode eq $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT){#DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
	  
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT)
    elsif($operationNameCode eq $COMPOSITE_BUILDER){#COMPOSITE_BUILDER
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
	  
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $COMPOSITE_BUILDER)
    elsif($operationNameCode eq $UPDATE_SW_LICENSES_STATUS){#UPDATE_SW_LICENSES_STATUS
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
	  
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $UPDATE_SW_LICENSES_STATUS)

    #Added by Tomas for System Support And Self Healing Service Components - Phase 8 - Start
    elsif($operationNameCode eq $REMOVE_CERTAIN_BANK_ACCOUNT){#REMOVE_CERTAIN_BANK_ACCOUNT
       if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
	     print LOG "Updating operation status\n";
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
       my $bankAccountName = $operationParameter2;
       my $connectionType  = $operationParameter3;
	   print LOG "Getting bank account ID from name\n";
       my $bankAccountID = getBankAccountID($bankAccountName,$connectionType,$bravoConnection);
       if($bankAccountID ne ""){ # there is exactly one bank account in the database
	   		print LOG "Bank account ID found\n";
       		deleteBankAccountFromStaging($bankAccountID);
       		deleteBankAccountFromTrails($bankAccountName);
       		if($connectionType eq "DISCONNECTED"){
	     		print LOG "Deleting files for disconnected bank account - start\n";
       			deleteDisconnectedFiles($bankAccountName);
	     		print LOG "Deleting files for disconnected bank account - end\n";
       		}
       }else{
		   print LOG "Multiple or 0 account IDs for given name and connection type";
	       $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		   $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
           $operationFailedComments.="Multiple or 0 account IDs for given name and connection type\n"; 
       } 

       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $REMOVE_CERTAIN_BANK_ACCOUNT)
#Added by Tomas for System Support And Self Healing Service Components - Phase 8 - End

    #A piece of code template which is used for 'New Operatoin' business logic
    #elsif($operationNameCode eq "SAMPLE_OPERATION_NAME_CODE"){#SAMPLE_OPERATION_NAME_CODE
	#  if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
    #    #Operation has been started to be processed
    #    updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
    #    $operationStartedFlag = $TRUE;#Operation has been started to process
    #  }
	#
	######Add 'New Operatoin' business logic here!!!###### 
	#
    #  $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	#  print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    #}
    ############THE ABOVE PIECE OF CODE IS THE OPERATION CORE BUSINESS LOGIC!!!!!!################################

    if(($selfHealingEngineInvokedMode eq $QUEUE_MODE)#Queue Mode
	 &&($operationStartedFlag == $TRUE)){#Operation has been started to process
	  if($operationResultFlag == $OPERATION_SUCCESS){#Operation has been finished to be processed successfully
	    #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
		if($operationSuccessSpecialFlag == $TRUE){
          updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_DONE_CODE,$operationSuccessSpecialComments,$parameterOperationId);	
		}#if($operationSuccessSpecialFlag == $TRUE)
		else{
	      updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_DONE_CODE,$DONE_COMMENTS,$parameterOperationId);	
	    }#end else
		#Added by Larry for System Support And Self Healing Service Components - Phase 3 End
      }
	  else{#Operation has been finished to be processed failed
	    updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_FAILED_CODE,$operationFailedComments,$parameterOperationId); 
	  }
    }
  };#end eval
  if($@){
    if($operationStartedFlag == $TRUE){#Operation has been started to process
      $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
      $operationFailedComments.= $@;
      updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_FAILED_CODE,$operationFailedComments,$parameterOperationId);
    }
	else{
	  print LOG "The Exception is happened due to reason: $@";
	}
	
  }#end if($@)
}#end sub coreOperationProcess

#This method is used to do Self Healing Engine Business Post Process for example, close db handlers, close file handers etc
sub postProcess{
  #Close Log File Handler
  close LOG; 
  #Disconnect DB
  $bravoConnection->disconnect;
  $stagingConnection->disconnect;
}

#This method is used to setup DB2 environment
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
   if($timeStampStyle == $STYLE1){#YYYY-MM-DD-HH.MM.SS For Example: 2013-06-18-10.30.33
      $currentTimeStamp = $dateObject->{fullTime1};
   }
   elsif($timeStampStyle == $STYLE2){#YYYYMMDDHHMMSS For Example: 20130618103033
      $currentTimeStamp = $dateObject->{fullTime2};
   }
   elsif($timeStampStyle == $STYLE3){#YYYYMMDD For Example: 20130618
      $currentTimeStamp = $dateObject->{fullTime3};
   }
   
   return $currentTimeStamp;
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
    $mon  = ($mon<10)?"0$mon":$mon;#Month[0,11]
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
             'fullTime2' => "$year$mon$mday$hour$min$sec",
		     'fullTime3' => "$year$mon$mday"
          };
}

#my $UPDATE_CERTAIN_OPERATION_STATUS_SQL = "UPDATE OPERATION_QUEUE SET OPERATION_STATUS = ?, OPERATION_UPDATE_TIME = CURRENT TIMESTAMP, COMMENTS = ? WHERE OPERATION_ID = ?";
#This method is used to update 
sub updateOperationFunction{
  my ($connection, $querySQL, $operationStatus, $operationComments, $operationId) = @_;
  $connection->prepareSqlQuery(queryUpdateOperation($querySQL));
  my $sth = $connection->sql->{updateOperation};
  eval{
	$currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
    print LOG "[$currentTimeStamp]Started to execute SQL: {$querySQL} with parameter values {Operation Status: $operationStatus + Operation Comments: $operationComments + Operation ID: $operationId}\n";
    $sth->execute($operationStatus,$operationComments,$operationId);
	$currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	print LOG "[$currentTimeStamp]Finished to execute SQL: {$querySQL}\n";
    $sth->finish;
  };
  if($@){
    print LOG "Database Exception happened due to reason: $@\n";
  }
}

sub queryUpdateOperation{
  my $query = shift;
  return ('updateOperation', $query);
}

sub getValidLoaderListOnTAPServer{
  my @vaildLoaderList = ();

  #TAP Loader List
  push @vaildLoaderList,"doranaToSwasset.pl";#1
  push @vaildLoaderList,"hdiskToStaging.pl";#2
  push @vaildLoaderList,"ipAddressToStaging.pl";#3
  push @vaildLoaderList,"manualToSwasset.pl";#4
  push @vaildLoaderList,"memModToStaging.pl";#5
  push @vaildLoaderList,"processorToStaging.pl";#6
  push @vaildLoaderList,"scanRecordToStaging.pl";#7
  push @vaildLoaderList,"softwareFilterToStaging.pl";#8
  push @vaildLoaderList,"softwareManualToStaging.pl";#9
  push @vaildLoaderList,"softwareSignatureToStaging.pl";#10
  push @vaildLoaderList,"softwareTlcmzToStaging.pl";#11
  push @vaildLoaderList,"swassetDataManager.pl";#12
  push @vaildLoaderList,"tlcmzToSwasset.pl";#13
  push @vaildLoaderList,"cndbReplication.pl";#14
  push @vaildLoaderList,"expiredMaintManager.pl";#15
  push @vaildLoaderList,"expiredScansManager.pl";#16
  push @vaildLoaderList,"scanRecordToLpar.pl";#17
  push @vaildLoaderList,"softwareDoranaToStaging.pl";#18
  push @vaildLoaderList,"licenseToBravo.pl";#19
  push @vaildLoaderList,"licTypeToBravo.pl";#20
  push @vaildLoaderList,"scanSoftwareItemToStaging.pl";#21
  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.6 Start
  push @vaildLoaderList,"atpToStaging.pl";#22
  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.6 End
  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7 Start
  push @vaildLoaderList,"swcmToStaging.pl";#23
  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.7 End
  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.8 Start
  push @vaildLoaderList,"capTypeToBravo.pl";#24
  #Added by Larry for System Support And Self Healing Service Components - Phase 1 - 1.0.8 End
  #push @vaildLoaderList,"testingTAP.pl";#25 #For testing function purpose only
  
  return @vaildLoaderList;
}

sub getValidLoaderListOnTAP3Server{
  my @vaildLoaderList = ();

  #TAP3 Loader List
  push @vaildLoaderList,"reconEngine.pl";#1
  push @vaildLoaderList,"softwareToBravo.pl";#2
  push @vaildLoaderList,"ipAddressToBravo.pl";#3
  push @vaildLoaderList,"memModToBravo.pl";#4
  push @vaildLoaderList,"hardwareToBravo.pl";#5
  push @vaildLoaderList,"hdiskToBravo.pl";#6
  push @vaildLoaderList,"processorToBravo.pl";#7
  push @vaildLoaderList,"swkbt";#8
  #push @vaildLoaderList,"testingTAP.pl";#9 #For testing function purpose only
  
  return @vaildLoaderList;
}

#This method is used to set DB2 ENV path
sub setDB2ENVPath{
    if($SERVER_MODE eq $TAP){#TAP Server
      $DB_ENV = "/db2/tap/sqllib/db2profile";
    }
	elsif($SERVER_MODE eq $TAP2){#TAP2 Server
	  $DB_ENV = "/home/tap/sqllib/db2profile";
	}
	elsif($SERVER_MODE eq $TAP3){#TAP3 Server
	  $DB_ENV = '/home/eaadmin/sqllib/db2profile';
	}
}

#Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
sub getValidChildLoaderListOnTAPServer{
  my @vaildChildLoaderList = ();

  #TAP Child Loader List
  push @vaildChildLoaderList,"hdiskToStagingChild.pl";#1
  push @vaildChildLoaderList,"ipAddressToStagingChild.pl";#2
  push @vaildChildLoaderList,"memModToStagingChild.pl";#3
  push @vaildChildLoaderList,"processorToStagingChild.pl";#4
  push @vaildChildLoaderList,"scanRecordToStagingChild.pl";#5
  push @vaildChildLoaderList,"softwareFilterToStagingChild.pl";#6
  push @vaildChildLoaderList,"softwareManualToStagingChild.pl";#7
  push @vaildChildLoaderList,"softwareSignatureToStagingChild.pl";#8
  push @vaildChildLoaderList,"softwareTlcmzToStagingChild.pl";#9
  push @vaildChildLoaderList,"softwareDoranaToStagingChild.pl";#10
  push @vaildChildLoaderList,"scanSoftwareItemToStagingChild.pl";#11

  return @vaildChildLoaderList;
}

#my $GET_COUNT_NUMBER_FOR_CERTAIN_BANK_ACCOUNT_NAME_SQL = "SELECT COUNT(*) FROM BANK_ACCOUNT WHERE NAME = ? WITH UR";
sub getCountNumberForCertainBankAccountNameFunction{
  my $connection = shift;
  my $bankAccountName = shift;
  my @countNumberRowForCertainBankAccountName;
  my $countNumberForCertainBankAccountName;
  
  $connection->prepareSqlQuery(queryCountNumberForCertainBankAccountName());
  my $sth = $connection->sql->{countNumberForCertainBankAccountName};

  $sth->execute($bankAccountName);
  @countNumberRowForCertainBankAccountName = $sth->fetchrow_array();
  $countNumberForCertainBankAccountName = $countNumberRowForCertainBankAccountName[0]; 
  $sth->finish;
  return $countNumberForCertainBankAccountName;
}

sub queryCountNumberForCertainBankAccountName{
  print LOG "[queryCountNumberForCertainBankAccountName] Query SQL: {$GET_COUNT_NUMBER_FOR_CERTAIN_BANK_ACCOUNT_NAME_SQL}\n";
  return ('countNumberForCertainBankAccountName', $GET_COUNT_NUMBER_FOR_CERTAIN_BANK_ACCOUNT_NAME_SQL);
}
#Added by Larry for System Support And Self Healing Service Components - Phase 3 End

#Added by Larry for System Support And Self Healing Service Components - Phase 5 Start
sub error
{
  my ($place,$reason)=@_;
  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
  $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
  $operationFailedComments.="$place: $reason.";
  printMessageWithTimeStamp("The Restart Remote Bravo/Tails Web Application - The Restart Web Appliction is failed due to reason: {$place: $reason}");
  $operationErrorFlag = $TRUE;
#For selfHealing Invoke Command Mode, return 1 as error value for HME call
  if($selfHealingEngineInvokedMode eq $COMMAND_MODE){
    exit 1;
  }
  
}

sub printMessageWithTimeStamp{
  my $message = shift;
  my $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
  my $messageWithTimeStamp = "[$currentTimeStamp]$message\n";
  print LOG $messageWithTimeStamp;
}
#Added by Larry for System Support And Self Healing Service Components - Phase 5 End

#Added by Larry for System Support And Self Healing Service Components - Phase 6 Start
#my $GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_SQL = "SELECT COUNT(*) FROM CUSTOMER WHERE ACCOUNT_NUMBER = ? AND STATUS = 'ACTIVE' WITH UR";
sub getCountNumberForCertainAccountNumberFunction{
  my $connection = shift;
  my $accountNumber = shift;
  my @countNumberRowForCertainAccountNumber;
  my $countNumberForCertainAccountNumber;
  
  $connection->prepareSqlQuery(queryCountNumberForCertainAccountNumber());
  my $sth = $connection->sql->{countNumberForCertainAccountNumber};

  $sth->execute($accountNumber);
  @countNumberRowForCertainAccountNumber = $sth->fetchrow_array();
  $countNumberForCertainAccountNumber = $countNumberRowForCertainAccountNumber[0]; 
  $sth->finish;
  return $countNumberForCertainAccountNumber;
}

sub queryCountNumberForCertainAccountNumber{
  print LOG "[queryCountNumberForCertainAccountNumber] Query SQL: {$GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_SQL}\n";
  return ('countNumberForCertainAccountNumber', $GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_SQL);
}

#Added by Tomas for System Support And Self Healing Service Components - Phase 8 - Start
sub deleteBankAccountFromTrails(){
  my $accountName = shift;
  my $connection = $bravoConnection;
  print LOG "Deleting bank account from TRAILS - start\n";
  $QUERY_DELETE_ACCOUNT_8 .= "'$accountName'"; # I know this is bad, I am sry, I am having weird bug when using normally binding values.
  $connection->prepareSqlQuery($accountName,$QUERY_DELETE_ACCOUNT_8);
  my $sth = $connection->sql->{$accountName};
  $sth->execute();
  $sth->finish;
  print LOG "Deleting bank account from TRAILS - end\n";
}

sub deleteBankAccountFromStaging(){
  print LOG "Deleting bank account from staging\n";
  my $accountID = shift;
  my $counter = 0; 
  my $connection = $stagingConnection;

  print LOG "Starting query 1\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_1);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $sth->finish;
    $counter = $sth->rows();
  }while($counter>0);

  print LOG "End of query 1\n";
  print LOG "Starting query 2\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_2);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $sth->finish;
    $counter = $sth->rows();
  }while($counter>0);

  print LOG "End of query 2\n";
  print LOG "Starting query 3\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_3);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $sth->finish;
    $counter = $sth->rows();
  }while($counter>0);

  print LOG "End of query 3\n";
  print LOG "Starting query 4\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_4);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $sth->finish;
    $counter = $sth->rows();
  }while($counter>0);

  print LOG "End of query 4\n";
  print LOG "Starting query 5\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_5);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $counter = $sth->rows();
    $sth->finish;
  }while($counter>0);

  print LOG "End of query 5\n";
  print LOG "Starting query 6\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_6);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $counter = $sth->rows();
    $sth->finish;
  }while($counter>0);

  print LOG "End of query 6\n";
  print LOG "Starting query 7\n";

  do{
    $connection->prepareSqlQuery($accountID,$QUERY_DELETE_ACCOUNT_7);
    my $sth = $connection->sql->{$accountID};
    $sth->execute($accountID);
    $counter = $sth->rows();
    $sth->finish;
  }while($counter>0);
  print LOG "End of query 7\n";

}

sub deleteDisconnectedFiles{
  my $accountName = shift;
  my $output = `rm /var/staging/disconnected/$accountName*`;
}

sub getBankAccountID{
  my $accountName = shift;
  my $connectionType = shift;
  my $connection= shift;

  $connection->prepareSqlQuery($accountName,$QUERY_ACCOUNT_ID_BY_NAME);
  my $sth = $connection->sql->{$accountName};
  $sth->execute($accountName,$connectionType);

  my @IDs = $sth->fetchrow_array();
  $sth->finish;
  my $countOfIDs = @IDs;
  if($countOfIDs == 1){
  	print LOG "Found id: $IDs[0]\n";
  	return $IDs[0]; 
  }
  return "";
	
}

#Added by Tomas for System Support And Self Healing Service Components - Phase 8 - End

#my $GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_AND_HOSTNAME_SQL = "SELECT COUNT(*) FROM SOFTWARE_LPAR SL, CUSTOMER C WHERE C.ACCOUNT_NUMBER = ? AND SL.NAME = ? AND C.CUSTOMER_ID = SL.CUSTOMER_ID AND C.STATUS = 'ACTIVE' AND SL.STATUS ='ACTIVE' WITH UR";
sub getCountNumberForCertainAccountNumberAndHostnameFunction{
  my $connection = shift;
  my $accountNumber = shift;
  my $hostname = shift;
  my @countNumberRowForCertainAccountNumberAndHostname;
  my $countNumberForCertainAccountNumberAndHostname;
  
  $connection->prepareSqlQuery(queryCountNumberForCertainAccountNumberAndHostname());
  my $sth = $connection->sql->{countNumberForCertainAccountNumberAndHostname};

  $sth->execute($accountNumber,$hostname);
  @countNumberRowForCertainAccountNumberAndHostname = $sth->fetchrow_array();
  $countNumberForCertainAccountNumberAndHostname = $countNumberRowForCertainAccountNumberAndHostname[0]; 
  $sth->finish;
  return $countNumberForCertainAccountNumberAndHostname;
}

sub queryCountNumberForCertainAccountNumberAndHostname{
  print LOG "[queryCountNumberForCertainAccountNumberAndHostname] Query SQL: {$GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_AND_HOSTNAME_SQL}\n";
  return ('countNumberForCertainAccountNumberAndHostname', $GET_COUNT_NUMBER_FOR_CERTAIN_ACCOUNT_NUMBER_AND_HOSTNAME_SQL);
}
#Added by Larry for System Support And Self Healing Service Components - Phase 6 End

#Added by Larry for System Support And Self Healing Service Components - Phase 7 Start
sub exec_sql_rs {
    my $dbconnection = shift;
    my $sqlname = shift;
    my $sql = shift;
    my $id = shift;
    my $customerId = shift;
    my @rs = ();
    
	$dbconnection->prepareSqlQuery($sqlname,$sql);
    my $sth = $dbconnection->sql->{$sqlname};
    if(defined $id && defined $customerId){
      $sth->execute($customerId,$id);
    }
	elsif(defined $id){
      $sth->execute($id);
    }
	else{
      $sth->execute();
    }
    
	push @rs,[@{$sth->{NAME}}];
    while(my @row = $sth->fetchrow_array()){
      push @rs,[@row];
    }
    
    return @rs;
}

sub exec_sql_rc {
    my $dbconnection = shift;
    my $sqlname = shift;
    my $sql = shift;
    my $objectId = shift;
    my $action =  shift;
    my $customerId = shift;    
    my $rc ;
   
    $dbconnection->prepareSqlQuery($sqlname,$sql);
    my $sth = $dbconnection->sql->{$sqlname};
    if(defined $customerId){
      $rc = $sth->execute($customerId,$objectId,$action);
    } 
	else{
      $rc = $sth->execute($objectId,$action);
    }
    
	$sth->finish();
   
    return $rc;
}
#Added by Larry for System Support And Self Healing Service Components - Phase 7 End