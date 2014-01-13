package Recon::OM::ReconSoftwareLpar;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_customerId => undef
        ,_action => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'recon_sw_lpar'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->softwareLparId && defined $object->softwareLparId) {
        $equal = 1 if $self->softwareLparId eq $object->softwareLparId;
    }
    $equal = 1 if (!defined $self->softwareLparId && !defined $object->softwareLparId);
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

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
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
    my $s = "[ReconSoftwareLpar] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "softwareLparId=";
    if (defined $self->{_softwareLparId}) {
        $s .= $self->{_softwareLparId};
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
        my $sth = $connection->sql->{insertReconSoftwareLpar};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLparId
            ,$self->customerId
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateReconSoftwareLpar};
        $sth->execute(
            $self->softwareLparId
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
        insert into recon_sw_lpar (
            software_lpar_id
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
    return ('insertReconSoftwareLpar', $query);
}

sub queryUpdate {
    my $query = '
        update recon_sw_lpar
        set
            software_lpar_id = ?
            ,customer_id = ?
            ,action = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateReconSoftwareLpar', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteReconSoftwareLpar};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from recon_sw_lpar a where
            exists ( select b.id from recon_sw_lpar b where b.id = ?
            and a.software_lpar_id = b.software_lpar_id 
            and a.customer_id = b.customer_id 
            and a.action = b.action 
)    ';
    return ('deleteReconSoftwareLpar', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconSoftwareLpar};
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
        $self->softwareLparId
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
            recon_sw_lpar
        where
            software_lpar_id = ?
            and action = ?
    ';
    return ('getByBizKeyReconSoftwareLpar', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconSoftwareLpar};
    my $softwareLparId;
    my $customerId;
    my $action;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$softwareLparId
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
    $self->softwareLparId($softwareLparId);
    $self->customerId($customerId);
    $self->action($action);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,customer_id
            ,action
            ,remote_user
            ,record_time
        from
            recon_sw_lpar
        where
            id = ?
    ';
    return ('getByIdKeyReconSoftwareLpar', $query);
}

1;
