package BRAVO::Loader::HardwareLpar;

use strict;
use Carp qw( croak );
use Base::Utils;
use BRAVO::OM::HardwareLpar;
use Staging::OM::HardwareLparEff;
use BRAVO::Loader::HardwareLparEff;
use Recon::Queue;
use BRAVO::OM::Hardware;
use BRAVO::OM::SoftwareLpar;

###Object constructor.
sub new {
    my ( $class, $stagingConnection, $bravoConnection, $stagingHardwareLpar,
        $bravoHardware )
        = @_;

    my $self = {
        _stagingConnection     => $stagingConnection,
        _bravoConnection       => $bravoConnection,
        _stagingHardwareLpar   => $stagingHardwareLpar,
        _bravoHardware         => $bravoHardware,
        _bravoHardwareLpar     => undef,
        _saveBravoHardwareLpar => 0,
        _error                 => 0,
        _reconDeep             => 0,
        _reconHardware         => undef,
        _hardwareLparEffLoader => undef

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

    croak 'Staging hardware lpar is undefined'
        unless defined $self->stagingHardwareLpar;

    croak 'Bravo hardware is undefined'
        unless defined $self->bravoHardware;
}

sub logic {
    my $self = shift;

    $self->buildBravoHardwareLpar;

    ###Find the hardware lpar in bravo
    my $bravoHardwareLpar = new BRAVO::OM::HardwareLpar();
    $bravoHardwareLpar->customerId( $self->bravoHardwareLpar->customerId );
    $bravoHardwareLpar->name( $self->bravoHardwareLpar->name );
    $bravoHardwareLpar->getByBizKey( $self->bravoConnection );
    dlog( $bravoHardwareLpar->toString );

    if ( defined $bravoHardwareLpar->id ) {
        ###We have a matching bravo hardware lpar

        ###Set the new bravo hardware lpar id to the old id
        $self->bravoHardwareLpar->id( $bravoHardwareLpar->id );

        ###Set to save the bravo hardware lpar if they are not equal
        if ( !$bravoHardwareLpar->equals( $self->bravoHardwareLpar ) ) {
            $self->saveBravoHardwareLpar(1);

            if($bravoHardwareLpar->partMIPS != $self->bravoHardwareLpar->partMIPS) {
                $self->reconDeep(1);    
            }
            elsif($bravoHardwareLpar->partMSU != $self->bravoHardwareLpar->partMSU) {
                $self->reconDeep(1);    
            }
            
            if ( defined $self->bravoHardwareLpar->hardwareId ) {
                if ( $self->bravoHardwareLpar->hardwareId
                    != $bravoHardwareLpar->hardwareId )
                {
                    $self->reconDeep(1);

                    my $bravoHardware = new BRAVO::OM::Hardware();
                    $bravoHardware->id( $bravoHardwareLpar->hardwareId );
                    $bravoHardware->getById( $self->bravoConnection );
                    dlog( $bravoHardware->toString );

                    $self->reconHardware($bravoHardware);
                }
            }
            else {
                $self->reconDeep(1);
            }
        }
    }
    else {
        ###This is a new record

        ###Set to save the hardware
        $self->saveBravoHardwareLpar(1);
    }

    $self->processHardwareLparEff;
}

sub processHardwareLparEff {
    my $self = shift;

    my $stagingHardwareLparEff = new Staging::OM::HardwareLparEff();
    $stagingHardwareLparEff->hardwareLparId( $self->stagingHardwareLpar->id );
    $stagingHardwareLparEff->getByBizKey( $self->stagingConnection );
    dlog( $stagingHardwareLparEff->toString );

    return if ( !defined $stagingHardwareLparEff->id );

    if ( $self->stagingHardwareLpar->action eq 'DELETE' ) {
        if ( $stagingHardwareLparEff->action ne 'DELETE' ) {
            $self->error(1);
            $self->stagingHardwareLpar->action('UPDATE');
           	$self->stagingHardwareLpar->save( $self->stagingConnection );
            return;
        }
    }

    my $hardwareLparEffLoader = new BRAVO::Loader::HardwareLparEff(
        $self->stagingConnection, $self->bravoConnection,
        $stagingHardwareLparEff,  $self->bravoHardwareLpar
    );

    $hardwareLparEffLoader->logic;

    $self->hardwareLparEffLoader($hardwareLparEffLoader);
}
sub save {
    my $self = shift;

    return if $self->error == 1;

    ###Save the license if we're supposed to
    $self->bravoHardwareLpar->save( $self->bravoConnection )
        if ( $self->saveBravoHardwareLpar == 1 );

    if ( defined $self->hardwareLparEffLoader ) {
        $self->hardwareLparEffLoader->bravoHardwareLparEff->hardwareLparId(
            $self->bravoHardwareLpar->id );
        $self->hardwareLparEffLoader->save;
    }

    ###Call the recon engine if we save anything
    if ( $self->saveBravoHardwareLpar == 1 ) {
        $self->recon;
    }
    elsif($self->reconDeep == 1) {
        $self->recon;
    }
    elsif ( defined $self->hardwareLparEffLoader ) {
        if ( $self->hardwareLparEffLoader->saveBravoHardwareLparEff == 1 ) {
            $self->recon;
        }
    }

    ###Return here if the staging license is already in complete
    return if $self->stagingHardwareLpar->action eq 'COMPLETE';

    ###Delete the staging license and return, if we're supposed to
    if ( $self->stagingHardwareLpar->action eq 'DELETE' ) {
        $self->stagingHardwareLpar->delete( $self->stagingConnection );
        return;
    }

    ###Set the staging license to complete
    $self->stagingHardwareLpar->action('COMPLETE');

    ###Save the staging license
    $self->stagingHardwareLpar->save( $self->stagingConnection );
}

sub recon {
    my $self = shift;

    my $queue = Recon::Queue->new( $self->bravoConnection,
        $self->bravoHardwareLpar );
    $queue->add;

    if ( $self->reconDeep == 1 ) {
        my $softwareLparId = $self->getSoftwareLparId;

        if ( defined $softwareLparId ) {
            my $softwareLpar = new BRAVO::OM::SoftwareLpar();
            $softwareLpar->id($softwareLparId);
            $softwareLpar->getById( $self->bravoConnection );
            dlog( $softwareLpar->toString );

            my $queue
                = Recon::Queue->new( $self->bravoConnection, $softwareLpar,
                undef, 'DEEP' );
            $queue->add;
        }
    }

    if ( defined $self->reconHardware ) {
        my $queue = Recon::Queue->new( $self->bravoConnection,
            $self->reconHardware );
        $queue->add;
    }
}

sub getSoftwareLparId {
    my ( $self, $softwareLpar ) = @_;

    $self->bravoConnection->prepareSqlQueryAndFields(
        $self->queryHwSwComposite );
    my $sth = $self->bravoConnection->sql->{hwSwComposite};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->bravoConnection->sql->{hwSwCompositeFields} } );
    $sth->execute( $self->bravoHardwareLpar->id );
    $sth->fetchrow_arrayref;
    $sth->finish;

    return $rec{softwareLparId};
}

