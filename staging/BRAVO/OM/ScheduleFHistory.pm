package BRAVO::OM::ScheduleFHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scheduleFId => undef
        ,_softwareId => undef
        ,_customerId => undef
        ,_softwareTitile => undef
        ,_softwareName => undef
        ,_manufacturer => undef
        ,_scopeId => undef
        ,_sourceId => undef
        ,_sourceLocation => undef
        ,_statusId => undef
        ,_businessJustification => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_level => undef
        ,_hwOwner => undef
        ,_serial => undef
        ,_machineType => undef
        ,_hostname => undef
        ,_table => 'schedule_f_h'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->scheduleFId && defined $object->scheduleFId) {
        $equal = 1 if $self->scheduleFId eq $object->scheduleFId;
    }
    $equal = 1 if (!defined $self->scheduleFId && !defined $object->scheduleFId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareTitile && defined $object->softwareTitile) {
        $equal = 1 if $self->softwareTitile eq $object->softwareTitile;
    }
    $equal = 1 if (!defined $self->softwareTitile && !defined $object->softwareTitile);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareName && defined $object->softwareName) {
        $equal = 1 if $self->softwareName eq $object->softwareName;
    }
    $equal = 1 if (!defined $self->softwareName && !defined $object->softwareName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->manufacturer && defined $object->manufacturer) {
        $equal = 1 if $self->manufacturer eq $object->manufacturer;
    }
    $equal = 1 if (!defined $self->manufacturer && !defined $object->manufacturer);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scopeId && defined $object->scopeId) {
        $equal = 1 if $self->scopeId eq $object->scopeId;
    }
    $equal = 1 if (!defined $self->scopeId && !defined $object->scopeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sourceId && defined $object->sourceId) {
        $equal = 1 if $self->sourceId eq $object->sourceId;
    }
    $equal = 1 if (!defined $self->sourceId && !defined $object->sourceId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sourceLocation && defined $object->sourceLocation) {
        $equal = 1 if $self->sourceLocation eq $object->sourceLocation;
    }
    $equal = 1 if (!defined $self->sourceLocation && !defined $object->sourceLocation);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->statusId && defined $object->statusId) {
        $equal = 1 if $self->statusId eq $object->statusId;
    }
    $equal = 1 if (!defined $self->statusId && !defined $object->statusId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->businessJustification && defined $object->businessJustification) {
        $equal = 1 if $self->businessJustification eq $object->businessJustification;
    }
    $equal = 1 if (!defined $self->businessJustification && !defined $object->businessJustification);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->remoteUser && defined $object->remoteUser) {
        $equal = 1 if $self->remoteUser eq $object->remoteUser;
    }
    $equal = 1 if (!defined $self->remoteUser && !defined $object->remoteUser);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->recordTime && defined $object->recordTime) {
        $equal = 1 if $self->recordTime eq $object->recordTime;
    }
    $equal = 1 if (!defined $self->recordTime && !defined $object->recordTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->level && defined $object->level) {
        $equal = 1 if $self->level eq $object->level;
    }
    $equal = 1 if (!defined $self->level && !defined $object->level);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwOwner && defined $object->hwOwner) {
        $equal = 1 if $self->hwOwner eq $object->hwOwner;
    }
    $equal = 1 if (!defined $self->hwOwner && !defined $object->hwOwner);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serial && defined $object->serial) {
        $equal = 1 if $self->serial eq $object->serial;
    }
    $equal = 1 if (!defined $self->serial && !defined $object->serial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->machineType && defined $object->machineType) {
        $equal = 1 if $self->machineType eq $object->machineType;
    }
    $equal = 1 if (!defined $self->machineType && !defined $object->machineType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hostname && defined $object->hostname) {
        $equal = 1 if $self->hostname eq $object->hostname;
    }
    $equal = 1 if (!defined $self->hostname && !defined $object->hostname);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->table && defined $object->table) {
        $equal = 1 if $self->table eq $object->table;
    }
    $equal = 1 if (!defined $self->table && !defined $object->table);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->idField && defined $object->idField) {
        $equal = 1 if $self->idField eq $object->idField;
    }
    $equal = 1 if (!defined $self->idField && !defined $object->idField);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub scheduleFId {
    my $self = shift;
    $self->{_scheduleFId} = shift if scalar @_ == 1;
    return $self->{_scheduleFId};
}

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub softwareTitile {
    my $self = shift;
    $self->{_softwareTitile} = shift if scalar @_ == 1;
    return $self->{_softwareTitile};
}

