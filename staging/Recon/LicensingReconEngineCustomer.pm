package Recon::LicensingReconEngineCustomer;

use strict;
use Base::Utils;
use Carp qw( croak );
use Database::Connection;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::License;
use Recon::OM::ReconInstalledSoftware;
use Recon::OM::ReconLicense;
use Recon::LicensingInstalledSoftware;
use Recon::LicensingLicense;

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
               if ( $table eq 'RECON_INSTALLED_SW' ) {

                    ###Get the object.
                    my $installedSoftware = new BRAVO::OM::InstalledSoftware();
                    $installedSoftware->id($fk);
                    $installedSoftware->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon =
                        Recon::LicensingInstalledSoftware->new( $self->connection, $installedSoftware, $self->poolRunning );
                    my $rc = $recon->recon;

                    ###Remove recon job from queue.
                    if ( $rc != 2 ) {
                        my $reconInstalledSoftware = new Recon::OM::ReconInstalledSoftware();
                        $reconInstalledSoftware->id($id);
                        $reconInstalledSoftware->delete( $self->connection );
                    }
                }
                elsif ( $table eq 'RECON_LICENSE' ) {

                    ###Get the object.
                    my $license = new BRAVO::OM::License();
                    $license->id($fk);
                    $license->getById( $self->connection );

                    ###Call recon delegate to perform recon.
                    $recon = Recon::LicensingLicense->new( $self->connection, $license );
                    $recon->recon;

                    ###Remove recon job from queue.
                    my $reconLicense = new Recon::OM::ReconLicense();
                    $reconLicense->id($id);
                    $reconLicense->delete( $self->connection );
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
    dlog('Begin loadQueue method of LicensingReconEngineCustomer');

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
            ,case when a.table = \'RECON_LICENSE\' then 0
             when a.table = \'RECON_INSTALLED_SW\' then 1
             else 2 end
        from
            v_recon_licensing_queue a
        where
            a.customer_id = ?
            and date(record_time) = ?
            and not exists (
                select b.id from v_recon_licensing_queue b where
                    a.fk = b.fk and
                    a.table = b.table and
                    a.action = b.action and
                    a.customer_id = b.customer_id and
                    date(a.record_time) = date(b.record_time) and
                    a.id > b.id
            )
         order by a.record_time
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

