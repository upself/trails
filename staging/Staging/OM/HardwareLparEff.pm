package Staging::OM::HardwareLparEff;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_processorCount => undef
        ,_hardwareLparId => undef
        ,_status => undef
        ,_action => undef
        ,_lparKey => undef
        ,_table => 'effective_processor'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

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
    if (defined $self->lparKey && defined $object->lparKey) {
        $equal = 1 if $self->lparKey eq $object->lparKey;
    }
    $equal = 1 if (!defined $self->lparKey && !defined $object->lparKey);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
}

sub hardwareLparId {
    my $self = shift;
    $self->{_hardwareLparId} = shift if scalar @_ == 1;
    return $self->{_hardwareLparId};
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

sub lparKey {
    my $self = shift;
    $self->{_lparKey} = shift if scalar @_ == 1;
    return $self->{_lparKey};
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
    my $s = "[HardwareLparEff] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
    }
    $s .= ",";
    $s .= "hardwareLparId=";
    if (defined $self->{_hardwareLparId}) {
        $s .= $self->{_hardwareLparId};
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
    $s .= "lparKey=";
    if (defined $self->{_lparKey}) {
        $s .= $self->{_lparKey};
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
        my $sth = $connection->sql->{insertHardwareLparEff};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->processorCount
            ,$self->hardwareLparId
            ,$self->status
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHardwareLparEff};
        $sth->execute(
            $self->processorCount
            ,$self->hardwareLparId
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
        insert into effective_processor (
            processor_count
            ,hardware_lpar_id
            ,status
            ,action
        ) values (
            ?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertHardwareLparEff', $query);
}

sub queryUpdate {
    my $query = '
        update effective_processor
        set
            processor_count = ?
            ,hardware_lpar_id = ?
            ,status = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateHardwareLparEff', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteHardwareLparEff};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from effective_processor
        where
            id = ?
    ';
    return ('deleteHardwareLparEff', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyHardwareLparEff};
    my $id;
    my $processorCount;
    my $status;
    my $action;
    $sth->bind_columns(
        \$id
        ,\$processorCount
        ,\$status
        ,\$action
    );
    $sth->execute(
        $self->hardwareLparId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->processorCount($processorCount);
    $self->status($status);
    $self->action($action);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,processor_count
            ,status
            ,action
        from
            effective_processor
        where
            hardware_lpar_id = ?
     with ur';
    return ('getByBizKeyHardwareLparEff', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHardwareLparEff};
    my $processorCount;
    my $hardwareLparId;
    my $status;
    my $action;
    $sth->bind_columns(
        \$processorCount
        ,\$hardwareLparId
        ,\$status
        ,\$action
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->processorCount($processorCount);
    $self->hardwareLparId($hardwareLparId);
    $self->status($status);
    $self->action($action);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            processor_count
            ,hardware_lpar_id
            ,status
            ,action
        from
            effective_processor
        where
            id = ?
     with ur';
    return ('getByIdKeyHardwareLparEff', $query);
}

1;
