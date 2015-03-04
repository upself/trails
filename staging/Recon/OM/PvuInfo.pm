package Recon::OM::PvuInfo;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_pvuId => undef
        ,_processorType => undef
        ,_valueUnitsPerCore => undef
        ,_processorArchitectures => undef
        ,_serverVendor => undef
        ,_serverBrand => undef
        ,_processorVendor => undef
        ,_startDate => undef
        ,_endDate => undef
        ,_status => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->pvuId && defined $object->pvuId) {
        $equal = 1 if $self->pvuId eq $object->pvuId;
    }
    $equal = 1 if (!defined $self->pvuId && !defined $object->pvuId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorType && defined $object->processorType) {
        $equal = 1 if $self->processorType eq $object->processorType;
    }
    $equal = 1 if (!defined $self->processorType && !defined $object->processorType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->valueUnitsPerCore && defined $object->valueUnitsPerCore) {
        $equal = 1 if $self->valueUnitsPerCore eq $object->valueUnitsPerCore;
    }
    $equal = 1 if (!defined $self->valueUnitsPerCore && !defined $object->valueUnitsPerCore);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorArchitectures && defined $object->processorArchitectures) {
        $equal = 1 if $self->processorArchitectures eq $object->processorArchitectures;
    }
    $equal = 1 if (!defined $self->processorArchitectures && !defined $object->processorArchitectures);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverVendor && defined $object->serverVendor) {
        $equal = 1 if $self->serverVendor eq $object->serverVendor;
    }
    $equal = 1 if (!defined $self->serverVendor && !defined $object->serverVendor);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverBrand && defined $object->serverBrand) {
        $equal = 1 if $self->serverBrand eq $object->serverBrand;
    }
    $equal = 1 if (!defined $self->serverBrand && !defined $object->serverBrand);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorVendor && defined $object->processorVendor) {
        $equal = 1 if $self->processorVendor eq $object->processorVendor;
    }
    $equal = 1 if (!defined $self->processorVendor && !defined $object->processorVendor);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->startDate && defined $object->startDate) {
        $equal = 1 if $self->startDate eq $object->startDate;
    }
    $equal = 1 if (!defined $self->startDate && !defined $object->startDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->endDate && defined $object->endDate) {
        $equal = 1 if $self->endDate eq $object->endDate;
    }
    $equal = 1 if (!defined $self->endDate && !defined $object->endDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status->equals($object->status);
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

sub pvuId {
    my $self = shift;
    $self->{_pvuId} = shift if scalar @_ == 1;
    return $self->{_pvuId};
}

sub processorType {
    my $self = shift;
    $self->{_processorType} = shift if scalar @_ == 1;
    return $self->{_processorType};
}

sub valueUnitsPerCore {
    my $self = shift;
    $self->{_valueUnitsPerCore} = shift if scalar @_ == 1;
    return $self->{_valueUnitsPerCore};
}

sub processorArchitectures {
    my $self = shift;
    $self->{_processorArchitectures} = shift if scalar @_ == 1;
    return $self->{_processorArchitectures};
}

sub serverVendor {
    my $self = shift;
    $self->{_serverVendor} = shift if scalar @_ == 1;
    return $self->{_serverVendor};
}

sub serverBrand {
    my $self = shift;
    $self->{_serverBrand} = shift if scalar @_ == 1;
    return $self->{_serverBrand};
}

sub processorVendor {
    my $self = shift;
    $self->{_processorVendor} = shift if scalar @_ == 1;
    return $self->{_processorVendor};
}

sub startDate {
    my $self = shift;
    $self->{_startDate} = shift if scalar @_ == 1;
    return $self->{_startDate};
}

sub endDate {
    my $self = shift;
    $self->{_endDate} = shift if scalar @_ == 1;
    return $self->{_endDate};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub toString {
    my ($self) = @_;
    my $s = "[PvuInfo] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "pvuId=";
    if (defined $self->{_pvuId}) {
        $s .= $self->{_pvuId};
    }
    $s .= ",";
    $s .= "processorType=";
    if (defined $self->{_processorType}) {
        $s .= $self->{_processorType};
    }
    $s .= ",";
    $s .= "valueUnitsPerCore=";
    if (defined $self->{_valueUnitsPerCore}) {
        $s .= $self->{_valueUnitsPerCore};
    }
    $s .= ",";
    $s .= "processorArchitectures=";
    if (defined $self->{_processorArchitectures}) {
        $s .= $self->{_processorArchitectures};
    }
    $s .= ",";
    $s .= "serverVendor=";
    if (defined $self->{_serverVendor}) {
        $s .= $self->{_serverVendor};
    }
    $s .= ",";
    $s .= "serverBrand=";
    if (defined $self->{_serverBrand}) {
        $s .= $self->{_serverBrand};
    }
    $s .= ",";
    $s .= "processorVendor=";
    if (defined $self->{_processorVendor}) {
        $s .= $self->{_processorVendor};
    }
    $s .= ",";
    $s .= "startDate=";
    if (defined $self->{_startDate}) {
        $s .= $self->{_startDate};
    }
    $s .= ",";
    $s .= "endDate=";
    if (defined $self->{_endDate}) {
        $s .= $self->{_endDate};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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
        my $sth = $connection->sql->{insertPvuInfo};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->pvuId
            ,$self->processorType
            ,$self->valueUnitsPerCore
            ,$self->processorArchitectures
            ,$self->serverVendor
            ,$self->serverBrand
            ,$self->processorVendor
            ,$self->startDate
            ,$self->endDate
            ,$self->status
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updatePvuInfo};
        $sth->execute(
            $self->pvuId
            ,$self->processorType
            ,$self->valueUnitsPerCore
            ,$self->processorArchitectures
            ,$self->serverVendor
            ,$self->serverBrand
            ,$self->processorVendor
            ,$self->startDate
            ,$self->endDate
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
        insert into pvu_info (
            pvu_id
            ,processor_type
            ,value_units_per_core
            ,processor_architectures
            ,server_vendor
            ,server_brand
            ,processor_vendor
            ,start_date
            ,end_date
            ,status
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertPvuInfo', $query);
}

sub queryUpdate {
    my $query = '
        update pvu_info
        set
            pvu_id = ?
            ,processor_type = ?
            ,value_units_per_core = ?
            ,processor_architectures = ?
            ,server_vendor = ?
            ,server_brand = ?
            ,processor_vendor = ?
            ,start_date = ?
            ,end_date = ?
            ,status = ?
        where
            id = ?
    ';
    return ('updatePvuInfo', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deletePvuInfo};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from pvu_info
        where
            id = ?
    ';
    return ('deletePvuInfo', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyPvuInfo};
    my $id;
    my $valueUnitsPerCore;
    my $processorArchitectures;
    my $serverVendor;
    my $serverBrand;
    my $processorVendor;
    my $startDate;
    my $endDate;
    my $status;
    $sth->bind_columns(
        \$id
        ,\$valueUnitsPerCore
        ,\$processorArchitectures
        ,\$serverVendor
        ,\$serverBrand
        ,\$processorVendor
        ,\$startDate
        ,\$endDate
        ,\$status
    );
    $sth->execute(
        $self->pvuId
        ,$self->processorType
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->valueUnitsPerCore($valueUnitsPerCore);
    $self->processorArchitectures($processorArchitectures);
    $self->serverVendor($serverVendor);
    $self->serverBrand($serverBrand);
    $self->processorVendor($processorVendor);
    $self->startDate($startDate);
    $self->endDate($endDate);
    $self->status($status);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,value_units_per_core
            ,processor_architectures
            ,server_vendor
            ,server_brand
            ,processor_vendor
            ,start_date
            ,end_date
            ,status
        from
            pvu_info
        where
            pvu_id = ?
            and processor_type = ?
     with ur';
    return ('getByBizKeyPvuInfo', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyPvuInfo};
    my $pvuId;
    my $processorType;
    my $valueUnitsPerCore;
    my $processorArchitectures;
    my $serverVendor;
    my $serverBrand;
    my $processorVendor;
    my $startDate;
    my $endDate;
    my $status;
    $sth->bind_columns(
        \$pvuId
        ,\$processorType
        ,\$valueUnitsPerCore
        ,\$processorArchitectures
        ,\$serverVendor
        ,\$serverBrand
        ,\$processorVendor
        ,\$startDate
        ,\$endDate
        ,\$status
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->pvuId($pvuId);
    $self->processorType($processorType);
    $self->valueUnitsPerCore($valueUnitsPerCore);
    $self->processorArchitectures($processorArchitectures);
    $self->serverVendor($serverVendor);
    $self->serverBrand($serverBrand);
    $self->processorVendor($processorVendor);
    $self->startDate($startDate);
    $self->endDate($endDate);
    $self->status($status);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            pvu_id
            ,processor_type
            ,value_units_per_core
            ,processor_architectures
            ,server_vendor
            ,server_brand
            ,processor_vendor
            ,start_date
            ,end_date
            ,status
        from
            pvu_info
        where
            id = ?
     with ur';
    return ('getByIdKeyPvuInfo', $query);
}

1;
