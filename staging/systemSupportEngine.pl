#!/usr/bin/perl -w
#
# This perl script is used to provide a System Support Engine Support Feature 
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     -------------------------------------------------------------------------------------------------------------------
# 2013-07-30  Liu Hai(Larry) 1.0.0           Design and implement the basic architecture for System Support Engine
# 2013-08-01  Liu Hai(Larry) 1.0.1           Add Multi Processes Support Feature
#                                            Add 'Database::Connection' Object to support Multi Databases
# 2013-08-08  Liu Hai(Larry) 1.0.2           1) Add Perl File Running Parameters(start/stop/run-once) and Process Running Check Features
#                                            2) Add Configuration File named 'systemSupportEngine.properties' Feature for Server Mode parameters etc
#                                            3) Finish the new added incremental Operation Records Process Logic for the defined System Support Engine Trigger Interval Time. For example: 3600 seconds for every hour  
#                                            4) Add Log Support Feature
# 2013-08-20  Liu Hai(Larry) 1.0.3           Add Filter Logic to dispatch Operation Object properly to SelfHealing Engine on TAP or TAP3 Server to process
#                                            For example: 'RESTART_LOADER_ON_TAP_SERVER' and 'RESTART_IBMIHS_ON_TAP_SERVER' Operations only can be processed on TAP Server
#                                            For example: 'RESTART_LOADER_ON_TAP3_SERVER' Operation only can be processed on TAP3 Server
# 2013-09-03  Liu Hai(Larry) 1.0.4           Bypass Filter Logic to dispatch Operation Object properly to SelfHealing Engine on TAP2 Testing Server to process
###################################################################################################################################################################################################
#                                            Phase 3 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 3'
# 2013-10-14  Liu Hai(Larry) 1.3.0           Add New Operation 'RESTART_CHILD_LOADER_ON_TAP_SERVER' And Filter Logic Support on TAP Server to process this new Operation
# 2013-10-15  Liu Hai(Larry) 1.3.1           Change Log File Generation Logic to generate Log File for every day
# 2013-11-18  Liu Hai(Larry) 1.3.2           Add the feature support when the input operation parameters have ' ' space chars in them - For example - "Test 2". 
#                                            There is a bug found when there are ' ' space chars in operation parameters, then there is a parse error for Self Healing Engine to get the input Operation Parameters
#                                            Solution: replace all the ' ' chars using '~' special chars for temp and then convert them back for Self Healing Engine 
###################################################################################################################################################################################################
#                                            Phase 4 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 4'
# 2013-11-08  Liu Hai(Larry) 1.4.0           Add New Operation 'RESTART_IBMIHS_ON_TAP_SERVER' And Filter Logic Support on TAP Server to process this new Operation
###################################################################################################################################################################################################
#                                            Phase 5 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 5'
# 2013-11-21  Liu Hai(Larry) 1.5.0           Add New Operation 'RESTART_BRAVO_WEB_APPLICATION' And Filter Logic Support on TAP Server to process this new Operation
#                                            Add New Operation 'RESTART_TRAILS_WEB_APPLICATION' And Filter Logic Support on TAP Server to process this new Operation 
###################################################################################################################################################################################################
#                                            Phase 6 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 6'
# 2014-01-27  Liu Hai(Larry) 1.6.0           Add New Operation 'STAGING_BRAVO_DATA_SYNC' And Filter Logic Support on TAP Server to process this new Operation
###################################################################################################################################################################################################
#                                            Phase 7 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 7'
# 2014-03-11  Liu Hai(Larry) 1.7.0           Add New Operation 'ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE' And Filter Logic Support on TAP Server to process this new Operation
#
###################################################################################################################################################################################################
#                                            Phase 8 Development Formal Tag: 'Added by Tomas for System Support And Self Healing Service Components - Phase 8'
# 2014-03-11  Tomas Sima(Tomas) 1.8.0        System Support And Self Healing Service Components - Phase 8 - Add 'REMOVE_CERTAIN_BANK_ACCOUNT' Support Feature  
#

