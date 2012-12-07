package Staging::ProcessorLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::OM::Processor;
use Scan::Delegate::ScanDelegate;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::ProcessorDelegate;

our @ISA = qw(Loader);

###Need to check and make sure current stuff has active customerIds, etc
sub new {
    my ($class, $bankAccountName) = @_;

    dlog('Building new ProcessorLoader object');

    my $self = $class->SUPER::new($bankAccountName);

    $self->{_list} = undef;

    bless $self, $class;

    dlog('ProcessorLoader instantiated for ' . $bankAccountName);

    return $self;
}

sub load {
    my ($self, %args) = @_;

    dlog('Start load method');

    my $job = $self->SUPER::bankAccountName . " PROCESSOR PULL";

    $self->SUPER::load(\%args, $job);

    ilog('Acquiring the staging connection');
    my $stagingConnection = Database::Connection->new('staging');
    ilog('Staging connection acquired');

    my $connection;
    eval {
        if ($self->SUPER::bankAccount->connectionType eq 'CONNECTED')
        {
            $connection
                = Database::Connection->new($self->SUPER::bankAccount);
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
        if ($self->SUPER::checkDeleteThreshold()) {
            $dieMsg
                = '**** We are deleting more than 15% of total records - Aborting '
                . $self->SUPER::bankAccountName
                . ' load ****';
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

    if ($self->SUPER::bankAccount->connectionType eq 'CONNECTED') {
        ilog('Disconnecting from bank account');
        $connection->disconnect
            if (defined $connection);
        ilog('Disconnected from bank account');
    }

    ilog('Disconnecting from staging');
    $stagingConnection->disconnect;
    ilog('Staging disconnected');

    die $dieMsg if defined $dieMsg;

    dlog('Load method complete');
}

sub prepareSourceData {
    my ($self, $connection) = @_;

    dlog('Start prepareSourceData method');

    die('Cannot call method directly') if ($self->SUPER::flag == 0);

    eval {
        $self->list(
            Scan::Delegate::ProcessorDelegate->getProcessorData(
                $connection, $self->SUPER::bankAccount,
                $self->loadDeltaOnly
            )
        );
    };
    if ($@) {
        wlog($@);
        die $@;
    }

    $self->SUPER::totalCnt(scalar keys %{ $self->list });
    dlog('End prepareSourceData method');
}

sub doDelta {
    my ($self, $connection) = @_;

    dlog('Start doDelta method');

    die('Cannot call method directly') if ($self->SUPER::flag == 0);

    if (!defined $self->list) {
        wlog('list is not defined');
        return;
    }

    if (scalar keys %{ $self->list } == 0) {
        wlog('list is zero');
        return;
    }

    dlog('Preparing staging processor query');
    $connection->prepareSqlQuery(
        Staging::Delegate::StagingDelegate->queryProcessorData());
    dlog("Prepared staging processor query");

    ###Define our fields
    my @fields = (
        qw (id processorNum manufacturer model maxSpeed busSpeed isActive serialNumber
            numBoards numModules pvu cache currentSpeed action scanRecordId)
    );

    ###Get the statement handle
    my $sth = $connection->sql->{processorData};

    ###Bind our columns
    my %rec;
    $sth->bind_columns(map { \$rec{$_} } @fields);

    dlog('Executing staging processor query');
    $sth->execute($self->SUPER::bankAccount->id);
    while ($sth->fetchrow_arrayref) {

        my $key = $rec{scanRecordId} . '|' . $rec{processorNum};
        dlog("key=$key");

        if ($rec{action} eq 'DELETE') {
            delete $self->list->{$key};
            next;
        }

        ###Create and populate a new processor object
        my $processor = new Staging::OM::Processor();
        $processor->id($rec{id});
        $processor->scanRecordId($rec{scanRecordId});
        $processor->processorNum($rec{processorNum});
        $processor->manufacturer($rec{manufacturer});
        $processor->model($rec{model});
        $processor->maxSpeed($rec{maxSpeed});
        $processor->busSpeed($rec{busSpeed});
        $processor->isActive($rec{isActive});
        $processor->serialNumber($rec{serialNumber});
        $processor->numBoards($rec{numBoards});
        $processor->numModules($rec{numModules});
        $processor->pvu($rec{pvu});
        $processor->cache($rec{cache});
        $processor->currentSpeed($rec{currentSpeed});
        $processor->action($rec{action});
        ilog($processor->toString);

        if (defined $self->list->{$key}) {
            ###We know that this scan record has this ip

            ###Set the id
            $self->list->{$key}->id($rec{id});
            $self->list->{$key}->action('COMPLETE');

            if (!$processor->equals($self->list->{$key})) {
                if ($processor->action eq 'COMPLETE') {
                    $self->list->{$key}->action('UPDATE');
                    $self->SUPER::incrUpdateCnt();
                }
            }
        }
        else {
            if ($processor->action eq 'COMPLETE') {
                $processor->action('DELETE');
                $self->SUPER::incrDeleteCnt();
            }
            else {
                $processor->action('COMPLETE');
            }

            $self->list->{$key} = $processor;
        }
    }
    $sth->finish;

    dlog("End doDelta method");
}

sub applyDelta {
    my ($self, $connection) = @_;

    dlog('Start applyDelta method');

    die('Cannot call method directly') if (!$self->flag);

    ###TODO Need to discuss how to handle
    if ($self->SUPER::applyChanges == 0) {
        dlog('Skipping apply per argument');
        return;
    }

    if (!defined $self->list) {
        wlog('list is not defined');
        return;
    }

    if (scalar keys %{ $self->list } == 0) {
        wlog('list is zero');
        return;
    }

    foreach my $key (keys %{ $self->list }) {
        dlog("Applying key=$key");

        $self->list->{$key}->action('UPDATE')
            if (!defined $self->list->{$key}->action);

        if ($self->list->{$key}->action eq 'COMPLETE') {
            dlog("Skipping this as is complete");
            next;
        }

        $self->list->{$key}->save($connection);
    }

    dlog("End applyDelta method");
}

sub list {
    my ($self, $value) = @_;
    $self->{_list} = $value if defined($value);
    return ($self->{_list});
}
1;
