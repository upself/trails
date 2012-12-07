package BRAVO::HdiskLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMap;
use Staging::OM::ScanRecord;
use Staging::OM::Hdisk;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::Hdisk;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _testMode           => undef,
                 _loadDeltaOnly      => undef,
                 _applyChanges       => undef,
                 _maxLparsInQuery    => undef,
                 _firstId            => undef,
                 _lastId             => undef
    };
    bless $self, $class;
    dlog("instantiated self");

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

###Primary method used by calling clients to load staging
###software lpar hdisk data to bravo.
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

        my %stagingHdiskesToDelete = ();
        ###Prepare query to pull hdisk data from staging
        dlog("preparing hdisk data query");
        $stagingConnection->prepareSqlQueryAndFields(    
                                     Staging::Delegate::StagingDelegate->queryHdiskDataByMinMaxIds( $self->testMode, $self->loadDeltaOnly )
        );
        dlog("prepared hdisk data query");

        ###Get the statement handle
        dlog("getting sth for hdisk data query");
        my $sth = $stagingConnection->sql->{hdiskDataByMinMaxIds};
        dlog("got sth for hdisk data query");

        ###Bind our columns
        my %rec;
        dlog("binding columns for hdisk data query");
        $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{hdiskDataByMinMaxIdsFields} } );
        dlog("binded columns for hdisk data query");

        ###Excute the query
        ilog("executing hdisk data query");
        $sth->execute( $self->firstId, $self->lastId );
        ilog("executed hdisk data query");

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
            my $bravoHdisk = new BRAVO::OM::Hdisk();
            $bravoHdisk->softwareLparId( $bravoSoftwareLpar->id );
            $bravoHdisk->serialNumber( $rec{serialNumber} );
            $bravoHdisk->hdiskSizeMb( $rec{size} );
            $bravoHdisk->model( $rec{model} );
            $bravoHdisk->getByBizKey($bravoConnection);

            ###Build staging bravo hdisk record
            my $stagingBravoHdisk = $self->buildBravoHdisk( \%rec );
            $stagingBravoHdisk->softwareLparId( $bravoSoftwareLpar->id );

            my $stagingHdisk = $self->buildStagingHdisk( \%rec );

            if ( defined $bravoHdisk->id ) {
                dlog( "matching bravo hdisk record found: " . "old bravo hdisk obj=" . $bravoHdisk->toString() );

                ###If staging action is update, compare the two records and then
                ###update is necessary
                if ( $rec{action} eq 'UPDATE' ) {
                    dlog("Update Action");
                    if ( !$stagingBravoHdisk->equals($bravoHdisk) ) {

                        ### update fields from staging record to bravo record
                        $bravoHdisk->hdiskSizeMb( $stagingBravoHdisk->hdiskSizeMb );
                        $bravoHdisk->manufacturer( $stagingBravoHdisk->manufacturer );
                        $bravoHdisk->serialNumber( $stagingBravoHdisk->serialNumber );
                        $bravoHdisk->storageType( $stagingBravoHdisk->storageType );
                        $bravoHdisk->model( $stagingBravoHdisk->model );

                        if ( $self->applyChanges == 1 ) {
                            ###save the record
                            $bravoHdisk->save($bravoConnection);
                        }
                    }
                }
                elsif ( $rec{action} eq 'DELETE' ) {
                    ###Delete record from BRAVO
                    dlog("Delete Action");
                    if ( $self->applyChanges == 1 ) {
                        ###delete the bravo hdisk record
                        $bravoHdisk->delete($bravoConnection);
                    }
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }
            else {
                dlog( "no matching bravo hdisk record found: " . "old bravo hdisk obj=" . $bravoHdisk->toString() );
                ### if action is update, we insert
                if ( $rec{action} eq 'UPDATE' ) {
                    if ( $self->applyChanges == 1 ) {
                        ###save the record
                        $stagingBravoHdisk->save($bravoConnection);
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

            ###Staging hdisk logic.
            if ( $stagingHdisk->action eq 'UPDATE' ) {

                ###Mark as complete.
                $stagingHdisk->action('COMPLETE');
                dlog("marked staging hdisk action as complete");

                ###Save if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    dlog("saving staging hdisk object");
                    $stagingHdisk->save($stagingConnection);
                    dlog("saved staging hdisk object: $stagingHdisk->toString()");
                }

            }
            elsif ( $stagingHdisk->action eq 'COMPLETE' ) {
                ###Do not save in this case to avoid a racing
                ###condition with the atp to staging loader.
                dlog("staging hdisk already complete");
            }
            elsif ( $stagingHdisk->action eq 'DELETE' ) {
                ###Mark for delete from staging.
                $stagingHdiskesToDelete{ $stagingHdisk->id }++;
                dlog("marking staging hdisk object for delete");
            }
            else {
                ###Invalid action.
                die "Invalid action: " . $stagingHdisk->toString() . "\n";
            }

        }

        $sth->finish;

        ###Delete any staging hdisks which have been flagged
        ###and processed above.
        dlog("performing any pending staging hdisk deletes");
        foreach my $id ( sort keys %stagingHdiskesToDelete ) {
            my $stagingHdisk = new Staging::OM::Hdisk();
            $stagingHdisk->id($id);
            $stagingHdisk->delete($stagingConnection);
            dlog( "deleted staging hdisk: " . $stagingHdisk->toString() );
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

sub buildBravoHdisk {
    my ( $self, $rec ) = @_;

    my $hdisk = new BRAVO::OM::Hdisk();
    $hdisk->model( $rec->{model} );
    $hdisk->hdiskSizeMb( $rec->{size} );
    $hdisk->serialNumber( $rec->{serialNumber} );
    $hdisk->storageType( $rec->{storageType} );
    $hdisk->manufacturer( $rec->{manfacturer} );

    return $hdisk;
}

sub buildStagingHdisk {
    my ( $self, $rec ) = @_;

    my $hdisk = new Staging::OM::Hdisk();
    $hdisk->id( $rec->{hdiskId} );
    $hdisk->scanRecordId( $rec->{scanRecordId} );
    $hdisk->model( $rec->{model} );
    $hdisk->size( $rec->{size} );
    $hdisk->serialNumber( $rec->{serialNumber} );
    $hdisk->storageType( $rec->{storageType} );
    $hdisk->manufacturer( $rec->{manfacturer} );
    $hdisk->action( $rec->{action} );

    return $hdisk;
}

1;
