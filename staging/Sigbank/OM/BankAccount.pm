package Sigbank::OM::BankAccount;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_name => undef
        ,_description => undef
        ,_type => undef
        ,_version => undef
        ,_connectionType => undef
        ,_connectionStatus => undef
        ,_dataType => undef
        ,_databaseType => undef
        ,_databaseVersion => undef
        ,_databaseName => undef
        ,_databaseSchema => undef
        ,_databaseIp => undef
        ,_databasePort => undef
        ,_databaseUser => undef
        ,_databasePassword => undef
        ,_socks => undef
        ,_tunnel => undef
        ,_tunnelPort => undef
        ,_authenticatedData => undef
        ,_syncSig => undef
        ,_comments => undef
        ,_remoteUser => 'STAGING'
        ,_recordTime => undef
        ,_status => undef
        ,_table => 'bank_account'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->description && defined $object->description) {
        $equal = 1 if $self->description eq $object->description;
    }
    $equal = 1 if (!defined $self->description && !defined $object->description);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->type && defined $object->type) {
        $equal = 1 if $self->type eq $object->type;
    }
    $equal = 1 if (!defined $self->type && !defined $object->type);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->version && defined $object->version) {
        $equal = 1 if $self->version eq $object->version;
    }
    $equal = 1 if (!defined $self->version && !defined $object->version);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->connectionType && defined $object->connectionType) {
        $equal = 1 if $self->connectionType eq $object->connectionType;
    }
    $equal = 1 if (!defined $self->connectionType && !defined $object->connectionType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->connectionStatus && defined $object->connectionStatus) {
        $equal = 1 if $self->connectionStatus eq $object->connectionStatus;
    }
    $equal = 1 if (!defined $self->connectionStatus && !defined $object->connectionStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->dataType && defined $object->dataType) {
        $equal = 1 if $self->dataType eq $object->dataType;
    }
    $equal = 1 if (!defined $self->dataType && !defined $object->dataType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databaseType && defined $object->databaseType) {
        $equal = 1 if $self->databaseType eq $object->databaseType;
    }
    $equal = 1 if (!defined $self->databaseType && !defined $object->databaseType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databaseVersion && defined $object->databaseVersion) {
        $equal = 1 if $self->databaseVersion eq $object->databaseVersion;
    }
    $equal = 1 if (!defined $self->databaseVersion && !defined $object->databaseVersion);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databaseName && defined $object->databaseName) {
        $equal = 1 if $self->databaseName eq $object->databaseName;
    }
    $equal = 1 if (!defined $self->databaseName && !defined $object->databaseName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databaseSchema && defined $object->databaseSchema) {
        $equal = 1 if $self->databaseSchema eq $object->databaseSchema;
    }
    $equal = 1 if (!defined $self->databaseSchema && !defined $object->databaseSchema);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databaseIp && defined $object->databaseIp) {
        $equal = 1 if $self->databaseIp eq $object->databaseIp;
    }
    $equal = 1 if (!defined $self->databaseIp && !defined $object->databaseIp);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databasePort && defined $object->databasePort) {
        $equal = 1 if $self->databasePort eq $object->databasePort;
    }
    $equal = 1 if (!defined $self->databasePort && !defined $object->databasePort);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databaseUser && defined $object->databaseUser) {
        $equal = 1 if $self->databaseUser eq $object->databaseUser;
    }
    $equal = 1 if (!defined $self->databaseUser && !defined $object->databaseUser);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->databasePassword && defined $object->databasePassword) {
        $equal = 1 if $self->databasePassword eq $object->databasePassword;
    }
    $equal = 1 if (!defined $self->databasePassword && !defined $object->databasePassword);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->socks && defined $object->socks) {
        $equal = 1 if $self->socks eq $object->socks;
    }
    $equal = 1 if (!defined $self->socks && !defined $object->socks);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tunnel && defined $object->tunnel) {
        $equal = 1 if $self->tunnel eq $object->tunnel;
    }
    $equal = 1 if (!defined $self->tunnel && !defined $object->tunnel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tunnelPort && defined $object->tunnelPort) {
        $equal = 1 if $self->tunnelPort eq $object->tunnelPort;
    }
    $equal = 1 if (!defined $self->tunnelPort && !defined $object->tunnelPort);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->authenticatedData && defined $object->authenticatedData) {
        $equal = 1 if $self->authenticatedData eq $object->authenticatedData;
    }
    $equal = 1 if (!defined $self->authenticatedData && !defined $object->authenticatedData);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->syncSig && defined $object->syncSig) {
        $equal = 1 if $self->syncSig eq $object->syncSig;
    }
    $equal = 1 if (!defined $self->syncSig && !defined $object->syncSig);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->comments && defined $object->comments) {
        $equal = 1 if $self->comments eq $object->comments;
    }
    $equal = 1 if (!defined $self->comments && !defined $object->comments);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->remoteUser && defined $object->remoteUser) {
        $equal = 1 if $self->remoteUser eq $object->remoteUser;
    }
    $equal = 1 if (!defined $self->remoteUser && !defined $object->remoteUser);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->recordTime && defined $object->recordTime) {
        $equal = 1 if $self->recordTime eq $object->recordTime;
    }
    $equal = 1 if (!defined $self->recordTime && !defined $object->recordTime);
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

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub description {
    my $self = shift;
    $self->{_description} = shift if scalar @_ == 1;
    return $self->{_description};
}

