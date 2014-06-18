package BRAVO::CustomerLoader;

use strict;
use Base::Utils;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::OM::ScheduleF;
use BRAVO::OM::ScheduleFHistory;
use BRAVO::Delegate::BRAVODelegate;
use Sigbank::Delegate::SystemScheduleStatusDelegate;

###Need to check and make sure current stuff has active customerIds, etc
sub new {
    my ($class) = @_;
    my $self = {
        _testMode      => undef,
        _loadDeltaOnly => undef,
        _applyChanges  => undef,
        _list          => undef
    };
    bless $self, $class;
    dlog("instantiated self");

    return $self;
}

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

sub load {
    my ( $self, %args ) = @_;

    dlog('Start load method');

    ###Check and set arguments.
    dlog("checking passed arguments");
    $self->checkArgs( \%args );
    dlog("checked passed arguments");

    my $job = "CUSTOMER REPLICATION";
    dlog("job=$job");

    my $systemScheduleStatus;
    if ( $self->applyChanges == 1 ) {
        ###Notify the scheduler that we are starting
        ilog("starting $job system schedule status");
        $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
        ilog("started $job system schedule status");
    }

    ilog('Get the bravo connection');
    my $bravoConnection = Database::Connection->new('trails');
    ilog('Got bravo connection');

    ilog('Get the cndb connection');
    my $cndbConnection = Database::Connection->new('cndb');
    ilog('Got cndb connection');

    my $dieMsg = undef;
    eval {
        ilog('Preparing the source data');
        $self->prepareSourceData($cndbConnection);
        ilog('Source data prepared');

        ilog('Performing the delta');
        $self->doDelta($bravoConnection);
        ilog('Delta complete');

        ilog('Applying deltas');
        $self->applyDelta($bravoConnection);
        ilog('Deltas applied');
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);

        if ( $self->applyChanges == 1 ) {
            SystemScheduleStatusDelegate->error( $systemScheduleStatus,
                $dieMsg );
        }
    }
    else {
        if ( $self->applyChanges == 1 ) {
            ilog("Stopping $job system schedule status");
            SystemScheduleStatusDelegate->stop($systemScheduleStatus);
            ilog("Stopped $job system schedule status");
        }
    }

    ilog('Disconnecting from staging');
    $bravoConnection->disconnect;
    ilog('Staging disconnected');

    ilog('Disconnecting from bravo');
    $cndbConnection->disconnect;
    ilog('Bravo disconnected');

    die $dieMsg if defined $dieMsg;

    dlog('End load method complete');
}

sub prepareSourceData {
    my ( $self, $connection ) = @_;

    dlog('Start prepareSourceData method');

    ilog('Acquring customer data');

    $self->list( CNDB::Delegate::CNDBDelegate->getCustomerData($connection) );

    dlog('End prepareSourceData method');
}

sub doDelta {
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    dlog('Preparing bravo customer query');
    $connection->prepareSqlQueryAndFields(
        BRAVO::Delegate::BRAVODelegate->queryCustomerData() );
    dlog('bravo customer query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{customerData};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerDataFields} } );
    dlog('Columns binded');

    ilog('Executing bravo customer query');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Get the key
        my $key = $rec{id};
        dlog("customer key=$key");

        ###Create and populate a new customer object
        my $customer = new BRAVO::OM::Customer();
        $customer->id( $rec{id} );
        $customer->customerId( $rec{id} );
        $customer->customerTypeId( $rec{customerTypeId} );
        $customer->podId( $rec{podId} );
        $customer->industryId( $rec{industryId} );
        $customer->accountNumber( $rec{accountNumber} );
        $customer->customerName( $rec{customerName} );
        $customer->contactDpeId( $rec{contactDpeId} );
        $customer->contactFaId( $rec{contactFaId} );
        $customer->contactHwId( $rec{contactHwId} );
        $customer->contactSwId( $rec{contactSwId} );
        $customer->contactFocalAssetId( $rec{contactFocalAssetId} );
        $customer->contractSignDate( $rec{contractSignDate} );
        $customer->assetToolsBillingCode( $rec{assetToolsBillingCode} );
        $customer->status( $rec{status} );
        $customer->hwInterlock( $rec{hwInterlock} );
        $customer->swInterlock( $rec{swInterlock} );
        $customer->invInterlock( $rec{invInterlock} );
        $customer->swLicenseMgmt( $rec{swLicenseMgmt} );
        $customer->swSupport( $rec{swSupport} );
        $customer->hwSupport( $rec{hwSupport} );
        $customer->transitionStatus( $rec{transitionStatus} );
        $customer->countryCodeId( $rec{countryCodeId} );
        $customer->scanValidity( $rec{scanValidity} );
        $customer->swTracking( $rec{swTracking} );
        $customer->swComplianceMgmt( $rec{swComplianceMgmt} );
        $customer->swFinancialResponsibility(
            $rec{swFinancialResponsibility} );
        $customer->swFinancialMgmt( $rec{swFinancialMgmt} );
        $customer->creationDateTime( $rec{creationDateTime} );
        $customer->updateDateTime( $rec{updateDateTime} );

        dlog( $customer->toString );

        if ( defined $self->list->{$key} ) {
            dlog('customer exists in cndb');

            $self->list->{$key}->id( $rec{id} );

            if ( !$customer->equals( $self->list->{$key} ) ) {
                dlog('customer is not equal');
                dlog( $self->list->{$key}->toString );

                if ( defined $self->list->{$key}->swComplianceMgmt ) {
                    if ( defined $customer->swComplianceMgmt ) {
                        if ( $customer->swComplianceMgmt ne
                            $self->list->{$key}->swComplianceMgmt )
                        {
                            $self->list->{$key}->action('RECONUPDATE');
                        }
                    }
                    elsif ( $self->list->{$key}->swComplianceMgmt ne '' ) {
                        $self->list->{$key}->action('RECONUPDATE');
                    }
                }

                $self->list->{$key}->action('UPDATE');
            }
            else {
                dlog('customer is equal, setting to complete');
                $self->list->{$key}->action('COMPLETE');
            }
        }
        else {
            if ( $customer->customerId == 999999 ) {
            	$self->list->{$key} = $customer;
                $self->list->{$key}->action('COMPLETE');
            }
            else {
                elog('customer does not exist in cndb '.$key);

                #die('customer deleted from CNDB');
            }
        }
    }
    $sth->finish();

    dlog('End doDelta method');
}

