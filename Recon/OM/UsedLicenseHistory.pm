package Recon::OM::UsedLicenseHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_licenseId => undef
        ,_usedQuantity => undef
        ,_capacityTypeId => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->licenseId && defined $object->licenseId) {
        $equal = 1 if $self->licenseId eq $object->licenseId;
    }
    $equal = 1 if (!defined $self->licenseId && !defined $object->licenseId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->usedQuantity && defined $object->usedQuantity) {
        $equal = 1 if $self->usedQuantity eq $object->usedQuantity;
    }
    $equal = 1 if (!defined $self->usedQuantity && !defined $object->usedQuantity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->capacityTypeId && defined $object->capacityTypeId) {
        $equal = 1 if $self->capacityTypeId eq $object->capacityTypeId;
    }
    $equal = 1 if (!defined $self->capacityTypeId && !defined $object->capacityTypeId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub licenseId {
    my $self = shift;
    $self->{_licenseId} = shift if scalar @_ == 1;
    return $self->{_licenseId};
}

sub usedQuantity {
    my $self = shift;
    $self->{_usedQuantity} = shift if scalar @_ == 1;
    return $self->{_usedQuantity};
}

sub capacityTypeId {
    my $self = shift;
    $self->{_capacityTypeId} = shift if scalar @_ == 1;
    return $self->{_capacityTypeId};
}

sub toString {
    my ($self) = @_;
    my $s = "[UsedLicenseHistory] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "licenseId=";
    if (defined $self->{_licenseId}) {
        $s .= $self->{_licenseId};
    }
    $s .= ",";
    $s .= "usedQuantity=";
    if (defined $self->{_usedQuantity}) {
        $s .= $self->{_usedQuantity};
    }
    $s .= ",";
    $s .= "capacityTypeId=";
    if (defined $self->{_capacityTypeId}) {
        $s .= $self->{_capacityTypeId};
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
        my $sth = $connection->sql->{insertUsedLicenseHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->licenseId
            ,$self->usedQuantity
            ,$self->capacityTypeId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateUsedLicenseHistory};
        $sth->execute(
            $self->licenseId
            ,$self->usedQuantity
            ,$self->capacityTypeId
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
        insert into h_used_license (
            license_id
            ,used_quantity
            ,capacity_type_id
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertUsedLicenseHistory', $query);
}

sub queryUpdate {
    my $query = '
        update h_used_license
        set
            license_id = ?
            ,used_quantity = ?
            ,capacity_type_id = ?
        where
            id = ?
    ';
    return ('updateUsedLicenseHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteUsedLicenseHistory};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from h_used_license a where
            exists ( select b.id from h_used_license b where b.id = ?
            and a.license_id = b.license_id 
            and a.used_quantity = b.used_quantity 
            and a.capacity_type_id = b.capacity_type_id 
)    ';
    return ('deleteUsedLicenseHistory', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyUsedLicenseHistory};
    my $id;
    my $licenseId;
    my $usedQuantity;
    my $capacityTypeId;
    $sth->bind_columns(
        \$id
        ,\$licenseId
        ,\$usedQuantity
        ,\$capacityTypeId
    );
    $sth->execute(
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->licenseId($licenseId);
    $self->usedQuantity($usedQuantity);
    $self->capacityTypeId($capacityTypeId);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,license_id
            ,used_quantity
            ,capacity_type_id
        from
            h_used_license
        where
    ';
    return ('getByBizKeyUsedLicenseHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyUsedLicenseHistory};
    my $licenseId;
    my $usedQuantity;
    my $capacityTypeId;
    $sth->bind_columns(
        \$licenseId
        ,\$usedQuantity
        ,\$capacityTypeId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->licenseId($licenseId);
    $self->usedQuantity($usedQuantity);
    $self->capacityTypeId($capacityTypeId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            license_id
            ,used_quantity
            ,capacity_type_id
        from
            h_used_license
        where
            id = ?
    ';
    return ('getByIdKeyUsedLicenseHistory', $query);
}

1;