sub type {
    my $self = shift;
    $self->{_type} = shift if scalar @_ == 1;
    return $self->{_type};
}

sub version {
    my $self = shift;
    $self->{_version} = shift if scalar @_ == 1;
    return $self->{_version};
}

sub connectionType {
    my $self = shift;
    $self->{_connectionType} = shift if scalar @_ == 1;
    return $self->{_connectionType};
}

sub connectionStatus {
    my $self = shift;
    $self->{_connectionStatus} = shift if scalar @_ == 1;
    return $self->{_connectionStatus};
}

sub dataType {
    my $self = shift;
    $self->{_dataType} = shift if scalar @_ == 1;
    return $self->{_dataType};
}

sub databaseType {
    my $self = shift;
    $self->{_databaseType} = shift if scalar @_ == 1;
    return $self->{_databaseType};
}

sub databaseVersion {
    my $self = shift;
    $self->{_databaseVersion} = shift if scalar @_ == 1;
    return $self->{_databaseVersion};
}

sub databaseName {
    my $self = shift;
    $self->{_databaseName} = shift if scalar @_ == 1;
    return $self->{_databaseName};
}

sub databaseSchema {
    my $self = shift;
    $self->{_databaseSchema} = shift if scalar @_ == 1;
    return $self->{_databaseSchema};
}

sub databaseIp {
    my $self = shift;
    $self->{_databaseIp} = shift if scalar @_ == 1;
    return $self->{_databaseIp};
}

sub databasePort {
    my $self = shift;
    $self->{_databasePort} = shift if scalar @_ == 1;
    return $self->{_databasePort};
}

sub databaseUser {
    my $self = shift;
    $self->{_databaseUser} = shift if scalar @_ == 1;
    return $self->{_databaseUser};
}

sub databasePassword {
    my $self = shift;
    $self->{_databasePassword} = shift if scalar @_ == 1;
    return $self->{_databasePassword};
}

sub socks {
    my $self = shift;
    $self->{_socks} = shift if scalar @_ == 1;
    return $self->{_socks};
}

sub tunnel {
    my $self = shift;
    $self->{_tunnel} = shift if scalar @_ == 1;
    return $self->{_tunnel};
}

sub tunnelPort {
    my $self = shift;
    $self->{_tunnelPort} = shift if scalar @_ == 1;
    return $self->{_tunnelPort};
}

sub authenticatedData {
    my $self = shift;
    $self->{_authenticatedData} = shift if scalar @_ == 1;
    return $self->{_authenticatedData};
}

sub syncSig {
    my $self = shift;
    $self->{_syncSig} = shift if scalar @_ == 1;
    return $self->{_syncSig};
}

