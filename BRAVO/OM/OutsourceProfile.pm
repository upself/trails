package BRAVO::OM::OutsourceProfile;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_outsourceProfileId => undef
        ,_customerId => undef
        ,_assetProcessId => undef
        ,_countryId => undef
        ,_outsourceable => undef
        ,_comment => undef
        ,_approver => undef
        ,_recordTime => undef
        ,_current => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_action => undef
        ,_table => 'outsource_profile'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->outsourceProfileId && defined $object->outsourceProfileId) {
        $equal = 1 if $self->outsourceProfileId eq $object->outsourceProfileId;
    }
    $equal = 1 if (!defined $self->outsourceProfileId && !defined $object->outsourceProfileId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->assetProcessId && defined $object->assetProcessId) {
        $equal = 1 if $self->assetProcessId eq $object->assetProcessId;
    }
    $equal = 1 if (!defined $self->assetProcessId && !defined $object->assetProcessId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->countryId && defined $object->countryId) {
        $equal = 1 if $self->countryId eq $object->countryId;
    }
    $equal = 1 if (!defined $self->countryId && !defined $object->countryId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->outsourceable && defined $object->outsourceable) {
        $equal = 1 if $self->outsourceable eq $object->outsourceable;
    }
    $equal = 1 if (!defined $self->outsourceable && !defined $object->outsourceable);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comment && defined $object->comment) {
        $equal = 1 if $self->comment eq $object->comment;
    }
    $equal = 1 if (!defined $self->comment && !defined $object->comment);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->approver && defined $object->approver) {
        $equal = 1 if $self->approver eq $object->approver;
    }
    $equal = 1 if (!defined $self->approver && !defined $object->approver);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->recordTime && defined $object->recordTime) {
        $equal = 1 if $self->recordTime eq $object->recordTime;
    }
    $equal = 1 if (!defined $self->recordTime && !defined $object->recordTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->current && defined $object->current) {
        $equal = 1 if $self->current eq $object->current;
    }
    $equal = 1 if (!defined $self->current && !defined $object->current);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->creationDateTime && defined $object->creationDateTime) {
        $equal = 1 if $self->creationDateTime eq $object->creationDateTime;
    }
    $equal = 1 if (!defined $self->creationDateTime && !defined $object->creationDateTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->updateDateTime && defined $object->updateDateTime) {
        $equal = 1 if $self->updateDateTime eq $object->updateDateTime;
    }
    $equal = 1 if (!defined $self->updateDateTime && !defined $object->updateDateTime);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub outsourceProfileId {
    my $self = shift;
    $self->{_outsourceProfileId} = shift if scalar @_ == 1;
    return $self->{_outsourceProfileId};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub assetProcessId {
    my $self = shift;
    $self->{_assetProcessId} = shift if scalar @_ == 1;
    return $self->{_assetProcessId};
}

sub countryId {
    my $self = shift;
    $self->{_countryId} = shift if scalar @_ == 1;
    return $self->{_countryId};
}

sub outsourceable {
    my $self = shift;
    $self->{_outsourceable} = shift if scalar @_ == 1;
    return $self->{_outsourceable};
}

sub comment {
    my $self = shift;
    $self->{_comment} = shift if scalar @_ == 1;
    return $self->{_comment};
}

sub approver {
    my $self = shift;
    $self->{_approver} = shift if scalar @_ == 1;
    return $self->{_approver};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
}

sub current {
    my $self = shift;
    $self->{_current} = shift if scalar @_ == 1;
    return $self->{_current};
}

sub creationDateTime {
    my $self = shift;
    $self->{_creationDateTime} = shift if scalar @_ == 1;
    return $self->{_creationDateTime};
}

sub updateDateTime {
    my $self = shift;
    $self->{_updateDateTime} = shift if scalar @_ == 1;
    return $self->{_updateDateTime};
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
    my $s = "[OutsourceProfile] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "outsourceProfileId=";
    if (defined $self->{_outsourceProfileId}) {
        $s .= $self->{_outsourceProfileId};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "assetProcessId=";
    if (defined $self->{_assetProcessId}) {
        $s .= $self->{_assetProcessId};
    }
    $s .= ",";
    $s .= "countryId=";
    if (defined $self->{_countryId}) {
        $s .= $self->{_countryId};
    }
    $s .= ",";
    $s .= "outsourceable=";
    if (defined $self->{_outsourceable}) {
        $s .= $self->{_outsourceable};
    }
    $s .= ",";
    $s .= "comment=";
    if (defined $self->{_comment}) {
        $s .= $self->{_comment};
    }
    $s .= ",";
    $s .= "approver=";
    if (defined $self->{_approver}) {
        $s .= $self->{_approver};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
    }
    $s .= ",";
    $s .= "current=";
    if (defined $self->{_current}) {
        $s .= $self->{_current};
    }
    $s .= ",";
    $s .= "creationDateTime=";
    if (defined $self->{_creationDateTime}) {
        $s .= $self->{_creationDateTime};
    }
    $s .= ",";
    $s .= "updateDateTime=";
    if (defined $self->{_updateDateTime}) {
        $s .= $self->{_updateDateTime};
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
        my $sth = $connection->sql->{insertOutsourceProfile};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->outsourceProfileId
            ,$self->customerId
            ,$self->assetProcessId
            ,$self->countryId
            ,$self->outsourceable
            ,$self->comment
            ,$self->approver
            ,$self->current
            ,$self->creationDateTime
            ,$self->updateDateTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateOutsourceProfile};
        $sth->execute(
            $self->outsourceProfileId
            ,$self->customerId
            ,$self->assetProcessId
            ,$self->countryId
            ,$self->outsourceable
            ,$self->comment
            ,$self->approver
            ,$self->current
            ,$self->creationDateTime
            ,$self->updateDateTime
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
        insert into outsource_profile (
            id
            ,customer_id
            ,asset_process_id
            ,country_id
            ,outsourceable
            ,comment
            ,approver
            ,record_time
            ,current
            ,creation_date_time
            ,update_date_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,CURRENT TIMESTAMP
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertOutsourceProfile', $query);
}

sub queryUpdate {
    my $query = '
        update outsource_profile
        set
            id = ?
            ,customer_id = ?
            ,asset_process_id = ?
            ,country_id = ?
            ,outsourceable = ?
            ,comment = ?
            ,approver = ?
            ,record_time = CURRENT TIMESTAMP
            ,current = ?
            ,creation_date_time = ?
            ,update_date_time = ?
        where
            id = ?
    ';
    return ('updateOutsourceProfile', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteOutsourceProfile};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from outsource_profile
        where
            id = ?
    ';
    return ('deleteOutsourceProfile', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyOutsourceProfile};
    my $id;
    my $customerId;
    my $assetProcessId;
    my $countryId;
    my $outsourceable;
    my $comment;
    my $approver;
    my $recordTime;
    my $current;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$id
        ,\$customerId
        ,\$assetProcessId
        ,\$countryId
        ,\$outsourceable
        ,\$comment
        ,\$approver
        ,\$recordTime
        ,\$current
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->outsourceProfileId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->customerId($customerId);
    $self->assetProcessId($assetProcessId);
    $self->countryId($countryId);
    $self->outsourceable($outsourceable);
    $self->comment($comment);
    $self->approver($approver);
    $self->recordTime($recordTime);
    $self->current($current);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,customer_id
            ,asset_process_id
            ,country_id
            ,outsourceable
            ,comment
            ,approver
            ,record_time
            ,current
            ,creation_date_time
            ,update_date_time
        from
            outsource_profile
        where
            id = ?
    ';
    return ('getByBizKeyOutsourceProfile', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyOutsourceProfile};
    my $outsourceProfileId;
    my $customerId;
    my $assetProcessId;
    my $countryId;
    my $outsourceable;
    my $comment;
    my $approver;
    my $recordTime;
    my $current;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$outsourceProfileId
        ,\$customerId
        ,\$assetProcessId
        ,\$countryId
        ,\$outsourceable
        ,\$comment
        ,\$approver
        ,\$recordTime
        ,\$current
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->outsourceProfileId($outsourceProfileId);
    $self->customerId($customerId);
    $self->assetProcessId($assetProcessId);
    $self->countryId($countryId);
    $self->outsourceable($outsourceable);
    $self->comment($comment);
    $self->approver($approver);
    $self->recordTime($recordTime);
    $self->current($current);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            id
            ,customer_id
            ,asset_process_id
            ,country_id
            ,outsourceable
            ,comment
            ,approver
            ,record_time
            ,current
            ,creation_date_time
            ,update_date_time
        from
            outsource_profile
        where
            id = ?
    ';
    return ('getByIdKeyOutsourceProfile', $query);
}

1;
