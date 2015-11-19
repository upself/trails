#!/usr/bin/perl -w
#
# This scripts read operation_queue table and invoke SHE for added operations

#Load required modules
use strict;
use DBI;
use Database::Connection;
use POSIX;#This package is used to support Multi Processes
use File::Basename;
use Base::ConfigManager;
use Sys::Hostname;
my $hostnamename = hostname;

#Globals
my $selfHealingEngineFile         = "./selfHealingEngine.pl";
my $systemSupportEngineLogFile    = #TODO nacitat z configu
my $systemSupportEnginePidFile    = "/tmp/systemSupportEngine.pid";
#my $systemSupportEngineConfigFile = "/opt/staging/v2/config/systemSupportEngine.properties";
my $systemSupportEngineConfigFile = "./config/systemSupportEngine.properties";

#System Support Engine Trigger Interval Time
my $TRIGGER_INTERVAL_TIME;

#TIMESTAMP STYLE
my $STYLE1 = 1;#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
my $STYLE2 = 2;#YYYYMMDDHHMMSS For Example: 20130418103033
my $STYLE3 = 3;#YYYYMMDD For Example: 20130618 #Added by Larry for System Support And Self Healing Service Components - Phase 3

#Database
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
my $GET_ALL_ADDED_OPERATIONS = "SELECT OPERATION_ID, OPERATION_NAME_CODE, OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER FROM OPERATION_QUEUE WHERE OPERATION_STATUS = 'ADDED' ORDER BY OPERATION_ID WITH UR";

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
}

#This method is used to do init operations
sub init{
    
    #Get the 'systemSupportEngineLog.properties' config object
    $cfgMgr   = Base::ConfigManager->instance($systemSupportEngineConfigFile);
    #Set Server Mode Value from configuration file
    
    $SleepPeriod = trim($cfgMgr->sleepPeriod);

    #setup db2 environment
    setupDB2Env();
}

sub get_config_path{
    my $currentDate = getCurrentTimeStamp($STYLE3);#Get the current date using format YYYYMMDD
    return ($systemSupportEngineLogFile .".$currentDate");
    
}
#This method is used to do System Support Engine Business Process
sub process{
    $LogFile=get_config_path()

    while (1){
        
    open(LOG,">>$LogFile");#Open Log File
    
        #get DB connection object
        $staging_connection = Database::Connection->new('staging');      

        eval{

            
            @operationQueueRecords = getOperations($staging_connection);
            $operationQueueRecordsCnt = scalar(@operationQueueRecords);
            if($operationQueueRecordsCnt > 0){
                print LOG "There are $operationQueueRecordsCnt new Operations which need to be processed in the new round on $hostname Server.\n";
                print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
            }
            else{
                print LOG "There is no available new added Operation which needs to be processed in the new round on $hostname Server.\n"; 
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
        sleep $SleepPeriod;
    }#end while(1)
}
sub getOperations{
	($staging_connection) = @_;
           @operationQueueRecords = getAllOperationQueueNotDoneOperationsFunction($staging_connection);
           @operationQueueRecords = filterAllOperationQueueNotDoneOperationsForCertainServer($records);
}

sub getAllOperationQueueNotDoneOperationsFunction{
    my $connection = shift;
    my @operationQueueRecords = ();
    $connection->prepareSqlQuery('allOperationQueueNotDoneOperations',$GET_ALL_ADDED_OPERATIONS);
    my $sth = $connection->sql->{allOperationQueueNotDoneOperations};
    
    my $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
    print LOG "[$currentTimeStamp]Started to execute SQL: {$GET_ALL_ADDED_OPERATIONS}\n";

    $sth->execute();

    my @operationQueueRecord;
    while (@operationQueueRecord = $sth->fetchrow_array()){
        push @operationQueueRecords, [@operationQueueRecord];  
    }

    $currentTimeStamp = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
    print LOG "[$currentTimeStamp]Finished to execute SQL: {$GET_ALL_ADDED_OPERATIONS}\n";

    $sth->finish;
    return @operationQueueRecords;
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
    print LOG "Before filter for $hostname Server, the count of the available Operation Queue Records: {$operationQueueRecordsCnt}\n";
    
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
        

 # pokud je operace ok     push @filterOperationQueueRecordsForCertainServer, [@operationQueueRecord];
}

$filterOperationQueueRecordsForCertainServerCnt = scalar(@filterOperationQueueRecordsForCertainServer);
print LOG "After filter for $hostname Server, the count of the available Operation Queue Records: {$filterOperationQueueRecordsForCertainServerCnt}\n";

return @filterOperationQueueRecordsForCertainServer;
}

#This method is used to setup DB2 environment
sub setupDB2Env {
    #TODO pridat nacteni configu
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
        #$yday is accumulated from 1/1��stands for which day of one year[0,364]
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
