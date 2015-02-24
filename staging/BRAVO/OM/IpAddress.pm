package BRAVO::OM::IpAddress;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_ipAddress => undef
        ,_hostname => undef
        ,_domain => undef
        ,_subnet => undef
        ,_instanceId => undef
        ,_gateway => undef
        ,_primaryDns => undef
        ,_secondaryDns => undef
        ,_isDhcp => undef
        ,_permMacAddress => undef
        ,_ipv6Address => undef
        ,_table => 'software_lpar_ip_address'
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
    if (defined $self->ipAddress && defined $object->ipAddress) {
        $equal = 1 if $self->ipAddress eq $object->ipAddress;
    }
    $equal = 1 if (!defined $self->ipAddress && !defined $object->ipAddress);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hostname && defined $object->hostname) {
        $equal = 1 if $self->hostname eq $object->hostname;
    }
    $equal = 1 if (!defined $self->hostname && !defined $object->hostname);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->domain && defined $object->domain) {
        $equal = 1 if $self->domain eq $object->domain;
    }
    $equal = 1 if (!defined $self->domain && !defined $object->domain);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->subnet && defined $object->subnet) {
        $equal = 1 if $self->subnet eq $object->subnet;
    }
    $equal = 1 if (!defined $self->subnet && !defined $object->subnet);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->instanceId && defined $object->instanceId) {
        $equal = 1 if $self->instanceId eq $object->instanceId;
    }
    $equal = 1 if (!defined $self->instanceId && !defined $object->instanceId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->gateway && defined $object->gateway) {
        $equal = 1 if $self->gateway eq $object->gateway;
    }
    $equal = 1 if (!defined $self->gateway && !defined $object->gateway);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->primaryDns && defined $object->primaryDns) {
        $equal = 1 if $self->primaryDns eq $object->primaryDns;
    }
    $equal = 1 if (!defined $self->primaryDns && !defined $object->primaryDns);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->secondaryDns && defined $object->secondaryDns) {
        $equal = 1 if $self->secondaryDns eq $object->secondaryDns;
    }
    $equal = 1 if (!defined $self->secondaryDns && !defined $object->secondaryDns);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->isDhcp && defined $object->isDhcp) {
        $equal = 1 if $self->isDhcp eq $object->isDhcp;
    }
    $equal = 1 if (!defined $self->isDhcp && !defined $object->isDhcp);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->permMacAddress && defined $object->permMacAddress) {
        $equal = 1 if $self->permMacAddress eq $object->permMacAddress;
    }
    $equal = 1 if (!defined $self->permMacAddress && !defined $object->permMacAddress);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->ipv6Address && defined $object->ipv6Address) {
        $equal = 1 if $self->ipv6Address eq $object->ipv6Address;
    }
    $equal = 1 if (!defined $self->ipv6Address && !defined $object->ipv6Address);
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

sub ipAddress {
    my $self = shift;
    $self->{_ipAddress} = shift if scalar @_ == 1;
    return $self->{_ipAddress};
}

sub hostname {
    my $self = shift;
    $self->{_hostname} = shift if scalar @_ == 1;
    return $self->{_hostname};
}

sub domain {
    my $self = shift;
    $self->{_domain} = shift if scalar @_ == 1;
    return $self->{_domain};
}

sub subnet {
    my $self = shift;
    $self->{_subnet} = shift if scalar @_ == 1;
    return $self->{_subnet};
}

sub instanceId {
    my $self = shift;
    $self->{_instanceId} = shift if scalar @_ == 1;
    return $self->{_instanceId};
}

sub gateway {
    my $self = shift;
    $self->{_gateway} = shift if scalar @_ == 1;
    return $self->{_gateway};
}

sub primaryDns {
    my $self = shift;
    $self->{_primaryDns} = shift if scalar @_ == 1;
    return $self->{_primaryDns};
}

sub secondaryDns {
    my $self = shift;
    $self->{_secondaryDns} = shift if scalar @_ == 1;
    return $self->{_secondaryDns};
}

sub isDhcp {
    my $self = shift;
    $self->{_isDhcp} = shift if scalar @_ == 1;
    return $self->{_isDhcp};
}

sub permMacAddress {
    my $self = shift;
    $self->{_permMacAddress} = shift if scalar @_ == 1;
    return $self->{_permMacAddress};
}

