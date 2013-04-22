package Staging::ATPLoader;

use strict;
use Staging::Loader;
use Base::Utils;
use Staging::OM::Hardware;
use Staging::OM::HardwareLpar;
use Staging::OM::HardwareLparEff;
use ATP::Delegate::ATPDelegate;
use Database::Connection;
use Staging::Delegate::StagingDelegate;

our @ISA = qw(Loader);

###Need to check and make sure current stuff has active customerIds, etc
sub new {
    my ( $class, $bankAccountName ) = @_;

    dlog('Building new ATPLoader object');

    my $self = $class->SUPER::new('ATP');

    $self->{_hardware}     = undef;
    $self->{_hardwareLpar} = undef;
    $self->{_effProcessor} = undef;
    $self->{_count}        = ();

    bless $self, $class;

    dlog('ATPLoader object built');

    return $self;
}

sub load {
    my ( $self, %args ) = @_;

    dlog('Start load method');

    my $job = "ATP TO STAGING";

    $self->SUPER::load( \%args, $job );

    ilog('Get the staging connection');
    my $stagingConnection = Database::Connection->new('staging');
    ilog('Got Staging connection');

    my $dieMsg = undef;
    eval {
        ilog('Preparing the source data');
        $self->prepareSourceData($stagingConnection);
        ilog('Source data prepared');

        ilog('Performing the delta');
        $self->doDelta($stagingConnection);
        ilog('Delta complete');

        ilog('Applying deltas');
        $self->applyDeltas($stagingConnection);
        ilog('Deltas applied');
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
    }

    $self->SUPER::endLoad($dieMsg);

    ilog('Disconnecting from staging');
    $stagingConnection->disconnect;
    ilog('Staging disconnected');

    die $dieMsg if defined $dieMsg;

    dlog('Load method complete');
}

sub prepareSourceData {
    my ( $self, $connection ) = @_;

    dlog('Start prepareSourceData method');

    die('Cannot call method directly') if ( !$self->flag );

    ilog('Acquring atp data');
    my $hwDate   = undef;
    my $lparDate = undef;

    #if ( $self->SUPER::loadDeltaOnly == 1 ) {
    ( $hwDate, $lparDate ) = $self->getLastUpdate($connection);
    dlog("hwDate=$hwDate");
    dlog("lparDate=$lparDate");

    #}

    my $atpConnection;
    my $dieMsg = undef;
    eval {
        $atpConnection = Database::Connection->new( $self->SUPER::bankAccount );
        $self->atpData(
                        ATPDelegate->getData(
                                              $atpConnection,              $self->SUPER::testMode,
                                              $self->SUPER::loadDeltaOnly, $hwDate,
                                              $lparDate
                        )
        );
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
    }

    ilog('Disconnecting from bank account');
    $atpConnection->disconnect;
    ilog('Disconnected from bank account');

    die $dieMsg if defined $dieMsg;

    dlog('End prepareSourceData method');
}

