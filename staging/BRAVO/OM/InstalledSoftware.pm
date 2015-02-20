package BRAVO::OM::InstalledSoftware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_softwareId => undef
        ,_discrepancyTypeId => undef
        ,_users => undef
        ,_processorCount => undef
        ,_authenticated => undef
        ,_version => undef
        ,_researchFlag => undef
        ,_invalidCategory => undef
        ,_status => undef
        ,_action => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'installed_software'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->softwareLparId && defined $object->softwareLparId) {
        $equal = 1 if $self->softwareLparId eq $object->softwareLparId;
    }
    $equal = 1 if (!defined $self->softwareLparId && !defined $object->softwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->discrepancyTypeId && defined $object->discrepancyTypeId) {
        $equal = 1 if $self->discrepancyTypeId eq $object->discrepancyTypeId;
    }
    $equal = 1 if (!defined $self->discrepancyTypeId && !defined $object->discrepancyTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->users && defined $object->users) {
        $equal = 1 if $self->users eq $object->users;
    }
    $equal = 1 if (!defined $self->users && !defined $object->users);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->authenticated && defined $object->authenticated) {
        $equal = 1 if $self->authenticated eq $object->authenticated;
    }
    $equal = 1 if (!defined $self->authenticated && !defined $object->authenticated);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->version && defined $object->version) {
        $equal = 1 if $self->version eq $object->version;
    }
    $equal = 1 if (!defined $self->version && !defined $object->version);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->researchFlag && defined $object->researchFlag) {
        $equal = 1 if $self->researchFlag eq $object->researchFlag;
    }
    $equal = 1 if (!defined $self->researchFlag && !defined $object->researchFlag);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->invalidCategory && defined $object->invalidCategory) {
        $equal = 1 if $self->invalidCategory eq $object->invalidCategory;
    }
    $equal = 1 if (!defined $self->invalidCategory && !defined $object->invalidCategory);
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

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
}

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
}

sub discrepancyTypeId {
    my $self = shift;
    $self->{_discrepancyTypeId} = shift if scalar @_ == 1;
    return $self->{_discrepancyTypeId};
}

sub users {
    my $self = shift;
    $self->{_users} = shift if scalar @_ == 1;
    return $self->{_users};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
}

sub authenticated {
    my $self = shift;
    $self->{_authenticated} = shift if scalar @_ == 1;
    return $self->{_authenticated};
}

sub version {
    my $self = shift;
    $self->{_version} = shift if scalar @_ == 1;
    return $self->{_version};
}

sub researchFlag {
    my $self = shift;
    $self->{_researchFlag} = shift if scalar @_ == 1;
    return $self->{_researchFlag};
}

sub invalidCategory {
    my $self = shift;
    $self->{_invalidCategory} = shift if scalar @_ == 1;
    return $self->{_invalidCategory};
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
    my $s = "[InstalledSoftware] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "softwareLparId=";
    if (defined $self->{_softwareLparId}) {
        $s .= $self->{_softwareLparId};
    }
    $s .= ",";
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
    }
    $s .= ",";
    $s .= "discrepancyTypeId=";
    if (defined $self->{_discrepancyTypeId}) {
        $s .= $self->{_discrepancyTypeId};
    }
    $s .= ",";
    $s .= "users=";
    if (defined $self->{_users}) {
        $s .= $self->{_users};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
    }
    $s .= ",";
    $s .= "authenticated=";
    if (defined $self->{_authenticated}) {
        $s .= $self->{_authenticated};
    }
    $s .= ",";
    $s .= "version=";
    if (defined $self->{_version}) {
        $s .= $self->{_version};
    }
    $s .= ",";
    $s .= "researchFlag=";
    if (defined $self->{_researchFlag}) {
        $s .= $self->{_researchFlag};
    }
    $s .= ",";
    $s .= "invalidCategory=";
    if (defined $self->{_invalidCategory}) {
        $s .= $self->{_invalidCategory};
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
        my $sth = $connection->sql->{insertInstalledSoftware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLparId
            ,$self->softwareId
            ,$self->discrepancyTypeId
            ,$self->users
            ,$self->processorCount
            ,$self->authenticated
            ,$self->version
            ,$self->researchFlag
            ,$self->invalidCategory
            ,$self->status
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateInstalledSoftware};
        $sth->execute(
            $self->softwareLparId
            ,$self->softwareId
            ,$self->discrepancyTypeId
            ,$self->users
            ,$self->processorCount
            ,$self->authenticated
            ,$self->version
            ,$self->researchFlag
            ,$self->invalidCategory
            ,$self->status
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
        insert into installed_software (
            software_lpar_id
            ,software_id
            ,discrepancy_type_id
            ,users
            ,processor_count
            ,authenticated
            ,version
            ,research_flag
            ,invalid_category
            ,status
            ,remote_user
            ,record_time
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
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertInstalledSoftware', $query);
}

sub queryUpdate {
    my $query = '
        update installed_software
        set
            software_lpar_id = ?
            ,software_id = ?
            ,discrepancy_type_id = ?
            ,users = ?
            ,processor_count = ?
            ,authenticated = ?
            ,version = ?
            ,research_flag = ?
            ,invalid_category = ?
            ,status = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateInstalledSoftware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledSoftware};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from installed_software
        where
            id = ?
    ';
    return ('deleteInstalledSoftware', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledSoftware};
    my $id;
    my $discrepancyTypeId;
    my $users;
    my $processorCount;
    my $authenticated;
    my $version;
    my $researchFlag;
    my $invalidCategory;
    my $status;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$discrepancyTypeId
        ,\$users
        ,\$processorCount
        ,\$authenticated
        ,\$version
        ,\$researchFlag
        ,\$invalidCategory
        ,\$status
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->softwareLparId
        ,$self->softwareId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->discrepancyTypeId($discrepancyTypeId);
    $self->users($users);
    $self->processorCount($processorCount);
    $self->authenticated($authenticated);
    $self->version($version);
    $self->researchFlag($researchFlag);
    $self->invalidCategory($invalidCategory);
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,discrepancy_type_id
            ,users
            ,processor_count
            ,authenticated
            ,version
            ,research_flag
            ,invalid_category
            ,status
            ,remote_user
            ,record_time
        from
            installed_software
        where
            software_lpar_id = ?
            and software_id = ?
     with ur';
    return ('getByBizKeyInstalledSoftware', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyInstalledSoftware};
    my $softwareLparId;
    my $softwareId;
    my $discrepancyTypeId;
    my $users;
    my $processorCount;
    my $authenticated;
    my $version;
    my $researchFlag;
    my $invalidCategory;
    my $status;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$softwareLparId
        ,\$softwareId
        ,\$discrepancyTypeId
        ,\$users
        ,\$processorCount
        ,\$authenticated
        ,\$version
        ,\$researchFlag
        ,\$invalidCategory
        ,\$status
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareLparId($softwareLparId);
    $self->softwareId($softwareId);
    $self->discrepancyTypeId($discrepancyTypeId);
    $self->users($users);
    $self->processorCount($processorCount);
    $self->authenticated($authenticated);
    $self->version($version);
    $self->researchFlag($researchFlag);
    $self->invalidCategory($invalidCategory);
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,software_id
            ,discrepancy_type_id
            ,users
            ,processor_count
            ,authenticated
            ,version
            ,research_flag
            ,invalid_category
            ,status
            ,remote_user
            ,record_time
        from
            installed_software
        where
            id = ?
     with ur';
    return ('getByIdKeyInstalledSoftware', $query);
}

1;
