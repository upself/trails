package Staging::ScanRecordToLparLoader;

use Base::Utils;
use Staging::Delegate::HardwareLparDelegate;
use CNDB::Delegate::CNDBDelegate;
use Staging::Delegate::ScanRecordDelegate;
use Staging::OM::ScanRecord;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMap;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::ScanTADzDelegate;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Sigbank::Delegate::BankAccountDelegate;
use Sigbank::OM::BankAccount;
use BRAVO::Delegate::BRAVODelegate;

use strict;

###Need to check and make sure current stuff has active customerIds, etc
sub new {
    my ($class) = @_;

    dlog('Instatiating ScanRecordLoader');

    my $self = {
                 _testMode       => undef,
                 _applyChanges   => undef,
                 _lpar           => undef,
                 _maps           => undef,
                 _inclusionMap   => undef,
                 _tadzAccountMap   => undef,
                 _updateCntSlm   => 0,
                 _completeCntSlm => 0,
                 _deleteCntSlm   => 0,
                 _updateCntSr    => 0,
                 _completeCntSr  => 0,
                 _deleteCntSr    => 0,
                 _updateCntSl    => 0,
                 _completeCntSl  => 0,
                 _deleteCntSl    => 0
    };

    bless $self, $class;

    dlog('ScanRecordToLparLoader instantiated');

    return $self;
}

sub load {
    my ( $self, %args ) = @_;

    dlog('Start load method');

    dlog('Checking passed arguments');
    $self->checkArgs( \%args );
    dlog('Arguments checked');

    ###Set the job we are running
    my $job = 'SCAN RECORD TO LPAR';
    dlog("Current job=$job");

    my $systemScheduleStatus;
    if ( $self->applyChanges == 1 ) {
        ilog("Starting $job system schedule status");
        $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
        ilog("Started $job system schedule status");
    }

    dlog('Setting the flag');
    $self->flag(1);
    dlog('Flag set');

    ilog('Acquiring the staging connection');
    my $stagingConnection = Database::Connection->new('staging');
    ilog('Staging connection acquired');

    ilog('Acquiring the bravo connection');
    my $bravoConnection = Database::Connection->new('trails');
    ilog('Bravo connection acquired');

    my $dieMsg = undef;
    eval {

        ilog('Generating mappings');
        $self->prepareMappings( $stagingConnection, $bravoConnection );
        ilog('Mappings generated');

        ilog('Performing Delta');
        $self->doDelta($stagingConnection);
        ilog('Delta complete');

        ilog('Applying Delta');
        $self->applyDelta($stagingConnection);
        ilog('Delta applied');
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);

        if ( $self->applyChanges == 1 ) {
            SystemScheduleStatusDelegate->error( $systemScheduleStatus, $dieMsg );
        }
    }
    else {
        if ( $self->applyChanges == 1 ) {
            ilog("Stopping $job system schedule status");
            SystemScheduleStatusDelegate->stop($systemScheduleStatus);
            ilog("Stopped $job system schedule status");
        }
    }

    Staging::Delegate::StagingDelegate->insertCount( $stagingConnection, $self->{count} );

    ilog('Disconnecting from staging');
    $stagingConnection->disconnect;
    ilog('Staging disconnected');

    ilog('Disconnecting from bravo');
    $bravoConnection->disconnect;
    ilog('Bravo disconnected');

    die $dieMsg if defined $dieMsg;

    dlog('End load method complete');
}

sub checkArgs {
    my ( $self, $args ) = @_;

    ###Check TestMode arg is passed correctly
    die "Must specify TestMode sub argument!\n"
        unless exists( $args->{'TestMode'} );
    die "Invalid value passed for TestMode param!\n"
        unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 );
    ilog( "TestMode arg=" . $args->{'TestMode'} );

    ###Check ApplyChanges arg is passed correctly
    die "Must specify ApplyChanges sub argument!\n"
        unless exists( $args->{'ApplyChanges'} );
    die "Invalid value passed for ApplyChanges param!\n"
        unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 );
    ilog( "ApplyChanges arg=" . $args->{'ApplyChanges'} );

    dlog('Setting passed arguments');
    $self->testMode( $args->{'TestMode'} );
    $self->applyChanges( $args->{'ApplyChanges'} );
    dlog('Arguments set');
}

sub prepareMappings {
    my ( $self, $connection, $bravoConnection ) = @_;

    dlog('Start prepareMappings method');

    ilog('Obtaining hardware lpar map');
    $self->hwLparMap( HardwareLparDelegate->getHardwareLparCustomerMap($connection) );
    ilog('Obtained hardware lpar map');

    ilog('Obtaining customer map');
    $self->customerMap( CNDB::Delegate::CNDBDelegate->getCustomerMaps() );
    ilog('Obtained customer map');

    ilog('Obtaining bank account inclusion map');
    $self->inclusionMap( BRAVO::Delegate::BRAVODelegate->getBankAccountInclusionMap($bravoConnection) );
    ilog('Obtained bank account exception map');

    ilog('Obtaining TADz bank account map');
    $self->tadzAccountMap( Sigbank::Delegate::BankAccountDelegate->getBankAccountIdsByType('TADZ') );
    ilog('Obtained TADz bank account map');

    dlog('End prepareMappings method');
}

