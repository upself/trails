package BRAVO::OM::HardwareLpar;

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
        ,_action => 0
        ,_remoteUser => 'ATP'
        ,_recordTime => undef
        ,_extId => undef
        ,_spla => undef
        ,_sysplex => undef
        ,_internetIccFlag => undef
        ,_techImageId => undef
        ,_serverType => undef
        ,_lparStatus => undef
        ,_partMIPS => undef
        ,_partMSU => undef
        ,_partGartnerMIPS => undef
        ,_effectiveThreads => undef
        ,_backupMethod => undef
        ,_clusterType => undef
        ,_vMobilRestrict => undef
        ,_cappedLpar => undef
        ,_virtualFlag => undef
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
    if (defined $self->hardwareId && defined $object->hardwareId) {
        $equal = 1 if $self->hardwareId eq $object->hardwareId;
    }
    $equal = 1 if (!defined $self->hardwareId && !defined $object->hardwareId);
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
    if (defined $self->extId && defined $object->extId) {
        $equal = 1 if $self->extId eq $object->extId;
    }
    $equal = 1 if (!defined $self->extId && !defined $object->extId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->spla && defined $object->spla) {
        $equal = 1 if $self->spla eq $object->spla;
    }
    $equal = 1 if (!defined $self->spla && !defined $object->spla);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sysplex && defined $object->sysplex) {
        $equal = 1 if $self->sysplex eq $object->sysplex;
    }
    $equal = 1 if (!defined $self->sysplex && !defined $object->sysplex);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->internetIccFlag && defined $object->internetIccFlag) {
        $equal = 1 if $self->internetIccFlag eq $object->internetIccFlag;
    }
    $equal = 1 if (!defined $self->internetIccFlag && !defined $object->internetIccFlag);
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
    if (defined $self->partGartnerMIPS && defined $object->partGartnerMIPS) {
        $equal = 1 if $self->partGartnerMIPS eq $object->partGartnerMIPS;
    }
    $equal = 1 if (!defined $self->partGartnerMIPS && !defined $object->partGartnerMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->effectiveThreads && defined $object->effectiveThreads) {
        $equal = 1 if $self->effectiveThreads eq $object->effectiveThreads;
    }
    $equal = 1 if (!defined $self->effectiveThreads && !defined $object->effectiveThreads);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->backupMethod && defined $object->backupMethod) {
        $equal = 1 if $self->backupMethod eq $object->backupMethod;
    }
    $equal = 1 if (!defined $self->backupMethod && !defined $object->backupMethod);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->clusterType && defined $object->clusterType) {
        $equal = 1 if $self->clusterType eq $object->clusterType;
    }
    $equal = 1 if (!defined $self->clusterType && !defined $object->clusterType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->vMobilRestrict && defined $object->vMobilRestrict) {
        $equal = 1 if $self->vMobilRestrict eq $object->vMobilRestrict;
    }
    $equal = 1 if (!defined $self->vMobilRestrict && !defined $object->vMobilRestrict);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cappedLpar && defined $object->cappedLpar) {
        $equal = 1 if $self->cappedLpar eq $object->cappedLpar;
    }
    $equal = 1 if (!defined $self->cappedLpar && !defined $object->cappedLpar);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->virtualFlag && defined $object->virtualFlag) {
        $equal = 1 if $self->virtualFlag eq $object->virtualFlag;
    }
    $equal = 1 if (!defined $self->virtualFlag && !defined $object->virtualFlag);
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

sub extId {
    my $self = shift;
    $self->{_extId} = shift if scalar @_ == 1;
    return $self->{_extId};
}

sub spla {
    my $self = shift;
    $self->{_spla} = shift if scalar @_ == 1;
    return $self->{_spla};
}

sub sysplex {
    my $self = shift;
    $self->{_sysplex} = shift if scalar @_ == 1;
    return $self->{_sysplex};
}

