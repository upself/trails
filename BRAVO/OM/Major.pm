package BRAVO::OM::Major;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
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
    my $s = "[Major] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
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
        my $sth = $connection->sql->{insertMajor};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->majorId
            ,$self->name
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateMajor};
        $sth->execute(
            $self->majorId
            ,$self->name
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            major_id
        from
            final table (
        insert into major (
            major_id
            ,major_name
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertMajor', $query);
}

sub queryUpdate {
    my $query = '
        update major
        set
            major_id = ?
            ,major_name = ?
        where
            major_id = ?
    ';
    return ('updateMajor', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteMajor};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from major a where
            a.major_id = ?
    ';
    return ('deleteMajor', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyMajor};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->majorId
        ,$self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            major_id
        from
            major
        where
            major_id = ?
            and major_name = ?
    ';
    return ('getByBizKeyMajor', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyMajor};
    my $majorId;
    my $name;
    $sth->bind_columns(
        \$majorId
        ,\$name
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->majorId($majorId);
    $self->name($name);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            major_id
            ,major_name
        from
            major
        where
            major_id = ?
    ';
    return ('getByIdKeyMajor', $query);
}

1;
