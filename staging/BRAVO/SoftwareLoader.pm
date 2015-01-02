package BRAVO::SoftwareLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMapNonObject;
use Staging::OM::ScanRecord;
use Staging::OM::SoftwareManual;
use Staging::OM::SoftwareSignature;
use Staging::OM::SoftwareFilter;
use Staging::OM::SoftwareTlcmz;
##use Staging::OM::SoftwareDorana;
use Staging::OM::ScanSoftwareItem;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::InstalledSignature;
use BRAVO::OM::InstalledFilter;
use BRAVO::OM::InstalledTLCMZ;
##use BRAVO::OM::InstalledDorana;
use BRAVO::OM::InstalledTADZ;
use BRAVO::OM::SoftwareDiscrepancyHistory;
use SWASSET::Delegate::SWASSETDelegate;
use SWASSET::OM::InstalledManualSoftware;
use Recon::Queue;

###Object constructor.
sub new {
    my ($class,$stagingConnection, $trailsConnection, $swassetConnection) = @_;
    my $self = {
                 _loadDeltaOnly      => undef,
                 _applyChanges       => undef,
                 _customerId         => undef,
                 _phase              => undef,
                 _discrepancyTypeMap => undef,
                 _lparId => undef,
                 _stagingConnection => $stagingConnection,
                 _bravoConnection => $trailsConnection,
                 _swassetConnection => $swassetConnection
    };
    bless $self, $class;
    dlog("instantiated self");

    ###Get the discrepancy type map
    $self->discrepancyTypeMap( BRAVO::Delegate::BRAVODelegate->getDiscrepancyTypeMap );
    dlog("got discrepancy type map");

    return $self;
}

###Object get/set methods.
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

sub customerId {
    my ( $self, $value ) = @_;
    $self->{_customerId} = $value if defined($value);
    return ( $self->{_customerId} );
}

sub discrepancyTypeMap {
    my ( $self, $value ) = @_;
    $self->{_discrepancyTypeMap} = $value if defined($value);
    return ( $self->{_discrepancyTypeMap} );
}

sub phase {
    my ( $self, $value ) = @_;
    $self->{_phase} = $value if defined($value);
    return ( $self->{_phase} );
}

