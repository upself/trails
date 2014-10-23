package BRAVO::Archive::LicenseSoftwareMap;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::License;
use Recon::Queue;

sub new {
    my ( $class, $connection, $licenseSwMap ) = @_;
    my $self = {
                 _connection   => $connection,
                 _licenseSwMap => $licenseSwMap
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

    croak 'License software map is undefined'
      unless defined $self->licenseSwMap;
}

sub archive {
    my $self = shift;

    ilog('Deleting license software map');
    $self->deleteLicenseSoftwareMap;
    ilog('Deleted license software map');
}

sub deleteSoftwareLpar {
    my $self = shift;

    my $license = new BRAVO::OM::LicenseSoftwareMap();
    $license->id($self->licenseSwMap->licenseId);
    $license->getById($self->connection);
    $self->licenseSwMap->delete( $self->connection );
    my $recon = new Recon::Queue($self->connection, $license);
    $recon->add;
}

sub log {
    my $self = shift;

    $self->licenseSwMap->toString;
}

sub connection {
    my ( $self, $value ) = @_;
    $self->{_connection} = $value if defined($value);
    return ( $self->{_connection} );
}

sub licenseSwMap {
    my ( $self, $value ) = @_;
    $self->{_licenseSwMap} = $value if defined($value);
    return ( $self->{_licenseSwMap} );
}

1;
