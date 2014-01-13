package Recon::OM::AlertExpiredScan;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_comments => undef
        ,_open => undef
        ,_creationTime => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'alert_expired_scan'
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

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
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
    my $s = "[AlertExpiredScan] ";
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
        my $sth = $connection->sql->{insertAlertExpiredScan};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLparId
            ,$self->comments
            ,$self->open
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateAlertExpiredScan};
        $sth->execute(
            $self->softwareLparId
            ,$self->comments
            ,$self->open
            ,$self->creationTime
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
        insert into alert_expired_scan (
            software_lpar_id
            ,comments
            ,open
            ,creation_time
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,CURRENT TIMESTAMP
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertAlertExpiredScan', $query);
}

sub queryUpdate {
    my $query = '
        update alert_expired_scan
        set
            software_lpar_id = ?
            ,comments = ?
            ,open = ?
            ,creation_time = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateAlertExpiredScan', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteAlertExpiredScan};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from alert_expired_scan a where
            exists ( select b.id from alert_expired_scan b where b.id = ?
            and a.software_lpar_id = b.software_lpar_id 
            and a.comments = b.comments 
            and a.open = b.open 
)    ';
    return ('deleteAlertExpiredScan', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyAlertExpiredScan};
    my $id;
    my $comments;
    my $open;
    my $creationTime;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$comments
        ,\$open
        ,\$creationTime
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->softwareLparId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->comments($comments);
    $self->open($open);
    $self->creationTime($creationTime);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,comments
            ,open
            ,creation_time
            ,remote_user
            ,record_time
        from
            alert_expired_scan
        where
            software_lpar_id = ?
    ';
    return ('getByBizKeyAlertExpiredScan', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyAlertExpiredScan};
    my $softwareLparId;
    my $comments;
    my $open;
    my $creationTime;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$softwareLparId
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
    $self->softwareLparId($softwareLparId);
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
            software_lpar_id
            ,comments
            ,open
            ,creation_time
            ,remote_user
            ,record_time
        from
            alert_expired_scan
        where
            id = ?
    ';
    return ('getByIdKeyAlertExpiredScan', $query);
}

1;