sub lparId {
    my ( $self, $value ) = @_;
    $self->{_lparId} = $value if defined($value);
    return ( $self->{_lparId} );
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

sub swassetConnection {
    my ( $self, $value ) = @_;
    $self->{_swassetConnection} = $value if defined($value);
    return ( $self->{_swassetConnection} );
}

###Primary method used by calling clients to load staging
###software lpar data to bravo.
sub load {
    my ( $self, %args ) = @_;

    ###Check and set arguments.
    $self->checkArgs( \%args );

    ###Get start time for processing
    my $begin = time();

    ###Hash to keep load statistics
    my %statistics = ();

    ###Wrap all of this in an eval so we can close the
    ###connections if something dies.  Use dieMsg to
    ###determine if this method should throw the die.
    my $dieMsg;
    eval {
        ###Prepare query to pull software lpar data from staging
        dlog("preparing software lpar data query");
        $self->stagingConnection->prepareSqlQueryAndFields(
                                                $self->querySoftwareLparDataByCustomerId( $self->loadDeltaOnly ) );
        dlog("prepared software lpar data query");

        ###Get the statement handle
        dlog("getting sth for software lpar data query");
        my $sth = $self->stagingConnection->sql->{softwareLparDataByCustomerId};
        dlog("got sth for software lpar data query");

        ###Bind our columns
        my %rec;
        dlog("binding columns for software lpar data query");
        $sth->bind_columns( map { \$rec{$_} } @{ $self->stagingConnection->sql->{softwareLparDataByCustomerIdFields} } );
        dlog("binded columns for software lpar data query");

        ###Excute the query
        ilog("executing software lpar data query");
        $sth->execute( $self->customerId,$self->lparId,$self->customerId,$self->lparId,$self->customerId,$self->lparId,$self->customerId,$self->lparId,$self->customerId,$self->lparId);
        ilog("executed software lpar data query");

        ###Helper variables to store the currently processing software lpar object.
        my $prevMapKey = "";
        my $prevStagingSoftwareLpar;
        my $prevBravoSoftwareLpar;
        my $prevDeleteInstalledType;

        ###Hash to store bravo installed software keys that need to be
        ###evaluated for inactivation after all processing is complete.
        my %bravoInstSwFlaggedForInactivation = ();

        ###Hashes to store staging records that we need to delete after all
        ###processing is complete.
        my %stagingSoftwareLparsToDelete = ();
        my %stagingMapsToDelete          = ();
        my %stagingScanRecordsToDelete   = ();
        while ( $sth->fetchrow_arrayref ) {

            ###Clean record values
            cleanValues( \%rec );

            ###Upper case record values
            upperValues( \%rec );

            logRec( 'dlog', \%rec );

            ###
            ### Error checking.
            ###

            ###Perform basic error checking.
            my $error = 0;

            if ( $rec{action} eq 'DELETE' ) {
                if ( defined $rec{mapAction} && $rec{mapAction} ne 'DELETE' ) {

                    ilog("SL=D,SLM!=D");
                    $error = 1;

                    ###Remove this software lpar from to delete hash if exists.
                    delete $stagingSoftwareLparsToDelete{ $rec{id} }
                        if exists $stagingSoftwareLparsToDelete{ $rec{id} };
                }
            }

            ###If we found an error, we do not want to process
            ###this row of data, so go to the next row.
            next if $error == 1;

            ###
            ###Handle software lpar.
            ###

            ###Variable to set if the logic determines we should save
            ###this software lpar object to the bravo database.
            my $saveSoftwareLpar = 0;

            ###Get the software lpar key
            my $softwareLparKey = $rec{customerId} . '|' . $rec{name};
            dlog("software lpar key=$softwareLparKey");

            ###Get the map key
            my $mapKey =
                  $softwareLparKey . '|'
                . ( defined $rec{mapId}        ? $rec{mapId}        : '' ) . '|'
                . ( defined $rec{scanRecordId} ? $rec{scanRecordId} : '' );

            ###Determine if we have processed this software lpar key yet.
            my $stagingSoftwareLpar;
            my $bravoSoftwareLpar;
            my $deleteInstalledType;
            if ( $prevMapKey ne $mapKey ) {

                ###This is the first row of data for this software lpar key.
                dlog("first row of data for this software lpar key");

                ###Create and populate a new staging software lpar object
                $stagingSoftwareLpar = new Staging::OM::SoftwareLpar();
                $stagingSoftwareLpar->id( $rec{id} );
                $stagingSoftwareLpar->customerId( $rec{customerId} );
                $stagingSoftwareLpar->computerId( $rec{computerId} );
                $stagingSoftwareLpar->objectId( $rec{objectId} );
                $stagingSoftwareLpar->name( $rec{name} );
                $stagingSoftwareLpar->model( $rec{model} );
                $stagingSoftwareLpar->biosSerial( $rec{biosSerial} );
                $stagingSoftwareLpar->osName( $rec{osName} );
                $stagingSoftwareLpar->osType( $rec{osType} );
                $stagingSoftwareLpar->osMajor( $rec{osMajor} );
                $stagingSoftwareLpar->osMinor( $rec{osMinor} );
                $stagingSoftwareLpar->osSub( $rec{osSub} );
                $stagingSoftwareLpar->osType( $rec{osType} );
                $stagingSoftwareLpar->userName( $rec{userName} );
                $stagingSoftwareLpar->biosManufacturer( $rec{manufacturer} );
                $stagingSoftwareLpar->biosModel( $rec{biosModel} );
                $stagingSoftwareLpar->serverType( $rec{serverType} );
                $stagingSoftwareLpar->techImgId( $rec{techImageId} );
                $stagingSoftwareLpar->extId( $rec{extId} );
                $stagingSoftwareLpar->memory( $rec{memory} );
                $stagingSoftwareLpar->disk( $rec{disk} );
                $stagingSoftwareLpar->dedicatedProcessors( $rec{dedicatedProcessors} );
                $stagingSoftwareLpar->totalProcessors( $rec{totalProcessors} );
                $stagingSoftwareLpar->sharedProcessors( $rec{sharedProcessors} );
                $stagingSoftwareLpar->processorType( $rec{processorType} );
                $stagingSoftwareLpar->sharedProcByCores( $rec{sharedProcByCores} );
                $stagingSoftwareLpar->dedicatedProcByCores( $rec{dedicatedProcByCores} );
                $stagingSoftwareLpar->totalProcByCores( $rec{totalProcByCores} );
                $stagingSoftwareLpar->alias( $rec{alias} );
                $stagingSoftwareLpar->physicalTotalKb( $rec{physicalTotalKb} );
                $stagingSoftwareLpar->virtualMemory( $rec{virtualMemory} );
                $stagingSoftwareLpar->physicalFreeMemory( $rec{physicalFreeMemory} );
                $stagingSoftwareLpar->virtualFreeMemory( $rec{virtualFreeMemory} );
                $stagingSoftwareLpar->nodeCapacity( $rec{nodeCapacity} );
                $stagingSoftwareLpar->lparCapacity( $rec{lparCapacity} );
                $stagingSoftwareLpar->biosDate( $rec{biosDate} );
                $stagingSoftwareLpar->biosSerialNumber( $rec{biosSerialNumber} );
                $stagingSoftwareLpar->biosUniqueId( $rec{biosUniqueId} );
                $stagingSoftwareLpar->boardSerial( $rec{boardSerial} );
                $stagingSoftwareLpar->caseSerial( $rec{caseSerial} );
                $stagingSoftwareLpar->caseAssetTag( $rec{caseAssetTag} );
                $stagingSoftwareLpar->powerOnPassword( $rec{powerOnPassword} );
                $stagingSoftwareLpar->processorCount( $rec{processorCount} );
                $stagingSoftwareLpar->scanTime( $rec{scanTime} );
                $stagingSoftwareLpar->status( $rec{status} );
                $stagingSoftwareLpar->action( $rec{action} );
                dlog( "staging software lpar obj=" . $stagingSoftwareLpar->toString() );

                ###Get bravo software lpar object by biz key if exists
                $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar();
                $bravoSoftwareLpar->customerId( $rec{customerId} );
                $bravoSoftwareLpar->name( $rec{name} );
                $bravoSoftwareLpar->getByBizKey($self->bravoConnection);

                ###Set the action property to the staging action.
                $bravoSoftwareLpar->action( $stagingSoftwareLpar->action );

                if ( defined $bravoSoftwareLpar->id ) {
                    dlog(   "matching bravo software lpar record found: "
                          . "old bravo software lpar obj="
                          . $bravoSoftwareLpar->toString() );
                }
                else {
                    dlog(   "no matching bravo software lpar record found: "
                          . "old bravo software lpar obj="
                          . $bravoSoftwareLpar->toString() );
                }

                ###Bravo software lpar object logic.

                ###Variable to set if the logic determines we should delete
                ###this software line item from bravo b/c of an map or
                ###scan record delete.
                $deleteInstalledType = 0;

                ###SSL=U|C
                if (    $stagingSoftwareLpar->action eq 'UPDATE'
                     || $stagingSoftwareLpar->action eq 'COMPLETE' )
                {
                    ###SSLM
                    if ( defined $rec{mapId} ) {
                        ###SSLM=C
                        if ( $rec{mapAction} eq 'COMPLETE' ) {
                            ###SR
                            if ( defined $rec{scanRecordId} ) {
                                ###SR=U|C
                                if (    $rec{scanRecordAction} eq 'UPDATE'
                                     || $rec{scanRecordAction} eq 'COMPLETE' )
                                {
                                    $saveSoftwareLpar = 1;
                                }
                                ###SR=D
                                elsif ( $rec{scanRecordAction} eq 'DELETE' ) {

                                    ###Always want to delete BIT in this case.
                                    $deleteInstalledType = 1;
                                    $saveSoftwareLpar    = 1;
                                }
                                else {
                                    die "Invalid action: " . $rec{scanRecordAction} . "\n";
                                }
                            }
                            ###!SR
                            else {
                                elog("SSL=U,SSLM,SSLM=C,!SR");
                                die("SSL=U,SSLM,SSLM=C,!SR");
                            }
                        }
                        ###SSLM=D
                        elsif ( $rec{mapAction} eq 'DELETE' ) {

                            ###Always want to delete BIT in this case.
                            $deleteInstalledType = 1;
                            $saveSoftwareLpar    = 1;
                        }
                        else {
                            die "Invalid action: " . $rec{mapAction} . "\n";
                        }
                    }
                    ###!SSLM
                    else {
                        ###BSL
                        $saveSoftwareLpar = 1;
                    }
                }
                ###SSL=D
                elsif ( $stagingSoftwareLpar->action eq 'DELETE' ) {
                    ###SSLM
                    if ( defined $rec{mapId} ) {
                        ###SSLM=C
                        if ( $rec{mapAction} eq 'COMPLETE' ) {
                            dlog("SSL=D,SSLM,SSLM=C");
                            $saveSoftwareLpar = 0;
                        }
                        ###SSLM=D
                        elsif ( $rec{mapAction} eq 'DELETE' ) {
                            ###BSL
                            if ( defined $bravoSoftwareLpar->id ) {
                                if ( $bravoSoftwareLpar->status eq 'ACTIVE' ) {
                                    dlog("SSL=D,BSL,BSL=A");
                                    $saveSoftwareLpar = 1;
                                }
                                elsif ( $bravoSoftwareLpar->status eq 'INACTIVE' ) {
                                    ilog("SSL=D,BSL,BSL=I");
                                    $saveSoftwareLpar = 0;
                                }
                                else {
                                    die "Invalid status: " . $bravoSoftwareLpar->toString() . "\n";
                                }
                            }
                            ###!BSL
                            else {
                                ilog("SSL=D,!BSL");
                                $saveSoftwareLpar = 0;
                            }
                        }
                        else {
                            die "Invalid action: " . $rec{mapAction} . "\n";
                        }
                    }
                    ###!SSLM
                    else {
                        ###BSL
                        if ( defined $bravoSoftwareLpar->id ) {
                            if ( $bravoSoftwareLpar->status eq 'ACTIVE' ) {
                                dlog("SSL=D,BSL,BSL=A");
                                $saveSoftwareLpar = 1;
                            }
                            elsif ( $bravoSoftwareLpar->status eq 'INACTIVE' ) {
                                dlog("SSL=D,BSL,BSL=I");
                                $saveSoftwareLpar = 0;
                            }
                            else {
                                die "Invalid status: " . $bravoSoftwareLpar->toString() . "\n";
                            }
                        }
                        ###!BSL
                        else {
                            ilog("SSL=D,!BSL");
                            $saveSoftwareLpar = 0;
                        }
                    }
                }
                else {
                    die "Invalid action: " . $stagingSoftwareLpar->toString . "\n";
                }

                ###Save bravo software lpar logic.
                dlog( "save software lpar flag=" . $saveSoftwareLpar );
                if ( $saveSoftwareLpar == 1 ) {

                    ###Check if bravo software lpar is already identical.
                    if (
                            stringEqual( $bravoSoftwareLpar->model, $stagingSoftwareLpar->model )
                         && stringEqual( $bravoSoftwareLpar->biosSerial, $stagingSoftwareLpar->biosSerial )
                         && numericEqualOrBothUndef(
                                                     $bravoSoftwareLpar->processorCount,
                                                     $stagingSoftwareLpar->processorCount
                         )
                         && stringEqual( $bravoSoftwareLpar->scanTime, $stagingSoftwareLpar->scanTime )
                         && $bravoSoftwareLpar->status eq $stagingSoftwareLpar->status
                        )
                    {

                        dlog("bravo software lpar identical to staging software lpar, not saving");

                        if ( $self->loadDeltaOnly == 0 && $bravoSoftwareLpar->customerId ne '999999' ) {

                            ###Call the recon engine if this is a full load even if
                            ###there were no changes to save.
                            dlog("calling recon engine for bravo software lpar object");
                            my $queue = Recon::Queue->new( $self->bravoConnection, $bravoSoftwareLpar );
                            $queue->add;
                            $statistics{'TRAILS'}{'RECON_SW_LPAR'}{'UPDATE'}++;
                            dlog("called recon engine for bravo software lpar object");
                        }
                    }
                    else {
                        ###Set acquisition time if insert.
                        if ( !defined $bravoSoftwareLpar->id ) {

                            ###If insert, use now for acquisitionTime
                            ###(format = yyyy-MM-dd-hh.mm.ss.000000)
                            my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
                            my $now = sprintf( "%04d-%02d-%02d-%02d.%02d.%02d.000000",
                                               ( $year + 1900 ),
                                               ( $mon + 1 ),
                                               $mday, $hour, $min, $sec );
                            $bravoSoftwareLpar->acquisitionTime($now);
                        }

                        ###Update bravo software lpar object from staging data
                        $bravoSoftwareLpar->computerId( $stagingSoftwareLpar->computerId );
                        $bravoSoftwareLpar->objectId( $stagingSoftwareLpar->objectId );
                        $bravoSoftwareLpar->model( $stagingSoftwareLpar->model );
                        $bravoSoftwareLpar->biosSerial( $stagingSoftwareLpar->biosSerial );
                        $bravoSoftwareLpar->osName( $stagingSoftwareLpar->osName );
                        $bravoSoftwareLpar->osType( $stagingSoftwareLpar->osType );
                        $bravoSoftwareLpar->osMajor( $stagingSoftwareLpar->osMajor );
                        $bravoSoftwareLpar->osMinor( $stagingSoftwareLpar->osMinor );
                        $bravoSoftwareLpar->osSub( $stagingSoftwareLpar->osSub );
                        $bravoSoftwareLpar->osType( $stagingSoftwareLpar->osType );
                        $bravoSoftwareLpar->userName( $stagingSoftwareLpar->userName );
                        $bravoSoftwareLpar->biosManufacturer( $stagingSoftwareLpar->biosManufacturer );
                        $bravoSoftwareLpar->biosModel( $stagingSoftwareLpar->biosModel );
                        $bravoSoftwareLpar->serverType( $stagingSoftwareLpar->serverType );
                        $bravoSoftwareLpar->techImgId( $stagingSoftwareLpar->techImgId );
                        $bravoSoftwareLpar->extId( $stagingSoftwareLpar->extId );
                        $bravoSoftwareLpar->memory( $stagingSoftwareLpar->memory );
                        $bravoSoftwareLpar->disk( $stagingSoftwareLpar->disk );
                        $bravoSoftwareLpar->dedicatedProcessors( $stagingSoftwareLpar->dedicatedProcessors );
                        $bravoSoftwareLpar->totalProcessors( $stagingSoftwareLpar->totalProcessors );
                        $bravoSoftwareLpar->sharedProcessors( $stagingSoftwareLpar->sharedProcessors );
                        $bravoSoftwareLpar->processorType( $stagingSoftwareLpar->processorType );
                        $bravoSoftwareLpar->sharedProcByCores( $stagingSoftwareLpar->sharedProcByCores );
                        $bravoSoftwareLpar->dedicatedProcByCores( $stagingSoftwareLpar->dedicatedProcByCores );
                        $bravoSoftwareLpar->totalProcByCores( $stagingSoftwareLpar->totalProcByCores );
                        $bravoSoftwareLpar->alias( $stagingSoftwareLpar->alias );
                        $bravoSoftwareLpar->physicalTotalKb( $stagingSoftwareLpar->physicalTotalKb );
                        $bravoSoftwareLpar->virtualMemory( $stagingSoftwareLpar->virtualMemory );
                        $bravoSoftwareLpar->physicalFreeMemory( $stagingSoftwareLpar->physicalFreeMemory );
                        $bravoSoftwareLpar->virtualFreeMemory( $stagingSoftwareLpar->virtualFreeMemory );
                        $bravoSoftwareLpar->nodeCapacity( $stagingSoftwareLpar->nodeCapacity );
                        $bravoSoftwareLpar->lparCapacity( $stagingSoftwareLpar->lparCapacity );
                        $bravoSoftwareLpar->biosDate( $stagingSoftwareLpar->biosDate );
                        $bravoSoftwareLpar->biosSerialNumber( $stagingSoftwareLpar->biosSerialNumber );
                        $bravoSoftwareLpar->biosUniqueId( $stagingSoftwareLpar->biosUniqueId );
                        $bravoSoftwareLpar->boardSerial( $stagingSoftwareLpar->boardSerial );
                        $bravoSoftwareLpar->caseSerial( $stagingSoftwareLpar->caseSerial );
                        $bravoSoftwareLpar->caseAssetTag( $stagingSoftwareLpar->caseAssetTag );
                        $bravoSoftwareLpar->powerOnPassword( $stagingSoftwareLpar->powerOnPassword );
                        $bravoSoftwareLpar->processorCount( $stagingSoftwareLpar->processorCount );
                        $bravoSoftwareLpar->scanTime( $stagingSoftwareLpar->scanTime );
                        $bravoSoftwareLpar->status( $stagingSoftwareLpar->status );
                        dlog( "new bravo software lpar obj=" . $bravoSoftwareLpar->toString() );

                        ###Save and recon the bravo software lpar object if applyChanges is true.
                        if ( $self->applyChanges == 1 ) {

                            ###Save the object.
                            dlog("saving bravo software lpar object");
                            $bravoSoftwareLpar->save($self->bravoConnection);
                            $statistics{'TRAILS'}{'SOFTWARE_LPAR'}{'UPDATE'}++;
                            dlog("saved bravo software lpar object");
                           
                           if ( $bravoSoftwareLpar->customerId ne '999999'){
                            ###Call the recon engine for the object.
                            dlog("calling recon engine for bravo software lpar object");
                            my $queue = Recon::Queue->new( $self->bravoConnection, $bravoSoftwareLpar );
                            $queue->add;
                            $statistics{'TRAILS'}{'RECON_SW_LPAR'}{'UPDATE'}++;
                            dlog("called recon engine for bravo software lpar object");
                             }
                             
                            ###If we are inactivating this software lpar, then
                            ###we must inactivate all installed software, and
                            ###delete all installed sigs, filters, manual, etc.
                            if ( $bravoSoftwareLpar->status eq 'INACTIVE' ) {
                                dlog("delete all the installed types");
                                BRAVO::Delegate::BRAVODelegate->inactivateSoftwareLparById( $self->bravoConnection,
                                                                            $bravoSoftwareLpar->id, \%statistics );
                            }
                        }
                    }
                }
                else {
                    dlog("not saving bravo software lpar object per flag");

                    if ( $self->loadDeltaOnly == 0 && defined $bravoSoftwareLpar->id && $bravoSoftwareLpar->customerId ne '999999') {

                        ###Call the recon engine if this is a full load even if
                        ###there were no changes to save.
                        dlog("calling recon engine for bravo software lpar object");
                        my $queue = Recon::Queue->new( $self->bravoConnection, $bravoSoftwareLpar );
                        $queue->add;
                        $statistics{'TRAILS'}{'RECON_SW_LPAR'}{'UPDATE'}++;
                        dlog("called recon engine for bravo software lpar object");
                    }
                }

                ###Staging software lpar logic.
                if ( $stagingSoftwareLpar->action eq 'UPDATE' ) {

                    ###Mark as complete.
                    $stagingSoftwareLpar->action('COMPLETE');
                    dlog("marked staging software lpar action as complete");

                    ###Save if applyChanges is true.
                    if ( $self->applyChanges == 1 ) {
                        dlog("saving staging software lpar object");
                        $stagingSoftwareLpar->save($self->stagingConnection);
                        $statistics{'STAGING'}{'SOFTWARE_LPAR'}{'STATUS_COMPLETE'}++;
                        dlog("saved staging software lpar object");
                    }

                }
                elsif ( $stagingSoftwareLpar->action eq 'COMPLETE' ) {

                    ###Do not save in this case to avoid a racing
                    ###condition with the atp to staging loader.
                    dlog("staging software lpar already complete");
                }
                elsif ( $stagingSoftwareLpar->action eq 'DELETE' ) {

                    ###Mark for delete from staging.
                    $stagingSoftwareLparsToDelete{ $stagingSoftwareLpar->id }++;
                    dlog("marking staging software lpar object for delete");
                }
                else {
                    ###Invalid action.
                    die "Invalid action: " . $stagingSoftwareLpar->toString() . "\n";
                }

                ###Save software lpar objects to memory for next row(s).
                ###For software lpars we only want to save them to memory
                ###if saveSoftwareLpar is true or if this row has an
                ###installed software record.
                if ( $saveSoftwareLpar == 1
                     || defined $rec{installedSoftwareTypeTableId} )
                {

                    dlog("saving software lpar objects to memory for subsequent rows");
                    $prevMapKey = $mapKey;
                    dlog( "prevMapKey=" . $prevMapKey );
                    $prevStagingSoftwareLpar = $stagingSoftwareLpar;
                    dlog( "prevStagingSoftwareLpar=" . $prevStagingSoftwareLpar->toString );
                    $prevBravoSoftwareLpar = $bravoSoftwareLpar;
                    dlog( "prevBravoSoftwareLpar=" . $prevBravoSoftwareLpar->toString );
                    $prevDeleteInstalledType = $deleteInstalledType;
                    dlog( "prevDeleteInstalledType=" . $prevDeleteInstalledType );
                    dlog("saved software lpar objects to memory for subsequent rows");
                }
                else {
                    dlog("not saving software lpar objects to memory");
                }
            }
            else {

                ###This is a subsequent row of data for this software lpar key.
                dlog("subsequent row of data for this software lpar key");

                ###Get the objects from memory.
                dlog("getting software lpar objects from memory");
                $stagingSoftwareLpar = $prevStagingSoftwareLpar;
                dlog( "stagingSoftwareLpar=" . $stagingSoftwareLpar->toString );
                $bravoSoftwareLpar = $prevBravoSoftwareLpar;
                dlog( "bravoSoftwareLpar=" . $bravoSoftwareLpar->toString );
                $deleteInstalledType = $prevDeleteInstalledType;
                dlog( "deleteInstalledType=" . $deleteInstalledType );
                dlog("got software lpar objects from memory");
            }

            ###
            ###Handle software lpar map.
            ###

            ###If the mapId is undef then this row is a software lpar only row,
            ###and we can go ahead and go to the next row.
            if ( !defined $rec{mapId} ) {
                dlog("no map id defined, skipping to next row");
                next;
            }

            ###Add this map to the to delete hash if it has been
            ###flagged for delete.
            if ( $rec{mapAction} eq 'DELETE' ) {
                $stagingMapsToDelete{ $rec{mapId} }++;
                dlog( "map flagged for delete, added to hash, mapId: " . $rec{mapId} );
            }

            ###
            ###Handle scan record.
            ###

            ###Add this scan record to the to delete hash if it has been
            ###flagged for delete, but ONLY if the map is also flagged
            ###for delete to avoid racing conditions with the staging loader.
            if (    $rec{scanRecordAction} eq 'DELETE'
                 && $rec{mapAction} eq 'DELETE' )
            {
                $stagingScanRecordsToDelete{ $rec{scanRecordId} }++;
                dlog( "scan record flagged for delete, added to hash, scanRecordId: " . $rec{scanRecordId} );
            }

            ###
            ###Handle installed software.
            ###

            ###If the installed software type is undef then we can go
            ###ahead and go to the next row.
            if ( !defined $rec{installedSoftwareTypeTableId} ) {
                dlog("no installed software id defined, skipping to next row");
                next;
            }
            
            
            
            my $softwareId = undef;
            my $kbDefId = undef;
            my $scanSwItem = undef;
            ###fetch the software id from software item by guid for tad4z.
            if( $rec{installedSoftwareType} eq 'TAD4Z' ){
              dlog("fetch the mainframe feature id by guid.");
              $scanSwItem = new Staging::OM::ScanSoftwareItem();
              $scanSwItem->id( $rec{installedSoftwareTypeTableId} );
              $scanSwItem->getById($self->stagingConnection);
              
              if(!defined $scanSwItem->guId){
                die "Invalid tadz scan item: " . $scanSwItem->toString . "\n";
              }              

              dlog($scanSwItem->toString);
           
              ###next item if we didn't find the scanSoftwareItem under this id.
              next if(!defined $scanSwItem->id);
                       
              #get the kb_def id (software_id) through guid, it may be mainframe_feature
              $kbDefId  = $self->getMainframeFeatureIdByGUID($self->bravoConnection, $scanSwItem->guId);
              $softwareId = $kbDefId;
              if(!defined $kbDefId){
                my $gudi = $scanSwItem->guId;
                dlog("mainframe items not loaded by catalog loader under guid id $gudi");
                $self->updateStagingInstalledType($scanSwItem, 'CATALOG MISSING');
                next;
              }
              
            }else{
              $softwareId = $rec{softwareId};
            }

            ###Get the installed software key
            my $installedSoftwareKey = $bravoSoftwareLpar->id . '|' . $softwareId;
            dlog("installed software key=$installedSoftwareKey");

            ###Get bravo installed software object by biz key if exists
            my $bravoInstalledSoftware = new BRAVO::OM::InstalledSoftware();
            $bravoInstalledSoftware->softwareLparId( $bravoSoftwareLpar->id );
            $bravoInstalledSoftware->softwareId( $softwareId );
            $bravoInstalledSoftware->getByBizKey($self->bravoConnection);

            ###Set the action property to the staging action.
            $bravoInstalledSoftware->action( $rec{installedSoftwareTypeAction} );

            if ( defined $bravoInstalledSoftware->id ) {
                dlog(   "matching bravo installed software record found: "
                      . "old bravo installed software obj="
                      . $bravoInstalledSoftware->toString() );
            }
            else {
                dlog(   "no matching bravo installed software record found: "
                      . "old bravo installed software obj="
                      . $bravoInstalledSoftware->toString() );
            }

            ###Get staging and bravo installed type objects based on type.
            dlog( "installed software type=" . $rec{installedSoftwareType} );
            my $stagingInstalledType;
            my $bravoInstalledType;
            if ( $rec{installedSoftwareType} eq 'SIGNATURE' ) {

                $stagingInstalledType = new Staging::OM::SoftwareSignature();
                $stagingInstalledType->softwareSignatureId( $rec{installedSoftwareTypeId} );
                $stagingInstalledType->path( $rec{path} );

                $bravoInstalledType = new BRAVO::OM::InstalledSignature();
                $bravoInstalledType->softwareSignatureId( $rec{installedSoftwareTypeId} );
            }
            elsif ( $rec{installedSoftwareType} eq 'FILTER' ) {

                $stagingInstalledType = new Staging::OM::SoftwareFilter();
                $stagingInstalledType->softwareFilterId( $rec{installedSoftwareTypeId} );

                $bravoInstalledType = new BRAVO::OM::InstalledFilter();
                $bravoInstalledType->softwareFilterId( $rec{installedSoftwareTypeId} );
            }
            elsif ( $rec{installedSoftwareType} eq 'TLCMZ' ) {

                $stagingInstalledType = new Staging::OM::SoftwareTlcmz();
                $stagingInstalledType->softwareTlcmzId( $rec{installedSoftwareTypeId} );

                $bravoInstalledType = new BRAVO::OM::InstalledTLCMZ();
                $bravoInstalledType->tlcmzProductId( $rec{installedSoftwareTypeId} );
            }
##            elsif ( $rec{installedSoftwareType} eq 'DORANA' ) {
##
##                $stagingInstalledType = new Staging::OM::SoftwareDorana();
##                $stagingInstalledType->softwareDoranaId( $rec{installedSoftwareTypeId} );
##
##                $bravoInstalledType = new BRAVO::OM::InstalledDorana();
##                $bravoInstalledType->doranaProductId( $rec{installedSoftwareTypeId} );
##            }
            elsif ( $rec{installedSoftwareType} eq 'MANUAL' ) {

                $stagingInstalledType = new Staging::OM::SoftwareManual();
                $stagingInstalledType->version( $rec{installedSoftwareTypeVersion} );
                $stagingInstalledType->users( $rec{installedSoftwareTypeUsers} );

                ###Bravo installed type object remains undef.
            }
            elsif ( $rec{installedSoftwareType} eq 'TAD4Z' ) {

                $stagingInstalledType = $scanSwItem;
                dlog('tad4z item to be processed '.$stagingInstalledType->toString);
                
                $bravoInstalledType = new BRAVO::OM::InstalledTADZ();
                $bravoInstalledType->mainframeFeatureId($kbDefId);
                
                 dlog('bravo installed type to be processed '.$bravoInstalledType->toString);

                ###Bravo installed type object remains undef.
            }
            else {
                die "Invalid installed type: " . $rec{installedSoftwareType} . "\n";
            }
            
            if( $rec{installedSoftwareType} ne 'TAD4Z' ){
              $stagingInstalledType->id( $rec{installedSoftwareTypeTableId} );
              $stagingInstalledType->scanRecordId( $rec{scanRecordId} );
              $stagingInstalledType->softwareId( $softwareId );
            }
            
            $stagingInstalledType->action( $rec{installedSoftwareTypeAction} );
            dlog( "staging software installed type obj=" . $stagingInstalledType->toString() );

            if ( defined $bravoInstalledType ) {
                dlog( "bank account id " . $rec{bankAccountId} );

                ###Get bravo installed type object by biz key if exists
                $bravoInstalledType->installedSoftwareId( $bravoInstalledSoftware->id );
                $bravoInstalledType->bankAccountId( $rec{bankAccountId} );
                $bravoInstalledType->getByBizKey($self->bravoConnection);
                if ( defined $bravoInstalledType->id ) {
                    dlog(   "matching bravo installed software type record found: "
                          . "old bravo installed software type obj="
                          . $bravoInstalledType->toString() );
                }
                else {
                    if( $rec{installedSoftwareType} eq 'TAD4Z' ){
                     
                      $stagingInstalledType->lastUsed('1970-01-01')
                         if(!defined $stagingInstalledType->lastUsed || '' eq $stagingInstalledType->lastUsed );
                      
                      $bravoInstalledType->lastUsed($stagingInstalledType->lastUsed);
                      $bravoInstalledType->useCount($stagingInstalledType->useCount);
                    }
                    dlog(   "no matching bravo installed software type record found: "
                          . "old bravo installed software type obj="
                          . $bravoInstalledType->toString() );
                          
                }
            }
            else {
                dlog("bravo installed software type is undef");
            }

            ###Variable to set if the logic determines we should save
            ###this installed software object to the bravo database.
            my $saveInstalledSoftware = 0;

            ###Variable to set if the logic determines we should save
            ###this installed software type object to the bravo database.
            my $saveInstalledType = 0;

            ###Variable to set if we need to log the open or close of a software
            ###discrepancy record in bravo.
            my $softwareDiscrepancyHistory;

            ###Variable to set if the logic determines we should delete
            ###this manual installed software object from the stating
            ###and swasset databases.
            my $deleteManual = 0;

            ###Bravo installed software object logic.

            ###For installed software have to take into account the
            ###deleteInstalledType flag from the lpar logic above.
            dlog( "stagingInstalledType->action=" . $stagingInstalledType->action );
            dlog( "deleteInstalledType=" . $deleteInstalledType );
            my $softwareTypeAction = $stagingInstalledType->action;
            $softwareTypeAction = 'DELETE' if $deleteInstalledType == 1;
            dlog( "softwareTypeAction=" . $softwareTypeAction );

            if ( $rec{installedSoftwareType} eq 'SIGNATURE' ) {
                if ( defined $bravoInstalledType 
                     &&!stringEqualOrBothUndef($stagingInstalledType->path,$bravoInstalledType->path) ) {
                        $saveInstalledType = 1;
                        $bravoInstalledType->path( $stagingInstalledType->path );
                }
            }

            ###SIT=U|C
            if (    $softwareTypeAction eq 'UPDATE'
                 || $softwareTypeAction eq 'COMPLETE' )
            {
                ###BSL
                if ( defined $bravoSoftwareLpar->id ) {
                    ###BSL=A
                    if ( $bravoSoftwareLpar->status eq 'ACTIVE' ) {
                        ###!BIS
                        if ( !defined $bravoInstalledSoftware->id ) {
                            ###SIT=M
                            if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                                dlog("SIT=U|C,BSL,BSL=A,!BIS,SIT=M");
                                $saveInstalledSoftware = 1;
                            }
                            ###SIT!=M
                            else {
                                dlog("SIT=U|C,BSL,BSL=A,!BIS,SIT!=M");
                                $saveInstalledSoftware = 1;
                                $saveInstalledType     = 1;
                            }
                        }
                        ###BIS is defined
                        else {
                            ###BIS=A
                            if ( $bravoInstalledSoftware->status eq 'ACTIVE' ) {
                                ###DT!=M
                                if ( $bravoInstalledSoftware->discrepancyTypeId
                                     != $self->discrepancyTypeMap->{'MISSING'} )
                                {
                                    ###SIT=M
                                    if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                                        dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT=M");
                                        $deleteManual = 1;
                                    }
                                    ###SIT!=M
                                    else {
                                        ###BIT
                                        if ( defined $bravoInstalledType->id ) {
                                            ###BIS=SIT
                                            if (
                                                 numericEqualOrBothUndef( $bravoInstalledSoftware->processorCount,
                                                                          $rec{processorCount} )
                                                 && numericEqualOrBothUndef(
                                                                            $bravoInstalledSoftware->users,
                                                                            $rec{installedSoftwareTypeUsers}
                                                 )
                                                 &&( ($rec{installedSoftwareType} ne 'MANUAL')
                                                     ||
                                                           stringEqualOrBothUndef(
                                                                 $bravoInstalledSoftware->version,
                                                                 $rec{installedSoftwareTypeVersion}
                                                           )
                                                 )
                                                 &&( ($rec{installedSoftwareType} ne 'TAD4Z')
                                                      || ($bravoInstalledSoftware->discrepancyTypeId == $self->discrepancyTypeMap->{'TADZ'}) 
                                                 )
                                               )
                                            {
                                                ###AUTH=AUTH|1
                                                if (
                                                     numericEqualOrBothUndef(
                                                                            $bravoInstalledSoftware->authenticated,
                                                                            $rec{scanRecordAuthenticated}
                                                     )
                                                     || ( defined $bravoInstalledSoftware->authenticated
                                                          && $bravoInstalledSoftware->authenticated == 1 )
                                                    )
                                                {
                                                    dlog(
                                                        "SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,BIT,BIS=SIT,AUTH=AUTH|1"
                                                    );
                                                }
                                                ###AUTH!=AUTH|1
                                                else {
                                                    dlog(
                                                        "SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,BIT,BIS=SIT,AUTH!=AUTH|1"
                                                    );
                                                    $saveInstalledSoftware = 1;
                                                }
                                            }
                                            ###BIS!=SIT
                                            else {
                                                dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,BIT,BIS!=SIT");
                                                $saveInstalledSoftware = 1;
                                            }
                                        }
                                        ###!BIT
                                        else {
                                            ###BIS=SIT
                                            if (
                                                 numericEqualOrBothUndef( $bravoInstalledSoftware->processorCount,
                                                                          $rec{processorCount} )
                                                 && numericEqualOrBothUndef(
                                                                             $bravoInstalledSoftware->users,
                                                                             $rec{installedSoftwareTypeUsers}
                                                 )  
                                                 &&( ($rec{installedSoftwareType} ne 'MANUAL') 
                                                     ||
                                                     stringEqualOrBothUndef(
                                                                            $bravoInstalledSoftware->version,
                                                                            $rec{installedSoftwareTypeVersion}
                                                     )
                                                 )
                                                 &&( ($rec{installedSoftwareType} ne 'TAD4Z')
                                                      || ($bravoInstalledSoftware->discrepancyTypeId == $self->discrepancyTypeMap->{'TADZ'}) 
                                                  ) 
                                               )
                                            {
                                                ###AUTH=AUTH|1
                                                if (
                                                     numericEqualOrBothUndef(
                                                                            $bravoInstalledSoftware->authenticated,
                                                                            $rec{scanRecordAuthenticated}
                                                     )
                                                     || ( defined $bravoInstalledSoftware->authenticated
                                                          && $bravoInstalledSoftware->authenticated == 1 )
                                                    )
                                                {
                                                    dlog(
                                                        "SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,!BIT,BIS=SIT,AUTH=AUTH|1"
                                                    );
                                                    $saveInstalledType = 1;
                                                }
                                                ###AUTH!=AUTH|1
                                                else {
                                                    dlog(
                                                        "SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,!BIT,BIS=SIT,AUTH!=AUTH|1"
                                                    );
                                                    $saveInstalledSoftware = 1;
                                                    $saveInstalledType     = 1;
                                                }
                                            }
                                            ###BIS!=SIT
                                            else {
                                                dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,!BIT,BIS!=SIT");
                                                $saveInstalledSoftware = 1;
                                                $saveInstalledType     = 1;
                                            }
                                        }
                                    }
                                }
                                ###DT=M
                                else {
                                    ###SIT=M
                                    if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                                        ###BIS=SIT
                                        if (
                                             numericEqualOrBothUndef( $bravoInstalledSoftware->processorCount,
                                                                      $rec{processorCount} )
                                             && numericEqualOrBothUndef( $bravoInstalledSoftware->users,
                                                                         $rec{installedSoftwareTypeUsers} )
                                             && stringEqual(
                                                             $bravoInstalledSoftware->version,
                                                             $rec{installedSoftwareTypeVersion}
                                             )
                                            )
                                        {
                                            ###AUTH=AUTH|1
                                            if (
                                                 numericEqualOrBothUndef(
                                                                          $bravoInstalledSoftware->authenticated,
                                                                          $rec{scanRecordAuthenticated}
                                                 )
                                                 || ( defined $bravoInstalledSoftware->authenticated
                                                      && $bravoInstalledSoftware->authenticated == 1 )
                                                )
                                            {
                                                dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT=M,SIT=M,BIS=SIT,AUTH=AUTH|1");
                                            }
                                            ###AUTH!=AUTH|1
                                            else {
                                                dlog(
                                                    "SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT=M,SIT=M,BIS=SIT,AUTH!=AUTH|1");
                                                $saveInstalledSoftware = 1;
                                            }
                                        }
                                        ###BIS!=SIT
                                        else {
                                            dlog("SIT=U|C,BIS,BSL,BSL=A,BIS=A,DT=M,SIT=M,BIS!=SIT");
                                            $saveInstalledSoftware = 1;
                                        }
                                    }
                                    ###SIT!=M
                                    else {
                                        ###BIT
                                        if ( defined $bravoInstalledType->id ) {
                                            ilog("SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT=M,SIT!=M,BIT");
                                            $saveInstalledSoftware      = 1;
                                            $softwareDiscrepancyHistory = 'CLOSE';
                                            $deleteManual               = 1;
                                        }
                                        ###!BIT
                                        else {
                                            dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=A,DT=M,SIT!=M,!BIT");
                                            $saveInstalledSoftware      = 1;
                                            $saveInstalledType          = 1;
                                            $softwareDiscrepancyHistory = 'CLOSE';
                                            $deleteManual               = 1;
                                        }
                                    }
                                }
                            }
                            ###BIS=I
                            elsif ( $bravoInstalledSoftware->status eq 'INACTIVE' ) {
                                ###SIT=M
                                if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                                    dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=I,SIT=M");
                                    $saveInstalledSoftware      = 1;
                                    $softwareDiscrepancyHistory = 'OPEN';
                                }
                                ###SIT!=M
                                else {
                                    ###BIT
                                    if ( defined $bravoInstalledType->id ) {
                                        ilog("SIT=U|C,BSL,BSL=A,BIS,BIS=I,SIT!=M,BIT");
                                        $saveInstalledSoftware = 1;
                                    }
                                    ###!BIT
                                    else {
                                        dlog("SIT=U|C,BSL,BSL=A,BIS,BIS=I,SIT!=M,!BIT");
                                        $saveInstalledSoftware = 1;
                                        $saveInstalledType     = 1;
                                    }
                                }
                            }
                            else {
                                die "Invalid status: " . $bravoInstalledSoftware->toString . "\n";
                            }
                        }
                    }
                    ###BSL=I
                    elsif ( $bravoSoftwareLpar->status eq 'INACTIVE' ) {
                        dlog("SIT=U|C,BSL,BSL=I");
                    }
                    else {
                        die "Invalid status: " . $bravoSoftwareLpar->toString . "\n";
                    }
                }
                ###!BSL
                else {
                    dlog("SIT=U|C,!BSL");
                }
            }
            ###SIT=D
            elsif ( $softwareTypeAction eq 'DELETE' ) {
                ###BSL
                if ( defined $bravoSoftwareLpar->id ) {
                    ###BSL=A
                    if ( $bravoSoftwareLpar->status eq 'ACTIVE' ) {
                        ###BIS
                        if ( defined $bravoInstalledSoftware->id ) {
                            ###BIS=A
                            if ( $bravoInstalledSoftware->status eq 'ACTIVE' ) {
                                ###DT!=M
                                if ( $bravoInstalledSoftware->discrepancyTypeId
                                     != $self->discrepancyTypeMap->{'MISSING'} )
                                {
                                    ###SIT=M
                                    if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                                        ilog("SIT=D,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT=M");
                                        $deleteManual = 1;
                                    }
                                    ###SIT!=M
                                    else {
                                        ###BIT
                                        if ( defined $bravoInstalledType->id ) {
                                            dlog("SIT=D,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,BIT");
                                            $saveInstalledSoftware = 1;
                                            $saveInstalledType     = 1;
                                        }
                                        ###!BIT
                                        else {
                                            ilog("SIT=D,BSL,BSL=A,BIS,BIS=A,DT!=M,SIT!=M,!BIT");
                                        }
                                    }
                                }
                                ###DT=M
                                else {
                                    ###SIT=M
                                    if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                                        dlog("SIT=D,BSL,BSL=A,BIS,BIS=A,DT=M,SIT=M");
                                        $saveInstalledSoftware = 1;
                                        $deleteManual          = 1;
                                    }
                                    ###SIT!=M
                                    else {
                                        ilog("SIT=D,BSL,BSL=A,BIS,BIS=A,DT=M,SIT!=M");
                                    }
                                }
                            }
                            ###BIS=I
                            elsif ( $bravoInstalledSoftware->status eq 'INACTIVE' ) {
                                ilog("SIT=D,BIS,BIS=I");
                            }
                            else {
                                die "Invalid status: " . $bravoInstalledSoftware->toString . "\n";
                            }
                        }
                        ###!BIS
                        else {
                            ilog("SIT=D,!BIS");
                        }
                    }
                    ###BSL=I
                    elsif ( $bravoSoftwareLpar->status eq 'INACTIVE' ) {
                        dlog("SIT=D,BSL,BSL=I");
                    }
                    else {
                        die "Invalid status: " . $bravoSoftwareLpar->toString . "\n";
                    }
                }
                ###!BSL
                else {
                    dlog("SIT=D,!BSL");
                }
            }
            else {
                die "Invalid action: " . $softwareTypeAction . "\n";
            }

            ###Save bravo installed software and installed type logic.
            dlog( "save installed software flag=" . $saveInstalledSoftware );
            dlog( "save installed type flag=" . $saveInstalledType );
            if (    $softwareTypeAction eq 'UPDATE'
                 || $softwareTypeAction eq 'COMPLETE' )
            {

                if ( $saveInstalledSoftware == 1 ) {

                    ###Update bravo installed software object from staging data

                    ###For installed software we will always be active if the
                    ###staging action is update or complete.
                    $bravoInstalledSoftware->status('ACTIVE');

                    ###Always use proc count from staging software lpar.
                    $bravoInstalledSoftware->processorCount( $rec{processorCount} );

                    ###We only want version to be updated by manually submitted
                    ###data since the primary source for version data is sigbank
                    ###for a given scanned signature/filter. Only update version
                    ###if we are a manual line item.
                    $bravoInstalledSoftware->version( $rec{installedSoftwareTypeVersion} )
                        if $rec{installedSoftwareType} eq 'MANUAL';

                    ###Only want to set users and authenticated values if this record
                    ###came from swassset, all other sources will have a value of 0,
                    ###so we should only update if the current bravo value is 0 or
                    ###if the new scan value is not 0.
                    $bravoInstalledSoftware->users( $rec{installedSoftwareTypeUsers} )
                        if defined $bravoInstalledSoftware->users && 
                        ($bravoInstalledSoftware->users == 0 || $rec{installedSoftwareTypeUsers} > 0);
                    $bravoInstalledSoftware->authenticated( $rec{scanRecordAuthenticated} )
                        if defined $bravoInstalledSoftware->authenticated && 
                        ($bravoInstalledSoftware->authenticated == 0 || $rec{scanRecordAuthenticated} > 0);
                    $bravoInstalledSoftware->users(0) 
                       if !defined $bravoInstalledSoftware->users;
                    $bravoInstalledSoftware->authenticated(0) 
                       if !defined $bravoInstalledSoftware->authenticated;
                     

                    ###Update discrepancy type id.
                    if ( $rec{installedSoftwareType} eq 'MANUAL' ) {
                        $bravoInstalledSoftware->discrepancyTypeId( $self->discrepancyTypeMap->{'MISSING'} );
                    }
                    elsif($rec{installedSoftwareType} eq 'TAD4Z'){
                    	# only set TADz the first time
                    	if ( ! defined $bravoInstalledSoftware->discrepancyTypeId ) {
                        	$bravoInstalledSoftware->discrepancyTypeId( $self->discrepancyTypeMap->{'NONE'} );
                        }
                    }else{
                        if ( defined $bravoInstalledSoftware->discrepancyTypeId ) {
                            if ( $bravoInstalledSoftware->discrepancyTypeId
                                 == $self->discrepancyTypeMap->{'MISSING'} )
                            {
                                $bravoInstalledSoftware->discrepancyTypeId( $self->discrepancyTypeMap->{'VALID'} );
                            }
                        }
                        else {
                            $bravoInstalledSoftware->discrepancyTypeId( $self->discrepancyTypeMap->{'NONE'} );
                        }
                    }

                    dlog( "new bravo installed software obj=" . $bravoInstalledSoftware->toString() );

                    ###Save the bravo installed software object if applyChanges is true.
                    if ( $self->applyChanges == 1 ) {

                        ###Save the object.
                        dlog("saving bravo installed software object");
                        $bravoInstalledSoftware->save($self->bravoConnection);
                        $statistics{'TRAILS'}{'INSTALLED_SOFTWARE'}{'UPDATE'}++;
                        dlog("saved bravo installed software object");
						dlog("checking if bravo installed software is in scope of recon engine");
                        my ($sw_license_mgmt, $status) = $self->getCustomerDataByID ($self->bravoConnection, $bravoSoftwareLpar->customerId);
                        if ( $bravoSoftwareLpar->customerId ne '999999' && $sw_license_mgmt eq 'YES' && $status eq 'ACTIVE'){
                        	###Call the recon engine for the object.
                        	dlog("calling recon engine for bravo installed software object");
                        	my $queue =
                        	    Recon::Queue->new( $self->bravoConnection, $bravoInstalledSoftware, $bravoSoftwareLpar );
                        	$queue->add;
                        	$statistics{'TRAILS'}{'RECON_INST_SW'}{'UPDATE'}++;
                        	dlog("called recon engine for bravo installed software object");
                        }else{
                        	dlog("customer is not in scope of recon engine");
                        }
                    }
                }
                else {
                    dlog("not saving bravo installed software per flag");
                }						

                if ( $saveInstalledType == 1 ) {

                    ###Set the installed software id.
                    $bravoInstalledType->installedSoftwareId( $bravoInstalledSoftware->id );

                    dlog( "new bravo installed type obj=" . $bravoInstalledType->toString() );

                    ###Save the bravo installed type object if applyChanges is true.
                    if ( $self->applyChanges == 1 ) {

                        ###Save the object.
                        dlog("saving bravo installed type object");
                        $bravoInstalledType->save($self->bravoConnection)
                            if ( defined $bravoInstalledType->installedSoftwareId );
                        $statistics{'TRAILS'}{ $rec{installedSoftwareType} }{'UPDATE'}++;
                        dlog("saved bravo installed type object");
                    }
                }
                else {
                    dlog("not saving bravo installed type object per flag");
                }
            }
            elsif ( $softwareTypeAction eq 'DELETE' ) {

                if ( $saveInstalledType == 1 ) {

                    ###Delete the bravo installed type object if applyChanges is true.
                    if ( $self->applyChanges == 1 ) {

                        ###Delete the bravo installed type.
                        dlog("deleting bravo installed type object");
                        $bravoInstalledType->delete($self->bravoConnection);
                        $statistics{'TRAILS'}{ $rec{installedSoftwareType} }{'DELETE'}++;
                        dlog("deleted bravo installed type object");
                    }
                }
                else {
                    dlog("not saving bravo installed type object per flag");
                }

                if ( $saveInstalledSoftware == 1 ) {

                    ###We can not inactivate an installed software object
                    ###unless we have just removed the last line installed
                    ###type for the given record.

                    ###Get the count of installed types referencing this record.
                    my $count = BRAVO::Delegate::BRAVODelegate->getInstalledSoftwareCountById( $self->bravoConnection,
                                                                                     $bravoInstalledSoftware->id );

                    ###Do not inactivate if there are still records
                    ###referencing this installed software record.
                    if ( defined $count && $count == 0 ) {

                        ###Update status to inactive.
                        $bravoInstalledSoftware->status('INACTIVE');
                        dlog( "new bravo installed software obj=" . $bravoInstalledSoftware->toString() );

                        ###Save the bravo installed software object if applyChanges is true.
                        if ( $self->applyChanges == 1 ) {

                            ###Save the object.
                            dlog("saving bravo installed software object");
                            $bravoInstalledSoftware->save($self->bravoConnection);
                            $statistics{'TRAILS'}{'INSTALLED_SOFTWARE'}{'UPDATE'}++;
                            dlog("saved bravo installed software object");
                            dlog("checking if customer is in scope for recon engine");

              				my ($sw_license_mgmt, $status) = $self->getCustomerDataByID ($self->bravoConnection, $bravoSoftwareLpar->customerId);
                            if ( $bravoSoftwareLpar->customerId ne '999999' && $sw_license_mgmt eq 'YES' && $status eq 'ACTIVE'){
                            	###Call the recon engine for the object.
                            	dlog("calling recon engine for bravo installed software object");
                            	my $queue =
                            	    Recon::Queue->new( $self->bravoConnection, $bravoInstalledSoftware, $bravoSoftwareLpar );
                            	$queue->add;
                            	$statistics{'TRAILS'}{'RECON_INST_SW'}{'UPDATE'}++;
                            	dlog("called recon engine for bravo installed software object");
                            }else{
                            	dlog("customer is not in scope");
                            }
                            
                            ###Check if this was the last installed software on the associated
                            ###software lpar and inactivate/recon the lpar if it was the last.
                            my $instSwCount =
                                BRAVO::Delegate::BRAVODelegate->getInstalledSoftwareCountBySwLparId(
                                                                                          $self->bravoConnection,
                                                                                          $bravoSoftwareLpar->id );
                            dlog("installed software count for software lpar=$instSwCount");

                            if ( defined $instSwCount && $instSwCount == 0 && $bravoSoftwareLpar->customerId ne '999999' ) {
                                ###Call the recon engine for the object.
                                dlog("calling recon engine for bravo software lpar object");
                                my $queue = Recon::Queue->new( $self->bravoConnection, $bravoSoftwareLpar );
                                $queue->add;
                                $statistics{'TRAILS'}{'RECON_SW_LPAR'}{'UPDATE'}++;
                                dlog("called recon engine for bravo software lpar object");
                            }
                            else {
                                dlog("this is not the last installed software for this lpar");
                            }
                        }
                    }
                    else {
                        dlog("bravo installed software type count > 0, not inactivating");
                    }
                }
                else {

                    dlog("not saving bravo installed software object per flag");
                }
            }

            ###Save bravo software discrepancy history logic.
            if ( defined $softwareDiscrepancyHistory ) {

                dlog( "software discrepancy history flag=" . $softwareDiscrepancyHistory );

                ###Create a new object.
                my $bravoSoftwareDiscrepancyHistory = new BRAVO::OM::SoftwareDiscrepancyHistory();
                $bravoSoftwareDiscrepancyHistory->installedSoftwareId( $bravoInstalledSoftware->id );

                if ( $softwareDiscrepancyHistory eq 'OPEN' ) {

                    $bravoSoftwareDiscrepancyHistory->action('OPEN - MISSING');
                    $bravoSoftwareDiscrepancyHistory->comment('MANUAL LOADER');
                }
                elsif ( $softwareDiscrepancyHistory eq 'CLOSE' ) {

                    $bravoSoftwareDiscrepancyHistory->action('CLOSED - MISSING');
                    $bravoSoftwareDiscrepancyHistory->comment('AUTO CLOSE');
                }
                else {
                    die "Invalid software discrepancy history flag value: " . $softwareDiscrepancyHistory . "\n";
                }
                dlog( "bravo software discrep history object=" . $bravoSoftwareDiscrepancyHistory->toString() );

                ###Save the object if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    dlog("saving bravo software discrep history object");
                    $bravoSoftwareDiscrepancyHistory->save($self->bravoConnection);
                    $statistics{'TRAILS'}{'SW_DISCREP_HIS'}{'UPDATE'}++;
                    dlog("saved bravo software discrep history object");
                }
            }

            ###Staging software type logic.
            if ( $stagingInstalledType->action eq 'UPDATE' ) {
                
                ###Save if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    $self->updateStagingInstalledType($stagingInstalledType, 'COMPLETE');
                    $statistics{'STAGING'}{ $rec{installedSoftwareType} }{'STATUS_COMPLETE'}++;
                }

            }
            elsif ( $stagingInstalledType->action eq 'COMPLETE' ) {

                ###Do not save in this case to avoid a racing
                ###condition with the atp to staging loader.
                dlog("staging installed type already complete");
            }
            elsif ( $stagingInstalledType->action eq 'DELETE' ) {

                ###Delete if applyChanges is true.
                if ( $self->applyChanges == 1 ) {

                    ###Delete from staging.
                    dlog("deleting staging installed type");
                    $stagingInstalledType->delete($self->stagingConnection);
                    $statistics{'STAGING'}{ $rec{installedSoftwareType} }{'DELETE'}++;
                    dlog("deleted staging installed type");
                }
            }
            else {
                ###Invalid action.
                die "Invalid action: " . $stagingInstalledType->toString() . "\n";
            }

            ###Delete manual software block.
            dlog( "delete manual flag=" . $deleteManual );
            if ( $deleteManual == 1 ) {

                ###Instantiate inst manual sw object for this input file line
                my $installedManualSoftware = new SWASSET::OM::InstalledManualSoftware();
                $installedManualSoftware->computerSysId( $rec{scanRecordComputerId} );
                $installedManualSoftware->softwareId( $softwareId );

                ###Get the inst manual sw object from db by biz key.
                $installedManualSoftware->getByBizKey($self->swassetConnection);
                dlog( "swasset installed manual software: " . $installedManualSoftware->toString() );

                ###Delete the record if id is set.
                if ( defined $installedManualSoftware->id ) {
                    dlog("deleting swasset installed manual software");
                    $installedManualSoftware->delete($self->swassetConnection);
                    $statistics{'SWASSET'}{'MANUAL_SW'}{'DELETE'}++;
                    dlog("deleted swasset installed manual software");
                }
                else {
                    dlog("not deleteing swasset installed manual software because id not set");
                }

                ###Check if this was the last line item of software for this
                ###manual computer record.
                my $manualCount = SWASSETDelegate->getManualSoftwareCountByComputerSysId( $self->swassetConnection,
                                                                                      $rec{scanRecordComputerId} );
                dlog("manualCount=$manualCount");

                ###Delete the manual computer record if this was the last sw line item.
                if ( $manualCount == 0 ) {

                    ###Get the manual computer object from db by biz key.
                    my $manualComputer = new SWASSET::OM::ManualComputer();
                    $manualComputer->computerSysId( $rec{scanRecordComputerId} );
                    $manualComputer->getByBizKey($self->swassetConnection);
                    dlog( "swasset manual computer: " . $manualComputer->toString() );

                    ###Delete the manual computer record.
                    dlog("deleting swasset manual computer");
                    $manualComputer->delete($self->swassetConnection);
                    $statistics{'SWASSET'}{'MANUAL_COMPUTER'}{'DELETE'}++;
                    dlog("deleted swasset manual computer");
                }
            }

        }
        $sth->finish;

        ###Perform staging deletes if applyChanges is 1.
        if ( $self->applyChanges == 1 ) {

            ###Delete any staging software lpar maps which have been flagged
            ###and processed above.
            dlog("performing any pending staging software lpar map deletes");
            foreach my $id ( sort keys %stagingMapsToDelete ) {
                my $softwareLparMap = new Staging::OM::SoftwareLparMapNonObject();
                $softwareLparMap->id($id);
                $softwareLparMap->delete($self->stagingConnection);
                $statistics{'STAGING'}{'SOFTWARE_LPAR_MAP'}{'DELETE'}++;
                dlog( "deleted staging software lpar map: " . $softwareLparMap->toString() );
            }

            ###Delete any staging software lpars which have been flagged
            ###and processed above.
            dlog("performing any pending staging software lpar deletes");
            foreach my $id ( sort keys %stagingSoftwareLparsToDelete ) {
                my $softwareLpar = new Staging::OM::SoftwareLpar();
                $softwareLpar->id($id);
                $softwareLpar->delete($self->stagingConnection);
                $statistics{'STAGING'}{'SOFTWARE_LPAR'}{'DELETE'}++;
                dlog( "deleted staging software lpar: " . $softwareLpar->toString() );
            }

            ###Delete any staging scan records which have been flagged
            ###and processed above, if applyChanges is 1.
            dlog("performing any pending staging scan record deletes");
            foreach my $id ( sort keys %stagingScanRecordsToDelete ) {
                my $scanRecord = new Staging::OM::ScanRecord();
                $scanRecord->id($id);
                $scanRecord->delete($self->stagingConnection);
                $statistics{'STAGING'}{'SCAN_RECORD'}{'DELETE'}++;
                dlog( "deleted staging scan record: " . $scanRecord->toString() );
            }
        }
    };
    if ($@) {
        ###Something died in the eval, set dieMsg so
        ###we know to die after closing the db connections.
        elog($@);
        $dieMsg = $@;
    }

    ###Display statistics
    #Staging::Delegate::StagingDelegate->insertCount( $self->stagingConnection, \%statistics );

    ###Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    ilog("totalProcessingTime: $totalProcessingTime secs");

    ###die if dieMsg is defined
    die $dieMsg if defined($dieMsg);
}

