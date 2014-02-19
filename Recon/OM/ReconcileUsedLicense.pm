package Recon::OM::ReconcileUsedLicense;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _reconcileId => undef
        ,_usedLicenseId => undef
        ,_id => undef
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

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub toString {
    my ($self) = @_;
    my $s = "[ReconcileUsedLicense] ";
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
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
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
        my $sth = $connection->sql->{insertReconcileUsedLicense};
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
        my $sth = $connection->sql->{updateReconcileUsedLicense};
        $sth->execute(
            $self->reconcileId
            ,$self->usedLicenseId
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            reconcile_id
        from
            final table (
        insert into reconcile_used_license (
            reconcile_id
            ,used_license_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertReconcileUsedLicense', $query);
}

sub queryUpdate {
    my $query = '
        update reconcile_used_license
        set
            reconcile_id = ?
            ,used_license_id = ?
        where
            reconcile_id = ?
    ';
    return ('updateReconcileUsedLicense', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconcileUsedLicense};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->reconcileId
        ,$self->usedLicenseId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            reconcile_id
        from
            reconcile_used_license
        where
            reconcile_id = ?
            and used_license_id = ?
    ';
    return ('getByBizKeyReconcileUsedLicense', $query);
}

1;