sub doDelta {
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    dlog('Preparing our staging query');
    $connection->prepareSqlQueryAndFields( Staging::Delegate::StagingDelegate->queryLparMaps() );
    dlog('Staging query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{lparMaps};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{lparMapsFields} } );
    dlog('Columns binded');

    my %lpar;
    my @maps;

    ilog('Executing staging lpar maps query');
    ###Pulling what is already in the software lpars left joined to what is in map and scan record
    $sth->execute();

    while ( $sth->fetchrow_arrayref ) {

        my $sr = new Staging::OM::ScanRecord();
        $sr->id( $rec{scanRecordId} );
        $sr->computerId( $rec{scanRecordComputerId} );
        $sr->name( $rec{scanRecordName} );
        $sr->objectId( $rec{scanRecordObjectId} );
        $sr->model( $rec{scanRecordModel} );
        $sr->serialNumber( $rec{scanRecordSerialNumber} );
        $sr->scanTime( $rec{scanRecordScanTime} );
        $sr->osName( $rec{scanRecordOsName} );
        $sr->osType( $rec{scanRecordOsType} );
        $sr->osMajor( $rec{scanRecordOsMajor} );
        $sr->osMinor( $rec{scanRecordOsMinor} );
        $sr->osSub( $rec{scanRecordOsSub} );
        $sr->osType( $rec{scanRecordOsType} );
        $sr->userName( $rec{scanRecordUserName} );
        $sr->biosManufacturer( $rec{scanRecordManufacturer} );
        $sr->biosModel( $rec{scanRecordBiosModel} );
        $sr->serverType( $rec{scanRecordServerType} );
        $sr->techImgId( $rec{scanRecordTechImageId} );
        $sr->extId( $rec{scanRecordExtId} );
        $sr->memory( $rec{scanRecordMemory} );
        $sr->disk( $rec{scanRecordDisk} );
        $sr->dedicatedProcessors( $rec{scanRecordDedicatedProcessors} );
        $sr->totalProcessors( $rec{scanRecordTotalProcessors} );
        $sr->sharedProcessors( $rec{scanRecordSharedProcessors} );
        $sr->processorType( $rec{scanRecordProcessorType} );
        $sr->sharedProcByCores( $rec{scanRecordSharedProcByCores} );
        $sr->dedicatedProcByCores( $rec{scanRecordDedicatedProcByCores} );
        $sr->totalProcByCores( $rec{scanRecordTotalProcByCores} );
        $sr->alias( $rec{scanRecordAlias} );
        $sr->physicalTotalKb( $rec{scanRecordPhysicalTotalKb} );
        $sr->virtualMemory( $rec{scanRecordVirtualMemory} );
        $sr->physicalFreeMemory( $rec{scanRecordPhysicalFreeMemory} );
        $sr->virtualFreeMemory( $rec{scanRecordVirtualFreeMemory} );
        $sr->nodeCapacity( $rec{scanRecordNodeCapacity} );
        $sr->lparCapacity( $rec{scanRecordLparCapacity} );
        $sr->biosDate( $rec{scanRecordBiosDate} );
        $sr->biosSerialNumber( $rec{scanRecordBiosSerialNumber} );
        $sr->biosUniqueId( $rec{scanRecordBiosUniqueId} );
        $sr->boardSerial( $rec{scanRecordBoardSerial} );
        $sr->caseSerial( $rec{scanRecordCaseSerial} );
        $sr->caseAssetTag( $rec{scanRecordCaseAssetTag} );
        $sr->powerOnPassword( $rec{scanRecordPowerOnPassword} );
        $sr->processorCount( $rec{scanRecordProcessorCount} );
        $sr->users( $rec{users} );
        $sr->authenticated( $rec{authenticated} );
        $sr->bankAccountId( $rec{bankAccountId} );
        $sr->isManual( $rec{isManual} );
        $sr->action( $rec{scanRecordAction} );
        dlog( $sr->toString );

        my $newSl = new Staging::OM::SoftwareLpar();
        $newSl->id( $rec{softwareLparId} );
        $newSl->computerId( $sr->computerId );
        $newSl->objectId( $sr->objectId );
        $newSl->name( $sr->name );
        $newSl->model( $sr->model );
        $newSl->biosSerial( $sr->serialNumber );
        $newSl->osName( $sr->osName );
        $newSl->osType( $sr->osType );
        $newSl->osMajor( $sr->osMajor );
        $newSl->osMinor( $sr->osMinor );
        $newSl->osSub( $sr->osSub );
        $newSl->osType( $sr->osType );
        $newSl->userName( $sr->userName );
        $newSl->biosManufacturer( $sr->biosManufacturer );
        $newSl->biosModel( $sr->biosModel );
        $newSl->serverType( $sr->serverType );
        $newSl->techImgId( $sr->techImgId );
        $newSl->extId( $sr->extId );
        $newSl->memory( $sr->memory );
        $newSl->disk( $sr->disk );
        $newSl->dedicatedProcessors( $sr->dedicatedProcessors );
        $newSl->totalProcessors( $sr->totalProcessors );
        $newSl->sharedProcessors( $sr->sharedProcessors );
        $newSl->processorType( $sr->processorType );
        $newSl->sharedProcByCores( $sr->sharedProcByCores );
        $newSl->dedicatedProcByCores( $sr->dedicatedProcByCores );
        $newSl->totalProcByCores( $sr->totalProcByCores );
        $newSl->alias( $sr->alias );
        $newSl->physicalTotalKb( $sr->physicalTotalKb );
        $newSl->virtualMemory( $sr->virtualMemory );
        $newSl->physicalFreeMemory( $sr->physicalFreeMemory );
        $newSl->virtualFreeMemory( $sr->virtualFreeMemory );
        $newSl->nodeCapacity( $sr->nodeCapacity );
        $newSl->lparCapacity( $sr->lparCapacity );
        $newSl->biosDate( $sr->biosDate );
        $newSl->biosSerialNumber( $sr->biosSerialNumber );
        $newSl->biosUniqueId( $sr->biosUniqueId );
        $newSl->boardSerial( $sr->boardSerial );
        $newSl->caseSerial( $sr->caseSerial );
        $newSl->caseAssetTag( $sr->caseAssetTag );
        $newSl->powerOnPassword( $sr->powerOnPassword );
        $newSl->processorCount( $sr->processorCount );
        $newSl->scanTime( $sr->scanTime );
        $newSl->status('ACTIVE');
        dlog( $newSl->toString );

        my $oldSl = new Staging::OM::SoftwareLpar();
        $oldSl->id( $rec{softwareLparId} );
        $oldSl->customerId( $rec{customerId} );
        $oldSl->computerId( $rec{softwareLparComputerId} );
        $oldSl->objectId( $rec{softwareLparObjectId} );
        $oldSl->name( $rec{softwareLparName} );
        $oldSl->model( $rec{softwareLparModel} );
        $oldSl->biosSerial( $rec{softwareLparSerialNumber} );
        $oldSl->osName( $rec{softwareLparOsName} );
        $oldSl->osType( $rec{softwareLparOsType} );
        $oldSl->osMajor( $rec{softwareLparOsMajor} );
        $oldSl->osMinor( $rec{softwareLparOsMinor} );
        $oldSl->osSub( $rec{softwareLparOsSub} );
        $oldSl->osType( $rec{softwareLparOsType} );
        $oldSl->userName( $rec{softwareLparUserName} );
        $oldSl->biosManufacturer( $rec{softwareLparManufacturer} );
        $oldSl->biosModel( $rec{softwareLparBiosModel} );
        $oldSl->serverType( $rec{softwareLparServerType} );
        $oldSl->techImgId( $rec{softwareLparTechImageId} );
        $oldSl->extId( $rec{softwareLparExtId} );
        $oldSl->memory( $rec{softwareLparMemory} );
        $oldSl->disk( $rec{softwareLparDisk} );
        $oldSl->dedicatedProcessors( $rec{softwareLparDedicatedProcessors} );
        $oldSl->totalProcessors( $rec{softwareLparTotalProcessors} );
        $oldSl->sharedProcessors( $rec{softwareLparSharedProcessors} );
        $oldSl->processorType( $rec{softwareLparProcessorType} );
        $oldSl->sharedProcByCores( $rec{softwareLparSharedProcByCores} );
        $oldSl->dedicatedProcByCores( $rec{softwareLparDedicatedProcByCores} );
        $oldSl->totalProcByCores( $rec{softwareLparTotalProcByCores} );
        $oldSl->alias( $rec{softwareLparAlias} );
        $oldSl->physicalTotalKb( $rec{softwareLparPhysicalTotalKb} );
        $oldSl->virtualMemory( $rec{softwareLparVirtualMemory} );
        $oldSl->physicalFreeMemory( $rec{softwareLparPhysicalFreeMemory} );
        $oldSl->virtualFreeMemory( $rec{softwareLparVirtualFreeMemory} );
        $oldSl->nodeCapacity( $rec{softwareLparNodeCapacity} );
        $oldSl->lparCapacity( $rec{softwareLparLparCapacity} );
        $oldSl->biosDate( $rec{softwareLparBiosDate} );
        $oldSl->biosSerialNumber( $rec{softwareLparBiosSerialNumber} );
        $oldSl->biosUniqueId( $rec{softwareLparBiosUniqueId} );
        $oldSl->boardSerial( $rec{softwareLparBoardSerial} );
        $oldSl->caseSerial( $rec{softwareLparCaseSerial} );
        $oldSl->caseAssetTag( $rec{softwareLparCaseAssetTag} );
        $oldSl->powerOnPassword( $rec{softwareLparPowerOnPassword} );
        $oldSl->processorCount( $rec{softwareLparProcessorCount} );
        $oldSl->scanTime( $rec{softwareLparScanTime} );
        $oldSl->status( $rec{softwareLparStatus} );
        $oldSl->action( $rec{softwareLparAction} );
        dlog( $oldSl->toString );

        my $slm = new Staging::OM::SoftwareLparMap();
        $slm->id( $rec{softwareLparMapId} );
        $slm->scanRecord($sr);
        $slm->softwareLpar($oldSl);
        $slm->action( $rec{softwareLparMapAction} );
        dlog( $slm->toString );

        if ( defined $sr->id ) {
            dlog('ScanRecord is defined');

            if ( defined $oldSl->id ) {
                dlog('SoftwareLpar is defined');

                if ( defined $slm->id ) {
                    dlog('SoftwareLparMap is defined');

                    if ( $sr->action eq 'UPDATE' ) {
                        dlog('ScanRecord is marked as update');

                        if ( $oldSl->action eq 'UPDATE' ) { #NOTE Start of check invalid software_lpar_map #1
                            dlog('SoftwareLpar is marked as update');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=U,SL=U,SLM=C');

                                ###SoftwareLpar is in update, we don't want to touch anything
                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );
                                    $lpar{$key}->action('UPDATE');
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=U,SL=U,SLM=D');

                                ###SoftwareLpar is in update, we don't want to touch anything
                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );
                                    $lpar{$key}->action('UPDATE');
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        }  #NOTE end of invalid software_lpar_map block #1
                        elsif ( $oldSl->action eq 'COMPLETE' ) { #NOTE start of invalid software_lpar_map block #2
                            dlog('SoftwareLpar is marked as complete');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=U,SL=C,SLM=C');

                                my $customerId = $self->getCustomerId($sr);
                                dlog("customerId=$customerId");

                                if ( $customerId =~ m/\D/ ) {
                                    dlog('ScanRecord does not map to a customerId');

                                    my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                    if ( exists $lpar{$key} ) {
                                        dlog('This lpar has been processed before');

                                        $lpar{$key}->id( $slm->softwareLpar->id );

                                        if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                            dlog('The processed lpar is in savedelete');
                                        }
                                        else {
                                            dlog('The processed lpar is not in savedelete');

                                            if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                dlog('Processed lpar equals db lpar');

                                                $lpar{$key}->action('COMPLETE');
                                            }
                                            else {
                                                dlog('Processed lpar does not equal db lpar');

                                                $lpar{$key}->action('SAVEUPDATE');
                                            }
                                        }

                                        $slm->action('DELETE');
                                        $slm->save($connection);
                                        $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );

                                        $sr->action('COMPLETE');
                                        $sr->save($connection);
                                        $self->addToCount( 'STAGING', 'SCAN_RECORD', 'STATUS_COMPLETE' );
                                    }
                                    else {
                                        dlog('This lpar has not been processed');

                                        $sr->action('COMPLETE');
                                        $sr->save($connection);
                                        $self->addToCount( 'STAGING', 'SCAN_RECORD', 'STATUS_COMPLETE' );

                                        $slm->action('DELETE');
                                        $slm->save($connection);
                                        $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );

                                        $slm->softwareLpar->action('SAVEDELETE');

                                        $lpar{$key} = $slm->softwareLpar;
                                    }
                                }
                                else {
                                    dlog('ScanRecord maps to a customerId');

                                    my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;
                                    dlog("key=$key");

                                    $newSl->customerId($customerId);

                                    if ( $newSl->customerId eq $slm->softwareLpar->customerId ) {
                                        dlog('ScanRecord customerId equals SoftwareLpar customerId');

                                        if ( $newSl->name eq $slm->softwareLpar->name ) {
                                            dlog('ScanRecord name equals SoftwareLpar name');

                                            if ( $newSl->equals( $slm->softwareLpar ) ) {
                                                dlog('ScanRecord equals SoftwareLpar');

                                                if ( exists $lpar{$key} ) {
                                                    dlog('This lpar has been processed before');

                                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                                    if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                        dlog('Processed lpar equals db lpar');

                                                        $lpar{$key}->action('COMPLETE');
                                                    }
                                                    else {
                                                        dlog('Processed lpar does not equal db lpar');

                                                        $lpar{$key}->action('SAVEUPDATE');
                                                    }

                                                    $sr->action('COMPLETE');
                                                    $sr->save($connection);
                                                    $self->addToCount( 'STAGING', 'SCAN_RECORD',
                                                                       'STATUS_COMPLETE' );
                                                }
                                                else {
                                                    dlog('This lpar has not been processed before');

                                                    $lpar{$key} = $slm->softwareLpar;

                                                    $sr->action('COMPLETE');
                                                    $sr->save($connection);
                                                    $self->addToCount( 'STAGING', 'SCAN_RECORD',
                                                                       'STATUS_COMPLETE' );
                                                }
                                            }
                                            else {
                                                dlog('ScanRecord does not equal SoftwareLpar');

                                                if ( exists $lpar{$key} ) {
                                                    dlog('This lpar has been processed before');

                                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                                    if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                        dlog('Processed lpar equals db lpar');

                                                        $lpar{$key}->action('COMPLETE');
                                                    }
                                                    else {
                                                        dlog('Processed lpar does not equal db lpar');

                                                        $lpar{$key}->action('SAVEUPDATE');
                                                    }

                                                    $sr->action('COMPLETE');
                                                    $sr->save($connection);
                                                    $self->addToCount( 'STAGING', 'SCAN_RECORD',
                                                                       'STATUS_COMPLETE' );
                                                }
                                                else {
                                                    dlog('This lpar has not been processed before');

                                                    $newSl->action('SAVEUPDATE');

                                                    $lpar{$key} = $newSl;
                                                    $slm->softwareLpar( $lpar{$key} );

                                                    $sr->action('COMPLETE');
                                                    $sr->save($connection);
                                                    $self->addToCount( 'STAGING', 'SCAN_RECORD',
                                                                       'STATUS_COMPLETE' );
                                                }
                                            }
                                        }
                                        else {
                                            dlog('ScanRecord name does not equal softwareLpar name');
                                            ###So, this scan record no longer maps to the old lpar, it is a new lpar( to itself)
                                            ###We need to delete the mapping and delete the lpar much like we do for the savedeletes
                                            ###But we want to leave the scanrecord in update status

                                            if ( exists $lpar{$key} ) {
                                                dlog('This lpar has been processed before');

                                                $lpar{$key}->id( $slm->softwareLpar->id );

                                                if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                                    dlog('The processed lpar is in savedelete');
                                                }
                                                else {
                                                    dlog('The processed lpar is not in savedelete');

                                                    if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                        dlog('Processed lpar equals db lpar');

                                                        $lpar{$key}->action('COMPLETE');
                                                    }
                                                    else {
                                                        dlog('Processed lpar does not equal db lpar');

                                                        $lpar{$key}->action('SAVEUPDATE');
                                                    }
                                                }

                                                $slm->action('DELETE');
                                                $slm->save($connection);
                                                $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP',
                                                                   'STATUS_DELETE' );
                                            }
                                            else {
                                                dlog('This lpar has not been processed before');

                                                $slm->action('DELETE');
                                                $slm->save($connection);
                                                $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP',
                                                                   'STATUS_DELETE' );

                                                $slm->softwareLpar->action('SAVEDELETE');

                                                $lpar{$key} = $slm->softwareLpar;
                                            }
                                        }
                                    }
                                    else {
                                        dlog('ScanRecord customerId does not equal SoftwareLpar customerId');

                                        if ( exists $lpar{$key} ) {
                                            dlog('This lpar has been processed before');

                                            $lpar{$key}->id( $slm->softwareLpar->id );

                                            if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                                dlog('The processed lpar is in savedelete');
                                            }
                                            else {
                                                dlog('The processed lpar is not in savedelete');

                                                if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                    dlog('Processed lpar equals db lpar');

                                                    $lpar{$key}->action('COMPLETE');
                                                }
                                                else {
                                                    dlog('Processed lpar does not equal db lpar');

                                                    $lpar{$key}->action('SAVEUPDATE');
                                                }
                                            }

                                            $slm->action('DELETE');
                                            $slm->save($connection);
                                            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                        }
                                        else {
                                            dlog('This lpar has not been processed before');

                                            $slm->action('DELETE');
                                            $slm->save($connection);
                                            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );

                                            $slm->softwareLpar->action('SAVEDELETE');

                                            $lpar{$key} = $slm->softwareLpar;
                                        }
                                    }
                                }
                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=U,SL=C,SLM=D');

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                        dlog('The processed lpar is in savedelete');
                                    }
                                    else {
                                        dlog('The processed lpar is not in savedelete');

                                        if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                            dlog('Processed lpar equals db lpar');

                                            $lpar{$key}->action('COMPLETE');
                                        }
                                        else {
                                            dlog('Processed lpar does not equal db lpar');

                                            $lpar{$key}->action('SAVEUPDATE');
                                        }
                                    }
                                }
                                else {
                                    dlog('This lpar has not been processed before');

                                    $slm->softwareLpar->action('SAVEDELETE');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            } 
                        } #NOTE end of invalid software_lpar_map block #2
                        elsif ( $oldSl->action eq 'DELETE' ) { #NOTE start of invalid software_lpar_map block #3
                            dlog('SoftwareLpar is marked as delete');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=U,SL=D,SLM=C');

                                ###This is an odd situation, I don't think it should happen, but we can still handle it to clean up

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;
                                dlog("key=$key");

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    $lpar{$key}->action('DELETE');

                                    $slm->action('DELETE');
                                    $slm->save($connection);
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                }
                                else {
                                    $lpar{$key} = $slm->softwareLpar;
                                    $slm->action('DELETE');
                                    $slm->save($connection);
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                }

                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=U,SL=D,SLM=D');

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;
                                dlog("key=$key");

                                ###Another odd situation

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    $lpar{$key}->action('DELETE');
                                }
                                else {
                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE end of invalid software_lpar_map block #3
                        else {
                            elog('SoftwareLpar is invalid');
                            die 'SoftwareLpar is invalid';
                        }
                    }
                    elsif ( $sr->action eq 'COMPLETE' ) {
                        dlog('ScanRecord is marked as complete');

                        if ( $oldSl->action eq 'UPDATE' ) { #NOTE start of invalid software_lpar_map block #4
                            dlog('SoftwareLpar is marked as update');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=C,SL=U,SLM=C');

                                ###SoftwareLpar is in update, we don't want to touch anything
                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );
                                    $lpar{$key}->action('UPDATE');
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR', 'STATUS_UPDATE' );
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=C,SL=U,SLM=D');

                                ###SoftwareLpar is in update, we don't want to touch anything
                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );
                                    $lpar{$key}->action('UPDATE');
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE: end of invalid software_lpar_map block #4
                        elsif ( $oldSl->action eq 'COMPLETE' ) { #NOTE start of invalid software_lpar_map block #5
                            dlog('SoftwareLpar is marked as complete');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=C,SL=C,SLM=C');

                                my $customerId = $self->getCustomerId($sr);
                                dlog("customerId=$customerId");

                                if ( $customerId =~ m/\D/ ) {
                                    dlog('ScanRecord does not map to a customerId');

                                    my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                    if ( exists $lpar{$key} ) {
                                        dlog('This lpar has been processed before');

                                        $lpar{$key}->id( $slm->softwareLpar->id );

                                        if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                            dlog('The processed lpar is in savedelete');
                                        }
                                        else {
                                            dlog('The processed lpar is not in savedelete');

                                            if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                dlog('Processed lpar equals db lpar');

                                                $lpar{$key}->action('COMPLETE');
                                            }
                                            else {
                                                dlog('Processed lpar does not equal db lpar');

                                                $lpar{$key}->action('SAVEUPDATE');
                                            }
                                        }

                                        $slm->action('DELETE');
                                        $slm->save($connection);
                                        $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                    }
                                    else {
                                        dlog('This lpar has not been processed');

                                        $slm->action('DELETE');
                                        $slm->save($connection);
                                        $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );

                                        $slm->softwareLpar->action('SAVEDELETE');

                                        $lpar{$key} = $slm->softwareLpar;
                                    }
                                }
                                else {
                                    dlog('ScanRecord maps to a customerId');

                                    my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;
                                    dlog("key=$key");

                                    $newSl->customerId($customerId);

                                    if ( $newSl->customerId eq $slm->softwareLpar->customerId ) {
                                        dlog('ScanRecord customerId equals SoftwareLpar customerId');

                                        if ( $newSl->name eq $slm->softwareLpar->name ) {
                                            dlog('ScanRecord name equals SoftwareLpar name');

                                            if ( $newSl->equals( $slm->softwareLpar ) ) {
                                                dlog('ScanRecord equals SoftwareLpar');

                                                if ( exists $lpar{$key} ) {
                                                    dlog('This lpar has been processed before');

                                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                                    if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                        dlog('Processed lpar equals db lpar');

                                                        $lpar{$key}->action('COMPLETE');
                                                    }
                                                    else {
                                                        dlog('Processed lpar does not equal db lpar');

                                                        $lpar{$key}->action('SAVEUPDATE');
                                                    }
                                                }
                                                else {
                                                    dlog('This lpar has not been processed before');

                                                    $lpar{$key} = $slm->softwareLpar;
                                                }
                                            }
                                            else {
                                                dlog('ScanRecord does not equal SoftwareLpar');

                                                if ( exists $lpar{$key} ) {
                                                    dlog('This lpar has been processed before');

                                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                                    if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                        dlog('Processed lpar equals db lpar');

                                                        $lpar{$key}->action('COMPLETE');
                                                    }
                                                    else {
                                                        dlog('Processed lpar does not equal db lpar');

                                                        $lpar{$key}->action('SAVEUPDATE');
                                                    }
                                                }
                                                else {
                                                    dlog('This lpar has not been processed before');

                                                    $newSl->action('SAVEUPDATE');

                                                    $lpar{$key} = $newSl;
                                                    $slm->softwareLpar( $lpar{$key} );
                                                }
                                            }
                                        }
                                        else {
                                            dlog('ScanRecord name does not equal softwareLpar name');
                                            ###So, this scan record no longer maps to the old lpar, it is a new lpar( to itself)
                                            ###We need to delete the mapping and delete the lpar much like we do for the savedeletes
                                            ###But we want to leave the scanrecord in update status

                                            if ( exists $lpar{$key} ) {
                                                dlog('This lpar has been processed before');

                                                $lpar{$key}->id( $slm->softwareLpar->id );

                                                if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                                    dlog('The processed lpar is in savedelete');
                                                }
                                                else {
                                                    dlog('The processed lpar is not in savedelete');

                                                    if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                        dlog('Processed lpar equals db lpar');

                                                        $lpar{$key}->action('COMPLETE');
                                                    }
                                                    else {
                                                        dlog('Processed lpar does not equal db lpar');

                                                        $lpar{$key}->action('SAVEUPDATE');
                                                    }
                                                }

                                                $slm->action('DELETE');
                                                $slm->save($connection);
                                                $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP',
                                                                   'STATUS_DELETE' );
                                            }
                                            else {
                                                dlog('This lpar has not been processed before');

                                                $slm->action('DELETE');
                                                $slm->save($connection);
                                                $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP',
                                                                   'STATUS_DELETE' );

                                                $slm->softwareLpar->action('SAVEDELETE');

                                                $lpar{$key} = $slm->softwareLpar;
                                            }
                                        }
                                    }
                                    else {
                                        dlog('ScanRecord customerId does not equal SoftwareLpar customerId');

                                        if ( exists $lpar{$key} ) {
                                            dlog('This lpar has been processed before');

                                            $lpar{$key}->id( $slm->softwareLpar->id );

                                            if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                                dlog('The processed lpar is in savedelete');
                                            }
                                            else {
                                                dlog('The processed lpar is not in savedelete');

                                                if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                                    dlog('Processed lpar equals db lpar');

                                                    $lpar{$key}->action('COMPLETE');
                                                }
                                                else {
                                                    dlog('Processed lpar does not equal db lpar');

                                                    $lpar{$key}->action('SAVEUPDATE');
                                                }
                                            }

                                            $slm->action('DELETE');
                                            $slm->save($connection);
                                            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                        }
                                        else {
                                            dlog('This lpar has not been processed before');

                                            $slm->action('DELETE');
                                            $slm->save($connection);
                                            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );

                                            $slm->softwareLpar->action('SAVEDELETE');

                                            $lpar{$key} = $slm->softwareLpar;
                                        }
                                    }
                                }
                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=C,SL=C,SLM=D');

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                        dlog('The processed lpar is in savedelete');
                                    }
                                    else {
                                        dlog('The processed lpar is not in savedelete');

                                        if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                            dlog('Processed lpar equals db lpar');

                                            $lpar{$key}->action('COMPLETE');
                                        }
                                        else {
                                            dlog('Processed lpar does not equal db lpar');

                                            $lpar{$key}->action('SAVEUPDATE');
                                        }
                                    }
                                }
                                else {
                                    dlog('This lpar has not been processed before');

                                    $slm->softwareLpar->action('SAVEDELETE');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE: end of invalid software_lpar_map block #5
                        elsif ( $oldSl->action eq 'DELETE' ) { #NOTE: start of invalid software_lpar_map block #6
                            dlog('SoftwareLpar is marked as delete');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=C,SL=D,SLM=C');

                                ###This is an odd situation, I don't think it should happen, but we can still handle it to clean up

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;
                                dlog("key=$key");

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    $lpar{$key}->action('DELETE');

                                    $slm->action('DELETE');
                                    $slm->save($connection);
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                }
                                else {
                                    $lpar{$key} = $slm->softwareLpar;
                                }

                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=C,SL=D,SLM=D');

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    $lpar{$key}->action('DELETE');
                                }
                                else {
                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE: end of invalid software_lpar map block #6
                        else {
                            elog('SoftwareLpar is invalid');
                            die 'SoftwareLpar is invalid';
                        }
                    }
                    elsif ( $sr->action eq 'DELETE' ) {
                        dlog('ScanRecord is marked as delete');

                        if ( $oldSl->action eq 'UPDATE' ) { #NOTE start of invalid software_lpar map #7
                            dlog('SoftwareLpar is marked as update');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=D,SL=U,SLM=C');

                                ###I just need to set the map to delete

                                ###SoftwareLpar is in update, we don't want to touch anything else
                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );
                                    $lpar{$key}->action('UPDATE');
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $lpar{$key} = $slm->softwareLpar;
                                }

                                $slm->action('DELETE');
                                $slm->save($connection);
                                $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=D,SL=U,SLM=D');

                                ###SoftwareLpar is in update, we don't want to touch anything
                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );
                                    $lpar{$key}->action('UPDATE');
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE end of invalid software_lpar map #7
                        elsif ( $oldSl->action eq 'COMPLETE' ) { #NOTE start of invalid software_lpar map #8
                            dlog('SoftwareLpar is marked as complete');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=D,SL=C,SLM=C');

                                my $customerId = $self->getCustomerId($sr);
                                dlog("customerId=$customerId");

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                        dlog('The processed lpar is in savedelete');
                                    }
                                    else {
                                        dlog('The processed lpar is not in savedelete');

                                        if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                            dlog('Processed lpar equals db lpar');

                                            $lpar{$key}->action('COMPLETE');
                                        }
                                        else {
                                            dlog('Processed lpar does not equal db lpar');

                                            $lpar{$key}->action('SAVEUPDATE');
                                        }
                                    }

                                    $slm->action('DELETE');
                                    $slm->save($connection);
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                }
                                else {
                                    dlog('This lpar has not been processed');

                                    $slm->action('DELETE');
                                    $slm->save($connection);
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );

                                    $slm->softwareLpar->action('SAVEDELETE');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=D,SL=C,SLM=D');

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                        dlog('The processed lpar is in savedelete');
                                    }
                                    else {
                                        dlog('The processed lpar is not in savedelete');

                                        if ( $lpar{$key}->equals( $slm->softwareLpar ) ) {
                                            dlog('Processed lpar equals db lpar');

                                            $lpar{$key}->action('COMPLETE');
                                        }
                                        else {
                                            dlog('Processed lpar does not equal db lpar');

                                            $lpar{$key}->action('SAVEUPDATE');
                                        }
                                    }
                                }
                                else {
                                    dlog('This lpar has not been processed before');

                                    $slm->softwareLpar->action('SAVEDELETE');

                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE: end of invalid software_lpar_map #8
                        elsif ( $oldSl->action eq 'DELETE' ) { #NOTE start of invalid software_lpar_map #9
                            dlog('SoftwareLpar is marked as delete');

                            if ( $slm->action eq 'COMPLETE' ) {
                                dlog('SoftwareLparMap is marked as complete');
                                dlog('SR=D,SL=D,SLM=C');

                                ###This is an odd situation, I don't think it should happen, but we can still handle it to clean up

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;
                                dlog("key=$key");

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    $lpar{$key}->action('DELETE');

                                    $slm->action('DELETE');
                                    $slm->save($connection);
                                    $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
                                }
                                else {
                                    $lpar{$key} = $slm->softwareLpar;
                                }

                            }
                            elsif ( $slm->action eq 'DELETE' ) {
                                dlog('SoftwareLparMap is marked as delete');
                                dlog('SR=D,SL=D,SLM=D');

                                my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                                if ( exists $lpar{$key} ) {
                                    dlog('This lpar has been processed before');

                                    $lpar{$key}->id( $slm->softwareLpar->id );

                                    $lpar{$key}->action('DELETE');
                                }
                                else {
                                    $lpar{$key} = $slm->softwareLpar;
                                }
                            }
                            else {
                                elog('SoftwareLparMap is invalid');
                                die 'SoftwareLparMap is invalid';
                            }
                        } #NOTE end of software_lpar_map is invalid block #9
                        else {
                            elog('SoftwareLpar is invalid');
                            die 'SoftwareLpar is invalid';
                        }
                    }
                    else {
                        elog('ScanRecord is invalid');
                        die 'SoftwareLpar is invalid';
                    }
                }
                else {
                    elog('SoftwareLparMap is not defined');
                    die 'SoftwareLparMap is not defined';
                }
            }
            else {
                dlog('Software Lpar is not defined');

                if ( defined $slm->id ) {
                    wlog('SoftwareLparMap is defined');
                    wlog( $oldSl->toString );
                    wlog( $newSl->toString );
                    wlog( $slm->toString );
                    wlog( $sr->toString );
                    next;
                }
                else {
                    dlog('SoftwareLparMap is not defined');

                    if ( $sr->action eq 'UPDATE' ) {
                        dlog('ScanRecord is marked as update');
                        dlog('SR=U,SL=N,SLM=N');

                        my $customerId = $self->getCustomerId($sr);
                        dlog("customerId=$customerId");

                        if ( $customerId =~ m/\D/ ) {
                            dlog('ScanRecord does not map to a customerId');

                            dlog('Setting and saving scan record as complete');
                            $sr->action('COMPLETE');
                            $sr->save($connection);
                            $self->incCompleteCntSr();
                        }
                        else {
                            dlog('ScanRecord maps to a customerId');

                            my $key = $sr->name . '|' . $customerId;

                            $slm->action('SAVECOMPLETE');
                            $slm->scanRecord->action('SAVECOMPLETE');

                            if ( exists $lpar{$key} ) {
                                dlog('This has been processed before');

                                if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                    dlog('Changing lpar action to complete from savedelete');
                                    $lpar{$key}->action('COMPLETE');

                                    $slm->softwareLpar( $lpar{$key} );

                                    push @maps, $slm;

                                }
                                elsif ( $lpar{$key}->action eq 'DELETE' ) {
                                    ###Do not want to generate anything new
                                }
                                else {
                                    $slm->softwareLpar( $lpar{$key} );

                                    push @maps, $slm;
                                }
                            }
                            else {
                                dlog('This lpar has not been processed');

                                $newSl->customerId($customerId);
                                $newSl->action('SAVEUPDATE');

                                $lpar{$key} = $newSl;

                                $slm->softwareLpar( $lpar{$key} );

                                push @maps, $slm;
                            }
                        }
                    }
                    elsif ( $sr->action eq 'COMPLETE' ) {
                        dlog('ScanRecord is marked as complete');
                        dlog('SR=C,SL=N,SLM=N');

                        my $customerId = $self->getCustomerId($sr);
                        dlog("customerId=$customerId");

                        if ( $customerId =~ m/\D/ ) {
                            dlog('ScanRecord does not map to a customerId');
                        }
                        else {
                            dlog('ScanRecord maps to a customerId');

                            my $key = $sr->name . '|' . $customerId;

                            $slm->action('SAVECOMPLETE');

                            if ( exists $lpar{$key} ) {
                                dlog('This has been processed before');

                                if ( $lpar{$key}->action eq 'SAVEDELETE' ) {
                                    dlog('Changing lpar action to complete from savedelete');
                                    $lpar{$key}->action('COMPLETE');

                                    $slm->softwareLpar( $lpar{$key} );

                                    push @maps, $slm;

                                }
                                elsif ( $lpar{$key}->action eq 'DELETE' ) {
                                    ###Do not want to generate anything new
                                }
                                else {
                                    $slm->softwareLpar( $lpar{$key} );

                                    push @maps, $slm;
                                }
                            }
                            else {
                                dlog('This lpar has not been processed');

                                $newSl->customerId($customerId);
                                $newSl->action('SAVEUPDATE');

                                $lpar{$key} = $newSl;

                                $slm->softwareLpar( $lpar{$key} );

                                push @maps, $slm;
                            }
                        }
                    }
                    elsif ( $sr->action eq 'DELETE' ) {
                        dlog('ScanRecord is marked as delete');
                        dlog('SR=D,SL=N,SLM=N');

                        $sr->delete($connection);
                        $self->addToCount( 'STAGING', 'SCAN_RECORD', 'DELETE' );
                    }
                    else {
                        elog('ScanRecord is invalid');
                        die 'ScanRecord is invalid';
                    }
                }
            }
        }
        else {
            dlog('ScanRecord is not defined');

            if ( defined $oldSl->id ) {
                dlog('SoftwareLpar is defined');

                if ( defined $slm->id ) { #NOTE simple invalid software_lpar_map test
                    elog("SoftwareLparMap is invalid, $slm->id" );
                    die "SoftwareLparMap is invalid, $slm->id" ;
                } #NOTE simple invalid software_lpar_map ends here
                else {
                    dlog('SoftwareLparMap is not defined');

                    if ( $oldSl->action eq 'UPDATE' ) {
                        dlog('SoftwareLpar is marked as update');
                        dlog('SR=N,SL=U,SLM=N');

                        ###If I am here I have an orphaned softwareLpar
                        ###The record has not been processed by bravo loader
                        ###I do not want to touch it the lpar itself
                        ###But I do want to add mappings later if I can
                        my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                        if ( exists $lpar{$key} ) {
                            dlog('This lpar been processed before');

                            $lpar{$key}->id( $slm->softwareLpar->id );
                            $lpar{$key}->action('UPDATE');
                        }
                        else {
                            dlog('This lpar has not been processed');

                            $lpar{$key} = $slm->softwareLpar;
                        }
                    }
                    elsif ( $oldSl->action eq 'COMPLETE' ) {
                        dlog('SoftwareLpar is marked as complete');
                        dlog('SR=N,SL=C,SLM=N');

                        my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                        if ( exists $lpar{$key} ) {
                            dlog('This lpar has been processed before');

                            ###Set the id in case it has not been set
                            $lpar{$key}->id( $slm->softwareLpar->id );

                            if ( $slm->softwareLpar->equals( $lpar{$key} ) ) {
                                dlog('The processed lpar is equal to db lpar');
                                $lpar{$key}->action('COMPLETE');
                            }
                            else {
                                dlog('The processed lpar is not equal to db lpar');

                                ###We need to tell it to update the record
                                $lpar{$key}->action('SAVEUPDATE');
                            }
                        }
                        else {
                            dlog('This lpar has not been processed');

                            $slm->softwareLpar->action('SAVEDELETE');
                            $lpar{$key} = $slm->softwareLpar;
                        }
                    }
                    elsif ( $oldSl->action eq 'DELETE' ) {
                        dlog('SoftwareLpar is marked as delete');
                        dlog('SR=N,SL=D,SLM=N');

                        my $key = $slm->softwareLpar->name . '|' . $slm->softwareLpar->customerId;

                        if ( exists $lpar{$key} ) {
                            dlog('This lpar has been processed before');

                            ###TODO need to make sure in the apply that
                            ###Anything with the lpar in delete, nothing gets saved
                            $lpar{$key}->action('DELETE');
                        }
                        else {
                            dlog('This lpar has not been processed');

                            $lpar{$key} = $slm->softwareLpar;
                        }
                    }
                    else {
                        elog('SoftwareLpar is invalid');
                        die 'SoftwareLpar is invalid';
                    }
                }
            }
            else {
                elog('SoftwareLpar is not defined');
                die 'SoftwareLpar is not defined';
            }
        }
    }
    $sth->finish;

    $self->maps( \@maps );
    $self->lpar( \%lpar );

    dlog('End doDelta method');
}

