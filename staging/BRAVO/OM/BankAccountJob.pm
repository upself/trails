package BRAVO::OM::BankAccountJob;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_bankAccountId => undef
        ,_name => undef
        ,_comments => undef
        ,_startTime => undef
        ,_endTime => undef
        ,_status => undef
        ,_firstErrorTime => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->bankAccountId && defined $object->bankAccountId) {
        $equal = 1 if $self->bankAccountId eq $object->bankAccountId;
    }
    $equal = 1 if (!defined $self->bankAccountId && !defined $object->bankAccountId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comments && defined $object->comments) {
        $equal = 1 if $self->comments eq $object->comments;
    }
    $equal = 1 if (!defined $self->comments && !defined $object->comments);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->startTime && defined $object->startTime) {
        $equal = 1 if $self->startTime eq $object->startTime;
    }
    $equal = 1 if (!defined $self->startTime && !defined $object->startTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->endTime && defined $object->endTime) {
        $equal = 1 if $self->endTime eq $object->endTime;
    }
    $equal = 1 if (!defined $self->endTime && !defined $object->endTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub bankAccountId {
    my $self = shift;
    $self->{_bankAccountId} = shift if scalar @_ == 1;
    return $self->{_bankAccountId};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub comments {
    my $self = shift;
    $self->{_comments} = shift if scalar @_ == 1;
    return $self->{_comments};
}

sub startTime {
    my $self = shift;
    $self->{_startTime} = shift if scalar @_ == 1;
    return $self->{_startTime};
}

sub endTime {
    my $self = shift;
    $self->{_endTime} = shift if scalar @_ == 1;
    return $self->{_endTime};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub firstErrorTime {
    my $self = shift;
    $self->{_firstErrorTime} = shift if scalar @_ == 1;
    return $self->{_firstErrorTime};
}

sub toString {
    my ($self) = @_;
    my $s = "[BankAccountJob] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "bankAccountId=";
    if (defined $self->{_bankAccountId}) {
        $s .= $self->{_bankAccountId};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "comments=";
    if (defined $self->{_comments}) {
        $s .= $self->{_comments};
    }
    $s .= ",";
    $s .= "startTime=";
    if (defined $self->{_startTime}) {
        $s .= $self->{_startTime};
    }
    $s .= ",";
    $s .= "endTime=";
    if (defined $self->{_endTime}) {
        $s .= $self->{_endTime};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "firstErrorTime=";
    if (defined $self->{_firstErrorTime}) {
        $s .= $self->{_firstErrorTime};
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
        my $sth = $connection->sql->{insertBankAccountJob};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->bankAccountId
            ,$self->name
            ,$self->comments
            ,$self->startTime
            ,$self->endTime
            ,$self->status
            ,$self->firstErrorTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateBankAccountJob};
        $sth->execute(
            $self->bankAccountId
            ,$self->name
            ,$self->comments
            ,$self->startTime
            ,$self->endTime
            ,$self->status
            ,$self->firstErrorTime
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
        insert into bank_account_job (
            bank_account_id
            ,name
            ,comments
            ,start_time
            ,end_time
            ,status
            ,first_error_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertBankAccountJob', $query);
}

sub queryUpdate {
    my $query = '
        update bank_account_job
        set
            bank_account_id = ?
            ,name = ?
            ,comments = ?
            ,start_time = ?
            ,end_time = ?
            ,status = ?
            ,first_error_time = ?
        where
            id = ?
    ';
    return ('updateBankAccountJob', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyBankAccountJob};
    my $id;
    my $comments;
    my $startTime;
    my $endTime;
    my $status;
    my $firstErrorTime;
    $sth->bind_columns(
        \$id
        ,\$comments
        ,\$startTime
        ,\$endTime
        ,\$status
        ,\$firstErrorTime
    );
    $sth->execute(
        $self->bankAccountId
        ,$self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->comments($comments);
    $self->startTime($startTime);
    $self->endTime($endTime);
    $self->status($status);
    $self->firstErrorTime($firstErrorTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,comments
            ,start_time
            ,end_time
            ,status
            ,first_error_time
        from
            bank_account_job
        where
            bank_account_id = ?
            and name = ?
     with ur';
    return ('getByBizKeyBankAccountJob', $query);
}

1;
