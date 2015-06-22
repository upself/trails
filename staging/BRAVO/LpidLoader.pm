package BRAVO::LpidLoader;

use strict;
use Base::Utils;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use BRAVO::OM::Lpid;

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

    my $job = "LPID REPLICATION";
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

    ilog('Acquring lpid data');

    $self->list( $self->getLpidData($connection) );

    dlog('End prepareSourceData method');
}

sub doDelta {
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    dlog('Preparing bravo lpid query');
    $connection->prepareSqlQueryAndFields( $self->queryLpidData() );
    dlog('bravo lpid query prepared');

    dlog('Getting statement handle');
    my $sth = $connection->sql->{lpidData};
    dlog('Acquired statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{lpidDataFields} } );
    dlog('Columns binded');

    ilog('Executing bravo lpid query');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Get the key
        my $key = $rec{id};
        dlog("lpid key=$key");

        ###Create and populate a new lpid object
        my $lpid = new BRAVO::OM::Lpid();
        $lpid->id( $rec{id} );
        $lpid->lpidId( $rec{id} );
        $lpid->majorId( $rec{majorId} );
        $lpid->name( $rec{name} );
        dlog( $lpid->toString );

        if ( defined $self->list->{$key} ) {
            dlog('lpid exists in cndb');

            $self->list->{$key}->id( $rec{id} );

            if ( !$lpid->equals( $self->list->{$key} ) ) {
                dlog('lpid is not equal');
                dlog( $self->list->{$key}->toString );

                $self->list->{$key}->action('UPDATE');
            }
            else {
                dlog('lpid is equal, setting to complete');
                $self->list->{$key}->action('COMPLETE');
            }
        }
        else {
            $self->list->{$key} = $lpid;
            $self->list->{$key}->action('DELETE');
            elog('lpid does not exist in cndb');

            # die('Lpid number deleted from CNDB');
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
        elsif ( $self->list->{$key}->action eq 'DELETE' ) {
            $self->list->{$key}->delete($connection);
        }
        else {
            $self->list->{$key}->save($connection)
                if ( $self->applyChanges == 1 );
            $self->list->{$key}->action('COMPLETE');
        }
    }

    dlog('End apply method');
}

sub list {
    my ( $self, $value ) = @_;
    $self->{list} = $value if defined($value);
    return ( $self->{list} );
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
        unless (    $args->{'LoadDeltaOnly'} == 0
                 || $args->{'LoadDeltaOnly'} == 1 );
    $self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
    ilog( "loadDeltaOnly=" . $self->loadDeltaOnly );

    ###Check ApplyChanges arg is passed correctly
    die "Must specify ApplyChanges sub argument!\n"
        unless exists( $args->{'ApplyChanges'} );
    die "Invalid value passed for ApplyChanges param!\n"
        unless (    $args->{'ApplyChanges'} == 0
                 || $args->{'ApplyChanges'} == 1 );
    $self->applyChanges( $args->{'ApplyChanges'} );
    ilog( "applyChanges=" . $self->applyChanges );
}

sub getLpidData {
    my ( $self, $connection ) = @_;

    dlog('Start getLpidData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryLpidData() );

    my $sth = $connection->sql->{lpidData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{lpidDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $lpid = new BRAVO::OM::Lpid();
        $lpid->lpidId( $rec{id} );
        $lpid->name( $rec{name} );
        $lpid->majorId( $rec{majorId} );

        $lpid->id( $rec{id} ) if $connection->name ne 'CNDB';

        $data{$key} = $lpid;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryLpidData {
    my @fields = (qw(id name majorId));
    my $query  = '
        select
            l.lpid_id
            ,substr(l.lpid_name,1,8)
            ,l.major_id
        from
            lpid l
        with ur
    ';

    return ( 'lpidData', $query, \@fields );
}
1;