sub internetIccFlag {
    my $self = shift;
    $self->{_internetIccFlag} = shift if scalar @_ == 1;
    return $self->{_internetIccFlag};
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

sub partGartnerMIPS {
    my $self = shift;
    $self->{_partGartnerMIPS} = shift if scalar @_ == 1;
    return $self->{_partGartnerMIPS};
}

sub effectiveThreads {
    my $self = shift;
    $self->{_effectiveThreads} = shift if scalar @_ == 1;
    return $self->{_effectiveThreads};
}

sub backupMethod {
    my $self = shift;
    $self->{_backupMethod} = shift if scalar @_ == 1;
    return $self->{_backupMethod};
}

sub clusterType {
    my $self = shift;
    $self->{_clusterType} = shift if scalar @_ == 1;
    return $self->{_clusterType};
}

sub vMobilRestrict {
    my $self = shift;
    $self->{_vMobilRestrict} = shift if scalar @_ == 1;
    return $self->{_vMobilRestrict};
}

sub cappedLpar {
    my $self = shift;
    $self->{_cappedLpar} = shift if scalar @_ == 1;
    return $self->{_cappedLpar};
}

sub virtualFlag {
    my $self = shift;
    $self->{_virtualFlag} = shift if scalar @_ == 1;
    return $self->{_virtualFlag};
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
    $s .= "extId=";
    if (defined $self->{_extId}) {
        $s .= $self->{_extId};
    }
    $s .= ",";
    $s .= "spla=";
    if (defined $self->{_spla}) {
        $s .= $self->{_spla};
    }
    $s .= ",";
    $s .= "sysplex=";
    if (defined $self->{_sysplex}) {
        $s .= $self->{_sysplex};
    }
    $s .= ",";
    $s .= "internetIccFlag=";
    if (defined $self->{_internetIccFlag}) {
        $s .= $self->{_internetIccFlag};
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
    $s .= "partGartnerMIPS=";
    if (defined $self->{_partGartnerMIPS}) {
        $s .= $self->{_partGartnerMIPS};
    }
    $s .= ",";
    $s .= "effectiveThreads=";
    if (defined $self->{_effectiveThreads}) {
        $s .= $self->{_effectiveThreads};
    }
    $s .= ",";
    $s .= "backupMethod=";
    if (defined $self->{_backupMethod}) {
        $s .= $self->{_backupMethod};
    }
    $s .= ",";
    $s .= "clusterType=";
    if (defined $self->{_clusterType}) {
        $s .= $self->{_clusterType};
    }
    $s .= ",";
    $s .= "vMobilRestrict=";
    if (defined $self->{_vMobilRestrict}) {
        $s .= $self->{_vMobilRestrict};
    }
    $s .= ",";
    $s .= "cappedLpar=";
    if (defined $self->{_cappedLpar}) {
        $s .= $self->{_cappedLpar};
    }
    $s .= ",";
    $s .= "virtualFlag=";
    if (defined $self->{_virtualFlag}) {
        $s .= $self->{_virtualFlag};
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
            ,$self->spla
            ,$self->sysplex
            ,$self->internetIccFlag
            ,$self->techImageId
            ,$self->serverType
            ,$self->lparStatus
            ,$self->partMIPS
            ,$self->partMSU
            ,$self->partGartnerMIPS
            ,$self->effectiveThreads
            ,$self->backupMethod
            ,$self->clusterType
            ,$self->vMobilRestrict
            ,$self->cappedLpar
            ,$self->virtualFlag
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
            ,$self->spla
            ,$self->sysplex
            ,$self->internetIccFlag
            ,$self->techImageId
            ,$self->serverType
            ,$self->lparStatus
            ,$self->partMIPS
            ,$self->partMSU
            ,$self->partGartnerMIPS
            ,$self->effectiveThreads
            ,$self->backupMethod
            ,$self->clusterType
            ,$self->vMobilRestrict
            ,$self->cappedLpar
            ,$self->virtualFlag
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
            ,remote_user
            ,record_time
            ,ext_id
            ,spla
            ,sysplex
            ,internet_icc_flag
            ,tech_image_id
            ,server_type
            ,lpar_status
            ,part_mips
            ,part_msu
            ,PART_GARTNER_MIPS
            ,EFFECTIVE_THREADS
            ,BACKUPMETHOD
            ,CLUSTER_TYPE
            ,VIRTUAL_MOBILITY_RESTRICTION
            ,CAPPED_LPAR
            ,VIRTUAL_FLAG
        ) values (
            ?
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
            ,remote_user = \'ATP\'
            ,record_time = CURRENT TIMESTAMP
            ,ext_id = ?
            ,spla = ?
            ,sysplex = ?
            ,internet_icc_flag = ?
            ,tech_image_id = ?
            ,server_type = ?
            ,lpar_status = ?
            ,part_mips = ?
            ,part_msu = ?
            ,PART_GARTNER_MIPS = ?
            ,EFFECTIVE_THREADS = ?
            ,BACKUPMETHOD = ?
            ,CLUSTER_TYPE = ?
            ,VIRTUAL_MOBILITY_RESTRICTION = ?
            ,CAPPED_LPAR = ?
            ,VIRTUAL_FLAG = ?
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

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyHardwareLpar};
    my $id;
    my $hardwareId;
    my $status;
    my $remoteUser;
    my $recordTime;
    my $extId;
    my $spla;
    my $sysplex;
    my $internetIccFlag;
    my $techImageId;
    my $serverType;
    my $lparStatus;
    my $partMIPS;
    my $partMSU;
    my $partGartnerMIPS;
    my $effectiveThreads;
    my $backupMethod;
    my $clusterType;
    my $vMobilRestrict;
    my $cappedLpar;
    my $virtualFlag;
    $sth->bind_columns(
        \$id
        ,\$hardwareId
        ,\$status
        ,\$remoteUser
        ,\$recordTime
        ,\$extId
        ,\$spla
        ,\$sysplex
        ,\$internetIccFlag
        ,\$techImageId
        ,\$serverType
        ,\$lparStatus
        ,\$partMIPS
        ,\$partMSU
        ,\$partGartnerMIPS
        ,\$effectiveThreads
        ,\$backupMethod
        ,\$clusterType
        ,\$vMobilRestrict
        ,\$cappedLpar
        ,\$virtualFlag
    );
    $sth->execute(
        $self->name
        ,$self->customerId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->hardwareId($hardwareId);
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->extId($extId);
    $self->spla($spla);
    $self->sysplex($sysplex);
    $self->internetIccFlag($internetIccFlag);
    $self->techImageId($techImageId);
    $self->serverType($serverType);
    $self->lparStatus($lparStatus);
    $self->partMIPS($partMIPS);
    $self->partMSU($partMSU);
    $self->partGartnerMIPS($partGartnerMIPS);
    $self->effectiveThreads($effectiveThreads);
    $self->backupMethod($backupMethod);
    $self->clusterType($clusterType);
    $self->vMobilRestrict($vMobilRestrict);
    $self->cappedLpar($cappedLpar);
    $self->virtualFlag($virtualFlag);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,hardware_id
            ,status
            ,remote_user
            ,record_time
            ,ext_id
            ,spla
            ,sysplex
            ,internet_icc_flag
            ,tech_image_id
            ,server_type
            ,lpar_status
            ,part_mips
            ,part_msu
            ,PART_GARTNER_MIPS
            ,EFFECTIVE_THREADS
            ,BACKUPMETHOD
            ,CLUSTER_TYPE
            ,VIRTUAL_MOBILITY_RESTRICTION
            ,CAPPED_LPAR
            ,VIRTUAL_FLAG
        from
            hardware_lpar
        where
            name = ?
            and customer_id = ?
    ';
    return ('getByBizKeyHardwareLpar', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHardwareLpar};
    my $name;
    my $customerId;
    my $hardwareId;
    my $status;
    my $remoteUser;
    my $recordTime;
    my $extId;
    my $spla;
    my $sysplex;
    my $internetIccFlag;
    my $techImageId;
    my $serverType;
    my $lparStatus;
    my $partMIPS;
    my $partMSU;
    my $partGartnerMIPS;
    my $effectiveThreads;
    my $backupMethod;
    my $clusterType;
    my $vMobilRestrict;
    my $cappedLpar;
    my $virtualFlag;
    $sth->bind_columns(
        \$name
        ,\$customerId
        ,\$hardwareId
        ,\$status
        ,\$remoteUser
        ,\$recordTime
        ,\$extId
        ,\$spla
        ,\$sysplex
        ,\$internetIccFlag
        ,\$techImageId
        ,\$serverType
        ,\$lparStatus
        ,\$partMIPS
        ,\$partMSU
        ,\$partGartnerMIPS
        ,\$effectiveThreads
        ,\$backupMethod
        ,\$clusterType
        ,\$vMobilRestrict
        ,\$cappedLpar
        ,\$virtualFlag
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
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->extId($extId);
    $self->spla($spla);
    $self->sysplex($sysplex);
    $self->internetIccFlag($internetIccFlag);
    $self->techImageId($techImageId);
    $self->serverType($serverType);
    $self->lparStatus($lparStatus);
    $self->partMIPS($partMIPS);
    $self->partMSU($partMSU);
    $self->partGartnerMIPS($partGartnerMIPS);
    $self->effectiveThreads($effectiveThreads);
    $self->backupMethod($backupMethod);
    $self->clusterType($clusterType);
    $self->vMobilRestrict($vMobilRestrict);
    $self->cappedLpar($cappedLpar);
    $self->virtualFlag($virtualFlag);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            name
            ,customer_id
            ,hardware_id
            ,status
            ,remote_user
            ,record_time
            ,ext_id
            ,spla
            ,sysplex
            ,internet_icc_flag
            ,tech_image_id
            ,server_type
            ,lpar_status
            ,part_mips
            ,part_msu
            ,PART_GARTNER_MIPS
            ,EFFECTIVE_THREADS
            ,BACKUPMETHOD
            ,CLUSTER_TYPE
            ,VIRTUAL_MOBILITY_RESTRICTION
            ,CAPPED_LPAR
            ,VIRTUAL_FLAG
        from
            hardware_lpar
        where
            id = ?
    ';
    return ('getByIdKeyHardwareLpar', $query);
}

1;
