package Recon::OM::ReconcileH;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_reconcileTypeId => undef
        ,_installedSoftwareId => undef
        ,_parentInstalledSoftwareId => undef
        ,_comments => undef
        ,_machineLevel => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_manualBreak => undef
        ,_table => 'reconcile'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->reconcileTypeId && defined $object->reconcileTypeId) {
        $equal = 1 if $self->reconcileTypeId eq $object->reconcileTypeId;
    }
    $equal = 1 if (!defined $self->reconcileTypeId && !defined $object->reconcileTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->installedSoftwareId && defined $object->installedSoftwareId) {
        $equal = 1 if $self->installedSoftwareId eq $object->installedSoftwareId;
    }
    $equal = 1 if (!defined $self->installedSoftwareId && !defined $object->installedSoftwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->parentInstalledSoftwareId && defined $object->parentInstalledSoftwareId) {
        $equal = 1 if $self->parentInstalledSoftwareId eq $object->parentInstalledSoftwareId;
    }
    $equal = 1 if (!defined $self->parentInstalledSoftwareId && !defined $object->parentInstalledSoftwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comments && defined $object->comments) {
        $equal = 1 if $self->comments eq $object->comments;
    }
    $equal = 1 if (!defined $self->comments && !defined $object->comments);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->machineLevel && defined $object->machineLevel) {
        $equal = 1 if $self->machineLevel eq $object->machineLevel;
    }
    $equal = 1 if (!defined $self->machineLevel && !defined $object->machineLevel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->manualBreak && defined $object->manualBreak) {
        $equal = 1 if $self->manualBreak eq $object->manualBreak;
    }
    $equal = 1 if (!defined $self->manualBreak && !defined $object->manualBreak);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub reconcileTypeId {
    my $self = shift;
    $self->{_reconcileTypeId} = shift if scalar @_ == 1;
    return $self->{_reconcileTypeId};
}

sub installedSoftwareId {
    my $self = shift;
    $self->{_installedSoftwareId} = shift if scalar @_ == 1;
    return $self->{_installedSoftwareId};
}

sub parentInstalledSoftwareId {
    my $self = shift;
    $self->{_parentInstalledSoftwareId} = shift if scalar @_ == 1;
    return $self->{_parentInstalledSoftwareId};
}

sub comments {
    my $self = shift;
    $self->{_comments} = shift if scalar @_ == 1;
    return $self->{_comments};
}

sub machineLevel {
    my $self = shift;
    $self->{_machineLevel} = shift if scalar @_ == 1;
    return $self->{_machineLevel};
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

sub manualBreak {
    my $self = shift;
    $self->{_manualBreak} = shift if scalar @_ == 1;
    return $self->{_manualBreak};
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
    my $s = "[ReconcileH] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "reconcileTypeId=";
    if (defined $self->{_reconcileTypeId}) {
        $s .= $self->{_reconcileTypeId};
    }
    $s .= ",";
    $s .= "installedSoftwareId=";
    if (defined $self->{_installedSoftwareId}) {
        $s .= $self->{_installedSoftwareId};
    }
    $s .= ",";
    $s .= "parentInstalledSoftwareId=";
    if (defined $self->{_parentInstalledSoftwareId}) {
        $s .= $self->{_parentInstalledSoftwareId};
    }
    $s .= ",";
    $s .= "comments=";
    if (defined $self->{_comments}) {
        $s .= $self->{_comments};
    }
    $s .= ",";
    $s .= "machineLevel=";
    if (defined $self->{_machineLevel}) {
        $s .= $self->{_machineLevel};
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
    $s .= "manualBreak=";
    if (defined $self->{_manualBreak}) {
        $s .= $self->{_manualBreak};
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
        my $sth = $connection->sql->{insertReconcileH};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->reconcileTypeId
            ,$self->installedSoftwareId
            ,$self->parentInstalledSoftwareId
            ,$self->comments
            ,$self->machineLevel
            ,$self->manualBreak
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateReconcileH};
        $sth->execute(
            $self->reconcileTypeId
            ,$self->installedSoftwareId
            ,$self->parentInstalledSoftwareId
            ,$self->comments
            ,$self->machineLevel
            ,$self->manualBreak
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
        insert into reconcile_h (
            reconcile_type_id
            ,installed_software_id
            ,parent_installed_software_id
            ,comments
            ,machine_level
            ,remote_user
            ,record_time
            ,manual_break
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
            ,?
        ))
    ';
    return ('insertReconcileH', $query);
}

sub queryUpdate {
    my $query = '
        update reconcile_h
        set
            reconcile_type_id = ?
            ,installed_software_id = ?
            ,parent_installed_software_id = ?
            ,comments = ?
            ,machine_level = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
            ,manual_break = ?
        where
            id = ?
    ';
    return ('updateReconcileH', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteReconcileH};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from reconcile_h
        where
            id = ?
    ';
    return ('deleteReconcileH', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconcileH};
    my $id;
    my $reconcileTypeId;
    my $parentInstalledSoftwareId;
    my $comments;
    my $machineLevel;
    my $remoteUser;
    my $recordTime;
    my $manualBreak;
    $sth->bind_columns(
        \$id
        ,\$reconcileTypeId
        ,\$parentInstalledSoftwareId
        ,\$comments
        ,\$machineLevel
        ,\$remoteUser
        ,\$recordTime
        ,\$manualBreak
    );
    $sth->execute(
        $self->installedSoftwareId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->reconcileTypeId($reconcileTypeId);
    $self->parentInstalledSoftwareId($parentInstalledSoftwareId);
    $self->comments($comments);
    $self->machineLevel($machineLevel);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->manualBreak($manualBreak);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,reconcile_type_id
            ,parent_installed_software_id
            ,comments
            ,machine_level
            ,remote_user
            ,record_time
            ,manual_break
        from
            reconcile_h
        where
            installed_software_id = ?
    ';
    return ('getByBizKeyReconcileH', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconcileH};
    my $reconcileTypeId;
    my $installedSoftwareId;
    my $parentInstalledSoftwareId;
    my $comments;
    my $machineLevel;
    my $remoteUser;
    my $recordTime;
    my $manualBreak;
    $sth->bind_columns(
        \$reconcileTypeId
        ,\$installedSoftwareId
        ,\$parentInstalledSoftwareId
        ,\$comments
        ,\$machineLevel
        ,\$remoteUser
        ,\$recordTime
        ,\$manualBreak
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->reconcileTypeId($reconcileTypeId);
    $self->installedSoftwareId($installedSoftwareId);
    $self->parentInstalledSoftwareId($parentInstalledSoftwareId);
    $self->comments($comments);
    $self->machineLevel($machineLevel);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->manualBreak($manualBreak);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            reconcile_type_id
            ,installed_software_id
            ,parent_installed_software_id
            ,comments
            ,machine_level
            ,remote_user
            ,record_time
            ,manual_break
        from
            reconcile_h
        where
            id = ?
    ';
    return ('getByIdKeyReconcileH', $query);
}

1;
