package BRAVO::OM::LicenseSoftwareMap;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_licenseId => undef
        ,_softwareId => undef
        ,_table => 'license_sw_map'
        ,_idField => 'id'
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
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
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

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
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
    my $s = "[LicenseSoftwareMap] ";
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
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
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
        my $sth = $connection->sql->{insertLicenseSoftwareMap};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->licenseId
            ,$self->softwareId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateLicenseSoftwareMap};
        $sth->execute(
            $self->licenseId
            ,$self->softwareId
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
        insert into license_sw_map (
            license_id
            ,software_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertLicenseSoftwareMap', $query);
}

sub queryUpdate {
    my $query = '
        update license_sw_map
        set
            license_id = ?
            ,software_id = ?
        where
            id = ?
    ';
    return ('updateLicenseSoftwareMap', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteLicenseSoftwareMap};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from license_sw_map
        where
            id = ?
    ';
    return ('deleteLicenseSoftwareMap', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyLicenseSoftwareMap};
    my $id;
    my $softwareId;
    $sth->bind_columns(
        \$id
        ,\$softwareId
    );
    $sth->execute(
        $self->licenseId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->softwareId($softwareId);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,software_id
        from
            license_sw_map
        where
            license_id = ?
    ';
    return ('getByBizKeyLicenseSoftwareMap', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyLicenseSoftwareMap};
    my $licenseId;
    my $softwareId;
    $sth->bind_columns(
        \$licenseId
        ,\$softwareId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->licenseId($licenseId);
    $self->softwareId($softwareId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            license_id
            ,software_id
        from
            license_sw_map
        where
            id = ?
    ';
    return ('getByIdKeyLicenseSoftwareMap', $query);
}

1;
