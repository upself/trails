package Recon::OM::AlertHardwareLparNew;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_idF => undef
        ,_hardwareLparId => undef
        ,_idField => 'id'
        ,_table => 'alert_hardware_lpar'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->hardwareLparId && defined $object->hardwareLparId) {
        $equal = 1 if $self->hardwareLparId eq $object->hardwareLparId;
    }
    $equal = 1 if (!defined $self->hardwareLparId && !defined $object->hardwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->idField && defined $object->idField) {
        $equal = 1 if $self->idField eq $object->idField;
    }
    $equal = 1 if (!defined $self->idField && !defined $object->idField);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->table && defined $object->table) {
        $equal = 1 if $self->table eq $object->table;
    }
    $equal = 1 if (!defined $self->table && !defined $object->table);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub idF {
    my $self = shift;
    $self->{_idF} = shift if scalar @_ == 1;
    return $self->{_idF};
}

sub hardwareLparId {
    my $self = shift;
    $self->{_hardwareLparId} = shift if scalar @_ == 1;
    return $self->{_hardwareLparId};
}

sub idField {
    my $self = shift;
    $self->{_idField} = shift if scalar @_ == 1;
    return $self->{_idField};
}

sub table {
    my $self = shift;
    $self->{_table} = shift if scalar @_ == 1;
    return $self->{_table};
}

sub toString {
    my ($self) = @_;
    my $s = "[AlertHardwareLparNew] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "idF=";
    if (defined $self->{_idF}) {
        $s .= $self->{_idF};
    }
    $s .= ",";
    $s .= "hardwareLparId=";
    if (defined $self->{_hardwareLparId}) {
        $s .= $self->{_hardwareLparId};
    }
    $s .= ",";
    $s .= "idField=";
    if (defined $self->{_idField}) {
        $s .= $self->{_idField};
    }
    $s .= ",";
    $s .= "table=";
    if (defined $self->{_table}) {
        $s .= $self->{_table};
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
        my $sth = $connection->sql->{insertAlertHardwareLparNew};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->idF
            ,$self->hardwareLparId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateAlertHardwareLparNew};
        $sth->execute(
            $self->idF
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
        insert into alert_hardware_lpar (
            id
            ,hardware_lpar_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertAlertHardwareLparNew', $query);
}

sub queryUpdate {
    my $query = '
        update alert_hardware_lpar
        set
            id = ?
            ,hardware_lpar_id = ?
        where
            id = ?
    ';
    return ('updateAlertHardwareLparNew', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteAlertHardwareLparNew};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from alert_hardware_lpar
        where
            id = ?
    ';
    return ('deleteAlertHardwareLparNew', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyAlertHardwareLparNew};
    my $id;
    my $idF;
    $sth->bind_columns(
        \$id
        ,\$idF
    );
    $sth->execute(
        $self->hardwareLparId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->idF($idF);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,id
        from
            alert_hardware_lpar
        where
            hardware_lpar_id = ?
    ';
    return ('getByBizKeyAlertHardwareLparNew', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyAlertHardwareLparNew};
    my $idF;
    my $hardwareLparId;
    $sth->bind_columns(
        \$idF
        ,\$hardwareLparId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->idF($idF);
    $self->hardwareLparId($hardwareLparId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            id
            ,hardware_lpar_id
        from
            alert_hardware_lpar
        where
            id = ?
    ';
    return ('getByIdKeyAlertHardwareLparNew', $query);
}

1;
