package Recon::InventoryLicense;

use strict;
use Base::Utils;
use Carp qw( croak );
use CNDB::Delegate::CNDBDelegate;
use BRAVO::OM::License;
use Recon::OM::Reconcile;
use Recon::Queue;
use Recon::Delegate::ReconDelegate;

sub new {
    my ( $class, $connection, $license ) = @_;
    my $self = {
                 _connection            => $connection,
                 _license               => $license,
                 _licenseAllocationData => undef,
                 _accountPoolChildren   => undef,
                 _licSwMap              => undef
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
        unless defined $self->connection;

    croak 'License is undefined'
        unless defined $self->license;
}

sub recon {
    my $self = shift;
    my %reconcilesToBreak;
    
    dlog("Began reconciliation of deleted license");
    
    if ( $self->license->status ne "INACTIVE" ) {
		dlog("License is not inactive, returning to Licensing engine");
		return 2;
	}

    $self->connection->prepareSqlQueryAndFields( $self->queryLicenseReconciles() );
    my $sth = $self->connection->sql->{licenseReconciles};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{licenseReconcilesFields} } );
    $sth->execute( $self->license->id );
    while ( $sth->fetchrow_arrayref ) {
        logRec( 'dlog', \%rec );
        
        $reconcilesToBreak{ $rec{rId} } = 1;
    }
    $sth->finish;

	foreach my $currID ( keys %reconcilesToBreak ) {
		Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection, $currID );
	}
    
    return 0;
}

sub queryLicenseReconciles {
    my @fields = qw(
        rId
    );
    my $query = '
        select
            r.id
        from
        	used_license ul
        	join reconcile_used_license rul on rul.used_license_id = ul.id
        	join reconcile r on r.id = rul.reconcile_id
        where
            ul.license_id = ?
        with ur
    ';
    return ( 'licenseReconciles', $query, \@fields );
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub license {
    my $self = shift;
    $self->{_license} = shift if scalar @_ == 1;
    return $self->{_license};
}

sub customer {
    my $self = shift;
    $self->{_customer} = shift if scalar @_ == 1;
    return $self->{_customer};
}

sub licenseAllocationData {
    my $self = shift;
    $self->{_licenseAllocationData} = shift if scalar @_ == 1;
    return $self->{_licenseAllocationData};
}

sub accountPoolChildren {
    my $self = shift;
    $self->{_accountPoolChildren} = shift if scalar @_ == 1;
    return $self->{_accountPoolChildren};
}

sub licSwMap {
    my $self = shift;
    $self->{_licSwMap} = shift if scalar @_ == 1;
    return $self->{_licSwMap};
}

1;

