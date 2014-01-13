package BRAVO::OM::HardwareSoftwareComposite;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_hardwareLparId => undef
        ,_softwareLparId => undef
        ,_matchMethod => undef
        ,_status => undef
        ,_action => undef
        ,_remoteUser => undef
        ,_recordTime => undef
        ,_table => 'hw_sw_composite'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->hardwareLparId && defined $object->hardwareLparId) {
        $equal = 1 if $self->hardwareLparId eq $object->hardwareLparId;
    }
    $equal = 1 if (!defined $self->hardwareLparId && !defined $object->hardwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareLparId && defined $object->softwareLparId) {
        $equal = 1 if $self->softwareLparId eq $object->softwareLparId;
    }
    $equal = 1 if (!defined $self->softwareLparId && !defined $object->softwareLparId);
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

sub hardwareLparId {
    my $self = shift;
    $self->{_hardwareLparId} = shift if scalar @_ == 1;
    return $self->{_hardwareLparId};
}

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
}

sub matchMethod {
    my $self = shift;
    $self->{_matchMethod} = shift if scalar @_ == 1;
    return $self->{_matchMethod};
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
    my $s = "[HardwareSoftwareComposite] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "hardwareLparId=";
    if (defined $self->{_hardwareLparId}) {
        $s .= $self->{_hardwareLparId};
    }
    $s .= ",";
    $s .= "softwareLparId=";
    if (defined $self->{_softwareLparId}) {
        $s .= $self->{_softwareLparId};
    }
    $s .= ",";
    $s .= "matchMethod=";
    if (defined $self->{_matchMethod}) {
        $s .= $self->{_matchMethod};
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
        my $sth = $connection->sql->{insertHardwareSoftwareComposite};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->hardwareLparId
            ,$self->softwareLparId
            ,$self->matchMethod
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHardwareSoftwareComposite};
        $sth->execute(
            $self->hardwareLparId
            ,$self->softwareLparId
            ,$self->matchMethod
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
        insert into hw_sw_composite (
            hardware_lpar_id
            ,software_lpar_id
            ,match_method
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertHardwareSoftwareComposite', $query);
}

sub queryUpdate {
    my $query = '
        update hw_sw_composite
        set
            hardware_lpar_id = ?
            ,software_lpar_id = ?
            ,match_method = ?
        where
            id = ?
    ';
    return ('updateHardwareSoftwareComposite', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteHardwareSoftwareComposite};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from hw_sw_composite a where
            a.id = ?
    ';
    return ('deleteHardwareSoftwareComposite', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyHardwareSoftwareComposite};
    my $id;
    my $matchMethod;
    $sth->bind_columns(
        \$id
        ,\$matchMethod
    );
    $sth->execute(
        $self->hardwareLparId
        ,$self->softwareLparId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->matchMethod($matchMethod);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,match_method
        from
            hw_sw_composite
        where
            hardware_lpar_id = ?
            and software_lpar_id = ?
    ';
    return ('getByBizKeyHardwareSoftwareComposite', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHardwareSoftwareComposite};
    my $hardwareLparId;
    my $softwareLparId;
    my $matchMethod;
    $sth->bind_columns(
        \$hardwareLparId
        ,\$softwareLparId
        ,\$matchMethod
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->hardwareLparId($hardwareLparId);
    $self->softwareLparId($softwareLparId);
    $self->matchMethod($matchMethod);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            hardware_lpar_id
            ,software_lpar_id
            ,match_method
        from
            hw_sw_composite
        where
            id = ?
    ';
    return ('getByIdKeyHardwareSoftwareComposite', $query);
}

1;
