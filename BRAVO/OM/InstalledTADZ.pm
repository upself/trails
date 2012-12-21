package BRAVO::OM::InstalledTADZ;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_installedSoftwareId => undef
        ,_mainframeFeatureId => undef
        ,_bankAccountId => undef
        ,_useCount => undef
        ,_lastUsed => undef
        ,_status => undef
        ,_action => undef
        ,_remoteUser => undef
        ,_recordTime => undef
        ,_table => 'installed_tadz'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->installedSoftwareId && defined $object->installedSoftwareId) {
        $equal = 1 if $self->installedSoftwareId eq $object->installedSoftwareId;
    }
    $equal = 1 if (!defined $self->installedSoftwareId && !defined $object->installedSoftwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->mainframeFeatureId && defined $object->mainframeFeatureId) {
        $equal = 1 if $self->mainframeFeatureId eq $object->mainframeFeatureId;
    }
    $equal = 1 if (!defined $self->mainframeFeatureId && !defined $object->mainframeFeatureId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bankAccountId && defined $object->bankAccountId) {
        $equal = 1 if $self->bankAccountId eq $object->bankAccountId;
    }
    $equal = 1 if (!defined $self->bankAccountId && !defined $object->bankAccountId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->useCount && defined $object->useCount) {
        $equal = 1 if $self->useCount eq $object->useCount;
    }
    $equal = 1 if (!defined $self->useCount && !defined $object->useCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lastUsed && defined $object->lastUsed) {
        $equal = 1 if $self->lastUsed eq $object->lastUsed;
    }
    $equal = 1 if (!defined $self->lastUsed && !defined $object->lastUsed);
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

sub installedSoftwareId {
    my $self = shift;
    $self->{_installedSoftwareId} = shift if scalar @_ == 1;
    return $self->{_installedSoftwareId};
}

sub mainframeFeatureId {
    my $self = shift;
    $self->{_mainframeFeatureId} = shift if scalar @_ == 1;
    return $self->{_mainframeFeatureId};
}

sub bankAccountId {
    my $self = shift;
    $self->{_bankAccountId} = shift if scalar @_ == 1;
    return $self->{_bankAccountId};
}

sub useCount {
    my $self = shift;
    $self->{_useCount} = shift if scalar @_ == 1;
    return $self->{_useCount};
}

sub lastUsed {
    my $self = shift;
    $self->{_lastUsed} = shift if scalar @_ == 1;
    return $self->{_lastUsed};
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
    my $s = "[InstalledTADZ] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "installedSoftwareId=";
    if (defined $self->{_installedSoftwareId}) {
        $s .= $self->{_installedSoftwareId};
    }
    $s .= ",";
    $s .= "mainframeFeatureId=";
    if (defined $self->{_mainframeFeatureId}) {
        $s .= $self->{_mainframeFeatureId};
    }
    $s .= ",";
    $s .= "bankAccountId=";
    if (defined $self->{_bankAccountId}) {
        $s .= $self->{_bankAccountId};
    }
    $s .= ",";
    $s .= "useCount=";
    if (defined $self->{_useCount}) {
        $s .= $self->{_useCount};
    }
    $s .= ",";
    $s .= "lastUsed=";
    if (defined $self->{_lastUsed}) {
        $s .= $self->{_lastUsed};
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
        my $sth = $connection->sql->{insertInstalledTADZ};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->installedSoftwareId
            ,$self->mainframeFeatureId
            ,$self->bankAccountId
            ,$self->useCount
            ,$self->lastUsed
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateInstalledTADZ};
        $sth->execute(
            $self->installedSoftwareId
            ,$self->mainframeFeatureId
            ,$self->bankAccountId
            ,$self->useCount
            ,$self->lastUsed
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
        insert into installed_tadz (
            installed_software_id
            ,mainframe_Feature_id
            ,bank_account_id
            ,use_count
            ,lastUsed
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertInstalledTADZ', $query);
}

sub queryUpdate {
    my $query = '
        update installed_tadz
        set
            installed_software_id = ?
            ,mainframe_Feature_id = ?
            ,bank_account_id = ?
            ,use_count = ?
            ,lastUsed = ?
        where
            id = ?
    ';
    return ('updateInstalledTADZ', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledTADZ};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from installed_tadz
        where
            id = ?
    ';
    return ('deleteInstalledTADZ', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledTADZ};
    my $id;
    my $useCount;
    my $lastUsed;
    $sth->bind_columns(
        \$id
        ,\$useCount
        ,\$lastUsed
    );
    $sth->execute(
        $self->installedSoftwareId
        ,$self->mainframeFeatureId
        ,$self->bankAccountId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->useCount($useCount);
    $self->lastUsed($lastUsed);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,use_count
            ,lastUsed
        from
            installed_tadz
        where
            installed_software_id = ?
            and mainframe_Feature_id = ?
            and bank_account_id = ?
    ';
    return ('getByBizKeyInstalledTADZ', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyInstalledTADZ};
    my $installedSoftwareId;
    my $mainframeFeatureId;
    my $bankAccountId;
    my $useCount;
    my $lastUsed;
    $sth->bind_columns(
        \$installedSoftwareId
        ,\$mainframeFeatureId
        ,\$bankAccountId
        ,\$useCount
        ,\$lastUsed
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->installedSoftwareId($installedSoftwareId);
    $self->mainframeFeatureId($mainframeFeatureId);
    $self->bankAccountId($bankAccountId);
    $self->useCount($useCount);
    $self->lastUsed($lastUsed);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            installed_software_id
            ,mainframe_Feature_id
            ,bank_account_id
            ,use_count
            ,lastUsed
        from
            installed_tadz
        where
            id = ?
    ';
    return ('getByIdKeyInstalledTADZ', $query);
}

1;
