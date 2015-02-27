package Recon::OM::ReconcileType;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_name => undef
        ,_isManual => undef
        ,_table => 'reconcile_type'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->isManual && defined $object->isManual) {
        $equal = 1 if $self->isManual eq $object->isManual;
    }
    $equal = 1 if (!defined $self->isManual && !defined $object->isManual);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub isManual {
    my $self = shift;
    $self->{_isManual} = shift if scalar @_ == 1;
    return $self->{_isManual};
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
    my $s = "[ReconcileType] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "isManual=";
    if (defined $self->{_isManual}) {
        $s .= $self->{_isManual};
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


sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconcileType};
    my $id;
    my $isManual;
    $sth->bind_columns(
        \$id
        ,\$isManual
    );
    $sth->execute(
        $self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->isManual($isManual);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,is_manual
        from
            reconcile_type
        where
            name = ?
     with ur';
    return ('getByBizKeyReconcileType', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconcileType};
    my $name;
    my $isManual;
    $sth->bind_columns(
        \$name
        ,\$isManual
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->name($name);
    $self->isManual($isManual);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            name
            ,is_manual
        from
            reconcile_type
        where
            id = ?
     with ur';
    return ('getByIdKeyReconcileType', $query);
}

1;
