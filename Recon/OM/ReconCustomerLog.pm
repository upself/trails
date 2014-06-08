package Recon::OM::ReconCustomerLog;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_customerId => undef
        ,_hwCount => undef
        ,_hwAvg => undef
        ,_hwLparCount => undef
        ,_hwLparAvg => undef
        ,_swLparCount => undef
        ,_swLparAvg => undef
        ,_licCount => undef
        ,_licAvg => undef
        ,_duration => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_table => 'recon_customer_log'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwCount && defined $object->hwCount) {
        $equal = 1 if $self->hwCount eq $object->hwCount;
    }
    $equal = 1 if (!defined $self->hwCount && !defined $object->hwCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwAvg && defined $object->hwAvg) {
        $equal = 1 if $self->hwAvg eq $object->hwAvg;
    }
    $equal = 1 if (!defined $self->hwAvg && !defined $object->hwAvg);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwLparCount && defined $object->hwLparCount) {
        $equal = 1 if $self->hwLparCount eq $object->hwLparCount;
    }
    $equal = 1 if (!defined $self->hwLparCount && !defined $object->hwLparCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwLparAvg && defined $object->hwLparAvg) {
        $equal = 1 if $self->hwLparAvg eq $object->hwLparAvg;
    }
    $equal = 1 if (!defined $self->hwLparAvg && !defined $object->hwLparAvg);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swLparCount && defined $object->swLparCount) {
        $equal = 1 if $self->swLparCount eq $object->swLparCount;
    }
    $equal = 1 if (!defined $self->swLparCount && !defined $object->swLparCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swLparAvg && defined $object->swLparAvg) {
        $equal = 1 if $self->swLparAvg eq $object->swLparAvg;
    }
    $equal = 1 if (!defined $self->swLparAvg && !defined $object->swLparAvg);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->licCount && defined $object->licCount) {
        $equal = 1 if $self->licCount eq $object->licCount;
    }
    $equal = 1 if (!defined $self->licCount && !defined $object->licCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->licAvg && defined $object->licAvg) {
        $equal = 1 if $self->licAvg eq $object->licAvg;
    }
    $equal = 1 if (!defined $self->licAvg && !defined $object->licAvg);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->duration && defined $object->duration) {
        $equal = 1 if $self->duration eq $object->duration;
    }
    $equal = 1 if (!defined $self->duration && !defined $object->duration);
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

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub hwCount {
    my $self = shift;
    $self->{_hwCount} = shift if scalar @_ == 1;
    return $self->{_hwCount};
}

sub hwAvg {
    my $self = shift;
    $self->{_hwAvg} = shift if scalar @_ == 1;
    return $self->{_hwAvg};
}

sub hwLparCount {
    my $self = shift;
    $self->{_hwLparCount} = shift if scalar @_ == 1;
    return $self->{_hwLparCount};
}

sub hwLparAvg {
    my $self = shift;
    $self->{_hwLparAvg} = shift if scalar @_ == 1;
    return $self->{_hwLparAvg};
}

sub swLparCount {
    my $self = shift;
    $self->{_swLparCount} = shift if scalar @_ == 1;
    return $self->{_swLparCount};
}

sub swLparAvg {
    my $self = shift;
    $self->{_swLparAvg} = shift if scalar @_ == 1;
    return $self->{_swLparAvg};
}

sub licCount {
    my $self = shift;
    $self->{_licCount} = shift if scalar @_ == 1;
    return $self->{_licCount};
}

sub licAvg {
    my $self = shift;
    $self->{_licAvg} = shift if scalar @_ == 1;
    return $self->{_licAvg};
}

