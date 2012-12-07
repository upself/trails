package Staging::OM::HardwareLpar;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_name => undef
        ,_customerId => undef
        ,_hardwareId => undef
        ,_status => undef
        ,_extId => undef
        ,_techImageId => undef
        ,_serverType => undef
        ,_lparStatus => undef
        ,_partMIPS => undef
        ,_partMSU => undef
        ,_action => undef
        ,_updateDate => undef
        ,_hardwareKey => undef
        ,_table => 'hardware_lpar'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->extId && defined $object->extId) {
        $equal = 1 if $self->extId eq $object->extId;
    }
    $equal = 1 if (!defined $self->extId && !defined $object->extId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->techImageId && defined $object->techImageId) {
        $equal = 1 if $self->techImageId eq $object->techImageId;
    }
    $equal = 1 if (!defined $self->techImageId && !defined $object->techImageId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverType && defined $object->serverType) {
        $equal = 1 if $self->serverType eq $object->serverType;
    }
    $equal = 1 if (!defined $self->serverType && !defined $object->serverType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lparStatus && defined $object->lparStatus) {
        $equal = 1 if $self->lparStatus eq $object->lparStatus;
    }
    $equal = 1 if (!defined $self->lparStatus && !defined $object->lparStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->partMIPS && defined $object->partMIPS) {
        $equal = 1 if $self->partMIPS eq $object->partMIPS;
    }
    $equal = 1 if (!defined $self->partMIPS && !defined $object->partMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->partMSU && defined $object->partMSU) {
        $equal = 1 if $self->partMSU eq $object->partMSU;
    }
    $equal = 1 if (!defined $self->partMSU && !defined $object->partMSU);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hardwareKey && defined $object->hardwareKey) {
        $equal = 1 if $self->hardwareKey eq $object->hardwareKey;
    }
    $equal = 1 if (!defined $self->hardwareKey && !defined $object->hardwareKey);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub hardwareId {
    my $self = shift;
    $self->{_hardwareId} = shift if scalar @_ == 1;
    return $self->{_hardwareId};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub extId {
    my $self = shift;
    $self->{_extId} = shift if scalar @_ == 1;
    return $self->{_extId};
}

sub techImageId {
    my $self = shift;
    $self->{_techImageId} = shift if scalar @_ == 1;
    return $self->{_techImageId};
}

sub serverType {
    my $self = shift;
    $self->{_serverType} = shift if scalar @_ == 1;
    return $self->{_serverType};
}

sub lparStatus {
    my $self = shift;
    $self->{_lparStatus} = shift if scalar @_ == 1;
    return $self->{_lparStatus};
}

sub partMIPS {
    my $self = shift;
    $self->{_partMIPS} = shift if scalar @_ == 1;
    return $self->{_partMIPS};
}

sub partMSU {
    my $self = shift;
    $self->{_partMSU} = shift if scalar @_ == 1;
    return $self->{_partMSU};
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

sub hardwareKey {
    my $self = shift;
    $self->{_hardwareKey} = shift if scalar @_ == 1;
    return $self->{_hardwareKey};
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
    my $s = "[HardwareLpar] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "hardwareId=";
    if (defined $self->{_hardwareId}) {
        $s .= $self->{_hardwareId};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "extId=";
    if (defined $self->{_extId}) {
        $s .= $self->{_extId};
    }
    $s .= ",";
    $s .= "techImageId=";
    if (defined $self->{_techImageId}) {
        $s .= $self->{_techImageId};
    }
    $s .= ",";
    $s .= "serverType=";
    if (defined $self->{_serverType}) {
        $s .= $self->{_serverType};
    }
    $s .= ",";
    $s .= "lparStatus=";
    if (defined $self->{_lparStatus}) {
        $s .= $self->{_lparStatus};
    }
    $s .= ",";
    $s .= "partMIPS=";
    if (defined $self->{_partMIPS}) {
        $s .= $self->{_partMIPS};
    }
    $s .= ",";
    $s .= "partMSU=";
    if (defined $self->{_partMSU}) {
        $s .= $self->{_partMSU};
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
    $s .= "hardwareKey=";
    if (defined $self->{_hardwareKey}) {
        $s .= $self->{_hardwareKey};
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
        my $sth = $connection->sql->{insertHardwareLpar};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->name
            ,$self->customerId
            ,$self->hardwareId
            ,$self->status
            ,$self->extId
            ,$self->techImageId
            ,$self->serverType
            ,$self->lparStatus
            ,$self->partMIPS
            ,$self->partMSU
            ,$self->action
            ,$self->updateDate
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHardwareLpar};
        $sth->execute(
            $self->name
            ,$self->customerId
            ,$self->hardwareId
            ,$self->status
            ,$self->extId
            ,$self->techImageId
            ,$self->serverType
            ,$self->lparStatus
            ,$self->partMIPS
            ,$self->partMSU
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
        insert into hardware_lpar (
            name
            ,customer_id
            ,hardware_id
            ,status
            ,ext_id
            ,tech_image_id
            ,server_type
            ,lpar_status
            ,part_mips
            ,part_msu
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
        ))
    ';
    return ('insertHardwareLpar', $query);
}

sub queryUpdate {
    my $query = '
        update hardware_lpar
        set
            name = ?
            ,customer_id = ?
            ,hardware_id = ?
            ,status = ?
            ,ext_id = ?
            ,tech_image_id = ?
            ,server_type = ?
            ,lpar_status = ?
            ,part_mips = ?
            ,part_msu = ?
            ,action = ?
            ,update_date = ?
        where
            id = ?
    ';
    return ('updateHardwareLpar', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteHardwareLpar};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from hardware_lpar
        where
            id = ?
    ';
    return ('deleteHardwareLpar', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHardwareLpar};
    my $name;
    my $customerId;
    my $hardwareId;
    my $status;
    my $extId;
    my $techImageId;
    my $serverType;
    my $lparStatus;
    my $partMIPS;
    my $partMSU;
    my $action;
    my $updateDate;
    $sth->bind_columns(
        \$name
        ,\$customerId
        ,\$hardwareId
        ,\$status
        ,\$extId
        ,\$techImageId
        ,\$serverType
        ,\$lparStatus
        ,\$partMIPS
        ,\$partMSU
        ,\$action
        ,\$updateDate
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->name($name);
    $self->customerId($customerId);
    $self->hardwareId($hardwareId);
    $self->status($status);
    $self->extId($extId);
    $self->techImageId($techImageId);
    $self->serverType($serverType);
    $self->lparStatus($lparStatus);
    $self->partMIPS($partMIPS);
    $self->partMSU($partMSU);
    $self->action($action);
    $self->updateDate($updateDate);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            name
            ,customer_id
            ,hardware_id
            ,status
            ,ext_id
            ,tech_image_id
            ,server_type
            ,lpar_status
            ,part_mips
            ,part_msu
            ,action
            ,update_date
        from
            hardware_lpar
        where
            id = ?
    ';
    return ('getByIdKeyHardwareLpar', $query);
}

1;
