package BRAVO::Archive::Hardware;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::ContactHardware;
use Recon::OM::AlertHardware;
use Recon::OM::AlertHardwareHistory;

sub new {
    my ( $class, $connection, $hardware ) = @_;
    my $self = {
        _connection => $connection,
        _hardware   => $hardware

    };
    bless $self, $class;
    dlog("instantiated self");

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Hardware is undefined'
      unless defined $self->hardware;
}

sub archive {
    my $self = shift;

    ilog('Deleting hardware contacts');
    $self->deleteContactHardware;
    ilog('Hardware contacts deleted');

    ilog('Deleting hardware alerts');
    $self->deleteAlertHardware;
    ilog('Hardware alerts deleted');

    ilog('Deleting hardware');
    $self->deleteHardware;
    ilog('Hardware deleted');
}

sub deleteContactHardware {
    my $self = shift;

    my @ids = $self->getContactHardwareIds;

    foreach my $id (@ids) {
        my $contactHardware = new BRAVO::OM::ContactHardware();
        $contactHardware->id($id);
        $contactHardware->getById( $self->connection );
        ilog( $contactHardware->toString );

        $contactHardware->delete( $self->connection );
    }
}

sub deleteAlertHardware {
    my $self = shift;

    my $alertHardware = new Recon::OM::AlertHardware();
    $alertHardware->hardwareId( $self->hardware->id );
    $alertHardware->getByBizKey( $self->connection );
    ilog( $alertHardware->toString );

    if ( defined $alertHardware->id ) {

        ilog('Deleting alert hardware history');
        $self->deleteAlertHardwareHistory( $alertHardware->id );
        ilog('Alert hardware history deleted');

        $alertHardware->delete( $self->connection );
    }
}

sub deleteAlertHardwareHistory {
    my ( $self, $alertHardwareId ) = @_;

    my @ids = $self->getAlertHardwareHistoryIds($alertHardwareId);
    
    foreach my $id (@ids) {
        my $alertHardwareH = new Recon::OM::AlertHardwareHistory();
        $alertHardwareH->id($id);
        $alertHardwareH->getById( $self->connection );
        ilog( $alertHardwareH->toString );

        $alertHardwareH->delete( $self->connection );
    }
}

sub deleteHardware {
    my $self = shift;

    $self->hardware->delete( $self->connection );
}

sub getAlertHardwareHistoryIds {
    my ( $self, $alertHardwareId ) = @_;

    my @ids;

    dlog('Preparing alert hardware history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryAlertHardwareHistoryIds );
    dlog('Alert hardware history query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{alertHardwareHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{alertHardwareHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute($alertHardwareId);
    dlog('Query executed');

    dlog('Looping throw resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Looped through resultset');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryAlertHardwareHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            alert_hardware_h
		where
			alert_hardware_id = ?
        };

    dlog("queryAlertHardwareHistoryIds=$query");
    return ( 'alertHardwareHistoryIds', $query, \@fields );
}

sub getContactHardwareIds {
    my $self = shift;

    my @ids;

    dlog('Preparing contact hardware query');
    $self->connection->prepareSqlQueryAndFields( $self->queryContactHardwareIds );
    dlog('Hardware contact query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{contactHardwareIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{contactHardwareIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->hardware->id );
    dlog('Query executed');

    dlog('Looping throw resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Looped through resultset');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryContactHardwareIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            ch.id
		from 
            contact_hardware ch
		where
			ch.hardware_id = ?
        };

    dlog("queryContactHardwareIds=$query");
    return ( 'contactHardwareIds', $query, \@fields );
}

sub log {
    my $self = shift;

    $self->hardware->toString;
}

sub connection {
    my ( $self, $value ) = @_;
    $self->{_connection} = $value if defined($value);
    return ( $self->{_connection} );
}

sub hardware {
    my ( $self, $value ) = @_;
    $self->{_hardware} = $value if defined($value);
    return ( $self->{_hardware} );
}

1;
