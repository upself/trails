package Recon::OM::ReconcileUsedLicenseHistory;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _reconcileId => undef
        ,_usedLicenseId => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->reconcileId && defined $object->reconcileId) {
        $equal = 1 if $self->reconcileId->equals($object->reconcileId);
    }
    $equal = 1 if (!defined $self->reconcileId && !defined $object->reconcileId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->usedLicenseId && defined $object->usedLicenseId) {
        $equal = 1 if $self->usedLicenseId eq $object->usedLicenseId;
    }
    $equal = 1 if (!defined $self->usedLicenseId && !defined $object->usedLicenseId);
    return 0 if $equal == 0;

    return 1;
}

sub reconcileId {
    my $self = shift;
    $self->{_reconcileId} = shift if scalar @_ == 1;
    return $self->{_reconcileId};
}

sub usedLicenseId {
    my $self = shift;
    $self->{_usedLicenseId} = shift if scalar @_ == 1;
    return $self->{_usedLicenseId};
}

sub toString {
    my ($self) = @_;
    my $s = "[ReconcileUsedLicenseHistory] ";
    $s .= "reconcileId=";
    if (defined $self->{_reconcileId}) {
        $s .= $self->{_reconcileId};
    }
    $s .= ",";
    $s .= "usedLicenseId=";
    if (defined $self->{_usedLicenseId}) {
        $s .= $self->{_usedLicenseId};
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
        my $sth = $connection->sql->{insertReconcileUsedLicenseHistory};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->reconcileId
            ,$self->usedLicenseId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateReconcileUsedLicenseHistory};
        $sth->execute(
            $self->usedLicenseId
            ,$self->reconcileId
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            rtrim(ltrim(cast(char(h_reconcile_id) as varchar(255))))
        from
            final table (
        insert into h_reconcile_used_license (
            h_reconcile_id
            ,h_used_license_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertReconcileUsedLicenseHistory', $query);
}

sub queryUpdate {
    my $query = '
        update h_reconcile_used_license
        set
            h_used_license_id = ?
        where
            h_reconcile_id = ?
    ';
    return ('updateReconcileUsedLicenseHistory', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteReconcileUsedLicenseHistory};
        $sth->execute(
            $self->reconcileId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from h_reconcile_used_license a where
            exists ( select b.id from h_reconcile_used_license b where b.h_reconcile_id = ?
            and a.h_used_license_id = b.h_used_license_id 
)    ';
    return ('deleteReconcileUsedLicenseHistory', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconcileUsedLicenseHistory};
    $sth->bind_columns(
    );
    $sth->execute(
        $self->reconcileId
        ,$self->usedLicenseId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
}

sub queryGetByBizKey {
    my $query = '
        select
        from
            h_reconcile_used_license
        where
            h_reconcile_id = ?
            and h_used_license_id = ?
    ';
    return ('getByBizKeyReconcileUsedLicenseHistory', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconcileUsedLicenseHistory};
    my $usedLicenseId;
    $sth->bind_columns(
        \$usedLicenseId
    );
    $sth->execute(
        $self->reconcileId
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->usedLicenseId($usedLicenseId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            h_used_license_id
        from
            h_reconcile_used_license
        where
            h_reconcile_id = ?
    ';
    return ('getByIdKeyReconcileUsedLicenseHistory', $query);
}

1;
