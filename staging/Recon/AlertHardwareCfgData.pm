package Recon::AlertHardwareCfgData;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::Validation;
use Recon::OM::AlertHardwareCfgData;
use Recon::OM::AlertHardwareCfgDataHistory;
use Recon::CauseCode;

sub new {
    my ( $class, $connection, $hardware ) = @_;
    my $self = {
                 _connection => $connection,
                 _hardware   => $hardware
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Hardware is undefined'
      unless defined $self->hardware;
}

sub recon {
    my $self = shift;

    my $customer = new BRAVO::OM::Customer();
    $customer->id($self->hardware->customerId);
    $customer->getById( $self->connection );

    my $validation = new Recon::Validation();
    $validation->customer( $customer );
    $validation->hardware( $self->hardware );
    
    dlog("Reconing hardware configuration data...");

    if ( $validation->isValidCustomer == 0 || $validation->isValidHardware == 0 || $self->hardwareLparCount == 0 ) {
        $self->closeAlert(0);
        dlog("Invalid hardware.");
        return;
    }
    
    my $machineType=$self->findMachineType( $self->hardware->machineTypeId );
    
    dlog("Found machine type: $machineType");
    
    if ( $machineType eq "WORKSTATION" ) {
		dlog("WORKSTATION doesn't need any config data filled.");
		$self->closeAlert(0);
		return;
	}
	
	my $letsopen = 0; # the AlertHardwareCfgData should be open in the end
    
    if (( $machineType eq "SERVER" ) || ( $machineType eq "AS/400" )) {
		dlog("SERVER or AS/400, checking attributes...");
		$letsopen = 1 if (( not defined $self->hardware->processorManufacturer ) || ( $self->hardware->processorManufacturer =~ /^\s*$/ ));
		$letsopen = 1 if (( not defined $self->hardware->mastProcessorType ) || ( $self->hardware->mastProcessorType =~ /^\s*$/ ));
		$letsopen = 1 if (( not defined $self->hardware->processorModel ) || ( $self->hardware->processorModel =~ /^\s*$/ ));
		$letsopen = 1 if (( not defined $self->hardware->nbrCoresPerChip ) || ( $self->hardware->nbrCoresPerChip <= 0 ));
		$letsopen = 1 if (( not defined $self->hardware->chips ) || ( $self->hardware->chips <= 0 ));
		$letsopen = 1 if (( not defined $self->hardware->processorCount ) || ( $self->hardware->processorCount <= 0 ));
		$letsopen = 1 if (( not defined $self->hardware->nbrOfChipsMax ) || ( $self->hardware->nbrOfChipsMax <= 0 ));
	} elsif ( $machineType eq "MAINFRAME" ) {
		dlog("MAINFRAME, checking attributes...");
		$letsopen = 1 if (( not defined $self->hardware->cpuMIPS ) || ( $self->hardware->cpuMIPS <= 0 ));
		$letsopen = 1 if (( not defined $self->hardware->cpuMSU ) || ( $self->hardware->cpuMSU <= 0 ));
		$letsopen = 1 if (( not defined $self->hardware->cpuGartnerMIPS ) || ( $self->hardware->cpuGartnerMIPS <= 0 ));
	}
	
	if ( $letsopen == 1 ) {
		$self->openAlert;
	} elsif ( $letsopen == 0 ) {
		$self->closeAlert(1);
	}
	dlog("Reconing HW config data done.");
}

sub findMachineType {
	my ( $self, $machineTypeId ) = @_;
	
	dlog ("Machine type ID: $machineTypeId");
	
	my $machType;
	
	$self->connection->prepareSqlQuery( $self->queryFindMachineType );
	my $sth= $self->connection->sql->{findMachineType};
    $sth->bind_columns( \$machType );
    $sth->execute( $machineTypeId );
    $sth->fetchrow_arrayref;
    $sth->finish;
	
	return $machType;
}

sub queryFindMachineType {
	my $query = "
		select
			type
		from
			machine_type
		where 
			id = ?
	";
	return ( 'findMachineType', $query );
}

sub hardwareLparCount {
    my $self = shift;

    my $count = 0;

    $self->connection->prepareSqlQuery( $self->queryHardwareLparCount );
    my $sth = $self->connection->sql->{hardwareLparCount};
    $sth->bind_columns( \$count );
    $sth->execute( $self->hardware->id );
    $sth->fetchrow_arrayref;
    $sth->finish;

    return $count;
}

sub queryHardwareLparCount {
    my $query = qq{
        select
            count(hl.id)
        from
            hardware h
            ,hardware_lpar hl
        where
            h.id = ?
            and h.id = hl.hardware_id
            and hl.status = 'ACTIVE'
        with ur
    };

    return ( 'hardwareLparCount', $query );
}

sub openAlert {
    my $self = shift;

    my $alert = new Recon::OM::AlertHardwareCfgData();
    $alert->hardwareId( $self->hardware->id );
    $alert->getByBizKey( $self->connection );

    return if ( defined $alert->id && $alert->open == 1 );

    $self->recordHistory($alert) if defined $alert->id;

    $alert->creationTime( currentTimeStamp() );
    $alert->comments('Auto Open');
    $alert->open(1);
    $alert->save( $self->connection );
    
    Recon::CauseCode::updateCCtable( $alert->id, "HWCFGDTA", $self->connection ); # updating CC table, HWCFGDTA
}

sub closeAlert {
    my ( $self, $save ) = @_;

    my $alert = new Recon::OM::AlertHardwareCfgData();
    $alert->hardwareId( $self->hardware->id );
    $alert->getByBizKey( $self->connection );

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
    
    Recon::CauseCode::updateCCtable( $alert->id, "HWCFGDTA", $self->connection ) if ( $save == 1 ); # updating CC table
}

sub recordHistory {
    my ( $self, $alert ) = @_;

    my $history = new Recon::OM::AlertHardwareCfgDataHistory();
    $history->alertHardwareCfgDataId( $alert->id );
    $history->creationTime( $alert->creationTime );
    $history->comments( $alert->comments );
    $history->open( $alert->open );
    $history->recordTime( $alert->recordTime );
    $history->save( $self->connection );
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub hardware {
    my $self = shift;
    $self->{_hardware} = shift if scalar @_ == 1;
    return $self->{_hardware};
}

1;
