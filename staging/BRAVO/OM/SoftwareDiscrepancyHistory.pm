package BRAVO::OM::SoftwareDiscrepancyHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_installedSoftwareId => undef
        ,_action => undef
        ,_comment => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'software_discrepancy_h'
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
    if (defined $self->action && defined $object->action) {
        $equal = 1 if $self->action eq $object->action;
    }
    $equal = 1 if (!defined $self->action && !defined $object->action);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comment && defined $object->comment) {
        $equal = 1 if $self->comment eq $object->comment;
    }
    $equal = 1 if (!defined $self->comment && !defined $object->comment);
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

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub comment {
    my $self = shift;
    $self->{_comment} = shift if scalar @_ == 1;
    return $self->{_comment};
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
    my $s = "[SoftwareDiscrepancyHistory] ";
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
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "comment=";
    if (defined $self->{_comment}) {
        $s .= $self->{_comment};
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
        my $sth = $connection->sql->{insertSoftwareDiscrepancyHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->installedSoftwareId
            ,$self->action
            ,$self->comment
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSoftwareDiscrepancyHistory};
        $sth->execute(
            $self->installedSoftwareId
            ,$self->action
            ,$self->comment
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
        insert into software_discrepancy_h (
            installed_software_id
            ,action
            ,comment
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertSoftwareDiscrepancyHistory', $query);
}

sub queryUpdate {
    my $query = '
        update software_discrepancy_h
        set
            installed_software_id = ?
            ,action = ?
            ,comment = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateSoftwareDiscrepancyHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSoftwareDiscrepancyHistory};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_discrepancy_h
        where
            id = ?
    ';
    return ('deleteSoftwareDiscrepancyHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeySoftwareDiscrepancyHistory};
    my $installedSoftwareId;
    my $action;
    my $comment;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$installedSoftwareId
        ,\$action
        ,\$comment
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->installedSoftwareId($installedSoftwareId);
    $self->action($action);
    $self->comment($comment);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            installed_software_id
            ,action
            ,comment
            ,remote_user
            ,record_time
        from
            software_discrepancy_h
        where
            id = ?
     with ur';
    return ('getByIdKeySoftwareDiscrepancyHistory', $query);
}

1;
