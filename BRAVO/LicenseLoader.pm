package BRAVO::LicenseLoader;

use strict;
use Carp qw( croak );
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use BRAVO::Loader::License;    

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

    $self->startJob;
    $self->stagingConnection( Database::Connection->new('staging') );
    $self->bravoConnection( Database::Connection->new('trails') );

    my $dieMsg = undef;
    eval {
        $self->stagingLicenseIds( $self->getStagingLicenseIds );
        $self->bravoLicenseIds( $self->getBravoActiveLicenseIds );
        $self->processLicenseIds;
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
        SystemScheduleStatusDelegate->error( $self->systemScheduleStatus, $dieMsg ) if $self->applyChanges == 1;
    }
    else {
        SystemScheduleStatusDelegate->stop( $self->systemScheduleStatus ) if $self->applyChanges == 1;
    }

    $self->stagingConnection->disconnect;
    $self->bravoConnection->disconnect;

    die $dieMsg if defined $dieMsg;

#TODO create method to send someone or some group an attachment with records deleted if the max is breached
#This should be in the swcm to staging loader
}

sub startJob {
    my $self = shift;

    ###Set the job name of this script to update the status
    my $job;
    if ( $self->loadDeltaOnly == 1 ) {
        $job = 'STAGING TO BRAVO - LIC (DELTA)';
    }
    else {
        $job = 'STAGING TO BRAVO - LIC (FULL)';
    }
    dlog("job=$job");

    $self->systemScheduleStatus( SystemScheduleStatusDelegate->start($job) ) if $self->applyChanges == 1;
}

sub getStagingLicenseIds {
    my $self = shift;

    my @ids;
    my %rec;

    $self->stagingConnection->prepareSqlQueryAndFields(
                                                     $self->queryLicenseData( $self->testMode, $self->loadDeltaOnly ) );
    my $sth = $self->stagingConnection->sql->{licenseData};
    $sth->bind_columns( map { \$rec{$_} } @{ $self->stagingConnection->sql->{licenseDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        push @ids, $rec{id};
    }
    $sth->finish;

    return \@ids;
}


sub getBravoActiveLicenseIds {
    my $self = shift;

    my @ids;
    my %rec;

    $self->bravoConnection->prepareSqlQueryAndFields(
                                                     $self->queryBravoActiveLicenseData() );
    my $sth = $self->bravoConnection->sql->{bravoActiveLicenseData};
    $sth->bind_columns( map { \$rec{$_} } @{ $self->bravoConnection->sql->{bravoActiveLicenseDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        push @ids, $rec{id};
    }
    $sth->finish;

    return \@ids;
}

sub processLicenseIds {
    my $self = shift;

    foreach my $id ( sort @{ $self->stagingLicenseIds } ) {
        my $license = new BRAVO::Loader::License( $self->stagingConnection, $self->bravoConnection, $id, 0  );
        $license->logic;
        $license->save if $self->applyChanges == 1;
    }
    
    
    foreach my $id ( sort @{ $self->bravoLicenseIds } ) {
        my $license = new BRAVO::Loader::License( $self->stagingConnection, $self->bravoConnection, $id, 1 );
        $license->logicFromBravoToStaging;
        $license->saveFromBravoToStaging if $self->applyChanges == 1;
    }
    
    
   
}


sub queryBravoActiveLicenseData {
    my $self   = shift;
    my @fields = qw(
      id
    );
    my $query = '
        select
            l.id
        from
            license l
        where
           l.status != \'INACTIVE\'
    ';    

    dlog("queryBravoActiveLicenseData=$query");
    return ( 'bravoActiveLicenseData', $query, \@fields );
}


sub queryLicenseData {
    my $self   = shift;
    my @fields = qw(
      id
    );
    my $query = '
        select
            l.id
        from
            license l
    ';

    my $clause = 'where';

    if ( $self->loadDeltaOnly == 1 ) {
        $query .= ' ' . $clause . ' l.action != \'COMPLETE\' ';
        $clause = ' and ';
    }
    if ( $self->testMode == 1 ) {
        $query .=
          ' ' . $clause . ' l.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }

    dlog("queryLicenseData=$query");
    return ( 'licenseData', $query, \@fields );
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

sub stagingLicenseIds {
    my ( $self, $value ) = @_;
    $self->{_stagingLicenseIds} = $value if defined($value);
    return ( $self->{_stagingLicenseIds} );
}

sub bravoLicenseIds {
    my ( $self, $value ) = @_;
    $self->{_bravoLicenseIds} = $value if defined($value);
    return ( $self->{_bravoLicenseIds} );
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