sub comments {
    my $self = shift;
    $self->{_comments} = shift if scalar @_ == 1;
    return $self->{_comments};
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

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
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
    my $s = "[BankAccount] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "description=";
    if (defined $self->{_description}) {
        $s .= $self->{_description};
    }
    $s .= ",";
    $s .= "type=";
    if (defined $self->{_type}) {
        $s .= $self->{_type};
    }
    $s .= ",";
    $s .= "version=";
    if (defined $self->{_version}) {
        $s .= $self->{_version};
    }
    $s .= ",";
    $s .= "connectionType=";
    if (defined $self->{_connectionType}) {
        $s .= $self->{_connectionType};
    }
    $s .= ",";
    $s .= "connectionStatus=";
    if (defined $self->{_connectionStatus}) {
        $s .= $self->{_connectionStatus};
    }
    $s .= ",";
    $s .= "dataType=";
    if (defined $self->{_dataType}) {
        $s .= $self->{_dataType};
    }
    $s .= ",";
    $s .= "databaseType=";
    if (defined $self->{_databaseType}) {
        $s .= $self->{_databaseType};
    }
    $s .= ",";
    $s .= "databaseVersion=";
    if (defined $self->{_databaseVersion}) {
        $s .= $self->{_databaseVersion};
    }
    $s .= ",";
    $s .= "databaseName=";
    if (defined $self->{_databaseName}) {
        $s .= $self->{_databaseName};
    }
    $s .= ",";
    $s .= "databaseSchema=";
    if (defined $self->{_databaseSchema}) {
        $s .= $self->{_databaseSchema};
    }
    $s .= ",";
    $s .= "databaseIp=";
    if (defined $self->{_databaseIp}) {
        $s .= $self->{_databaseIp};
    }
    $s .= ",";
    $s .= "databasePort=";
    if (defined $self->{_databasePort}) {
        $s .= $self->{_databasePort};
    }
    $s .= ",";
    $s .= "databaseUser=";
    if (defined $self->{_databaseUser}) {
        $s .= $self->{_databaseUser};
    }
    $s .= ",";
    $s .= "socks=";
    if (defined $self->{_socks}) {
        $s .= $self->{_socks};
    }
    $s .= ",";
    $s .= "tunnel=";
    if (defined $self->{_tunnel}) {
        $s .= $self->{_tunnel};
    }
    $s .= ",";
    $s .= "tunnelPort=";
    if (defined $self->{_tunnelPort}) {
        $s .= $self->{_tunnelPort};
    }
    $s .= ",";
    $s .= "authenticatedData=";
    if (defined $self->{_authenticatedData}) {
        $s .= $self->{_authenticatedData};
    }
    $s .= ",";
    $s .= "syncSig=";
    if (defined $self->{_syncSig}) {
        $s .= $self->{_syncSig};
    }
    $s .= ",";
    $s .= "comments=";
    if (defined $self->{_comments}) {
        $s .= $self->{_comments};
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
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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
        my $sth = $connection->sql->{insertBankAccount};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->name
            ,$self->description
            ,$self->type
            ,$self->version
            ,$self->connectionType
            ,$self->connectionStatus
            ,$self->dataType
            ,$self->databaseType
            ,$self->databaseVersion
            ,$self->databaseName
            ,$self->databaseSchema
            ,$self->databaseIp
            ,$self->databasePort
            ,$self->databaseUser
            ,$self->databasePassword
            ,$self->socks
            ,$self->tunnel
            ,$self->tunnelPort
            ,$self->authenticatedData
            ,$self->syncSig
            ,$self->comments
            ,$self->status
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateBankAccount};
        $sth->execute(
            $self->name
            ,$self->description
            ,$self->type
            ,$self->version
            ,$self->connectionType
            ,$self->connectionStatus
            ,$self->dataType
            ,$self->databaseType
            ,$self->databaseVersion
            ,$self->databaseName
            ,$self->databaseSchema
            ,$self->databaseIp
            ,$self->databasePort
            ,$self->databaseUser
            ,$self->databasePassword
            ,$self->socks
            ,$self->tunnel
            ,$self->tunnelPort
            ,$self->authenticatedData
            ,$self->syncSig
            ,$self->comments
            ,$self->status
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
        insert into bank_account (
            name
            ,description
            ,type
            ,version
            ,connection_type
            ,connection_status
            ,data_type
            ,database_type
            ,database_version
            ,database_name
            ,database_schema
            ,database_ip
            ,database_port
            ,database_user
            ,database_password
            ,socks
            ,tunnel
            ,tunnel_port
            ,authenticated_data
            ,sync_sig
            ,comments
            ,remote_user
            ,record_time
            ,status
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
            ,?
            ,?
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
            ,?
        ))
    ';
    return ('insertBankAccount', $query);
}

