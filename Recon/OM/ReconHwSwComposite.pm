package Recon::OM::ReconHwSwComposite;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_hwSwCompositeId => undef
        ,_customerId => undef
        ,_action => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'recon_hs_composite'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->hwSwCompositeId && defined $object->hwSwCompositeId) {
        $equal = 1 if $self->hwSwCompositeId eq $object->hwSwCompositeId;
    }
    $equal = 1 if (!defined $self->hwSwCompositeId && !defined $object->hwSwCompositeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->action && defined $object->action) {
        $equal = 1 if $self->action eq $object->action;
    }
    $equal = 1 if (!defined $self->action && !defined $object->action);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->table && defined $object->table) {
        $equal = 1 if $self->table eq $object->table;
    }
    $equal = 1 if (!defined $self->table && !defined $object->table);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->idField && defined $object->idField) {
        $equal = 1 if $self->idField eq $object->idField;
    }
    $equal = 1 if (!defined $self->idField && !defined $object->idField);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub hwSwCompositeId {
    my $self = shift;
    $self->{_hwSwCompositeId} = shift if scalar @_ == 1;
    return $self->{_hwSwCompositeId};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
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
    my $s = "[ReconHwSwComposite] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "hwSwCompositeId=";
    if (defined $self->{_hwSwCompositeId}) {
        $s .= $self->{_hwSwCompositeId};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
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
        my $sth = $connection->sql->{insertReconHwSwComposite};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->hwSwCompositeId
            ,$self->customerId
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateReconHwSwComposite};
        $sth->execute(
            $self->hwSwCompositeId
            ,$self->customerId
            ,$self->action
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
        insert into recon_hs_composite (
            hw_sw_composite_id
            ,customer_id
            ,action
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertReconHwSwComposite', $query);
}

sub queryUpdate {
    my $query = '
        update recon_hs_composite
        set
            hw_sw_composite_id = ?
            ,customer_id = ?
            ,action = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateReconHwSwComposite', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteReconHwSwComposite};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from recon_hs_composite hsc1
        where exists ( select hsc2.customer_id, hsc2.hw_sw_composite_id, hsc2.action from recon_hs_composite hsc2 where hsc2.id = ?
         and hsc2.customer_id = hsc1.customer_id and hsc2.hw_sw_composite_id = hsc1.hw_sw_composite_id and hsc2.action = hsc1.action )
    ';
    return ('deleteReconHwSwComposite', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconHwSwComposite};
    my $id;
    my $customerId;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$customerId
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->hwSwCompositeId
        ,$self->action
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->customerId($customerId);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,customer_id
            ,remote_user
            ,record_time
        from
            recon_hs_composite
        where
            hw_sw_composite_id = ?
            and action = ?
    ';
    return ('getByBizKeyReconHwSwComposite', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconHwSwComposite};
    my $hwSwCompositeId;
    my $customerId;
    my $action;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$hwSwCompositeId
        ,\$customerId
        ,\$action
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->hwSwCompositeId($hwSwCompositeId);
    $self->customerId($customerId);
    $self->action($action);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            hw_sw_composite_id
            ,customer_id
            ,action
            ,remote_user
            ,record_time
        from
            recon_hs_composite
        where
            id = ?
    ';
    return ('getByIdKeyReconHwSwComposite', $query);
}

1;
