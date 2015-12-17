#!/usr/bin/perl -w
#
# This script reads operation_queue table and invoke SHE for added operations

use strict;
use DBI;
use Database::Connection;
use POSIX;
use File::Basename;
use Base::ConfigManager;
use Sys::Hostname;

my $HOSTNAME= hostname;
my $systemSupportEnginePidFile    = "/tmp/systemSupportEngine.pid";
my $systemSupportEngineConfigFile = "./config/systemSupportEngine.properties";
my $currentTimeStamp;

#TIMESTAMP STYLE
my $STYLE1 = 1;#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
my $STYLE2 = 2;#YYYYMMDDHHMMSS For Example: 20130418103033
my $STYLE3 = 3;#YYYYMMDD For Example: 20130618 #Added by Larry for System Support And Self Healing Service Components - Phase 3

###Make a daemon.
umask 0;
defined( my $pid = fork )
or die "ERROR: Unable to fork: $!";
exit if $pid;

loaderStart(shift @ARGV, $systemSupportEnginePidFile);#Start System Support Engine Process

main();

sub main{
	init();
	process();
}

sub init{
	my $config   = Base::ConfigManager->instance($systemSupportEngineConfigFile);
	setupDB2Env($config->db2Profile);
}

sub process{
	my $config   = Base::ConfigManager->instance($systemSupportEngineConfigFile);
	my $SleepPeriod = trim($config->sleepPeriod);
	my $LogFile=get_log_path($config->LogFile);
my @operationQueueRecords = ();

	while (1){
		my $staging_connection = Database::Connection->new('staging');      
		
		open(LOG,">>$LogFile");

		eval{


			@operationQueueRecords = getOperations($staging_connection,$config);
			my $operationQueueRecordsCnt = scalar(@operationQueueRecords);
			if($operationQueueRecordsCnt > 0){
				print LOG "There are $operationQueueRecordsCnt new Operations which need to be processed in the new round on $HOSTNAME Server.\n";
				print LOG "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
			}
			else{
				print LOG "There is no available new added Operation which needs to be processed in the new round on $HOSTNAME Server.\n"; 
			}
			
			foreach my $operationQueueRecord (@operationQueueRecords){
			#Set the finalPerlScriptExecutionCommand to empty string before every command to run
			my $finalPerlScriptExecutionCommand = "";
			$finalPerlScriptExecutionCommand.="./selfHealingEngine.pl";
			my $operationId = $operationQueueRecord->[0];
			print LOG "Operation ID: {$operationId}\n";
			$finalPerlScriptExecutionCommand.=" $operationId";
			my $operationNameCode = $operationQueueRecord->[1];
			print LOG "Operation Name Code: {$operationNameCode}\n";
			$finalPerlScriptExecutionCommand.=" $operationNameCode";
			my $operationParameters = $operationQueueRecord->[3];
			print LOG "Operation Parameters: {$operationParameters}\n";
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

		close LOG;
		$staging_connection->disconnect();
		sleep $SleepPeriod;
	}#end while(1)
}

sub get_log_path{
	my $systemSupportEngineLogFile    = shift;
	my $currentDate = getCurrentTimeStamp($STYLE3);#Get the current date using format YYYYMMDD
	return ($systemSupportEngineLogFile .".$currentDate");
}

sub getOperations{
	my ($staging_connection,$config) = @_;
my @operationQueueRecords = ();
	@operationQueueRecords = getAllOperationQueueNotDoneOperationsFunction($staging_connection);
	@operationQueueRecords = filterAllOperationQueueNotDoneOperationsForCertainServer(\@operationQueueRecords,$config);
	return @operationQueueRecords;
}

sub getAllOperationQueueNotDoneOperationsFunction{
	my $connection = shift;
	my $GET_ALL_ADDED_OPERATIONS = "SELECT OPERATION_ID, OPERATION_NAME_CODE, OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER FROM OPERATION_QUEUE WHERE OPERATION_STATUS = 'ADDED' ORDER BY OPERATION_ID WITH UR";
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
	my ($operationQueueRecordsRef ,$config) = @_;
	my @allowedOperations = split(',',$config->allowedOperations);
	my @operationQueueRecords = @$operationQueueRecordsRef;
	my $serverMode = shift;
	my $operationQueueRecordRef;
	my @operationQueueRecord;
	my @filterOperationQueueRecordsForCertainServer = ();
	my $filterOperationQueueRecordsForCertainServerCnt;
	my $operationId;
	my $operationNameCode;
	
	my $operationQueueRecordsCnt = scalar(@operationQueueRecords);
	print LOG "Before filter for $HOSTNAME Server, the count of the available Operation Queue Records: {$operationQueueRecordsCnt}\n";
	
	foreach $operationQueueRecordRef (@operationQueueRecords){
		@operationQueueRecord = ();
		$operationId = $operationQueueRecordRef->[0];
	push @operationQueueRecord, $operationId;#Operation ID
	$operationNameCode = $operationQueueRecordRef->[1];
		push @operationQueueRecord, $operationNameCode;#Operation Name Code
		push @operationQueueRecord, $operationQueueRecordRef->[2];
		push @operationQueueRecord, $operationQueueRecordRef->[3];
		push @operationQueueRecord, $operationQueueRecordRef->[4];
		push @operationQueueRecord, $operationQueueRecordRef->[5];

  push @filterOperationQueueRecordsForCertainServer, [@operationQueueRecord];
}

$filterOperationQueueRecordsForCertainServerCnt = scalar(@filterOperationQueueRecordsForCertainServer);
print LOG "After filter for $HOSTNAME Server, the count of the available Operation Queue Records: {$filterOperationQueueRecordsForCertainServerCnt}\n";

return @filterOperationQueueRecordsForCertainServer;
}

#This method is used to setup DB2 environment
sub setupDB2Env {
	my $DB_ENV = shift;
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

sub getCurrentTimeStamp{
	my $timeStampStyle = shift;
	 my $dateObject = &getTime();
	 my $currentTimeStamp;
	 if($timeStampStyle == $STYLE1){#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
	 	$currentTimeStamp = $dateObject->{fullTime1};
	 }
	 elsif($timeStampStyle == $STYLE2){#YYYYMMDDHHMMSS For Example: 20130418103033
	 	$currentTimeStamp = $dateObject->{fullTime2};
	 }
	 elsif($timeStampStyle == $STYLE3){#YYYYMMDD For Example: 20130618
	 	$currentTimeStamp = $dateObject->{fullTime3};
	 }
	 
	 return $currentTimeStamp;
	}

sub getTime
{
		my $time = shift || time();
		
		my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
		
		$mon ++;
		$sec  = ($sec<10)?"0$sec":$sec;#Second[0,59]
		$min  = ($min<10)?"0$min":$min;#minitue[0,59]
		$hour = ($hour<10)?"0$hour":$hour;#Hour[0,23]
		$mday = ($mday<10)?"0$mday":$mday;#Day[1,31]
		$mon  = ($mon<10)?"0$mon":$mon;#Month[0,11]
		$year+=1900;#From 1900 year
		
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
