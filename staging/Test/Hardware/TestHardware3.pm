package Test::Hardware::TestHardware3;

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
#Test Case: New Hardware coming in as HWCOUNT should not generate HW LPAR without SW LPAR alerts
#Ensure that your test case compares against a current open HW LPAR without SW LPAR alert
 sub test_AddHardware : Test(4) {
 	my $self = shift;
 	
	#insert a new hardware into staging
	my $stagingHW = new Staging::OM::Hardware();
	$stagingHW->machineTypeId(1764);
	$stagingHW->serial('UTSerial');
	$stagingHW->country('SG');
	$stagingHW->owner('IBM');
	$stagingHW->customerNumber('0987654');
	$stagingHW->hardwareStatus('HWCOUNT');
	$stagingHW->status('ACTIVE');
	$stagingHW->updateDate('11/18/2009');
	$stagingHW->action('COMPLETE');
	$stagingHW->customerId(2541);
	$stagingHW->processorCount(4);
	$stagingHW->model('UTModel');
	$stagingHW->classification('OEM SERVER');
	$stagingHW->chips(10);
	$stagingHW->processorType('0');
	$stagingHW->save( $self->{stagingConnection} );

	$self->{stagingHW} = $stagingHW;

	#check if the hardware is inserted into staging db
	my $result1 = $self->existStagingObjExistById( $stagingHW->id, 'hardware' );
	my $stagingHWId = $stagingHW->id;
	ok( $result1, "Insert a new hardware into staging, id= $stagingHWId");
	die "Failed to insert hardware into staging!!\n" unless $result1;
	
	#insert a new hardware lpar into staging 	
    my $stagingHWLpar = new Staging::OM::HardwareLpar();
	$stagingHWLpar->name('SHIEL_TEST1');
	$stagingHWLpar->customerId( $stagingHW->customerId );
	$stagingHWLpar->hardwareId( $stagingHW->id );
	$stagingHWLpar->status('ACTIVE');
	$stagingHWLpar->action('COMPLETE');
	$stagingHWLpar->updateDate('11/18/2009');

	$stagingHWLpar->save( $self->{stagingConnection} );
	$self->{stagingHWLpar} = $stagingHWLpar;
	
    #check if the hardware is inserted into staging db
    my $result2 = $self->existStagingObjExistById( $stagingHWLpar->id, 'hardwareLpar' );
    my $stagingHWLparId = $stagingHWLpar->id;
	ok( $result2, "Insert a new hardware lpar into staging, id= $stagingHWLparId" );
	die "Failed to insert hardware into staging!!\n"
	  unless $result2;
	  
	my $bravoHwLoader = new BRAVO::Loader::Hardware(
		$self->{stagingConnection},
		$self->{bravoConnection},
		$stagingHW
	);
 
	$bravoHwLoader->logic;
    $bravoHwLoader->save;
    
    $self->{bravoHW} = $bravoHwLoader->bravoHardware;
    
	my $bravoHwId = $bravoHwLoader->bravoHardware->id;
	my $bravoHwLparId;
	foreach my $bravoHwLparLoader ( @{ $bravoHwLoader->hardwareLparLoaders } ) {
		$bravoHwLparId = $bravoHwLparLoader->bravoHardwareLpar->id;
		$self->{bravoHWLpar} = $bravoHwLparLoader->bravoHardwareLpar;
	}
	
	$self->{hwReconId} = $self->getBravoObjReconQueueId( $bravoHwId, 'hw' );
	$self->{hwLparReconId} = $self->getBravoObjReconQueueId( $bravoHwLparId, 'hwLpar' );
	
	ok( defined $self->{hwReconId}, "New hardware in recon queue, id=$self->{hwReconId}" );
	ok( defined $self->{hwLparReconId}, "New hardware lpar in recon queue, id=$self->{hwLparReconId}" );
 }

