package Recon::InventoryReconEngineCustomer;

use strict;
use Base::Utils;
use Carp qw( croak );
use Database::Connection;
use BRAVO::OM::Customer;
use BRAVO::OM::Hardware;
use BRAVO::OM::HardwareLpar;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::License;
use Recon::OM::ReconCustomer;
use Recon::OM::ReconHardware;
use Recon::OM::ReconHardwareLpar;
use Recon::OM::ReconSoftwareLpar;
use Recon::OM::ReconInstalledSoftware;
use Recon::OM::ReconLicense;
use Recon::OM::ReconCustomerSoftware;
use Recon::Customer;
use Recon::Hardware;
use Recon::HardwareLpar;
use Recon::SoftwareLpar;
use Recon::InventoryInstalledSoftware;
use Recon::InventoryLicense;
use Recon::CustomerSoftware;
use Recon::Queue;

sub new {
    my ( $class, $customerId, $date, $poolRunning ) = @_;
    my $self = {
                 _customerId  => $customerId,
                 _queue       => undef,
                 _connection  => Database::Connection->new('trails'),
                 _date        => $date,
                 _poolRunning => $poolRunning
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Customer ID is invalid'
        if $self->customerId !~ /^\d+$/;

    croak 'Connection is undefined'
        if !defined $self->connection;
}

sub recon {
    my $self = shift;

    my $dieMsg;

    eval {
        $self->loadQueue;

        foreach my $orderBy ( sort keys %{ $self->queue } ) {
            foreach my $pk ( keys %{ $self->queue->{$orderBy} } ) {

                my $table  = $self->queue->{$orderBy}->{$pk}->{table};
                my $id     = $self->queue->{$orderBy}->{$pk}->{id};
                my $fk     = $self->queue->{$orderBy}->{$pk}->{fk};
                my $action = $self->queue->{$orderBy}->{$pk}->{action};

                my $recon;

                ###Process the recon job based on table.
                if ( $table eq 'RECON_CUSTOMER' ) {

                    ###Get the customer
                    my $customer = new BRAVO::OM::Customer();
                    $customer->id($fk);
                    $customer->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon = Recon::Customer->new( $self->connection, $customer );
                    $recon->recon;

                    ###Remove recon job from queue.
                    my $reconCustomer = new Recon::OM::ReconCustomer();
                    $reconCustomer->id($id);
                    $reconCustomer->delete( $self->connection );
                }
                elsif ( $table eq 'RECON_HARDWARE' ) {

                    ###Get the hardware.
                    my $hardware = new BRAVO::OM::Hardware();
                    $hardware->id($fk);
                    $hardware->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon = Recon::Hardware->new( $self->connection, $hardware, $action );
                    $recon->recon;

                    ###Remove recon job from queue.
                    my $reconHardware = new Recon::OM::ReconHardware();
                    $reconHardware->id($id);
                    $reconHardware->delete( $self->connection );
                }
                elsif ( $table eq 'RECON_HW_LPAR' ) {

                    ###Get the object.
                    my $hardwareLpar = new BRAVO::OM::HardwareLpar();
                    $hardwareLpar->id($fk);
                    $hardwareLpar->getById( $self->connection );
                    dlog( $hardwareLpar->toString );

                    ###Call recon delegate to perform recon.
                    $recon = Recon::HardwareLpar->new( $self->connection, $hardwareLpar, $action );
                    $recon->recon;

                    ###Remove recon job from queue.
                    my $reconHardwareLpar = new Recon::OM::ReconHardwareLpar();
                    $reconHardwareLpar->id($id);
                    $reconHardwareLpar->delete( $self->connection );
                }
                elsif ( $table eq 'RECON_SW_LPAR' ) {

                    ###Get the object.
                    my $softwareLpar = new BRAVO::OM::SoftwareLpar();
                    $softwareLpar->id($fk);
                    $softwareLpar->getById( $self->connection );

                    ###Call recon delegate to perform recon
                    $recon = Recon::SoftwareLpar->new( $self->connection, $softwareLpar, $action );
                    $recon->recon;

                    ###Remove recon job from queue.
                    my $reconSoftwareLpar = new Recon::OM::ReconSoftwareLpar();
                    $reconSoftwareLpar->id($id);
                    $reconSoftwareLpar->delete( $self->connection );
                }
                elsif ( $table eq 'RECON_INSTALLED_SW' ) {

                    ###Get the object.
                    my $installedSoftware = new BRAVO::OM::InstalledSoftware();
                    $installedSoftware->id($fk);
                    $installedSoftware->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon =
                        Recon::InventoryInstalledSoftware->new( $self->connection, $installedSoftware, 0 );
                    my $rc = $recon->recon;

                    ###Remove recon job from queue.

                    my $reconInstalledSoftware = new Recon::OM::ReconInstalledSoftware();
                    $reconInstalledSoftware->id($id);
                    $reconInstalledSoftware->delete( $self->connection );

                    if ( $rc == 2 ) {
						my $softwareLpar = new BRAVO::OM::SoftwareLpar();
						$softwareLpar->id( $installedSoftware->softwareLparId );
						$softwareLpar->getById ( $self->connection );

						my $queue =
							Recon::Queue->new( $self->connection, $installedSoftware,
							$softwareLpar, 'LICENSING' );
						$queue->add;
                    }
                }
                elsif ( $table eq 'RECON_LICENSE' ) {

                    ###Get the object.
                    my $license = new BRAVO::OM::License();
                    $license->id($fk);
                    $license->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon = Recon::InventoryLicense->new( $self->connection, $license );
                    my $rc = $recon->recon;

                    ###Remove recon job from queue.
                    if ( $rc == 2 ) {
						dlog("License with job DELETE, but still active - switching to Licensing recon engine.");
						my $reconLicense = new Recon::OM::ReconLicense();
						$reconLicense->id($id);
						$reconLicense->licenseId($fk);
						$reconLicense->customerId( $license->customerId );
						$reconLicense->action('UPDATE');
						$reconLicense->save( $self->connection );
					} else {
						my $reconLicense = new Recon::OM::ReconLicense();
						$reconLicense->id($id);
						$reconLicense->delete( $self->connection );
					}
                }
                elsif ( $table eq 'RECON_CUSTOMER_SW' ) {

                    ###Get the customer
                    my $customer = new BRAVO::OM::Customer();
                    $customer->id( $self->customerId );
                    $customer->getById( $self->connection );

                    ###Get the software
                    my $software = new BRAVO::OM::Software();
                    $software->id($fk);
                    $software->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon = Recon::CustomerSoftware->new( $self->connection, $customer, $software );
                    $recon->recon;

                    ###Remove recon job from queue.
                    my $reconCustomerSoftware = new Recon::OM::ReconCustomerSoftware();
                    $reconCustomerSoftware->id($id);
                    $reconCustomerSoftware->delete( $self->connection );
                }
            }
        }
    };
    if ($@) {
        elog($@);
        $dieMsg = $@;
    }

    $self->connection->disconnect;

    ###die if dieMsg is defined
    die $dieMsg if defined $dieMsg;
}

sub loadQueue {
    my $self = shift;
    dlog('Begin loadQueue method of InventoryReconEngineCustomer');

    my %queue;

    ###Prepare the query
    $self->connection->prepareSqlQueryAndFields( $self->queryReconQueueByCustomerId() );

    ###Acquire the statement handle
    my $sth = $self->connection->sql->{reconQueueByCustomerId};

    ###Bind our columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{reconQueueByCustomerIdFields} } );

    ###Excute the query
    $sth->execute( $self->customerId, $self->date );

    ###Loop over query result set.
    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        ###Upper case record values
        upperValues( \%rec );
        
        ###Add to our queue hash
        $queue{ $rec{orderBy} }{ $rec{pk} }{table}  = $rec{table};
        $queue{ $rec{orderBy} }{ $rec{pk} }{id}     = $rec{id};
        $queue{ $rec{orderBy} }{ $rec{pk} }{fk}     = $rec{fk};
        $queue{ $rec{orderBy} }{ $rec{pk} }{action} = $rec{action};
    }
    $sth->finish;

    ###Set our queue attribute
    $self->queue( \%queue );
}

