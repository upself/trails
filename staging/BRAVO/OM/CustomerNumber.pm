package BRAVO::OM::CustomerNumber;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_customerNumberId => undef
        ,_customerId => undef
        ,_customerNumber => undef
        ,_status => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_lpidId => undef
        ,_countryCodeId => undef
        ,_action => undef
        ,_table => 'customer_number'
        ,_idField => 'customer_number_id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->customerNumberId && defined $object->customerNumberId) {
        $equal = 1 if $self->customerNumberId eq $object->customerNumberId;
    }
    $equal = 1 if (!defined $self->customerNumberId && !defined $object->customerNumberId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerNumber && defined $object->customerNumber) {
        $equal = 1 if $self->customerNumber eq $object->customerNumber;
    }
    $equal = 1 if (!defined $self->customerNumber && !defined $object->customerNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
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

    $equal = 0;
    if (defined $self->lpidId && defined $object->lpidId) {
        $equal = 1 if $self->lpidId eq $object->lpidId;
    }
    $equal = 1 if (!defined $self->lpidId && !defined $object->lpidId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->countryCodeId && defined $object->countryCodeId) {
        $equal = 1 if $self->countryCodeId eq $object->countryCodeId;
    }
    $equal = 1 if (!defined $self->countryCodeId && !defined $object->countryCodeId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub customerNumberId {
    my $self = shift;
    $self->{_customerNumberId} = shift if scalar @_ == 1;
    return $self->{_customerNumberId};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub customerNumber {
    my $self = shift;
    $self->{_customerNumber} = shift if scalar @_ == 1;
    return $self->{_customerNumber};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
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

sub lpidId {
    my $self = shift;
    $self->{_lpidId} = shift if scalar @_ == 1;
    return $self->{_lpidId};
}

sub countryCodeId {
    my $self = shift;
    $self->{_countryCodeId} = shift if scalar @_ == 1;
    return $self->{_countryCodeId};
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
    my $s = "[CustomerNumber] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "customerNumberId=";
    if (defined $self->{_customerNumberId}) {
        $s .= $self->{_customerNumberId};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "customerNumber=";
    if (defined $self->{_customerNumber}) {
        $s .= $self->{_customerNumber};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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
    $s .= "lpidId=";
    if (defined $self->{_lpidId}) {
        $s .= $self->{_lpidId};
    }
    $s .= ",";
    $s .= "countryCodeId=";
    if (defined $self->{_countryCodeId}) {
        $s .= $self->{_countryCodeId};
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
        my $sth = $connection->sql->{insertCustomerNumber};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->customerNumberId
            ,$self->customerId
            ,$self->customerNumber
            ,$self->status
            ,$self->creationDateTime
            ,$self->updateDateTime
            ,$self->lpidId
            ,$self->countryCodeId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateCustomerNumber};
        $sth->execute(
            $self->customerNumberId
            ,$self->customerId
            ,$self->customerNumber
            ,$self->status
            ,$self->creationDateTime
            ,$self->updateDateTime
            ,$self->lpidId
            ,$self->countryCodeId
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            customer_number_id
        from
            final table (
        insert into customer_number (
            customer_number_id
            ,customer_id
            ,customer_number
            ,status
            ,creation_date_time
            ,update_date_time
            ,lpid_id
            ,country_code_id
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertCustomerNumber', $query);
}

sub queryUpdate {
    my $query = '
        update customer_number
        set
            customer_number_id = ?
            ,customer_id = ?
            ,customer_number = ?
            ,status = ?
            ,creation_date_time = ?
            ,update_date_time = ?
            ,lpid_id = ?
            ,country_code_id = ?
        where
            customer_number_id = ?
    ';
    return ('updateCustomerNumber', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteCustomerNumber};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from customer_number
        where
            customer_number_id = ?
    ';
    return ('deleteCustomerNumber', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyCustomerNumber};
    my $id;
    my $customerNumberId;
    my $customerId;
    my $status;
    my $creationDateTime;
    my $updateDateTime;
    my $lpidId;
    $sth->bind_columns(
        \$id
        ,\$customerNumberId
        ,\$customerId
        ,\$status
        ,\$creationDateTime
        ,\$updateDateTime
        ,\$lpidId
    );
    $sth->execute(
        $self->customerNumber
        ,$self->countryCodeId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->customerNumberId($customerNumberId);
    $self->customerId($customerId);
    $self->status($status);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    $self->lpidId($lpidId);
}

sub queryGetByBizKey {
    my $query = '
        select
            customer_number_id
            ,customer_number_id
            ,customer_id
            ,status
            ,creation_date_time
            ,update_date_time
            ,lpid_id
        from
            customer_number
        where
            customer_number = ?
            and country_code_id = ?
    ';
    return ('getByBizKeyCustomerNumber', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyCustomerNumber};
    my $customerNumberId;
    my $customerId;
    my $customerNumber;
    my $status;
    my $creationDateTime;
    my $updateDateTime;
    my $lpidId;
    my $countryCodeId;
    $sth->bind_columns(
        \$customerNumberId
        ,\$customerId
        ,\$customerNumber
        ,\$status
        ,\$creationDateTime
        ,\$updateDateTime
        ,\$lpidId
        ,\$countryCodeId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->customerNumberId($customerNumberId);
    $self->customerId($customerId);
    $self->customerNumber($customerNumber);
    $self->status($status);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    $self->lpidId($lpidId);
    $self->countryCodeId($countryCodeId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            customer_number_id
            ,customer_id
            ,customer_number
            ,status
            ,creation_date_time
            ,update_date_time
            ,lpid_id
            ,country_code_id
        from
            customer_number
        where
            customer_number_id = ?
    ';
    return ('getByIdKeyCustomerNumber', $query);
}

1;