sub getLastUpdate {
    my ( $self, $connection ) = @_;

    dlog('Start getLastUpdateTime method');

    die('Cannot call method directly') if ( !$self->flag );

    dlog('Preparing staging hwLastUpdate query');
    $connection->prepareSqlQueryAndFields( Staging::Delegate::StagingDelegate->queryHwLastUpdate() );
    dlog('Staging hwLastUpdate query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{hwLastUpdate};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{hwLastUpdateFields} } );
    dlog('Columns binded');

    ilog('Executing staging hardware last update query');
    $sth->execute();
    $sth->fetchrow_arrayref();
    $sth->finish();
    ilog('Staging hardware last update query complete');

    dlog('End getLastUpdateTime method');

    return ( $rec{hwDate}, $rec{lparDate} );
}

sub doDelta {
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    die('Cannot call method directly') if ( !$self->flag );

    dlog('Preparing staging hardware query');
    $connection->prepareSqlQueryAndFields(
                              Staging::Delegate::StagingDelegate->queryHardwareData( $self->SUPER::testMode, 0 ) );
    dlog('Staging hardware query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{hardwareData};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{hardwareDataFields} } );
    dlog('Columns binded');

    my $hwDelCount     = 0;
    my $hwLparDelCount = 0;
    my $effDelCount    = 0;

    ilog('Executing staging hardware query');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        cleanValues( \%rec );

        ###Get the key
        my $key = $rec{machineTypeId} . '|' . $rec{serial} . '|' . $rec{country};
        dlog("hardware key=$key");

        ###Create and populate a new hardware object
        my $hardware = new Staging::OM::Hardware();
        $hardware->id( $rec{id} );
        $hardware->machineTypeId( $rec{machineTypeId} );
        $hardware->serial( $rec{serial} );
        $hardware->country( $rec{country} );
        $hardware->owner( $rec{owner} );
        $hardware->customerNumber( $rec{customerNumber} );
        $hardware->hardwareStatus( $rec{hardwareStatus} );
        $hardware->status( $rec{status} );
        $hardware->updateDate( $rec{hwDate} );
        $hardware->action( $rec{action} );
        $hardware->customerId( $rec{customerId} );
        $hardware->processorCount( $rec{processorCount} );
        $hardware->model( $rec{model} );
        $hardware->classification( $rec{classification} );
        $hardware->chips( $rec{chips} );
        $hardware->processorType( $rec{processorType} );
        $hardware->serverType( $rec{serverType} );
        $hardware->cpuMIPS( $rec{cpuMIPS} );
        $hardware->cpuMSU( $rec{cpuMSU} );
        dlog( $hardware->toString );

        if ( defined $self->hardware->{$key} ) {
            dlog('hardware exists in atp');

            ###Set the id
            $self->hardware->{$key}->id( $rec{id} );

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                $self->hardware->{$key}->serverType('PRODUCTION')
                    if (    $hardware->serverType eq 'PRODUCTION'
                         && $self->hardware->{$key}->serverType eq 'DEVELOPMENT' );
            }

            if ( !$hardware->equals( $self->hardware->{$key} ) ) {
                dlog('hardware is not equal');
                dlog( $self->hardware->{$key}->toString );

                if ( $hardware->action eq 'COMPLETE' ) {
                    ###Set to update if the hardware is currently complete
                    $self->hardware->{$key}->action('UPDATE');
                }
                elsif ( $hardware->action eq 'ERROR' ) {
                    ###Set to update if the hardware is currently complete
                    $self->hardware->{$key}->action('UPDATE');
                }
                else {
                    ###Set to complete so we don't save
                    $self->hardware->{$key}->action('COMPLETE');
                }
            }
            else {
                if ( $hardware->action eq 'ERROR' ) {
                    $self->hardware->{$key}->action('UPDATE');
                }
                else {
                    dlog('hardware is equal, setting to complete');
                    $self->hardware->{$key}->action('COMPLETE');
                }
            }
        }
        else {
            dlog('Hardware does not exist in atp');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $hardware->action('COMPLETE');
            }
            else {
                if ( $hardware->action eq 'COMPLETE' ) {
                    dlog('Setting hardware to delete');
                    $hardware->action('DELETE');
                    $hwDelCount++;
                }
                elsif ( $hardware->action eq 'ERROR' ) {
                    dlog('Setting hardware to delete');
                    $hardware->action('DELETE');
                    $hwDelCount++;
                }
                else {
                    dlog('Hardware is in update or delete, setting to complete');
                    $hardware->action('COMPLETE');
                }

                $hardware->hardwareStatus('REMOVED');
                $hardware->status('INACTIVE');
            }

            $self->hardware->{$key} = $hardware;
        }

        dlog( $self->hardware->{$key}->toString );

        if ( !defined $rec{lparId} ) {
            dlog('Lpar is not defined, skipping');
            next;
        }

        ###Get the key for this lpar
        my $lparKey = $rec{name} . '|' . $rec{lparCustomerId};
        dlog("hardwarelpar key=$lparKey");

        my $hardwareLpar = new Staging::OM::HardwareLpar();
        $hardwareLpar->id( $rec{lparId} );
        $hardwareLpar->name( $rec{name} );
        $hardwareLpar->customerId( $rec{lparCustomerId} );
        $hardwareLpar->hardwareKey($key);
        $hardwareLpar->hardwareId( $rec{id} );
        $hardwareLpar->status( $rec{hlStatus} );
        $hardwareLpar->lparStatus( $rec{lparStatus} );
        $hardwareLpar->action( $rec{lparAction} );
        $hardwareLpar->updateDate( $rec{lparDate} );
        $hardwareLpar->extId( $rec{extId} );
        $hardwareLpar->techImageId( $rec{techImageId} );
        $hardwareLpar->serverType( $rec{serverType} );
        $hardwareLpar->partMIPS( $rec{partMIPS} );
        $hardwareLpar->partMSU( $rec{partMSU} );

        dlog( $hardwareLpar->toString );

        if ( $self->hardwareLpar->{$lparKey} ) {
            dlog('Hardware lpar exists in atp');

            ###Set the id
            $self->hardwareLpar->{$lparKey}->id( $rec{lparId} );

            if ( !$hardwareLpar->equals( $self->hardwareLpar->{$lparKey} ) ) {
                dlog('Hardware lpars are not equal');
                dlog( $self->hardwareLpar->{$lparKey}->toString );

                if ( $hardwareLpar->action eq 'COMPLETE' ) {
                    ###Set lpar to update if it is complete
                    $self->hardwareLpar->{$lparKey}->action('UPDATE');
                }
                elsif ( $hardwareLpar->action eq 'ERROR' ) {
                    ###Set lpar to update if it is complete
                    $self->hardwareLpar->{$lparKey}->action('UPDATE');
                }
                else {
                    ###set lpar to complete so we don't save
                    $self->hardwareLpar->{$lparKey}->action('COMPLETE');
                }
            }
            else {
                dlog('Lpars are equal');
                $self->hardwareLpar->{$lparKey}->action('COMPLETE');

                if ( $hardwareLpar->action eq 'ERROR' ) {
                    ###Set lpar to update if it is complete
                    $self->hardwareLpar->{$lparKey}->action('UPDATE');
                }
            }
        }
        else {
            dlog('Hardware lpar is no longer in atp');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $hardwareLpar->action('COMPLETE');
            }
            else {
                if ( $hardwareLpar->action eq 'COMPLETE' ) {
                    dlog("Setting hardware lpar to delete");
                    $hardwareLpar->action('DELETE');
                    $hwLparDelCount++;
                }
                elsif ( $hardwareLpar->action eq 'ERROR' ) {
                    dlog('Setting hardware lpar to delete');
                    $hardwareLpar->action('DELETE');
                    $hwLparDelCount++;
                }
                else {
                    dlog('Setting hardware lpar to complete to not save');
                    $hardwareLpar->action('COMPLETE');
                }

                $hardwareLpar->status('INACTIVE');
                $hardwareLpar->lparStatus('INACTIVE') 
                    if  (!defined $rec{lparStatus} || $rec{lparStatus} eq "null" || '' eq $rec{lparStatus});
            }

            $self->hardwareLpar->{$lparKey} = $hardwareLpar;
        }

        dlog( $self->hardwareLpar->{$lparKey}->toString );

        if ( !defined $rec{effId} ) {
            dlog("processor count not defined, skipping");
            next;
        }

        my $effProc = new Staging::OM::HardwareLparEff();
        $effProc->id( $rec{effId} );
        $effProc->processorCount( $rec{effProcessorCount} );
        $effProc->hardwareLparId( $rec{lparId} );
        $effProc->lparKey($lparKey);
        $effProc->status( $rec{effStatus} );
        $effProc->action( $rec{effAction} );
        dlog( $effProc->toString );

        if ( $self->effProcessor->{$lparKey} ) {
            dlog('Processor count exists');

            ###Set the id
            $self->effProcessor->{$lparKey}->id( $rec{effId} );

            if ( !$effProc->equals( $self->effProcessor->{$lparKey} ) ) {
                dlog('Effective processor count not equal');
                dlog( $self->effProcessor->{$lparKey}->toString );

                if ( $effProc->action eq 'COMPLETE' ) {
                    dlog('Setting effective processor count to update');
                    $self->effProcessor->{$lparKey}->action('UPDATE');
                }
                elsif ( $effProc->action eq 'ERROR' ) {
                    dlog('Setting effective processor count to update');
                    $self->effProcessor->{$lparKey}->action('UPDATE');
                }
                else {
                    dlog('Setting processor count to complete to not save');
                    $self->effProcessor->{$lparKey}->action('COMPLETE');
                }
            }
            else {
                dlog('processor count is equal');
                $self->effProcessor->{$lparKey}->action('COMPLETE');

                if ( $effProc->action eq 'ERROR' ) {
                    dlog('Setting effective processor count to update');
                    $self->effProcessor->{$lparKey}->action('UPDATE');
                }
            }
        }
        else {
            dlog('Processor count does not exist in atp');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $effProc->action('COMPLETE');
            }
            else {
                if ( $effProc->action eq 'COMPLETE' ) {
                    $effProc->action('DELETE');
                    $effDelCount++;
                }
                elsif ( $effProc->action eq 'ERROR' ) {
                    $effProc->action('DELETE');
                    $effDelCount++;
                }
                else {
                    $effProc->action('COMPLETE');
                }

                $effProc->status('INACTIVE');
            }

            $self->effProcessor->{$lparKey} = $effProc;
        }

        dlog( $self->effProcessor->{$lparKey}->toString );
    }
    $sth->finish();

    if (    ( $hwDelCount > 5000 )
         || ( $hwLparDelCount > 5000 )
         || ( $effDelCount > 5000 ) )
    {
        elog("hwDelCount=$hwDelCount, $hwLparDelCount=hwLparDelCount, $effDelCount=effDelCount");
        foreach my $key ( keys %{ $self->hardwareLpar } ) {
            elog( $self->hardwareLpar->{$key}->customerId . '|' . $self->hardwareLpar->{$key}->name )
                if $self->hardwareLpar->{$key}->action eq 'DELETE';
        }
        die('Too many deletes');
    }

    dlog('End doDelta method');
}

