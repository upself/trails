package Test::Common::StagingBasedTest;

use base qw(Test::Class Test::Common::ConnectionManager);
use Test::More;

use Test::Sample::StagingHWSample;
use Test::Sample::StagingHWLparSample;
use Test::Sample::StagingSWLparSample;
use Test::Common::ConnectionManager;

use BRAVO::Loader::Hardware;

# create a new hardware in staging db.
sub startup02_insertStagingHW : Test( startup => 1 ) {
	my $self = shift;

	#insert a make up hardware in staging.
	my $stagingHWSample = new Sample::StagingHWSample;
	$stagingHWSample->connection( $self->getStagingConnection );
	$stagingHWSample->insert;

	#check if the hardware is inserted into staging db.
	ok(
		$stagingHWSample->existLightWeight,
		'insert test hardware into staging.'
	);

	$self->stagingHWSample($stagingHWSample);
}

#insert staging db a  test HW lpar.
sub startup03_insertStagingHWLpar : Test( startup => 1 ) {
	my $self = shift;

	my $stagingHWLparSample = new Sample::StagingHWLparSample;
	$stagingHWLparSample->connection( $self->getStagingConnection );

	$stagingHWLparSample->customerId(
		$self->stagingHWSample->model->customerId );
	$stagingHWLparSample->hardwareId( $self->stagingHWSample->model->id );

	$stagingHWLparSample->insert;

	ok(
		$stagingHWLparSample->existLightWeight,
		'insert test hardware lpar into staging.'
	);

	$self->stagingHWLparSample($stagingHWLparSample);

}

#insert a test sw lpar into staging db.
sub startup04_insertStagingSWLpar : Test( startup => 1 ) {
	my $self = shift;

	my $stagingSWLparSample = new Sample::StagingSWLparSample;

	$stagingSWLparSample->connection( $self->getStagingConnection );
	$stagingSWLparSample->customerId(
		$self->stagingHWSample->model->customerId );

	$stagingSWLparSample->insert;

	ok(
		$stagingSWLparSample->existLightWeight,
		'insert test sw lpar into staging.'
	);

	$self->stagingSWLparSample($stagingSWLparSample);

}

#------------------------
#    end of start up.
#------------------------

# clear all test data in staging db.
sub shutdown01_cleanStagingDB : Test( shutdown => 3 ) {
	my $self = shift;

	#remove test hw lpar.
	$self->stagingHWLparSample->remove;
	ok( !$self->stagingHWLparSample->exist, 'remove test HW lpar in staging.' );

	#remove test sw lpar
	$self->stagingSWLparSample->remove;

	ok( !$self->stagingSWLparSample->exist, 'remove test SW lpar in staging.' );

	#Remove test hw.
	$self->stagingHWSample->remove;
	ok( !$self->stagingHWSample->exist, 'remove test HW in staging.' );
}

#switch the status of staging sample (ACTIVE<->INACTIVE).
sub switchSampleStatus {
	my ( $self, $sample ) = @_;

	#refresh the staging sample in memory from db.
	my $sampleObj = $sample->retrieveModelById;
	my $oldStatus = $sampleObj->status;

	#change current staging obj status.
	if ( $sampleObj->status eq 'ACTIVE' ) {
		$sampleObj->status('INACTIVE');
	}
	else {
		$sampleObj->status('ACTIVE');
	}
	$sampleObj->save( $self->getStagingConnection );

	#refresh the staging sample in memory from db.
	$sampleObj = $sample->retrieveModelById;

	my $newStatus = $sampleObj->status;

	return ( $oldStatus, $newStatus );
}

#change the staging HW status.
sub changeHWStatus {
	my ( $self, $switcher ) = @_;

	my @status = qw( HWCOUNT ACTIVE INACTIVE );
	my @to     = qw( HWCOUNT ACTIVE INACTIVE );

	foreach my $from (@status) {
		my @matches = grep { $_ ne $from } @to;

		foreach my $toStatus (@matches) {
			my $stagingHW = $self->stagingHWSample->retrieveModelById;
			$stagingHW->hardwareStatus($from);
			$stagingHW->save( $self->getStagingConnection );

			$self->beforeHWStatusChange;

			#refresh the staging hw lpar in memory from db.
			$stagingHW = $self->stagingHWSample->retrieveModelById;
			my $oldStatus = $stagingHW->hardwareStatus;

			#change hw status.
			$stagingHW->hardwareStatus($toStatus);
			$stagingHW->save( $self->getStagingConnection );

			#refresh the staging hw lpar in memory from db.
			$stagingHW = $self->stagingHWSample->retrieveModelById;
			my $newStatus = $stagingHW->hardwareStatus;

			$self->afterHWStatusChange( $oldStatus, $newStatus, $switcher );

		}
	}
}

sub stagingHWSample {
	$self = shift;
	if (@_) { $self->{_stagingHWSample} = shift }
	return $self->{_stagingHWSample};
}

sub stagingHWLparSample {
	$self = shift;
	if (@_) { $self->{_stagingHWLparSample} = shift }
	return $self->{_stagingHWLparSample};
}

sub stagingSWLparSample {
	$self = shift;
	if (@_) { $self->{_stagingSWLparSample} = shift }
	return $self->{_stagingSWLparSample};
}
1;