sub queryHwSwComposite {
    my $self = shift;

    my @fields = qw(
        softwareLparId
    );

    my $query = qq{
        select
            software_lpar_id
        from
            hw_sw_composite
        where
            hardware_lpar_id = ?      
    };

    dlog("queryHwSwComposite=$query");
    return ( 'hwSwComposite', $query, \@fields );
}

sub buildBravoHardwareLpar {
    my $self = shift;

    my $bravoHardwareLpar = new BRAVO::OM::HardwareLpar();
    $bravoHardwareLpar->name( $self->stagingHardwareLpar->name );
    $bravoHardwareLpar->customerId( $self->stagingHardwareLpar->customerId );
    $bravoHardwareLpar->hardwareId( $self->bravoHardware->id );
    $bravoHardwareLpar->status( $self->stagingHardwareLpar->status );
    $bravoHardwareLpar->lparStatus( $self->stagingHardwareLpar->lparStatus );
    $bravoHardwareLpar->extId( $self->stagingHardwareLpar->extId );
    $bravoHardwareLpar->techImageId(
        $self->stagingHardwareLpar->techImageId );
    $bravoHardwareLpar->serverType($self->stagingHardwareLpar->serverType );
    $bravoHardwareLpar->partMIPS($self->stagingHardwareLpar->partMIPS );
    $bravoHardwareLpar->partMSU($self->stagingHardwareLpar->partMSU );

    $self->bravoHardwareLpar($bravoHardwareLpar);
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

sub stagingHardwareLpar {
    my ( $self, $value ) = @_;
    $self->{_stagingHardwareLpar} = $value if defined($value);
    return ( $self->{_stagingHardwareLpar} );
}

sub bravoHardware {
    my ( $self, $value ) = @_;
    $self->{_bravoHardware} = $value if defined($value);
    return ( $self->{_bravoHardware} );
}

sub bravoHardwareLpar {
    my ( $self, $value ) = @_;
    $self->{_bravoHardwareLpar} = $value if defined($value);
    return ( $self->{_bravoHardwareLpar} );
}

sub saveBravoHardwareLpar {
    my ( $self, $value ) = @_;
    $self->{_saveBravoHardwareLpar} = $value if defined($value);
    return ( $self->{_saveBravoHardwareLpar} );
}

sub error {
    my ( $self, $value ) = @_;
    $self->{_error} = $value if defined($value);
    return ( $self->{_error} );
}

sub reconDeep {
    my ( $self, $value ) = @_;
    $self->{_reconDeep} = $value if defined($value);
    return ( $self->{_reconDeep} );
}

sub reconHardware {
    my ( $self, $value ) = @_;
    $self->{_reconHardware} = $value if defined($value);
    return ( $self->{_reconHardware} );
}

sub hardwareLparEffLoader {
    my ( $self, $value ) = @_;
    $self->{_hardwareLparEffLoader} = $value if defined($value);
    return ( $self->{_hardwareLparEffLoader} );
}

1;
