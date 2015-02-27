package BRAVO::OM::CapType;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_code => undef
        ,_description => undef
        ,_recordTime => undef
        ,_action => undef
        ,_table => 'capacity_type'
        ,_idField => 'code'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->description && defined $object->description) {
        $equal = 1 if $self->description eq $object->description;
    }
    $equal = 1 if (!defined $self->description && !defined $object->description);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->recordTime && defined $object->recordTime) {
        $equal = 1 if $self->recordTime eq $object->recordTime;
    }
    $equal = 1 if (!defined $self->recordTime && !defined $object->recordTime);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub code {
    my $self = shift;
    $self->{_code} = shift if scalar @_ == 1;
    return $self->{_code};
}

sub description {
    my $self = shift;
    $self->{_description} = shift if scalar @_ == 1;
    return $self->{_description};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
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
    my $s = "[CapType] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "code=";
    if (defined $self->{_code}) {
        $s .= $self->{_code};
    }
    $s .= ",";
    $s .= "description=";
    if (defined $self->{_description}) {
        $s .= $self->{_description};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
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
        my $sth = $connection->sql->{insertCapType};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->code
            ,$self->description
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateCapType};
        $sth->execute(
            $self->code
            ,$self->description
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            code
        from
            final table (
        insert into capacity_type (
            code
            ,description
            ,record_time
        ) values (
            ?
            ,?
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertCapType', $query);
}

sub queryUpdate {
    my $query = '
        update capacity_type
        set
            code = ?
            ,description = ?
            ,record_time = CURRENT TIMESTAMP
        where
            code = ?
    ';
    return ('updateCapType', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteCapType};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from capacity_type
        where
            code = ?
    ';
    return ('deleteCapType', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyCapType};
    my $id;
    my $description;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$description
        ,\$recordTime
    );
    $sth->execute(
        $self->code
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->description($description);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            code
            ,description
            ,record_time
        from
            capacity_type
        where
            code = ?
     with ur';
    return ('getByBizKeyCapType', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyCapType};
    my $code;
    my $description;
    my $recordTime;
    $sth->bind_columns(
        \$code
        ,\$description
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->code($code);
    $self->description($description);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            code
            ,description
            ,record_time
        from
            capacity_type
        where
            code = ?
     with ur';
    return ('getByIdKeyCapType', $query);
}

1;
