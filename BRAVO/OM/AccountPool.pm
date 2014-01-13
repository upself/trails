package BRAVO::OM::AccountPool;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_accountPoolId => undef
        ,_logicalDeleteInd => undef
        ,_masterAccountId => undef
        ,_memberAccountId => undef
        ,_action => undef
        ,_table => 'account_pool'
        ,_idField => 'account_pool_id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->logicalDeleteInd && defined $object->logicalDeleteInd) {
        $equal = 1 if $self->logicalDeleteInd eq $object->logicalDeleteInd;
    }
    $equal = 1 if (!defined $self->logicalDeleteInd && !defined $object->logicalDeleteInd);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->masterAccountId && defined $object->masterAccountId) {
        $equal = 1 if $self->masterAccountId eq $object->masterAccountId;
    }
    $equal = 1 if (!defined $self->masterAccountId && !defined $object->masterAccountId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->memberAccountId && defined $object->memberAccountId) {
        $equal = 1 if $self->memberAccountId eq $object->memberAccountId;
    }
    $equal = 1 if (!defined $self->memberAccountId && !defined $object->memberAccountId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub accountPoolId {
    my $self = shift;
    $self->{_accountPoolId} = shift if scalar @_ == 1;
    return $self->{_accountPoolId};
}

sub logicalDeleteInd {
    my $self = shift;
    $self->{_logicalDeleteInd} = shift if scalar @_ == 1;
    return $self->{_logicalDeleteInd};
}

sub masterAccountId {
    my $self = shift;
    $self->{_masterAccountId} = shift if scalar @_ == 1;
    return $self->{_masterAccountId};
}

sub memberAccountId {
    my $self = shift;
    $self->{_memberAccountId} = shift if scalar @_ == 1;
    return $self->{_memberAccountId};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
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
    my $s = "[AccountPool] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "accountPoolId=";
    if (defined $self->{_accountPoolId}) {
        $s .= $self->{_accountPoolId};
    }
    $s .= ",";
    $s .= "logicalDeleteInd=";
    if (defined $self->{_logicalDeleteInd}) {
        $s .= $self->{_logicalDeleteInd};
    }
    $s .= ",";
    $s .= "masterAccountId=";
    if (defined $self->{_masterAccountId}) {
        $s .= $self->{_masterAccountId};
    }
    $s .= ",";
    $s .= "memberAccountId=";
    if (defined $self->{_memberAccountId}) {
        $s .= $self->{_memberAccountId};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
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
        my $sth = $connection->sql->{insertAccountPool};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->accountPoolId
            ,$self->logicalDeleteInd
            ,$self->masterAccountId
            ,$self->memberAccountId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateAccountPool};
        $sth->execute(
            $self->accountPoolId
            ,$self->logicalDeleteInd
            ,$self->masterAccountId
            ,$self->memberAccountId
            ,$self->id
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            account_pool_id
        from
            final table (
        insert into account_pool (
            account_pool_id
            ,logical_delete_ind
            ,master_account_id
            ,member_account_id
        ) values (
            ?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertAccountPool', $query);
}

sub queryUpdate {
    my $query = '
        update account_pool
        set
            account_pool_id = ?
            ,logical_delete_ind = ?
            ,master_account_id = ?
            ,member_account_id = ?
        where
            account_pool_id = ?
    ';
    return ('updateAccountPool', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteAccountPool};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from account_pool a where
            a.account_pool_id = ?
    ';
    return ('deleteAccountPool', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyAccountPool};
    my $id;
    my $logicalDeleteInd;
    my $masterAccountId;
    my $memberAccountId;
    $sth->bind_columns(
        \$id
        ,\$logicalDeleteInd
        ,\$masterAccountId
        ,\$memberAccountId
    );
    $sth->execute(
        $self->accountPoolId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->logicalDeleteInd($logicalDeleteInd);
    $self->masterAccountId($masterAccountId);
    $self->memberAccountId($memberAccountId);
}

sub queryGetByBizKey {
    my $query = '
        select
            account_pool_id
            ,logical_delete_ind
            ,master_account_id
            ,member_account_id
        from
            account_pool
        where
            account_pool_id = ?
    ';
    return ('getByBizKeyAccountPool', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyAccountPool};
    my $accountPoolId;
    my $logicalDeleteInd;
    my $masterAccountId;
    my $memberAccountId;
    $sth->bind_columns(
        \$accountPoolId
        ,\$logicalDeleteInd
        ,\$masterAccountId
        ,\$memberAccountId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->accountPoolId($accountPoolId);
    $self->logicalDeleteInd($logicalDeleteInd);
    $self->masterAccountId($masterAccountId);
    $self->memberAccountId($memberAccountId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            account_pool_id
            ,logical_delete_ind
            ,master_account_id
            ,member_account_id
        from
            account_pool
        where
            account_pool_id = ?
    ';
    return ('getByIdKeyAccountPool', $query);
}

1;
