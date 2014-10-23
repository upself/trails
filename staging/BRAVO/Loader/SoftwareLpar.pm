package BRAVO::Loader::SoftwareLpar;

use strict;
use Carp qw( croak );
use Base::Utils;
use Recon::Queue;
use BRAVO::OM::SoftwareLpar;

#use Staging::OM::HardwareLpar;
#use BRAVO::Loader::HardwareLpar;
use Recon::Queue;
use BRAVO::Delegate::BRAVODelegate;

###Object constructor.
sub new {
    my ( $class, $stagingConnection, $bravoConnection, $stagingSoftwareLpar )
        = @_;
    my $self = {
        _stagingConnection      => $stagingConnection,
        _bravoConnection        => $bravoConnection,
        _stagingSoftwareLpar    => $stagingSoftwareLpar,
        _error                  => 0,
        _reconDeep              => 0,
        _bravoSoftwareLpar      => undef,
        _saveBravoSoftwareLpar  => 0,
        _stagingHardwareLparIds => undef,
        _hardwareLparLoaders    => undef
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

    croak 'Staging hardware is undefined'
        unless defined $self->stagingSoftwareLpar;
}

sub logic {
    my $self = shift;

    ##Need test case for this
    if (   $self->isMapDelete == 0
        && $self->stagingSoftwareLpar->action eq 'DELETE' )
    {

        #Go no further because a map related to this is not in delete
        #The scanRecordToLpar should fix this automatically
        return;
    }
    
    #When building set status to inactive if action is delete
    $self->buildBravoSoftwareLpar;

    my $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar();
    $bravoSoftwareLpar->customerId( $self->stagingSoftwareLpar->customerId );
    $bravoSoftwareLpar->getByBizKey( $self->bravoConnection );
    dlog( $bravoSoftwareLpar->toString );

    if ( defined $bravoSoftwareLpar->id ) {
        ###We have a matching bravo software lpar

        ###Set the new bravo software lpar id to the old id
        $self->bravoSoftwareLpar->id( $bravoSoftwareLpar->id );

        ###Set to save the bravo software lpar if they are not equal
        if ( !$bravoSoftwareLpar->equals( $self->bravoSoftwareLpar ) ) {
            $self->saveBravoSoftwareLpar(1);

            if ( $bravoSoftwareLpar->extId ne $self->bravoSoftwareLpar->extId
                || $bravoSoftwareLpar->biosSerial ne
                $self->bravoSoftwareLpar->biosSerial
                || $bravoSoftwareLpar->processorCount
                != $self->bravoSoftwareLpar->processorCount )
            {
                $self->reconDeep(1);
            }
        }
    }
    else {
        ###This is a new record

        ###Set to save the software lpar
        ###If we are saving a new one, then we need to process all records
        $self->saveBravoSoftwareLpar(1);
    }

    $self->processADC;
    $self->processHdisk;
    $self->processIpAddress;
    $self->processMemMod;
    $self->processProcessor;
    $self->processSoftwareDorana;
    $self->processSoftwareFilter;
    $self->processSoftwareManual;
    $self->processSoftwareSignature;
    $self->processSoftwareTlcmz;
}

sub processADC {
    my $self = shift;
}

sub processHdisk {
    my $self = shift;
}

sub processIpAddress {
    my $self = shift;
}

sub processMemMod {
    my $self = shift;
}

sub processProcessor {
    my $self = shift;
}

sub processSoftwareDorana {
    my $self = shift;
}

sub processSoftwareFilter {
    my $self = shift;
}

sub processSoftwareManual {
    my $self = shift;
}

sub processSoftwareSignature {
    my $self = shift;

    $self->getStagingInstalledSignatureIds;

    foreach my $id ( sort @{ $self->stagingInstalledSignatureIds } ) {
        my $stagingInstalledSignature = new Staging::OM::SoftwareSignature();
        $stagingInstalledSignature->id($id);
        $stagingInstalledSignature->getById( $self->stagingConnection );
        dlog( $stagingInstalledSignature->toString );

        my $installedSignatureLoader = new BRAVO::Loader::InstalledSignature(
            $self->stagingConnection,   $self->bravoConnection,
            $stagingInstalledSignature, $self->bravoSoftwareLpar
        );
        $installedSignatureLoader->reconDeep( $self->reconDeep );
        $installedSignatureLoader->logic;
        if ( $installedSignatureLoader->error == 1 ) {
            $self->error(1);
            last;
        }
        $self->addToInstalledSignatureLoaders ($installedSignatureLoader);
    }
}

sub processSoftwareTlcmz {
    my $self = shift;
}

sub save {
    my $self = shift;

    return if $self->error == 1;

    ###Save the software lpar if we're supposed to
    $self->bravoHardware->save( $self->bravoConnection )
        if ( $self->saveBravoHardware == 1 );

    ###Call save on the hardware lpar objects
    if ( defined $self->hardwareLparLoaders ) {
        foreach my $hardwareLparLoader ( @{ $self->hardwareLparLoaders } ) {
            $hardwareLparLoader->bravoHardwareLpar->hardwareId(
                $self->bravoHardware->id );
            $hardwareLparLoader->save;
        }
    }

    ###Call the recon engine if we save anything
    $self->recon
        if ( $self->saveBravoHardware == 1 );

    ###Return here if the staging hardware is already in complete
    return if $self->stagingHardware->action eq 'COMPLETE';

    ###Delete the staging hardware and return, if we're supposed to
    if ( $self->stagingHardware->action eq 'DELETE' ) {
        $self->stagingHardware->delete( $self->stagingConnection );
        return;
    }

    ###Set the staging license to complete
    $self->stagingHardware->action('COMPLETE');

    ###Save the staging license
    $self->stagingHardware->save( $self->stagingConnection );
}

sub recon {
    my $self = shift;

    my $queue
        = Recon::Queue->new( $self->bravoConnection, $self->bravoHardware );
    $queue->add;
}

sub getStagingHardwareLparIds {
    my $self = shift;

    my @ids;
    my %rec;

    $self->stagingConnection->prepareSqlQueryAndFields(
        $self->queryHardwareLparData() );
    my $sth = $self->stagingConnection->sql->{hardwareLparData};
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->stagingConnection->sql->{hardwareLparDataFields} } );
    $sth->execute( $self->stagingHardware->id );
    while ( $sth->fetchrow_arrayref ) {
        push @ids, $rec{id};
    }
    $sth->finish;

    $self->stagingHardwareLparIds( \@ids );
}

