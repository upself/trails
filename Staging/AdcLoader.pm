package Staging::AdcLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::OM::Adc;
use Scan::Delegate::ScanDelegate;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::AdcDelegate;

our @ISA = qw(Loader);

###Need to check and make sure current stuff has active customerIds, etc
sub new {
    my ( $class, $bankAccountName ) = @_;

    dlog('Building new AdcLoader object');

    my $self = $class->SUPER::new($bankAccountName);

    $self->{_list} = undef;

    bless $self, $class;

    dlog( 'AdcLoader instantiated for ' . $bankAccountName );

    return $self;
}

sub load {
    my ( $self, %args ) = @_;

    dlog('Start load method');

    my $job = $self->SUPER::bankAccountName . " ADC PULL";

    $self->SUPER::load( \%args, $job );

    ilog('Acquiring the staging connection');
    my $stagingConnection = Database::Connection->new('staging');
    ilog('Staging connection acquired');

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

        ###Check if we have crossed the delete threshold
        if ( $self->SUPER::checkDeleteThreshold() ) {
            $dieMsg = '**** We are deleting more than 15% of total records - Aborting ' . $self->SUPER::bankAccountName . ' load ****';
        }
        else {
            ilog('Applying deltas');
            $self->applyDelta($stagingConnection);
            ilog('Deltas applied');
        }
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
              Scan::Delegate::AdcDelegate->getAdcData( $connection, $self->SUPER::bankAccount, $self->loadDeltaOnly ) );
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

    dlog('Preparing staging adc query');
    $connection->prepareSqlQuery( Staging::Delegate::StagingDelegate->queryAdcData() );
    dlog("Prepared staging adc query");

    ###Define our fields
    my @fields = (
        qw(id epName epOid ipAddress cust loc gu serverType sesdrLocation
          sesdrBpUsing sesdrSystid action scanRecordId scanRecordAction)
    );

    ###Get the statement handle
    my $sth = $connection->sql->{adcData};

    ###Bind our columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    dlog('Executing staging adc query');
    $sth->execute( $self->SUPER::bankAccount->id );
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{scanRecordId} . '|' . $rec{epName};
        dlog("key=$key");
        
        if($rec{action} eq 'DELETE') {
            delete $self->list->{$key};
            next;
        }
        
        if($rec{scanRecordAction} eq 'DELETE') {
            delete $self->list->{$key};
            next;
        }      

        ###Create and populate a new hardware object
        my $adc = new Staging::OM::Adc();
        $adc->id( $rec{id} );
        $adc->scanRecordId( $rec{scanRecordId} );
        $adc->epName( $rec{epName} );
        $adc->epOid( $rec{epOid} );
        $adc->ipAddress( $rec{ipAddress} );
        $adc->cust( $rec{cust} );
        $adc->loc( $rec{loc} );
        $adc->gu( $rec{gu} );
        $adc->serverType( $rec{serverType} );
        $adc->sesdrLocation( $rec{sesdrLocation} );
        $adc->sesdrBpUsing( $rec{sesdrBpUsing} );
        $adc->sesdrSystid( $rec{sesdrSystid} );
        $adc->action( $rec{action} );
        ilog( $adc->toString );

        if ( defined $self->list->{$key} ) {
                    
            ###We know that this scan record has this adc

            ###Set the id
            $self->list->{$key}->id( $rec{id} );
            $self->list->{$key}->action('COMPLETE');

            if ( !$adc->equals( $self->list->{$key} ) ) {
                if ( $adc->action eq 'COMPLETE' ) {
                    $self->list->{$key}->action('UPDATE');
                    $self->SUPER::incrUpdateCnt();
                }
            }
        }
        else {
            if ( $adc->action eq 'COMPLETE' ) {
                $adc->action('DELETE');
                $self->SUPER::incrDeleteCnt();
            }
            else {
                $adc->action('COMPLETE');
                $self->SUPER::incrUpdateCnt();                
            }

            $self->list->{$key} = $adc;
        }
    }
    $sth->finish;

    dlog("End doDelta method");
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
        wlog('list is not defined');
        return;
    }

    if ( scalar keys %{ $self->list } == 0 ) {
        wlog('list is zero');
        return;
    }

    foreach my $key ( keys %{ $self->list } ) {
        dlog("Applying key=$key");

        $self->list->{$key}->action('UPDATE')
          if ( !defined $self->list->{$key}->action );

        if ( $self->list->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
            next;
        }

        $self->list->{$key}->save($connection);
    }

    dlog("End applyDelta method");
}

sub list {
    my ( $self, $value ) = @_;
    $self->{_list} = $value if defined($value);
    return ( $self->{_list} );
}
1;
