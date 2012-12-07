package BRAVO::Loader::HardwareLparEff;

use strict;
use Carp qw( croak );
use Base::Utils;
use BRAVO::OM::HardwareLparEff;

###Object constructor.
sub new {
    my ( $class, $stagingConnection, $bravoConnection, $stagingHardwareLparEff,
        $bravoHardwareLpar )
      = @_;

    my $self = {
        _stagingConnection        => $stagingConnection,
        _bravoConnection          => $bravoConnection,
        _stagingHardwareLparEff   => $stagingHardwareLparEff,
        _bravoHardwareLpar        => $bravoHardwareLpar,
        _saveBravoHardwareLparEff => 0
    };
    bless $self, $class;

    ###Call validation
    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Staging connection is undefined'
      unless defined $self->stagingConnection;

    croak 'BRAVO connection is undefined'
      unless defined $self->bravoConnection;

    croak 'Staging hardware lpar eff is undefined'
      unless defined $self->stagingHardwareLparEff;

    croak 'Bravo hardware lpar is undefined'
      unless defined $self->bravoHardwareLpar;
}

sub logic {
    my $self = shift;

    $self->buildBravoHardwareLparEff;

    my $bravoHardwareLparEff = new BRAVO::OM::HardwareLparEff();

    if ( defined $self->bravoHardwareLpar->id ) {

        $bravoHardwareLparEff->hardwareLparId( $self->bravoHardwareLpar->id );
        $bravoHardwareLparEff->getByBizKey( $self->bravoConnection );
        dlog( $bravoHardwareLparEff->toString );

        if ( defined $bravoHardwareLparEff->id ) {
            ###We have a matching bravo hardware

            ###Set the new bravo hardware lpar id to the old id
            $self->bravoHardwareLparEff->id( $bravoHardwareLparEff->id );

            ###Set to save the bravo hardware lpar if they are not equal
            if ( !$bravoHardwareLparEff->equals( $self->bravoHardwareLparEff ) )
            {
                $self->saveBravoHardwareLparEff(1);
            }
        }
        else {
            ###This is a new record

            $self->saveBravoHardwareLparEff(1);
        }
    }
    else {
        ###This is a new record

        ###Set to save the hardware
        $self->saveBravoHardwareLparEff(1);
    }

}

sub save {
    my $self = shift;

    ###Save the license if we're supposed to
    if ( $self->saveBravoHardwareLparEff == 1 ) {
        my $temp = new BRAVO::OM::HardwareLparEff();
        $temp->hardwareLparId( $self->bravoHardwareLparEff->hardwareLparId );
        $temp->getByBizKey( $self->bravoConnection );
        $self->bravoHardwareLparEff->id( $temp->id );
        $self->bravoHardwareLparEff->save( $self->bravoConnection );
    }

    ###Return here if the staging license is already in complete
    return if $self->stagingHardwareLparEff->action eq 'COMPLETE';

    ###Delete the staging license and return, if we're supposed to
    if ( $self->stagingHardwareLparEff->action eq 'DELETE' ) {
        $self->stagingHardwareLparEff->delete( $self->stagingConnection );
        return;
    }

    ###Set the staging license to complete
    $self->stagingHardwareLparEff->action('COMPLETE');

    ###Save the staging license
    $self->stagingHardwareLparEff->save( $self->stagingConnection );
}

sub buildBravoHardwareLparEff {
    my $self = shift;

    my $bravoHardwareLparEff = new BRAVO::OM::HardwareLparEff();
    $bravoHardwareLparEff->hardwareLparId( $self->bravoHardwareLpar->id );
    $bravoHardwareLparEff->processorCount(
        $self->stagingHardwareLparEff->processorCount );
    $bravoHardwareLparEff->status( $self->stagingHardwareLparEff->status );

    $self->bravoHardwareLparEff($bravoHardwareLparEff);
}

sub stagingConnection {
    my ( $self, $value ) = @_;
    $self->{_stagingConnection} = $value if defined($value);
    return ( $self->{_stagingConnection} );
}

sub bravoConnection {
    my ( $self, $value ) = @_;
    $self->{_bravoConnection} = $value if defined($value);
    return ( $self->{_bravoConnection} );
}

sub stagingHardwareLparEff {
    my ( $self, $value ) = @_;
    $self->{_stagingHardwareLparEff} = $value if defined($value);
    return ( $self->{_stagingHardwareLparEff} );
}

sub bravoHardwareLparEff {
    my ( $self, $value ) = @_;
    $self->{_bravoHardwareLparEff} = $value if defined($value);
    return ( $self->{_bravoHardwareLparEff} );
}

sub bravoHardwareLpar {
    my ( $self, $value ) = @_;
    $self->{_bravoHardwareLpar} = $value if defined($value);
    return ( $self->{_bravoHardwareLpar} );
}

sub saveBravoHardwareLparEff {
    my ( $self, $value ) = @_;
    $self->{_saveBravoHardwareLparEff} = $value if defined($value);
    return ( $self->{_saveBravoHardwareLparEff} );
}

1;
