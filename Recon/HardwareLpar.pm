package Recon::HardwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Hardware;
use Recon::Lpar;
use Recon::AlertHardwareLpar;
use Recon::AlertZeroHWProcessorCount;
use Recon::AlertZeroHwChipCount;
use Recon::Hardware;

sub new {
    my ( $class, $connection, $hardwareLpar ) = @_;
    my $self = {
                 _connection   => $connection,
                 _hardwareLpar => $hardwareLpar
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Hardware Lpar is undefined'
      unless defined $self->hardwareLpar;
}

sub recon {
    my $self = shift;

    ilog("Entering recon method of ReconHardwareLparDelegate");
    ilog( $self->hardwareLpar->toString );

    ilog("Obtaining the Hardware object");
    my $hardware = new BRAVO::OM::Hardware();
    $hardware->id( $self->hardwareLpar->hardwareId );
    $hardware->getById( $self->connection );
    ilog("Obtained the Hardware object");
    ilog( $hardware->toString );

    ###Create recon lpar object
    my $reconLpar = new Recon::Lpar();

    ###Set the database connection
    $reconLpar->connection( $self->connection );

    ###Set the hardware lpar
    $reconLpar->hardwareLpar( $self->hardwareLpar );

    ###Set the hardware
    $reconLpar->hardware($hardware);

    ###Call the recon method of the recon lpar object
    ilog("Performing recon");
    $reconLpar->recon;
    ilog("Recon complete");

    ###Run the alert logic
    ilog("Performing alert logic");
    my $alert = Recon::AlertHardwareLpar->new( $self->connection,$reconLpar->hardware,$self->hardwareLpar, $reconLpar->softwareLpar );
    $alert->recon;
    
    my $alertZeorHwProCount =new Recon::AlertZeroHWProcessorCount($self->connection,$reconLpar->hardware,$self->hardwareLpar);
    $alertZeorHwProCount->recon;
    
    my $alertZeorHWChipsCount =new Recon::AlertZeroHwChipCount($self->connection,$reconLpar->hardware,$self->hardwareLpar);
    $alertZeorHWChipsCount->recon;
    ilog("Alert logic complete");

    ###Call recon on items we have designated to reconcile from the recon logic
    ilog("Performing additional reconciliations");
    $reconLpar->performAdditionalRecons;
    ilog("Additional reconciliations complete");

    ###Call recon on the hardware object
    my $recon = Recon::Hardware->new( $self->connection, $hardware );
    $recon->recon;

    ilog("Recon complete");
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

1;
