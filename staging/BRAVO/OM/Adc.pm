package BRAVO::OM::Adc;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_epName => undef
        ,_epOid => undef
        ,_ipAddress => undef
        ,_cust => undef
        ,_loc => undef
        ,_gu => undef
        ,_serverType => undef
        ,_sesdrLocation => undef
        ,_sesdrBpUsing => undef
        ,_sesdrSystid => undef
        ,_table => 'software_lpar_adc'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->epName && defined $object->epName) {
        $equal = 1 if $self->epName eq $object->epName;
    }
    $equal = 1 if (!defined $self->epName && !defined $object->epName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->epOid && defined $object->epOid) {
        $equal = 1 if $self->epOid eq $object->epOid;
    }
    $equal = 1 if (!defined $self->epOid && !defined $object->epOid);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->ipAddress && defined $object->ipAddress) {
        $equal = 1 if $self->ipAddress eq $object->ipAddress;
    }
    $equal = 1 if (!defined $self->ipAddress && !defined $object->ipAddress);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cust && defined $object->cust) {
        $equal = 1 if $self->cust eq $object->cust;
    }
    $equal = 1 if (!defined $self->cust && !defined $object->cust);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->loc && defined $object->loc) {
        $equal = 1 if $self->loc eq $object->loc;
    }
    $equal = 1 if (!defined $self->loc && !defined $object->loc);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->gu && defined $object->gu) {
        $equal = 1 if $self->gu eq $object->gu;
    }
    $equal = 1 if (!defined $self->gu && !defined $object->gu);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverType && defined $object->serverType) {
        $equal = 1 if $self->serverType eq $object->serverType;
    }
    $equal = 1 if (!defined $self->serverType && !defined $object->serverType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sesdrLocation && defined $object->sesdrLocation) {
        $equal = 1 if $self->sesdrLocation eq $object->sesdrLocation;
    }
    $equal = 1 if (!defined $self->sesdrLocation && !defined $object->sesdrLocation);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sesdrBpUsing && defined $object->sesdrBpUsing) {
        $equal = 1 if $self->sesdrBpUsing eq $object->sesdrBpUsing;
    }
    $equal = 1 if (!defined $self->sesdrBpUsing && !defined $object->sesdrBpUsing);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sesdrSystid && defined $object->sesdrSystid) {
        $equal = 1 if $self->sesdrSystid eq $object->sesdrSystid;
    }
    $equal = 1 if (!defined $self->sesdrSystid && !defined $object->sesdrSystid);
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

sub epName {
    my $self = shift;
    $self->{_epName} = shift if scalar @_ == 1;
    return $self->{_epName};
}

sub epOid {
    my $self = shift;
    $self->{_epOid} = shift if scalar @_ == 1;
    return $self->{_epOid};
}

sub ipAddress {
    my $self = shift;
    $self->{_ipAddress} = shift if scalar @_ == 1;
    return $self->{_ipAddress};
}

sub cust {
    my $self = shift;
    $self->{_cust} = shift if scalar @_ == 1;
    return $self->{_cust};
}

sub loc {
    my $self = shift;
    $self->{_loc} = shift if scalar @_ == 1;
    return $self->{_loc};
}

sub gu {
    my $self = shift;
    $self->{_gu} = shift if scalar @_ == 1;
    return $self->{_gu};
}

sub serverType {
    my $self = shift;
    $self->{_serverType} = shift if scalar @_ == 1;
    return $self->{_serverType};
}

sub sesdrLocation {
    my $self = shift;
    $self->{_sesdrLocation} = shift if scalar @_ == 1;
    return $self->{_sesdrLocation};
}

sub sesdrBpUsing {
    my $self = shift;
    $self->{_sesdrBpUsing} = shift if scalar @_ == 1;
    return $self->{_sesdrBpUsing};
}

