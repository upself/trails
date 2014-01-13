package BRAVO::OM::CustomerType;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_customerTypeId => undef
        ,_name => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_action => undef
        ,_table => 'customer_type'
        ,_idField => 'customer_type_id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->customerTypeId && defined $object->customerTypeId) {
        $equal = 1 if $self->customerTypeId eq $object->customerTypeId;
    }
    $equal = 1 if (!defined $self->customerTypeId && !defined $object->customerTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->creationDateTime && defined $object->creationDateTime) {
        $equal = 1 if $self->creationDateTime eq $object->creationDateTime;
    }
    $equal = 1 if (!defined $self->creationDateTime && !defined $object->creationDateTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->updateDateTime && defined $object->updateDateTime) {
        $equal = 1 if $self->updateDateTime eq $object->updateDateTime;
    }
    $equal = 1 if (!defined $self->updateDateTime && !defined $object->updateDateTime);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub customerTypeId {
    my $self = shift;
    $self->{_customerTypeId} = shift if scalar @_ == 1;
    return $self->{_customerTypeId};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub creationDateTime {
    my $self = shift;
    $self->{_creationDateTime} = shift if scalar @_ == 1;
    return $self->{_creationDateTime};
}

sub updateDateTime {
    my $self = shift;
    $self->{_updateDateTime} = shift if scalar @_ == 1;
    return $self->{_updateDateTime};
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
    my $s = "[CustomerType] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "customerTypeId=";
    if (defined $self->{_customerTypeId}) {
        $s .= $self->{_customerTypeId};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "creationDateTime=";
    if (defined $self->{_creationDateTime}) {
        $s .= $self->{_creationDateTime};
    }
    $s .= ",";
    $s .= "updateDateTime=";
    if (defined $self->{_updateDateTime}) {
        $s .= $self->{_updateDateTime};
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
        my $sth = $connection->sql->{insertCustomerType};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->customerTypeId
            ,$self->name
            ,$self->creationDateTime
            ,$self->updateDateTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateCustomerType};
        $sth->execute(
            $self->customerTypeId
            ,$self->name
            ,$self->creationDateTime
            ,$self->updateDateTime
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            customer_type_id
        from
            final table (
        insert into customer_type (
            customer_type_id
            ,customer_type_name
            ,creation_date_time
            ,update_date_time
        ) values (
            ?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertCustomerType', $query);
}

sub queryUpdate {
    my $query = '
        update customer_type
        set
            customer_type_id = ?
            ,customer_type_name = ?
            ,creation_date_time = ?
            ,update_date_time = ?
        where
            customer_type_id = ?
    ';
    return ('updateCustomerType', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteCustomerType};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from customer_type a where
            a.customer_type_id = ?
    ';
    return ('deleteCustomerType', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyCustomerType};
    my $id;
    my $name;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$id
        ,\$name
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->customerTypeId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->name($name);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            customer_type_id
            ,customer_type_name
            ,creation_date_time
            ,update_date_time
        from
            customer_type
        where
            customer_type_id = ?
    ';
    return ('getByBizKeyCustomerType', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyCustomerType};
    my $customerTypeId;
    my $name;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$customerTypeId
        ,\$name
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->customerTypeId($customerTypeId);
    $self->name($name);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            customer_type_id
            ,customer_type_name
            ,creation_date_time
            ,update_date_time
        from
            customer_type
        where
            customer_type_id = ?
    ';
    return ('getByIdKeyCustomerType', $query);
}

1;
