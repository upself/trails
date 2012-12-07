package Staging::ScanRecordLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::Delegate::ScanRecordDelegate;
use Staging::OM::ScanRecord;
use Scan::Delegate::ComputerDelegate;
use Staging::Delegate::StagingDelegate;

our @ISA = qw(Loader);

sub new {
    my ( $class, $bankAccountName ) = @_;

    dlog('Building new ScanRecordLoader object');

    my $self = $class->SUPER::new($bankAccountName);

    $self->{_list} = undef;

    bless $self, $class;

    dlog( 'ScanRecordLoader instantiated for ' . $bankAccountName );

    return $self;
}

sub load {
    my ( $self, %args ) = @_;

    dlog('Start load method');

    my $job = $self->SUPER::bankAccountName . " TO SCAN RECORD";

    $self->SUPER::load( \%args, $job );

    ilog('Get the staging connection');
    my $stagingConnection = Database::Connection->new('staging');
    ilog('Got Staging connection');

    my $connection;
    eval {
        if ( $self->SUPER::bankAccount->connectionType eq 'CONNECTED' )
        {
            $connection = Database::Connection->new( $self->SUPER::bankAccount );
        }
    };
    if ($@) {
        wlog($@);
        $self->SUPER::endLoad($@);
        return;
    }

    my $dieMsg = undef;
    eval {
        ilog('Preparing the source data');
        $self->prepareSourceData($connection);
        ilog('Source data prepared');

        ilog('Performing the delta');
        $self->doDelta($stagingConnection);
        ilog('Delta complete');

        eval {
            ilog('Applying deltas');
            $self->applyDelta($stagingConnection);
            ilog('Deltas applied');
        };
        if ($@) {
            $dieMsg = $@;
        }
        my $hash;
        $hash->{'STAGING'}->{'SCAN_RECORD'}->{'UPDATE'} = $self->SUPER::updateCnt;
        $hash->{'STAGING'}->{'SCAN_RECORD'}->{'DELETE'} = $self->SUPER::deleteCnt;
        Staging::Delegate::StagingDelegate->insertCount( $stagingConnection, $hash );
        die $dieMsg if defined $dieMsg;
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
    }

    $self->SUPER::endLoad($dieMsg);

    if ( $self->SUPER::bankAccount->connectionType eq 'CONNECTED' ) {
        ilog('Disconnecting from bank account');
        $connection->disconnect
            if ( defined $connection );
        ilog('Disconnected from bank account');
    }

    ilog('Disconnecting from staging');
    $stagingConnection->disconnect;
    ilog('Staging disconnected');

    die $dieMsg if defined $dieMsg;

    dlog('Load method complete');
}

sub prepareSourceData {
    my ( $self, $connection ) = @_;

    dlog('Start prepareSourceData method');

    die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

    eval {
        $self->list(
            ComputerDelegate->getScanRecordData(
                $connection, $self->SUPER::bankAccount, $self->SUPER::loadDeltaOnly
            )
        );
    };
    if ($@) {
        wlog($@);
        die $@;
    }

    $self->SUPER::totalCnt( scalar keys %{ $self->list } );
    dlog('End prepareSourceData method');
}