#Load required modules
use strict;
use DBI;
use Database::Connection;
use POSIX;#This package is used to support Multi Processes
use File::Basename;
use Base::ConfigManager;

#Globals
my $selfHealingEngineFile         = "/opt/staging/v2/selfHealingEngine.pl";
my $systemSupportEngineLogFile    = "/var/staging/logs/systemSupport/systemSupportEngine.log";
my $systemSupportEnginePidFile    = "/tmp/systemSupportEngine.pid";
my $systemSupportEngineConfigFile = "/opt/staging/v2/config/systemSupportEngine.properties";

#SERVER MODE
my $TAP  = "TAP";#TAP Server for toStaging Loaders
my $TAP2 = "TAP2";#TAP2 Testing Server
my $TAP3 = "TAP3";#TAP3 Server for toBravo Loaders
my $SERVER_MODE;

#Special Operation Name Codes List
#Only can be processed on TAP Server
my $RESTART_LOADER_ON_TAP_SERVER         = "RESTART_LOADER_ON_TAP_SERVER";
my $RESTART_CHILD_LOADER_ON_TAP_SERVER   = "RESTART_CHILD_LOADER_ON_TAP_SERVER";#Added by Larry for System Support And Self Healing Service Components - Phase 3
my $RESTART_IBMIHS_ON_TAP_SERVER         = "RESTART_IBMIHS_ON_TAP_SERVER";#Added by Larry for System Support And Self Healing Service Components - Phase 4
my $RESTART_BRAVO_WEB_APPLICATION        = "RESTART_BRAVO_WEB_APPLICATION";#Added by Larry for System Support And Self Healing Service Components - Phase 5
my $RESTART_TRAILS_WEB_APPLICATION       = "RESTART_TRAILS_WEB_APPLICATION";#Added by Larry for System Support And Self Healing Service Components - Phase 5
my $STAGING_BRAVO_DATA_SYNC              = "STAGING_BRAVO_DATA_SYNC";#Added by Larry for System Support And Self Healing Service Components - Phase 6
my $ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE = "ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE";#Added by Larry for System Support And Self Healing Service Components - Phase 7
my $REMOVE_CERTAIN_BANK_ACCOUNT			 = "REMOVE_CERTAIN_BANK_ACCOUNT"; #Added by Tomas for System Support And Self Healing Service Components - Phase 8
#Only can be processed on TAP3 Server
my $RESTART_LOADER_ON_TAP3_SERVER        = "RESTART_LOADER_ON_TAP3_SERVER";

#System Support Engine Trigger Interval Time
my $TRIGGER_INTERVAL_TIME;

#TIMESTAMP STYLE
my $STYLE1 = 1;#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
my $STYLE2 = 2;#YYYYMMDDHHMMSS For Example: 20130418103033
my $STYLE3 = 3;#YYYYMMDD For Example: 20130618 #Added by Larry for System Support And Self Healing Service Components - Phase 3

#Vars Definition
#Database
my $DB_ENV;
my $staging_connection;
#Config File
my $cfgMgr;
my $configServerMode;
my $configSleepPeriod;

#Others
my @mockOperationQueueRecords = ();
my @operationQueueRecords = ();
my $operationQueueRecordsCnt;#var used to store the count of Operation Queue Records 
my $currentTimeStamp;
my $currentDate;#Added by Larry for System Support And Self Healing Service Components - Phase 3

#SQL Statements
my $GET_ALL_OPERATION_QUEUE_NOT_DONE_OPERATIONS_SQL = "SELECT OPERATION_ID, OPERATION_NAME_CODE, OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER FROM OPERATION_QUEUE WHERE OPERATION_STATUS = 'ADDED' ORDER BY OPERATION_ID WITH UR";

