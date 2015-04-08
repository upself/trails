package Base::ConfigManager;

use strict;
use base qw( Class::Singleton );
use Base::Utils;
use Config::Properties::Simple;

# This only gets called the first time instance() is called
sub _new_instance {
    my ( $class, $configFile ) = @_;

    ###If the passed in filename is empty or the file doesn't exists, load the default
    ###config file
    if ( ( !defined $configFile ) || ( $configFile eq '' ) || ( !-e $configFile ) ) {
        $configFile = "/opt/staging/v2/config/default_config.txt";
    }

    my $self = { _cfg => Config::Properties::Simple->new( file => $configFile, ) };

    bless $self, $class;
    return $self;
}

sub testMode {
    my $self = shift;
    return $self->{_cfg}->getProperty('testMode');
}

sub connRetryTimes {
    my $self = shift;
    return $self->{_cfg}->getProperty('connRetryTimes');
}

sub connRetrySleepPeriod {
    my $self = shift;
    return $self->{_cfg}->getProperty('connRetrySleepPeriod');
}

sub server {
    my $self = shift;
    return $self->{_cfg}->getProperty('server');
}

sub applyChanges {
    my $self = shift;
    return $self->{_cfg}->getProperty('applyChanges');
}

sub loadDeltaOnly {
    my $self = shift;
    return $self->{_cfg}->getProperty('loadDeltaOnly');
}

sub sleepPeriod {
    my $self = shift;
    return $self->{_cfg}->getProperty('sleepPeriod');
}

sub fullLoadPeriodHours {
    my $self = shift;
    return $self->{_cfg}->getProperty('fullLoadPeriodHours');
}

sub bravoFullLoadPeriodHours {
    my $self = shift;
    return $self->{_cfg}->getProperty('bravoFullLoadPeriodHours');
}

sub debugLevel {
    my $self = shift;
    return $self->{_cfg}->getProperty('debugLevel');
}

sub ageDaysDelete {
    my $self = shift;
    return $self->{_cfg}->getProperty('ageDaysDelete');
}

#Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
sub nonDebugLogPath {
    my $self = shift;
    return $self->{_cfg}->getProperty('nonDebugLogPath');
}
#Added by Larry for System Support And Self Healing Service Components - Phase 3 End

###Returns an array of Test Bank Account names
sub testBankAccounts {
    my $self = shift;
    ###convert comma-separated list to a hash of bank account names that can be
    ###searched by the calling script
    my @bankAccts = split( /,/, $self->{_cfg}->getProperty('testBankAccounts') );
    return \@bankAccts;
}

###Returns the test bank accounts name as keys in a hash map for easier check for existence
sub testBankAccountsAsHash {
    my $self = shift;
    ###convert comma-separated list to a hash of bank account names that can be
    ###searched by the calling script
    my @bankAccts = split( /,/, $self->{_cfg}->getProperty('testBankAccounts') );

    my %bankAcctsHash;
    foreach (@bankAccts) {
        $bankAcctsHash{$_} = undef;
    }

    return \%bankAcctsHash;
}

###Returns an array of test customer ids
sub testCustomerIds {
    my $self = shift;
    ###convert comma-separated list to a hash of customer ids that can be
    ###searched by the calling script
    my @custIds = split( /,/, $self->{_cfg}->getProperty('testCustomerIds') );
    return \@custIds;
}

###Returns customer ids as a comma separated list
sub testCustomerIdsAsString {
    my $self = shift;
    return $self->{_cfg}->getProperty('testCustomerIds');
}

1;
