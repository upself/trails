package BRAVO::OM::InstalledDorana;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_installedSoftwareId => undef
        ,_doranaProductId => undef
        ,_bankAccountId => undef
        ,_status => undef
        ,_action => undef
        ,_remoteUser => undef
        ,_recordTime => undef
        ,_table => 'installed_dorana_product'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->installedSoftwareId && defined $object->installedSoftwareId) {
        $equal = 1 if $self->installedSoftwareId eq $object->installedSoftwareId;
    }
    $equal = 1 if (!defined $self->installedSoftwareId && !defined $object->installedSoftwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->doranaProductId && defined $object->doranaProductId) {
        $equal = 1 if $self->doranaProductId eq $object->doranaProductId;
    }
    $equal = 1 if (!defined $self->doranaProductId && !defined $object->doranaProductId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bankAccountId && defined $object->bankAccountId) {
        $equal = 1 if $self->bankAccountId eq $object->bankAccountId;
    }
    $equal = 1 if (!defined $self->bankAccountId && !defined $object->bankAccountId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->action && defined $object->action) {
        $equal = 1 if $self->action eq $object->action;
    }
    $equal = 1 if (!defined $self->action && !defined $object->action);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub installedSoftwareId {
    my $self = shift;
    $self->{_installedSoftwareId} = shift if scalar @_ == 1;
    return $self->{_installedSoftwareId};
}

sub doranaProductId {
    my $self = shift;
    $self->{_doranaProductId} = shift if scalar @_ == 1;
    return $self->{_doranaProductId};
}

sub bankAccountId {
    my $self = shift;
    $self->{_bankAccountId} = shift if scalar @_ == 1;
    return $self->{_bankAccountId};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub remoteUser {
    my $self = shift;
    $self->{_remoteUser} = shift if scalar @_ == 1;
    return $self->{_remoteUser};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
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
    my $s = "[InstalledDorana] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "installedSoftwareId=";
    if (defined $self->{_installedSoftwareId}) {
        $s .= $self->{_installedSoftwareId};
    }
    $s .= ",";
    $s .= "doranaProductId=";
    if (defined $self->{_doranaProductId}) {
        $s .= $self->{_doranaProductId};
    }
    $s .= ",";
    $s .= "bankAccountId=";
    if (defined $self->{_bankAccountId}) {
        $s .= $self->{_bankAccountId};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "remoteUser=";
    if (defined $self->{_remoteUser}) {
        $s .= $self->{_remoteUser};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
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
        my $sth = $connection->sql->{insertInstalledDorana};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->installedSoftwareId
            ,$self->doranaProductId
            ,$self->bankAccountId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateInstalledDorana};
        $sth->execute(
            $self->installedSoftwareId
            ,$self->doranaProductId
            ,$self->bankAccountId
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
        insert into installed_dorana_product (
            installed_software_id
            ,dorana_product_id
            ,bank_account_id
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertInstalledDorana', $query);
}

sub queryUpdate {
    my $query = '
        update installed_dorana_product
        set
            installed_software_id = ?
            ,dorana_product_id = ?
            ,bank_account_id = ?
        where
            id = ?
    ';
    return ('updateInstalledDorana', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledDorana};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from installed_dorana_product
        where
            id = ?
    ';
    return ('deleteInstalledDorana', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledDorana};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->installedSoftwareId
        ,$self->doranaProductId
        ,$self->bankAccountId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
        from
            installed_dorana_product
        where
            installed_software_id = ?
            and dorana_product_id = ?
            and bank_account_id = ?
     with ur';
    return ('getByBizKeyInstalledDorana', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyInstalledDorana};
    my $installedSoftwareId;
    my $doranaProductId;
    my $bankAccountId;
    $sth->bind_columns(
        \$installedSoftwareId
        ,\$doranaProductId
        ,\$bankAccountId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->installedSoftwareId($installedSoftwareId);
    $self->doranaProductId($doranaProductId);
    $self->bankAccountId($bankAccountId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            installed_software_id
            ,dorana_product_id
            ,bank_account_id
        from
            installed_dorana_product
        where
            id = ?
     with ur';
    return ('getByIdKeyInstalledDorana', $query);
}

1;