############
#teardown
############
# clear all test data in staging db.
sub teardown01_cleanStagingDB : Test( teardown => 2 ) {
	my $self              = shift;
	my $stagingConnection = $self->{stagingConnection};

	#Remove the inserted hardwareLpar.
	$stagingConnection->prepareSqlQuery(
		$self->queryDeleteStagingHardwareLpar() );
	my $sth = $stagingConnection->sql->{removeStagingHWLpar};
	$sth->execute( $self->{stagingHWLpar}->id );
	$sth->finish();

	ok(
		!$self->existStagingObjExistById(
			$self->{stagingHWLpar}->id,
			'hardwareLpar'
		),
		'Remove test hardware lpar in staging. id=' . $self->{stagingHWLpar}->id
	);

	#Remove the inserted hardware.
	$stagingConnection->prepareSqlQuery( $self->queryDeleteStagingHardware() );
	$sth = $stagingConnection->sql->{removeStagingHW};
	$sth->execute( $self->{stagingHW}->id );
	$sth->finish();

	ok(
		!$self->existStagingObjExistById( $self->{stagingHW}->id, 'hardware' ),
		'Remove test hardware in staging. id=' . $self->{stagingHW}->id
	);

}

# clear all test data in bravo db.
sub teardown02_cleanBravoDB : Test( teardown => 4 ) {
	my $self            = shift;
	my $bravoConnection = $self->{bravoConnection};

	#Remove the inserted hardware recon.
	$bravoConnection->prepareSqlQuery( $self->queryDeleteReconHWQueue() );
	my $sth = $bravoConnection->sql->{removeReconHWQueue};
	$sth->execute( $self->{hwReconId} );
	$sth->finish();

	$self->{hwReconId} =
	  $self->getBravoObjReconQueueId( $self->{bravoHW}->id, 'hw' );
	ok( !defined $self->{hwReconId},
		'Remove test hardware in recon queue. id=' . $self->{bravoHW}->id );

	#Remove the inserted hardwareLpar recon.
	$bravoConnection->prepareSqlQuery( $self->queryDeleteReconHWLparQueue() );
	$sth = $bravoConnection->sql->{removeReconHWLparQueue};
	$sth->execute( $self->{hwLparReconId} );
	$sth->finish();

	$self->{hwLparReconId} =
	  $self->getBravoObjReconQueueId( $self->{bravoHWLpar}->id, 'hwLpar' );
	
	ok(
		!defined $self->{hwLparReconId},
		'Remove test hardware lpar in recon queue. id='
		  . $self->{bravoHWLpar}->id
	);

	#Remove the inserted hardwareLpar.
	$bravoConnection->prepareSqlQuery( $self->queryDeleteBravoHardwareLpar() );
	$sth = $bravoConnection->sql->{removeBravoHWLpar};
	$sth->execute( $self->{bravoHWLpar}->id );
	$sth->finish();

	ok(
		!$self->existBravoObjById( $self->{bravoHWLpar}->id, 'hardwareLpar' ),
		'Remove test hardware lpar in barvo. id=' . $self->{bravoHWLpar}->id
	);

	#Remove the inserted hardware.
	$bravoConnection->prepareSqlQuery( $self->queryDeleteBravoHardware() );
	$sth = $bravoConnection->sql->{removeBravoHW};
	$sth->execute( $self->{bravoHW}->id );
	$sth->finish();

	ok(
		!$self->existBravoObjById( $self->{bravoHW}->id, 'hardware' ),
		'Remove test hardware in barvo. id=' . $self->{bravoHW}->id
	);

}

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

#sub removeHwLparReconQueue {
#	my $self = shift;
#
#	my $bravoConnection = $self->{bravoConnection};
#
#	#Remove the inserted hardwareLpar recon.
#	$bravoConnection->prepareSqlQuery( $self->queryDeleteReconHWLparQueue() );
#	my $sth = $bravoConnection->sql->{removeReconHWLparQueue};
#	$sth->execute( $self->{hwLparReconId} );
#	$sth->finish();
#
#	$self->{hwLparReconId} =
#	  $self->getBravoObjReconQueueId( $self->{bravoHWLpar}->id, 'hwLpar' );
#
#}
1;