sub applyDelta {
    my ( $self, $connection ) = @_;

    dlog('Start applyDelta method');
    foreach my $key ( keys %{ $self->lpar } ) {
        dlog("key=$key");

        dlog( $self->lpar->{$key}->toString );

        if ( $self->lpar->{$key}->action eq 'SAVECOMPLETE' ) {
            dlog('lpars saving to complete');
            $self->lpar->{$key}->action('COMPLETE');
            $self->lpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR', 'STATUS_COMPLETE' );
        }
        elsif ( $self->lpar->{$key}->action eq 'SAVEDELETE' ) {
            dlog('lpars saving to delete');
            $self->lpar->{$key}->status('INACTIVE');
            $self->lpar->{$key}->action('DELETE');
            $self->lpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR', 'STATUS_DELETE' );
        }
        elsif ( $self->lpar->{$key}->action eq 'SAVEUPDATE' ) {
            dlog('lpars saving to update');
            $self->lpar->{$key}->action('UPDATE');
            $self->lpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR', 'STATUS_UPDATE' );
        }
    }

    foreach my $slm ( @{ $self->maps } ) {

        if ( $slm->softwareLpar->action eq 'DELETE' ) {
            dlog( $slm->toString );
            dlog( $slm->softwareLpar->toString );
            dlog( $slm->scanRecord->toString );

            dlog('Skipping save as softwareLpar is delete');

            next;
        }

        if ( $slm->softwareLpar->action eq 'SAVECOMPLETE' ) {
            dlog('Saving slm lpar to complete');
            $slm->softwareLpar->action('COMPLETE');
            $slm->softwareLpar->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_COMPLETE' );
        }
        elsif ( $slm->softwareLpar->action eq 'SAVEDELETE' ) {
            dlog('Saving slm lpar to delete');
            $slm->softwareLpar->action('DELETE');
            $slm->softwareLpar->status('INACTIVE');
            $slm->softwareLpar->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
        }
        elsif ( $slm->softwareLpar->action eq 'SAVEUPDATE' ) {
            dlog('Saving slm lpar to update');
            $slm->softwareLpar->action('UPDATE');
            $slm->softwareLpar->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_UPDATE' );
        }

        if ( $slm->scanRecord->action eq 'SAVECOMPLETE' ) {
            dlog('Saving slm sr to complete');
            $slm->scanRecord->action('COMPLETE');
            $slm->scanRecord->save($connection);
            $self->addToCount( 'STAGING', 'SCAN_RECORD', 'STATUS_COMPLETE' );
        }
        elsif ( $slm->scanRecord->action eq 'SAVEDELETE' ) {
            dlog('Saving slm sr to delete');
            $slm->scanRecord->action('DELETE');
            $slm->scanRecord->save($connection);
            $self->addToCount( 'STAGING', 'SCAN_RECORD', 'STATUS_DELETE' );
        }
        elsif ( $slm->scanRecord->action eq 'SAVEUPDATE' ) {
            dlog('Saving slm sr to update');
            $slm->scanRecord->action('UPDATE');
            $slm->scanRecord->save($connection);
            $self->addToCount( 'STAGING', 'SCAN_RECORD', 'STATUS_UPDATE' );
        }

        if ( $slm->action eq 'SAVECOMPLETE' ) {
            dlog('Saving slm to complete');
            $slm->action('COMPLETE');
            $slm->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_COMPLETE' );
        }
        elsif ( $slm->action eq 'SAVEDELETE' ) {
            dlog('Saving slm to delete');
            $slm->action('DELETE');
            $slm->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_DELETE' );
        }
        if ( $slm->action eq 'SAVEUPDATE' ) {
            dlog('Saving slm to update');
            $slm->action('UPDATE');
            $slm->save($connection);
            $self->addToCount( 'STAGING', 'SOFTWARE_LPAR_MAP', 'STATUS_UPDATE' );
        }
    }
    dlog('End applyDelta method');
}

