package BRAVO::OM::CountryCode;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_countryCodeId => undef
        ,_regionId => undef
        ,_name => undef
        ,_code => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_action => undef
        ,_table => 'country_code'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->countryCodeId && defined $object->countryCodeId) {
        $equal = 1 if $self->countryCodeId eq $object->countryCodeId;
    }
    $equal = 1 if (!defined $self->countryCodeId && !defined $object->countryCodeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->regionId && defined $object->regionId) {
        $equal = 1 if $self->regionId eq $object->regionId;
    }
    $equal = 1 if (!defined $self->regionId && !defined $object->regionId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->code && defined $object->code) {
        $equal = 1 if $self->code eq $object->code;
    }
    $equal = 1 if (!defined $self->code && !defined $object->code);
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

sub countryCodeId {
    my $self = shift;
    $self->{_countryCodeId} = shift if scalar @_ == 1;
    return $self->{_countryCodeId};
}

sub regionId {
    my $self = shift;
    $self->{_regionId} = shift if scalar @_ == 1;
    return $self->{_regionId};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub code {
    my $self = shift;
    $self->{_code} = shift if scalar @_ == 1;
    return $self->{_code};
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
    my $s = "[CountryCode] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "countryCodeId=";
    if (defined $self->{_countryCodeId}) {
        $s .= $self->{_countryCodeId};
    }
    $s .= ",";
    $s .= "regionId=";
    if (defined $self->{_regionId}) {
        $s .= $self->{_regionId};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "code=";
    if (defined $self->{_code}) {
        $s .= $self->{_code};
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
        my $sth = $connection->sql->{insertCountryCode};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->countryCodeId
            ,$self->regionId
            ,$self->name
            ,$self->code
            ,$self->creationDateTime
            ,$self->updateDateTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateCountryCode};
        $sth->execute(
            $self->countryCodeId
            ,$self->regionId
            ,$self->name
            ,$self->code
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
            id
        from
            final table (
        insert into country_code (
            id
            ,region_id
            ,name
            ,code
            ,creation_date_time
            ,update_date_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertCountryCode', $query);
}

sub queryUpdate {
    my $query = '
        update country_code
        set
            id = ?
            ,region_id = ?
            ,name = ?
            ,code = ?
            ,creation_date_time = ?
            ,update_date_time = ?
        where
            id = ?
    ';
    return ('updateCountryCode', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteCountryCode};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from country_code
        where
            id = ?
    ';
    return ('deleteCountryCode', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyCountryCode};
    my $id;
    my $regionId;
    my $name;
    my $code;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$id
        ,\$regionId
        ,\$name
        ,\$code
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->countryCodeId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->regionId($regionId);
    $self->name($name);
    $self->code($code);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,region_id
            ,name
            ,code
            ,creation_date_time
            ,update_date_time
        from
            country_code
        where
            id = ?
    ';
    return ('getByBizKeyCountryCode', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyCountryCode};
    my $countryCodeId;
    my $regionId;
    my $name;
    my $code;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$countryCodeId
        ,\$regionId
        ,\$name
        ,\$code
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->countryCodeId($countryCodeId);
    $self->regionId($regionId);
    $self->name($name);
    $self->code($code);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            id
            ,region_id
            ,name
            ,code
            ,creation_date_time
            ,update_date_time
        from
            country_code
        where
            id = ?
    ';
    return ('getByIdKeyCountryCode', $query);
}

1;
