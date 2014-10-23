package BRAVO::OM::SwassetQueue;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_customerId => undef
        ,_softwareLparId => undef
        ,_hostname => undef
        ,_recordTime => undef
        ,_remoteUser => 'STAGING'
        ,_type => undef
        ,_deleted => undef
        ,_comments => undef
        ,_table => 'swasset_queue'
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

sub type {
    my $self = shift;
    $self->{_type} = shift if scalar @_ == 1;
    return $self->{_type};
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
    my $s = "[SwassetQueue] ";
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
    $s .= "type=";
    if (defined $self->{_type}) {
        $s .= $self->{_type};
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
    ilog("saving: ".$self->toString());
    if( ! defined $self->id ) {
        $connection->prepareSqlQuery($self->queryInsert());
        my $sth = $connection->sql->{insertSwassetQueue};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->customerId
            ,$self->softwareLparId
            ,$self->hostname
            ,$self->type
            ,$self->deleted
            ,$self->comments
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSwassetQueue};
        $sth->execute(
            $self->customerId
            ,$self->softwareLparId
            ,$self->hostname
            ,$self->type
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
        insert into swasset_queue (
            customer_id
            ,software_lpar_id
            ,hostname
            ,record_time
            ,remote_user
            ,type
            ,deleted
            ,comments
        ) values (
            ?
            ,?
            ,?
            ,CURRENT TIMESTAMP
            ,\'STAGING\'
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertSwassetQueue', $query);
}

sub queryUpdate {
    my $query = '
        update swasset_queue
        set
            customer_id = ?
            ,software_lpar_id = ?
            ,hostname = ?
            ,record_time = CURRENT TIMESTAMP
            ,remote_user = \'STAGING\'
            ,type = ?
            ,deleted = ?
            ,comments = ?
        where
            id = ?
    ';
    return ('updateSwassetQueue', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSwassetQueue};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from swasset_queue
        where
            id = ?
    ';
    return ('deleteSwassetQueue', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeySwassetQueue};
    my $id;
    my $softwareLparId;
    my $recordTime;
    my $remoteUser;
    my $type;
    my $deleted;
    my $comments;
    $sth->bind_columns(
        \$id
        ,\$softwareLparId
        ,\$recordTime
        ,\$remoteUser
        ,\$type
        ,\$deleted
        ,\$comments
    );
    $sth->execute(
        $self->customerId
        ,$self->hostname
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->softwareLparId($softwareLparId);
    $self->recordTime($recordTime);
    $self->remoteUser($remoteUser);
    $self->type($type);
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
            ,type
            ,deleted
            ,comments
        from
            swasset_queue
        where
            customer_id = ?
            and hostname = ?
    ';
    return ('getByBizKeySwassetQueue', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeySwassetQueue};
    my $customerId;
    my $softwareLparId;
    my $hostname;
    my $recordTime;
    my $remoteUser;
    my $type;
    my $deleted;
    my $comments;
    $sth->bind_columns(
        \$customerId
        ,\$softwareLparId
        ,\$hostname
        ,\$recordTime
        ,\$remoteUser
        ,\$type
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
    $self->recordTime($recordTime);
    $self->remoteUser($remoteUser);
    $self->type($type);
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
            ,record_time
            ,remote_user
            ,type
            ,deleted
            ,comments
        from
            swasset_queue
        where
            id = ?
    ';
    return ('getByIdKeySwassetQueue', $query);
}

1;
