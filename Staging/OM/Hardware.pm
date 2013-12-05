package Staging::OM::Hardware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_machineTypeId => undef
        ,_serial => undef
        ,_country => undef
        ,_owner => undef
        ,_customerNumber => undef
        ,_hardwareStatus => undef
        ,_serverType => undef
        ,_status => undef
        ,_processorCount => undef
        ,_model => undef
        ,_customerId => undef
        ,_classification => undef
        ,_chips => undef
        ,_processorType => undef
        ,_mastProcessorType => undef
        ,_processorManufacturer => undef
        ,_processorModel => undef
        ,_nbrCoresPerChip => undef
        ,_nbrOfChipsMax => undef
        ,_shared => undef
        ,_cpuMIPS => undef
        ,_cpuMSU => undef
        ,_cpuGartnerMIPS => undef
        ,_sharedProcessor => undef
        ,_cloudName => undef
        ,_chassisId => undef
        ,_action => undef
        ,_updateDate => undef
        ,_table => 'hardware'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->machineTypeId && defined $object->machineTypeId) {
        $equal = 1 if $self->machineTypeId eq $object->machineTypeId;
    }
    $equal = 1 if (!defined $self->machineTypeId && !defined $object->machineTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serial && defined $object->serial) {
        $equal = 1 if $self->serial eq $object->serial;
    }
    $equal = 1 if (!defined $self->serial && !defined $object->serial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->country && defined $object->country) {
        $equal = 1 if $self->country eq $object->country;
    }
    $equal = 1 if (!defined $self->country && !defined $object->country);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->owner && defined $object->owner) {
        $equal = 1 if $self->owner eq $object->owner;
    }
    $equal = 1 if (!defined $self->owner && !defined $object->owner);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerNumber && defined $object->customerNumber) {
        $equal = 1 if $self->customerNumber eq $object->customerNumber;
    }
    $equal = 1 if (!defined $self->customerNumber && !defined $object->customerNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hardwareStatus && defined $object->hardwareStatus) {
        $equal = 1 if $self->hardwareStatus eq $object->hardwareStatus;
    }
    $equal = 1 if (!defined $self->hardwareStatus && !defined $object->hardwareStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverType && defined $object->serverType) {
        $equal = 1 if $self->serverType eq $object->serverType;
    }
    $equal = 1 if (!defined $self->serverType && !defined $object->serverType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->model && defined $object->model) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if (!defined $self->model && !defined $object->model);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->classification && defined $object->classification) {
        $equal = 1 if $self->classification eq $object->classification;
    }
    $equal = 1 if (!defined $self->classification && !defined $object->classification);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->chips && defined $object->chips) {
        $equal = 1 if $self->chips eq $object->chips;
    }
    $equal = 1 if (!defined $self->chips && !defined $object->chips);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorType && defined $object->processorType) {
        $equal = 1 if $self->processorType eq $object->processorType;
    }
    $equal = 1 if (!defined $self->processorType && !defined $object->processorType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->mastProcessorType && defined $object->mastProcessorType) {
        $equal = 1 if $self->mastProcessorType eq $object->mastProcessorType;
    }
    $equal = 1 if (!defined $self->mastProcessorType && !defined $object->mastProcessorType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorManufacturer && defined $object->processorManufacturer) {
        $equal = 1 if $self->processorManufacturer eq $object->processorManufacturer;
    }
    $equal = 1 if (!defined $self->processorManufacturer && !defined $object->processorManufacturer);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorModel && defined $object->processorModel) {
        $equal = 1 if $self->processorModel eq $object->processorModel;
    }
    $equal = 1 if (!defined $self->processorModel && !defined $object->processorModel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->nbrCoresPerChip && defined $object->nbrCoresPerChip) {
        $equal = 1 if $self->nbrCoresPerChip eq $object->nbrCoresPerChip;
    }
    $equal = 1 if (!defined $self->nbrCoresPerChip && !defined $object->nbrCoresPerChip);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->nbrOfChipsMax && defined $object->nbrOfChipsMax) {
        $equal = 1 if $self->nbrOfChipsMax eq $object->nbrOfChipsMax;
    }
    $equal = 1 if (!defined $self->nbrOfChipsMax && !defined $object->nbrOfChipsMax);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->shared && defined $object->shared) {
        $equal = 1 if $self->shared eq $object->shared;
    }
    $equal = 1 if (!defined $self->shared && !defined $object->shared);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cpuMIPS && defined $object->cpuMIPS) {
        $equal = 1 if $self->cpuMIPS eq $object->cpuMIPS;
    }
    $equal = 1 if (!defined $self->cpuMIPS && !defined $object->cpuMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cpuMSU && defined $object->cpuMSU) {
        $equal = 1 if $self->cpuMSU eq $object->cpuMSU;
    }
    $equal = 1 if (!defined $self->cpuMSU && !defined $object->cpuMSU);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cpuGartnerMIPS && defined $object->cpuGartnerMIPS) {
        $equal = 1 if $self->cpuGartnerMIPS eq $object->cpuGartnerMIPS;
    }
    $equal = 1 if (!defined $self->cpuGartnerMIPS && !defined $object->cpuGartnerMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sharedProcessor && defined $object->sharedProcessor) {
        $equal = 1 if $self->sharedProcessor eq $object->sharedProcessor;
    }
    $equal = 1 if (!defined $self->sharedProcessor && !defined $object->sharedProcessor);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cloudName && defined $object->cloudName) {
        $equal = 1 if $self->cloudName eq $object->cloudName;
    }
    $equal = 1 if (!defined $self->cloudName && !defined $object->cloudName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->chassisId && defined $object->chassisId) {
        $equal = 1 if $self->chassisId eq $object->chassisId;
    }
    $equal = 1 if (!defined $self->chassisId && !defined $object->chassisId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub machineTypeId {
    my $self = shift;
    $self->{_machineTypeId} = shift if scalar @_ == 1;
    return $self->{_machineTypeId};
}

sub serial {
    my $self = shift;
    $self->{_serial} = shift if scalar @_ == 1;
    return $self->{_serial};
}

sub country {
    my $self = shift;
    $self->{_country} = shift if scalar @_ == 1;
    return $self->{_country};
}

sub owner {
    my $self = shift;
    $self->{_owner} = shift if scalar @_ == 1;
    return $self->{_owner};
}

sub customerNumber {
    my $self = shift;
    $self->{_customerNumber} = shift if scalar @_ == 1;
    return $self->{_customerNumber};
}

sub hardwareStatus {
    my $self = shift;
    $self->{_hardwareStatus} = shift if scalar @_ == 1;
    return $self->{_hardwareStatus};
}

sub serverType {
    my $self = shift;
    $self->{_serverType} = shift if scalar @_ == 1;
    return $self->{_serverType};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
}

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub classification {
    my $self = shift;
    $self->{_classification} = shift if scalar @_ == 1;
    return $self->{_classification};
}

sub chips {
    my $self = shift;
    $self->{_chips} = shift if scalar @_ == 1;
    return $self->{_chips};
}

sub processorType {
    my $self = shift;
    $self->{_processorType} = shift if scalar @_ == 1;
    return $self->{_processorType};
}

sub mastProcessorType {
    my $self = shift;
    $self->{_mastProcessorType} = shift if scalar @_ == 1;
    return $self->{_mastProcessorType};
}

sub processorManufacturer {
    my $self = shift;
    $self->{_processorManufacturer} = shift if scalar @_ == 1;
    return $self->{_processorManufacturer};
}

sub processorModel {
    my $self = shift;
    $self->{_processorModel} = shift if scalar @_ == 1;
    return $self->{_processorModel};
}

sub nbrCoresPerChip {
    my $self = shift;
    $self->{_nbrCoresPerChip} = shift if scalar @_ == 1;
    return $self->{_nbrCoresPerChip};
}

sub nbrOfChipsMax {
    my $self = shift;
    $self->{_nbrOfChipsMax} = shift if scalar @_ == 1;
    return $self->{_nbrOfChipsMax};
}

sub shared {
    my $self = shift;
    $self->{_shared} = shift if scalar @_ == 1;
    return $self->{_shared};
}

sub cpuMIPS {
    my $self = shift;
    $self->{_cpuMIPS} = shift if scalar @_ == 1;
    return $self->{_cpuMIPS};
}

sub cpuMSU {
    my $self = shift;
    $self->{_cpuMSU} = shift if scalar @_ == 1;
    return $self->{_cpuMSU};
}

sub cpuGartnerMIPS {
    my $self = shift;
    $self->{_cpuGartnerMIPS} = shift if scalar @_ == 1;
    return $self->{_cpuGartnerMIPS};
}

sub sharedProcessor {
    my $self = shift;
    $self->{_sharedProcessor} = shift if scalar @_ == 1;
    return $self->{_sharedProcessor};
}

sub cloudName {
    my $self = shift;
    $self->{_cloudName} = shift if scalar @_ == 1;
    return $self->{_cloudName};
}

sub chassisId {
    my $self = shift;
    $self->{_chassisId} = shift if scalar @_ == 1;
    return $self->{_chassisId};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub updateDate {
    my $self = shift;
    $self->{_updateDate} = shift if scalar @_ == 1;
    return $self->{_updateDate};
}

sub table {
    my $self = shift;
    $self->{_table} = shift if scalar @_ == 1;
    return $self->{_table};
}

sub idField {
    my $self = shift;
    $self->{_idField} = shift if scalar @_ == 1;
    return $self->{_idField};
}

sub toString {
    my ($self) = @_;
    my $s = "[Hardware] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "machineTypeId=";
    if (defined $self->{_machineTypeId}) {
        $s .= $self->{_machineTypeId};
    }
    $s .= ",";
    $s .= "serial=";
    if (defined $self->{_serial}) {
        $s .= $self->{_serial};
    }
    $s .= ",";
    $s .= "country=";
    if (defined $self->{_country}) {
        $s .= $self->{_country};
    }
    $s .= ",";
    $s .= "owner=";
    if (defined $self->{_owner}) {
        $s .= $self->{_owner};
    }
    $s .= ",";
    $s .= "customerNumber=";
    if (defined $self->{_customerNumber}) {
        $s .= $self->{_customerNumber};
    }
    $s .= ",";
    $s .= "hardwareStatus=";
    if (defined $self->{_hardwareStatus}) {
        $s .= $self->{_hardwareStatus};
    }
    $s .= ",";
    $s .= "serverType=";
    if (defined $self->{_serverType}) {
        $s .= $self->{_serverType};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
    }
    $s .= ",";
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "classification=";
    if (defined $self->{_classification}) {
        $s .= $self->{_classification};
    }
    $s .= ",";
    $s .= "chips=";
    if (defined $self->{_chips}) {
        $s .= $self->{_chips};
    }
    $s .= ",";
    $s .= "processorType=";
    if (defined $self->{_processorType}) {
        $s .= $self->{_processorType};
    }
    $s .= ",";
    $s .= "mastProcessorType=";
    if (defined $self->{_mastProcessorType}) {
        $s .= $self->{_mastProcessorType};
    }
    $s .= ",";
    $s .= "processorManufacturer=";
    if (defined $self->{_processorManufacturer}) {
        $s .= $self->{_processorManufacturer};
    }
    $s .= ",";
    $s .= "processorModel=";
    if (defined $self->{_processorModel}) {
        $s .= $self->{_processorModel};
    }
    $s .= ",";
    $s .= "nbrCoresPerChip=";
    if (defined $self->{_nbrCoresPerChip}) {
        $s .= $self->{_nbrCoresPerChip};
    }
    $s .= ",";
    $s .= "nbrOfChipsMax=";
    if (defined $self->{_nbrOfChipsMax}) {
        $s .= $self->{_nbrOfChipsMax};
    }
    $s .= ",";
    $s .= "shared=";
    if (defined $self->{_shared}) {
        $s .= $self->{_shared};
    }
    $s .= ",";
    $s .= "cpuMIPS=";
    if (defined $self->{_cpuMIPS}) {
        $s .= $self->{_cpuMIPS};
    }
    $s .= ",";
    $s .= "cpuMSU=";
    if (defined $self->{_cpuMSU}) {
        $s .= $self->{_cpuMSU};
    }
    $s .= ",";
    $s .= "cpuGartnerMIPS=";
    if (defined $self->{_cpuGartnerMIPS}) {
        $s .= $self->{_cpuGartnerMIPS};
    }
    $s .= ",";
    $s .= "sharedProcessor=";
    if (defined $self->{_sharedProcessor}) {
        $s .= $self->{_sharedProcessor};
    }
    $s .= ",";
    $s .= "cloudName=";
    if (defined $self->{_cloudName}) {
        $s .= $self->{_cloudName};
    }
    $s .= ",";
    $s .= "chassisId=";
    if (defined $self->{_chassisId}) {
        $s .= $self->{_chassisId};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "updateDate=";
    if (defined $self->{_updateDate}) {
        $s .= $self->{_updateDate};
    }
    $s .= ",";
    $s .= "table=";
    if (defined $self->{_table}) {
        $s .= $self->{_table};
    }
    $s .= ",";
    $s .= "idField=";
    if (defined $self->{_idField}) {
        $s .= $self->{_idField};
    }
    $s .= ",";
    chop $s;
    return $s;
}

sub save {
    my($self, $connection) = @_;
    ilog("saving: ".$self->toString());
    if( ! defined $self->id ) {
        $connection->prepareSqlQuery($self->queryInsert());
        my $sth = $connection->sql->{insertHardware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->machineTypeId
            ,$self->serial
            ,$self->country
            ,$self->owner
            ,$self->customerNumber
            ,$self->hardwareStatus
            ,$self->serverType
            ,$self->status
            ,$self->processorCount
            ,$self->model
            ,$self->customerId
            ,$self->classification
            ,$self->chips
            ,$self->processorType
            ,$self->mastProcessorType
            ,$self->processorManufacturer
            ,$self->processorModel
            ,$self->nbrCoresPerChip
            ,$self->nbrOfChipsMax
            ,$self->shared
            ,$self->cpuMIPS
            ,$self->cpuMSU
            ,$self->cpuGartnerMIPS
            ,$self->sharedProcessor
            ,$self->cloudName
            ,$self->chassisId
            ,$self->action
            ,$self->updateDate
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHardware};
        $sth->execute(
            $self->machineTypeId
            ,$self->serial
            ,$self->country
            ,$self->owner
            ,$self->customerNumber
            ,$self->hardwareStatus
            ,$self->serverType
            ,$self->status
            ,$self->processorCount
            ,$self->model
            ,$self->customerId
            ,$self->classification
            ,$self->chips
            ,$self->processorType
            ,$self->mastProcessorType
            ,$self->processorManufacturer
            ,$self->processorModel
            ,$self->nbrCoresPerChip
            ,$self->nbrOfChipsMax
            ,$self->shared
            ,$self->cpuMIPS
            ,$self->cpuMSU
            ,$self->cpuGartnerMIPS
            ,$self->sharedProcessor
            ,$self->cloudName
            ,$self->chassisId
            ,$self->action
            ,$self->updateDate
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            id
        from
            final table (
        insert into hardware (
            machine_type_id
            ,serial
            ,country
            ,owner
            ,customer_number
            ,hardware_status
            ,server_type
            ,status
            ,processor_count
            ,model
            ,customer_id
            ,classification
            ,chips
            ,processor_type
            ,mast_processor_type
            ,processor_manufacturer
            ,processor_model
            ,nbr_cores_per_chip
            ,nbr_of_chips_max
            ,shared
            ,cpu_mips
            ,cpu_msu
            ,CPU_GARTNER_MIPS
            ,SHARED_PROCESSOR
            ,CLOUD_NAME
            ,CHASSIS_ID
            ,action
            ,update_date
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertHardware', $query);
}

sub queryUpdate {
    my $query = '
        update hardware
        set
            machine_type_id = ?
            ,serial = ?
            ,country = ?
            ,owner = ?
            ,customer_number = ?
            ,hardware_status = ?
            ,server_type = ?
            ,status = ?
            ,processor_count = ?
            ,model = ?
            ,customer_id = ?
            ,classification = ?
            ,chips = ?
            ,processor_type = ?
            ,mast_processor_type = ?
            ,processor_manufacturer = ?
            ,processor_model = ?
            ,nbr_cores_per_chip = ?
            ,nbr_of_chips_max = ?
            ,shared = ?
            ,cpu_mips = ?
            ,cpu_msu = ?
            ,CPU_GARTNER_MIPS = ?
            ,SHARED_PROCESSOR = ?
            ,CLOUD_NAME = ?
            ,CHASSIS_ID = ?
            ,action = ?
            ,update_date = ?
        where
            id = ?
    ';
    return ('updateHardware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteHardware};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from hardware
        where
            id = ?
    ';
    return ('deleteHardware', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHardware};
    my $machineTypeId;
    my $serial;
    my $country;
    my $owner;
    my $customerNumber;
    my $hardwareStatus;
    my $serverType;
    my $status;
    my $processorCount;
    my $model;
    my $customerId;
    my $classification;
    my $chips;
    my $processorType;
    my $mastProcessorType;
    my $processorManufacturer;
    my $processorModel;
    my $nbrCoresPerChip;
    my $nbrOfChipsMax;
    my $shared;
    my $cpuMIPS;
    my $cpuMSU;
    my $cpuGartnerMIPS;
    my $sharedProcessor;
    my $cloudName;
    my $chassisId;
    my $action;
    my $updateDate;
    $sth->bind_columns(
        \$machineTypeId
        ,\$serial
        ,\$country
        ,\$owner
        ,\$customerNumber
        ,\$hardwareStatus
        ,\$serverType
        ,\$status
        ,\$processorCount
        ,\$model
        ,\$customerId
        ,\$classification
        ,\$chips
        ,\$processorType
        ,\$mastProcessorType
        ,\$processorManufacturer
        ,\$processorModel
        ,\$nbrCoresPerChip
        ,\$nbrOfChipsMax
        ,\$shared
        ,\$cpuMIPS
        ,\$cpuMSU
        ,\$cpuGartnerMIPS
        ,\$sharedProcessor
        ,\$cloudName
        ,\$chassisId
        ,\$action
        ,\$updateDate
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->machineTypeId($machineTypeId);
    $self->serial($serial);
    $self->country($country);
    $self->owner($owner);
    $self->customerNumber($customerNumber);
    $self->hardwareStatus($hardwareStatus);
    $self->serverType($serverType);
    $self->status($status);
    $self->processorCount($processorCount);
    $self->model($model);
    $self->customerId($customerId);
    $self->classification($classification);
    $self->chips($chips);
    $self->processorType($processorType);
    $self->mastProcessorType($mastProcessorType);
    $self->processorManufacturer($processorManufacturer);
    $self->processorModel($processorModel);
    $self->nbrCoresPerChip($nbrCoresPerChip);
    $self->nbrOfChipsMax($nbrOfChipsMax);
    $self->shared($shared);
    $self->cpuMIPS($cpuMIPS);
    $self->cpuMSU($cpuMSU);
    $self->cpuGartnerMIPS($cpuGartnerMIPS);
    $self->sharedProcessor($sharedProcessor);
    $self->cloudName($cloudName);
    $self->chassisId($chassisId);
    $self->action($action);
    $self->updateDate($updateDate);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            machine_type_id
            ,serial
            ,country
            ,owner
            ,customer_number
            ,hardware_status
            ,server_type
            ,status
            ,processor_count
            ,model
            ,customer_id
            ,classification
            ,chips
            ,processor_type
            ,mast_processor_type
            ,processor_manufacturer
            ,processor_model
            ,nbr_cores_per_chip
            ,nbr_of_chips_max
            ,shared
            ,cpu_mips
            ,cpu_msu
            ,CPU_GARTNER_MIPS
            ,SHARED_PROCESSOR
            ,CLOUD_NAME
            ,CHASSIS_ID
            ,action
            ,update_date
        from
            hardware
        where
            id = ?
    ';
    return ('getByIdKeyHardware', $query);
}

1;
