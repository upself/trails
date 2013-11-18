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
###################################################################################################################################################################################################
#                                            Phase 2 Development Formal Tag: 'Added by Larry for Self Healing Service Component - Phase 2'
# 2013-08-28  Liu Hai(Larry) 1.2.0           Self Healing Service Component - Phase 2: Restart Loader on TAP3 Server
# 2013-09-06  Liu Hai(Larry) 1.2.1           Self Healing Service Component - Phase 2: Add Post Check Support Feature to judge if the target loader has been restarted successfully or not
# 2013-09-30  Liu Hai(Larry) 1.2.2           Self Healing Service Component - Phase 2: For TAP3 Server, there is no root privilege granted. So the 'sudo' unix command needs to be used to get temp root privilege to execute special unix commands 
###################################################################################################################################################################################################
#                                            Phase 3 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 3'
# 2013-10-14  Liu Hai(Larry) 1.3.0           System Support And Self Healing Service Components - Phase 3 - Operation Parameters Input String whatever Operation Parameters have values or not. The Operation Parameters String has included 10 values using ^ char to seperate. For example: TI30326-36768^reconEngine.pl^^^^^^^^
#                                            System Support And Self Healing Service Components - Phase 3 - Add 'RESTART_CHILD_LOADER_ON_TAP_SERVER' Support Feature
# 2013-11-18  Liu Hai(Larry) 1.3.2           Add the feature support when the input operation parameters have ' ' space chars in them - For example - "Test 2". 
#                                            There is a bug found when there are ' ' space chars in operation parameters, then there is a parse error for Self Healing Engine to get the input Operation Parameters
#                                            Solution: replace all the ' ' chars using '~' special chars for temp and then convert them back for Self Healing Engine 
#
#

#Load required modules
use strict;
use DBI;
use Database::Connection;
use Base::ConfigManager;

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
my $FAILED_COMMENTS      = "This Operatoin is failed due to reason: ";
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
my $RESTART_IBMIHS_ON_TAP_SERVER              = "RESTART_IBMIHS_ON_TAP_SERVER";

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
my $RESTART_CHILD_LOADER_ON_TAP_SERVER_LOG_FILE_INDEX              = 4;#Log File(Required) - For example: /var/staging/logs/softwareFilterToStaging/softwareFilterToStaging.log.GTAASCCM

