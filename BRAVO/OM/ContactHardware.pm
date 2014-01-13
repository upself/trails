package BRAVO::OM::ContactHardware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_contactSupportId => undef
        ,_hardwareId => undef
        ,_table => 'contact_hardware'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->contactSupportId && defined $object->contactSupportId) {
        $equal = 1 if $self->contactSupportId eq $object->contactSupportId;
    }
    $equal = 1 if (!defined $self->contactSupportId && !defined $object->contactSupportId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hardwareId && defined $object->hardwareId) {
        $equal = 1 if $self->hardwareId eq $object->hardwareId;
    }
    $equal = 1 if (!defined $self->hardwareId && !defined $object->hardwareId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub contactSupportId {
    my $self = shift;
    $self->{_contactSupportId} = shift if scalar @_ == 1;
    return $self->{_contactSupportId};
}

sub hardwareId {
    my $self = shift;
    $self->{_hardwareId} = shift if scalar @_ == 1;
    return $self->{_hardwareId};
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
    my $s = "[ContactHardware] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "contactSupportId=";
    if (defined $self->{_contactSupportId}) {
        $s .= $self->{_contactSupportId};
    }
    $s .= ",";
    $s .= "hardwareId=";
    if (defined $self->{_hardwareId}) {
        $s .= $self->{_hardwareId};
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
        my $sth = $connection->sql->{insertContactHardware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->contactSupportId
            ,$self->hardwareId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateContactHardware};
        $sth->execute(
            $self->contactSupportId
            ,$self->hardwareId
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
        insert into contact_hardware (
            contact_support_id
            ,hardware_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertContactHardware', $query);
}

sub queryUpdate {
    my $query = '
        update contact_hardware
        set
            contact_support_id = ?
            ,hardware_id = ?
        where
            id = ?
    ';
    return ('updateContactHardware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteContactHardware};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from contact_hardware a where
            a.id = ?
    ';
    return ('deleteContactHardware', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyContactHardware};
    my $contactSupportId;
    my $hardwareId;
    $sth->bind_columns(
        \$contactSupportId
        ,\$hardwareId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->contactSupportId($contactSupportId);
    $self->hardwareId($hardwareId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            contact_support_id
            ,hardware_id
        from
            contact_hardware
        where
            id = ?
    ';
    return ('getByIdKeyContactHardware', $query);
}

1;