###Checks arguments passed to load method.
sub checkArgs {
    my ( $self, $args ) = @_;

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

    ###Check CustomerId arg is passed correctly
    die "Must specify CustomerId sub argument!\n"
        unless exists( $args->{'CustomerId'} );
    die "Invalid value passed for CustomerId param!\n"
        unless $args->{'CustomerId'} =~ m/\d+/;
    $self->customerId( $args->{'CustomerId'} );
    ilog( "customerId=" . $self->customerId );

    ###Check Phase arg is passed correctly
    die "Must specify Phase sub argument!\n"
        unless exists( $args->{'Phase'} );
    die "Invalid value passed for Phase param!\n"
        unless $args->{'Phase'} =~ m/\d+/;
    $self->phase( $args->{'Phase'} );
    ilog( "phase=" . $self->phase );

    ###Check Phase arg is passed correctly
    die "Must specify Phase sub argument!\n"
        unless exists( $args->{'LparId'} );
    die "Invalid value passed for Phase param!\n"
        unless $args->{'LparId'} =~ m/\d+/;
    $self->lparId( $args->{'LparId'} );
    ilog( "phase=" . $self->lparId );
}

sub querySoftwareLparDataByCustomerId {
    my ( $self, $deltaOnly ) = @_;
    my @fields = (
        qw(
            id
            customerId
            computerId
            objectId
            name
            model
            biosSerial
            osName
            osType
            osMajor
            osMinor
            osSub
            osInst
            userName
            manufacturer
            biosModel
            serverType
            techImageId
            extId
            memory
            disk
            dedicatedProcessors
            totalProcessors
            sharedProcessors
            processorType
            sharedProcByCores
            dedicatedProcByCores
            totalProcByCores
            alias
            physicalTotalKb
            virtualMemory
            physicalFreeMemory
            virtualFreeMemory
            nodeCapacity
            lparCapacity
            biosDate
            biosSerialNumber
            biosUniqueId
            boardSerial
            caseSerial
            caseAssetTag
            powerOnPassword
            processorCount
            scanTime
            status
            action
            mapId
            mapAction
            scanRecordId
            scanRecordComputerId
            bankAccountId
            scanRecordScanTime
            scanRecordAuthenticated
            scanRecordAction
            installedSoftwareType
            installedSoftwareTypeTableId
            installedSoftwareTypeId
            softwareId
            path
            installedSoftwareTypeAction
            installedSoftwareTypeUsers
            installedSoftwareTypeVersion
            )
    );
    my $query = '
        select * from (
    ';
        $query .= $self->getManualQuery();
        $query .= '
            union
        ';
        $query .= $self->getSignatureQuery();
        $query .= '
            union
        ';
        $query .= $self->getFilterQuery();
        $query .= '
            union
        ';
        $query .= $self->getTlcmzQuery();
        $query .= '
            union
        ';
##      $query .= $self->getDoranaQuery();
##      $query .= '
##          union
##      ';
        $query .= $self->getTad4zQuery();
    $query .= '
        ) as x
        order by
            x.lpar_id
            ,x.map_id
            ,x.scan_record_id
            ,x.software_id
        with ur
    ';

    dlog("querySoftwareLparDataByCustomerId=$query");
    return ( 'softwareLparDataByCustomerId', $query, \@fields );
}

