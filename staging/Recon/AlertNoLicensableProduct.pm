package Recon::AlertNoLicensableProduct;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Customer;
use Recon::Validation;
use Recon::OM::Alert;
use Recon::OM::AlertHistory;
use Recon::OM::AlertSoftwareLparNew;
use Recon::CauseCode;

sub new {
	my ( $class, $connection, $softwareLpar ) = @_;
	my $self = {
		_connection   => $connection,
		_softwareLpar => $softwareLpar
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
	ilog('Begin recon method of AlertNoLicensableProduct');

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
	if (   $validation->isValidCustomer == 0
		|| $validation->isValidSoftwareLpar == 0 )
	{
		$self->closeAlert(0);
	}
	elsif ( $self->hasLP == 1 ) {
		$self->closeAlert(0);
	}
	else {
		$self->openAlert;
	}
}

sub hasLP {
	my $self = shift;
	my $SWcount;
	$self->connection->prepareSqlQuery( $self->queryhasLP() );
	my $sth = $self->connection->sql->{hasLP};
	$sth->bind_columns( \$SWcount );
	$sth->execute( $self->softwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;
    my $test=$self->softwareLpar->id;
	if ( defined $SWcount && $SWcount > 0 ) {
		return 1;
	}
	return 0;
}

sub queryhasLP {
	my $query = '
			select 
                count(*) 
            from  
                ( ( installed_software is join product_info pi on pi.id = is.software_id )
                join kb_definition kbd on kbd.id = is.software_id )
            where 
                is.SOFTWARE_LPAR_ID = ?
                and is.status=\'ACTIVE\'
                and ( ( kbd.deleted is null ) or ( kbd.deleted <> 1 ) )
                and pi.licensable = 1
            with ur;             ';
	return ( 'hasLP', $query );
}

sub getAlert {
	my ( $self, $alertType ) = @_;

	my $id;
	$self->connection->prepareSqlQuery( $self->queryAlertId() );
	my $sth = $self->connection->sql->{alertId};
	$sth->bind_columns( \$id );
	$sth->execute( $self->softwareLpar->id, $alertType );
	$sth->fetchrow_arrayref;
	$sth->finish;
	return $id;
}

sub queryAlertId {
	my $query = '
        select
            a.id
        from
            alert_software_lpar asl
            ,alert a
            ,alert_type at
        where
            asl.software_lpar_id = ?
            and at.code = ?
            and asl.id = a.id
            and a.alert_type_id = at.id
        with ur
    ';
	return ( 'alertId', $query );
}

sub openAlert {
	my $self = shift;

	my $alertId = $self->getAlert('NOLP');
	my $alert   = new Recon::OM::Alert();
	$alert->id($alertId);
	$alert->getById( $self->connection );

	return if ( defined $alert->customerId && $alert->open == 1 );

	$self->recordHistory($alert) if defined $alert->customerId;

	$alert->customerId( $self->softwareLpar->customerId );
	$alert->alertTypeId(11);
	$alert->alertCauseId(1);
	$alert->open(1);
	$alert->creationTime( currentTimeStamp() );
	$alert->recordTime( currentTimeStamp() );
	$alert->remoteUser('STAGING');
	$alert->assignee(undef);
	$alert->comment('Auto Open');
	$alert->save( $self->connection );
	
	Recon::CauseCode::updateCCtable($alert->id, "NOLP", $self->connection );

	my $softwareLparAlert = new Recon::OM::AlertSoftwareLparNew();
	$softwareLparAlert->id( $alert->id );
	$softwareLparAlert->getById( $self->connection );
	return if defined $softwareLparAlert->softwareLparId;
	$softwareLparAlert->softwareLparId( $self->softwareLpar->id );
	$self->saveSoftwareLparAlert($softwareLparAlert);

	ilog('OpenAlert method of AlertNoLicensableProduct complete');
}

sub closeAlert {
	my ( $self, $save ) = @_;
	ilog('Begin closeAlert method of AlertNoLicensableProduct');

	my $alertId = $self->getAlert('NOLP');
	my $alert   = new Recon::OM::Alert();
	$alert->id($alertId);
	$alert->getById( $self->connection );

	return if ( defined $alert->customerId && $alert->open == 0 );

	if ( defined $alert->customerId ) {
		$self->recordHistory($alert);
		$save = 1;
	}
	else {
		$alert->customerId( $self->softwareLpar->customerId );
		$alert->alertTypeId(11);
		$alert->alertCauseId(1);
		$alert->creationTime( currentTimeStamp() );
		$alert->recordTime( currentTimeStamp() );
		$alert->remoteUser('STAGING');
		$alert->assignee(undef);
	}

	$alert->comment('Auto Close');
	$alert->open(0);
	$alert->save( $self->connection ) if $save == 1;
	
	Recon::CauseCode::updateCCtable($alert->id, "NOLP", $self->connection ) if ( $save == 1 );

	my $softwareLparAlert = new Recon::OM::AlertSoftwareLparNew();
	$softwareLparAlert->id( $alert->id );
	$softwareLparAlert->getById( $self->connection );
	return if defined $softwareLparAlert->softwareLparId;
	$softwareLparAlert->softwareLparId( $self->softwareLpar->id );
	$self->saveSoftwareLparAlert($softwareLparAlert) if $save == 1;

	ilog('CloseAlert method of AlertNoLicensableProduct complete');
}

sub saveSoftwareLparAlert {
	my ( $self, $softwareLparAlert ) = @_;

	$self->connection->prepareSqlQuery( $self->insertSoftwareLparAlertNew );
	my $sth = $self->connection->sql->{insertSoftwareLparAlertNew};
	$sth->execute( $softwareLparAlert->id,
		$softwareLparAlert->softwareLparId );
	$sth->finish;
}

sub insertSoftwareLparAlertNew {
	my $query = '
        insert into
            alert_software_lpar
        values(?,?)
    ';
	return ( 'insertSoftwareLparAlertNew', $query );
}

sub recordHistory {
	my ( $self, $alert ) = @_;
	ilog('Begin recordHistory method of AlertNoLicensableProduct');

	my $history = new Recon::OM::AlertHistory();
	$history->alertId( $alert->id );
	$history->customerId( $alert->customerId );
	$history->alertTypeId( $alert->alertTypeId );
	$history->alertCauseId( $alert->alertCauseId );
	$history->open( $alert->open );
	$history->creationTime( $alert->creationTime );
	$history->recordTime( $alert->recordTime );
	$history->remoteUser( $alert->remoteUser );
	$history->assignee( $alert->assignee );
	$history->comment( $alert->comment );
	$history->save( $self->connection );

	ilog('Complete recordHistory method of AlertNoLicensableProduct');
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

1;
