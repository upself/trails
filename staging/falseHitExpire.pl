#!/usr/bin/perl -w

##############################
# Automatic expire of a year old FALSE HIT discrepancy type and putting them to the recon queue
# Written by michal.starek@cz.ibm.com
##############################

use strict;
use POSIX;
use File::Copy;
use File::Basename;
use Base::Utils;
use Database::Connection;
use Tap::NewPerl;
use BRAVO::OM::SoftwareDiscrepancyHistory;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use Recon::Queue;

###############################
# Global variables
###############################

our $logfile    = "/var/staging/logs/falseHitExpire/falseHitExpire.log";
our $server       = "tap3";

our $falsehitage = 365; # number of days for FALSE HIT expiration

our $complexstring = "Complex discovery"; # this string in the field INSTALLED_SOFTWARE.INVALID_CATEGORY will prevent FALSE HIT from expiry
										  # mind the letter case

our $maxperonerun = 2; # maximum number of FALSE HITs to expire in one run of the script - this is to prevent system overload
                       # during the debugging, it's set to 2, my recommendation for run in production would be 100

logging_level( "debug" );
logfile($logfile);

###############################
# SUBS
###############################

sub getISWids {
	my $connection=shift;
	my %toret; # hash to return
	
	$connection->prepareSqlQueryAndFields(queryGetISWids());
	
	my $sth=$connection->sql->{getISWids};
	
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{getISWidsFields} } );

    ###Excute the query
    $sth->execute();

    ###Loop over query result set.
    while ( $sth->fetchrow_arrayref ) {
		$toret{ $rec{iSWid} } = $rec{slID};
    }
    $sth->finish;

	return %toret;
}

sub queryGetISWids {
	    my @fields = qw(
        iSWid
        slID
		);
    my $query = "
		select
			isw.id
			,isw.software_lpar_id
		from
			eaadmin.installed_software isw
				join
			( select sdh.installed_software_id as isw_id
					 ,days(current timestamp) - days(max(sdh.record_time)) as age
				from eaadmin.software_discrepancy_h sdh group by sdh.installed_software_id ) a
			on ( 	isw.id = a.isw_id
				and a.age > $falsehitage
				and isw.invalid_category <> \'$complexstring\'
				and isw.status = \'ACTIVE\'
				and isw.discrepancy_type_id = 3 )
			fetch first $maxperonerun rows only with ur
    ";
    dlog("queryReconQueueByCustomerId=$query");
    return ( 'getISWids', $query, \@fields );

}

#################################
#  MAIN
#################################

###Validate server
die "!!! ONLY RUN THIS LOADER ON $server !!!\n"
    unless validateServer($server);

ilog("FALSE HIT expirator started.");

my $connection = Database::Connection->new('trails');

my %iSWids = getISWids($connection); # hash of installed software IDs which are applicable for re-processing by recon engine.
									 # Keys = iSW ID, values = SW LPAR ID

ilog(scalar(keys %iSWids)." FALSE HITS to expire found.");

foreach my $currID (keys %iSWids) { # loop for all iSW IDs found to expire
	dlog("Working on iSW ID ".$currID);
	
	#### updating the SW discrepancy type of the iSW object
	
	$connection->prepareSqlQuery( 'updateISWdt', 'update eaadmin.installed_software set discrepancy_type_id = 7 where id = ?' );
	my $sth = $connection->sql->{updateISWdt};
	$sth->execute ( $currID );
	$sth->finish;
	
	#### inserting change of discrepancy to SD history
	
	my $SDhistory = new BRAVO::OM::SoftwareDiscrepancyHistory();
	
	$SDhistory->installedSoftwareId( $currID );
	$SDhistory->action("FALSE HIT RESET" );
	$SDhistory->comment("FALSE HIT auto-expire, $falsehitage days");
	
	$SDhistory->save($connection);
	
	#### insert iSW to iSW recon queue
	
	###Get installed software object
	my $installedSoftware = new BRAVO::OM::InstalledSoftware();
	$installedSoftware->id( $currID );
	$installedSoftware->getById($connection);
	dlog( "installed software=" . $installedSoftware->toString() );

	###Get software lpar object
	my $softwareLpar = new BRAVO::OM::SoftwareLpar();
	$softwareLpar->id( $iSWids{$currID} );
	$softwareLpar->getById($connection);
	dlog( "software lpar=" . $softwareLpar->toString() );
	
	###enqueue
	my $queue = Recon::Queue->new( $connection, $installedSoftware, $softwareLpar );
	$queue->add;
	dlog("Added installed software to queue");
	
}

$connection->disconnect;

ilog("FALSE HIT expirator exited normally.");