sub getManualQuery {
    my $self = shift;
    return '
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'MANUAL\' as type
                ,d.id as type_table_id
                ,0 as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,d.users
                ,d.version                
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_manual d on d.scan_record_id = c.id
            where
                a.customer_id = ?
                and a.id = ?
            ';
}

sub getSignatureQuery {
    my $self = shift;
    return '
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'SIGNATURE\' as type
                ,d.id as type_table_id
                ,d.software_signature_id as type_id
                ,d.software_id
                ,d.path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_signature d on d.scan_record_id = c.id
            where
                a.customer_id = ?
                and a.id = ?
            ';
}

sub getFilterQuery {
    my $self = shift;
    return '
                select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'FILTER\' as type
                ,d.id as type_table_id
                ,d.software_filter_id as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_filter d on d.scan_record_id = c.id
            where
                a.customer_id = ?
                and a.id = ?
                ';
}

sub getTlcmzQuery {
    my $self = shift;
    return '
                select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'TLCMZ\' as type
                ,d.id as type_table_id
                ,d.sa_product_id as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_tlcmz d on d.scan_record_id = c.id
            where
                a.customer_id = ?
                and a.id = ?
                ';
}

sub getDoranaQuery {
    my $self = shift;
    return '
                select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'DORANA\' as type
                ,d.id as type_table_id
                ,d.dorana_product_id as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_dorana d on d.scan_record_id = c.id
            where
                a.customer_id = ?
                and a.id = ?
                ';
}

