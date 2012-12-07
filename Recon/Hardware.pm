package Recon::Hardware;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::AlertHardware;

sub new {
    my ( $class, $connection, $hardware ) = @_;
    my $self = {
                 _connection => $connection,
                 _hardware   => $hardware
    };
    bless $self, $class;

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

sub recon {
    my $self = shift;

    my $alert = Recon::AlertHardware->new($self->connection, $self->hardware);
    $alert->recon;
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub hardware {
    my $self = shift;
    $self->{_hardware} = shift if scalar @_ == 1;
    return $self->{_hardware};    
}

1;