sub updateStats {
    my ( $self, $stagingConnection ) = @_;
    ###SR

}
###TODO make sure everything is caps from source
sub getCustomerId {
    my ( $self, $sr ) = @_;

    dlog("Start getCustomerId method");

    my $acceptFlag = 0;
    if (    $sr->bankAccountId == 180
         || $sr->bankAccountId == 406
         || $sr->bankAccountId == 410
         || $sr->bankAccountId == 5
         || $sr->bankAccountId == 740
         || $sr->bankAccountId == 738 
         || $sr->bankAccountId == 853
         || $sr->bankAccountId == 920
         || $sr->bankAccountId == 1305)
    {
        $acceptFlag = 1;
    }

    if ( $sr->isManual == 1 ) {
        if ( exists $self->customerAcctMap->{ $sr->objectId } ) {
            return $self->customerAcctMap->{ $sr->objectId };
        }

        dlog('NO MATCHING ACCOUNT');
        return 999999;
    }

    my $shortName = ( split( /\./, $sr->name ) )[0];
    $shortName = $sr->name if ( !defined $shortName );
    
    dlog("shortName=$shortName");

    if ( exists $self->hwLparMap->{$shortName} ) {
        my $count           = 0;
        my $exactMatchCount = 0;
        my $customerCount   = 0;
        my $exactId;
        my %customerIds;
        
        # Are we a TADz scan? If so, use LPAR_NAME+SERIAL to match else UNKNOWN account
# This was commented out to take the change out -- until we stop getBankAccountById and use a hash
#    	my $bankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountById($sr->bankAccountId);
    	if ( $self->isTADz($sr->bankAccountId) == 1 ) {
    		my $match4 = 0;
    		dlog("applying TADz HW->SW matching logic for customer_id");
        	foreach my $ref ( @{ $self->hwLparMap->{$shortName} } ) {
            	foreach my $fqhn ( keys %{$ref} ) {
            		my $hwSerial4 = "";
            		my $hwSerial5 = "";
            		if ( defined $ref->{$fqhn}->{'serialNumber'} ) {
            			$hwSerial4 = substr $ref->{$fqhn}->{'serialNumber'}, -4;
            			$hwSerial5 = substr $ref->{$fqhn}->{'serialNumber'}, -5;
            			
            		}
            		if ( defined $sr->serialNumber ) {
            			my $swSerial4 = substr $sr->serialNumber, -4;
            			my $swSerial5 = substr $sr->serialNumber, -5;
            			if ( $hwSerial5 eq $swSerial5 ) {
            				return $ref->{$fqhn}->{'customerId'};
            			}
            			if ( $hwSerial4 eq $swSerial4 ) {
            				$match4 =  $ref->{$fqhn}->{'customerId'};
            			}
            		}
            	}
        	
        	}
        	if ( $match4 > 0 ) {
        		return $match4;
        	}
    		return 999999;
    	} 

        #Loop through all the matches
        foreach my $ref ( @{ $self->hwLparMap->{$shortName} } ) {

            #Loop through the fqhns, there could be 1 short and 1 long
            foreach my $fqhn ( keys %{$ref} ) {

                if ( $acceptFlag == 0 ) {
                    if ( exists $self->inclusionMap->{ $ref->{$fqhn}->{'customerId'} } ) {
                        ### This customer will only accept certain bank accounts

                        if (
                            !defined $self->inclusionMap->{ $ref->{$fqhn}->{'customerId'} }{ $sr->bankAccountId } )
                        {
                            dlog( $sr->bankAccountId . " not defined for " . $ref->{$fqhn}->{'customerId'} );
                            $count++;
                            next;
                        }
                    }
                }

                #If we match a serial number return it immediately per logic
                if (    ( defined $sr->serialNumber )
                     && ( $ref->{$fqhn}->{'serialNumber'} eq $sr->serialNumber ) )
                {
                    dlog( "ATP serial match: $shortName " . $sr->serialNumber . ", " . $sr->name . ", $fqhn" );

                    return $ref->{$fqhn}->{'customerId'};
                }

                if ( $fqhn eq $sr->name ) {
                    $exactMatchCount++;
                    $exactId = $ref->{$fqhn}->{'customerId'};
                }

                if ( !exists $customerIds{ $ref->{$fqhn}->{'customerId'} } ) {
                    $customerIds{ $ref->{$fqhn}->{'customerId'} } = 0;
                    $customerCount++;
                }

                $count++;
            }
        }

        #If we get here, we know a serial didn't match
        #If our count is equal to 1, then we know we have a fuzzy unique match
        dlog("count=$count");
        if ( $count == 1 ) {
            my $ref = @{ $self->hwLparMap->{$shortName} }[0];

            foreach my $fqhn ( keys %{$ref} ) {
                if ( $acceptFlag == 0 ) {
                    if ( exists $self->inclusionMap->{ $ref->{$fqhn}->{'customerId'} } ) {
                        ### This customer will only accept certain bank accounts

                        if (
                            !defined $self->inclusionMap->{ $ref->{$fqhn}->{'customerId'} }{ $sr->bankAccountId } )
                        {
                            dlog( $sr->bankAccountId . " not defined for " . $ref->{$fqhn}->{'customerId'} );
                            next;
                        }
                    }
                }

                dlog("ATP Fuzzy match $fqhn");
                return $ref->{$fqhn}->{'customerId'};
            }
        }

        #If we get here, we know we have multiple matches
        dlog("exactMatchCount=$exactMatchCount");
        if ( $exactMatchCount > 0 ) {

            # If there is one exact match
            if ( $exactMatchCount == 1 ) {
                dlog("ATP exact match: $sr->name");
                return $exactId;
            }

            # If we have only one customerId, thats it
            dlog("customerCount=$customerCount");
            if ( $customerCount == 1 ) {
                foreach my $customerId ( keys %customerIds ) {
                    dlog("ATP single customer: $sr->name");
                    return $customerId;
                }
            }

            # if account is swasset, only use if an account matches what is in swasset
            if ( $sr->bankAccountId eq '5' || $sr->bankAccountId eq '410' ) {
                foreach my $customerId ( keys %customerIds ) {
                    if ( exists $self->customerAcctMap->{ $sr->objectId }
                         && $self->customerAcctMap->{ $sr->objectId } eq $customerId )
                    {
                        return $customerId;
                    }
                }

                dlog('MOVE SWASSET SCAN');
                return 999999;
            }

            #Check the mapping file for hostname
            if ( exists $self->nameMap->{ $sr->name } ) {
                foreach my $customerId ( keys %customerIds ) {
                    if ( $self->nameMap->{ $sr->name } eq $customerId ) {
                        dlog("ATP Mapping file match $sr->name");
                        return $customerId;
                    }
                }

                dlog('UPDATE MAPPING FILE');
                return 999999;
            }

            # Use the tme_object_id from cndb
            if ( exists $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] } ) {
                foreach my $customerId ( keys %customerIds ) {
                    if ( $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] } eq $customerId ) {
                        dlog("ATP tme_object_id match $sr->name");
                        return $customerId;
                    }
                }

                dlog('TME_OBJECT_ID MISMATCH');
                return 999999;
            }

            dlog('ADD TME_OBJECT_ID TO CNDB');
            return 999999;
        }
    }

    # if account is swasset, only use if an account matches what is in swasset
    if ( $sr->bankAccountId eq '5' || $sr->bankAccountId eq '410' ) {
        if ( exists $self->customerAcctMap->{ $sr->objectId } ) {
            return $self->customerAcctMap->{ $sr->objectId };
        }

        dlog('NO MATCHING ACCOUNT');
        return 999999;
    }

    if ( exists $self->nameMap->{ $sr->name } ) {
        dlog("Found hostname in mapping $sr->name");

        if ( $acceptFlag == 0 ) {
            if ( exists $self->inclusionMap->{ $self->nameMap->{ $sr->name } } ) {
                ### This customer will only accept certain bank accounts

                if ( defined $self->inclusionMap->{ $self->nameMap->{ $sr->name } }{ $sr->bankAccountId } ) {
                    return $self->nameMap->{ $sr->name };
                }
            }
            else {
                return $self->nameMap->{ $sr->name };
            }
        }
        else {
            return $self->nameMap->{ $sr->name };
        }
    }

    if ( defined $sr->objectId && $sr->objectId ne '' ) {
        if ( exists $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] } ) {

            if ( $acceptFlag == 0 ) {
                if (
                     exists
                     $self->inclusionMap->{ $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] } } )
                {
                    ### This customer will only accept certain bank accounts

                    if (
                         defined
                         $self->inclusionMap->{ $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] } }
                         { $sr->bankAccountId } )
                    {
                        dlog( "Found tme_object_id in cndb" . $sr->name );
                        return $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] };
                    }
                }
                else {
                    return $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] };
                }
            }
            else {
                return $self->objectIdMap->{ ( split( /\./, uc( $sr->objectId ) ) )[0] };
            }
        }
    }

    dlog("End getCustomerId method");

    dlog('ATP NEED UPDATE');
    return 999999;
}