sub softwareName {
    my $self = shift;
    $self->{_softwareName} = shift if scalar @_ == 1;
    return $self->{_softwareName};
}

sub manufacturer {
    my $self = shift;
    $self->{_manufacturer} = shift if scalar @_ == 1;
    return $self->{_manufacturer};
}

sub scopeId {
    my $self = shift;
    $self->{_scopeId} = shift if scalar @_ == 1;
    return $self->{_scopeId};
}

sub sourceId {
    my $self = shift;
    $self->{_sourceId} = shift if scalar @_ == 1;
    return $self->{_sourceId};
}

sub sourceLocation {
    my $self = shift;
    $self->{_sourceLocation} = shift if scalar @_ == 1;
    return $self->{_sourceLocation};
}

sub statusId {
    my $self = shift;
    $self->{_statusId} = shift if scalar @_ == 1;
    return $self->{_statusId};
}

sub businessJustification {
    my $self = shift;
    $self->{_businessJustification} = shift if scalar @_ == 1;
    return $self->{_businessJustification};
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

sub level {
    my $self = shift;
    $self->{_level} = shift if scalar @_ == 1;
    return $self->{_level};
}

sub hwOwner {
    my $self = shift;
    $self->{_hwOwner} = shift if scalar @_ == 1;
    return $self->{_hwOwner};
}

sub serial {
    my $self = shift;
    $self->{_serial} = shift if scalar @_ == 1;
    return $self->{_serial};
}

sub machineType {
    my $self = shift;
    $self->{_machineType} = shift if scalar @_ == 1;
    return $self->{_machineType};
}

sub hostname {
    my $self = shift;
    $self->{_hostname} = shift if scalar @_ == 1;
    return $self->{_hostname};
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
    my $s = "[ScheduleFHistory] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "scheduleFId=";
    if (defined $self->{_scheduleFId}) {
        $s .= $self->{_scheduleFId};
    }
    $s .= ",";
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "softwareTitile=";
    if (defined $self->{_softwareTitile}) {
        $s .= $self->{_softwareTitile};
    }
    $s .= ",";
    $s .= "softwareName=";
    if (defined $self->{_softwareName}) {
        $s .= $self->{_softwareName};
    }
    $s .= ",";
    $s .= "manufacturer=";
    if (defined $self->{_manufacturer}) {
        $s .= $self->{_manufacturer};
    }
    $s .= ",";
    $s .= "scopeId=";
    if (defined $self->{_scopeId}) {
        $s .= $self->{_scopeId};
    }
    $s .= ",";
    $s .= "sourceId=";
    if (defined $self->{_sourceId}) {
        $s .= $self->{_sourceId};
    }
    $s .= ",";
    $s .= "sourceLocation=";
    if (defined $self->{_sourceLocation}) {
        $s .= $self->{_sourceLocation};
    }
    $s .= ",";
    $s .= "statusId=";
    if (defined $self->{_statusId}) {
        $s .= $self->{_statusId};
    }
    $s .= ",";
    $s .= "businessJustification=";
    if (defined $self->{_businessJustification}) {
        $s .= $self->{_businessJustification};
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
    $s .= "level=";
    if (defined $self->{_level}) {
        $s .= $self->{_level};
    }
    $s .= ",";
    $s .= "hwOwner=";
    if (defined $self->{_hwOwner}) {
        $s .= $self->{_hwOwner};
    }
    $s .= ",";
    $s .= "serial=";
    if (defined $self->{_serial}) {
        $s .= $self->{_serial};
    }
    $s .= ",";
    $s .= "machineType=";
    if (defined $self->{_machineType}) {
        $s .= $self->{_machineType};
    }
    $s .= ",";
    $s .= "hostname=";
    if (defined $self->{_hostname}) {
        $s .= $self->{_hostname};
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
        my $sth = $connection->sql->{insertScheduleFHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scheduleFId
            ,$self->softwareId
            ,$self->customerId
            ,$self->softwareTitile
            ,$self->softwareName
            ,$self->manufacturer
            ,$self->scopeId
            ,$self->sourceId
            ,$self->sourceLocation
            ,$self->statusId
            ,$self->businessJustification
            ,$self->level
            ,$self->hwOwner
            ,$self->serial
            ,$self->machineType
            ,$self->hostname
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateScheduleFHistory};
        $sth->execute(
            $self->scheduleFId
            ,$self->softwareId
            ,$self->customerId
            ,$self->softwareTitile
            ,$self->softwareName
            ,$self->manufacturer
            ,$self->scopeId
            ,$self->sourceId
            ,$self->sourceLocation
            ,$self->statusId
            ,$self->businessJustification
            ,$self->level
            ,$self->hwOwner
            ,$self->serial
            ,$self->machineType
            ,$self->hostname
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
        insert into schedule_f_h (
            SCHEDULE_F_ID
            ,software_id
            ,CUSTOMER_ID
            ,SOFTWARE_TITLE
            ,SOFTWARE_NAME
            ,MANUFACTURER
            ,SCOPE_ID
            ,SOURCE_ID
            ,SOURCE_LOCATION
            ,STATUS_ID
            ,BUSINESS_JUSTIFICATION
            ,REMOTE_USER
            ,RECORD_TIME
            ,level
            ,HW_OWNER
            ,SERIAL
            ,MACHINE_TYPE
            ,HOSTNAME
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
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertScheduleFHistory', $query);
}

sub queryUpdate {
    my $query = '
        update schedule_f_h
        set
            SCHEDULE_F_ID = ?
            ,software_id = ?
            ,CUSTOMER_ID = ?
            ,SOFTWARE_TITLE = ?
            ,SOFTWARE_NAME = ?
            ,MANUFACTURER = ?
            ,SCOPE_ID = ?
            ,SOURCE_ID = ?
            ,SOURCE_LOCATION = ?
            ,STATUS_ID = ?
            ,BUSINESS_JUSTIFICATION = ?
            ,REMOTE_USER = \'STAGING\'
            ,RECORD_TIME = CURRENT TIMESTAMP
            ,level = ?
            ,HW_OWNER = ?
            ,SERIAL = ?
            ,MACHINE_TYPE = ?
            ,HOSTNAME = ?
        where
            id = ?
    ';
    return ('updateScheduleFHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteScheduleFHistory};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from schedule_f_h
        where
            id = ?
    ';
    return ('deleteScheduleFHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyScheduleFHistory};
    my $scheduleFId;
    my $softwareId;
    my $customerId;
    my $softwareTitile;
    my $softwareName;
    my $manufacturer;
    my $scopeId;
    my $sourceId;
    my $sourceLocation;
    my $statusId;
    my $businessJustification;
    my $remoteUser;
    my $recordTime;
    my $level;
    my $hwOwner;
    my $serial;
    my $machineType;
    my $hostname;
    $sth->bind_columns(
        \$scheduleFId
        ,\$softwareId
        ,\$customerId
        ,\$softwareTitile
        ,\$softwareName
        ,\$manufacturer
        ,\$scopeId
        ,\$sourceId
        ,\$sourceLocation
        ,\$statusId
        ,\$businessJustification
        ,\$remoteUser
        ,\$recordTime
        ,\$level
        ,\$hwOwner
        ,\$serial
        ,\$machineType
        ,\$hostname
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->scheduleFId($scheduleFId);
    $self->softwareId($softwareId);
    $self->customerId($customerId);
    $self->softwareTitile($softwareTitile);
    $self->softwareName($softwareName);
    $self->manufacturer($manufacturer);
    $self->scopeId($scopeId);
    $self->sourceId($sourceId);
    $self->sourceLocation($sourceLocation);
    $self->statusId($statusId);
    $self->businessJustification($businessJustification);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->level($level);
    $self->hwOwner($hwOwner);
    $self->serial($serial);
    $self->machineType($machineType);
    $self->hostname($hostname);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            SCHEDULE_F_ID
            ,software_id
            ,CUSTOMER_ID
            ,SOFTWARE_TITLE
            ,SOFTWARE_NAME
            ,MANUFACTURER
            ,SCOPE_ID
            ,SOURCE_ID
            ,SOURCE_LOCATION
            ,STATUS_ID
            ,BUSINESS_JUSTIFICATION
            ,REMOTE_USER
            ,RECORD_TIME
            ,level
            ,HW_OWNER
            ,SERIAL
            ,MACHINE_TYPE
            ,HOSTNAME
        from
            schedule_f_h
        where
            id = ?
     with ur';
    return ('getByIdKeyScheduleFHistory', $query);
}

1;
