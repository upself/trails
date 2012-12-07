#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Copy;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;    
use Database::Connection;
use Base::ConfigManager;
use Tap::NewPerl;

###Globals
my $logfile    = "/var/staging/logs/expiredMaintManager/expiredMaintManager.log";
my $pidFile    = "/tmp/expiredMaintManager.pid";
my $configFile = "/opt/staging/v2/config/expiredMaintManagerConfig.txt";

###Initialize properties
my $cfgMgr       = Base::ConfigManager->instance($configFile);
my $server       = $cfgMgr->server;
my $testMode     = $cfgMgr->testMode;
my $applyChanges = $cfgMgr->applyChanges;
my $sleepPeriod  = 86400;

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
  unless validateServer($server);

###Make a daemon.
chdir "/tmp";
umask 0;
defined( my $pid = fork )
  or die "ERROR: Unable to fork: $!";
exit if $pid;
setsid or die "ERROR: Unable to setsid: $!";

####Handle usage and user action.
loaderStart( shift @ARGV, $pidFile );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

###Set the logging level
logging_level( $cfgMgr->debugLevel );

###Set the logfile
logfile($logfile);

###Set the job name of this script to update the status
my $job = 'EXPIRED MAINT MGR';
my $systemScheduleStatus;

###Wrap everything in an eval so we can capture in logfile.
eval {
    ###Execute loader once, and then continue to execute
    ###based on existance of pid file.
    $| = 1;
    while (1) {

        ###Notify system schedule status that we are starting.
        dlog("job=$job");
        if ( $applyChanges == 1 ) {
            ###Notify the scheduler that we are starting
            ilog("starting $job system schedule status");
            $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
            ilog("started $job system schedule status");
        }

        ###Get a connection to bravo
        ilog("getting bravo db connection");
        my $bravoConnection = Database::Connection->new('trails');
        die "Unable to get bravo db connection!\n"
          unless defined $bravoConnection;
        ilog("got bravo db connection");

        ###Add lics with expired maint to recon queue.
        eval {
            $bravoConnection->prepareSqlQuery( queryAddExpiredLicsToQueue($testMode) );

            my $sth = $bravoConnection->sql->{addExpiredLicsToQueue};
            $sth->execute();
            $sth->finish;
        };
        if ($@) {
            ###Close the bravo db connection
            ilog("disconnecting bravo db connection");
            $bravoConnection->disconnect;
            ilog("disconnected bravo db connection");
            die $@;
        }

        ###Close the bravo db connection
        ilog("disconnecting bravo db connection");
        $bravoConnection->disconnect;
        ilog("disconnected bravo db connection");

        ###Check if we should stop.
        last if loaderCheckForStop($pidFile) == 1;
        sleep $sleepPeriod;
    }
};
if ($@) {
    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we had an error
        ilog("erroring $job system schedule status");
        SystemScheduleStatusDelegate->error($systemScheduleStatus);
        ilog("errored $job system schedule status");
    }

    elog($@);
    die $@;
}
else {
    if ( $applyChanges == 1 ) {

        ###Notify the scheduler that we are stopping
        ilog("stopping $job system schedule status");
        SystemScheduleStatusDelegate->stop($systemScheduleStatus);
        ilog("stopped $job system schedule status");
    }
}

exit 0;

sub queryAddExpiredLicsToQueue {
    my ($testMode) = @_;
    my $query = '	
		insert into recon_license
		(
		    license_id
		    ,customer_id
		    ,action
		    ,remote_user
		    ,record_time
		)
		select
			l.id
			,c.customer_id
			,\'UPDATE\'
			,\'STAGING\'
			,CURRENT TIMESTAMP
		from license l
			join customer c on c.customer_id = l.customer_id
		where c.status = \'ACTIVE\'
			and c.sw_license_mgmt = \'YES\'
			and l.status = \'ACTIVE\'
			and days(l.expire_date) - days(current timestamp) < 0
			and not exists (select 1 from alert_expired_maint aem where aem.license_id = l.id and open = 1)
	';
    if ( $testMode == 1 ) {
        $query .= '
    		and c.customer_id in (' . $cfgMgr->testCustomerIdsAsString() . ')';
    }
    $query .= '
		union
		select
			l.id
			,c.customer_id
			,\'UPDATE\'
			,\'STAGING\'
			,CURRENT TIMESTAMP
		from license l
			join customer c on c.customer_id = l.customer_id
		where c.status = \'ACTIVE\'
			and c.sw_license_mgmt = \'YES\'
			and l.status = \'ACTIVE\'
			and days(l.expire_date) - days(current timestamp) >= 0
			and exists (select 1 from alert_expired_maint aem where aem.license_id = l.id and open = 1)
	';
    if ( $testMode == 1 ) {
        $query .= '
    		and c.customer_id in (' . $cfgMgr->testCustomerIdsAsString() . ')';
    }
    dlog("queryAddExpiredLicsToQueue=$query");
    return ( 'addExpiredLicsToQueue', $query );
}