sub applyDeltas {
    my ( $self, $connection ) = @_;

    dlog('Start applyDeltas method');

    die('Cannot call method directly') if ( !$self->flag );

    my $dieMsg = undef;
    eval {
        ilog('Applying effective processor count deltas');
        $self->applyEffectiveProcessorDeltas($connection);
        ilog('Applied effective processor count deltas');

        ilog('Applying hardware lpar deltas');
        $self->applyHardwareLparDeltas($connection);
        ilog('Applied hardware lpar deltas');

        ilog('Applying hardware deltas');
        $self->applyHardwareDeltas($connection);
        ilog('Applied hardware deltas');
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
    }

    ilog('Applying counts to staging db');
    Staging::Delegate::StagingDelegate->insertCount( $connection, $self->count );
    ilog('Applied counts to staging db');

    die $dieMsg if defined $dieMsg;
    dlog('Stop applyDeltas method');
}

sub applyHardwareDeltas {
    my ( $self, $connection ) = @_;

    dlog('Start applyHardwareDeltas method');

    die('Cannot call method directly') if ( !$self->flag );

    if ( !$self->SUPER::applyChanges ) {
        dlog('Skipping apply per argument');
        return;
    }

    my $count;
    foreach my $key ( keys %{ $self->hardware } ) {
        dlog("Applying key=$key");

        $self->hardware->{$key}->action('UPDATE')
            if ( !defined $self->hardware->{$key}->action );

        if ( $self->hardware->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardware->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE', $self->hardware->{$key}->action );
            $self->hardware->{$key}->action('COMPLETE');
        }
    }

    dlog('End applyHardwareDeltas method');
}

