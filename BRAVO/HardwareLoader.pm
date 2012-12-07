package BRAVO::HardwareLoader;

use strict;
use Carp qw( croak );
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Staging::OM::Hardware;
use BRAVO::Loader::Hardware;

###Object constructor.
sub new {
    my ( $class, $testMode, $loadDeltaOnly, $applyChanges ) = @_;
    my $self = {
                 _testMode             => $testMode,
                 _loadDeltaOnly        => $loadDeltaOnly,
                 _applyChanges         => $applyChanges,
                 _stagingConnection    => undef,
                 _bravoConnection      => undef,
                 _systemScheduleStatus => undef
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Test mode is undefined'
      unless defined $self->testMode;

    croak 'Invalid value passed to testMode'
      unless $self->testMode == 1 || $self->testMode == 0;

    croak 'loadDeltaOnly is undefined'
      unless defined $self->loadDeltaOnly;

    croak 'Invalid value passed to loadDeltaOnly'
      unless $self->loadDeltaOnly == 1 || $self->loadDeltaOnly == 0;

    croak 'applyChanges is undefined'
      unless defined $self->applyChanges;

    croak 'Invalid value passed to applyChanges'
      unless $self->applyChanges == 1 || $self->applyChanges == 0;
}

###Primary method used by calling clients to load staging
###license data to bravo.
sub load {
    my $self = shift;

    ilog("Starting job");
    $self->startJob;
    ilog("Job started");

    ilog("Establishing staging connection");
    $self->stagingConnection( Database::Connection->new('staging') );
    ilog("Staging connection established");

    ilog("Establishing bravo connection");
    $self->bravoConnection( Database::Connection->new('trails') );
    ilog("Bravo connection established");

    my $dieMsg = undef;
    eval {
        ilog("Obtaining staging hardware ids");
        $self->stagingHardwareIds( $self->getStagingHardwareIds );
        ilog("Obtained staging hardware ids");

        ilog("Processing hardware ids");
        $self->processHardwareIds;
        ilog("Hardware ids processed");
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
        SystemScheduleStatusDelegate->error( $self->systemScheduleStatus, $dieMsg ) if $self->applyChanges == 1;
    }
    else {
        ilog("Ending job");
        SystemScheduleStatusDelegate->stop( $self->systemScheduleStatus ) if $self->applyChanges == 1;
        ilog("Job ended");
    }

    ilog("Closing staging connection");
    $self->stagingConnection->disconnect;
    ilog("Staging connection closed");

    ilog("Closing bravo connection");
    $self->bravoConnection->disconnect;
    ilog("Bravo connection closed");

    die $dieMsg if defined $dieMsg;
}

sub startJob {
    my $self = shift;

    ###Set the job name of this script to update the status
    my $job;
    if ( $self->loadDeltaOnly == 1 ) {
        $job = 'STAGING TO BRAVO - HW (DELTA)';
    }
    else {
        $job = 'STAGING TO BRAVO - HW (FULL)';
    }
    dlog("job=$job");

    $self->systemScheduleStatus( SystemScheduleStatusDelegate->start($job) ) if $self->applyChanges == 1;
}

sub getStagingHardwareIds {
    my $self = shift;

    my @ids;
    my %rec;

    $self->stagingConnection->prepareSqlQueryAndFields(
                                                    $self->queryHardwareData( $self->testMode, $self->loadDeltaOnly ) );
    my $sth = $self->stagingConnection->sql->{hardwareData};
    $sth->bind_columns( map { \$rec{$_} } @{ $self->stagingConnection->sql->{hardwareDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        dlog( "Hardware ID: " . $rec{id} );
        push @ids, $rec{id};
    }
    $sth->finish;

    return \@ids;
}

sub processHardwareIds {
    my $self = shift;

    foreach my $id ( sort @{ $self->stagingHardwareIds } ) {
        my $hardware = new Staging::OM::Hardware();
        $hardware->id($id);
        $hardware->getById( $self->stagingConnection );
        dlog( $hardware->toString );

        my $hardwareLoader = new BRAVO::Loader::Hardware( $self->stagingConnection, $self->bravoConnection, $hardware );
        $hardwareLoader->logic;
        $hardwareLoader->save if $self->applyChanges == 1;
    }
}

sub queryHardwareData {
    my $self = shift;

    my @fields = qw(
      id
    );

    my $query = '
        select distinct
            h.id
        from
            hardware h
            left outer join hardware_lpar hl on
                h.id = hl.hardware_id
            left outer join effective_processor ep on
                ep.hardware_lpar_id = hl.id
    ';

    my $clause = 'where';

    if ( $self->loadDeltaOnly == 1 ) {
        $query .= ' ' . $clause . ' (h.action != \'COMPLETE\'
                or hl.action != \'COMPLETE\'
                or ep.action != \'COMPLETE\') ';
        $clause = ' and ';
    }
    if ( $self->testMode == 1 ) {
        $query .=
            ' ' . $clause
          . ' (h.customer_id in ('
          . Base::ConfigManager->instance()->testCustomerIdsAsString()
          . ') or hl.customer_id in ('
          . Base::ConfigManager->instance()->testCustomerIdsAsString() . '))';
    }

    dlog("queryHardwareData=$query");
    return ( 'hardwareData', $query, \@fields );
}

sub stagingConnection {
    my ( $self, $value ) = @_;
    $self->{_stagingConnection} = $value if defined($value);
    return ( $self->{_stagingConnection} );
}

sub bravoConnection {
    my ( $self, $value ) = @_;
    $self->{_bravoConnection} = $value if defined($value);
    return ( $self->{_bravoConnection} );
}

sub systemScheduleStatus {
    my ( $self, $value ) = @_;
    $self->{_systemScheduleStatus} = $value if defined($value);
    return ( $self->{_systemScheduleStatus} );
}

sub stagingHardwareIds {
    my ( $self, $value ) = @_;
    $self->{_stagingHardwareIds} = $value if defined($value);
    return ( $self->{_stagingHardwareIds} );
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

1;
