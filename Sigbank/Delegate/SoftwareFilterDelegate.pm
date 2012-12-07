package SoftwareFilterDelegate;

use strict;
use Database::Connection;

sub getSoftwareFilterMap {
    my( $self ) = @_;

    my %data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQuery( $self->querySoftwareFilter());

    ###Define the fields
    my @fields = ( qw(softwareFilterId softwareId softwareName softwareVersion) );

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{softwareFilter};

    ###Bind the columns
    my %rec;
    $sth->bind_columns(map {\$rec{$_}} @fields);

    ###Execute the query
    $sth->execute();

    while($sth->fetchrow_arrayref) {
        cleanValues(\%rec);
        $data{$rec{softwareName}}{$rec{softwareVersion}}{'softwareFilterId'} = $rec{softwareFilterId};
        $data{$rec{softwareName}}{$rec{softwareVersion}}{'softwareId'} = $rec{softwareId};
    }

    ###Close the statement handle
    $sth->finish;

    $trailsConnection->disconnect;

    ###Return the bank account
    return \%data;
}

sub querySoftwareFilter {
    my $query = '
        select
            a.software_filter_id
            ,a.software_id
            ,a.software_name
            ,a.software_version
        from
            software_filter a
        where
            a.software_id != 1000
            and a.status = \'ACTIVE\'
    ';

    return ('softwareFilter',$query);
}
1;
