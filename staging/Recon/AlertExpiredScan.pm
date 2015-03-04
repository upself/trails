package Recon::AlertExpiredScan;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Customer;
use Recon::Validation;
use Recon::OM::AlertExpiredScan;
use Recon::OM::AlertExpiredScanHistory;
use Recon::CauseCode;

sub new {
	my ( $class, $connection, $softwareLpar, $isValidScantime ) = @_;
	my $self = {
		_connection      => $connection,
		_softwareLpar    => $softwareLpar,
		_isValidScantime => $isValidScantime
	};
	bless $self, $class;

	$self->validate;

	return $self;
}

sub validate {
	my $self = shift;

	croak 'Connection is undefined'
		unless defined $self->connection;

	croak 'SoftwareLpar is undefined'
		unless defined $self->softwareLpar;
}

sub recon {
	my $self = shift;
	ilog('Begin recon method of AlertExpiredScan');

	ilog('Acquiring Customer');
	my $customer = new BRAVO::OM::Customer();
	$customer->id( $self->softwareLpar->customerId );
	$customer->getById( $self->connection );
	dlog( $customer->toString );
	ilog('Customer acquired');

	###Setup validation object
	my $validation = new Recon::Validation();
	$validation->customer($customer);
	$validation->softwareLpar( $self->softwareLpar );

	###Open/Close alert based on validation
	if ( $self->isValidScantime == 0 ) {
		$self->closeAlert(0);
	}
	elsif ($validation->isValidCustomer == 0
		|| $validation->isValidSoftwareLpar == 0 )
	{
		$self->closeAlert(0);
	}
	elsif ( $self->isScanExpired == 0 ) {
		$self->closeAlert(0);
	}
	else {
		$self->openAlert;
	}

	ilog('Recon method of AlertExpiredScan complete');
}

sub isScanExpired {
	my $self = shift;
	dlog("begin isScanExpired method of AlertExpiredScan");

	my $diff;
	$self->connection->prepareSqlQuery( $self->queryIsScanExpired() );
	my $sth = $self->connection->sql->{isScanExpired};
	$sth->bind_columns( \$diff );
	$sth->execute( $self->softwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;

	if ( defined $diff ) {
		if ( $diff >= 0 ) {
			return 0;
		}
		else {
			return 1;
		}
	}
	else {
		die "Unable to query isScanExpired for software lpar id: "
			. $self->softwareLpar->id . " !";
	}

	ilog("isScanExpired method of AlertExpiredScan complete");
	return;
}

sub queryIsScanExpired {
	my $query = '
        select
            (coalesce ( integer(c.scan_validity), 365 ) - timestampdiff(16, char(current timestamp - sl.scantime)))
        from
            software_lpar sl
            join customer c on c.customer_id = sl.customer_id
        where
            sl.id = ?
        with ur
    ';
	return ( 'isScanExpired', $query );
}

sub openAlert {
	my $self = shift;
	ilog('Begin open alert method of AlertExpiredScan');

	ilog('Obtaining AlertExpiredScan from db');
	my $alert = new Recon::OM::AlertExpiredScan();
	$alert->softwareLparId( $self->softwareLpar->id );
	$alert->getByBizKey( $self->connection );
	ilog('Obtained AlertExpiredScan from db');

	return if ( defined $alert->id && $alert->open == 1 );

	$self->recordHistory($alert) if defined $alert->id;

	$alert->creationTime( currentTimeStamp() );
	$alert->comments('Auto Open');
	$alert->open(1);
	$alert->save( $self->connection );
	
	Recon::CauseCode::updateCCtable( $alert->id, 6, $self->connection );

	ilog('OpenAlert method of AlertExpiredScan complete');
}

sub closeAlert {
	my ( $self, $save ) = @_;
	ilog('Begin closeAlert method of AlertExpiredScan');

	ilog('Obtaining AlertExpiredScan from db');
	my $alert = new Recon::OM::AlertExpiredScan();
	$alert->softwareLparId( $self->softwareLpar->id );
	$alert->getByBizKey( $self->connection );
	ilog('Obtained AlertExpiredScan from db');

	return if ( defined $alert->id && $alert->open == 0 );

	if ( defined $alert->id ) {
		$self->recordHistory($alert);
		$save = 1;
	}
	else {
		$alert->creationTime( currentTimeStamp() );
	}

	$alert->comments('Auto Close');
	$alert->open(0);
	$alert->save( $self->connection ) if $save == 1;
	
	Recon::CauseCode::updateCCtable( $alert->id, 6, $self->connection ) if ( $save == 1 );

	ilog('CloseAlert method of AlertExpiredScan complete');
}

sub recordHistory {
	my ( $self, $alert ) = @_;
	ilog('Begin recordHistory method of AlertExpiredScan');

	my $history = new Recon::OM::AlertExpiredScanHistory();
	$history->alertExpiredScanId( $alert->id );
	$history->creationTime( $alert->creationTime );
	$history->comments( $alert->comments );
	$history->open( $alert->open );
	$history->recordTime( $alert->recordTime );
	$history->save( $self->connection );

	ilog('Complete recordHistory method of AlertExpiredScan');
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

sub softwareLpar {
	my $self = shift;
	$self->{_softwareLpar} = shift if scalar @_ == 1;
	return $self->{_softwareLpar};
}
sub isValidScantime {
    my $self = shift;
    $self->{_isValidScantime} = shift if scalar @_ == 1;
    return $self->{_isValidScantime};
}
1;
