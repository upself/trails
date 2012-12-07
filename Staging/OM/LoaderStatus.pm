package Staging::OM::LoaderStatus;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_database => undef
        ,_objectType => undef
        ,_action => undef
        ,_recordTime => undef
        ,_count => undef
        ,_table => 'loader_status'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->database && defined $object->database) {
        $equal = 1 if $self->database eq $object->database;
    }
    $equal = 1 if (!defined $self->database && !defined $object->database);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->objectType && defined $object->objectType) {
        $equal = 1 if $self->objectType eq $object->objectType;
    }
    $equal = 1 if (!defined $self->objectType && !defined $object->objectType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->action && defined $object->action) {
        $equal = 1 if $self->action eq $object->action;
    }
    $equal = 1 if (!defined $self->action && !defined $object->action);
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

sub database {
    my $self = shift;
    $self->{_database} = shift if scalar @_ == 1;
    return $self->{_database};
}

sub objectType {
    my $self = shift;
    $self->{_objectType} = shift if scalar @_ == 1;
    return $self->{_objectType};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
}

sub count {
    my $self = shift;
    $self->{_count} = shift if scalar @_ == 1;
    return $self->{_count};
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
    my $s = "[LoaderStatus] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "database=";
    if (defined $self->{_database}) {
        $s .= $self->{_database};
    }
    $s .= ",";
    $s .= "objectType=";
    if (defined $self->{_objectType}) {
        $s .= $self->{_objectType};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
    }
    $s .= ",";
    $s .= "count=";
    if (defined $self->{_count}) {
        $s .= $self->{_count};
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
        my $sth = $connection->sql->{insertLoaderStatus};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->database
            ,$self->objectType
            ,$self->action
            ,$self->count
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateLoaderStatus};
        $sth->execute(
            $self->database
            ,$self->objectType
            ,$self->action
            ,$self->count
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
        insert into loader_status (
            database
            ,object_type
            ,action
            ,record_time
            ,count
        ) values (
            ?
            ,?
            ,?
            ,CURRENT TIMESTAMP
            ,?
        ))
    ';
    return ('insertLoaderStatus', $query);
}

sub queryUpdate {
    my $query = '
        update loader_status
        set
            database = ?
            ,object_type = ?
            ,action = ?
            ,record_time = CURRENT TIMESTAMP
            ,count = ?
        where
            id = ?
    ';
    return ('updateLoaderStatus', $query);
}

1;
