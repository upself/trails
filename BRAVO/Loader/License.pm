package BRAVO::Loader::License;

use strict;
use Carp qw( croak );
use Base::Utils;
use Recon::Queue;
use BRAVO::OM::LicenseSoftwareMap;
use BRAVO::OM::License;
use Staging::OM::License;

###Object constructor.
sub new {
    my ( $class, $stagingConnection, $bravoConnection, $stagingId ) = @_;
    my $self = {
        _stagingConnection   => $stagingConnection,
        _bravoConnection     => $bravoConnection,
        _stagingId           => $stagingId,
        _stagingLicense      => undef,
        _bravoLicense        => undef,
        _bravoLicSwMap       => undef,
        _saveBravoLicense    => 0,
        _saveBravoLicSwMap   => 0,
        _deleteBravoLicSwMap => 0

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

    croak 'staging id is undefined'
      unless defined $self->stagingId;

    ###Get the staging license
    $self->stagingLicense( new Staging::OM::License() );
    $self->stagingLicense->id( $self->stagingId );
    $self->stagingLicense->getById( $self->stagingConnection );
    dlog( $self->stagingLicense->toString );

    #TODO getbyid should return a null object
    croak 'Cannot find staging license by ID'
      unless defined $self->stagingLicense->extSrcId;
}

sub logic {
    my $self = shift;

    ###Build a bravo license from the staging license
    $self->buildBravoLicense;

    ###Find the license in bravo by extSrcId
    my $bravoLicense = new BRAVO::OM::License();
    $bravoLicense->extSrcId( $self->stagingLicense->extSrcId );
    $bravoLicense->getByBizKey( $self->bravoConnection );
    dlog( $bravoLicense->toString );

    $self->bravoLicSwMap( new BRAVO::OM::LicenseSoftwareMap() );
    if ( defined $bravoLicense->id ) {
        ###We have a matching bravo license

        ###Set the new bravo license id to the old id
        $self->bravoLicense->id( $bravoLicense->id );

        ###Set to save the bravo license if they are not equal
        if ( !$bravoLicense->equals( $self->bravoLicense ) ) {
            $self->saveBravoLicense(1);
        }

        ###Find the software map in bravo
        $self->bravoLicSwMap->licenseId( $bravoLicense->id );
        $self->bravoLicSwMap->getByBizKey( $self->bravoConnection );
        dlog( $self->bravoLicSwMap->toString );

        if ( defined $self->bravoLicSwMap->id ) {
            ###We have a current map

            if ( defined $self->stagingLicense->softwareId ) {
                ###Staging license has a software ID

                if ( $self->bravoLicSwMap->softwareId != $self->stagingLicense->softwareId ) {
                    ###software IDs are not equal

                    ###Set the software id
                    $self->bravoLicSwMap->softwareId( $self->stagingLicense->softwareId );

                    ###Set to save the license map
                    $self->saveBravoLicSwMap(1);
                }
            }
            else {
                ###Delete the map as staging has no software id
                $self->deleteBravoLicSwMap(1);
            }
        }
        else {
            if ( defined $self->stagingLicense->softwareId ) {
                ###Staging license has a software ID

                ###Set the software id
                $self->bravoLicSwMap->softwareId( $self->stagingLicense->softwareId );

                ###Set to save the license map
                $self->saveBravoLicSwMap(1);
            }
        }
    }
    else {
        ###This is a new record

        ###Set to save the license
        $self->saveBravoLicense(1);

        if ( defined $self->stagingLicense->softwareId ) {
            ###Staging license has a software ID

            ###Set the software id
            $self->bravoLicSwMap->softwareId( $self->stagingLicense->softwareId );

            ###Set to save the license map
            $self->saveBravoLicSwMap(1);
        }
    }
}

sub save {
    my $self = shift;

    ###Save the license if we're supposed to
    $self->bravoLicense->save( $self->bravoConnection ) if ( $self->saveBravoLicense == 1 );

    ###Set the license map license id
    $self->bravoLicSwMap->licenseId( $self->bravoLicense->id );

    ###Save the license map, if we're supposed to
    $self->bravoLicSwMap->save( $self->bravoConnection ) if ( $self->saveBravoLicSwMap == 1 );

    ###Delete the license map, if we're supposed to
    $self->bravoLicSwMap->delete( $self->bravoConnection ) if ( $self->deleteBravoLicSwMap == 1 );

    ###Call the recon engine if we save or delete anything
    $self->recon
      if ( $self->saveBravoLicense == 1 || $self->saveBravoLicSwMap == 1 || $self->deleteBravoLicSwMap == 1 );

    ###Return here if the staging license is already in complete
    return if $self->stagingLicense->action eq 'COMPLETE';

    ###Delete the staging license and return, if we're supposed to
    if ( $self->stagingLicense->action eq 'DELETE' ) {
        $self->stagingLicense->delete( $self->stagingConnection );
        return;
    }

    ###Set the staging license to complete
    $self->stagingLicense->action('COMPLETE');

    ###Save the staging license
    $self->stagingLicense->save( $self->stagingConnection );
}

sub recon {
    my $self = shift;

    ###Add the license to the queue
    my $queue = Recon::Queue->new( $self->bravoConnection, $self->bravoLicense );
    $queue->add;
}

sub buildBravoLicense {
    my $self = shift;

    my $bravoLicense = new BRAVO::OM::License();
    $bravoLicense->customerId( $self->stagingLicense->customerId );
    $bravoLicense->licType( $self->stagingLicense->licType );
    $bravoLicense->capType( $self->stagingLicense->capType );
    $bravoLicense->quantity( $self->stagingLicense->quantity );
    $bravoLicense->ibmOwned( $self->stagingLicense->ibmOwned );
    $bravoLicense->draft( $self->stagingLicense->draft );
    $bravoLicense->pool( $self->stagingLicense->pool );
    $bravoLicense->tryAndBuy( $self->stagingLicense->tryAndBuy );
    $bravoLicense->expireDate( $self->stagingLicense->expireDate );
    $bravoLicense->endDate( $self->stagingLicense->endDate );
    $bravoLicense->poNumber( $self->stagingLicense->poNumber );
    $bravoLicense->prodName( $self->stagingLicense->prodName );
    $bravoLicense->fullDesc( $self->stagingLicense->fullDesc );
    $bravoLicense->version( $self->stagingLicense->version );
    $bravoLicense->cpuSerial( $self->stagingLicense->cpuSerial );
    $bravoLicense->licenseStatus( $self->stagingLicense->licenseStatus );
    $bravoLicense->extSrcId( $self->stagingLicense->extSrcId );
    $bravoLicense->status( $self->stagingLicense->status );
    $bravoLicense->agreementType( $self->stagingLicense->agreementType );
    $bravoLicense->environment($self->stagingLicense->environment);
    $bravoLicense->lparName($self->stagingLicense->lparName);
    
    $self->bravoLicense($bravoLicense);
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

sub stagingId {
    my ( $self, $value ) = @_;
    $self->{_stagingId} = $value if defined($value);
    return ( $self->{_stagingId} );
}

sub stagingLicense {
    my ( $self, $value ) = @_;
    $self->{_stagingLicense} = $value if defined($value);
    return ( $self->{_stagingLicense} );
}

sub bravoLicense {
    my ( $self, $value ) = @_;
    $self->{_bravoLicense} = $value if defined($value);
    return ( $self->{_bravoLicense} );
}

sub bravoLicSwMap {
    my ( $self, $value ) = @_;
    $self->{_bravoLicSwMap} = $value if defined($value);
    return ( $self->{_bravoLicSwMap} );
}

sub saveBravoLicense {
    my ( $self, $value ) = @_;
    $self->{_saveBravoLicense} = $value if defined($value);
    return ( $self->{_saveBravoLicense} );
}

sub saveBravoLicSwMap {
    my ( $self, $value ) = @_;
    $self->{_saveBravoLicSwMap} = $value if defined($value);
    return ( $self->{_saveBravoLicSwMap} );
}

sub deleteBravoLicSwMap {
    my ( $self, $value ) = @_;
    $self->{_deleteBravoLicSwMap} = $value if defined($value);
    return ( $self->{_deleteBravoLicSwMap} );
}

1;
