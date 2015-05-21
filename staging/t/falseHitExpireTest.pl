#!/usr/bin/perl -w

##############################
# Automatic expire of a year old FALSE HIT discrepancy type and putting them to the recon queue
# Written by michal.starek@cz.ibm.com
##############################

use lib '/opt/staging/v2';

use strict;
use POSIX;
use Base::Utils;
use Database::Connection;
use Tap::NewPerl;

require '/opt/staging/v2/falseHitExpire.pl';

our $falsehitage=396;
our $complexstring="Complex discovery";
our $maxperonerun=5000;

my %certify; # iSW IDs to check if they have been found

my $connection = Database::Connection->new('trails');

$connection->prepareSqlQueryAndFields(queryEmptyGetISWids());
	
my $sth=$connection->sql->{getEmptyISWids};
	
my %rec;
$sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{getEmptyISWidsFields} } );

###Excute the query
$sth->execute();

###Loop over query result set.
while ( $sth->fetchrow_arrayref ) {
		$certify{ $rec{iSWid} } = 1;
}
$sth->finish;

my %iSWids = getISWids ( $connection );

my $success = 1;

foreach my $curr ( keys %certify ) {
	$success = 0 unless ( exists $iSWids{$curr} );
}

print "All ".scalar(keys %certify)." expired iSWs with NULL in INVALID_CATEGORY have been found! Success.\n" if ( $success == 1 );
print "Some expired iSWs with NULL in INVALID_CATEGORY have NOT been found! Fail.\n" if ( $success == 0 );

sub queryEmptyGetISWids {
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
				and isw.invalid_category is null
				and isw.status = \'ACTIVE\'
				and isw.discrepancy_type_id = 3 )
			fetch first $maxperonerun rows only with ur
    ";
    dlog("queryReconQueueByCustomerId=$query");
    return ( 'getEmptyISWids', $query, \@fields );

}
