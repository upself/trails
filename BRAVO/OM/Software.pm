package BRAVO::OM::Software;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_name => undef
        ,_level => undef
        ,_vendorManaged => undef
        ,_status => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'software'
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
    if (defined $self->level && defined $object->level) {
        $equal = 1 if $self->level eq $object->level;
    }
    $equal = 1 if (!defined $self->level && !defined $object->level);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->vendorManaged && defined $object->vendorManaged) {
        $equal = 1 if $self->vendorManaged eq $object->vendorManaged;
    }
    $equal = 1 if (!defined $self->vendorManaged && !defined $object->vendorManaged);
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

sub level {
    my $self = shift;
    $self->{_level} = shift if scalar @_ == 1;
    return $self->{_level};
}

sub vendorManaged {
    my $self = shift;
    $self->{_vendorManaged} = shift if scalar @_ == 1;
    return $self->{_vendorManaged};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
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
    my $s = "[Software] ";
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
    $s .= "level=";
    if (defined $self->{_level}) {
        $s .= $self->{_level};
    }
    $s .= ",";
    $s .= "vendorManaged=";
    if (defined $self->{_vendorManaged}) {
        $s .= $self->{_vendorManaged};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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
        my $sth = $connection->sql->{insertSoftware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->name
            ,$self->level
            ,$self->vendorManaged
            ,$self->status
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSoftware};
        $sth->execute(
            $self->name
            ,$self->level
            ,$self->vendorManaged
            ,$self->status
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            software_id
        from
            final table (
        insert into software (
            software_name
            ,level
            ,vendor_managed
            ,status
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertSoftware', $query);
}

sub queryUpdate {
    my $query = '
        update software
        set
            software_name = ?
            ,level = ?
            ,vendor_managed = ?
            ,status = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            software_id = ?
    ';
    return ('updateSoftware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSoftware};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software a where
            a.software_id = ?
    ';
    return ('deleteSoftware', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeySoftware};
    my $id;
    my $level;
    my $vendorManaged;
    my $status;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$level
        ,\$vendorManaged
        ,\$status
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->level($level);
    $self->vendorManaged($vendorManaged);
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            software_id
            ,level
            ,vendor_managed
            ,status
            ,remote_user
            ,record_time
        from
            software
        where
            software_name = ?
    ';
    return ('getByBizKeySoftware', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeySoftware};
    my $name;
    my $level;
    my $vendorManaged;
    my $status;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$name
        ,\$level
        ,\$vendorManaged
        ,\$status
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->name($name);
    $self->level($level);
    $self->vendorManaged($vendorManaged);
    $self->status($status);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_name
            ,level
            ,vendor_managed
            ,status
            ,remote_user
            ,record_time
        from
            software
        where
            software_id = ?
    ';
    return ('getByIdKeySoftware', $query);
}

1;
