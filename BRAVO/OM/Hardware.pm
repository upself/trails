package BRAVO::OM::Hardware;

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
        ,_status => undef
        ,_action => undef
        ,_remoteUser => 'ATP'
        ,_recordTime => undef
        ,_customerId => undef
        ,_processorCount => undef
        ,_classification => undef
        ,_chips => undef
        ,_model => undef
        ,_processorType => undef
        ,_serverType => undef
        ,_cpuMIPS => undef
        ,_cpuMSU => undef
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
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->action && defined $object->action) {
        $equal = 1 if $self->action eq $object->action;
    }
    $equal = 1 if (!defined $self->action && !defined $object->action);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
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
    if (defined $self->model && defined $object->model) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if (!defined $self->model && !defined $object->model);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorType && defined $object->processorType) {
        $equal = 1 if $self->processorType eq $object->processorType;
    }
    $equal = 1 if (!defined $self->processorType && !defined $object->processorType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverType && defined $object->serverType) {
        $equal = 1 if $self->serverType eq $object->serverType;
    }
    $equal = 1 if (!defined $self->serverType && !defined $object->serverType);
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

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub remoteUser {
    my $self = shift;
    $self->{_remoteUser} = shift if scalar @_ == 1;
    return $self->{_remoteUser};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
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

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub processorType {
    my $self = shift;
    $self->{_processorType} = shift if scalar @_ == 1;
    return $self->{_processorType};
}

sub serverType {
    my $self = shift;
    $self->{_serverType} = shift if scalar @_ == 1;
    return $self->{_serverType};
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
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "remoteUser=";
    if (defined $self->{_remoteUser}) {
        $s .= $self->{_remoteUser};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
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
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "processorType=";
    if (defined $self->{_processorType}) {
        $s .= $self->{_processorType};
    }
    $s .= ",";
    $s .= "serverType=";
    if (defined $self->{_serverType}) {
        $s .= $self->{_serverType};
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
            ,$self->status
            ,$self->customerId
            ,$self->processorCount
            ,$self->classification
            ,$self->chips
            ,$self->model
            ,$self->processorType
            ,$self->serverType
            ,$self->cpuMIPS
            ,$self->cpuMSU
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
            ,$self->status
            ,$self->customerId
            ,$self->processorCount
            ,$self->classification
            ,$self->chips
            ,$self->model
            ,$self->processorType
            ,$self->serverType
            ,$self->cpuMIPS
            ,$self->cpuMSU
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
            ,status
            ,remote_user
            ,record_time
            ,customer_id
            ,processor_count
            ,classification
            ,chips
            ,model
            ,processor_type
            ,server_type
            ,cpu_mips
            ,cpu_msu
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,\'ATP\'
            ,CURRENT TIMESTAMP
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
            ,status = ?
            ,remote_user = \'ATP\'
            ,record_time = CURRENT TIMESTAMP
            ,customer_id = ?
            ,processor_count = ?
            ,classification = ?
            ,chips = ?
            ,model = ?
            ,processor_type = ?
            ,server_type = ?
            ,cpu_mips = ?
            ,cpu_msu = ?
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

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyHardware};
    my $id;
    my $owner;
    my $customerNumber;
    my $hardwareStatus;
    my $status;
    my $remoteUser;
    my $recordTime;
    my $customerId;
    my $processorCount;
    my $classification;
    my $chips;
    my $model;
    my $processorType;
    my $serverType;
    my $cpuMIPS;
    my $cpuMSU;
    $sth->bind_columns(
        \$id
        ,\$owner
        ,\$customerNumber
        ,\$hardwareStatus
        ,\$status
        ,\$remoteUser
        ,\$recordTime
        ,\$customerId
        ,\$processorCount
        ,\$classification
        ,\$chips
        ,\$model
        ,\$processorType
        ,\$serverType
        ,\$cpuMIPS
        ,\$cpuMSU
    );
    $sth->execute(
        $self->machineTypeId
        ,$self->serial
        ,$self->country
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->owner($owner);
    $self->customerNumber($customerNumber);
    $self->hardwareStatus($hardwareStatus);
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->customerId($customerId);
    $self->processorCount($processorCount);
    $self->classification($classification);
    $self->chips($chips);
    $self->model($model);
    $self->processorType($processorType);
    $self->serverType($serverType);
    $self->cpuMIPS($cpuMIPS);
    $self->cpuMSU($cpuMSU);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,owner
            ,customer_number
            ,hardware_status
            ,status
            ,remote_user
            ,record_time
            ,customer_id
            ,processor_count
            ,classification
            ,chips
            ,model
            ,processor_type
            ,server_type
            ,cpu_mips
            ,cpu_msu
        from
            hardware
        where
            machine_type_id = ?
            and serial = ?
            and country = ?
    ';
    return ('getByBizKeyHardware', $query);
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
    my $status;
    my $remoteUser;
    my $recordTime;
    my $customerId;
    my $processorCount;
    my $classification;
    my $chips;
    my $model;
    my $processorType;
    my $serverType;
    my $cpuMIPS;
    my $cpuMSU;
    $sth->bind_columns(
        \$machineTypeId
        ,\$serial
        ,\$country
        ,\$owner
        ,\$customerNumber
        ,\$hardwareStatus
        ,\$status
        ,\$remoteUser
        ,\$recordTime
        ,\$customerId
        ,\$processorCount
        ,\$classification
        ,\$chips
        ,\$model
        ,\$processorType
        ,\$serverType
        ,\$cpuMIPS
        ,\$cpuMSU
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
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->customerId($customerId);
    $self->processorCount($processorCount);
    $self->classification($classification);
    $self->chips($chips);
    $self->model($model);
    $self->processorType($processorType);
    $self->serverType($serverType);
    $self->cpuMIPS($cpuMIPS);
    $self->cpuMSU($cpuMSU);
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
            ,status
            ,remote_user
            ,record_time
            ,customer_id
            ,processor_count
            ,classification
            ,chips
            ,model
            ,processor_type
            ,server_type
            ,cpu_mips
            ,cpu_msu
        from
            hardware
        where
            id = ?
    ';
    return ('getByIdKeyHardware', $query);
}

1;
