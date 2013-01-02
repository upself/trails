package BRAVO::AdcLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMap;
use Staging::OM::ScanRecord;
use Staging::OM::Adc;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::Adc;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _testMode           => undef,
                 _loadDeltaOnly      => undef,
                 _applyChanges       => undef,
                 _maxLparsInQuery    => undef,
                 _firstId            => undef,
                 _lastId             => undef,
                 _discrepancyTypeMap => undef
    };
    bless $self, $class;
    dlog("instantiated self");

    ###Get the discrepancy type map
    $self->discrepancyTypeMap( BRAVO::Delegate::BRAVODelegate->getDiscrepancyTypeMap );
    dlog("got discrepancy type map");

    return $self;
}

###Object get/set methods.
sub testMode {
    my ( $self, $value ) = @_;
    $self->{_testMode} = $value if defined($value);
    return ( $self->{_testMode} );
}

sub loadDeltaOnly {
    my ( $self, $value ) = @_;
    $self->{_loadDeltaOnly} = $value if defined($value);
    return ( $self->{_loadDeltaOnly} );
}

sub applyChanges {
    my ( $self, $value ) = @_;
    $self->{_applyChanges} = $value if defined($value);
    return ( $self->{_applyChanges} );
}

sub maxLparsInQuery {
    my ( $self, $value ) = @_;
    $self->{_maxLparsInQuery} = $value if defined($value);
    return ( $self->{_maxLparsInQuery} );
}

sub firstId {
    my ( $self, $value ) = @_;
    $self->{_firstId} = $value if defined($value);
    return ( $self->{_firstId} );
}

sub lastId {
    my ( $self, $value ) = @_;
    $self->{_lastId} = $value if defined($value);
    return ( $self->{_lastId} );
}

sub discrepancyTypeMap {
    my ( $self, $value ) = @_;
    $self->{_discrepancyTypeMap} = $value if defined($value);
    return ( $self->{_discrepancyTypeMap} );
}

