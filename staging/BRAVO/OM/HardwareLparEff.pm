package BRAVO::OM::HardwareLparEff;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_hardwareLparId => undef
        ,_processorCount => undef
        ,_status => undef
        ,_action => undef
        ,_table => 'hardware_lpar_eff'
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
    if (defined $self->hardwareLparId && defined $object->hardwareLparId) {
        $equal = 1 if $self->hardwareLparId eq $object->hardwareLparId;
    }
    $equal = 1 if (!defined $self->hardwareLparId && !defined $object->hardwareLparId);
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
    $s .= "hardwareLparId=";
    if (defined $self->{_hardwareLparId}) {
        $s .= $self->{_hardwareLparId};
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
            $self->hardwareLparId
            ,$self->processorCount
            ,$self->status
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHardwareLparEff};
        $sth->execute(
            $self->hardwareLparId
            ,$self->processorCount
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
        insert into hardware_lpar_eff (
            hardware_lpar_id
            ,processor_count
            ,status
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertHardwareLparEff', $query);
}

sub queryUpdate {
    my $query = '
        update hardware_lpar_eff
        set
            hardware_lpar_id = ?
            ,processor_count = ?
            ,status = ?
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
        delete from hardware_lpar_eff
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
    $sth->bind_columns(
        \$id
        ,\$processorCount
        ,\$status
    );
    $sth->execute(
        $self->hardwareLparId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->processorCount($processorCount);
    $self->status($status);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,processor_count
            ,status
        from
            hardware_lpar_eff
        where
            hardware_lpar_id = ?
     with ur';
    return ('getByBizKeyHardwareLparEff', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHardwareLparEff};
    my $hardwareLparId;
    my $processorCount;
    my $status;
    $sth->bind_columns(
        \$hardwareLparId
        ,\$processorCount
        ,\$status
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->hardwareLparId($hardwareLparId);
    $self->processorCount($processorCount);
    $self->status($status);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            hardware_lpar_id
            ,processor_count
            ,status
        from
            hardware_lpar_eff
        where
            id = ?
     with ur';
    return ('getByIdKeyHardwareLparEff', $query);
}

1;