sub doDelta {
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

    if ( !defined $self->list ) {
        wlog('scanlist is not defined');
        return;
    }

    if ( scalar keys %{ $self->list } == 0 ) {
        wlog('scanlist is zero');
        return;
    }

    dlog('Preparing our staging query');
    $connection->prepareSqlQueryAndFields( Staging::Delegate::StagingDelegate->queryScanRecordData() );
    dlog('Staging query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{scanRecordData};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{scanRecordDataFields} } );
    dlog('Columns binded');

    ilog('Executing staging scan record query');
    $sth->execute( $self->SUPER::bankAccount->id );
    while ( $sth->fetchrow_arrayref ) {

        $self->SUPER::incrTotalCnt();

        my $key = $rec{computerId};
        dlog("key=$key");

        if ( $rec{action} eq 'DELETE' ) {
            delete $self->list->{$key};
            next;
        }

        cleanValues( \%rec );

        my $scanRecord = new Staging::OM::ScanRecord();
        $scanRecord->id( $rec{id} );
        $scanRecord->computerId( $rec{computerId} );
        $scanRecord->name( $rec{name} );
        $scanRecord->objectId( $rec{objectId} );
        $scanRecord->model( $rec{model} );
        $scanRecord->serialNumber( $rec{serialNumber} );
        $scanRecord->scanTime( $rec{scanTime} );
        $scanRecord->osName( $rec{osName} );
        $scanRecord->osType( $rec{osType} );
        $scanRecord->osMajor( $rec{osMajor} );
        $scanRecord->osMinor( $rec{osMinor} );
        $scanRecord->osSub( $rec{osSub} );
        $scanRecord->osType( $rec{osType} );
        $scanRecord->userName( $rec{userName} );
        $scanRecord->biosManufacturer( $rec{manufacturer} );
        $scanRecord->biosModel( $rec{biosModel} );
        $scanRecord->serverType( $rec{serverType} );
        $scanRecord->techImgId( $rec{techImgId} );
        $scanRecord->extId( $rec{extId} );
        $scanRecord->memory( $rec{memory} );
        $scanRecord->disk( $rec{disk} );
        $scanRecord->dedicatedProcessors( $rec{dedicatedProcessors} );
        $scanRecord->totalProcessors( $rec{totalProcessors} );
        $scanRecord->sharedProcessors( $rec{sharedProcessors} );
        $scanRecord->processorType( $rec{processorType} );
        $scanRecord->sharedProcByCores( $rec{sharedProcByCores} );
        $scanRecord->dedicatedProcByCores( $rec{dedicatedProcByCores} );
        $scanRecord->totalProcByCores( $rec{totalProcByCores} );
        $scanRecord->alias( $rec{alias} );
        $scanRecord->physicalTotalKb( $rec{physicalTotalKb} );
        $scanRecord->virtualMemory( $rec{virtualMemory} );
        $scanRecord->physicalFreeMemory( $rec{physicalFreeMemory} );
        $scanRecord->virtualFreeMemory( $rec{virtualFreeMemory} );
        $scanRecord->nodeCapacity( $rec{nodeCapacity} );
        $scanRecord->lparCapacity( $rec{lparCapacity} );
        $scanRecord->biosDate( $rec{biosDate} );
        $scanRecord->biosSerialNumber( $rec{biosSerialNumber} );
        $scanRecord->biosUniqueId( $rec{biosUniqueId} );
        $scanRecord->boardSerial( $rec{boardSerial} );
        $scanRecord->caseSerial( $rec{caseSerial} );
        $scanRecord->caseAssetTag( $rec{caseAssetTag} );
        $scanRecord->powerOnPassword( $rec{powerOnPassword} );
        $scanRecord->processorCount( $rec{processorCount} );
        $scanRecord->users( $rec{users} );
        $scanRecord->authenticated( $rec{authenticated} );
        $scanRecord->bankAccountId( $self->SUPER::bankAccount->id );
        $scanRecord->isManual( $rec{isManual} );
        $scanRecord->action( $rec{action} );
        dlog( $scanRecord->toString );

        if ( defined $self->list->{$key} ) {
            dlog('Scan exists in bank account');

            my $stagingTs = $rec{scanTime};
            $stagingTs =~ s/\D//g;
            $stagingTs =~ s/\s+//g;

            my $stagingBTs = $rec{biosDate};
            $stagingBTs =~ s/\D//g;
            $stagingBTs =~ s/\s+//g;

            $scanRecord->scanTime($stagingTs);
            $scanRecord->biosDate($stagingBTs);

            my $sourceTs  = $self->list->{$key}->scanTime;
            my $oSourceTs = $self->list->{$key}->scanTime;

            my $sourceBTs  = $self->list->{$key}->biosDate;
            my $oSourceBTs = $self->list->{$key}->biosDate;

            $sourceTs =~ s/\D//g;
            $sourceTs =~ s/\s+//g;

            $sourceBTs =~ s/\D//g;
            $sourceBTs =~ s/\s+//g;

            $self->list->{$key}->scanTime($sourceTs);
            $self->list->{$key}->biosDate($sourceBTs);

            ###Set the id
            $self->list->{$key}->id( $rec{id} );
            $self->list->{$key}->action('COMPLETE');

            if ( !$scanRecord->equals( $self->list->{$key} ) ) {
                ilog('Record is not equal');
                ilog($scanRecord->toString);
                ilog($self->list->{$key}->toString);

                if ( $scanRecord->action eq 'COMPLETE' ) {
                    ###Set to update if it is currently complete
                    $self->list->{$key}->action('UPDATE');
                }
                else {
                    ###Set to complete so we don't save
                    $self->list->{$key}->action('COMPLETE');
                }
            }
            else {
                dlog('Record is equal, setting to complete');
                $self->list->{$key}->action('COMPLETE');
            }

            $self->list->{$key}->scanTime($oSourceTs);
            $self->list->{$key}->biosDate($oSourceBTs);
        }
        else {
            dlog('Record does not exist in bank account');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog('Setting to complete as this is delta only');
                $scanRecord->action('COMPLETE');
            }
            else {
                if ( $scanRecord->action eq 'COMPLETE' ) {
                    dlog('Setting record to delete');
                    $scanRecord->action('DELETE');
                }
                else {
                    dlog('Record is in update or delete, setting to complete');
                    $scanRecord->action('COMPLETE');
                }
            }

            $self->list->{$key} = $scanRecord;
        }

        dlog( $self->list->{$key}->toString );
    }
    $sth->finish;

    dlog('End doDelta method');
}