###Primary method used by calling clients to load staging
###software lpar adc data to bravo.
sub load {
    my ( $self, %args ) = @_;

    ###Check and set arguments.
    $self->checkArgs( \%args );

    ###Get a connection to staging
    ilog("getting staging db connection");
    my $stagingConnection = Database::Connection->new('staging');
    die "Unable to get staging db connection!\n"
      unless defined $stagingConnection;
    ilog("got staging db connection");

    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    die "Unable to get bravo db connection!\n"
      unless defined $bravoConnection;
    ilog("got bravo db connection");

    ###Get start time for processing
    my $begin = time();

    ###Hash to keep load statistics
    my %statistics = ();

    ###Wrap all of this in an eval so we can close the
    ###connections if something dies.  Use dieMsg to
    ###determine if this method should throw the die.
    my $dieMsg;
    eval {

        my %stagingAdcToDelete = ();
        ###Prepare query to pull adc data from staging
        dlog("preparing adc data query");
        $stagingConnection->prepareSqlQueryAndFields(    
                                       Staging::Delegate::StagingDelegate->queryAdcDataByMinMaxIds( $self->testMode, $self->loadDeltaOnly )
        );
        dlog("prepared adc data query");

        ###Get the statement handle
        dlog("getting sth for adc data query");
        my $sth = $stagingConnection->sql->{adcDataByMinMaxIds};
        dlog("got sth for adc data query");

        ###Bind our columns
        my %rec;
        dlog("binding columns for adc data query");
        $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{adcDataByMinMaxIdsFields} } );
        dlog("binded columns for adc data query");

        ###Excute the query
        ilog("executing adc data query");
        $sth->execute( $self->firstId, $self->lastId );
        ilog("executed adc data query");

        while ( $sth->fetchrow_arrayref ) {
            ###Clean record values
            cleanValues( \%rec );

            ###Upper case record values
            upperValues( \%rec );

            logRec( 'dlog', \%rec );

            ###Get bravo software lpar object by biz key if exists
            my $bravoSoftwareLpar;
            $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar();
            $bravoSoftwareLpar->customerId( $rec{customerId} );
            $bravoSoftwareLpar->name( $rec{name} );
            $bravoSoftwareLpar->getByBizKey($bravoConnection);

            if ( defined $bravoSoftwareLpar->id ) {
                dlog(   "matching bravo software lpar record found: "
                      . "old bravo software lpar obj="
                      . $bravoSoftwareLpar->toString() );
            }
            else {
                dlog(   "no matching bravo software lpar record found: "
                      . "old bravo software lpar obj="
                      . $bravoSoftwareLpar->toString() );
                next;
            }

            ###Check whether this record exists in BRAVO db
            my $bravoAdc = new BRAVO::OM::Adc();
            $bravoAdc->softwareLparId( $bravoSoftwareLpar->id );
            $bravoAdc->epName( $rec{epName} );
            $bravoAdc->getByBizKey($bravoConnection);

            ###Build staging bravo adc record
            my $stagingBravoAdc = $self->buildBravoAdc( \%rec );
            $stagingBravoAdc->softwareLparId( $bravoSoftwareLpar->id );
            my $stagingAdc = $self->buildStagingAdc( \%rec );

            if ( defined $bravoAdc->id ) {
                dlog( "matching bravo adc record found: " . "old bravo adc obj=" . $bravoAdc->toString() );

                ###If staging action is update, compare the two records and then
                ###update is necessary
                if ( $rec{adcAction} eq 'UPDATE' ) {
                    dlog("Update Action");
                    if ( !$stagingBravoAdc->equals($bravoAdc) ) {
                        ### update fields from staging record to bravo record
                        $bravoAdc->epName( $stagingBravoAdc->epName );
                        $bravoAdc->epOid( $stagingBravoAdc->epOid );
                        $bravoAdc->ipAddress( $stagingBravoAdc->ipAddress );
                        $bravoAdc->cust( $stagingBravoAdc->cust );
                        $bravoAdc->loc( $stagingBravoAdc->loc );
                        $bravoAdc->gu( $stagingBravoAdc->gu );
                        $bravoAdc->serverType( $stagingBravoAdc->serverType );
                        $bravoAdc->sesdrLocation( $stagingBravoAdc->sesdrLocation );
                        $bravoAdc->sesdrBpUsing( $stagingBravoAdc->sesdrBpUsing );
                        $bravoAdc->sesdrSystid( $stagingBravoAdc->sesdrSystid );

                        if ( $self->applyChanges == 1 ) {
                            ###save the record
                            $bravoAdc->save($bravoConnection);
                        }
                    }
                }
                elsif ( $rec{adcAction} eq 'DELETE' ) {
                    ###Delete record from BRAVO
                    dlog("Delete Action");
                    if ( $self->applyChanges == 1 ) {
                        ###delete the bravo adc record
                        $bravoAdc->delete($bravoConnection);
                    }
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }
            else {
                dlog( "no matching bravo adc record found: " . "old bravo adc obj=" . $bravoAdc->toString() );
                ### if action is update, we insert
                if ( $rec{adcAction} eq 'UPDATE' ) {
                    if ( $self->applyChanges == 1 ) {
                        ###save the record
                        $stagingBravoAdc->save($bravoConnection);
                    }
                }
                elsif ( $rec{adcAction} eq 'DELETE' ) {
                    ###There is nothing to delete in BRAVO - ignore
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }

            ###Staging adc logic.
            if ( $stagingAdc->action eq 'UPDATE' ) {

                ###Mark as complete.
                $stagingAdc->action('COMPLETE');
                dlog("marked staging adc action as complete");

                ###Save if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    dlog("saving staging adc object");
                    $stagingAdc->save($stagingConnection);
                    dlog("saved staging adc object: $stagingAdc->toString()");
                }

            }
            elsif ( $stagingAdc->action eq 'COMPLETE' ) {
                ###Do not save in this case to avoid a racing
                ###condition with the atp to staging loader.
                dlog("staging adc already complete");
            }
            elsif ( $stagingAdc->action eq 'DELETE' ) {
                ###Mark for delete from staging.
                $stagingAdcToDelete{ $stagingAdc->id }++;
                dlog("marking staging adc object for delete");
            }
            else {
                ###Invalid action.
                die "Invalid action: " . $stagingAdc->toString() . "\n";
            }

        }

        $sth->finish;

        ###Delete any staging adces which have been flagged
        ###and processed above.
        dlog("performing any pending staging adc deletes");
        foreach my $id ( sort keys %stagingAdcToDelete ) {
            my $stagingAdc = new Staging::OM::Adc();
            $stagingAdc->id($id);
            $stagingAdc->delete($stagingConnection);
            dlog( "deleted staging adc: " . $stagingAdc->toString() );
        }

    };
    if ($@) {
        ###Something died in the eval, set dieMsg so
        ###we know to die after closing the db connections.
        elog($@);
        $dieMsg = $@;
    }

    ###Display statistics
    foreach my $key ( sort keys %statistics ) {
        logMsg( "statistics: $key=" . $statistics{$key} );
    }

    ###Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    ilog("totalProcessingTime: $totalProcessingTime secs");

    ###Close the staging db connection
    ilog("disconnecting staging db connection");
    $stagingConnection->disconnect;
    ilog("disconnected staging db connection");

    ###Close the bravo connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    ###die if dieMsg is defined
    die $dieMsg if defined($dieMsg);
}

