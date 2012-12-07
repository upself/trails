package Loader;
use strict;
use Base::Utils;
use File::Basename;
use Sigbank::Delegate::BankAccountDelegate;
use BRAVO::BankAccountService;

sub new {
	my ( $class, $bankAccountName ) = @_;
	dlog('Building new Loader object');
	if ( !defined $bankAccountName ) {
		elog("Bank account name is not defined");
		die "Bank account name is not defined";
	}
	my $self = {
		_testMode             => undef,
		_loadDeltaOnly        => undef,
		_applyChanges         => undef,
		_fullLoadPeriodHours  => undef,
		_flag                 => undef,
		_bankAccount          => undef,
		_bankAccountJob       => undef,
		_updateCnt            => 0,
		_deleteCnt            => 0,
		_totalCnt             => 0,
		_bankAccountName      => uc($bankAccountName)
	};
	bless $self, $class;
	dlog('Loader object built');
	return $self;
}

sub load {
	my ( $self, $args, $job ) = @_;
	dlog('Start super load method');
	dlog('Checking passed arguments');
	$self->checkArgs($args);
	dlog('Checked passed arguments');
	$self->bankAccount(
		Sigbank::Delegate::BankAccountDelegate->getBankAccountByName(
			$self->bankAccountName
		)
	);
	if ( !defined $self->bankAccount->id ) {
		elog( "Bank Account " . $self->bankAccountName . " does not exist" );
		die "Bank Account " . $self->bankAccountName . " does not exist";
	}
	if ( $self->loadDeltaOnly == 1 ) {
		dlog('Set to only load the delta');
		if ( defined $self->fullLoadPeriodHours ) {
			dlog( 'Full load period set to ' . $self->fullLoadPeriodHours );
			if (
				BRAVO::BankAccountService->isFullLoad( "$job (FULL)",
					$self->fullLoadPeriodHours ) == 0
			  )
			{
				dlog('This is a delta load');
				$job = "$job (DELTA)";
			}
			else {
				dlog('This is a full load');
				$self->loadDeltaOnly(0);
				$job = "$job (FULL)";
			}
		}
		else {
			dlog('This is a delta load');
			$job = "$job (DELTA)";
		}
	}
	else {
		dlog('This is a full load');
		$job = "$job (FULL)";
	}
	ilog("Current job=$job");
	if ( $self->applyChanges == 1 ) {
		ilog("Starting $job bank account job");
		$self->bankAccountJob(
			BRAVO::BankAccountService->startJob( $self->bankAccount->id, $job )
		);
		ilog("Started $job bank account job");
	}
	dlog('Setting the flag');
	$self->flag(1);
	dlog('Flag set');
	dlog('End super load method');
}

sub endLoad {
	my ( $self, $dieMsg ) = @_;
	dlog('Start super endLoad method');
	if ( defined $dieMsg ) {
		dlog( "dieMsg is defined " . $dieMsg );
		if ( $self->applyChanges == 1 ) {
			ilog("Generating bank account job error");
			BRAVO::BankAccountService->error( $self->bankAccountJob, $dieMsg );
			ilog("Generated bank account job error");
		}
		$self->bankAccount->connectionStatus('ERROR');
		$self->bankAccount->comments($dieMsg);
		Sigbank::Delegate::BankAccountDelegate->updateBankAccount(
			$self->bankAccount );
	}
	else {
		if ( $self->applyChanges == 1 ) {
			ilog("Stopping bank account job");
			BRAVO::BankAccountService->stopJob( $self->bankAccountJob );
			ilog("Stopped bank account job");
		}
		if ( $self->bankAccount->connectionStatus eq 'ERROR' ) {
			$self->bankAccount->connectionStatus('SUCCESS');
			$self->bankAccount->comments('Successful Connection');
			Sigbank::Delegate::BankAccountDelegate->updateBankAccount(
				$self->bankAccount );
		}
	}
	### logs the counts
	if ( $self->{_totalCnt} > 0 ) {
		logMsg("Total Counts  - $self->{_totalCnt}");
		logMsg("Update Counts - $self->{_updateCnt}");
		logMsg("Delete Counts - $self->{_deleteCnt}");
	}
	dlog('End super endLoad method');
}

