package Staging::ATPLoader;

use strict;
use Staging::Loader;
use Base::Utils;
use bignum;
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
	my $stagingConnection;
    my $dieMsg = undef;
    eval {
    	ilog('Get the staging connection');
    	$stagingConnection = Database::Connection->new('staging');
    	ilog('Got Staging connection');

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
                        ATP::Delegate::ATPDelegate->getData(
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
    my $action         = 0;

    ilog('Executing staging hardware query');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        cleanValues( \%rec );

        ###Get the key
        my $key = $rec{machineTypeId} . '|' . $rec{serial} . '|' . $rec{country};
        dlog("hardware key=$key");
        $action = 0;
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
        $hardware->mastProcessorType( $rec{mastProcessorType} );
        $hardware->serverType( $rec{serverType} );
        $hardware->cpuMIPS( $rec{cpuMIPS} );
        $hardware->cpuMSU( $rec{cpuMSU} );
        $hardware->cpuGartnerMIPS( $rec{cpuGartnerMIPS} );
        $hardware->processorManufacturer( $rec{processorManufacturer} );
        $hardware->processorModel( $rec{processorModel} );
        $hardware->nbrCoresPerChip( $rec{nbrCoresPerChip} );
        $hardware->nbrOfChipsMax( $rec{nbrOfChipsMax} );
        $hardware->shared( $rec{shared} );
        $hardware->sharedProcessor( $rec{sharedProcessor} );
        $hardware->cloudName( $rec{cloudName} );
        $hardware->chassisId( $rec{chassisId} );
        $hardware->cpuIFL($rec{cpuIFL});
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
                
                    $action = 10 + $action if ( $hardware->status ne $self->hardware->{$key}->status );
                	$action = 10**2 + $action if ( $hardware->hardwareStatus ne $self->hardware->{$key}->hardwareStatus );
                	$action = 10**3 + $action if ( $hardware->processorCount ne $self->hardware->{$key}->processorCount );
                	$action = 10**4 + $action if ( $hardware->chips ne $self->hardware->{$key}->chips );
                	$action = 10**5 + $action if ( $hardware->model ne $self->hardware->{$key}->model );
                	$action = 10**6 + $action if ( $hardware->mastProcessorType ne $self->hardware->{$key}->mastProcessorType );
                	$action = 10**7 + $action if ( $hardware->processorType ne $self->hardware->{$key}->processorType );
                	$action = 10**8 + $action if ( $hardware->serverType ne $self->hardware->{$key}->serverType );
                	$action = 10**9 + $action if ( $hardware->owner ne $self->hardware->{$key}->owner );
                	$action = 10**10 + $action if ( $hardware->cpuMIPS ne $self->hardware->{$key}->cpuMIPS );
                	$action = 10**11 + $action if ( $hardware->cpuGartnerMIPS ne $self->hardware->{$key}->cpuGartnerMIPS );
                	$action = 10**12 + $action if ( $hardware->cpuMSU ne $self->hardware->{$key}->cpuMSU );
                	$action = 10**13 + $action if ( $hardware->processorManufacturer ne $self->hardware->{$key}->processorManufacturer );
                	$action = 10**14 + $action if ( $hardware->processorModel ne $self->hardware->{$key}->processorModel );
                	$action = 10**15 + $action if ( $hardware->nbrOfChipsMax ne $self->hardware->{$key}->nbrOfChipsMax );
                	$action = 10**16 + $action if ( $hardware->cpuIFL ne $self->hardware->{$key}->cpuIFL );
                dlog('hardware action is ' . $action->bstr() ); 
                if ( $hardware->action eq '0' ) {
                	###Set to update if the hardware is currently complete
                    $action = $action + 1 ;                	
                }
                elsif ( $hardware->action eq '-1' ) {
                    ###Set to update if the hardware is currently complete
                    $action = $action + 1 ;
                }
                else {
                    ###Set to complete so we don't save
                    $action = 0 ;
                }
            }
            else {
                if ( $hardware->action eq '-1' ) {
                	$action = 1 ;
                }
                else {
                    dlog('hardware is equal, setting to complete');
                    $action = 0 ;
                }
            }
            $self->hardware->{$key}->action($action->bstr());
        }
        else {
            dlog('Hardware does not exist in atp');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $action = 0 ;
            }
            else {
                if ( $hardware->action eq '0' ) {
                    dlog('Setting hardware to delete');
                    $action = 2 ;
                    $hwDelCount++;
                }
                elsif ( $hardware->action eq '-1' ) {
                    dlog('Setting hardware to delete');
                    $action = 2 ;
                    $hwDelCount++;
                }
                else {
                    dlog('Hardware is in update or delete, setting to complete');
                    $action = 0 ;
                }

                $hardware->hardwareStatus('REMOVED');
                $hardware->status('INACTIVE');
            }
             $hardware->action($action->bstr());
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
        $hardwareLpar->partGartnerMIPS( $rec{partGartnerMIPS} );
        $hardwareLpar->effectiveThreads( $rec{effectiveThreads} );
        $hardwareLpar->spla( $rec{spla} );
        $hardwareLpar->sysplex( $rec{sysplex} );
        $hardwareLpar->internetIccFlag( $rec{internetIccFlag} );
        $hardwareLpar->backupMethod( $rec{backupMethod} );
        $hardwareLpar->clusterType( $rec{clusterType} );
        $hardwareLpar->vMobilRestrict( $rec{vMobilRestrict} );
        $hardwareLpar->cappedLpar( $rec{cappedLpar} );
        $hardwareLpar->virtualFlag( $rec{virtualFlag} );

        dlog( $hardwareLpar->toString );
        $action = 0 ;
        if ( $self->hardwareLpar->{$lparKey} ) {
            dlog('Hardware lpar exists in atp');

            ###Set the id
            $self->hardwareLpar->{$lparKey}->id( $rec{lparId} );

            if ( !$hardwareLpar->equals( $self->hardwareLpar->{$lparKey} ) ) {
                dlog('Hardware lpars are not equal');
                dlog( $self->hardwareLpar->{$lparKey}->toString );
                     $action = 10 + $action if ( $hardwareLpar->status ne $self->hardwareLpar->{$lparKey}->status ); 
                     $action = 10**2 + $action if ( $hardwareLpar->lparStatus ne $self->hardwareLpar->{$lparKey}->lparStatus ); 
                     $action = 10**3 + $action if ( $hardwareLpar->extId ne $self->hardwareLpar->{$lparKey}->extId ); 
                     $action = 10**4 + $action if ( $hardwareLpar->techImageId ne $self->hardwareLpar->{$lparKey}->techImageId ); 
                     $action = 10**5 + $action if ( $hardwareLpar->partMIPS ne $self->hardwareLpar->{$lparKey}->partMIPS ); 
                     $action = 10**6 + $action if ( $hardwareLpar->partMSU ne $self->hardwareLpar->{$lparKey}->partMSU ); 
                     $action = 10**7 + $action if ( $hardwareLpar->partGartnerMIPS ne $self->hardwareLpar->{$lparKey}->partGartnerMIPS ); 
                     $action = 10**8 + $action if ( $hardwareLpar->serverType ne $self->hardwareLpar->{$lparKey}->serverType );
                     $action = 10**10 + $action if ( $hardwareLpar->effectiveThreads ne $self->hardwareLpar->{$lparKey}->effectiveThreads ); 

                if ( $hardwareLpar->action eq '0' ) {                    	                	           	
                    ###Set lpar to update if it is complete              
                	$action = $action + 1 ;          	
                }
                elsif ( $hardwareLpar->action eq '-1' ) {
                    ###Set lpar to update if it is complete
                    $action = $action + 1 ;
                }
                else {
                    ###set lpar to complete so we don't save
                    $action = 0 ;
                }
            }
            else {
                dlog('Lpars are equal');
                $action = 0 ;

                if ( $hardwareLpar->action eq '-1' ) {
                    ###Set lpar to update if it is complete
                    $action = 1 ;
                }
            }
            $self->hardwareLpar->{$lparKey}->action($action->bstr());
        }
        else {
            dlog('Hardware lpar is no longer in atp');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $action = 0 ;
             
            }
            else {
                if ( $hardwareLpar->action eq '0' ) {
                    dlog("Setting hardware lpar to delete");
                    $action = 2 ;
                   
                    $hwLparDelCount++;
                }
                elsif ( $hardwareLpar->action eq '-1' ) {
                    dlog('Setting hardware lpar to delete');
                    $action = 2 ;
                    
                    $hwLparDelCount++;
                }
                else {
                    dlog('Setting hardware lpar to complete to not save');
                    $action = 0 ;
                }

                $hardwareLpar->status('INACTIVE');
            }
            $hardwareLpar->action($action->bstr());
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
        $action = 0;
        if ( $self->effProcessor->{$lparKey} ) {
            dlog('Processor count exists');

            ###Set the id
            $self->effProcessor->{$lparKey}->id( $rec{effId} );

            if ( !$effProc->equals( $self->effProcessor->{$lparKey} ) ) {
                dlog('Effective processor count not equal');
                dlog( $self->effProcessor->{$lparKey}->toString );
                $action = 10**9;
                if ( $effProc->action eq '0' ) {
                    dlog('Setting effective processor count to update');
                    $action = $action + 1 ;
                }
                elsif ( $effProc->action eq '-1' ) {
                    dlog('Setting effective processor count to update');
                    $action = $action + 1;
                }
                else {
                    dlog('Setting processor count to complete to not save');
                    $action = 0 ;
                }
            }
            else {
                dlog('processor count is equal');
                $action = 0 ;

                if ( $effProc->action eq '-1' ) {
                    dlog('Setting effective processor count to update');
                    $action = 1 ;
                }
            }
            $self->effProcessor->{$lparKey}->action($action->bstr());
        }
        else {
            dlog('Processor count does not exist in atp');

            if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $action = 0 ;
            }
            else {
                if ( $effProc->action eq '0' ) {
                	$action = 2 ;
                    $effDelCount++;
                }
                elsif ( $effProc->action eq '-1' ) {
                	$action = 2 ;
                    $effDelCount++;
                }
                else {
                	$action = 0 ;
                }

                $effProc->status('INACTIVE');
            }
            $effProc->action($action->bstr());
            $self->effProcessor->{$lparKey} = $effProc;
        }

        dlog( $self->effProcessor->{$lparKey}->toString );
    }
    $sth->finish();
   
    if (   ( $hwDelCount > 5000 )
		|| ( $hwLparDelCount > 5000 )
		|| ( $effDelCount > 5000 ) )
	{
		elog(
"hwDelCount=$hwDelCount, $hwLparDelCount=hwLparDelCount, $effDelCount=effDelCount"
		);

		# List hardwareLpar if too many deletes
		if ( $hwLparDelCount > 5000 ) {
			foreach my $key ( keys %{ $self->hardwareLpar } ) {
				elog(   $self->hardwareLpar->{$key}->customerId . '|'
					  . $self->hardwareLpar->{$key}->name )
				  if ($self->hardwareLpar->{$key}->action eq 'DELETE' || substr($self->hardwareLpar->{$key}->action,-1) eq '2' );
			}
		}

		if ( $hwDelCount > 5000 ) {

			# List hardware if too many deletes
			foreach my $key ( keys %{ $self->hardware } ) {
				elog(   $self->hardware->{$key}->customerId . '|'
					  . $self->hardware->{$key}->serial )
				  if ($self->hardware->{$key}->action eq 'DELETE' || substr($self->hardware->{$key}->action,-1) eq '2' );
			}
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

        $self->hardware->{$key}->action('3')
            if ( !defined $self->hardware->{$key}->action );

        if ( $self->hardware->{$key}->action eq '0' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardware->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE', substr( $self->hardware->{$key}->action ,-1));
            $self->hardware->{$key}->action('0');
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

        $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('3')
            if ( !defined $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action );

        if ( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action eq '0' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE', substr(
                                  $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action,-1) );
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('0');
        }

        $self->hardwareLpar->{$key}->action('3')
            if ( !defined $self->hardwareLpar->{$key}->action );

        if ( $self->hardwareLpar->{$key}->action eq '0' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardwareLpar->{$key}
                ->hardwareId( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->id );
            $self->hardwareLpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE_LPAR', substr( $self->hardwareLpar->{$key}->action,-1)  );
            $self->hardwareLpar->{$key}->action('0');
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

        $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('3')
            if ( !defined $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action );

        if ( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action eq '0' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE',substr(
                                  $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action,-1) );
            $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->action('0');
        }

        $self->hardwareLpar->{$key}->action('3')
            if ( !defined $self->hardwareLpar->{$key}->action );

        if ( $self->hardwareLpar->{$key}->action eq '0' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->hardwareLpar->{$key}
                ->hardwareId( $self->hardware->{ $self->hardwareLpar->{$key}->hardwareKey }->id );
            $self->hardwareLpar->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'HARDWARE_LPAR', substr(  $self->hardwareLpar->{$key}->action,-1) );
            $self->hardwareLpar->{$key}->action('0');
        }

        $self->effProcessor->{$key}->action('3')
            if ( !defined $self->effProcessor->{$key}->action );

        if ( $self->effProcessor->{$key}->action eq '0' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->effProcessor->{$key}->hardwareLparId( $self->hardwareLpar->{$key}->id );
            $self->effProcessor->{$key}->save($connection);
            $self->addToCount( 'STAGING', 'EFFECTIVE_PROCESSOR', substr(  $self->effProcessor->{$key}->action,-1)  );
            $self->effProcessor->{$key}->action('0');
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