###Checks arguments passed to load method.
sub checkArgs {
    my ( $self, $args ) = @_;

    ###Check TestMode arg is passed correctly
    die "Must specify TestMode sub argument!\n"
      unless exists( $args->{'TestMode'} );
    die "Invalid value passed for TestMode param!\n"
      unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 );
    $self->testMode( $args->{'TestMode'} );
    ilog( "testMode=" . $self->testMode );

    ###Check LoadDeltaOnly arg is passed correctly
    die "Must specify LoadDeltaOnly sub argument!\n"
      unless exists( $args->{'LoadDeltaOnly'} );
    die "Invalid value passed for LoadDeltaOnly param!\n"
      unless ( $args->{'LoadDeltaOnly'} == 0 || $args->{'LoadDeltaOnly'} == 1 );
    $self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
    ilog( "loadDeltaOnly=" . $self->loadDeltaOnly );

    ###Check ApplyChanges arg is passed correctly
    die "Must specify ApplyChanges sub argument!\n"
      unless exists( $args->{'ApplyChanges'} );
    die "Invalid value passed for ApplyChanges param!\n"
      unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 );
    $self->applyChanges( $args->{'ApplyChanges'} );
    ilog( "applyChanges=" . $self->applyChanges );

    ###Check MaxLparsInQuery arg is passed correctly
    die "Must specify MaxLparsInQuery sub argument!\n"
      unless exists( $args->{'MaxLparsInQuery'} );
    die "Invalid value passed for MaxLparsInQuery param!\n"
      unless $args->{'MaxLparsInQuery'} =~ m/\d+/;
    $self->maxLparsInQuery( $args->{'MaxLparsInQuery'} );
    ilog( "maxLparsInQuery=" . $self->maxLparsInQuery );

    ###Check FirstId arg is passed correctly
    die "Must specify FirstId sub argument!\n"
      unless exists( $args->{'FirstId'} );
    die "Invalid value passed for FirstId param!\n"
      unless $args->{'FirstId'} =~ m/\d+/;
    $self->firstId( $args->{'FirstId'} );
    ilog( "firstId=" . $self->firstId );

    ###Check LastId arg is passed correctly
    die "Must specify LastId sub argument!\n"
      unless exists( $args->{'LastId'} );
    die "Invalid value passed for LastId param!\n"
      unless $args->{'LastId'} =~ m/\d+/;
    $self->lastId( $args->{'LastId'} );
    ilog( "lastId=" . $self->lastId );
}

sub buildBravoAdc {
    my ( $self, $rec ) = @_;

    my $adc = new BRAVO::OM::Adc();
    $adc->epName( $rec->{epName} );
    $adc->epOid( $rec->{epOid} );
    $adc->ipAddress( $rec->{ipAddress} );
    $adc->cust( $rec->{cust} );
    $adc->loc( $rec->{loc} );
    $adc->gu( $rec->{gu} );
    $adc->serverType( $rec->{serverType} );
    $adc->sesdrLocation( $rec->{sesdrLocation} );
    $adc->sesdrBpUsing( $rec->{sesdrBpUsing} );
    $adc->sesdrSystid( $rec->{sesdrSystid} );

    return $adc;
}

sub buildStagingAdc {
    my ( $self, $rec ) = @_;

    my $adc = new Staging::OM::Adc();
    $adc->id( $rec->{adcId} );
    $adc->scanRecordId( $rec->{scanRecordId} );
    $adc->epName( $rec->{epName} );
    $adc->epOid( $rec->{epOid} );
    $adc->ipAddress( $rec->{ipAddress} );
    $adc->cust( $rec->{cust} );
    $adc->loc( $rec->{loc} );
    $adc->gu( $rec->{gu} );
    $adc->serverType( $rec->{serverType} );
    $adc->sesdrLocation( $rec->{sesdrLocation} );
    $adc->sesdrBpUsing( $rec->{sesdrBpUsing} );
    $adc->sesdrSystid( $rec->{sesdrSystid} );
    $adc->action( $rec->{adcAction} );

    return $adc;
}

1;
