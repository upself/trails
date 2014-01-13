package BRAVO::OM::Lpid;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_lpidId => undef
        ,_majorId => undef
        ,_name => undef
        ,_action => undef
        ,_table => 'customer_number'
        ,_idField => 'customer_number_id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->lpidId && defined $object->lpidId) {
        $equal = 1 if $self->lpidId eq $object->lpidId;
    }
    $equal = 1 if (!defined $self->lpidId && !defined $object->lpidId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->majorId && defined $object->majorId) {
        $equal = 1 if $self->majorId eq $object->majorId;
    }
    $equal = 1 if (!defined $self->majorId && !defined $object->majorId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub lpidId {
    my $self = shift;
    $self->{_lpidId} = shift if scalar @_ == 1;
    return $self->{_lpidId};
}

sub majorId {
    my $self = shift;
    $self->{_majorId} = shift if scalar @_ == 1;
    return $self->{_majorId};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
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
    my $s = "[Lpid] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "lpidId=";
    if (defined $self->{_lpidId}) {
        $s .= $self->{_lpidId};
    }
    $s .= ",";
    $s .= "majorId=";
    if (defined $self->{_majorId}) {
        $s .= $self->{_majorId};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
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
        my $sth = $connection->sql->{insertLpid};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->lpidId
            ,$self->majorId
            ,$self->name
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateLpid};
        $sth->execute(
            $self->lpidId
            ,$self->majorId
            ,$self->name
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            lpid_id
        from
            final table (
        insert into lpid (
            lpid_id
            ,major_id
            ,lpid_name
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertLpid', $query);
}

sub queryUpdate {
    my $query = '
        update lpid
        set
            lpid_id = ?
            ,major_id = ?
            ,lpid_name = ?
        where
            lpid_id = ?
    ';
    return ('updateLpid', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteLpid};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from lpid a where
            a.lpid_id = ?
    ';
    return ('deleteLpid', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyLpid};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->lpidId
        ,$self->majorId
        ,$self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            lpid_id
        from
            lpid
        where
            lpid_id = ?
            and major_id = ?
            and lpid_name = ?
    ';
    return ('getByBizKeyLpid', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyLpid};
    my $lpidId;
    my $majorId;
    my $name;
    $sth->bind_columns(
        \$lpidId
        ,\$majorId
        ,\$name
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->lpidId($lpidId);
    $self->majorId($majorId);
    $self->name($name);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            lpid_id
            ,major_id
            ,lpid_name
        from
            lpid
        where
            lpid_id = ?
    ';
    return ('getByIdKeyLpid', $query);
}

1;
