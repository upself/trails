package SoftwareTlcmzDelegate;

use strict;
use Database::Connection;

sub getSoftwareTlcmzMap {
    my( $self ) = @_;

    my %data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQuery( querySoftwareTlcmz());

    ###Define the fields
    my @fields = ( qw(id softwareId tlcmzProductId) );

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{software};

    ###Bind the columns
    my %rec;
    $sth->bind_columns(map {\$rec{$_}} @fields);

    ###Execute the query
    $sth->execute();

    while($sth->fetchrow_arrayref) {
        $data{$rec{tlcmzProductId}}{'id'} = $rec{id};
        $data{$rec{tlcmzProductId}}{'softwareId'} = $rec{softwareId};
    }

    ###Close the statement handle
    $sth->finish;

    $trailsConnection->disconnect;

    ###Return the bank account
    return \%data;
}

sub querySoftwareTlcmz {
    my $query = '
        select
            a.id
            ,a.software_id
            ,a.sa_product
        from
            sa_product a
        where
            a.software_id != 1000
            and a.status = \'ACTIVE\'
    ';

    return ('software',$query);
}
1;