sub queryHardwareLparData {
    my $self = shift;

    my @fields = qw(
        id
    );

    my $query = '
        select
            hl.id
        from
            hardware_lpar hl
        where
            hl.hardware_id = ?
    ';

    dlog("queryHardwareLparData=$query");
    return ( 'hardwareLparData', $query, \@fields );
}

sub buildBravoHardware {
    my $self = shift;

    my $bravoHardware = new BRAVO::OM::Hardware();
    $bravoHardware->machineTypeId( $self->stagingHardware->machineTypeId );
    $bravoHardware->serial( $self->stagingHardware->serial );
    $bravoHardware->country( $self->stagingHardware->country );
    $bravoHardware->owner( $self->stagingHardware->owner );
    $bravoHardware->customerNumber( $self->stagingHardware->customerNumber );
    $bravoHardware->hardwareStatus( $self->stagingHardware->hardwareStatus );
    $bravoHardware->status( $self->stagingHardware->status );
    $bravoHardware->customerId( $self->stagingHardware->customerId );
    $bravoHardware->processorCount( $self->stagingHardware->processorCount );
    $bravoHardware->classification( $self->stagingHardware->classification );
    $bravoHardware->chips( $self->stagingHardware->chips );
    $bravoHardware->model( $self->stagingHardware->model );
    $bravoHardware->processorType( $self->stagingHardware->processorType );
    $self->bravoHardware($bravoHardware);
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

sub stagingHardware {
    my ( $self, $value ) = @_;
    $self->{_stagingHardware} = $value if defined($value);
    return ( $self->{_stagingHardware} );
}

sub bravoHardware {
    my ( $self, $value ) = @_;
    $self->{_bravoHardware} = $value if defined($value);
    return ( $self->{_bravoHardware} );
}

sub saveBravoHardware {
    my ( $self, $value ) = @_;
    $self->{_saveBravoHardware} = $value if defined($value);
    return ( $self->{_saveBravoHardware} );
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

sub stagingHardwareLparIds {
    my ( $self, $value ) = @_;
    $self->{_stagingHardwareLparIds} = $value if defined($value);
    return ( $self->{_stagingHardwareLparIds} );
}

sub hardwareLparLoaders {
    my ( $self, $value ) = @_;
    $self->{_hardwareLparLoaders} = $value if defined($value);
    return ( $self->{_hardwareLparLoaders} );
}

sub addToHardwareLparLoaders {
    my ( $self, $value ) = @_;

    my @array;

    if ( defined $self->hardwareLparLoaders ) {
        @array = @{ $self->hardwareLparLoaders };
    }
    push @array, $value;
    $self->hardwareLparLoaders( \@array );
}

1;
