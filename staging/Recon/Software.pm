package Recon::Software;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use Recon::Queue;

sub new {
    my ( $class, $connection, $software ) = @_;
    my $self = {
                 _connection         => $connection,
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
    
    return if(!defined $self->installedSoftwares);

    foreach my $installedSoftwareId ( keys %{ $self->installedSoftwares } ) {
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($installedSoftwareId);

        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->customerId( $self->installedSoftwares->{$installedSoftwareId} );

        my $queue = Recon::Queue->new( $self->connection, $installedSoftware, $softwareLpar );
        $queue->add;    
    }
}

sub retrieveInstalledSoftwareRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareRecordsBySoftwareId() );
    my $sth = $self->connection->sql->{installedSoftwareRecordsBySoftwareId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedSoftwareRecordsBySoftwareIdFields} } );
    $sth->execute( $self->software->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->addToInstalledSoftwares( $rec{installedSoftwareId}, $rec{customerId} );
    }
    $sth->finish;
}

sub queryInstalledSoftwareRecordsBySoftwareId {
    my @fields = (qw( customerId installedSoftwareId ));
    my $query  = qq{
        select
        	sl.customer_id
        	,is.id
        from
            customer c
            ,software_lpar sl
        	,installed_software is
        where
            c.status = 'ACTIVE'
            and c.sw_license_mgmt = 'YES'
            and c.customer_id = sl.customer_id
            and sl.id = is.software_lpar_id
            and sl.status = 'ACTIVE'
        	and is.software_id = ?
        	and is.status = 'ACTIVE'
        with ur        	
    };
    return ( 'installedSoftwareRecordsBySoftwareId', $query, \@fields );
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

sub software {
    my $self = shift;
    $self->{_software} = shift if scalar @_ == 1;
    return $self->{_software};
}

1;
