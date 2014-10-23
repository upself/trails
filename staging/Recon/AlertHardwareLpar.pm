package Recon::AlertHardwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Customer;
use Recon::Validation;
use Recon::OM::AlertHardwareLpar;
use Recon::OM::AlertHardwareLparHistory;
use Recon::CauseCode;

sub new {
    my ( $class, $connection, $hardware, $hardwareLpar, $softwareLpar ) = @_;
    my $self = {
                 _connection   => $connection,
                 _hardware     => $hardware,
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

    croak 'Hardware is undefined'
      unless defined $self->hardware;

    croak 'HardwareLpar is undefined'
      unless defined $self->hardwareLpar;
}

sub recon {
    my $self = shift;

    dlog("Acquiring customer");
    my $customer = new BRAVO::OM::Customer();
    $customer->id($self->hardwareLpar->customerId);
    $customer->getById( $self->connection );
    dlog("Customer acquired");

    my $validation = new Recon::Validation();
    $validation->customer( $customer );
    $validation->hardware( $self->hardware );
    $validation->hardwareLpar( $self->hardwareLpar );

    if (    $validation->isValidCustomer == 0
         || $validation->isValidHardware == 0
         || $validation->isValidHardwareLpar == 0 )
    {
        $self->closeAlert(0);
    }
    elsif ( defined $self->softwareLpar ) {
        $self->closeAlert(1);
    }
    else {
        $self->openAlert;
    }
}

sub openAlert {
    my $self = shift;

    dlog("Acquiring hardware lpar");
    my $alert = new Recon::OM::AlertHardwareLpar();
    $alert->hardwareLparId( $self->hardwareLpar->id );
    $alert->getByBizKey( $self->connection );
    dlog("Hardware lpar acquired");

    return if ( defined $alert->id && $alert->open == 1 );

    $self->recordHistory($alert) if defined $alert->id;

    $alert->creationTime( currentTimeStamp() );
    $alert->comments('Auto Open');
    $alert->open(1);
    $alert->save( $self->connection );
    
    Recon::CauseCode::updateCCtable( $alert->id, 4, $self->connection );
}

sub closeAlert {
    my ( $self, $save ) = @_;

    my $alert = new Recon::OM::AlertHardwareLpar();
    $alert->hardwareLparId( $self->hardwareLpar->id );
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
    
    Recon::CauseCode::updateCCtable( $alert->id, 4, $self->connection ) if ( $save == 1 ); # update CC table, 4 = HW LPAR w/o SW LPAR
}

sub recordHistory {
    my ( $self, $alert ) = @_;

    my $history = new Recon::OM::AlertHardwareLparHistory();
    $history->alertHardwareLparId( $alert->id );
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
