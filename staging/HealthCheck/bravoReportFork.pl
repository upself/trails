#!/usr/bin/perl -w

###############################################################################
# (C) COPYRIGHT IBM Corp. 2004
# All Rights Reserved
# Licensed Material - Property of IBM
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
###############################################################################

###############################################################################
# Name          : stagingImport.pl
# Component		: Staging
# Description	: Creates db2 import files for load into staging
# Author        : Alex Moise
# Date          : January 25, 2006
#
#                      ATTENTION: I live in CVS now! 
#  $Source: /cvs/AdHocReports/sw_multi_report/bravoReportFork.pl,v $
#                      
# $Id: bravoReportFork.pl,v 1.2 2008/10/27 17:23:33 cweyl Exp $
#
# $Log: bravoReportFork.pl,v $
# Revision 1.2  2008/10/27 17:23:33  cweyl
# - perltidy'ed; no other changes
#
# Revision 1.1  2008/10/27 17:18:24  cweyl
# initial import
#
###############################################################################
$VERSION = 'Version 1.0';
###############################################################################

###############################################################################
### Use/Require Statements
###
###############################################################################
use lib '/opt/bravo/scripts/report/lib'; 
use lib '/opt/staging/v2'; 
use strict;
use Getopt::Std;
use POSIX ":sys_wait_h";
use Tap::DBConnection;
use HealthCheck::Delegate::EventLoaderDelegate; 

require '/opt/common/utils/loggingUtils.pl';

###############################################################################
### Define Script Variables
###
###############################################################################
getopts("c:");
use vars qw (
    $opt_c
);

###############################################################################
### Set Script Variables
###
###############################################################################
my $maxChildren   = $opt_c;
my %children      = ();
my $children      = 0;
my $sleepTime     = 5;
my @logArray      = qw(1 2 3 4 5 6);
my $scriptDir     = '/opt/bravo/scripts/report';
my $trailsSqlFile = $scriptDir . '/trails_sql.xml';
my $logFile       = '/opt/bravo/scripts/report/logs/bravoReportFork.log';
my $reportScript  = '/opt/bravo/scripts/report/bravoReport.pl';
#my $reportScript  = '/opt/bravo/scripts/report/sw_multi_report';
my $eventTypeName = 'BRAVOREPORTFORK_START_STOP_SCRIPT'; 
my $eventObject; 
my $bravoConnection; 
my $customerIds; 

###############################################################################
### Basic Checks
###
###############################################################################

# Signal handler for dead children
sub REAPER {

    $SIG{CHLD} = \&REAPER;

    while ((my $pid = waitpid(-1, &WNOHANG)) > 0) {

        if (exists($children{$pid})) {
            $children--;
            push @logArray, $children{$pid}{'log'};
            delete $children{$pid};
        }
        else {
            logit("I shouldn't hit this in the reaper sub", $logFile);
        }
    }
}

$SIG{CHLD} = \&REAPER;

###############################################################################
### Main
###
###############################################################################
eval { 

     
	###Notify Event Engine that we are starting.
    logit("eventTypeName=$eventTypeName", $logFile);
	logit("starting $eventTypeName event status", $logFile);
    $eventObject = EventLoaderDelegate->start($eventTypeName);
    logit("started $eventTypeName event status", $logFile);

	sleep 1;#sleep 1 second to resolve the startTime and endTime is the same case if process is too quick
	 

   $bravoConnection = getConnection('trails', $trailsSqlFile);#Define $bravoConnection var as a Global one  
   $customerIds = getDistinctBravoCustomerIds();#Define $customerIds var as a Global one  
   $bravoConnection->disconnect;

foreach my $customerId (sort @{$customerIds}) {

    # spawn child unless maxed out
    while ($children >= $maxChildren) {
        logit("Sleeping", $logFile);
        sleep $sleepTime;
    }

    spawnScript($customerId, shift @logArray);
}

# wait till  all children die

while ($children != 0) {
    sleep 5;
}

}; 

 
if ($@) {
	###Notify the Event Engine that we had an error
	logit("erroring $eventTypeName event status", $logFile);
    EventLoaderDelegate->error($eventObject,$eventTypeName);
	logit("errored $eventTypeName event status", $logFile);

    die $@;
}
else {

    ###Notify the Event Engine that we are stopping
	logit("stopping $eventTypeName event status", $logFile);
	EventLoaderDelegate->stop($eventObject,$eventTypeName);
	logit("stopped $eventTypeName event status", $logFile);
}
 

# End of Program
exit 0;

###############################################################################
### Subroutines
###
###############################################################################

sub spawnScript {
    my $customerId = shift;
    my $logNum     = shift;
    my $pid;

    unless (defined($pid = fork)) {
        logit("ERROR: unable to fork child process", $logFile);
        exit 1;
    }

    if ($pid) {

        # i am the parent
        $children{$pid}{'log'} = $logNum;
        $children++;

        return;
    }
    else {

        # i am the child, i *CANNOT* return only exit
        logit("Spawning script $customerId", $logFile);
        exec "/opt/perl-5.10.1/bin/perl $reportScript -c $customerId";
        #exit 0;
    }
}

sub getDistinctBravoCustomerIds {
    my ($sql) = @_;

    my @data;
    my $customerId;

    $bravoConnection->getSql->{getDistinctBravoCustomerIds}->{sth}
        ->bind_columns(\$customerId);

    $bravoConnection->getSql->{getDistinctBravoCustomerIds}->{sth}->execute();
    while ($bravoConnection->getSql->{getDistinctBravoCustomerIds}->{sth}
        ->fetchrow_arrayref)
    {
        push @data, $customerId;
    }
    $bravoConnection->getSql->{getDistinctBravoCustomerIds}->{sth}->finish();

    return \@data;
}

sub getConnection {
    my $database = shift;
    my $sqlFile  = shift;

    my $connection;
    logit("Preparing $database connection", $logFile);
    eval {
        $connection = new Tap::DBConnection();
        $connection->setDatabase($database);
        $connection->connect;
        $connection->prepareSql($sqlFile);
    };
    if ($@) {
        logit($@, $logFile);
        pageit('stagingImport.pl' . $@);
        $connection->disconnect;
        $bravoConnection->disconnect if (defined $bravoConnection);

         
        ###Notify the Event Engine that we had an error
	    logit("erroring $eventTypeName event status", $logFile);
        EventLoaderDelegate->error($eventObject,$eventTypeName);
	    logit("errored $eventTypeName event status", $logFile);
		 

        die;
    }
    logit("$database connection acquired", $logFile);

    return $connection;
}

sub usage {
    print
        "bravoImportFork.pl -c <children> -m <med children> -b <big children> \n";
    exit 0;
}