sub sesdrSystid {
    my $self = shift;
    $self->{_sesdrSystid} = shift if scalar @_ == 1;
    return $self->{_sesdrSystid};
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
    my $s = "[Adc] ";
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
    $s .= "epName=";
    if (defined $self->{_epName}) {
        $s .= $self->{_epName};
    }
    $s .= ",";
    $s .= "epOid=";
    if (defined $self->{_epOid}) {
        $s .= $self->{_epOid};
    }
    $s .= ",";
    $s .= "ipAddress=";
    if (defined $self->{_ipAddress}) {
        $s .= $self->{_ipAddress};
    }
    $s .= ",";
    $s .= "cust=";
    if (defined $self->{_cust}) {
        $s .= $self->{_cust};
    }
    $s .= ",";
    $s .= "loc=";
    if (defined $self->{_loc}) {
        $s .= $self->{_loc};
    }
    $s .= ",";
    $s .= "gu=";
    if (defined $self->{_gu}) {
        $s .= $self->{_gu};
    }
    $s .= ",";
    $s .= "serverType=";
    if (defined $self->{_serverType}) {
        $s .= $self->{_serverType};
    }
    $s .= ",";
    $s .= "sesdrLocation=";
    if (defined $self->{_sesdrLocation}) {
        $s .= $self->{_sesdrLocation};
    }
    $s .= ",";
    $s .= "sesdrBpUsing=";
    if (defined $self->{_sesdrBpUsing}) {
        $s .= $self->{_sesdrBpUsing};
    }
    $s .= ",";
    $s .= "sesdrSystid=";
    if (defined $self->{_sesdrSystid}) {
        $s .= $self->{_sesdrSystid};
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
        my $sth = $connection->sql->{insertAdc};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLparId
            ,$self->epName
            ,$self->epOid
            ,$self->ipAddress
            ,$self->cust
            ,$self->loc
            ,$self->gu
            ,$self->serverType
            ,$self->sesdrLocation
            ,$self->sesdrBpUsing
            ,$self->sesdrSystid
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateAdc};
        $sth->execute(
            $self->softwareLparId
            ,$self->epName
            ,$self->epOid
            ,$self->ipAddress
            ,$self->cust
            ,$self->loc
            ,$self->gu
            ,$self->serverType
            ,$self->sesdrLocation
            ,$self->sesdrBpUsing
            ,$self->sesdrSystid
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
        insert into software_lpar_adc (
            software_lpar_id
            ,ep_name
            ,ep_oid
            ,ip_address
            ,cust
            ,loc
            ,gu
            ,server_type
            ,sesdr_location
            ,sesdr_bp_using
            ,sesdr_syst_id
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
            ,?
        ))
    ';
    return ('insertAdc', $query);
}

sub queryUpdate {
    my $query = '
        update software_lpar_adc
        set
            software_lpar_id = ?
            ,ep_name = ?
            ,ep_oid = ?
            ,ip_address = ?
            ,cust = ?
            ,loc = ?
            ,gu = ?
            ,server_type = ?
            ,sesdr_location = ?
            ,sesdr_bp_using = ?
            ,sesdr_syst_id = ?
        where
            id = ?
    ';
    return ('updateAdc', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteAdc};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_lpar_adc
        where
            id = ?
    ';
    return ('deleteAdc', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyAdc};
    my $id;
    my $epOid;
    my $ipAddress;
    my $cust;
    my $loc;
    my $gu;
    my $serverType;
    my $sesdrLocation;
    my $sesdrBpUsing;
    my $sesdrSystid;
    $sth->bind_columns(
        \$id
        ,\$epOid
        ,\$ipAddress
        ,\$cust
        ,\$loc
        ,\$gu
        ,\$serverType
        ,\$sesdrLocation
        ,\$sesdrBpUsing
        ,\$sesdrSystid
    );
    $sth->execute(
        $self->softwareLparId
        ,$self->epName
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->epOid($epOid);
    $self->ipAddress($ipAddress);
    $self->cust($cust);
    $self->loc($loc);
    $self->gu($gu);
    $self->serverType($serverType);
    $self->sesdrLocation($sesdrLocation);
    $self->sesdrBpUsing($sesdrBpUsing);
    $self->sesdrSystid($sesdrSystid);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,ep_oid
            ,ip_address
            ,cust
            ,loc
            ,gu
            ,server_type
            ,sesdr_location
            ,sesdr_bp_using
            ,sesdr_syst_id
        from
            software_lpar_adc
        where
            software_lpar_id = ?
            and ep_name = ?
     with ur';
    return ('getByBizKeyAdc', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyAdc};
    my $softwareLparId;
    my $epName;
    my $epOid;
    my $ipAddress;
    my $cust;
    my $loc;
    my $gu;
    my $serverType;
    my $sesdrLocation;
    my $sesdrBpUsing;
    my $sesdrSystid;
    $sth->bind_columns(
        \$softwareLparId
        ,\$epName
        ,\$epOid
        ,\$ipAddress
        ,\$cust
        ,\$loc
        ,\$gu
        ,\$serverType
        ,\$sesdrLocation
        ,\$sesdrBpUsing
        ,\$sesdrSystid
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareLparId($softwareLparId);
    $self->epName($epName);
    $self->epOid($epOid);
    $self->ipAddress($ipAddress);
    $self->cust($cust);
    $self->loc($loc);
    $self->gu($gu);
    $self->serverType($serverType);
    $self->sesdrLocation($sesdrLocation);
    $self->sesdrBpUsing($sesdrBpUsing);
    $self->sesdrSystid($sesdrSystid);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,ep_name
            ,ep_oid
            ,ip_address
            ,cust
            ,loc
            ,gu
            ,server_type
            ,sesdr_location
            ,sesdr_bp_using
            ,sesdr_syst_id
        from
            software_lpar_adc
        where
            id = ?
     with ur';
    return ('getByIdKeyAdc', $query);
}

1;
