package BRAVO::OM::ManualQueue;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_customerId => undef
        ,_softwareLparId => undef
        ,_hostname => undef
        ,_softwareId => undef
        ,_recordTime => undef
        ,_remoteUser => 'STAGING'
        ,_deleted => undef
        ,_comments => undef
        ,_table => 'manual_queue'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareLparId && defined $object->softwareLparId) {
        $equal = 1 if $self->softwareLparId eq $object->softwareLparId;
    }
    $equal = 1 if (!defined $self->softwareLparId && !defined $object->softwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hostname && defined $object->hostname) {
        $equal = 1 if $self->hostname eq $object->hostname;
    }
    $equal = 1 if (!defined $self->hostname && !defined $object->hostname);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
}

sub hostname {
    my $self = shift;
    $self->{_hostname} = shift if scalar @_ == 1;
    return $self->{_hostname};
}

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
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

sub deleted {
    my $self = shift;
    $self->{_deleted} = shift if scalar @_ == 1;
    return $self->{_deleted};
}

sub comments {
    my $self = shift;
    $self->{_comments} = shift if scalar @_ == 1;
    return $self->{_comments};
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
    my $s = "[ManualQueue] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "softwareLparId=";
    if (defined $self->{_softwareLparId}) {
        $s .= $self->{_softwareLparId};
    }
    $s .= ",";
    $s .= "hostname=";
    if (defined $self->{_hostname}) {
        $s .= $self->{_hostname};
    }
    $s .= ",";
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
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
    $s .= "deleted=";
    if (defined $self->{_deleted}) {
        $s .= $self->{_deleted};
    }
    $s .= ",";
    $s .= "comments=";
    if (defined $self->{_comments}) {
        $s .= $self->{_comments};
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
    if (!defined $self->remoteUser) {
        $self->remoteUser = "STAGING"
    }
    ilog("saving: ".$self->toString());
    if( ! defined $self->id ) {
        $connection->prepareSqlQuery($self->queryInsert());
        my $sth = $connection->sql->{insertManualQueue};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->customerId
            ,$self->softwareLparId
            ,$self->hostname
            ,$self->softwareId
            ,$self->remoteUser
            ,$self->deleted
            ,$self->comments
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateManualQueue};
        $sth->execute(
            $self->customerId
            ,$self->softwareLparId
            ,$self->hostname
            ,$self->softwareId
            ,$self->remoteUser
            ,$self->deleted
            ,$self->comments
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
        insert into manual_queue (
            customer_id
            ,software_lpar_id
            ,hostname
            ,software_id
            ,record_time
            ,remote_user
            ,deleted
            ,comments
        ) values (
            ?
            ,?
            ,?
            ,?
            ,CURRENT TIMESTAMP
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertManualQueue', $query);
}

sub queryUpdate {
    my $query = '
        update manual_queue
        set
            customer_id = ?
            ,software_lpar_id = ?
            ,hostname = ?
            ,software_id = ?
            ,record_time = CURRENT TIMESTAMP
            ,remote_user = ?
            ,deleted = ?
            ,comments = ?
        where
            id = ?
    ';
    return ('updateManualQueue', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteManualQueue};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from manual_queue
        where
            id = ?
    ';
    return ('deleteManualQueue', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyManualQueue};
    my $id;
    my $softwareLparId;
    my $recordTime;
    my $remoteUser;
    my $deleted;
    my $comments;
    $sth->bind_columns(
        \$id
        ,\$softwareLparId
        ,\$recordTime
        ,\$remoteUser
        ,\$deleted
        ,\$comments
    );
    $sth->execute(
        $self->customerId
        ,$self->hostname
        ,$self->softwareId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->softwareLparId($softwareLparId);
    $self->recordTime($recordTime);
    $self->remoteUser($remoteUser);
    $self->deleted($deleted);
    $self->comments($comments);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,software_lpar_id
            ,record_time
            ,remote_user
            ,deleted
            ,comments
        from
            manual_queue
        where
            customer_id = ?
            and hostname = ?
            and software_id = ?
     with ur';
    return ('getByBizKeyManualQueue', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyManualQueue};
    my $customerId;
    my $softwareLparId;
    my $hostname;
    my $softwareId;
    my $recordTime;
    my $remoteUser;
    my $deleted;
    my $comments;
    $sth->bind_columns(
        \$customerId
        ,\$softwareLparId
        ,\$hostname
        ,\$softwareId
        ,\$recordTime
        ,\$remoteUser
        ,\$deleted
        ,\$comments
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->customerId($customerId);
    $self->softwareLparId($softwareLparId);
    $self->hostname($hostname);
    $self->softwareId($softwareId);
    $self->recordTime($recordTime);
    $self->remoteUser($remoteUser);
    $self->deleted($deleted);
    $self->comments($comments);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            customer_id
            ,software_lpar_id
            ,hostname
            ,software_id
            ,record_time
            ,remote_user
            ,deleted
            ,comments
        from
            manual_queue
        where
            id = ?
     with ur';
    return ('getByIdKeyManualQueue', $query);
}

1;
