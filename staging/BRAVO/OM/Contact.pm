package BRAVO::OM::Contact;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_contactId => undef
        ,_role => undef
        ,_serial => undef
        ,_fullName => undef
        ,_remoteUserHolder => undef
        ,_notesMail => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_action => undef
        ,_table => 'contact'
        ,_idField => 'contact_id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->contactId && defined $object->contactId) {
        $equal = 1 if $self->contactId eq $object->contactId;
    }
    $equal = 1 if (!defined $self->contactId && !defined $object->contactId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->role && defined $object->role) {
        $equal = 1 if $self->role eq $object->role;
    }
    $equal = 1 if (!defined $self->role && !defined $object->role);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serial && defined $object->serial) {
        $equal = 1 if $self->serial eq $object->serial;
    }
    $equal = 1 if (!defined $self->serial && !defined $object->serial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->fullName && defined $object->fullName) {
        $equal = 1 if $self->fullName eq $object->fullName;
    }
    $equal = 1 if (!defined $self->fullName && !defined $object->fullName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->remoteUserHolder && defined $object->remoteUserHolder) {
        $equal = 1 if $self->remoteUserHolder eq $object->remoteUserHolder;
    }
    $equal = 1 if (!defined $self->remoteUserHolder && !defined $object->remoteUserHolder);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->notesMail && defined $object->notesMail) {
        $equal = 1 if $self->notesMail eq $object->notesMail;
    }
    $equal = 1 if (!defined $self->notesMail && !defined $object->notesMail);
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

sub contactId {
    my $self = shift;
    $self->{_contactId} = shift if scalar @_ == 1;
    return $self->{_contactId};
}

sub role {
    my $self = shift;
    $self->{_role} = shift if scalar @_ == 1;
    return $self->{_role};
}

sub serial {
    my $self = shift;
    $self->{_serial} = shift if scalar @_ == 1;
    return $self->{_serial};
}

sub fullName {
    my $self = shift;
    $self->{_fullName} = shift if scalar @_ == 1;
    return $self->{_fullName};
}

sub remoteUserHolder {
    my $self = shift;
    $self->{_remoteUserHolder} = shift if scalar @_ == 1;
    return $self->{_remoteUserHolder};
}

sub notesMail {
    my $self = shift;
    $self->{_notesMail} = shift if scalar @_ == 1;
    return $self->{_notesMail};
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
    my $s = "[Contact] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "contactId=";
    if (defined $self->{_contactId}) {
        $s .= $self->{_contactId};
    }
    $s .= ",";
    $s .= "role=";
    if (defined $self->{_role}) {
        $s .= $self->{_role};
    }
    $s .= ",";
    $s .= "serial=";
    if (defined $self->{_serial}) {
        $s .= $self->{_serial};
    }
    $s .= ",";
    $s .= "fullName=";
    if (defined $self->{_fullName}) {
        $s .= $self->{_fullName};
    }
    $s .= ",";
    $s .= "remoteUserHolder=";
    if (defined $self->{_remoteUserHolder}) {
        $s .= $self->{_remoteUserHolder};
    }
    $s .= ",";
    $s .= "notesMail=";
    if (defined $self->{_notesMail}) {
        $s .= $self->{_notesMail};
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
        my $sth = $connection->sql->{insertContact};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->contactId
            ,$self->role
            ,$self->serial
            ,$self->fullName
            ,$self->remoteUserHolder
            ,$self->notesMail
            ,$self->creationDateTime
            ,$self->updateDateTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateContact};
        $sth->execute(
            $self->contactId
            ,$self->role
            ,$self->serial
            ,$self->fullName
            ,$self->remoteUserHolder
            ,$self->notesMail
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
            contact_id
        from
            final table (
        insert into contact (
            contact_id
            ,role
            ,serial
            ,full_name
            ,remote_user
            ,notes_mail
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
            ,?
        ))
    ';
    return ('insertContact', $query);
}

sub queryUpdate {
    my $query = '
        update contact
        set
            contact_id = ?
            ,role = ?
            ,serial = ?
            ,full_name = ?
            ,remote_user = ?
            ,notes_mail = ?
            ,creation_date_time = ?
            ,update_date_time = ?
        where
            contact_id = ?
    ';
    return ('updateContact', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteContact};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from contact
        where
            contact_id = ?
    ';
    return ('deleteContact', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyContact};
    my $id;
    my $role;
    my $serial;
    my $fullName;
    my $remoteUserHolder;
    my $notesMail;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$id
        ,\$role
        ,\$serial
        ,\$fullName
        ,\$remoteUserHolder
        ,\$notesMail
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->contactId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->role($role);
    $self->serial($serial);
    $self->fullName($fullName);
    $self->remoteUserHolder($remoteUserHolder);
    $self->notesMail($notesMail);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            contact_id
            ,role
            ,serial
            ,full_name
            ,remote_user
            ,notes_mail
            ,creation_date_time
            ,update_date_time
        from
            contact
        where
            contact_id = ?
     with ur';
    return ('getByBizKeyContact', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyContact};
    my $contactId;
    my $role;
    my $serial;
    my $fullName;
    my $remoteUserHolder;
    my $notesMail;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$contactId
        ,\$role
        ,\$serial
        ,\$fullName
        ,\$remoteUserHolder
        ,\$notesMail
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->contactId($contactId);
    $self->role($role);
    $self->serial($serial);
    $self->fullName($fullName);
    $self->remoteUserHolder($remoteUserHolder);
    $self->notesMail($notesMail);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            contact_id
            ,role
            ,serial
            ,full_name
            ,remote_user
            ,notes_mail
            ,creation_date_time
            ,update_date_time
        from
            contact
        where
            contact_id = ?
     with ur';
    return ('getByIdKeyContact', $query);
}

1;
