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
#

#Load required modules
use strict;
use DBI;
use Database::Connection;
use Base::ConfigManager;

#Globals
my $selfHealingEngineLogFile    = "/home/liuhaidl/working/scripts/selfHealingEngine.log";
my $selfHealingEngineConfigFile = "/home/liuhaidl/working/scripts/selfHealingEngine.properties";

#SERVER MODE
my $TAP  = "TAP";#TAP Server for toStaging Loaders
my $TAP2 = "TAP2";#TAP2 Testing Server
my $TAP3 = "TAP3";#TAP3 Server for toBravo Loaders
my $SERVER_MODE;

my $LOADER_EXISTING_PATH = "/opt/staging/v2/";

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
#Database Group
my $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT = "DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT";
my $COMPOSITE_BUILDER                         = "COMPOSITE_BUILDER";
my $UPDATE_SW_LICENSES_STATUS                 = "UPDATE_SW_LICENSES_STATUS";
#Server Group
my $RESTART_IBMIHS_ON_TAP_SERVER              = "RESTART_IBMIHS_ON_TAP_SERVER";

#SQL Statement
my $UPDATE_CERTAIN_OPERATION_STATUS_SQL = "UPDATE OPERATION_QUEUE SET OPERATION_STATUS = ?, OPERATION_UPDATE_TIME = CURRENT TIMESTAMP, COMMENTS = ? WHERE OPERATION_ID = ?";

#Queue Invoke Mode Input Parameters Index
#Sample for Queue Invoke Mode
#/home/liuhaidl/working/scripts/selfHealingEngine.pl 1 RESTART_LOADER_ON_TAP_SERVER TI30326-36768^reconEngine.pl
my $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_ID_INDEX                      = 1;#For example: "1"
my $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_NAME_CODE_INDEX               = 2;#For example: "RESTART_LOADER_ON_TAP_SERVER"
my $QUEUE_INVOKE_MODE_INPUT_PARAMETER_OPERATION_MERGED_PARAMETERS_VALUE_INDEX = 3;#For example: "TI30326-36768^reconEngine.pl" or "reconEngine.pl"

