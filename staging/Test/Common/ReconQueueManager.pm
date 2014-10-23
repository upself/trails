package Test::Common::ReconQueueManager;

use strict;

use Test::Common::ConnectionManager;

use Recon::OM::ReconHardware;
use Recon::OM::ReconHardwareLpar;
use Recon::OM::ReconSoftwareLpar;

my $connection = sub {
	return new Test::Common::ConnectionManager->getBravoConnection;
};

sub reconHWQueue {
	my $self = shift;
	if (@_) { $self->{_reconHWQueue} = shift }
	return $self->{_reconHWQueue};
}

sub reconHWLparQueue {
	my $self = shift;
	if (@_) { $self->{_reconHWLparQueue} = shift }
	return $self->{_reconHWLparQueue};
}

sub reconSWLparQueue {
	my $self = shift;
	if (@_) { $self->{_reconSWLparQueue} = shift }
	return $self->{_reconSWLparQueue};
}

sub isHWReconExist {
	my ( $self, $id ) = @_;

	my $hwRecon = new Recon::OM::ReconHardware();
	$hwRecon->id($id);
	$hwRecon->getById( $self->$connection() );

	return defined $hwRecon->customerId;
}

sub isSWLparReconExist {

	my ( $self, $id ) = @_;

	my $swLparRecon = new Recon::OM::ReconSoftwareLpar;
	$swLparRecon->id($id);
	$swLparRecon->getById( $self->$connection() );

	return defined $swLparRecon->customerId;
}

sub isHWLparReconExist {
	my ( $self, $id ) = @_;

	my $hwLparRecon = new Recon::OM::ReconHardwareLpar;
	$hwLparRecon->id($id);
	$hwLparRecon->getById( $self->$connection() );

	return defined $hwLparRecon->customerId;
}

sub getReconQueueByHW {
	my ( $self, $id, $action ) = @_;

	my $hwRecon = new Recon::OM::ReconHardware;
	$hwRecon->id(undef);
	$hwRecon->hardwareId($id);
	$hwRecon->action($action);
	$hwRecon->getByBizKey( $self->$connection() );

	return $hwRecon;
}

sub getReconQueueByHWLpar {
	my ( $self, $id, $action ) = @_;

	my $hwLparRecon = new Recon::OM::ReconHardwareLpar;
	$hwLparRecon->id(undef);
	$hwLparRecon->hardwareLparId($id);
	$hwLparRecon->action($action);
	$hwLparRecon->getByBizKey( $self->$connection() );

	return $hwLparRecon;
}

sub getReconQueueBySWLpar {
	my ( $self, $id, $action ) = @_;

	my $swLparRecon = new Recon::OM::ReconSoftwareLpar;
	$swLparRecon->id(undef);
	$swLparRecon->softwareLparId($id);
	$swLparRecon->action($action);
	$swLparRecon->getByBizKey( $self->$connection() );

	return $swLparRecon;
}

sub deleteSWLparReconQueueById {
	my ( $self, $id ) = @_;
	my $reconSWLpar = new Recon::OM::ReconSoftwareLpar;
	$reconSWLpar->id($id);
	$reconSWLpar->delete( $self->$connection() );
}

sub deleteHWLparReconQueueById {
	my ( $self, $id ) = @_;
	my $reconHWLpar = new Recon::OM::ReconHardwareLpar;
	$reconHWLpar->id($id);
	$reconHWLpar->delete( $self->$connection() );
}

sub deleteHWReconQueueById {
	my ( $self, $id ) = @_;
	my $reconHW = new Recon::OM::ReconHardware;
	$reconHW->id($id);
	$reconHW->delete( $self->$connection() );
}

sub cleanReconDB {
	my $self = shift;

	#remove the hw recon queue.
	if ( defined $self->reconHWQueue ) {
		$self->deleteHWReconQueueById( $self->reconHWQueue->id );
	}

	#remove the hw lpar recon queue.
	if ( defined $self->reconHWLparQueue ) {
		$self->deleteHWLparReconQueueById( $self->reconHWLparQueue->id );
	}

	#remove the hw recon queue.
	if ( defined $self->reconSWLparQueue ) {
		$self->deleteSWLparReconBySWLparId(
			$self->reconSWLparQueue->softwareLparId );
	}

}

sub deleteSWLparReconBySWLparId {
	my ( $self, $swLparId ) = @_;

	my $conn = $self->$connection();
	$conn->prepareSqlQuery( 'delSWLparRecon',
		'delete from recon_sw_lpar where software_lpar_id =?' );
	my $sth = $conn->sql->{delSWLparRecon};
	$sth->execute( $swLparId );
	$sth->finish;
}

1;