sub applyHardwareLparDeltas {
    my ( $self, $connection ) = @_;

    dlog('Start applyHardwareLparDeltas method');

    die('Cannot call method directly') if ( !$self->flag );

    if ( $self->SUPER::applyChanges == 0 ) {
        dlog('Skipping apply per argument');
        return;
    }

    foreach my $key ( keys %{ $self->hardwareLpar } ) {
        dlog("Applying key=$key");

        $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('UPDATE')
            if ( !defined $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action );

        if ( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE',
                                  $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action );
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('COMPLETE');
        }

        $self->hardwareLpar->{$key}->action('UPDATE')
            if ( !defined $self->hardwareLpar->{$key}->action );

        if ( $self->hardwareLpar->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardwareLpar->{$key}
                ->hardwareId( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->id );
            $self->hardwareLpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE_LPAR', $self->hardwareLpar->{$key}->action );
            $self->hardwareLpar->{$key}->action('COMPLETE');
        }
    }

    dlog('End applyHardwareLparDeltas method');
}

sub applyEffectiveProcessorDeltas {
    my ( $self, $connection ) = @_;

    if ( $self->SUPER::applyChanges == 0 ) {
        dlog('Skipping apply per argument');
        return;
    }

    foreach my $key ( keys %{ $self->effProcessor } ) {
        dlog("Applying key=$key");

        $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('UPDATE')
            if ( !defined $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action );

        if ( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE',
                                  $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action );
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('COMPLETE');
        }

        $self->hardwareLpar->{$key}->action('UPDATE')
            if ( !defined $self->hardwareLpar->{$key}->action );

        if ( $self->hardwareLpar->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardwareLpar->{$key}
                ->hardwareId( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->id );
            $self->hardwareLpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE_LPAR', $self->hardwareLpar->{$key}->action );
            $self->hardwareLpar->{$key}->action('COMPLETE');
        }

        $self->effProcessor->{$key}->action('UPDATE')
            if ( !defined $self->effProcessor->{$key}->action );

        if ( $self->effProcessor->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->effProcessor->{$key}->hardwareLparId( $self->hardwareLpar->{$key}->id );
            $self->effProcessor->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'EFFECTIVE_PROCESSOR', $self->effProcessor->{$key}->action );
            $self->effProcessor->{$key}->action('COMPLETE');
        }
    }
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

sub atpData {
    my ( $self, $hardware, $lpar, $processor ) = @_;

    $self->hardware($hardware);
    $self->hardwareLpar($lpar);
    $self->effProcessor($processor);
}

sub hardware {
    my ( $self, $value ) = @_;
    $self->{_hardware} = $value if defined($value);
    return ( $self->{_hardware} );
}

sub hardwareLpar {
    my ( $self, $value ) = @_;
    $self->{_hardwareLpar} = $value if defined($value);
    return ( $self->{_hardwareLpar} );
}

sub effProcessor {
    my ( $self, $value ) = @_;
    $self->{_effProcessor} = $value if defined($value);
    return ( $self->{_effProcessor} );
}

1;

