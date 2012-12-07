package Recon::AlertSoftwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::Validation;
use Recon::OM::AlertSoftwareLpar;
use Recon::OM::AlertSoftwareLparHistory;
use BRAVO::OM::Customer;

sub new {
    my ( $class, $connection, $softwareLpar, $hardwareLpar ) = @_;
    my $self = {
                 _connection   => $connection,
                 _hardwareLpar => $hardwareLpar,
                 _softwareLpar => $softwareLpar
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'SoftwareLpar is undefined'
      unless defined $self->softwareLpar;
}

sub recon {
    my $self = shift;

    my $customer = new BRAVO::OM::Customer();
    $customer->id($self->softwareLpar->customerId);
    $customer->getById( $self->connection );

    my $validation = new Recon::Validation();
    $validation->customer( $customer );
    $validation->softwareLpar( $self->softwareLpar );

    if (    $validation->isValidCustomer == 0
         || $validation->isValidSoftwareLpar == 0 )
    {
        $self->closeAlert(0);
    }
    elsif ( defined $self->hardwareLpar ) {
        $self->closeAlert(1);
    }
    else {
        $self->openAlert;    
    }
}

sub openAlert {
    my $self = shift;

    my $alert = new Recon::OM::AlertSoftwareLpar();
    $alert->softwareLparId( $self->softwareLpar->id );
    $alert->getByBizKey( $self->connection );

    return if ( defined $alert->id && $alert->open == 1 );

    $self->recordHistory($alert) if defined $alert->id;

    $alert->creationTime( currentTimeStamp() );
    $alert->comments('Auto Open');
    $alert->open(1);
    $alert->save( $self->connection );
}

sub closeAlert {
    my ( $self, $save ) = @_;

    my $alert = new Recon::OM::AlertSoftwareLpar();
    $alert->softwareLparId( $self->softwareLpar->id );
    $alert->getByBizKey( $self->connection );

    return if ( defined $alert->id && $alert->open == 0 );

    if ( defined $alert->id ) {
        $self->recordHistory($alert);
        $save = 1;
    }
    else {
        $alert->creationTime( currentTimeStamp() );
    }

    $alert->comments('Auto Close');
    $alert->open(0);
    $alert->save( $self->connection ) if $save == 1;
}

sub recordHistory {
    my ( $self, $alert ) = @_;

    my $history = new Recon::OM::AlertSoftwareLparHistory();
    $history->alertSoftwareLparId( $alert->id );
    $history->creationTime( $alert->creationTime );
    $history->comments( $alert->comments );
    $history->open( $alert->open );
    $history->recordTime( $alert->recordTime );
    $history->save( $self->connection );
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
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
