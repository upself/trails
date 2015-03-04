package Recon::CustomerSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use Recon::Queue;

sub new {
    my ( $class, $connection, $customer, $software ) = @_;
    my $self = { _connection         => $connection,
                 _customer           => $customer,
                 _software           => $software,
                 _installedSoftwares => undef
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
        unless defined $self->connection;

    croak 'Customer is undefined'
        unless defined $self->customer;

    croak 'Software is undefined'
        unless defined $self->software;
}

sub recon {
    my $self = shift;

    ###Retrieve all installed software records
    $self->retrieveInstalledSoftwareRecords;

    ###Throw everything into the queue
    $self->queue;
}

sub queue {
    my $self = shift;

    return if ( !defined $self->installedSoftwares );

    foreach my $installedSoftwareId ( keys %{ $self->installedSoftwares } ) {
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($installedSoftwareId);

        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->customerId(
                          $self->installedSoftwares->{$installedSoftwareId} );

        my $queue = Recon::Queue->new( $self->connection, $installedSoftware,
                                       $softwareLpar );
        $queue->add;
    }
}

sub retrieveInstalledSoftwareRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields(
            $self->queryInstalledSoftwareRecordsBySoftwareIdAndCustomerId() );
    my $sth = $self->connection->sql
        ->{installedSoftwareRecordsBySoftwareIdAndCustomerId};
    my %rec;
    $sth->bind_columns(
           map { \$rec{$_} } @{
               $self->connection->sql
                   ->{installedSoftwareRecordsBySoftwareIdAndCustomerIdFields}
               }
    );
    $sth->execute( $self->customer->id, $self->software->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->addToInstalledSoftwares( $rec{installedSoftwareId},
                                        $self->customer->id );
    }
    $sth->finish;
}

sub queryInstalledSoftwareRecordsBySoftwareIdAndCustomerId {
    my @fields = (qw( installedSoftwareId ));
    my $query  = qq{
        select
        	is.id
        from
            customer c
            ,software_lpar sl
        	,installed_software is
        where
            c.customer_id = ?
            and c.status = 'ACTIVE'
            and c.sw_license_mgmt = 'YES'
            and c.customer_id = sl.customer_id
            and sl.id = is.software_lpar_id
            and sl.status = 'ACTIVE'
        	and is.software_id = ?
        	and is.status = 'ACTIVE'        	
        with ur
    };
    return ( 'installedSoftwareRecordsBySoftwareIdAndCustomerId',
             $query, \@fields );
}

sub addToInstalledSoftwares {
    my ( $self, $id, $customerId ) = @_;

    my $installedSoftwares = $self->installedSoftwares;
    $installedSoftwares->{$id} = $customerId;

    $self->installedSoftwares($installedSoftwares);
}

sub installedSoftwares {
    my $self = shift;
    $self->{_installedSoftwares} = shift if scalar @_ == 1;
    return $self->{_installedSoftwares};
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub customer {
    my $self = shift;
    $self->{_customer} = shift if scalar @_ == 1;
    return $self->{_customer};
}

sub software {
    my $self = shift;
    $self->{_software} = shift if scalar @_ == 1;
    return $self->{_software};
}

1;