my $RESTART_CHILD_LOADER_INVOKED_COMMAND = "#1 -b #2 -f 12 -t 0 -d 1 -a 1 -l #3 -c #4";#var used to store Restart Child Loader Invoked Command
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
  my $operationResultFlag = $OPERATION_SUCCESS;#Set the init default value is "OPERATION_SUCCESS"
  my $operationFailedComments = "";#var used to store operation comments
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
		  #1. Find out and Kill all the parent and child processes for the target loader name - For example: "reconEngine.pl"
		  my @targetLoaderPids = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|awk '{print \$2}'`;
          my $targetLoaderPidsCnt = scalar(@targetLoaderPids);
		  if($targetLoaderPidsCnt == 0){
		    print LOG "The Restart Loader on TAP Server - There is no process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		  }
		  else{
		    print LOG "The Restart Loader on TAP Server - There are $targetLoaderPidsCnt processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";

		    my $targetLoaderPidIndex = 1;
		    foreach my $targetLoaderPid(@targetLoaderPids){
		      chomp($targetLoaderPid);#remove the return line char
		      trim($targetLoaderPid);#Remove space chars
		      print LOG "The Restart Loader on TAP Server - [$targetLoaderPidIndex]PID: {$targetLoaderPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";
              my $cmdExecResult = system("kill -9 $targetLoaderPid");
			  if($cmdExecResult == 0){
                print LOG "The Restart Loader on TAP Server - PID: {$targetLoaderPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";
              }
			  else{
			    print LOG "The Restart Loader on TAP Server - PID: {$targetLoaderPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";
			  }
              $targetLoaderPidIndex++;
		    }#end foreach my $targetLoaderPid(@targetLoaderPids)
		  }#end else
		  
          #2. Start target loader using loader full name - For exmaple: "/opt/staging/v2/reconEngine.pl"
		  $restartLoaderFullCommand = $loaderExistingPath;
          $restartLoaderFullCommand.= $restartLoaderName;
          $restartLoaderFullCommand.= " start";
		  print LOG "The Restart Loader on TAP Server - The Restart Loader Full Unix Command: {$restartLoaderFullCommand}\n";
		  my $restartLoaderFullCommandExecutedResult = system("$restartLoaderFullCommand");
          print LOG "The Restart Loader on TAP Server - The Unix Command {$restartLoaderFullCommand} executed result is {$restartLoaderFullCommandExecutedResult}\n";
		  if($restartLoaderFullCommandExecutedResult == 0){#Execute Successfully
            print LOG "The Restart Loader on TAP Server - The Unix Command {$restartLoaderFullCommand} has been executed successfully.\n";

			#Added by Larry for Self Healing Service Component - Phase 2 Start
			#Sleep 10 seconds to give the target loader startup time
			sleep 10;
            #Add Post Check Support Feature to judge if the target loader has been restarted successfully or not
			my $targetLoaderRunningProcessCnt = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|wc -l`;
			chomp($targetLoaderRunningProcessCnt);#remove the return line char
            $targetLoaderRunningProcessCnt--;#decrease the unix command itself from the total calculated target loader running process count
			if($targetLoaderRunningProcessCnt > 0){#The target loader has been restarted successfully case
			   print LOG "The Restart Loader on TAP Server - There are $targetLoaderRunningProcessCnt processes which have been created for the target loader {$restartLoaderName} to run.\n";
			   print LOG "The Restart Loader on TAP Server - The Target Loader {$restartLoaderName} has been restarted successfully.\n";
			}
			else{#The target loader has been started failed case
               $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		       $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
               $operationFailedComments.="The Target Loader {$restartLoaderName} has been restarted failed on TAP Server. Please contact AM developer to check this loader log to find the failed reason. Thanks!\n";
			   print LOG "The Restart Loader on TAP Server - There is no process which has been created for the target loader {$restartLoaderName} to run.\n";
			   print LOG "The Restart Loader on TAP Server - The Target Loader {$restartLoaderName} has been restarted failed. Please check this loader log to find the failed reason on TAP Server.\n";
			}
			#Added by Larry for Self Healing Service Component - Phase 2 End
		  }
		  else{#Execute Failed
			$operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		    $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
            $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n"; 
		    print LOG "The Restart Loader on TAP Server - The Unix Command {$restartLoaderFullCommand} has been executed failed.\n";
		  }
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
		  #1. Find out and Kill all the parent and child processes for the target loader name - For example: "reconEngine.pl"
		  my @targetLoaderPids = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|awk '{print \$2}'`;
          my $targetLoaderPidsCnt = scalar(@targetLoaderPids);
		  if($targetLoaderPidsCnt == 0){
		    print LOG "The Restart Loader on TAP3 Server - There is no process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		  }
		  else{
		    print LOG "The Restart Loader on TAP3 Server - There are $targetLoaderPidsCnt processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";

		    my $targetLoaderPidIndex = 1;
		    foreach my $targetLoaderPid(@targetLoaderPids){
		      chomp($targetLoaderPid);#remove the return line char
		      trim($targetLoaderPid);#Remove space chars
		      print LOG "The Restart Loader on TAP3 Server - [$targetLoaderPidIndex]PID: {$targetLoaderPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";
              my $cmdExecResult = system("kill -9 $targetLoaderPid");
			  if($cmdExecResult == 0){
                print LOG "The Restart Loader on TAP3 Server - PID: {$targetLoaderPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";
              }
			  else{
			    print LOG "The Restart Loader on TAP3 Server - PID: {$targetLoaderPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";
			  }
              $targetLoaderPidIndex++;
		    }#end foreach my $targetLoaderPid(@targetLoaderPids)
		  }#end else
		  
          #2. Start target loader using start-all.sh due that there is no root privilege granted on TAP3 Server we need to use 'sudo' unix command to get temp root privilege - For exmaple: "sudo /opt/staging/v2/start-all.sh"
		  $restartLoaderFullCommand = "$SUDO_CMD_PREFIX ";#"sudo "
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
		       $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
               $operationFailedComments.="The Target Loader {$restartLoaderName} has been restarted failed on TAP3 Server. Please contact AM developer to check this loader log to find the failed reason. Thanks!\n";
			   print LOG "The Restart Loader on TAP3 Server - There is no process which has been created for the target loader {$restartLoaderName} to run.\n";
			   print LOG "The Restart Loader on TAP3 Server - The Target Loader {$restartLoaderName} has been restarted failed. Please check this loader log to find the failed reason on TAP3 Server.\n";
			}
			#Added by Larry for Self Healing Service Component - Phase 2 End
		  }
		  else{#Execute Failed
			$operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		    $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
            $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n"; 
		    print LOG "The Restart Loader on TAP3 Server - The Unix Command {$restartLoaderFullCommand} has been executed failed.\n";
		  }
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
    elsif($operationNameCode eq $RESTART_IBMIHS_ON_TAP_SERVER){#RESTART_IBMIHS_ON_TAP_SERVER
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
         #Operation has been started to be processed
         updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
         $operationStartedFlag = $TRUE;#Operation has been started to process
       }
	  
       $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	   print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end elsif($operationNameCode eq $RESTART_IBMIHS_ON_TAP_SERVER)
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
  #push @vaildLoaderList,"testingTAP.pl";#22 #For testing function purpose only
  
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