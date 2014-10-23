package BRAVO::ProcessorLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMap;
use Staging::OM::ScanRecord;
use Staging::OM::Processor;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::Processor;

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
###software lpar data to bravo.
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

        my %stagingProcessoresToDelete = ();
        ###Prepare query to pull processor data from staging
        dlog("preparing processor data query");
        $stagingConnection->prepareSqlQueryAndFields(    
                                 Staging::Delegate::StagingDelegate->queryProcessorDataByMinMaxIds( $self->testMode, $self->loadDeltaOnly )
        );
        dlog("prepared processor data query");

        ###Get the statement handle
        dlog("getting sth for processor data query");
        my $sth = $stagingConnection->sql->{processorDataByMinMaxIds};
        dlog("got sth for processor data query");

        ###Bind our columns
        my %rec;
        dlog("binding columns for processor data query");
        $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{processorDataByMinMaxIdsFields} } );
        dlog("binded columns for processor data query");

        ###Excute the query
        ilog("executing processor data query");
        $sth->execute( $self->firstId, $self->lastId );
        ilog("executed processor data query");

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
            my $bravoProcessor = new BRAVO::OM::Processor();
            $bravoProcessor->softwareLparId( $bravoSoftwareLpar->id );
            $bravoProcessor->processorNum( $rec{processorNum} );
            $bravoProcessor->getByBizKey($bravoConnection);

            ###Build staging bravo processor record
            my $stagingBravoProcessor = $self->buildBravoProcessor( \%rec );
            $stagingBravoProcessor->softwareLparId( $bravoSoftwareLpar->id );
            my $stagingProcessor = $self->buildStagingProcessor( \%rec );

            if ( defined $bravoProcessor->id ) {
                dlog(   "matching bravo processor record found: "
                      . "old bravo processor obj="
                      . $bravoProcessor->toString() );

                ###If staging action is update, compare the two records and then
                ###update is necessary
                if ( $rec{processorAction} eq 'UPDATE' ) {
                    dlog("Update Action");
                    if ( !$stagingBravoProcessor->equals($bravoProcessor) ) {

                        ### update fields from staging record to bravo record
                        $bravoProcessor->processorNum( $stagingBravoProcessor->processorNum );
                        $bravoProcessor->manufacturer( $stagingBravoProcessor->manufacturer );
                        $bravoProcessor->model( $stagingBravoProcessor->model );
                        $bravoProcessor->maxSpeed( $stagingBravoProcessor->maxSpeed );
                        $bravoProcessor->busSpeed( $stagingBravoProcessor->busSpeed );
                        $bravoProcessor->isActive( $stagingBravoProcessor->isActive );
                        $bravoProcessor->serialNumber( $stagingBravoProcessor->serialNumber );
                        $bravoProcessor->numBoards( $stagingBravoProcessor->numBoards );
                        $bravoProcessor->numModules( $stagingBravoProcessor->numModules );
                        $bravoProcessor->pvu( $stagingBravoProcessor->pvu );
                        $bravoProcessor->cache( $stagingBravoProcessor->cache );
                        $bravoProcessor->currentSpeed( $stagingBravoProcessor->currentSpeed );

                        if ( $self->applyChanges == 1 ) {
                            ###save the record
                            $bravoProcessor->save($bravoConnection);
                        }
                    }
                }
                elsif ( $rec{processorAction} eq 'DELETE' ) {
                    ###Delete record from BRAVO
                    dlog("Delete Action");
                    if ( $self->applyChanges == 1 ) {
                        ###delete the bravo processor record
                        $bravoProcessor->delete($bravoConnection);
                    }
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }
            else {
                dlog(   "no matching bravo processor record found: "
                      . "old bravo processor obj="
                      . $bravoProcessor->toString() );
                ### if action is update, we insert
                if ( $rec{processorAction} eq 'UPDATE' ) {
                    if ( $self->applyChanges == 1 ) {
                        ###save the record
                        $stagingBravoProcessor->save($bravoConnection);
                    }
                }
                elsif ( $rec{processorAction} eq 'DELETE' ) {
                    ###There is nothing to delete in BRAVO - ignore
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }

            ###Staging processor logic.
            if ( $stagingProcessor->action eq 'UPDATE' ) {

                ###Mark as complete.
                $stagingProcessor->action('COMPLETE');
                dlog("marked staging processor action as complete");

                ###Save if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    dlog("saving staging processor object");
                    $stagingProcessor->save($stagingConnection);
                    dlog("saved staging processor object: $stagingProcessor->toString()");
                }

            }
            elsif ( $stagingProcessor->action eq 'COMPLETE' ) {
                ###Do not save in this case to avoid a racing
                ###condition with the atp to staging loader.
                dlog("staging processor already complete");
            }
            elsif ( $stagingProcessor->action eq 'DELETE' ) {
                ###Mark for delete from staging.
                $stagingProcessoresToDelete{ $stagingProcessor->id }++;
                dlog("marking staging processor object for delete");
            }
            else {
                ###Invalid action.
                die "Invalid action: " . $stagingProcessor->toString() . "\n";
            }

        }

        $sth->finish;

        ###Delete any staging processors which have been flagged
        ###and processed above.
        dlog("performing any pending staging processor deletes");
        foreach my $id ( sort keys %stagingProcessoresToDelete ) {
            my $stagingProcessor = new Staging::OM::Processor();
            $stagingProcessor->id($id);
            $stagingProcessor->delete($stagingConnection);
            dlog( "deleted staging processor: " . $stagingProcessor->toString() );
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

sub buildBravoProcessor {
    my ( $self, $rec ) = @_;

    my $processor = new BRAVO::OM::Processor();
    $processor->processorNum( $rec->{processorNum} );
    $processor->manufacturer( $rec->{manufacturer} );
    $processor->model( $rec->{model} );
    $processor->maxSpeed( $rec->{maxSpeed} );
    $processor->busSpeed( $rec->{busSpeed} );
    $processor->isActive( $rec->{isActive} );
    $processor->serialNumber( $rec->{serialNumber} );
    $processor->numBoards( $rec->{numBoards} );
    $processor->numModules( $rec->{numModules} );
    $processor->pvu( $rec->{pvu} );
    $processor->cache( $rec->{cache} );
    $processor->currentSpeed( $rec->{currentSpeed} );

    return $processor;
}

sub buildStagingProcessor {
    my ( $self, $rec ) = @_;

    my $processor = new Staging::OM::Processor();
    $processor->id( $rec->{processorId} );
    $processor->scanRecordId( $rec->{scanRecordId} );
    $processor->processorNum( $rec->{processorNum} );
    $processor->manufacturer( $rec->{manufacturer} );
    $processor->model( $rec->{model} );
    $processor->maxSpeed( $rec->{maxSpeed} );
    $processor->busSpeed( $rec->{busSpeed} );
    $processor->isActive( $rec->{isActive} );
    $processor->serialNumber( $rec->{serialNumber} );
    $processor->numBoards( $rec->{numBoards} );
    $processor->numModules( $rec->{numModules} );
    $processor->pvu( $rec->{pvu} );
    $processor->cache( $rec->{cache} );
    $processor->currentSpeed( $rec->{currentSpeed} );
    $processor->action( $rec->{processorAction} );

    return $processor;
}

1;
