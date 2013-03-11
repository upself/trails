package Recon::Customer;

use strict;
use Base::Utils;
use Carp qw( croak );

sub new {
    my ( $class, $connection, $customer ) = @_;
    my $self = {
                 _connection         => $connection,
                 _customer           => $customer,
                 _hardwares          => {},
                 _hardwareLpars      => {},
                 _softwareLpars      => {},
                 _licenses           => {},
                 _installedSoftwares => {}
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
}

sub recon {
    my $self = shift;

    ###Retrieve all hardware records and their hardware lpars
    $self->retrieveHardwareRecords;
    $self->retrieveHardwareLparRecords;

    ###Retrieve all software lpar records, and their inst sw.
    $self->retrieveSoftwareLparRecords;
    $self->retrieveInstalledSwRecords;

    ###Retrieve all license records.
    $self->retrieveLicenseRecords;

    ###Throw everything into the queue
    $self->queue;
}

sub queue {
    my $self = shift;

    foreach my $hardwareId ( keys %{ $self->hardwares } ) {
        my $hardware = new BRAVO::OM::Hardware();
        $hardware->id($hardwareId);
        $hardware->customerId( $self->customer->id );

        my $queue = Recon::Queue->new( $self->connection, $hardware );
        $queue->add;
    }

    foreach my $hardwareLparId ( keys %{ $self->hardwareLpars } ) {    
        my $hardwareLpar = new BRAVO::OM::HardwareLpar();
        $hardwareLpar->id($hardwareLparId);
        $hardwareLpar->customerId( $self->customer->id );

        my $queue = Recon::Queue->new( $self->connection, $hardwareLpar );
        $queue->add;
    }

    foreach my $softwareLparId ( keys %{ $self->softwareLpars } ) {
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id($softwareLparId);
        $softwareLpar->customerId( $self->customer->id );

        my $queue = Recon::Queue->new( $self->connection, $softwareLpar );
        $queue->add;
    }

    foreach my $installedSoftwareId ( keys %{ $self->installedSoftwares } ) {
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($installedSoftwareId);

        my $queue = Recon::Queue->new( $self->connection, $installedSoftware, $self->customer );
        $queue->add;
    }

    foreach my $licenseId ( keys %{ $self->licenses } ) {
        my $license = new BRAVO::OM::License();
        $license->id($licenseId);
        $license->customerId( $self->customer->id );

        my $queue = Recon::Queue->new( $self->connection, $license );
        $queue->add;
    }

}

sub retrieveHardwareRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields( $self->queryHardwareIdsByCustomerId() );
    my $sth = $self->connection->sql->{hardwareIdsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{hardwareIdsByCustomerIdFields} } );
    $sth->execute( $self->customer->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->hardwares->{ $rec{hardwareId} } = 1;
    }
    $sth->finish;
}

sub queryHardwareIdsByCustomerId {
    my @fields = (qw( hardwareId ));

    my $query = qq{
        select
            h.id
        from 
            hardware h        
        where 
            h.customer_id = ?
            and not exists (select 1 from recon_hardware rh where rh.hardware_id = h.id)
    };

    return ( 'hardwareIdsByCustomerId', $query, \@fields );
}


sub retrieveHardwareLparRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields( $self->queryHardwareLparIdsByCustomerId() );
    my $sth = $self->connection->sql->{hardwareLparIdsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{hardwareLparIdsByCustomerIdFields} } );
    $sth->execute( $self->customer->id, $self->customer->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->hardwareLpars->{ $rec{hardwareLparId} } = 1;
    }
    $sth->finish;
}

sub queryHardwareLparIdsByCustomerId {
    my @fields = (qw( hardwareLparId ));

    my $query = qq{
        select         
            hl.id
        from 
            hardware h,
            hardware_lpar hl
        where
            h.id = hl.hardware_id
            and hl.customer_id = ?
            and h.customer_id = ?
            and not exists (select 1 from recon_hw_lpar rhl where rhl.hardware_lpar_id  = hl.id)
    };

    return ( 'hardwareLparIdsByCustomerId', $query, \@fields );
}

sub retrieveSoftwareLparRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareLparIdsByCustomerId() );
    my $sth = $self->connection->sql->{softwareLparIdsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareLparIdsByCustomerIdFields} } );
    $sth->execute( $self->customer->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->softwareLpars->{ $rec{softwareLparId} } = 1;
    }
    $sth->finish;
}

sub querySoftwareLparIdsByCustomerId {
    my @fields = (qw( softwareLparId ));
    my $query  = qq{
        select
            sl.id
        from 
            software_lpar sl
        where 
            sl.customer_id = ?
            and not exists (select 1 from recon_sw_lpar rsl where rsl.software_lpar_id  = sl.id)
    };
    return ( 'softwareLparIdsByCustomerId', $query, \@fields );
}

sub retrieveInstalledSwRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledSwIdsByCustomerId() );
    my $sth = $self->connection->sql->{installedSwIdsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedSwIdsByCustomerIdFields} } );
    $sth->execute( $self->customer->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->installedSoftwares->{ $rec{installedSoftwareId} } = 1;
    }
    $sth->finish;
}

sub queryInstalledSwIdsByCustomerId {
    my @fields = (qw( installedSoftwareId ));
    my $query  = qq{
        select
            is.id
        from 
            software_lpar sl join installed_software is 
            on sl.id = is.software_lpar_id
        where 
            sl.customer_id = ?
            and not exists (select 1 from recon_installed_sw ris where ris.installed_software_id = is.id)
    };
    return ( 'installedSwIdsByCustomerId', $query, \@fields );
}

sub retrieveLicenseRecords {
    my $self = shift;

    $self->connection->prepareSqlQueryAndFields( $self->queryLicenseIdsByCustomerId() );
    my $sth = $self->connection->sql->{licenseIdsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{licenseIdsByCustomerIdFields} } );
    $sth->execute( $self->customer->id );
    while ( $sth->fetchrow_arrayref ) {
        $self->licenses->{ $rec{id} } = 1;
    }
    $sth->finish;

}

sub queryLicenseIdsByCustomerId {
    my @fields = (qw( id ));
    my $query  = qq{
        select
            l.id
        from 
            license l
        where 
            l.customer_id = ?
            and not exists (select 1 from recon_license rl where rl.license_id  = l.id)
    };
    return ( 'licenseIdsByCustomerId', $query, \@fields );
}

sub hardwares {
    my $self = shift;
    $self->{_hardwares} = shift if scalar @_ == 1;
    return $self->{_hardwares};
}

sub hardwareLpars {
    my $self = shift;
    $self->{_hardwareLpars} = shift if scalar @_ == 1;
    return $self->{_hardwareLpars};
}

sub softwareLpars {
    my $self = shift;
    $self->{_softwareLpars} = shift if scalar @_ == 1;
    return $self->{_softwareLpars};
}

sub installedSoftwares {
    my $self = shift;
    $self->{_installedSoftwares} = shift if scalar @_ == 1;
    return $self->{_installedSoftwares};
}

sub licenses {
    my $self = shift;
    $self->{_licenses} = shift if scalar @_ == 1;
    return $self->{_licenses};
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
1;
