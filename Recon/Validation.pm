package Recon::Validation;

use strict;
use Carp qw( croak );

sub new {
    my $class = shift;
    my $self = {
                 _customer     => undef,
                 _hardware     => undef,
                 _hardwareLpar => undef,
                 _softwareLpar => undef
    };
    bless $self, $class;

    return $self;
}

sub isValidCustomer {
    my $self = shift;

    croak 'Customer is not defined' if !defined $self->customer;

    return 0 if $self->customer->status ne 'ACTIVE';
    return 0 if !defined $self->customer->swLicenseMgmt;
    return 0 if $self->customer->swLicenseMgmt ne 'YES';

    return 1;
}

sub isValidHardware {
    my $self = shift;

    croak 'Hardware is not defined' if !defined $self->hardware;

    return 0 if $self->hardware->status ne 'ACTIVE';

    return 0 if $self->hardware->hardwareStatus ne 'ACTIVE';

    return 1;
}

sub isValidHardwareLpar {
    my $self = shift;

    croak 'HardwareLpar is not defined' if !defined $self->hardwareLpar;

    return 0 if $self->hardwareLpar->status ne 'ACTIVE';

    return 1;
}

sub isValidSoftwareLpar {
    my $self = shift;

    croak 'SoftwareLpar is not defined' if !defined $self->softwareLpar;

    return 0 if $self->softwareLpar->status ne 'ACTIVE';

    return 1;
}

sub customer {
    my $self = shift;
    $self->{_customer} = shift if scalar @_ == 1;
    return $self->{_customer};
}

sub hardware {
    my $self = shift;
    $self->{_hardware} = shift if scalar @_ == 1;
    return $self->{_hardware};
}

sub hardwareLpar {
    my $self = shift;
    $self->{_hardwareLpar} = shift if scalar @_ == 1;
    return $self->{_hardwareLpar};    
}

sub softwareLpar {
    my $self = shift;
    $self->{_softwareLpar} = shift if scalar @_ == 1;
    return $self->{_softwareLpar};    
}

1;