#Operation Record Data Indexes Definition
my $OPERATION_ID_INDEX                       = 0;
my $OPERATION_NAME_CODE_INDEX                = 1;
my $OPERATION_NAME_DESCRIPTION_INDEX         = 2;
my $OPERATION_PARMS_INDEX                    = 3;
my $OPERATION_STATUS_INDEX                   = 4;
my $OPERATION_USER_INDEX                     = 5;

my $finalPerlScriptExecutionCommand = "";
my $operationId;
my $operationNameCode;
my $operationParameters;

###Make a daemon.
umask 0;
defined( my $pid = fork )
  or die "ERROR: Unable to fork: $!";
exit if $pid;

loaderStart(shift @ARGV, $systemSupportEnginePidFile);#Start System Support Engine Process

#This is the main method of System Support Engine
main();

#This is the main method of System Support Engine
sub main{
  init();
  process();
  postProcess();
}

#This method is used to do init operations
sub init{
  #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
  #Change Log File Generation Logic to generate Log File for every day
  #Log File Operation
  $currentDate = getCurrentTimeStamp($STYLE3);#Get the current date using format YYYYMMDD
  $systemSupportEngineLogFile.= ".$currentDate";
  #Added by Larry for System Support And Self Healing Service Components - Phase 3 End 
  
  #Get the 'systemSupportEngineLog.properties' config object
  $cfgMgr   = Base::ConfigManager->instance($systemSupportEngineConfigFile);
  #Get the config Server Mode
  $configServerMode = trim($cfgMgr->server);
  print "configServerMode: {$configServerMode}\n";
  #Set Server Mode Value from configuration file
  $SERVER_MODE  = $configServerMode;
  
  #Get the config Sleep Period
  $configSleepPeriod = trim($cfgMgr->sleepPeriod);
  print "configSleepPeriod: {$configSleepPeriod}\n";
  #Set Trigger Frequency Time from configuration file For example: 3600(Unit: Second)
  $TRIGGER_INTERVAL_TIME = $configSleepPeriod;

  #set db2 env path
  setDB2ENVPath();

  #setup db2 environment
  setupDB2Env();
}

