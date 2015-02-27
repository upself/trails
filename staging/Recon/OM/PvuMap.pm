package Recon::OM::PvuMap;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_processorBrand => undef
        ,_processorModel => undef
        ,_pvuId => undef
        ,_machineTypeId => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->processorBrand && defined $object->processorBrand) {
        $equal = 1 if $self->processorBrand eq $object->processorBrand;
    }
    $equal = 1 if (!defined $self->processorBrand && !defined $object->processorBrand);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorModel && defined $object->processorModel) {
        $equal = 1 if $self->processorModel eq $object->processorModel;
    }
    $equal = 1 if (!defined $self->processorModel && !defined $object->processorModel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->pvuId && defined $object->pvuId) {
        $equal = 1 if $self->pvuId eq $object->pvuId;
    }
    $equal = 1 if (!defined $self->pvuId && !defined $object->pvuId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->machineTypeId && defined $object->machineTypeId) {
        $equal = 1 if $self->machineTypeId eq $object->machineTypeId;
    }
    $equal = 1 if (!defined $self->machineTypeId && !defined $object->machineTypeId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub processorBrand {
    my $self = shift;
    $self->{_processorBrand} = shift if scalar @_ == 1;
    return $self->{_processorBrand};
}

sub processorModel {
    my $self = shift;
    $self->{_processorModel} = shift if scalar @_ == 1;
    return $self->{_processorModel};
}

sub pvuId {
    my $self = shift;
    $self->{_pvuId} = shift if scalar @_ == 1;
    return $self->{_pvuId};
}

sub machineTypeId {
    my $self = shift;
    $self->{_machineTypeId} = shift if scalar @_ == 1;
    return $self->{_machineTypeId};
}

sub toString {
    my ($self) = @_;
    my $s = "[PvuMap] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "processorBrand=";
    if (defined $self->{_processorBrand}) {
        $s .= $self->{_processorBrand};
    }
    $s .= ",";
    $s .= "processorModel=";
    if (defined $self->{_processorModel}) {
        $s .= $self->{_processorModel};
    }
    $s .= ",";
    $s .= "pvuId=";
    if (defined $self->{_pvuId}) {
        $s .= $self->{_pvuId};
    }
    $s .= ",";
    $s .= "machineTypeId=";
    if (defined $self->{_machineTypeId}) {
        $s .= $self->{_machineTypeId};
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
        my $sth = $connection->sql->{insertPvuMap};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->processorBrand
            ,$self->processorModel
            ,$self->pvuId
            ,$self->machineTypeId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updatePvuMap};
        $sth->execute(
            $self->processorBrand
            ,$self->processorModel
            ,$self->pvuId
            ,$self->machineTypeId
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
        insert into pvu_map (
            processor_brand
            ,processor_model
            ,pvu_id
            ,machine_type_id
        ) values (
            ?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertPvuMap', $query);
}

sub queryUpdate {
    my $query = '
        update pvu_map
        set
            processor_brand = ?
            ,processor_model = ?
            ,pvu_id = ?
            ,machine_type_id = ?
        where
            id = ?
    ';
    return ('updatePvuMap', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deletePvuMap};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from pvu_map
        where
            id = ?
    ';
    return ('deletePvuMap', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyPvuMap};
    my $id;
    my $pvuId;
    $sth->bind_columns(
        \$id
        ,\$pvuId
    );
    $sth->execute(
        $self->processorBrand
        ,$self->processorModel
        ,$self->machineTypeId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->pvuId($pvuId);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,pvu_id
        from
            pvu_map
        where
            processor_brand = ?
            and processor_model = ?
            and machine_type_id = ?
     with ur';
    return ('getByBizKeyPvuMap', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyPvuMap};
    my $processorBrand;
    my $processorModel;
    my $pvuId;
    my $machineTypeId;
    $sth->bind_columns(
        \$processorBrand
        ,\$processorModel
        ,\$pvuId
        ,\$machineTypeId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->processorBrand($processorBrand);
    $self->processorModel($processorModel);
    $self->pvuId($pvuId);
    $self->machineTypeId($machineTypeId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            processor_brand
            ,processor_model
            ,pvu_id
            ,machine_type_id
        from
            pvu_map
        where
            id = ?
     with ur';
    return ('getByIdKeyPvuMap', $query);
}

1;
