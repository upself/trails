package BRAVO::OM::DiscrepancyType;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_name => undef
        ,_remoteUser => undef
        ,_recordTime => undef
        ,_status => undef
        ,_table => 'discrepancy_type'
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
    if (defined $self->remoteUser && defined $object->remoteUser) {
        $equal = 1 if $self->remoteUser eq $object->remoteUser;
    }
    $equal = 1 if (!defined $self->remoteUser && !defined $object->remoteUser);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->recordTime && defined $object->recordTime) {
        $equal = 1 if $self->recordTime eq $object->recordTime;
    }
    $equal = 1 if (!defined $self->recordTime && !defined $object->recordTime);
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
    my $s = "[DiscrepancyType] ";
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


sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyDiscrepancyType};
    my $id;
    my $remoteUser;
    my $recordTime;
    my $status;
    $sth->bind_columns(
        \$id
        ,\$remoteUser
        ,\$recordTime
        ,\$status
    );
    $sth->execute(
        $self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->status($status);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,remote_user
            ,record_time
            ,status
        from
            discrepancy_type
        where
            name = ?
     with ur';
    return ('getByBizKeyDiscrepancyType', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyDiscrepancyType};
    my $name;
    my $remoteUser;
    my $recordTime;
    my $status;
    $sth->bind_columns(
        \$name
        ,\$remoteUser
        ,\$recordTime
        ,\$status
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->name($name);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->status($status);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            name
            ,remote_user
            ,record_time
            ,status
        from
            discrepancy_type
        where
            id = ?
     with ur';
    return ('getByIdKeyDiscrepancyType', $query);
}

1;
