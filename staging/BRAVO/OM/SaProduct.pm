package BRAVO::OM::SaProduct;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareId => undef
        ,_table => 'sa_product'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->table && defined $object->table) {
        $equal = 1 if $self->table eq $object->table;
    }
    $equal = 1 if (!defined $self->table && !defined $object->table);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->idField && defined $object->idField) {
        $equal = 1 if $self->idField eq $object->idField;
    }
    $equal = 1 if (!defined $self->idField && !defined $object->idField);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
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
    my $s = "[SaProduct] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
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
        my $sth = $connection->sql->{insertSaProduct};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSaProduct};
        $sth->execute(
            $self->softwareId
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
        insert into sa_product (
            software_id
        ) values (
            ?
        ))
    ';
    return ('insertSaProduct', $query);
}

sub queryUpdate {
    my $query = '
        update sa_product
        set
            software_id = ?
        where
            id = ?
    ';
    return ('updateSaProduct', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSaProduct};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from sa_product
        where
            id = ?
    ';
    return ('deleteSaProduct', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeySaProduct};
    my $softwareId;
    $sth->bind_columns(
        \$softwareId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareId($softwareId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_id
        from
            sa_product
        where
            id = ?
     with ur';
    return ('getByIdKeySaProduct', $query);
}

1;
