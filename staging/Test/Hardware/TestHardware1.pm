package Test::Hardware::TestHardware2;

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
#Test Case: Hardware status change from ACTIVE to HWCOUNT results in no open HW LPAR without SW LPAR alerts.
#Ensure that in your test case this one will not match up to a software lpar
 sub test_ChangeStatus2HWCOUNT : Test(3) {
	my $self = shift;
	
	my $stagingHWId = 796153;
	my $stagingHW = new Staging::OM::Hardware();
	$stagingHW->id($stagingHWId);
	my $result1 = $stagingHW->getById( $self->{stagingConnection} );
	die "Staging hw doesn't exist!!\n" unless $result1;
	die "Staging hardware_status != ACTIVE!!\n" unless $stagingHW->hardwareStatus == 'ACTIVE';
	$stagingHW->hardwareStatus('HWCOUNT');
	$stagingHW->save( $self->{stagingConnection} );
	$self->{stagingHW} = $stagingHW;

	#check if the hardware is updated properly in staging db
	my $result2 = $stagingHW->getById( $self->{stagingConnection} );
	die "Failed to get Staging hw!!\n" unless $result2;
	my $stagingHWId = $stagingHW->id;
	ok( $stagingHW->hardwareStatus eq 'HWCOUNT', "Succeeded to update Staging hardware_status to HWCOUNT, id= $stagingHWId");
	die "Failed to update Staging hardware_status to 'HWCOUNT'!!\n" unless $stagingHW->hardwareStatus eq 'HWCOUNT';
    
    my $bravoHwLoader = new BRAVO::Loader::Hardware(
		$self->{stagingConnection},
		$self->{bravoConnection},
		$stagingHW
	);
	$bravoHwLoader->logic;
    $bravoHwLoader->save;
    
    $self->{bravoHW} = $bravoHwLoader->bravoHardware;
    
	my $bravoHwId = $bravoHwLoader->bravoHardware->id;
	diag("bravoHwId = $bravoHwId");
	$self->{hwReconId} = $self->getBravoObjReconQueueId( $bravoHwId, 'hw' );
	ok( defined $self->{hwReconId}, "Hardware in recon queue, id=$self->{hwReconId}" );
    
    #############
    my $hw_lpar_id=984922;
    my $hwLparReconId = $self->getBravoObjReconQueueId( $hw_lpar_id, 'hwLpar' );
   	diag("hwLparId = $hw_lpar_id");
	ok( defined $hw_lpar_id, "Hardware lpar in recon queue, id=$hw_lpar_id" );   
    
 }
 
# clear all test data in staging db.
sub teardown01_RollbackStagingDB : Test( teardown ) {
	my $self              = shift;
	my $stagingConnection = $self->{stagingConnection};
	
 	    my $stagingHWId = 796153;
 	    my $stagingHW = new Staging::OM::Hardware();
        $stagingHW->id($stagingHWId);
        my $result1 = $stagingHW->getById( $stagingConnection );
        die "Staging hw doesn't exist!!\n" unless $result1;
        $stagingHW->hardwareStatus('ACTIVE');
        $stagingHW->save( $stagingConnection );
        diag("Rollback Staging hardware_status to ACTIVE successfully!");
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

	if ( $type eq 'swLpar' ) {
		$recon = new Recon::OM::ReconSoftwareLpar();
		$recon->softwareLparId($id);
		$recon->action('DEEP');
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