sub queryReconQueueByCustomerId {
    my @fields = qw(
        pk
        id
        fk
        table
        action
        orderBy
    );
    my $query = '
        select
            a.pk
            ,a.id
            ,a.fk
            ,a.table
            ,a.action
            ,case when a.table = \'RECON_CUSTOMER\' then 0
             when a.table = \'RECON_HARDWARE\' then 1
             when a.table = \'RECON_HW_LPAR\' then 2
             when a.table = \'RECON_SW_LPAR\' then 3
             when a.table = \'RECON_LICENSE\' then 4
             when a.table = \'RECON_INSTALLED_SW\' then 5
             else 6 end
        from
            v_recon_inventory_queue a
        where
            a.customer_id = ?
            and date(record_time) = ?
            and not exists (
                select b.id from v_recon_inventory_queue b where
                    a.fk = b.fk and
                    a.table = b.table and
                    a.action = b.action and
                    a.customer_id = b.customer_id and
                    date(a.record_time) = date(b.record_time) and
                    a.id > b.id
            )
        fetch first 200 rows only with ur
    ';
    dlog("queryReconQueueByCustomerId=$query");
    return ( 'reconQueueByCustomerId', $query, \@fields );
    

} 

sub date {
    my $self = shift;
    $self->{_date} = shift if scalar @_ == 1;
    return $self->{_date};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub queue {
    my $self = shift;
    $self->{_queue} = shift if scalar @_ == 1;
    return $self->{_queue};
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub poolRunning {
    my $self = shift;
    $self->{_poolRunning} = shift if scalar @_ == 1;
    return $self->{_poolRunning};
}

1;