sub checkArgs {
	my ( $self, $args ) = @_;
	###Check TestMode arg is passed correctly
	die "Must specify TestMode sub argument!\n"
	  unless exists( $args->{'TestMode'} );
	die "Invalid value passed for TestMode param!\n"
	  unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 );
	dlog( "TestMode arg=" . $args->{'TestMode'} );
	###Check LoadDeltaOnly arg is passed correctly
	die "Must specify LoadDeltaOnly sub argument!\n"
	  unless exists( $args->{'LoadDeltaOnly'} );
	die "Invalid value passed for LoadDeltaOnly param!\n"
	  unless ( $args->{'LoadDeltaOnly'} == 0 || $args->{'LoadDeltaOnly'} == 1 );
	dlog( "LoadDeltaOnly arg=" . $args->{'LoadDeltaOnly'} );
	###Check ApplyChanges arg is passed correctly
	die "Must specify ApplyChanges sub argument!\n"
	  unless exists( $args->{'ApplyChanges'} );
	die "Invalid value passed for ApplyChanges param!\n"
	  unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 );
	dlog( "ApplyChanges arg=" . $args->{'ApplyChanges'} );
	###Check FullLoadPeriodHours arg is passed correctly
	die "Invalid value passed for ApplyChanges param!\n"
	  unless ( defined $args->{'FullLoadPeriodHours'}
		&& $args->{'FullLoadPeriodHours'} =~ m/\d+/ );
	dlog( "FullLoadPeriodHours arg=" . $args->{'FullLoadPeriodHours'} );
	dlog('Setting passed arguments');
	$self->testMode( $args->{'TestMode'} );
	$self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
	$self->applyChanges( $args->{'ApplyChanges'} );
	$self->fullLoadPeriodHours( $args->{'FullLoadPeriodHours'} );
	dlog('Arguments set');
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

sub flag {
	my ( $self, $value ) = @_;
	$self->{_flag} = $value if defined($value);
	return ( $self->{_flag} );
}

sub fullLoadPeriodHours {
	my ( $self, $value ) = @_;
	$self->{_fullLoadPeriodHours} = $value if defined($value);
	return ( $self->{_fullLoadPeriodHours} );
}

sub bankAccount {
	my ( $self, $value ) = @_;
	$self->{_bankAccount} = $value if defined($value);
	return ( $self->{_bankAccount} );
}

sub bankAccountJob {
	my ( $self, $value ) = @_;
	$self->{_bankAccountJob} = $value if defined($value);
	return ( $self->{_bankAccountJob} );
}

sub bankAccountName {
	my ( $self, $value ) = @_;
	$self->{_bankAccountName} = $value if defined($value);
	return ( $self->{_bankAccountName} );
}

sub updateCnt {
	my ( $self, $value ) = @_;
	$self->{_updateCnt} = $value if defined($value);
	return ( $self->{_updateCnt} );
}

sub deleteCnt {
	my ( $self, $value ) = @_;
	$self->{_deleteCnt} = $value if defined($value);
	return ( $self->{_deleteCnt} );
}

sub totalCnt {
	my ( $self, $value ) = @_;
	$self->{_totalCnt} = $value if defined($value);
	return ( $self->{_totalCnt} );
}

sub incrDeleteCnt {
	my ($self) = @_;
	$self->{_deleteCnt}++;
}

sub incrTotalCnt {
	my ($self) = @_;
	$self->{_totalCnt}++;
}

sub incrUpdateCnt {
	my ($self) = @_;
	$self->{_updateCnt}++;
}

sub checkDeleteThreshold {
	my ($self) = @_;
	###check if we are overriding delete threshold logic via the existence of a temporary
	###file
	my ( $pkg, $file, $line ) = caller;
	my $bfile                  = basename($file);
	my $filePrefix             = substr( $bfile, 0, index( $bfile, '.' ) );
	my $deleteOverrideFileName =
	  '/tmp/' . $filePrefix . '_' . $self->bankAccountName . '.deleteOverride';
	if ( -e $deleteOverrideFileName ) {
		### override delete logic
		logMsg("**** Delete threshold check overridden ****");
		return 0;
	}
	###If total number of records processed is greater that 1000, then we do not want to
	###process more than 15% delete records - this may indicate a bad input file
	if ( $self->totalCnt > 1000
		&& ( $self->deleteCnt > ( $self->totalCnt * 0.15 ) ) )
	{
		dlog("**** Exceeded delete threshold ****");
		return 1;
	}
	else {
		dlog("**** ok to process delete records ****");
		return 0;
	}
}
1;
