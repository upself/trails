package SWASSET::OM::InstalledTLCMZSoftware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_computerSysId => undef
        ,_tlcmzProductId => undef
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
    if (defined $self->tlcmzProductId && defined $object->tlcmzProductId) {
        $equal = 1 if $self->tlcmzProductId eq $object->tlcmzProductId;
    }
    $equal = 1 if (!defined $self->tlcmzProductId && !defined $object->tlcmzProductId);
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

sub tlcmzProductId {
    my $self = shift;
    $self->{_tlcmzProductId} = shift if scalar @_ == 1;
    return $self->{_tlcmzProductId};
}

sub toString {
    my ($self) = @_;
    my $s = "[InstalledTLCMZSoftware] ";
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
    $s .= "tlcmzProductId=";
    if (defined $self->{_tlcmzProductId}) {
        $s .= $self->{_tlcmzProductId};
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
        my $sth = $connection->sql->{insertInstalledTLCMZSoftware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->computerSysId
            ,$self->tlcmzProductId
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
            || \'|\' || rtrim(ltrim(cast(char(tlcmz_prod_id) as varchar(255))))
        from
            final table (
        insert into inst_tlcmz_sware (
            computer_sys_id
            ,tlcmz_prod_id
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertInstalledTLCMZSoftware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteInstalledTLCMZSoftware};
        $sth->execute(
            $self->computerSysId
            ,$self->tlcmzProductId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from inst_tlcmz_sware
        where
            computer_sys_id = ?
            and tlcmz_prod_id = ?
    ';
    return ('deleteInstalledTLCMZSoftware', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyInstalledTLCMZSoftware};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->computerSysId
        ,$self->tlcmzProductId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            || \'|\' || rtrim(ltrim(cast(char(tlcmz_prod_id) as varchar(255))))
        from
            inst_tlcmz_sware
        where
            computer_sys_id = ?
            and tlcmz_prod_id = ?
    ';
    return ('getByBizKeyInstalledTLCMZSoftware', $query);
}

1;