sub applyDelta {
    my ( $self, $connection ) = @_;

    dlog('Start applyDelta method');

    foreach my $key ( keys %{ $self->list } ) {
        dlog("Applying key=$key");

        $self->list->{$key}->action('UPDATE')
            if ( !defined $self->list->{$key}->action );

        if ( $self->list->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
        }
        else {
            $self->list->{$key}->save($connection)
                if ( $self->applyChanges == 1 );

            if ( $self->list->{$key}->action eq 'RECONUPDATE' ) {               
               my $queue = Recon::Queue->new( $connection, $self->list->{$key} );
               $queue->add;
            }
        }
        if ( $self->list->{$key}->status eq 'INACTIVE' ) {
            dlog("Inactiving ScheduleF items while account Inactive");
            $self->inactiveScheduleF($connection,$self->list->{$key}->customerId);
        }
    }

    dlog('End apply method');
}

sub list {
    my ( $self, $value ) = @_;
    $self->{list} = $value if defined($value);
    return ( $self->{list} );
}

sub inactiveScheduleF {
    my ( $self, $connection, $customerId ) = @_;
    dlog('Start inactiveSheduleF method');
    my @scheduleFIds = 
              BRAVO::Delegate::BRAVODelegate->getScheduleFbyCustomerId($connection, $customerId);
     foreach my $scheduleFId (@scheduleFIds) {
        my $scheduleF = new BRAVO::OM::ScheduleF();
        $scheduleF->id( $scheduleFId );
        $scheduleF->getById($connection); 
        if (defined $scheduleF->id){
            my $scheduleFh = new BRAVO::OM::ScheduleFHistory();
                $scheduleFh->scheduleFId($scheduleF->id);
                $scheduleFh->softwareId( $scheduleF->softwareId);
                $scheduleFh->customerId($scheduleF->customerId);
                $scheduleFh->softwareTitile($scheduleF->softwareTitile);
                $scheduleFh->softwareName($scheduleF->softwareName);
                $scheduleFh->manufacturer($scheduleF->manufacturer);
                $scheduleFh->scopeId($scheduleF->scopeId);
                $scheduleFh->sourceId($scheduleF->sourceId);
                $scheduleFh->sourceLocation($scheduleF->sourceLocation);
                $scheduleFh->statusId($scheduleF->statusId);
                $scheduleFh->businessJustification($scheduleF->businessJustification);
                $scheduleFh->remoteUser($scheduleF->remoteUser);
                $scheduleFh->recordTime($scheduleF->recordTime);
                $scheduleFh->level($scheduleF->level);
                $scheduleFh->hwOwner($scheduleF->hwOwner);
                $scheduleFh->serial($scheduleF->serial);
                $scheduleFh->machineType($scheduleF->machineType);
                $scheduleFh->hostname($scheduleF->hostname);
                dlog( $scheduleFh->toString );
                $scheduleFh->save($connection);
                dlog('ScheduleFHistory Saved');
                 $scheduleF->remoteUser('STAGING');
                 $scheduleF->businessJustification('Customer set Out of scope for SWLM');
                 dlog( $scheduleF->toString );
                 $scheduleF->save($connection);	
                 dlog('ScheduleF Updated');
        }
     }
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
        unless ( $args->{'LoadDeltaOnly'} == 0
        || $args->{'LoadDeltaOnly'} == 1 );
    $self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
    ilog( "loadDeltaOnly=" . $self->loadDeltaOnly );

    ###Check ApplyChanges arg is passed correctly
    die "Must specify ApplyChanges sub argument!\n"
        unless exists( $args->{'ApplyChanges'} );
    die "Invalid value passed for ApplyChanges param!\n"
        unless ( $args->{'ApplyChanges'} == 0
        || $args->{'ApplyChanges'} == 1 );
    $self->applyChanges( $args->{'ApplyChanges'} );
    ilog( "applyChanges=" . $self->applyChanges );
}
1;
