#!/usr/bin/perl -w

###############################################################################
# Name          : bravoReportFork.pl
# Component		: Staging
# Description	: spawns multiple bravoReport.pl scripts for generating
#                 software multireport for each customer
###############################################################################

###############################################################################
### Use/Require Statements
###
###############################################################################
use lib '/opt/staging/v2'; 
use strict;
use Getopt::Long qw(GetOptions);
use POSIX ":sys_wait_h";
require "/opt/staging/v2/Database/Connection.pm";   
use HealthCheck::Delegate::EventLoaderDelegate;#Added by Larry for HealthCheck And Monitor Module - Phase 2B


###############################################################################
### Get parameters
###
###############################################################################

my $maxChildren   = undef;
GetOptions(
'c=i' => \$maxChildren,
) or die "Usage: $0 -c max_children\n";

die "Usage: $0 -c max_children\n"
  unless defined $maxChildren;

###############################################################################
### Set Script Variables
###
###############################################################################
my %children      = ();
my $children      = 0;
my $sleepTime     = 5;
my @logArray      = qw(1 2 3 4 5 6);
my $logFilePath       = '/opt/reports/swMulti/logs/bravoReportFork.log';
my $reportScript  = '/opt/reports/swMulti/bravoReport.pl';
#my $reportScript  = '/opt/bravo/scripts/report/sw_multi_report';
my $eventTypeName = 'BRAVOREPORTFORK_START_STOP_SCRIPT';#Added by Larry for HealthCheck And Monitor Module - Phase 2B
my $eventObject;#Added by Larry for HealthCheck And Monitor Module - Phase 2B
my $logFile;
open($logFile, '>>', $logFilePath);
$SIG{CHLD} = \&REAPER;


###############################################################################
### Main
###
###############################################################################
eval {#Added by Larry for HealthCheck And Monitor Module - Phase 2B

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	###Notify Event Engine that we are starting.
    logit("eventTypeName=$eventTypeName", $logFile);
	logit("starting $eventTypeName event status", $logFile);
    $eventObject = EventLoaderDelegate->start($eventTypeName);
    logit("started $eventTypeName event status", $logFile);

	sleep 1;#sleep 1 second to resolve the startTime and endTime is the same case if process is too quick

    logit("Selecting customerIDs form database", $logFile);
    my $customerIds = getIds();
    logit("CustomerIDs selected, stasrting child spawning loop", $logFile);
    logit("CustomerIDs selected num @$customerIds[1]", $logFile);

foreach my $customerId (sort @{$customerIds}) {
    logit("In spawning loop", $logFile);

    # spawn child unless maxed out
    while ($children >= $maxChildren) {
        logit("Sleeping", $logFile);
        sleep $sleepTime;
    }

    logit("Spawning child for customer: $customerId", $logFile);
    spawnScript($customerId, shift @logArray);
}

# wait till  all children die

while ($children != 0) {
    sleep 5;
}

};

#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
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
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End
# End of Program
close $logFile;
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

sub getIds {

    my $dbh;
    my $customerId;
    my @data;
    eval {
        $dbh = Database::Connection->new("trails");
        my $query = "select
                      distinct customer_id
                  from
                      software_lpar
                  where
                      status = 'ACTIVE'
                  and customer_id not in (999999)  
                  with ur";
        $dbh->prepareSqlQuery( 'CustomersIDs', $query);
        my $sth = $dbh->sql->{CustomersIDs};
		$sth->bind_columns(\$customerId);
		$sth->execute();
		while ( $sth->fetchrow_arrayref ) {
			push @data, $customerId;
		}
		$sth->finish();
    };
    if ($@) {
        logit($@, $logFile);
        $dbh->disconnect;

        #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start 
        ###Notify the Event Engine that we had an error
	    logit("erroring $eventTypeName event status", $logFile);
        EventLoaderDelegate->error($eventObject,$eventTypeName);
	    logit("errored $eventTypeName event status", $logFile);
		#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

        die;
    }

    return \@data;
}

sub logit { 
	my ($string, $logfile) = @_ ;
	print $logfile "$string"."\n";
}       

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


