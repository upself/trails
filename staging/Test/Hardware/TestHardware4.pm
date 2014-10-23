package Test::Hardware::TestHardware4;

use strict;
use Database::Connection;
use Staging::OM::Hardware;
use Staging::OM::HardwareLpar;
use BRAVO::Loader::Hardware;
use BRAVO::OM::Hardware;
use BRAVO::OM::HardwareLpar;
use Recon::OM::ReconHardwareLpar;

use base qw(Test::Class);
use Test::More;
############
#setup
############
 sub setup_initConnection : Test(setup){
	my $self = shift;
	$self->{stagingConnection} = Database::Connection->new('staging');
	$self->{bravoConnection}   = Database::Connection->new('trails');
}

############
#test sub
############
# Test case: Change Hardware for a given Hardware Lpar within same customer where the new Hardware has status of HWCOUNT should close alert
 sub test_ChangeLparHWId : Test(2) {
	my $self = shift;
	
	my $stagingHWLparId = 443626;	
	my $oldLparHWId = 501703;
	my $newLparHWId = 446225;	
	#update hardware_id for a given Hardware Lpar	
    my $stagingHWLpar = new Staging::OM::HardwareLpar();
	$stagingHWLpar->id($stagingHWLparId);
	$stagingHWLpar->getById( $self->{stagingConnection} );
	die "Staging hw lpar doesn't exist!!\n" unless defined $stagingHWLpar->id;
	die "Staging HARDWARE_ID != $oldLparHWId!!\n" unless $stagingHWLpar->hardwareId == $oldLparHWId;
	diag($stagingHWLpar->toString);
	$stagingHWLpar->hardwareId( $newLparHWId );
	$stagingHWLpar->save( $self->{stagingConnection} );
	$self->{stagingHWLpar} = $stagingHWLpar;
	diag($stagingHWLpar->toString);
	
	
	my $stagingNewHW = new Staging::OM::Hardware();
	$stagingNewHW->id($newLparHWId);
	$stagingNewHW->getById( $self->{stagingConnection} );
	die "Staging new hw doesn't exist!!\n" unless defined $stagingNewHW->id;
	die "Staging new hw HARDWARE_STATUS != 'HWCOUNT'" unless $stagingNewHW->hardwareStatus eq 'HWCOUNT';
	diag($stagingNewHW->toString);
	
	my $bravoNewHardware = new BRAVO::OM::Hardware();
    $bravoNewHardware->machineTypeId( $stagingNewHW->machineTypeId );
    $bravoNewHardware->serial( $stagingNewHW->serial );
    $bravoNewHardware->country( $stagingNewHW->country );
    $bravoNewHardware->getByBizKey( $self->{bravoConnection} );
    diag( $bravoNewHardware->toString );
    die "Bravo new hw lpar doesn't exist!!\n" unless defined $bravoNewHardware->id;

    my $bravoHwLparLoader = new BRAVO::Loader::HardwareLpar(
		$self->{stagingConnection},
		$self->{bravoConnection},
		$stagingHWLpar,
		$bravoNewHardware
	);
 
	$bravoHwLparLoader->logic;
    $bravoHwLparLoader->save;
    
    my $stagingOldHW = new Staging::OM::Hardware();
	$stagingOldHW->id($oldLparHWId);
	$stagingOldHW->getById( $self->{stagingConnection} );
	die "Staging old hw doesn't exist!!\n" unless defined $stagingOldHW->id;
	
	my $bravoOldHardware = new BRAVO::OM::Hardware();
    $bravoOldHardware->machineTypeId( $stagingOldHW->machineTypeId );
    $bravoOldHardware->serial( $stagingOldHW->serial );
    $bravoOldHardware->country( $stagingOldHW->country );
    $bravoOldHardware->getByBizKey( $self->{bravoConnection} );
    diag( $bravoOldHardware->toString );
    die "Bravo old hw lpar doesn't exist!!\n" unless defined $bravoOldHardware->id;
    
    $self->{bravoHWLpar} = $bravoHwLparLoader->bravoHardwareLpar;
    
	my $bravoHwLparId = $bravoHwLparLoader->bravoHardwareLpar->id;
	
	$self->{hwLparReconId} = $self->getBravoObjReconQueueId( $bravoHwLparId, 'hwLpar' );
	ok( defined $self->{hwLparReconId}, "Updated hardware lpar in recon queue, id=$self->{hwLparReconId}" );
	
	$self->{oldHWReconId} = $self->getBravoObjReconQueueId( $bravoOldHardware->id, 'hw' );
	ok( defined $self->{oldHWReconId}, "Old hardware in recon queue, id=$self->{oldHWReconId}" );
    #diag("hwReconId = $self->{hwReconId}");
 }

# clear all test data in staging db.
sub teardown01_RollbackStagingDB : Test( teardown ) {
	my $self              = shift;
	my $stagingConnection = $self->{stagingConnection};
	
	my $stagingHWLparId = 443626;	
	my $oldLparHWId = 501703;
	#update hardware_id for a given Hardware Lpar	
    my $stagingHWLpar = new Staging::OM::HardwareLpar();
	$stagingHWLpar->id($stagingHWLparId);
	$stagingHWLpar->getById( $self->{stagingConnection} );
	die "Staging hw lpar doesn't exist!!\n" unless defined $stagingHWLpar->id;
	$stagingHWLpar->hardwareId( $oldLparHWId );
	$stagingHWLpar->save( $self->{stagingConnection} );
	diag("Rollback Staging hardware_id for hardware lpar to ACTIVE successfully!");
}

