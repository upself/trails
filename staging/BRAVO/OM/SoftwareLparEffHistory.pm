package BRAVO::OM::SoftwareLparEffHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_effProcId => undef
        ,_processorCount => undef
        ,_status => undef
        ,_action => undef
        ,_remoteUser => 'ATP'
        ,_recordTime => undef
        ,_table => 'software_lpar_eff_h'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->id && defined $object->id) {
        $equal = 1 if $self->id eq $object->id;
    }
    $equal = 1 if (!defined $self->id && !defined $object->id);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->effProcId && defined $object->effProcId) {
        $equal = 1 if $self->effProcId eq $object->effProcId;
    }
    $equal = 1 if (!defined $self->effProcId && !defined $object->effProcId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->action && defined $object->action) {
        $equal = 1 if $self->action eq $object->action;
    }
    $equal = 1 if (!defined $self->action && !defined $object->action);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub effProcId {
    my $self = shift;
    $self->{_effProcId} = shift if scalar @_ == 1;
    return $self->{_effProcId};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
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
    my $s = "[SoftwareLparEffHistory] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "effProcId=";
    if (defined $self->{_effProcId}) {
        $s .= $self->{_effProcId};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
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
        my $sth = $connection->sql->{insertSoftwareLparEffHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->effProcId
            ,$self->processorCount
            ,$self->status
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSoftwareLparEffHistory};
        $sth->execute(
            $self->effProcId
            ,$self->processorCount
            ,$self->status
            ,$self->action
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
        insert into software_lpar_eff_h (
            software_lpar_eff_id
            ,processor_count
            ,status
            ,action
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,\'ATP\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertSoftwareLparEffHistory', $query);
}

sub queryUpdate {
    my $query = '
        update software_lpar_eff_h
        set
            software_lpar_eff_id = ?
            ,processor_count = ?
            ,status = ?
            ,action = ?
            ,remote_user = \'ATP\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateSoftwareLparEffHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSoftwareLparEffHistory};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_lpar_eff_h
        where
            id = ?
    ';
    return ('deleteSoftwareLparEffHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeySoftwareLparEffHistory};
    my $effProcId;
    my $processorCount;
    my $status;
    my $action;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$effProcId
        ,\$processorCount
        ,\$status
        ,\$action
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->effProcId($effProcId);
    $self->processorCount($processorCount);
    $self->status($status);
    $self->action($action);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_eff_id
            ,processor_count
            ,status
            ,action
            ,remote_user
            ,record_time
        from
            software_lpar_eff_h
        where
            id = ?
     with ur';
    return ('getByIdKeySoftwareLparEffHistory', $query);
}

1;