sub maps {
    my ( $self, $value ) = @_;
    $self->{_maps} = $value if defined($value);
    return ( $self->{_maps} );
}

sub lpar {
    my ( $self, $value ) = @_;
    $self->{_lpar} = $value if defined($value);
    return ( $self->{_lpar} );
}

sub hwLparMap {
    my ( $self, $value ) = @_;
    $self->{_hwLparMap} = $value if defined($value);
    return ( $self->{_hwLparMap} );
}

sub isTADz {
	my ( $self, $bankAccountId ) = @_;
	my $tadzFlag = 0;
	foreach my $realTadz ( @{$self->tadzAccountMap} ) {
		if ( $realTadz == $bankAccountId ) {
			$tadzFlag = 1;
			dlog("$realTadz eq $bankAccountId -- I am TADZ");
			return $tadzFlag;
		}
	}
	dlog ("$bankAccountId is not TADZ");
	return $tadzFlag;	
}

sub customerMap {
    my ( $self, $suffix, $prefix, $objectIdMap, $nameMap, $namePrefixMap, $customerAcctMap ) = @_;

    $self->suffix($suffix);
    $self->prefix($prefix);
    $self->objectIdMap($objectIdMap);
    $self->nameMap($nameMap);
    $self->namePrefixMap($namePrefixMap);
    $self->customerAcctMap($customerAcctMap);
}

