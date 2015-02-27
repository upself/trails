package SWASSET::OM::ManualComputer;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_computerSysId => undef
        ,_computerScantime => undef
        ,_tmeObjectId => undef
        ,_tmeObjectLabel => undef
        ,_processorCount => undef
        ,_recordTime => undef
        ,_table => 'manual_computer'
        ,_idField => 'computer_sys_id'
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
    if (defined $self->computerScantime && defined $object->computerScantime) {
        $equal = 1 if $self->computerScantime eq $object->computerScantime;
    }
    $equal = 1 if (!defined $self->computerScantime && !defined $object->computerScantime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tmeObjectId && defined $object->tmeObjectId) {
        $equal = 1 if $self->tmeObjectId eq $object->tmeObjectId;
    }
    $equal = 1 if (!defined $self->tmeObjectId && !defined $object->tmeObjectId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tmeObjectLabel && defined $object->tmeObjectLabel) {
        $equal = 1 if $self->tmeObjectLabel eq $object->tmeObjectLabel;
    }
    $equal = 1 if (!defined $self->tmeObjectLabel && !defined $object->tmeObjectLabel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
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

sub computerSysId {
    my $self = shift;
    $self->{_computerSysId} = shift if scalar @_ == 1;
    return $self->{_computerSysId};
}

sub computerScantime {
    my $self = shift;
    $self->{_computerScantime} = shift if scalar @_ == 1;
    return $self->{_computerScantime};
}

sub tmeObjectId {
    my $self = shift;
    $self->{_tmeObjectId} = shift if scalar @_ == 1;
    return $self->{_tmeObjectId};
}

sub tmeObjectLabel {
    my $self = shift;
    $self->{_tmeObjectLabel} = shift if scalar @_ == 1;
    return $self->{_tmeObjectLabel};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
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
    my $s = "[ManualComputer] ";
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
    $s .= "computerScantime=";
    if (defined $self->{_computerScantime}) {
        $s .= $self->{_computerScantime};
    }
    $s .= ",";
    $s .= "tmeObjectId=";
    if (defined $self->{_tmeObjectId}) {
        $s .= $self->{_tmeObjectId};
    }
    $s .= ",";
    $s .= "tmeObjectLabel=";
    if (defined $self->{_tmeObjectLabel}) {
        $s .= $self->{_tmeObjectLabel};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
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
        my $sth = $connection->sql->{insertManualComputer};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->computerSysId
            ,$self->computerScantime
            ,$self->tmeObjectId
            ,$self->tmeObjectLabel
            ,$self->processorCount
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateManualComputer};
        $sth->execute(
            $self->computerScantime
            ,$self->tmeObjectId
            ,$self->tmeObjectLabel
            ,$self->processorCount
            ,$self->computerSysId
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
        from
            final table (
        insert into manual_computer (
            computer_sys_id
            ,computer_scantime
            ,tme_object_id
            ,tme_object_label
            ,processor_count
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertManualComputer', $query);
}

sub queryUpdate {
    my $query = '
        update manual_computer
        set
            computer_scantime = ?
            ,tme_object_id = ?
            ,tme_object_label = ?
            ,processor_count = ?
            ,record_time = CURRENT TIMESTAMP
        where
            computer_sys_id = ?
    ';
    return ('updateManualComputer', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteManualComputer};
        $sth->execute(
            $self->computerSysId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from manual_computer
        where
            computer_sys_id = ?
    ';
    return ('deleteManualComputer', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyManualComputer};
    my $id;
    my $computerScantime;
    my $tmeObjectId;
    my $tmeObjectLabel;
    my $processorCount;
    my $recordTime;
    $sth->bind_columns(
        \$id
        ,\$computerScantime
        ,\$tmeObjectId
        ,\$tmeObjectLabel
        ,\$processorCount
        ,\$recordTime
    );
    $sth->execute(
        $self->computerSysId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->computerScantime($computerScantime);
    $self->tmeObjectId($tmeObjectId);
    $self->tmeObjectLabel($tmeObjectLabel);
    $self->processorCount($processorCount);
    $self->recordTime($recordTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            ,computer_scantime
            ,tme_object_id
            ,tme_object_label
            ,processor_count
            ,record_time
        from
            manual_computer
        where
            computer_sys_id = ?
     with ur';
    return ('getByBizKeyManualComputer', $query);
}

1;