sub getTad4zQuery {
    my $self = shift;
    return '
                select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'TAD4Z\' as type
                ,d.id as type_table_id
                ,0 as type_id
                ,0 as software_id
                ,\'NULL\' as path
                ,case 
                  when d.action=0 then \'COMPLETE\'
                  when d.action=1 then \'UPDATE\'
                  when d.action=2 then \'DELETE\'
                  when d.action=3 then \'UPDATE\'
                 end
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join scan_software_item d on d.scan_record_id = c.id
            where
                a.customer_id = ?
                and a.id = ?
                ';
}

sub getMainframeFeatureIdByGUID{
   my ($self, $connection, $guid)  = @_;
   
    $connection->prepareSqlQuery($self->queryMainframeFeatureIdByGUID());
    my $sth = $connection->sql->{getMainframeFeatureId};
    my $featureId=undef;
    my $lowerGuid=lc($guid);
  
    $sth->bind_columns(
        \$featureId
    );
    $sth->execute(
        $lowerGuid,$guid
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    
    return $featureId;
}


sub queryMainframeFeatureIdByGUID {
    my $query = '
        select id from kb_definition kb where exists (select 1 from mainframe_feature mf where mf.id=kb.id ) and (kb.guid =  ? or kb.guid = ?) with ur
    ';
    return ('getMainframeFeatureId', $query);
}

sub getCustomerDataByID{
   my ($self, $connection, $customerID)  = @_;
   
    $connection->prepareSqlQuery($self->queryCustomersByID());
    my $sth = $connection->sql->{getCustomersByID};
    my $sw_license_mgmt = undef;
    my $status = undef;
  
    $sth->bind_columns(
        \$sw_license_mgmt,
        \$status
    );
    $sth->execute(
        $customerID
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    
    return ($sw_license_mgmt, $status);
}

sub queryCustomersByID{
	my $query = '
		select sw_license_mgmt, status from customer where customer_id = ?
	';
	return ('getCustomersByID', $query); 
}



sub updateStagingInstalledType{
  my($self,$stagingInstalledType, $action) = @_;
  
  dlog("marked staging installed type action as complete");
  ###it is TADZ data type, convert the action from string to integer
  if($stagingInstalledType->isa("Staging::OM::ScanSoftwareItem")){
   
    #0-COMPLETE, 1-UPDATE, 2-DELETE, 3-CATALOGMISSING
    if($action eq 'COMPLETE'){
      $stagingInstalledType->action(0);
    }elsif($action eq 'CATALOG MISSING'){
      dlog("staging installed type catalog missing");
      $stagingInstalledType->action(3);
    }
   
  }else{
     $stagingInstalledType->action($action);
  }
                   
  dlog("saving staging installed type object");                    
  $stagingInstalledType->save($self->stagingConnection);
  dlog("saved staging installed type object");
 
}
1;