sub addToCount {
    my ( $self, $db, $object, $action ) = @_;
    my $hash;
    if ( defined $self->count ) {
        $hash = $self->count;
        $hash->{$db}->{$object}->{$action}++;
    }
    else {
        $hash->{$db}->{$object}->{$action} = 1;
    }
    $self->count($hash);
}

sub count {
    my ( $self, $value ) = @_;
    $self->{_count} = $value if defined($value);
    return ( $self->{_count} );
}

sub suffix {
    my ( $self, $value ) = @_;
    $self->{_suffix} = $value if defined($value);
    return ( $self->{_suffix} );
}

sub prefix {
    my ( $self, $value ) = @_;
    $self->{_prefix} = $value if defined($value);
    return ( $self->{_prefix} );
}

sub objectIdMap {
    my ( $self, $value ) = @_;
    $self->{_objectIdMap} = $value if defined($value);
    return ( $self->{_objectIdMap} );
}

sub nameMap {
    my ( $self, $value ) = @_;
    $self->{_nameMap} = $value if defined($value);
    return ( $self->{_nameMap} );
}

sub namePrefixMap {
    my ( $self, $value ) = @_;
    $self->{_namePrefixMap} = $value if defined($value);
    return ( $self->{_namePrefixMap} );
}

sub customerAcctMap {
    my ( $self, $value ) = @_;
    $self->{_customerAcctMap} = $value if defined($value);
    return ( $self->{_customerAcctMap} );
}

sub inclusionMap {
    my ( $self, $value ) = @_;
    $self->{_inclusionMap} = $value if defined($value);
    return ( $self->{_inclusionMap} );
}

sub tadzAccountMap {
    my ( $self, $value ) = @_;
    $self->{_tadzAccountMap} = $value if defined($value);
    return ( $self->{_tadzAccountMap} );
}

sub testMode {
    my ( $self, $value ) = @_;
    $self->{_testMode} = $value if defined($value);
    return ( $self->{_testMode} );
}

sub applyChanges {
    my ( $self, $value ) = @_;
    $self->{_applyChanges} = $value if defined($value);
    return ( $self->{_applyChanges} );
}

sub flag {
    my ( $self, $value ) = @_;
    $self->{_flag} = $value if defined($value);
    return ( $self->{_flag} );
}
1;

