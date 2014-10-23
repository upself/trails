package SoftwareDelegate;

use strict;
use Database::Connection;

sub getSoftwareMap {
    my( $self ) = @_;

    my %data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQuery( $self->querySoftware());

    ###Define the fields
    my @fields = ( qw(softwareId) );

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{software};

    ###Bind the columns
    my %rec;
    $sth->bind_columns(map {\$rec{$_}} @fields);

    ###Execute the query
    $sth->execute();

    while($sth->fetchrow_arrayref) {
        $data{$rec{softwareId}} = $rec{softwareId};
    }

    ###Close the statement handle
    $sth->finish;

    $trailsConnection->disconnect;

    ###Return the bank account
    return \%data;
}

sub querySoftware {
    my $query = '
        select
            a.software_id
        from
            software a
            ,kb_definition b
        where
            a.software_id != 1000
            and a.software_id=b.id
            and b.deleted != 1
    ';

    return ('software',$query);
}
1;
