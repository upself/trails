package Sigbank::OM::SystemScheduleStatus;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_name => undef
        ,_comments => undef
        ,_startTime => undef
        ,_endTime => undef
        ,_remoteUser => 'STAGING'
        ,_status => undef
        ,_table => 'system_schedule_status'
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
    if (defined $self->comments && defined $object->comments) {
        $equal = 1 if $self->comments eq $object->comments;
    }
    $equal = 1 if (!defined $self->comments && !defined $object->comments);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->startTime && defined $object->startTime) {
        $equal = 1 if $self->startTime eq $object->startTime;
    }
    $equal = 1 if (!defined $self->startTime && !defined $object->startTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->endTime && defined $object->endTime) {
        $equal = 1 if $self->endTime eq $object->endTime;
    }
    $equal = 1 if (!defined $self->endTime && !defined $object->endTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->remoteUser && defined $object->remoteUser) {
        $equal = 1 if $self->remoteUser eq $object->remoteUser;
    }
    $equal = 1 if (!defined $self->remoteUser && !defined $object->remoteUser);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
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

sub comments {
    my $self = shift;
    $self->{_comments} = shift if scalar @_ == 1;
    return $self->{_comments};
}

sub startTime {
    my $self = shift;
    $self->{_startTime} = shift if scalar @_ == 1;
    return $self->{_startTime};
}

sub endTime {
    my $self = shift;
    $self->{_endTime} = shift if scalar @_ == 1;
    return $self->{_endTime};
}

sub remoteUser {
    my $self = shift;
    $self->{_remoteUser} = shift if scalar @_ == 1;
    return $self->{_remoteUser};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
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
    my $s = "[SystemScheduleStatus] ";
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
    $s .= "comments=";
    if (defined $self->{_comments}) {
        $s .= $self->{_comments};
    }
    $s .= ",";
    $s .= "startTime=";
    if (defined $self->{_startTime}) {
        $s .= $self->{_startTime};
    }
    $s .= ",";
    $s .= "endTime=";
    if (defined $self->{_endTime}) {
        $s .= $self->{_endTime};
    }
    $s .= ",";
    $s .= "remoteUser=";
    if (defined $self->{_remoteUser}) {
        $s .= $self->{_remoteUser};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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
        my $sth = $connection->sql->{insertSystemScheduleStatus};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->name
            ,$self->comments
            ,$self->startTime
            ,$self->endTime
            ,$self->status
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSystemScheduleStatus};
        $sth->execute(
            $self->name
            ,$self->comments
            ,$self->startTime
            ,$self->endTime
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
        insert into system_schedule_status (
            name
            ,comments
            ,start_time
            ,end_time
            ,remote_user
            ,status
        ) values (
            ?
            ,?
            ,?
            ,?
            ,\'STAGING\'
            ,?
        ))
    ';
    return ('insertSystemScheduleStatus', $query);
}

sub queryUpdate {
    my $query = '
        update system_schedule_status
        set
            name = ?
            ,comments = ?
            ,start_time = ?
            ,end_time = ?
            ,remote_user = \'STAGING\'
            ,status = ?
        where
            id = ?
    ';
    return ('updateSystemScheduleStatus', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSystemScheduleStatus};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from system_schedule_status
        where
            id = ?
    ';
    return ('deleteSystemScheduleStatus', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeySystemScheduleStatus};
    my $id;
    my $comments;
    my $startTime;
    my $endTime;
    my $remoteUser;
    my $status;
    $sth->bind_columns(
        \$id
        ,\$comments
        ,\$startTime
        ,\$endTime
        ,\$remoteUser
        ,\$status
    );
    $sth->execute(
        $self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->comments($comments);
    $self->startTime($startTime);
    $self->endTime($endTime);
    $self->remoteUser($remoteUser);
    $self->status($status);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,comments
            ,start_time
            ,end_time
            ,remote_user
            ,status
        from
            system_schedule_status
        where
            name = ?
    ';
    return ('getByBizKeySystemScheduleStatus', $query);
}

1;
