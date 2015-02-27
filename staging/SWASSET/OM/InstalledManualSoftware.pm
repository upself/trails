package SWASSET::OM::InstalledManualSoftware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_computerSysId => undef
        ,_softwareId => undef
        ,_productVersion => undef
        ,_users => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->id && defined $object->id) {
        $equal = 1 if $self->id eq $object->id;
    }
    $equal = 1 if (!defined $self->id && !defined $object->id);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->computerSysId && defined $object->computerSysId) {
        $equal = 1 if $self->computerSysId eq $object->computerSysId;
    }
    $equal = 1 if (!defined $self->computerSysId && !defined $object->computerSysId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->productVersion && defined $object->productVersion) {
        $equal = 1 if $self->productVersion eq $object->productVersion;
    }
    $equal = 1 if (!defined $self->productVersion && !defined $object->productVersion);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->users && defined $object->users) {
        $equal = 1 if $self->users eq $object->users;
    }
    $equal = 1 if (!defined $self->users && !defined $object->users);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub computerSysId {
    my $self = shift;
    $self->{_computerSysId} = shift if scalar @_ == 1;
    return $self->{_computerSysId};
}

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
}

sub productVersion {
    my $self = shift;
    $self->{_productVersion} = shift if scalar @_ == 1;
    return $self->{_productVersion};
}

sub users {
    my $self = shift;
    $self->{_users} = shift if scalar @_ == 1;
    return $self->{_users};
}

sub toString {
    my ($self) = @_;
    my $s = "[InstalledManualSoftware] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "computerSysId=";
    if (defined $self->{_computerSysId}) {
        $s .= $self->{_computerSysId};
    }
    $s .= ",";
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
    }
    $s .= ",";
    $s .= "productVersion=";
    if (defined $self->{_productVersion}) {
        $s .= $self->{_productVersion};
    }
    $s .= ",";
    $s .= "users=";
    if (defined $self->{_users}) {
        $s .= $self->{_users};
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
        my $sth = $connection->sql->{insertInstalledManualSoftware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->computerSysId
            ,$self->softwareId
            ,$self->productVersion
            ,$self->users
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateInstalledManualSoftware};
        $sth->execute(
            $self->productVersion
            ,$self->users
            ,$self->computerSysId
            ,$self->softwareId
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            || \'|\' || rtrim(ltrim(cast(char(software_id) as varchar(255))))
        from
            final table (
        insert into inst_manual_sware (
            computer_sys_id
            ,software_id
            ,prod_version
            ,users
        ) values (
            ?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertInstalledManualSoftware', $query);
}

sub queryUpdate {
    my $query = '
        update inst_manual_sware
        set
            prod_version = ?
            ,users = ?
        where
            computer_sys_id = ?
            and software_id = ?
    ';
    return ('updateInstalledManualSoftware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledManualSoftware};
        $sth->execute(
            $self->computerSysId
            ,$self->softwareId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from inst_manual_sware
        where
            computer_sys_id = ?
            and software_id = ?
    ';
    return ('deleteInstalledManualSoftware', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledManualSoftware};
    my $id;
    my $productVersion;
    my $users;
    $sth->bind_columns(
        \$id
        ,\$productVersion
        ,\$users
    );
    $sth->execute(
        $self->computerSysId
        ,$self->softwareId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->productVersion($productVersion);
    $self->users($users);
}

sub queryGetByBizKey {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            || \'|\' || rtrim(ltrim(cast(char(software_id) as varchar(255))))
            ,prod_version
            ,users
        from
            inst_manual_sware
        where
            computer_sys_id = ?
            and software_id = ?
     with ur';
    return ('getByBizKeyInstalledManualSoftware', $query);
}

1;
