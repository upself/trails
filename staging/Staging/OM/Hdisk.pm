package Staging::OM::Hdisk;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scanRecordId => undef
        ,_model => undef
        ,_size => undef
        ,_manufacturer => undef
        ,_serialNumber => undef
        ,_storageType => undef
        ,_action => undef
        ,_table => 'hdisk'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->scanRecordId && defined $object->scanRecordId) {
        $equal = 1 if $self->scanRecordId eq $object->scanRecordId;
    }
    $equal = 1 if (!defined $self->scanRecordId && !defined $object->scanRecordId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->model && defined $object->model) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if (!defined $self->model && !defined $object->model);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->size && defined $object->size) {
        $equal = 1 if $self->size eq $object->size;
    }
    $equal = 1 if (!defined $self->size && !defined $object->size);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->manufacturer && defined $object->manufacturer) {
        $equal = 1 if $self->manufacturer eq $object->manufacturer;
    }
    $equal = 1 if (!defined $self->manufacturer && !defined $object->manufacturer);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serialNumber && defined $object->serialNumber) {
        $equal = 1 if $self->serialNumber eq $object->serialNumber;
    }
    $equal = 1 if (!defined $self->serialNumber && !defined $object->serialNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->storageType && defined $object->storageType) {
        $equal = 1 if $self->storageType eq $object->storageType;
    }
    $equal = 1 if (!defined $self->storageType && !defined $object->storageType);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub scanRecordId {
    my $self = shift;
    $self->{_scanRecordId} = shift if scalar @_ == 1;
    return $self->{_scanRecordId};
}

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub size {
    my $self = shift;
    $self->{_size} = shift if scalar @_ == 1;
    return $self->{_size};
}

sub manufacturer {
    my $self = shift;
    $self->{_manufacturer} = shift if scalar @_ == 1;
    return $self->{_manufacturer};
}

sub serialNumber {
    my $self = shift;
    $self->{_serialNumber} = shift if scalar @_ == 1;
    return $self->{_serialNumber};
}

sub storageType {
    my $self = shift;
    $self->{_storageType} = shift if scalar @_ == 1;
    return $self->{_storageType};
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
    my $s = "[Hdisk] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "scanRecordId=";
    if (defined $self->{_scanRecordId}) {
        $s .= $self->{_scanRecordId};
    }
    $s .= ",";
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "size=";
    if (defined $self->{_size}) {
        $s .= $self->{_size};
    }
    $s .= ",";
    $s .= "manufacturer=";
    if (defined $self->{_manufacturer}) {
        $s .= $self->{_manufacturer};
    }
    $s .= ",";
    $s .= "serialNumber=";
    if (defined $self->{_serialNumber}) {
        $s .= $self->{_serialNumber};
    }
    $s .= ",";
    $s .= "storageType=";
    if (defined $self->{_storageType}) {
        $s .= $self->{_storageType};
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
        my $sth = $connection->sql->{insertHdisk};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scanRecordId
            ,$self->model
            ,$self->size
            ,$self->manufacturer
            ,$self->serialNumber
            ,$self->storageType
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHdisk};
        $sth->execute(
            $self->scanRecordId
            ,$self->model
            ,$self->size
            ,$self->manufacturer
            ,$self->serialNumber
            ,$self->storageType
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
        insert into hdisk (
            scan_record_id
            ,model
            ,size
            ,manufacturer
            ,serial_number
            ,storage_type
            ,action
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertHdisk', $query);
}

sub queryUpdate {
    my $query = '
        update hdisk
        set
            scan_record_id = ?
            ,model = ?
            ,size = ?
            ,manufacturer = ?
            ,serial_number = ?
            ,storage_type = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateHdisk', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteHdisk};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from hdisk
        where
            id = ?
    ';
    return ('deleteHdisk', $query);
}

1;
