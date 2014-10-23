package BRAVO::MemModLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMap;
use Staging::OM::ScanRecord;
use Staging::OM::MemMod;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::MemMod;

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
###software lpar memMod data to bravo.
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

        my %stagingMemModsToDelete = ();
        ###Prepare query to pull memMod data from staging
        dlog("preparing memMod data query");
        $stagingConnection->prepareSqlQueryAndFields(    
                                    Staging::Delegate::StagingDelegate->queryMemModDataByMinMaxIds( $self->testMode, $self->loadDeltaOnly )
        );
        dlog("prepared memmod data query");

        ###Get the statement handle
        dlog("getting sth for memMod data query");
        my $sth = $stagingConnection->sql->{memModDataByMinMaxIds};
        dlog("got sth for memMod data query");

        ###Bind our columns
        my %rec;
        dlog("binding columns for memMod data query");
        $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{memModDataByMinMaxIdsFields} } );
        dlog("binded columns for memMod data query");

        ###Excute the query
        ilog("executing memMod data query");
        $sth->execute( $self->firstId, $self->lastId );
        ilog("executed memMod data query");

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
            my $bravoMemMod = new BRAVO::OM::MemMod();
            $bravoMemMod->softwareLparId( $bravoSoftwareLpar->id );
            $bravoMemMod->instMemId( $rec{instMemId} );
            $bravoMemMod->getByBizKey($bravoConnection);

            ###Build staging bravo memMod record
            my $stagingBravoMemMod = $self->buildBravoMemMod( \%rec );
            $stagingBravoMemMod->softwareLparId( $bravoSoftwareLpar->id );
            my $stagingMemMod = $self->buildStagingMemMod( \%rec );

            if ( defined $bravoMemMod->id ) {
                dlog( "matching bravo memMod record found: " . "old bravo memMod obj=" . $bravoMemMod->toString() );

                ###If staging action is update, compare the two records and then
                ###update is necessary
                if ( $rec{action} eq 'UPDATE' ) {
                    dlog("Update Action");
                    if ( !$stagingBravoMemMod->equals($bravoMemMod) ) {

                        ### update fields from staging record to bravo record
                        $bravoMemMod->instMemId( $stagingBravoMemMod->instMemId );
                        $bravoMemMod->moduleSizeMb( $stagingBravoMemMod->moduleSizeMb );
                        $bravoMemMod->maxModuleSizeMb( $stagingBravoMemMod->maxModuleSizeMb );
                        $bravoMemMod->socketName( $stagingBravoMemMod->socketName );
                        $bravoMemMod->packaging( $stagingBravoMemMod->packaging );
                        $bravoMemMod->memType( $stagingBravoMemMod->memType );

                        if ( $self->applyChanges == 1 ) {
                            ###save the record
                            $bravoMemMod->save($bravoConnection);
                        }
                    }
                }
                elsif ( $rec{action} eq 'DELETE' ) {
                    ###Delete record from BRAVO
                    dlog("Delete Action");
                    if ( $self->applyChanges == 1 ) {
                        ###delete the bravo memMod record
                        $bravoMemMod->delete($bravoConnection);
                    }
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }
            else {
                dlog( "no matching bravo memMod record found: " . "old bravo memMod obj=" . $bravoMemMod->toString() );
                ### if action is update, we insert
                if ( $rec{action} eq 'UPDATE' ) {
                    if ( $self->applyChanges == 1 ) {
                        ###save the record
                        $stagingBravoMemMod->save($bravoConnection);
                    }
                }
                elsif ( $rec{action} eq 'DELETE' ) {
                    ###There is nothing to delete in BRAVO - ignore
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }

            ###Staging memMod logic.
            if ( $stagingMemMod->action eq 'UPDATE' ) {

                ###Mark as complete.
                $stagingMemMod->action('COMPLETE');
                dlog("marked staging memMod action as complete");

                ###Save if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    dlog("saving staging memMod object");
                    $stagingMemMod->save($stagingConnection);
                    dlog("saved staging memMod object: $stagingMemMod->toString()");
                }

            }
            elsif ( $stagingMemMod->action eq 'COMPLETE' ) {
                ###Do not save in this case to avoid a racing
                ###condition with the atp to staging loader.
                dlog("staging memMod already complete");
            }
            elsif ( $stagingMemMod->action eq 'DELETE' ) {
                ###Mark for delete from staging.
                $stagingMemModsToDelete{ $stagingMemMod->id }++;
                dlog("marking staging memMod object for delete");
            }
            else {
                ###Invalid action.
                die "Invalid action: " . $stagingMemMod->toString() . "\n";
            }

        }

        $sth->finish;

        ###Delete any staging memMods which have been flagged
        ###and processed above.
        dlog("performing any pending staging memMod deletes");
        foreach my $id ( sort keys %stagingMemModsToDelete ) {
            my $stagingMemMod = new Staging::OM::MemMod();
            $stagingMemMod->id($id);
            $stagingMemMod->delete($stagingConnection);
            dlog( "deleted staging memMod: " . $stagingMemMod->toString() );
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

sub buildBravoMemMod {
    my ( $self, $rec ) = @_;

    my $memMod = new BRAVO::OM::MemMod();
    $memMod->instMemId( $rec->{instMemId} );
    $memMod->moduleSizeMb( $rec->{moduleSizeMb} );
    $memMod->maxModuleSizeMb( $rec->{maxModuleSizeMb} );
    $memMod->socketName( $rec->{socketName} );
    $memMod->packaging( $rec->{packaging} );
    $memMod->memType( $rec->{memType} );

    return $memMod;
}

sub buildStagingMemMod {
    my ( $self, $rec ) = @_;

    my $memMod = new Staging::OM::MemMod();
    $memMod->id( $rec->{memModId} );
    $memMod->scanRecordId( $rec->{scanRecordId} );
    $memMod->instMemId( $rec->{instMemId} );
    $memMod->moduleSizeMb( $rec->{moduleSizeMb} );
    $memMod->maxModuleSizeMb( $rec->{maxModuleSizeMb} );
    $memMod->socketName( $rec->{socketName} );
    $memMod->packaging( $rec->{packaging} );
    $memMod->memType( $rec->{memType} );
    $memMod->action( $rec->{action} );

    return $memMod;
}

1;
