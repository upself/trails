package MachineTypeDelegate;

use strict;
use Base::Utils;

#TODO should we externalize the connections on these
#We need some kind of standard on that
#TODO Should this be in bravo delegates

###11/13/07

sub getMachineTypeMap {
    my ($self) = @_;

    
    dlog('Start getMachineTypeMap method');

    my %data;

    ###Get a trails connection
    my $connection = Database::Connection->new('trails');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryMachineTypeMap() );

    ###Get the statement handle
    my $sth = $connection->sql->{machineTypeMap};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{machineTypeMapFields} } );

    dlog('Executing query');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        $data{ $rec{name} } = $rec{id};
    }
    $sth->finish;
    dlog('Executed query');

    ###Close the trails connection
    $connection->disconnect;

    dlog('End getMachineTypeMap method');

    return \%data;
}

sub queryMachineTypeMap {
    my @fields = (qw( id name ));
    my $query  = '
        select
            a.id
            ,upper(a.name)
        from
            machine_type a
        where
            a.status = \'ACTIVE\'
        with ur
    ';

    return ( 'machineTypeMap', $query, \@fields );
}
1;