#This method is used to generate Mock Operation Queue Data
sub generateMockOperationQueueData{
  push @operationQueueRecords, [("1","UPDATE_SW_LICENSES_STATUS","Update Software Licenses Status","TI30401-61932^25230^SR_85257459006C7B07","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("2","UPDATE_SW_LICENSES_STATUS","Update Software Licenses Status","TI30319-59512^77300","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("3","RESTART_LOADER_FOR_SPECIAL_ACCOUNT","Restart Loader For Special Account","TI30619-69113^processorToBravo.pl^26190","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("4","RESTART_LOADER_FOR_SPECIAL_ACCOUNT","Restart Loader For Special Account","TI888888^reconEngine.pl^999999","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("5","RESTART_LOADER_FOR_SPECIAL_ACCOUNT","Restart Loader For Special Account","TI30620-58906^softwareToBravo.pl^22190","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("6","RESTART_LOADER_FOR_SPECIAL_ACCOUNT","Restart Loader For Special Account","TI30620-57888^softwareToBravo.pl^36189","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("7","RESTART_LOADER_FOR_SPECIAL_ACCOUNT","Restart Loader For Special Account","TI30620-56680^softwareToBravo.pl^29999","ADDED","liuhaidl\@cn.ibm.com")];
  push @operationQueueRecords, [("8","RESTART_LOADER","Restart Loader","TI30626-50081^reconEngine.pl","ADDED","liuhaidl\@cn.ibm.com")];
}

#This method is used to do System Support Engine Business Process
sub process{
  while (1){
	
	open(LOG,">>$systemSupportEngineLogFile");#Open Log File
	  
    #get DB connection object
    $staging_connection = Database::Connection->new('staging');      

	eval{
      #Define 'process' method detailed logic
      #generateMockOperationQueueData();#For testing purpose
      #Get All the new added incremential operation records for every round interval time set in the 'systemSupportEngineLog.properties' file. For example, 3600 seconds for every hour
	  @operationQueueRecords = getAllOperationQueueNotDoneOperationsFunction($staging_connection,$GET_ALL_OPERATION_QUEUE_NOT_DONE_OPERATIONS_SQL);
      
	  #Filter All the available Operation Queue Operations for certaion server - For example, TAP or TAP3 Server 
	  @operationQueueRecords = filterAllOperationQueueNotDoneOperationsForCertainServer(\@operationQueueRecords,$SERVER_MODE);
    
	  $operationQueueRecordsCnt = scalar(@operationQueueRecords);
	  if($operationQueueRecordsCnt > 0){
	   print LOG "There are $operationQueueRecordsCnt new Operations which need to be processed in the new round on $SERVER_MODE Server.\n";
	   print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
	  }
	  else{
       print LOG "There is no available new added Operation which needs to be processed in the new round on $SERVER_MODE Server.\n"; 
	  }
 
      foreach my $operationQueueRecord (@operationQueueRecords){
	     #Set the finalPerlScriptExecutionCommand to empty string before every command to run
	     $finalPerlScriptExecutionCommand = "";
         $finalPerlScriptExecutionCommand.=$selfHealingEngineFile;
	     $operationId = $operationQueueRecord->[$OPERATION_ID_INDEX];
         print LOG "Operation ID: {$operationId}\n";
	     $finalPerlScriptExecutionCommand.=" $operationId";
         $operationNameCode = $operationQueueRecord->[$OPERATION_NAME_CODE_INDEX];
	     print LOG "Operation Name Code: {$operationNameCode}\n";
         $finalPerlScriptExecutionCommand.=" $operationNameCode";
         $operationParameters = $operationQueueRecord->[$OPERATION_PARMS_INDEX];
         print LOG "Operation Parameters: {$operationParameters}\n";
		 #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
		 $operationParameters =~ s/ /\~/g;
         print LOG "Converted Operation Parameters to replace char ' ' with '~' : {$operationParameters}\n";
		 #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
         $finalPerlScriptExecutionCommand.=" $operationParameters";
         print LOG "The final Perl Script Execution Command: {$finalPerlScriptExecutionCommand}\n";
	     #Create new Child Process to execute Operation Object
	     newChildProcess($operationId,$operationNameCode,$operationParameters,$finalPerlScriptExecutionCommand);
	     print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
      }#end foreach my $operationQueueRecord (@operationQueueRecords)
    };
	if($@){
	  print LOG "Exception happened due to reason: $@\n";
	}
    
	#Disconnect DB
    $staging_connection->disconnect();#Added by Larry for HealthCheck And Monitor Module - Phase 2B

	close LOG;
    sleep $TRIGGER_INTERVAL_TIME;
  }#end while(1)
}

#This method is used to do System Support Engine Business Post Process for example, close db handlers, close file handers etc
sub postProcess{
  #Define 'postProcess' method detailed logic
  #Disconnect DB
  #$staging_connection->disconnect();#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  #Close Log File Handler
  #close LOG;
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

#This method is used to created Child Process to invoke System Support Engine
sub newChildProcess {
	my $operationId = shift;
	my $operationNameCode = shift;
	my $operationParametersMergedValue = shift;
    my $finalExecutePerlCommand  = shift;
    my $pid;

    my $sigset = POSIX::SigSet->new(SIGINT);
    sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
    die "Cannot fork child: $!\n" unless defined( $pid = fork );
  
	if ($pid) {
		$currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
        print LOG "[$currentTimeStamp]New Child Process {$pid} has bee created to process Operation ID: {$operationId} + Operation Name Code: {$operationNameCode} + Operation Parameters Merged Value: {$operationParametersMergedValue}\n";	
  		return;
    }

    #Execute the final Perl Script Execution Command
    #`$finalExecutePerlCommand`;#This method cannot be used due that the main process always hang up to wait for the child process to return even if the child process has actually be finished successfully!!!
	my $finalExecutePerlCommandResult = system("$finalExecutePerlCommand");
	$currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
	if($finalExecutePerlCommandResult == 0){#Execute Successfully
	  print LOG "[$currentTimeStamp]The Perl Command: {$finalExecutePerlCommand} has been executed successfully by Child Process\n";
    }
	else{#Execute Failed
	  print LOG "[$currentTimeStamp]The Perl Command: {$finalExecutePerlCommand} has been executed failed by Child Process\n";
	}
	exit;
}

#my $GET_ALL_OPERATION_QUEUE_NOT_DONE_OPERATIONS_SQL = "SELECT OPERATION_ID, OPERATION_NAME_CODE, OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER FROM OPERATION_QUEUE WHERE OPERATION_STATUS = 'ADDED' ORDER BY OPERATION_ID WITH UR";
sub getAllOperationQueueNotDoneOperationsFunction{
  my ($connection, $querySQL) = @_;
  my @operationQueueRecords = ();
  my @operationQueueRecord;
  $connection->prepareSqlQuery(queryAllOperationQueueNotDoneOperations($querySQL));
  my $sth = $connection->sql->{allOperationQueueNotDoneOperations};
  
  $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
  print LOG "[$currentTimeStamp]Started to execute SQL: {$querySQL}\n";

  $sth->execute();
  while (@operationQueueRecord = $sth->fetchrow_array()){
     push @operationQueueRecords, [@operationQueueRecord];  
  }

  $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
  print LOG "[$currentTimeStamp]Finished to execute SQL: {$querySQL}\n";

  $sth->finish;
  return @operationQueueRecords;
}

sub queryAllOperationQueueNotDoneOperations{
  my $query = shift;
  return ('allOperationQueueNotDoneOperations', $query);
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
		     'fullTime3' => "$year$mon$mday"#Added by Larry for System Support And Self Healing Service Components - Phase 3
          };
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
   #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
   elsif($timeStampStyle == $STYLE3){#YYYYMMDD For Example: 20130618
      $currentTimeStamp = $dateObject->{fullTime3};
   }
   #Added by Larry for System Support And Self Healing Service Components - Phase 3 End
   
   return $currentTimeStamp;
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
}

sub filterAllOperationQueueNotDoneOperationsForCertainServer{
  my $operationQueueRecordsRef = shift;
  my @operationQueueRecords = @$operationQueueRecordsRef;
  my $serverMode = shift;
  my $operationQueueRecordRef;
  my @operationQueueRecord;
  my @filterOperationQueueRecordsForCertainServer = ();
  my $filterOperationQueueRecordsForCertainServerCnt;
  my $operationId;
  my $operationNameCode;
  
  my $operationQueueRecordsCnt = scalar(@operationQueueRecords);
  print LOG "Before filter for {$serverMode} Server, the count of the available Operation Queue Records: {$operationQueueRecordsCnt}\n";
  
  foreach $operationQueueRecordRef (@operationQueueRecords){
    @operationQueueRecord = ();
    $operationId = $operationQueueRecordRef->[$OPERATION_ID_INDEX];
	push @operationQueueRecord, $operationId;#Operation ID
    $operationNameCode = $operationQueueRecordRef->[$OPERATION_NAME_CODE_INDEX];
    push @operationQueueRecord, $operationNameCode;#Operation Name Code
	push @operationQueueRecord, $operationQueueRecordRef->[$OPERATION_NAME_DESCRIPTION_INDEX];
	push @operationQueueRecord, $operationQueueRecordRef->[$OPERATION_PARMS_INDEX];
	push @operationQueueRecord, $operationQueueRecordRef->[$OPERATION_STATUS_INDEX];
    push @operationQueueRecord, $operationQueueRecordRef->[$OPERATION_USER_INDEX];
    
   if($serverMode eq $TAP2){#TAP2 Server for testing purpose
	 #Please note that for TAP2 Testing Server, the available operation process records will not be filtered out.
     push @filterOperationQueueRecordsForCertainServer, [@operationQueueRecord];
	 print LOG "Operation Queue Record with Operation ID: {$operationId} + Operation Name Code: {$operationNameCode} has be kept for {$serverMode} Server to process.\n";       
   }#end if($serverMode eq $TAP2)
   elsif($serverMode eq $TAP){#TAP Server
	  if($operationNameCode ne $RESTART_LOADER_ON_TAP3_SERVER){
	    push @filterOperationQueueRecordsForCertainServer, [@operationQueueRecord];
		print LOG "Operation Queue Record with Operation ID: {$operationId} + Operation Name Code: {$operationNameCode} has be kept for {$serverMode} Server to process.\n";
	  }#end if($operationNameCode ne $RESTART_LOADER_ON_TAP3_SERVER)
	  else{
	    print LOG "Operation Queue Record with Operation ID: {$operationId} + Operation Name Code: {$operationNameCode} has be filtered out for {$serverMode} Server to bypass process.\n"; 
	  }#end else
	}#end elsif($serverMode eq $TAP)
	elsif($serverMode eq $TAP3){#TAP3 Server
	  if($operationNameCode ne $RESTART_LOADER_ON_TAP_SERVER 
	  && $operationNameCode ne $RESTART_IBMIHS_ON_TAP_SERVER
	  && $operationNameCode ne $RESTART_CHILD_LOADER_ON_TAP_SERVER#Added by Larry for System Support And Self Healing Service Components - Phase 3
      && $operationNameCode ne $RESTART_IBMIHS_ON_TAP_SERVER#Added by Larry for System Support And Self Healing Service Components - Phase 4
	  && $operationNameCode ne $RESTART_BRAVO_WEB_APPLICATION#Added by Larry for System Support And Self Healing Service Components - Phase 5
      && $operationNameCode ne $RESTART_TRAILS_WEB_APPLICATION#Added by Larry for System Support And Self Healing Service Components - Phase 5
      && $operationNameCode ne $STAGING_BRAVO_DATA_SYNC#Added by Larry for System Support And Self Healing Service Components - Phase 6
      && $operationNameCode ne $ADD_SPECIFIC_ID_LIST_INTO_TARGET_RECON_QUEUE#Added by Larry for System Support And Self Healing Service Components - Phase 7
      && $operationNameCode ne $REMOVE_CERTAIN_BANK_ACCOUNT#Added by Tom for System Support And Self Healing Service Components - Phase 8
	  ){
	    push @filterOperationQueueRecordsForCertainServer, [@operationQueueRecord];
		print LOG "Operation Queue Record with Operation ID: {$operationId} + Operation Name Code: {$operationNameCode} has be kept for {$serverMode} Server to process.\n";    
	  }#end if($operationNameCode ne $RESTART_LOADER_ON_TAP_SERVER && $operationNameCode ne $RESTART_IBMIHS_ON_TAP_SERVER && $operationNameCode ne $RESTART_CHILD_LOADER_ON_TAP_SERVER) 
	  else{
	    print LOG "Operation Queue Record with Operation ID: {$operationId} + Operation Name Code: {$operationNameCode} has be filtered out for {$serverMode} Server to bypass process.\n";     
	  }
	}#end elsif($serverMode eq $TAP3)
  }#end for(my $index=0 ; $index<$operationQueueRecordsCnt; $index++)
  
  $filterOperationQueueRecordsForCertainServerCnt = scalar(@filterOperationQueueRecordsForCertainServer);
  print LOG "After filter for {$serverMode} Server, the count of the available Operation Queue Records: {$filterOperationQueueRecordsForCertainServerCnt}\n";

  return @filterOperationQueueRecordsForCertainServer;
}#end sub filterAllOperationQueueNotDoneOperationsForCertainServer