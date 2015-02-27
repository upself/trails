package BRAVO::OM::InstalledFilter;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_installedSoftwareId => undef
        ,_softwareFilterId => undef
        ,_bankAccountId => undef
        ,_status => undef
        ,_action => undef
        ,_remoteUser => undef
        ,_recordTime => undef
        ,_table => 'installed_filter'
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
    if (defined $self->softwareFilterId && defined $object->softwareFilterId) {
        $equal = 1 if $self->softwareFilterId eq $object->softwareFilterId;
    }
    $equal = 1 if (!defined $self->softwareFilterId && !defined $object->softwareFilterId);
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

sub softwareFilterId {
    my $self = shift;
    $self->{_softwareFilterId} = shift if scalar @_ == 1;
    return $self->{_softwareFilterId};
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
    my $s = "[InstalledFilter] ";
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
    $s .= "softwareFilterId=";
    if (defined $self->{_softwareFilterId}) {
        $s .= $self->{_softwareFilterId};
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
        my $sth = $connection->sql->{insertInstalledFilter};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->installedSoftwareId
            ,$self->softwareFilterId
            ,$self->bankAccountId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateInstalledFilter};
        $sth->execute(
            $self->installedSoftwareId
            ,$self->softwareFilterId
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
        insert into installed_filter (
            installed_software_id
            ,software_filter_id
            ,bank_account_id
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertInstalledFilter', $query);
}

sub queryUpdate {
    my $query = '
        update installed_filter
        set
            installed_software_id = ?
            ,software_filter_id = ?
            ,bank_account_id = ?
        where
            id = ?
    ';
    return ('updateInstalledFilter', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledFilter};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from installed_filter
        where
            id = ?
    ';
    return ('deleteInstalledFilter', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledFilter};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->installedSoftwareId
        ,$self->softwareFilterId
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
            installed_filter
        where
            installed_software_id = ?
            and software_filter_id = ?
            and bank_account_id = ?
     with ur';
    return ('getByBizKeyInstalledFilter', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyInstalledFilter};
    my $installedSoftwareId;
    my $softwareFilterId;
    my $bankAccountId;
    $sth->bind_columns(
        \$installedSoftwareId
        ,\$softwareFilterId
        ,\$bankAccountId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->installedSoftwareId($installedSoftwareId);
    $self->softwareFilterId($softwareFilterId);
    $self->bankAccountId($bankAccountId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            installed_software_id
            ,software_filter_id
            ,bank_account_id
        from
            installed_filter
        where
            id = ?
     with ur';
    return ('getByIdKeyInstalledFilter', $query);
}

1;