#Command Invoke Mode Input Parameters Index
#Sample for Command Invoke Mode
#/home/liuhaidl/working/scripts/selfHealingEngine.pl RESTART_LOADER_ON_TAP_SERVER reconEngine.pl
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
  #Sample: /home/liuhaidl/working/scripts/selfHealingEngine.pl "1 RESTART_LOADER_ON_TAP_SERVER reconEngine.pl"
  #1. Input Operation ID Parameter = "1"
  #2. Input Operation Name Code Parameter = "RESTART_LOADER_ON_TAP_SERVER"
  #3. Input Operation Merged Parameter Values Parameter "reconEngine.pl"
  if($parameterCnt ==3){
    $selfHealingEngineInvokedMode = $QUEUE_MODE;#Queue Mode
	print LOG "The selfHealingEngine Invoke Mode is {$QUEUE_MODE}\n";
  }
  #If the count of input parameters is 2, it means that the invoked mode for SelfHealingEngine is 'Command' mode.
  #Sample: /home/liuhaidl/working/scripts/selfHealingEngine.pl "RESTART_LOADER_ON_TAP_SERVER reconEngine.pl"
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
	
  $operationNameCode = trim($operationNameCode);#Remove space chars
  $operationMergedParametersValue = trim($operationMergedParametersValue);#Remove space chars

  my @operationParametersArray = split(/\^/,$operationMergedParametersValue);
  my $operationParametersCnt = scalar(@operationParametersArray);
  print LOG "The Operation Name Code: {$operationNameCode}\n";
  print LOG "The Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
  print LOG "The Count of Operation Parameters: {$operationParametersCnt}\n";
  
  eval{
  
	#############THE FOLLOWING PIECE OF CODE IS THE OPERATION CORE BUSINESS LOGIC!!!!!!################################
    if(($operationNameCode eq $RESTART_LOADER_ON_TAP_SERVER)#RESTART_LOADER_ON_TAP_SERVER
	 &&($SERVER_MODE eq $TAP || $SERVER_MODE eq $TAP2)){#TAP Server or Support TAP2 Testing Server Case
      
	  if($selfHealingEngineInvokedMode eq $QUEUE_MODE){
        #Operation has been started to be processed
        updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_PROGRESSING_CODE,$PROGRESSING_COMMENTS,$parameterOperationId);
        $operationStartedFlag = $TRUE;#Operation has been started to process
      }

	  my $restartLoaderName;#var used to store restart loader name
	  my @validLoaderList = getValidLoaderListOnTAPServer();#array used to store valid loader list on TAP Server
	  my $validLoaderFlag = $FALSE;#Set 0(0 = False) as default value
	  my $loaderExistingPath = $LOADER_EXISTING_PATH;#var used to store loader existing path
	  my $restartLoaderFullCommand;#var used to store restart loader full command  - For example: "/opt/staging/v2/reconEngine.pl start"

      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	  print LOG "[$currentTimeStamp]Operation has been started to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){#Queue Invoked Mode
		#Sample Merged Parameter
	    #"TI30326-36768^reconEngine.pl" or "reconEngine.pl"
	    #There are two input parameters for Operation Name Code = "RESTART_LOADER_ON_TAP_SERVER" which Support User can choose to input from Operation GUI
	    #1. "Related Ticket Number" is not a required field - For example: "TI30326-36768"
	    #2. "Restart Loader Name" is a required field - For example: "reconEngine.pl"
        if($operationParametersCnt == 1){#For example: "reconEngine.pl"
	      $restartLoaderName = $operationParametersArray[0];
		  print LOG "The Operation Parameter - Restart Loader Name: {$restartLoaderName}\n";
	    }
	    elsif($operationParametersCnt == 2){#For example: "TI30326-36768^reconEngine.pl"
	      $restartLoaderName = $operationParametersArray[1];
          print LOG "The Operation Parameter - Restart Loader Name: {$restartLoaderName}\n";
	    }
	    else{
          $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
          $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
          $operationFailedComments.="The Count of Operation Parameters is not valid for Operation Name Code:{$operationNameCode}. It should be 1 or 2. For example: {TI30326-36768^reconEngine.pl} or {reconEngine.pl}"; 
	      print LOG "The Count of Operation Parameter is not valid for Operation Name Code:{$operationNameCode}. It should be 1 or 2. For example: {TI30326-36768^reconEngine.pl} or {reconEngine.pl}\n";
	    }
	  }
	  else{#Command Invoked Mode
	    #Sample Merged Parameter
	    #"reconEngine.pl"
		if($operationParametersCnt == 1){#For example: "reconEngine.pl"
		  $restartLoaderName = $operationParametersArray[0];
		  print LOG "The Operation Parameter - Restart Loader Name: {$restartLoaderName}\n"; 
		}
		else{
		  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		  print LOG "The Count of Operation Parameters is not valid for Operation Name Code:{$operationNameCode}. It should be 1. For example: {reconEngine.pl}\n";
		}
	  }
       
      if($operationResultFlag == $OPERATION_SUCCESS){#Only Operation Success case will go into the "Restart Loader" business logic
	    foreach my $validLoaderName (@validLoaderList){
		  if($restartLoaderName eq $validLoaderName){
		    print LOG "The Restart Loader Name: {$restartLoaderName} is equal to the valid Loader Name: {$validLoaderName}\n";
			print LOG "The Restart Loader Name: {$restartLoaderName} is a valid Loader Name on TAP Server.\n";
            $validLoaderFlag = $TRUE;#Set 1(1 = True) to vaildLoaderFlag
			last;
		  }
		  else{
		    print LOG "The Restart Loader Name: {$restartLoaderName} is not equal to the valid Loader Name: {$validLoaderName}\n";
		  }
		}#end foreach my $validLoaderName (@validLoaderList)

		if($validLoaderFlag == $FALSE){#Restart Loader is not a valid loader
		  $operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		  $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
          $operationFailedComments.="The Restart Loader Name: {$restartLoaderName} is not a valid Loader Name on TAP Server.\n"; 
		  print LOG "The Restart Loader Name: {$restartLoaderName} is not a valid Loader Name on TAP Server.\n";
		}
		else{#Restart Loader is a valid loader
		  #1. Find out and Kill all the parent and child processes for the target loader name - For example: "reconEngine.pl"
		  my @targetLoaderPids = `ps -ef|grep $restartLoaderName|grep start|grep -v grep|awk '{print \$2}'`;
          my $targetLoaderPidsCnt = scalar(@targetLoaderPids);
		  if($targetLoaderPidsCnt == 0){
		    print LOG "There is no process running currently for the Restart Loader Name: {$restartLoaderName}.\n";
		  }
		  else{
		    print LOG "There are $targetLoaderPidsCnt processes running currently for the Restart Loader Name: {$restartLoaderName}.\n";

		    my $targetLoaderPidIndex = 1;
		    foreach my $targetLoaderPid(@targetLoaderPids){
		      chomp($targetLoaderPid);#remove the return line char
		      trim($targetLoaderPid);#Remove space chars
		      print LOG "[$targetLoaderPidIndex]PID: {$targetLoaderPid} needs to be killed for the Restart Loader Name: {$restartLoaderName}.\n";
              my $cmdExecResult = system("kill -9 $targetLoaderPid");
			  if($cmdExecResult == 0){
                print LOG "PID: {$targetLoaderPid} has been killed successfully for the Restart Loader Name: {$restartLoaderName}.\n";
              }
			  else{
			    print LOG "PID: {$targetLoaderPid} has been killed failed for the Restart Loader Name: {$restartLoaderName}.\n";
			  }
              $targetLoaderPidIndex++;
		    }#end foreach my $targetLoaderPid(@targetLoaderPids)
		  }#end else
		  
          #2. Start target loader using loader full name - For exmaple: "/home/liuhaidl/working/scripts/reconEngine.pl"
		  $restartLoaderFullCommand = $loaderExistingPath;
          $restartLoaderFullCommand.= $restartLoaderName;
          $restartLoaderFullCommand.= " start";
		  print LOG "The Restart Loader Full Unix Command: {$restartLoaderFullCommand}\n";
		  my $restartLoaderFullCommandExecutedResult = system("$restartLoaderFullCommand");
          print LOG "The Unix Command {$restartLoaderFullCommand} executed result is {$restartLoaderFullCommandExecutedResult}\n";
		  if($restartLoaderFullCommandExecutedResult == 0){#Execute Successfully
            print LOG "The Unix Command {$restartLoaderFullCommand} has been executed successfully.\n";
		  }
		  else{#Execute Failed
			$operationResultFlag = $OPERATION_FAIL;#Set operation result falg to "OPERATION_FAIL" value
		    $operationFailedComments = $FAILED_COMMENTS;#"This Operatoin is failed due to reason: "
            $operationFailedComments.="The Unix Command {$restartLoaderFullCommand} has been executed failed.\n"; 
		    print LOG "The Unix Command {$restartLoaderFullCommand} has been executed failed.\n";
		  }
		}
	  }#end if($operationResultFlag == $OPERATION_SUCCESS) 

      $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	  print LOG "[$currentTimeStamp]Operation has been finished to process for Operation Name Code: {$operationNameCode} + Operation Merged Parameters Value: {$operationMergedParametersValue}\n";
    }#end if($operationNameCode eq $RESTART_LOADER_ON_TAP_SERVER)
    elsif(($operationNameCode eq $RESTART_LOADER_ON_TAP3_SERVER)#RESTART_LOADER_ON_TAP3_SERVER
	    &&($SERVER_MODE eq $TAP3)){#TAP3 Server
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){#Queue Invoked Mode
	  
	  }
	  else{#Command Invoked Mode
	
	  }
    }#end elsif($operationNameCode eq $RESTART_LOADER_ON_TAP3_SERVER)
    elsif($operationNameCode eq $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT){#DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){#Queue Invoked Mode
	  
	  }
	  else{#Command Invoked Mode
	
	  }
    }#end elsif($operationNameCode eq $DELETE_ALL_LPARS_FOR_SPECIAL_BANK_ACCOUNT)
    elsif($operationNameCode eq $COMPOSITE_BUILDER){#COMPOSITE_BUILDER
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){#Queue Invoked Mode
	
	  }
	  else{#Command Invoked Mode
	
	  }
    }#end elsif($operationNameCode eq $COMPOSITE_BUILDER)
    elsif($operationNameCode eq $UPDATE_SW_LICENSES_STATUS){#UPDATE_SW_LICENSES_STATUS
      if($selfHealingEngineInvokedMode eq $QUEUE_MODE){#Queue Invoked Mode
	
	  }
	  else{#Command Invoked Mode
	
	  }
    }#end elsif($operationNameCode eq $UPDATE_SW_LICENSES_STATUS)
    elsif($operationNameCode eq $RESTART_IBMIHS_ON_TAP_SERVER){#RESTART_IBMIHS_ON_TAP_SERVER
    
    }#end elsif($operationNameCode eq $RESTART_IBMIHS_ON_TAP_SERVER)
    #A piece of code template which is used for 'New Operatoin' business logic
    #elsif($operationNameCode eq "SAMPLE_OPERATION_NAME_CODE"){#SAMPLE_OPERATION_NAME_CODE
    #Add 'New Operatoin' business logic here 
    #}
    ############THE ABOVE PIECE OF CODE IS THE OPERATION CORE BUSINESS LOGIC!!!!!!################################

    if(($selfHealingEngineInvokedMode eq $QUEUE_MODE)#Queue Mode
	 &&($operationStartedFlag == $TRUE)){#Operation has been started to process
	  if($operationResultFlag == $OPERATION_SUCCESS){#Operation has been finished to be processed successfully
        updateOperationFunction($stagingConnection,$UPDATE_CERTAIN_OPERATION_STATUS_SQL,$OPERATION_STATUS_DONE_CODE,$DONE_COMMENTS,$parameterOperationId);
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
  push @vaildLoaderList,"memModToBravo.pl";#3
  push @vaildLoaderList,"hardwareToBravo.pl";#4
  push @vaildLoaderList,"hdiskToBravo.pl";#5
  push @vaildLoaderList,"processorToBravo.pl";#6
  push @vaildLoaderList,"swkbt";#7
  #push @vaildLoaderList,"testingTAP.pl";#8 #For testing function purpose only
  
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