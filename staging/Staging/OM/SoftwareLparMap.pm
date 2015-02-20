package Staging::OM::SoftwareLparMap;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLpar => undef
        ,_scanRecord => undef
        ,_action => undef
        ,_table => 'software_lpar_map'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->softwareLpar && defined $object->softwareLpar) {
        $equal = 1 if $self->softwareLpar->equals($object->softwareLpar);
    }
    $equal = 1 if (!defined $self->softwareLpar && !defined $object->softwareLpar);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scanRecord && defined $object->scanRecord) {
        $equal = 1 if $self->scanRecord->equals($object->scanRecord);
    }
    $equal = 1 if (!defined $self->scanRecord && !defined $object->scanRecord);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub softwareLpar {
    my $self = shift;
    $self->{_softwareLpar} = shift if scalar @_ == 1;
    return $self->{_softwareLpar};
}

sub scanRecord {
    my $self = shift;
    $self->{_scanRecord} = shift if scalar @_ == 1;
    return $self->{_scanRecord};
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
    my $s = "[SoftwareLparMap] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "softwareLpar->id=";
    if (defined $self->{_softwareLpar}) {
        if (defined $self->{_softwareLpar}->id) {
            $s .= $self->{_softwareLpar}->id;
        }
    }
    $s .= ",";
    $s .= "scanRecord->id=";
    if (defined $self->{_scanRecord}) {
        if (defined $self->{_scanRecord}->id) {
            $s .= $self->{_scanRecord}->id;
        }
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
        my $sth = $connection->sql->{insertSoftwareLparMap};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLpar->id
            ,$self->scanRecord->id
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSoftwareLparMap};
        $sth->execute(
            $self->softwareLpar->id
            ,$self->scanRecord->id
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
        insert into software_lpar_map (
            software_lpar_id
            ,scan_record_id
            ,action
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertSoftwareLparMap', $query);
}

sub queryUpdate {
    my $query = '
        update software_lpar_map
        set
            software_lpar_id = ?
            ,scan_record_id = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateSoftwareLparMap', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSoftwareLparMap};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_lpar_map
        where
            id = ?
    ';
    return ('deleteSoftwareLparMap', $query);
}

1;