sub duration {
    my $self = shift;
    $self->{_duration} = shift if scalar @_ == 1;
    return $self->{_duration};
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
    my $s = "[ReconCustomerLog] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "hwCount=";
    if (defined $self->{_hwCount}) {
        $s .= $self->{_hwCount};
    }
    $s .= ",";
    $s .= "hwAvg=";
    if (defined $self->{_hwAvg}) {
        $s .= $self->{_hwAvg};
    }
    $s .= ",";
    $s .= "hwLparCount=";
    if (defined $self->{_hwLparCount}) {
        $s .= $self->{_hwLparCount};
    }
    $s .= ",";
    $s .= "hwLparAvg=";
    if (defined $self->{_hwLparAvg}) {
        $s .= $self->{_hwLparAvg};
    }
    $s .= ",";
    $s .= "swLparCount=";
    if (defined $self->{_swLparCount}) {
        $s .= $self->{_swLparCount};
    }
    $s .= ",";
    $s .= "swLparAvg=";
    if (defined $self->{_swLparAvg}) {
        $s .= $self->{_swLparAvg};
    }
    $s .= ",";
    $s .= "licCount=";
    if (defined $self->{_licCount}) {
        $s .= $self->{_licCount};
    }
    $s .= ",";
    $s .= "licAvg=";
    if (defined $self->{_licAvg}) {
        $s .= $self->{_licAvg};
    }
    $s .= ",";
    $s .= "duration=";
    if (defined $self->{_duration}) {
        $s .= $self->{_duration};
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
        my $sth = $connection->sql->{insertReconCustomerLog};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->customerId
            ,$self->hwCount
            ,$self->hwAvg
            ,$self->hwLparCount
            ,$self->hwLparAvg
            ,$self->swLparCount
            ,$self->swLparAvg
            ,$self->licCount
            ,$self->licAvg
            ,$self->duration
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateReconCustomerLog};
        $sth->execute(
            $self->customerId
            ,$self->hwCount
            ,$self->hwAvg
            ,$self->hwLparCount
            ,$self->hwLparAvg
            ,$self->swLparCount
            ,$self->swLparAvg
            ,$self->licCount
            ,$self->licAvg
            ,$self->duration
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
        insert into recon_customer_log (
            customer_id
            ,hw_count
            ,hw_avg
            ,hw_lpar_count
            ,hw_lpar_avg
            ,sw_lpar_count
            ,sw_lpar_avg
            ,lic_count
            ,lic_avg
            ,duration
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,\'STAGING\'
            ,CURRENT TIMESTAMP
        ))
    ';
    return ('insertReconCustomerLog', $query);
}

sub queryUpdate {
    my $query = '
        update recon_customer_log
        set
            customer_id = ?
            ,hw_count = ?
            ,hw_avg = ?
            ,hw_lpar_count = ?
            ,hw_lpar_avg = ?
            ,sw_lpar_count = ?
            ,sw_lpar_avg = ?
            ,lic_count = ?
            ,lic_avg = ?
            ,duration = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateReconCustomerLog', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteReconCustomerLog};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from recon_customer_log
        where
            id = ?
    ';
    return ('deleteReconCustomerLog', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyReconCustomerLog};
    my $customerId;
    my $hwCount;
    my $hwAvg;
    my $hwLparCount;
    my $hwLparAvg;
    my $swLparCount;
    my $swLparAvg;
    my $licCount;
    my $licAvg;
    my $duration;
    my $remoteUser;
    my $recordTime;
    $sth->bind_columns(
        \$customerId
        ,\$hwCount
        ,\$hwAvg
        ,\$hwLparCount
        ,\$hwLparAvg
        ,\$swLparCount
        ,\$swLparAvg
        ,\$licCount
        ,\$licAvg
        ,\$duration
        ,\$remoteUser
        ,\$recordTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->customerId($customerId);
    $self->hwCount($hwCount);
    $self->hwAvg($hwAvg);
    $self->hwLparCount($hwLparCount);
    $self->hwLparAvg($hwLparAvg);
    $self->swLparCount($swLparCount);
    $self->swLparAvg($swLparAvg);
    $self->licCount($licCount);
    $self->licAvg($licAvg);
    $self->duration($duration);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            customer_id
            ,hw_count
            ,hw_avg
            ,hw_lpar_count
            ,hw_lpar_avg
            ,sw_lpar_count
            ,sw_lpar_avg
            ,lic_count
            ,lic_avg
            ,duration
            ,remote_user
            ,record_time
        from
            recon_customer_log
        where
            id = ?
    ';
    return ('getByIdKeyReconCustomerLog', $query);
}

1;
