package Recon::OM::AlertHardwareLparHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_alertHardwareLparId => undef
        ,_comments => undef
        ,_open => undef
        ,_creationTime => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'alert_hw_lpar_h'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->alertHardwareLparId && defined $object->alertHardwareLparId) {
        $equal = 1 if $self->alertHardwareLparId eq $object->alertHardwareLparId;
    }
    $equal = 1 if (!defined $self->alertHardwareLparId && !defined $object->alertHardwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comments && defined $object->comments) {
        $equal = 1 if $self->comments eq $object->comments;
    }
    $equal = 1 if (!defined $self->comments && !defined $object->comments);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->open && defined $object->open) {
        $equal = 1 if $self->open eq $object->open;
    }
    $equal = 1 if (!defined $self->open && !defined $object->open);
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

sub alertHardwareLparId {
    my $self = shift;
    $self->{_alertHardwareLparId} = shift if scalar @_ == 1;
    return $self->{_alertHardwareLparId};
}

sub comments {
    my $self = shift;
    $self->{_comments} = shift if scalar @_ == 1;
    return $self->{_comments};
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
    my $s = "[AlertHardwareLparHistory] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "alertHardwareLparId=";
    if (defined $self->{_alertHardwareLparId}) {
        $s .= $self->{_alertHardwareLparId};
    }
    $s .= ",";
    $s .= "comments=";
    if (defined $self->{_comments}) {
        $s .= $self->{_comments};
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
        my $sth = $connection->sql->{insertAlertHardwareLparHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->alertHardwareLparId
            ,$self->comments
            ,$self->open
            ,$self->creationTime
            ,$self->recordTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateAlertHardwareLparHistory};
        $sth->execute(
            $self->alertHardwareLparId
            ,$self->comments
            ,$self->open
            ,$self->creationTime
            ,$self->recordTime
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
        insert into alert_hw_lpar_h (
            alert_hw_lpar_id
            ,comments
            ,open
            ,creation_time
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,\'STAGING\'
            ,?
        ))
    ';
    return ('insertAlertHardwareLparHistory', $query);
}

sub queryUpdate {
    my $query = '
        update alert_hw_lpar_h
        set
            alert_hw_lpar_id = ?
            ,comments = ?
            ,open = ?
            ,creation_time = ?
            ,remote_user = \'STAGING\'
            ,record_time = ?
        where
            id = ?
    ';
    return ('updateAlertHardwareLparHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteAlertHardwareLparHistory};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from alert_hw_lpar_h
        where
            id = ?
    ';
    return ('deleteAlertHardwareLparHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyAlertHardwareLparHistory};
    my $alertHardwareLparId;
    my $comments;
    my $open;
    my $creationTime;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$alertHardwareLparId
        ,\$comments
        ,\$open
        ,\$creationTime
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->alertHardwareLparId($alertHardwareLparId);
    $self->comments($comments);
    $self->open($open);
    $self->creationTime($creationTime);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            alert_hw_lpar_id
            ,comments
            ,open
            ,creation_time
            ,remote_user
            ,record_time
        from
            alert_hw_lpar_h
        where
            id = ?
    ';
    return ('getByIdKeyAlertHardwareLparHistory', $query);
}

1;
