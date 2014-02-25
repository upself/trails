package BRAVO::OM::Hdisk;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_model => undef
        ,_hdiskSizeMb => undef
        ,_manufacturer => undef
        ,_serialNumber => undef
        ,_storageType => undef
        ,_table => 'software_lpar_hdisk'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->softwareLparId && defined $object->softwareLparId) {
        $equal = 1 if $self->softwareLparId eq $object->softwareLparId;
    }
    $equal = 1 if (!defined $self->softwareLparId && !defined $object->softwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->model && defined $object->model) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if (!defined $self->model && !defined $object->model);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hdiskSizeMb && defined $object->hdiskSizeMb) {
        $equal = 1 if $self->hdiskSizeMb eq $object->hdiskSizeMb;
    }
    $equal = 1 if (!defined $self->hdiskSizeMb && !defined $object->hdiskSizeMb);
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

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
}

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub hdiskSizeMb {
    my $self = shift;
    $self->{_hdiskSizeMb} = shift if scalar @_ == 1;
    return $self->{_hdiskSizeMb};
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
    $s .= "softwareLparId=";
    if (defined $self->{_softwareLparId}) {
        $s .= $self->{_softwareLparId};
    }
    $s .= ",";
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "hdiskSizeMb=";
    if (defined $self->{_hdiskSizeMb}) {
        $s .= $self->{_hdiskSizeMb};
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
            $self->softwareLparId
            ,$self->model
            ,$self->hdiskSizeMb
            ,$self->manufacturer
            ,$self->serialNumber
            ,$self->storageType
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateHdisk};
        $sth->execute(
            $self->softwareLparId
            ,$self->model
            ,$self->hdiskSizeMb
            ,$self->manufacturer
            ,$self->serialNumber
            ,$self->storageType
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
        insert into software_lpar_hdisk (
            software_lpar_id
            ,model
            ,hdisk_size_mb
            ,manufacturer
            ,serial_number
            ,storage_type
        ) values (
            ?
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
        update software_lpar_hdisk
        set
            software_lpar_id = ?
            ,model = ?
            ,hdisk_size_mb = ?
            ,manufacturer = ?
            ,serial_number = ?
            ,storage_type = ?
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
        delete from software_lpar_hdisk
        where
            id = ?
    ';
    return ('deleteHdisk', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyHdisk};
    my $id;
    my $manufacturer;
    my $storageType;
    $sth->bind_columns(
        \$id
        ,\$manufacturer
        ,\$storageType
    );
    $sth->execute(
        $self->softwareLparId
        ,$self->model
        ,$self->hdiskSizeMb
        ,$self->serialNumber
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->manufacturer($manufacturer);
    $self->storageType($storageType);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,manufacturer
            ,storage_type
        from
            software_lpar_hdisk
        where
            software_lpar_id = ?
            and model = ?
            and hdisk_size_mb = ?
            and serial_number = ?
    ';
    return ('getByBizKeyHdisk', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyHdisk};
    my $softwareLparId;
    my $model;
    my $hdiskSizeMb;
    my $manufacturer;
    my $serialNumber;
    my $storageType;
    $sth->bind_columns(
        \$softwareLparId
        ,\$model
        ,\$hdiskSizeMb
        ,\$manufacturer
        ,\$serialNumber
        ,\$storageType
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareLparId($softwareLparId);
    $self->model($model);
    $self->hdiskSizeMb($hdiskSizeMb);
    $self->manufacturer($manufacturer);
    $self->serialNumber($serialNumber);
    $self->storageType($storageType);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,model
            ,hdisk_size_mb
            ,manufacturer
            ,serial_number
            ,storage_type
        from
            software_lpar_hdisk
        where
            id = ?
    ';
    return ('getByIdKeyHdisk', $query);
}

1;