# clear all test data in bravo db.
#sub teardown02_cleanBravoDB : Test( teardown => 1 ) {
#	my $self            = shift;
#	my $bravoConnection = $self->{bravoConnection};
#
#	#Remove the inserted hardware recon.
#	$bravoConnection->prepareSqlQuery( $self->queryDeleteReconHWQueue() );
#	my $sth = $bravoConnection->sql->{removeReconHWQueue};
#	$sth->execute( $self->{hwReconId} );
#	$sth->finish();
#
#	$self->{hwReconId} =
#	  $self->getBravoObjReconQueueId( $self->{bravoHW}->id, 'hw' );
#	ok( !defined $self->{hwReconId},
#		'remove test hardware in recon queue. id=' . $self->{bravoHW}->id );
#
#	#Remove the inserted hardwareLpar recon.
#	$bravoConnection->prepareSqlQuery( $self->queryDeleteReconHWLparQueue() );
#	$sth = $bravoConnection->sql->{removeReconHWLparQueue};
#	$sth->execute( $self->{hwLparReconId} );
#	$sth->finish();
#
#	$self->{hwLparReconId} =
#	  $self->getBravoObjReconQueueId( $self->{bravoHWLpar}->id, 'hwLpar' );
#	
#	ok(
#		!defined $self->{hwLparReconId},
#		'remove test hardware lpar in recon queue. id='
#		  . $self->{bravoHWLpar}->id
#	);
#
#	#Remove the inserted hardwareLpar.
#	$bravoConnection->prepareSqlQuery( $self->queryDeleteBravoHardwareLpar() );
#	$sth = $bravoConnection->sql->{removeBravoHWLpar};
#	$sth->execute( $self->{bravoHWLpar}->id );
#	$sth->finish();
#
#	ok(
#		!$self->existBravoObjById( $self->{bravoHWLpar}->id, 'hardwareLpar' ),
#		'remove test hardware lpar in barvo. id=' . $self->{bravoHWLpar}->id
#	);
#
#	#Remove the inserted hardware.
#	$bravoConnection->prepareSqlQuery( $self->queryDeleteBravoHardware() );
#	$sth = $bravoConnection->sql->{removeBravoHW};
#	$sth->execute( $self->{bravoHW}->id );
#	$sth->finish();
#
#	ok(
#		!$self->existBravoObjById( $self->{bravoHW}->id, 'hardware' ),
#		'remove test hardware in barvo. id=' . $self->{bravoHW}->id
#	);
#
#}

  sub teardown03_closeConnection : Test(teardown) {
     my $self            = shift;
     $self->{stagingConnection}->disconnect;
     $self->{bravoConnection}->disconnect;
 }
###############
#Check if the hw exist in staging db.
sub existStagingObjExistById {
	my ( $self, $id, $type ) = @_;

	my $obj;
	if ( $type eq 'hardware' ) {
		$obj = new Staging::OM::Hardware();
	}
	if ( $type eq 'hardwareLpar' ) {
		$obj = new Staging::OM::HardwareLpar();
	}

	if ( !defined $obj ) { return 0; }

	$obj->id($id);
	$obj->getById( $self->{stagingConnection} );

	return defined $obj->customerId;
}

#Check if the hw exist in bravo db.
sub existBravoObjById {
	my ( $self, $id, $type ) = @_;

	my $checkExist;
	if ( $type eq 'hardware' ) {
		$checkExist = new BRAVO::OM::Hardware();
	}
	if ( $type eq 'hardwareLpar' ) {
		$checkExist = new BRAVO::OM::HardwareLpar();
	}

	if ( !defined $checkExist ) { return 0; }

	$checkExist->id($id);
	$checkExist->getById( $self->{bravoConnection} );

	return defined $checkExist->customerId;
}

sub getBravoObjReconQueueId {
	my ( $self, $id, $type ) = @_;

	my $recon;
	if ( $type eq 'hwLpar' ) {
		$recon = new Recon::OM::ReconHardwareLpar();
		$recon->hardwareLparId($id);
		$recon->action('UPDATE');
		$recon->getByBizKey( $self->{bravoConnection} );
	}

	if ( $type eq 'hw' ) {
		$recon = new Recon::OM::ReconHardware();
		$recon->hardwareId($id);
		$recon->action('UPDATE');
		$recon->getByBizKey( $self->{bravoConnection} );
	}

	if ( !defined $recon ) {
		return 0;
	}

	return $recon->id;
}

sub queryDeleteStagingHardware {
	my $query = 'delete from hardware where id=?';
	return ( 'removeStagingHW', $query );
}

sub queryDeleteStagingHardwareLpar {
	my $query = 'delete from hardware_lpar where id=?';
	return ( 'removeStagingHWLpar', $query );
}

sub queryDeleteBravoHardware {
	my $query = 'delete from hardware where id=?';
	return ( 'removeBravoHW', $query );
}

sub queryDeleteBravoHardwareLpar {
	my $query = 'delete from hardware_lpar where id=?';
	return ( 'removeBravoHWLpar', $query );
}

sub queryDeleteReconHWQueue {
	my $query = 'delete from recon_hardware where id=?';
	return ( 'removeReconHWQueue', $query );
}

sub queryDeleteReconHWLparQueue {
	my $query = 'delete from recon_hw_lpar where id=?';
	return ( 'removeReconHWLparQueue', $query );
}

1;