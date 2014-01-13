package BRAVO::OM::Region;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_regionId => undef
        ,_geographyId => undef
        ,_name => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_action => undef
        ,_table => 'region'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->regionId && defined $object->regionId) {
        $equal = 1 if $self->regionId eq $object->regionId;
    }
    $equal = 1 if (!defined $self->regionId && !defined $object->regionId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->geographyId && defined $object->geographyId) {
        $equal = 1 if $self->geographyId eq $object->geographyId;
    }
    $equal = 1 if (!defined $self->geographyId && !defined $object->geographyId);
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

sub regionId {
    my $self = shift;
    $self->{_regionId} = shift if scalar @_ == 1;
    return $self->{_regionId};
}

sub geographyId {
    my $self = shift;
    $self->{_geographyId} = shift if scalar @_ == 1;
    return $self->{_geographyId};
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
    my $s = "[Region] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "regionId=";
    if (defined $self->{_regionId}) {
        $s .= $self->{_regionId};
    }
    $s .= ",";
    $s .= "geographyId=";
    if (defined $self->{_geographyId}) {
        $s .= $self->{_geographyId};
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
        my $sth = $connection->sql->{insertRegion};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->regionId
            ,$self->geographyId
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
        my $sth = $connection->sql->{updateRegion};
        $sth->execute(
            $self->regionId
            ,$self->geographyId
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
            id
        from
            final table (
        insert into region (
            id
            ,geography_id
            ,name
            ,creation_date_time
            ,update_date_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertRegion', $query);
}

sub queryUpdate {
    my $query = '
        update region
        set
            id = ?
            ,geography_id = ?
            ,name = ?
            ,creation_date_time = ?
            ,update_date_time = ?
        where
            id = ?
    ';
    return ('updateRegion', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteRegion};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from region a where
            a.id = ?
    ';
    return ('deleteRegion', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyRegion};
    my $id;
    my $geographyId;
    my $name;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$id
        ,\$geographyId
        ,\$name
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->regionId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->geographyId($geographyId);
    $self->name($name);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,geography_id
            ,name
            ,creation_date_time
            ,update_date_time
        from
            region
        where
            id = ?
    ';
    return ('getByBizKeyRegion', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyRegion};
    my $regionId;
    my $geographyId;
    my $name;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$regionId
        ,\$geographyId
        ,\$name
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->regionId($regionId);
    $self->geographyId($geographyId);
    $self->name($name);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            id
            ,geography_id
            ,name
            ,creation_date_time
            ,update_date_time
        from
            region
        where
            id = ?
    ';
    return ('getByIdKeyRegion', $query);
}

1;
