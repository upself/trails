package Recon::Queue;

use strict;
use Carp qw( croak );
use Base::Utils;
use Recon::OM::ReconCustomer;
use Recon::OM::ReconHardware;
use Recon::OM::ReconHardwareLpar;
use Recon::OM::ReconSoftwareLpar;
use Recon::OM::ReconInstalledSoftware;
use Recon::OM::ReconLicense;
use Recon::OM::ReconSoftware;

sub new {
	my ( $class, $connection, $object, $subObject, $action ) = @_;
	my $self = {
		_connection => $connection,
		_object     => $object,
		_subObject  => $subObject,
		_action     => $action
	};
	bless $self, $class;

	$self->validate;

	return $self;
}

sub add {
	my $self = shift;

	if (   $self->object->isa("BRAVO::OM::Customer")
		&& ( defined $self->subObject
			&& $self->subObject->isa("BRAVO::OM::Software") )
		)
	{
		$self->addCustomerSoftwareToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::Customer") ) {
		$self->addCustomerToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::Hardware") ) {
		$self->addHardwareToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::HardwareLpar") ) {
		$self->addHardwareLparToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::SoftwareLpar") ) {
		$self->addSoftwareLparToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::InstalledSoftware") ) {
		$self->addInstalledSoftwareToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::License") ) {
		$self->addLicenseToQueue;
	}

	if ( $self->object->isa("BRAVO::OM::Software") ) {
		$self->addSoftwareToQueue;
	}
}

sub addCustomerToQueue {
	my $self = shift;

	ilog("Entering addCustomerToQueue method of Recon::Queue");

	ilog("Checking for existing customer in queue");
	my $recon = new Recon::OM::ReconCustomer();
	$recon->customerId( $self->object->id );
	$recon->action('UPDATE');
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("Customer does not exist in queue...saving");
		$recon->save( $self->connection );
		ilog("Customer inserted into queue");
	}
	else {
		ilog("Customer already exists in queue");
	}
}

sub addHardwareToQueue {
	my $self = shift;

	ilog("Entering addHardwareToQueue method of Recon::Queue");

	ilog("Checking for existing hardware in queue");
	my $recon = new Recon::OM::ReconHardware();
	$recon->hardwareId( $self->object->id);
	$recon->action($self->object->action);
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("Hardware does not exist in queue...saving");
		$recon->customerId( $self->object->customerId );
		$recon->save( $self->connection );
		ilog("Hardware inserted into queue");
	}
	else {
		ilog("Hardware already exists in queue");
	}
}

sub addHardwareLparToQueue {
	my $self = shift;

	ilog("Entering addHardwareLparToQueue method of Recon::Queue");

	ilog("Checking for existing hardware lpar in queue");
	my $recon = new Recon::OM::ReconHardwareLpar();
	$recon->hardwareLparId( $self->object->id );
	$recon->action($self->object->action);
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("Hardware lpar does not exist in queue...saving");
		$recon->customerId( $self->object->customerId );
		$recon->save( $self->connection );
		ilog("Hardware lpar inserted into queue");
	}
	else {
		ilog("Hardware lpar already exists in queue");
	}
}

sub addSoftwareLparToQueue {
	my $self = shift;

	ilog("Entering addSoftwareLparToQueue method of Recon::Queue");
	
	return  if( $self->object->customerId == 999999 );

	ilog("Checking for existing software lpar in queue");
	my $recon = new Recon::OM::ReconSoftwareLpar();
	$recon->softwareLparId( $self->object->id );
	if ( defined $self->action ) {
		$recon->action( $self->action );
	}
	else {
		$recon->action('UPDATE');
	}
	$recon->getByBizKey( $self->connection );
	
	if ( !defined $recon->id ) {
		ilog("Software lpar does not exist in queue...saving");
		$recon->customerId( $self->object->customerId );
		$recon->save( $self->connection );
		ilog("Software lpar inserted into queue");
	}
	else {
		ilog("Software lpar already exists in queue");
	}
}

sub addInstalledSoftwareToQueue {
	my $self = shift;

	ilog("Entering addInstalledSoftwareToQueue method of Recon::Queue");

	croak 'Software Lpar not defined' if !defined $self->subObject;
	
	return if( $self->subObject->customerId == 999999);

	ilog("Checking for existing installed software in queue");
	my $recon = new Recon::OM::ReconInstalledSoftware();
	$recon->installedSoftwareId( $self->object->id );
	$recon->action('UPDATE');
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("Installed Software does not exist in queue...saving");
		$recon->customerId( $self->subObject->customerId );
		$recon->save( $self->connection );
		ilog("Installed Software inserted into queue");
	}
	else {
		ilog("Installed Software already exists in queue");
	}
}

sub addLicenseToQueue {
	my $self = shift;

	ilog("Entering addLicenseToQueue method of Recon::Queue");

	ilog("Checking for existing license in queue");
	my $recon = new Recon::OM::ReconLicense();
	$recon->licenseId( $self->object->id );
	
	if (defined $self->action) {
		$recon->action($self->action);
	}
	else {
		$recon->action('UPDATE');
	}
	
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("License does not exist in queue...saving");
		$recon->customerId( $self->object->customerId );
		$recon->save( $self->connection );
		ilog("License inserted into queue");
	}
	else {
		ilog("License already exists in queue");
	}
}

sub addSoftwareToQueue {
	my $self = shift;

	ilog("Entering addSoftwareToQueue method of Recon::Queue");

	ilog("Checking for existing software in queue");
	my $recon = new Recon::OM::ReconSoftware();
	$recon->softwareId( $self->object->id );
	$recon->action('UPDATE');
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("Software does not exist in queue...saving");
		$recon->save( $self->connection );
		ilog("Software inserted into queue");
	}
	else {
		ilog("Software already exists in queue");
	}
}

sub addCustomerSoftwareToQueue {
	my $self = shift;

	ilog("Entering addCustomerSoftwareToQueue method of Recon::Queue");

	croak 'Software not defined' if !defined $self->subObject;

	ilog("Checking for existing in queue");
	my $recon = new Recon::OM::ReconCustomerSoftware();
	$recon->customerId( $self->object->id );
	$recon->softwareId( $self->subObject->id );
	$recon->action('UPDATE');
	$recon->getByBizKey( $self->connection );

	if ( !defined $recon->id ) {
		ilog("Customer software does not exist in queue...saving");
		$recon->save( $self->connection );
		ilog("Customer software inserted into queue");
	}
	else {
		ilog("Customer software already exists in queue");
	}
}

sub validate {
	my $self = shift;

	croak 'Connection not defined' if !defined $self->connection;

	croak 'Object not defined' if !defined $self->object;
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

sub object {
	my $self = shift;
	$self->{_object} = shift if scalar @_ == 1;
	return $self->{_object};
}

sub subObject {
	my $self = shift;
	$self->{_subObject} = shift if scalar @_ == 1;
	return $self->{_subObject};
}

sub action {
	my $self = shift;
	$self->{_action} = shift if scalar @_ == 1;
	return $self->{_action};
}

1;