sub queryUpdate {
    my $query = '
        update bank_account
        set
            name = ?
            ,description = ?
            ,type = ?
            ,version = ?
            ,connection_type = ?
            ,connection_status = ?
            ,data_type = ?
            ,database_type = ?
            ,database_version = ?
            ,database_name = ?
            ,database_schema = ?
            ,database_ip = ?
            ,database_port = ?
            ,database_user = ?
            ,database_password = ?
            ,socks = ?
            ,tunnel = ?
            ,tunnel_port = ?
            ,authenticated_data = ?
            ,sync_sig = ?
            ,comments = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
            ,status = ?
        where
            id = ?
    ';
    return ('updateBankAccount', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteBankAccount};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from bank_account
        where
            id = ?
    ';
    return ('deleteBankAccount', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyBankAccount};
    my $id;
    my $description;
    my $type;
    my $version;
    my $connectionType;
    my $connectionStatus;
    my $dataType;
    my $databaseType;
    my $databaseVersion;
    my $databaseName;
    my $databaseSchema;
    my $databaseIp;
    my $databasePort;
    my $databaseUser;
    my $databasePassword;
    my $socks;
    my $tunnel;
    my $tunnelPort;
    my $authenticatedData;
    my $syncSig;
    my $comments;
    my $remoteUser;
    my $recordTime;
    my $status;
    $sth->bind_columns(
        \$id
        ,\$description
        ,\$type
        ,\$version
        ,\$connectionType
        ,\$connectionStatus
        ,\$dataType
        ,\$databaseType
        ,\$databaseVersion
        ,\$databaseName
        ,\$databaseSchema
        ,\$databaseIp
        ,\$databasePort
        ,\$databaseUser
        ,\$databasePassword
        ,\$socks
        ,\$tunnel
        ,\$tunnelPort
        ,\$authenticatedData
        ,\$syncSig
        ,\$comments
        ,\$remoteUser
        ,\$recordTime
        ,\$status
    );
    $sth->execute(
        $self->name
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->description($description);
    $self->type($type);
    $self->version($version);
    $self->connectionType($connectionType);
    $self->connectionStatus($connectionStatus);
    $self->dataType($dataType);
    $self->databaseType($databaseType);
    $self->databaseVersion($databaseVersion);
    $self->databaseName($databaseName);
    $self->databaseSchema($databaseSchema);
    $self->databaseIp($databaseIp);
    $self->databasePort($databasePort);
    $self->databaseUser($databaseUser);
    $self->databasePassword($databasePassword);
    $self->socks($socks);
    $self->tunnel($tunnel);
    $self->tunnelPort($tunnelPort);
    $self->authenticatedData($authenticatedData);
    $self->syncSig($syncSig);
    $self->comments($comments);
    $self->remoteUser($remoteUser);
    $self->recordTime($recordTime);
    $self->status($status);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,description
            ,type
            ,version
            ,connection_type
            ,connection_status
            ,data_type
            ,database_type
            ,database_version
            ,database_name
            ,database_schema
            ,database_ip
            ,database_port
            ,database_user
            ,database_password
            ,socks
            ,tunnel
            ,tunnel_port
            ,authenticated_data
            ,sync_sig
            ,comments
            ,remote_user
            ,record_time
            ,status
        from
            bank_account
        where
            name = ?
     with ur';
    return ('getByBizKeyBankAccount', $query);
}

1;
