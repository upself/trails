package HardwareLparDelegate;

use Database::Connection;
use Base::Utils;

use strict;

sub getHardwareLparCustomerMap {
    my( $self, $connection ) = @_;

    my %data;
    my $data2;

    dlog('Preparing our staging query');
    $connection->prepareSqlQueryAndFields( $self->queryHardwareLparCustomerMap());
    dlog('Staging query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{hardwareLparCustomerMap};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns(
        map {\$rec{$_}} @{ $connection->sql->{hardwareLparCustomerMapFields} });
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute();
    while( $sth->fetchrow_arrayref ) {

        $data2 = ();

        my $shortName = (split( /\./, uc($rec{name}) ) )[0];
        $shortName = uc($rec{name}) if ( ! defined $shortName );

        $data2->{uc($rec{name})}->{'serialNumber'} = uc($rec{serial});
        $data2->{uc($rec{name})}->{'customerId'} = $rec{customerId};

        push ( @{ $data{uc($shortName)} }, $data2);
    }

    return \%data;
}

sub queryHardwareLparCustomerMap {
    my @fields = ( qw(
        customerId
        name
        serial
    ));
    my $query = '
        select
            a.customer_id
            ,a.name
            ,b.serial
        from
            hardware_lpar a
            ,hardware b
        where
            a.status = \'ACTIVE\'
            and a.hardware_id = b.id
        with ur
    ';

    return( 'hardwareLparCustomerMap',$query,\@fields );
}
1;
