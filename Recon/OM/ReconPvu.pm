package Recon::OM::ReconPvu;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_processorBrand => undef
        ,_processorModel => undef
        ,_machineTypeId => undef
        ,_action => undef
        ,_remoteUser => 'TRAILS'
        ,_recordTime => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->processorBrand && defined $object->processorBrand) {
        $equal = 1 if $self->processorBrand eq $object->processorBrand;
    }
    $equal = 1 if (!defined $self->processorBrand && !defined $object->processorBrand);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorModel && defined $object->processorModel) {
        $equal = 1 if $self->processorModel eq $object->processorModel;
    }
    $equal = 1 if (!defined $self->processorModel && !defined $object->processorModel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->machineTypeId && defined $object->machineTypeId) {
        $equal = 1 if $self->machineTypeId eq $object->machineTypeId;
    }
    $equal = 1 if (!defined $self->machineTypeId && !defined $object->machineTypeId);
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

sub processorBrand {
    my $self = shift;
    $self->{_processorBrand} = shift if scalar @_ == 1;
    return $self->{_processorBrand};
}

sub processorModel {
    my $self = shift;
    $self->{_processorModel} = shift if scalar @_ == 1;
    return $self->{_processorModel};
}

sub machineTypeId {
    my $self = shift;
    $self->{_machineTypeId} = shift if scalar @_ == 1;
    return $self->{_machineTypeId};
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

sub toString {
    my ($self) = @_;
    my $s = "[ReconPvu] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "processorBrand=";
    if (defined $self->{_processorBrand}) {
        $s .= $self->{_processorBrand};
    }
    $s .= ",";
    $s .= "processorModel=";
    if (defined $self->{_processorModel}) {
        $s .= $self->{_processorModel};
    }
    $s .= ",";
    $s .= "machineTypeId=";
    if (defined $self->{_machineTypeId}) {
        $s .= $self->{_machineTypeId};
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
    chop $s;
    return $s;
}

sub save {
    my($self, $connection) = @_;
    ilog("saving: ".$self->toString());
    if( ! defined $self->id ) {
        $connection->prepareSqlQuery($self->queryInsert());
        my $sth = $connection->sql->{insertReconPvu};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->processorBrand
            ,$self->processorModel
            ,$self->machineTypeId
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateReconPvu};
        $sth->execute(
            $self->processorBrand
            ,$self->processorModel
            ,$self->machineTypeId
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
        insert into recon_pvu (
            processor_brand
            ,processor_model
            ,machine_type_id
            ,action
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,\'TRAILS\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertReconPvu', $query);
}

sub queryUpdate {
    my $query = '
        update recon_pvu
        set
            processor_brand = ?
            ,processor_model = ?
            ,machine_type_id = ?
            ,action = ?
            ,remote_user = \'TRAILS\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateReconPvu', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteReconPvu};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from recon_pvu a where
            a.id = ?
    ';
    return ('deleteReconPvu', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyReconPvu};
    my $id;
    my $processorModel;
    my $machineTypeId;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$processorModel
        ,\$machineTypeId
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->processorBrand
        ,$self->action
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->processorModel($processorModel);
    $self->machineTypeId($machineTypeId);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,processor_model
            ,machine_type_id
            ,remote_user
            ,record_time
        from
            recon_pvu
        where
            processor_brand = ?
            and action = ?
    ';
    return ('getByBizKeyReconPvu', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconPvu};
    my $processorBrand;
    my $processorModel;
    my $machineTypeId;
    my $action;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$processorBrand
        ,\$processorModel
        ,\$machineTypeId
        ,\$action
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->processorBrand($processorBrand);
    $self->processorModel($processorModel);
    $self->machineTypeId($machineTypeId);
    $self->action($action);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            processor_brand
            ,processor_model
            ,machine_type_id
            ,action
            ,remote_user
            ,record_time
        from
            recon_pvu
        where
            id = ?
    ';
    return ('getByIdKeyReconPvu', $query);
}

1;