sub ipv6Address {
    my $self = shift;
    $self->{_ipv6Address} = shift if scalar @_ == 1;
    return $self->{_ipv6Address};
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
    my $s = "[IpAddress] ";
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
    $s .= "ipAddress=";
    if (defined $self->{_ipAddress}) {
        $s .= $self->{_ipAddress};
    }
    $s .= ",";
    $s .= "hostname=";
    if (defined $self->{_hostname}) {
        $s .= $self->{_hostname};
    }
    $s .= ",";
    $s .= "domain=";
    if (defined $self->{_domain}) {
        $s .= $self->{_domain};
    }
    $s .= ",";
    $s .= "subnet=";
    if (defined $self->{_subnet}) {
        $s .= $self->{_subnet};
    }
    $s .= ",";
    $s .= "instanceId=";
    if (defined $self->{_instanceId}) {
        $s .= $self->{_instanceId};
    }
    $s .= ",";
    $s .= "gateway=";
    if (defined $self->{_gateway}) {
        $s .= $self->{_gateway};
    }
    $s .= ",";
    $s .= "primaryDns=";
    if (defined $self->{_primaryDns}) {
        $s .= $self->{_primaryDns};
    }
    $s .= ",";
    $s .= "secondaryDns=";
    if (defined $self->{_secondaryDns}) {
        $s .= $self->{_secondaryDns};
    }
    $s .= ",";
    $s .= "isDhcp=";
    if (defined $self->{_isDhcp}) {
        $s .= $self->{_isDhcp};
    }
    $s .= ",";
    $s .= "permMacAddress=";
    if (defined $self->{_permMacAddress}) {
        $s .= $self->{_permMacAddress};
    }
    $s .= ",";
    $s .= "ipv6Address=";
    if (defined $self->{_ipv6Address}) {
        $s .= $self->{_ipv6Address};
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
        my $sth = $connection->sql->{insertIpAddress};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLparId
            ,$self->ipAddress
            ,$self->hostname
            ,$self->domain
            ,$self->subnet
            ,$self->instanceId
            ,$self->gateway
            ,$self->primaryDns
            ,$self->secondaryDns
            ,$self->isDhcp
            ,$self->permMacAddress
            ,$self->ipv6Address
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateIpAddress};
        $sth->execute(
            $self->softwareLparId
            ,$self->ipAddress
            ,$self->hostname
            ,$self->domain
            ,$self->subnet
            ,$self->instanceId
            ,$self->gateway
            ,$self->primaryDns
            ,$self->secondaryDns
            ,$self->isDhcp
            ,$self->permMacAddress
            ,$self->ipv6Address
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
        insert into software_lpar_ip_address (
            software_lpar_id
            ,ip_address
            ,ip_hostname
            ,ip_domain
            ,ip_subnet
            ,instance_id
            ,gateway
            ,primary_dns
            ,secondary_dns
            ,is_dhcp
            ,perm_mac_address
            ,ipv6_address
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
            ,?
        ))
    ';
    return ('insertIpAddress', $query);
}

sub queryUpdate {
    my $query = '
        update software_lpar_ip_address
        set
            software_lpar_id = ?
            ,ip_address = ?
            ,ip_hostname = ?
            ,ip_domain = ?
            ,ip_subnet = ?
            ,instance_id = ?
            ,gateway = ?
            ,primary_dns = ?
            ,secondary_dns = ?
            ,is_dhcp = ?
            ,perm_mac_address = ?
            ,ipv6_address = ?
        where
            id = ?
    ';
    return ('updateIpAddress', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteIpAddress};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_lpar_ip_address
        where
            id = ?
    ';
    return ('deleteIpAddress', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyIpAddress};
    my $id;
    my $hostname;
    my $domain;
    my $subnet;
    my $instanceId;
    my $gateway;
    my $primaryDns;
    my $secondaryDns;
    my $isDhcp;
    my $permMacAddress;
    my $ipv6Address;
    $sth->bind_columns(
        \$id
        ,\$hostname
        ,\$domain
        ,\$subnet
        ,\$instanceId
        ,\$gateway
        ,\$primaryDns
        ,\$secondaryDns
        ,\$isDhcp
        ,\$permMacAddress
        ,\$ipv6Address
    );
    $sth->execute(
        $self->softwareLparId
        ,$self->ipAddress
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->hostname($hostname);
    $self->domain($domain);
    $self->subnet($subnet);
    $self->instanceId($instanceId);
    $self->gateway($gateway);
    $self->primaryDns($primaryDns);
    $self->secondaryDns($secondaryDns);
    $self->isDhcp($isDhcp);
    $self->permMacAddress($permMacAddress);
    $self->ipv6Address($ipv6Address);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,ip_hostname
            ,ip_domain
            ,ip_subnet
            ,instance_id
            ,gateway
            ,primary_dns
            ,secondary_dns
            ,is_dhcp
            ,perm_mac_address
            ,ipv6_address
        from
            software_lpar_ip_address
        where
            software_lpar_id = ?
            and ip_address = ?
     with ur';
    return ('getByBizKeyIpAddress', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyIpAddress};
    my $softwareLparId;
    my $ipAddress;
    my $hostname;
    my $domain;
    my $subnet;
    my $instanceId;
    my $gateway;
    my $primaryDns;
    my $secondaryDns;
    my $isDhcp;
    my $permMacAddress;
    my $ipv6Address;
    $sth->bind_columns(
        \$softwareLparId
        ,\$ipAddress
        ,\$hostname
        ,\$domain
        ,\$subnet
        ,\$instanceId
        ,\$gateway
        ,\$primaryDns
        ,\$secondaryDns
        ,\$isDhcp
        ,\$permMacAddress
        ,\$ipv6Address
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareLparId($softwareLparId);
    $self->ipAddress($ipAddress);
    $self->hostname($hostname);
    $self->domain($domain);
    $self->subnet($subnet);
    $self->instanceId($instanceId);
    $self->gateway($gateway);
    $self->primaryDns($primaryDns);
    $self->secondaryDns($secondaryDns);
    $self->isDhcp($isDhcp);
    $self->permMacAddress($permMacAddress);
    $self->ipv6Address($ipv6Address);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,ip_address
            ,ip_hostname
            ,ip_domain
            ,ip_subnet
            ,instance_id
            ,gateway
            ,primary_dns
            ,secondary_dns
            ,is_dhcp
            ,perm_mac_address
            ,ipv6_address
        from
            software_lpar_ip_address
        where
            id = ?
     with ur';
    return ('getByIdKeyIpAddress', $query);
}

1;