sub applyDelta {
    my ( $self, $connection ) = @_;

    dlog('Start applyDelta method');

    die('Cannot call method directly') if ( !$self->flag );

    ###TODO Need to discuss how to handle
    if ( $self->SUPER::applyChanges == 0 ) {
        dlog('Skipping apply per argument');
        return;
    }

    if ( !defined $self->list ) {
        wlog('scanlist is not defined');
        return;
    }

    if ( scalar keys %{ $self->list } == 0 ) {
        wlog('scanlist is zero');
        return;
    }

    foreach my $key ( keys %{ $self->list } ) {
        if ( !defined $self->list->{$key}->action ) {
            $self->list->{$key}->action('UPDATE');
            $self->SUPER::incrUpdateCnt();
        }
        elsif ( $self->list->{$key}->action eq 'UPDATE' ) {
            $self->SUPER::incrUpdateCnt();
        }
        elsif ( $self->list->{$key}->action eq 'DELETE' ) {
            $self->SUPER::incrDeleteCnt();
        }
        else {
            delete $self->list->{$key};
        }
    }

    ###Check if we have crossed the delete threshold
    if ( $self->SUPER::checkDeleteThreshold() ) {
        die '**** We are deleting more than 15% of total records - Aborting ****';
    }
    else {
        $self->SUPER::updateCnt(0);
        $self->SUPER::deleteCnt(0);
        foreach my $key ( keys %{ $self->list } ) {
            dlog("Applying key=$key");
            $self->list->{$key}->save($connection);
            if ( $self->list->{$key}->action eq 'UPDATE' ) {
                $self->SUPER::incrUpdateCnt();
                dlog($self->SUPER::incrUpdateCnt());
            }
            else {
                $self->SUPER::incrDeleteCnt();
            }
        }
    }

    dlog('End applyDelta method');
}

sub list {
    my ( $self, $value ) = @_;
    $self->{_list} = $value if defined($value);
    return ( $self->{_list} );
}
1;
