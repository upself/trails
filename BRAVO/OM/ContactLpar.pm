package BRAVO::OM::ContactLpar;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_contactSupportId => undef
        ,_hardwareLparId => undef
        ,_table => 'contact_lpar'
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
    if (defined $self->hardwareLparId && defined $object->hardwareLparId) {
        $equal = 1 if $self->hardwareLparId eq $object->hardwareLparId;
    }
    $equal = 1 if (!defined $self->hardwareLparId && !defined $object->hardwareLparId);
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

sub hardwareLparId {
    my $self = shift;
    $self->{_hardwareLparId} = shift if scalar @_ == 1;
    return $self->{_hardwareLparId};
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
    my $s = "[ContactLpar] ";
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
    $s .= "hardwareLparId=";
    if (defined $self->{_hardwareLparId}) {
        $s .= $self->{_hardwareLparId};
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
        my $sth = $connection->sql->{insertContactLpar};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->contactSupportId
            ,$self->hardwareLparId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateContactLpar};
        $sth->execute(
            $self->contactSupportId
            ,$self->hardwareLparId
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
        insert into contact_lpar (
            contact_support_id
            ,hardware_lpar_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertContactLpar', $query);
}

sub queryUpdate {
    my $query = '
        update contact_lpar
        set
            contact_support_id = ?
            ,hardware_lpar_id = ?
        where
            id = ?
    ';
    return ('updateContactLpar', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteContactLpar};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from contact_lpar
        where
            id = ?
    ';
    return ('deleteContactLpar', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyContactLpar};
    my $contactSupportId;
    my $hardwareLparId;
    $sth->bind_columns(
        \$contactSupportId
        ,\$hardwareLparId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->contactSupportId($contactSupportId);
    $self->hardwareLparId($hardwareLparId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            contact_support_id
            ,hardware_lpar_id
        from
            contact_lpar
        where
            id = ?
    ';
    return ('getByIdKeyContactLpar', $query);
}

1;
