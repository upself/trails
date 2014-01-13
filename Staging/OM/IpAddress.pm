package Staging::OM::IpAddress;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scanRecordId => undef
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
        ,_action => undef
        ,_table => 'ip_address'
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

sub scanRecordId {
    my $self = shift;
    $self->{_scanRecordId} = shift if scalar @_ == 1;
    return $self->{_scanRecordId};
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
    my $s = "[IpAddress] ";
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
        my $sth = $connection->sql->{insertIpAddress};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scanRecordId
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
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateIpAddress};
        $sth->execute(
            $self->scanRecordId
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
        insert into ip_address (
            scan_record_id
            ,ip_address
            ,hostname
            ,domain
            ,subnet
            ,instance_id
            ,gateway
            ,primary_dns
            ,secondary_dns
            ,is_dhcp
            ,perm_mac_address
            ,ipv6_address
            ,action
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
            ,?
        ))
    ';
    return ('insertIpAddress', $query);
}

sub queryUpdate {
    my $query = '
        update ip_address
        set
            scan_record_id = ?
            ,ip_address = ?
            ,hostname = ?
            ,domain = ?
            ,subnet = ?
            ,instance_id = ?
            ,gateway = ?
            ,primary_dns = ?
            ,secondary_dns = ?
            ,is_dhcp = ?
            ,perm_mac_address = ?
            ,ipv6_address = ?
            ,action = ?
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
        delete from ip_address a where
            a.id = ?
    ';
    return ('deleteIpAddress', $query);
}

1;
