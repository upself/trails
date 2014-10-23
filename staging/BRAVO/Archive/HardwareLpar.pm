package BRAVO::Archive::HardwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::ContactLpar;
use BRAVO::OM::HardwareLparEff;
use Recon::OM::AlertHardwareLpar;
use Recon::OM::AlertHardwareLparHistory;

sub new {
    my ( $class, $connection, $hardwareLpar ) = @_;
    my $self = {
        _connection   => $connection,
        _hardwareLpar => $hardwareLpar

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

    croak 'Hardware lpar is undefined'
      unless defined $self->hardwareLpar;
}

sub archive {
    my $self = shift;

    ilog('Delete lpar contacts');
    $self->deleteContactLpar;
    ilog('Deleted contact lpar');

    ilog('Deleting hardware lpar effective processor');
    $self->deleteHardwareLparEff;
    ilog('Deleted hardware lpar effective processor');

    ilog('Deleting alert hardware lpar');
    $self->deleteAlertHardwareLpar;
    ilog('Deleted alert hardware lpar');

    ilog('Deleting hardware lpar Software Lpar composite');
    $self->deleteHwSwComposite;
    ilog('Deleted hardware lpar Software Lpar composite');
    
    ilog('Deleting hardware lpar');
    $self->deleteHardwareLpar;
    ilog('Deleted hardware lpar');
}

sub deleteContactLpar {
    my $self = shift;

    my @ids = $self->getContactLparIds;

    foreach my $id (@ids) {
        my $contactLpar = new BRAVO::OM::ContactLpar();
        $contactLpar->id($id);
        $contactLpar->getById( $self->connection );
        dlog( $contactLpar->toString );

        $contactLpar->delete( $self->connection );
    }
}

sub deleteHardwareLparEff {
    my $self = shift;

    my $hardwareLparEff = new BRAVO::OM::HardwareLparEff();
    $hardwareLparEff->hardwareLparId( $self->hardwareLpar->id );
    $hardwareLparEff->getByBizKey( $self->connection );
    dlog( $hardwareLparEff->toString );

    if ( defined $hardwareLparEff->id ) {
        $hardwareLparEff->delete( $self->connection );
    }
}

sub deleteAlertHardwareLpar {
    my $self = shift;

    my $alertHardwareLpar = new Recon::OM::AlertHardwareLpar();
    $alertHardwareLpar->hardwareLparId( $self->hardwareLpar->id );
    $alertHardwareLpar->getByBizKey( $self->connection );
    dlog( $alertHardwareLpar->toString );

    if ( defined $alertHardwareLpar->id ) {

        dlog('Deleting alert hardware lpar history');
        $self->deleteAlertHardwareLparHistory( $alertHardwareLpar->id );
        dlog('Deleted alert hardware lpar history');

        $alertHardwareLpar->delete( $self->connection );
    }
}

sub deleteAlertHardwareLparHistory {
    my ( $self, $alertHardwareLparId ) = @_;

    my @ids = $self->getAlertHardwareLparHistoryIds($alertHardwareLparId);

    foreach my $id (@ids) {
        my $alertHardwareLparH = new Recon::OM::AlertHardwareLparHistory();
        $alertHardwareLparH->id($id);
        $alertHardwareLparH->getById( $self->connection );
        dlog( $alertHardwareLparH->toString );

        $alertHardwareLparH->delete( $self->connection );
    }
}

sub deleteHwSwComposite {
    my  $self =shift ;
    
        $self->connection->prepareSqlQuery(  $self->queryDeleteHwSwComposite );
         my $sth =  $self->connection->sql->{deleteHwSwComposite};
        $sth->execute(  $self->hardwareLpar->id  );
        $sth->finish;
}

sub queryDeleteHwSwComposite {
    my  $self =shift ;
    my $query = '	
		delete from hw_Sw_composite where hardware_lpar_id = ?
	';
    return ( 'deleteHwSwComposite', $query );
}

sub deleteHardwareLpar {
    my $self = shift;

    $self->hardwareLpar->delete( $self->connection );
}

sub getAlertHardwareLparHistoryIds {
    my ( $self, $alertHardwareLparId ) = @_;

    my @ids;

    dlog('Preparing alert hardware lpar history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryAlertHardwareLparHistoryIds );
    dlog('Alert hardware lpar history query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{alertHardwareLparHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{alertHardwareLparHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute($alertHardwareLparId);
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

sub queryAlertHardwareLparHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            alert_hw_lpar_h
		where
			alert_hw_lpar_id = ?
        };

    dlog("queryAlertHardwareLparHistoryIds=$query");
    return ( 'alertHardwareLparHistoryIds', $query, \@fields );    
}

sub getContactLparIds {
    my $self = shift;

    my @ids;

    dlog('Preparing contact lpar query');
    $self->connection->prepareSqlQueryAndFields( $self->queryContactLparIds );
    dlog('Prepared contact lpar query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{contactLparIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{contactLparIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->hardwareLpar->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryContactLparIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            cl.id
		from 
            contact_lpar cl
		where
			cl.hardware_lpar_id = ?
        };

    dlog("queryContactLparIds=$query");
    return ( 'contactLparIds', $query, \@fields );
}

sub log {
    my $self = shift;

    $self->hardwareLpar->toString;
}

sub connection {
    my ( $self, $value ) = @_;
    $self->{_connection} = $value if defined($value);
    return ( $self->{_connection} );
}

sub hardwareLpar {
    my ( $self, $value ) = @_;
    $self->{_hardwareLpar} = $value if defined($value);
    return ( $self->{_hardwareLpar} );
}

1;
