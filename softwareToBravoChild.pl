#!/usr/bin/perl -w

###TODO: log this given batch if failed.

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use BRAVO::SoftwareLoader;
use Base::ConfigManager;
use Tap::NewPerl;
use Database::Connection;

###Check usage.
use vars qw( $opt_d $opt_a $opt_i $opt_l $opt_c $opt_p $opt_s);
getopts("d:a:i:l:c:p:s:");
die "Usage: $0"
    . " -d <load-delta-only> -a <apply-changes> -i <customerId>"
    . " -l <logfile> -c <configFile> \n"
    unless (    defined $opt_d
             && defined $opt_a
             && defined $opt_i
             && defined $opt_l
             && defined $opt_c
             && defined $opt_p
             && defined $opt_s );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
    or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
    or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
    or die "ERROR: Unable to direct STDERR to /dev/null: $!";

my $stagingConnection;
my $trailsConnection;
my $swassetConnection;
eval {
    my $cfgMgr = Base::ConfigManager->instance($opt_c);
    $stagingConnection = Database::Connection->new('staging');
    $trailsConnection = Database::Connection->new('trails');
    $swassetConnection = Database::Connection->new('swasset');

    logfile($opt_l);
    logging_level( $cfgMgr->debugLevel );

    ilog(   "starting child: loadDeltaOnly=$opt_d, applyChanges=$opt_a"
          . ", customerId=$opt_i"
          . ", logfile=$opt_l, configFile=$opt_c, phase=$opt_p" );

    my @lpars = findSoftwareLparsByCustomerIdByDate($opt_i,$opt_s,$stagingConnection);
    foreach my $id ( @lpars ) {
    ###Load software lpar data
    my $loader = new BRAVO::SoftwareLoader($stagingConnection,$trailsConnection,$swassetConnection);
    $loader->load(
                   LoadDeltaOnly => $opt_d,
                   ApplyChanges  => $opt_a,
                   CustomerId    => $opt_i,
                   Phase => $opt_p,
                   LparId => $id
    );
   }

    ilog(   "stopping child: loadDeltaOnly=$opt_d, applyChanges=$opt_a"
          . ", customerId=$opt_i"
          . ", logfile=$opt_l, configFile=$opt_c, phase=$opt_p" );
};
if ($@) {
    elog($@);
}
$stagingConnection->disconnect;
$trailsConnection->disconnect;
$swassetConnection->disconnect;

sub findSoftwareLparsByCustomerIdByDate {
    my ($customerId,$date,$connection) = @_;

    my @lparIds;

    ###Prepare query to pull software lpar ids from staging
    dlog("preparing software lpar ids query");
    $connection->prepareSqlQueryAndFields( querySoftwareLparsByCustomerIdByDate($opt_p) );
    dlog("prepared software lpar ids query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids query");
    my $sth = $connection->sql->{softwareLparsByCustomerIdByDate};
    dlog("got sth for software lpar ids query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparsByCustomerIdByDateFields} } );
    dlog("binded columns for software lpar ids query");

    ###Excute the query
    ilog("executing software lpar ids query");
    $sth->execute($customerId,$date);
    ilog("executed software lpar ids query");

    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );
        push @lparIds, $rec{id};
    }

    return @lparIds;
}

sub querySoftwareLparsByCustomerIdByDate {
    my $phase = shift;
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from software_lpar a
        left outer join software_lpar_map b on
            a.id = b.software_lpar_id
        left outer join scan_record c on
            b.scan_record_id = c.id
    ';
    if ( $phase == 1 ) {
        $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
    }
    elsif ( $phase == 2 ) {
        $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
    }
    elsif ( $phase == 3 ) {
        $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
    }
    elsif ( $phase == 4 ) {
        $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
    }
    elsif ( $phase == 5 ) {
        $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
    }
        $query .= '
        where
            a.customer_id = ?
            and date(a.scan_time) = ?
            and (a.action != \'COMPLETE\'
            or b.action != \'COMPLETE\'
        ';
        if ( $phase == 1 ) {
            $query .= '
                or sm.action != \'COMPLETE\'
            ';
        }
        elsif ( $phase == 2 ) {
            $query .= '
                or sd.action != \'COMPLETE\'
            ';
        }
        elsif ( $phase == 3 ) {
            $query .= '
                or st.action != \'COMPLETE\'
            ';
        }
        elsif ( $phase == 4 ) {
            $query .= '
                or sf.action != \'COMPLETE\'
            ';
        }
        elsif ( $phase == 5 ) {
            $query .= '
                or ss.action != \'COMPLETE\'
            ';
        }
        $query .= ')';
    $query .= '
        group by
            a.id
        order by
            a.id
        with ur
    ';
    return ( 'softwareLparsByCustomerIdByDate', $query, \@fields );
}


exit 0;

