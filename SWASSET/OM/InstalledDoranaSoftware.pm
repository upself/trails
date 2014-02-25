package SWASSET::OM::InstalledDoranaSoftware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_computerSysId => undef
        ,_doranaProductId => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->computerSysId && defined $object->computerSysId) {
        $equal = 1 if $self->computerSysId eq $object->computerSysId;
    }
    $equal = 1 if (!defined $self->computerSysId && !defined $object->computerSysId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->doranaProductId && defined $object->doranaProductId) {
        $equal = 1 if $self->doranaProductId eq $object->doranaProductId;
    }
    $equal = 1 if (!defined $self->doranaProductId && !defined $object->doranaProductId);
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

sub doranaProductId {
    my $self = shift;
    $self->{_doranaProductId} = shift if scalar @_ == 1;
    return $self->{_doranaProductId};
}

sub toString {
    my ($self) = @_;
    my $s = "[InstalledDoranaSoftware] ";
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
    $s .= "doranaProductId=";
    if (defined $self->{_doranaProductId}) {
        $s .= $self->{_doranaProductId};
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
        my $sth = $connection->sql->{insertInstalledDoranaSoftware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->computerSysId
            ,$self->doranaProductId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
}

sub queryInsert {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            || \'|\' || rtrim(ltrim(cast(char(dorana_prod_id) as varchar(255))))
        from
            final table (
        insert into inst_dorana_sware (
            computer_sys_id
            ,dorana_prod_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertInstalledDoranaSoftware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledDoranaSoftware};
        $sth->execute(
            $self->computerSysId
            ,$self->doranaProductId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from inst_dorana_sware
        where
            computer_sys_id = ?
            and dorana_prod_id = ?
    ';
    return ('deleteInstalledDoranaSoftware', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledDoranaSoftware};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->computerSysId
        ,$self->doranaProductId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            || \'|\' || rtrim(ltrim(cast(char(dorana_prod_id) as varchar(255))))
        from
            inst_dorana_sware
        where
            computer_sys_id = ?
            and dorana_prod_id = ?
    ';
    return ('getByBizKeyInstalledDoranaSoftware', $query);
}

1;
