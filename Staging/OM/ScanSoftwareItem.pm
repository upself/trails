package Staging::OM::ScanSoftwareItem;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scanRecordId => undef
        ,_guid => undef
        ,_lastUsed => undef
        ,_useCount => undef
        ,_action => undef
        ,_table => 'scan_software_item'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->scanRecordId && defined $object->scanRecordId) {
        $equal = 1 if $self->scanRecordId eq $object->scanRecordId;
    }
    $equal = 1 if (!defined $self->scanRecordId && !defined $object->scanRecordId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->guid && defined $object->guid) {
        $equal = 1 if $self->guid eq $object->guid;
    }
    $equal = 1 if (!defined $self->guid && !defined $object->guid);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lastUsed && defined $object->lastUsed) {
        $equal = 1 if $self->lastUsed eq $object->lastUsed;
    }
    $equal = 1 if (!defined $self->lastUsed && !defined $object->lastUsed);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub scanRecordId {
    my $self = shift;
    $self->{_scanRecordId} = shift if scalar @_ == 1;
    return $self->{_scanRecordId};
}

sub guid {
    my $self = shift;
    $self->{_guid} = shift if scalar @_ == 1;
    return $self->{_guid};
}

sub lastUsed {
    my $self = shift;
    $self->{_lastUsed} = shift if scalar @_ == 1;
    return $self->{_lastUsed};
}

sub useCount {
    my $self = shift;
    $self->{_useCount} = shift if scalar @_ == 1;
    return $self->{_useCount};
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
    my $s = "[ScanSoftwareItem] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "scanRecordId=";
    if (defined $self->{_scanRecordId}) {
        $s .= $self->{_scanRecordId};
    }
    $s .= ",";
    $s .= "guid=";
    if (defined $self->{_guid}) {
        $s .= $self->{_guid};
    }
    $s .= ",";
    $s .= "lastUsed=";
    if (defined $self->{_lastUsed}) {
        $s .= $self->{_lastUsed};
    }
    $s .= ",";
    $s .= "useCount=";
    if (defined $self->{_useCount}) {
        $s .= $self->{_useCount};
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
        my $sth = $connection->sql->{insertScanSoftwareItem};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scanRecordId
            ,$self->guid
            ,$self->lastUsed
            ,$self->useCount
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateScanSoftwareItem};
        $sth->execute(
            $self->scanRecordId
            ,$self->guid
            ,$self->lastUsed
            ,$self->useCount
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
        insert into scan_software_item (
            scan_record_id
            ,guid
            ,last_used
            ,use_count
            ,action
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertScanSoftwareItem', $query);
}

sub queryUpdate {
    my $query = '
        update scan_software_item
        set
            scan_record_id = ?
            ,guid = ?
            ,last_used = ?
            ,use_count = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateScanSoftwareItem', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteScanSoftwareItem};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from scan_software_item
        where
            id = ?
    ';
    return ('deleteScanSoftwareItem', $query);
}

1;
