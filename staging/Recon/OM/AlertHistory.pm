package Recon::OM::AlertHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_alertId => undef
        ,_customerId => undef
        ,_alertTypeId => undef
        ,_alertCauseId => undef
        ,_open => undef
        ,_creationTime => undef
        ,_recordTime => undef
        ,_remoteUser => 'STAGING'
        ,_assignee => undef
        ,_comment => undef
        ,_table => 'alert'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->alertId && defined $object->alertId) {
        $equal = 1 if $self->alertId eq $object->alertId;
    }
    $equal = 1 if (!defined $self->alertId && !defined $object->alertId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->alertTypeId && defined $object->alertTypeId) {
        $equal = 1 if $self->alertTypeId eq $object->alertTypeId;
    }
    $equal = 1 if (!defined $self->alertTypeId && !defined $object->alertTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->alertCauseId && defined $object->alertCauseId) {
        $equal = 1 if $self->alertCauseId eq $object->alertCauseId;
    }
    $equal = 1 if (!defined $self->alertCauseId && !defined $object->alertCauseId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->open && defined $object->open) {
        $equal = 1 if $self->open eq $object->open;
    }
    $equal = 1 if (!defined $self->open && !defined $object->open);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comment && defined $object->comment) {
        $equal = 1 if $self->comment eq $object->comment;
    }
    $equal = 1 if (!defined $self->comment && !defined $object->comment);
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

sub alertId {
    my $self = shift;
    $self->{_alertId} = shift if scalar @_ == 1;
    return $self->{_alertId};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub alertTypeId {
    my $self = shift;
    $self->{_alertTypeId} = shift if scalar @_ == 1;
    return $self->{_alertTypeId};
}

sub alertCauseId {
    my $self = shift;
    $self->{_alertCauseId} = shift if scalar @_ == 1;
    return $self->{_alertCauseId};
}

sub open {
    my $self = shift;
    $self->{_open} = shift if scalar @_ == 1;
    return $self->{_open};
}

sub creationTime {
    my $self = shift;
    $self->{_creationTime} = shift if scalar @_ == 1;
    return $self->{_creationTime};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
}

sub remoteUser {
    my $self = shift;
    $self->{_remoteUser} = shift if scalar @_ == 1;
    return $self->{_remoteUser};
}

sub assignee {
    my $self = shift;
    $self->{_assignee} = shift if scalar @_ == 1;
    return $self->{_assignee};
}

sub comment {
    my $self = shift;
    $self->{_comment} = shift if scalar @_ == 1;
    return $self->{_comment};
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
    my $s = "[AlertHistory] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "alertId=";
    if (defined $self->{_alertId}) {
        $s .= $self->{_alertId};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "alertTypeId=";
    if (defined $self->{_alertTypeId}) {
        $s .= $self->{_alertTypeId};
    }
    $s .= ",";
    $s .= "alertCauseId=";
    if (defined $self->{_alertCauseId}) {
        $s .= $self->{_alertCauseId};
    }
    $s .= ",";
    $s .= "open=";
    if (defined $self->{_open}) {
        $s .= $self->{_open};
    }
    $s .= ",";
    $s .= "creationTime=";
    if (defined $self->{_creationTime}) {
        $s .= $self->{_creationTime};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
    }
    $s .= ",";
    $s .= "remoteUser=";
    if (defined $self->{_remoteUser}) {
        $s .= $self->{_remoteUser};
    }
    $s .= ",";
    $s .= "assignee=";
    if (defined $self->{_assignee}) {
        $s .= $self->{_assignee};
    }
    $s .= ",";
    $s .= "comment=";
    if (defined $self->{_comment}) {
        $s .= $self->{_comment};
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
        my $sth = $connection->sql->{insertAlertHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->alertId
            ,$self->customerId
            ,$self->alertTypeId
            ,$self->alertCauseId
            ,$self->open
            ,$self->creationTime
            ,$self->recordTime
            ,$self->assignee
            ,$self->comment
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateAlertHistory};
        $sth->execute(
            $self->alertId
            ,$self->customerId
            ,$self->alertTypeId
            ,$self->alertCauseId
            ,$self->open
            ,$self->creationTime
            ,$self->recordTime
            ,$self->assignee
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
        insert into h_alert (
            alert_id
            ,customer_id
            ,alert_type_id
            ,alert_cause_id
            ,open
            ,creation_time
            ,record_time
            ,remote_user
            ,assignee
            ,comment
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,\'STAGING\'
            ,?
            ,?
        ))
    ';
    return ('insertAlertHistory', $query);
}

sub queryUpdate {
    my $query = '
        update h_alert
        set
            alert_id = ?
            ,customer_id = ?
            ,alert_type_id = ?
            ,alert_cause_id = ?
            ,open = ?
            ,creation_time = ?
            ,record_time = ?
            ,remote_user = \'STAGING\'
            ,assignee = ?
            ,comment = ?
        where
            id = ?
    ';
    return ('updateAlertHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteAlertHistory};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from h_alert
        where
            id = ?
    ';
    return ('deleteAlertHistory', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyAlertHistory};
    my $id;
    my $alertId;
    my $customerId;
    my $alertTypeId;
    my $alertCauseId;
    my $open;
    my $creationTime;
    my $recordTime;
    my $remoteUser;
    my $assignee;
    my $comment;
    $sth->bind_columns(
        \$id
        ,\$alertId
        ,\$customerId
        ,\$alertTypeId
        ,\$alertCauseId
        ,\$open
        ,\$creationTime
        ,\$recordTime
        ,\$remoteUser
        ,\$assignee
        ,\$comment
    );
    $sth->execute(
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->alertId($alertId);
    $self->customerId($customerId);
    $self->alertTypeId($alertTypeId);
    $self->alertCauseId($alertCauseId);
    $self->open($open);
    $self->creationTime($creationTime);
    $self->recordTime($recordTime);
    $self->remoteUser($remoteUser);
    $self->assignee($assignee);
    $self->comment($comment);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,alert_id
            ,customer_id
            ,alert_type_id
            ,alert_cause_id
            ,open
            ,creation_time
            ,record_time
            ,remote_user
            ,assignee
            ,comment
        from
            h_alert
        where
     with ur';
    return ('getByBizKeyAlertHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyAlertHistory};
    my $alertId;
    my $customerId;
    my $alertTypeId;
    my $alertCauseId;
    my $open;
    my $creationTime;
    my $recordTime;
    my $remoteUser;
    my $assignee;
    my $comment;
    $sth->bind_columns(
        \$alertId
        ,\$customerId
        ,\$alertTypeId
        ,\$alertCauseId
        ,\$open
        ,\$creationTime
        ,\$recordTime
        ,\$remoteUser
        ,\$assignee
        ,\$comment
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->alertId($alertId);
    $self->customerId($customerId);
    $self->alertTypeId($alertTypeId);
    $self->alertCauseId($alertCauseId);
    $self->open($open);
    $self->creationTime($creationTime);
    $self->recordTime($recordTime);
    $self->remoteUser($remoteUser);
    $self->assignee($assignee);
    $self->comment($comment);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            alert_id
            ,customer_id
            ,alert_type_id
            ,alert_cause_id
            ,open
            ,creation_time
            ,record_time
            ,remote_user
            ,assignee
            ,comment
        from
            h_alert
        where
            id = ?
     with ur';
    return ('getByIdKeyAlertHistory', $query);
}

1;
