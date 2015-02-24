package SWASSET::OM::Computer;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_computerSysId => undef
        ,_computerAlias => undef
        ,_computerBootTime => undef
        ,_computerModel => undef
        ,_computerScantime => undef
        ,_functionKeys => undef
        ,_keyboardType => undef
        ,_onSavingsTime => undef
        ,_osInstDate => undef
        ,_osMajorVersion => undef
        ,_osMinorVersion => undef
        ,_osName => undef
        ,_osSubVersion => undef
        ,_osType => undef
        ,_recordTime => undef
        ,_registeredOrg => undef
        ,_registeredOwner => undef
        ,_sysSerNum => undef
        ,_timeDirection => undef
        ,_tmeObjectId => undef
        ,_tmeObjectLabel => undef
        ,_tzDaylightName => undef
        ,_tzLocale => undef
        ,_tzName => undef
        ,_tzSeconds => undef
        ,_table => 'computer'
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
    if (defined $self->computerAlias && defined $object->computerAlias) {
        $equal = 1 if $self->computerAlias eq $object->computerAlias;
    }
    $equal = 1 if (!defined $self->computerAlias && !defined $object->computerAlias);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->computerBootTime && defined $object->computerBootTime) {
        $equal = 1 if $self->computerBootTime eq $object->computerBootTime;
    }
    $equal = 1 if (!defined $self->computerBootTime && !defined $object->computerBootTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->computerModel && defined $object->computerModel) {
        $equal = 1 if $self->computerModel eq $object->computerModel;
    }
    $equal = 1 if (!defined $self->computerModel && !defined $object->computerModel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->computerScantime && defined $object->computerScantime) {
        $equal = 1 if $self->computerScantime eq $object->computerScantime;
    }
    $equal = 1 if (!defined $self->computerScantime && !defined $object->computerScantime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->functionKeys && defined $object->functionKeys) {
        $equal = 1 if $self->functionKeys eq $object->functionKeys;
    }
    $equal = 1 if (!defined $self->functionKeys && !defined $object->functionKeys);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->keyboardType && defined $object->keyboardType) {
        $equal = 1 if $self->keyboardType eq $object->keyboardType;
    }
    $equal = 1 if (!defined $self->keyboardType && !defined $object->keyboardType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->onSavingsTime && defined $object->onSavingsTime) {
        $equal = 1 if $self->onSavingsTime eq $object->onSavingsTime;
    }
    $equal = 1 if (!defined $self->onSavingsTime && !defined $object->onSavingsTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osInstDate && defined $object->osInstDate) {
        $equal = 1 if $self->osInstDate eq $object->osInstDate;
    }
    $equal = 1 if (!defined $self->osInstDate && !defined $object->osInstDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osMajorVersion && defined $object->osMajorVersion) {
        $equal = 1 if $self->osMajorVersion eq $object->osMajorVersion;
    }
    $equal = 1 if (!defined $self->osMajorVersion && !defined $object->osMajorVersion);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osMinorVersion && defined $object->osMinorVersion) {
        $equal = 1 if $self->osMinorVersion eq $object->osMinorVersion;
    }
    $equal = 1 if (!defined $self->osMinorVersion && !defined $object->osMinorVersion);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osName && defined $object->osName) {
        $equal = 1 if $self->osName eq $object->osName;
    }
    $equal = 1 if (!defined $self->osName && !defined $object->osName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osSubVersion && defined $object->osSubVersion) {
        $equal = 1 if $self->osSubVersion eq $object->osSubVersion;
    }
    $equal = 1 if (!defined $self->osSubVersion && !defined $object->osSubVersion);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osType && defined $object->osType) {
        $equal = 1 if $self->osType eq $object->osType;
    }
    $equal = 1 if (!defined $self->osType && !defined $object->osType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->registeredOrg && defined $object->registeredOrg) {
        $equal = 1 if $self->registeredOrg eq $object->registeredOrg;
    }
    $equal = 1 if (!defined $self->registeredOrg && !defined $object->registeredOrg);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->registeredOwner && defined $object->registeredOwner) {
        $equal = 1 if $self->registeredOwner eq $object->registeredOwner;
    }
    $equal = 1 if (!defined $self->registeredOwner && !defined $object->registeredOwner);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sysSerNum && defined $object->sysSerNum) {
        $equal = 1 if $self->sysSerNum eq $object->sysSerNum;
    }
    $equal = 1 if (!defined $self->sysSerNum && !defined $object->sysSerNum);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->timeDirection && defined $object->timeDirection) {
        $equal = 1 if $self->timeDirection eq $object->timeDirection;
    }
    $equal = 1 if (!defined $self->timeDirection && !defined $object->timeDirection);
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
    if (defined $self->tzDaylightName && defined $object->tzDaylightName) {
        $equal = 1 if $self->tzDaylightName eq $object->tzDaylightName;
    }
    $equal = 1 if (!defined $self->tzDaylightName && !defined $object->tzDaylightName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tzLocale && defined $object->tzLocale) {
        $equal = 1 if $self->tzLocale eq $object->tzLocale;
    }
    $equal = 1 if (!defined $self->tzLocale && !defined $object->tzLocale);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tzName && defined $object->tzName) {
        $equal = 1 if $self->tzName eq $object->tzName;
    }
    $equal = 1 if (!defined $self->tzName && !defined $object->tzName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tzSeconds && defined $object->tzSeconds) {
        $equal = 1 if $self->tzSeconds eq $object->tzSeconds;
    }
    $equal = 1 if (!defined $self->tzSeconds && !defined $object->tzSeconds);
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

sub computerAlias {
    my $self = shift;
    $self->{_computerAlias} = shift if scalar @_ == 1;
    return $self->{_computerAlias};
}

sub computerBootTime {
    my $self = shift;
    $self->{_computerBootTime} = shift if scalar @_ == 1;
    return $self->{_computerBootTime};
}

sub computerModel {
    my $self = shift;
    $self->{_computerModel} = shift if scalar @_ == 1;
    return $self->{_computerModel};
}

sub computerScantime {
    my $self = shift;
    $self->{_computerScantime} = shift if scalar @_ == 1;
    return $self->{_computerScantime};
}

sub functionKeys {
    my $self = shift;
    $self->{_functionKeys} = shift if scalar @_ == 1;
    return $self->{_functionKeys};
}

sub keyboardType {
    my $self = shift;
    $self->{_keyboardType} = shift if scalar @_ == 1;
    return $self->{_keyboardType};
}

sub onSavingsTime {
    my $self = shift;
    $self->{_onSavingsTime} = shift if scalar @_ == 1;
    return $self->{_onSavingsTime};
}

sub osInstDate {
    my $self = shift;
    $self->{_osInstDate} = shift if scalar @_ == 1;
    return $self->{_osInstDate};
}

sub osMajorVersion {
    my $self = shift;
    $self->{_osMajorVersion} = shift if scalar @_ == 1;
    return $self->{_osMajorVersion};
}

sub osMinorVersion {
    my $self = shift;
    $self->{_osMinorVersion} = shift if scalar @_ == 1;
    return $self->{_osMinorVersion};
}

sub osName {
    my $self = shift;
    $self->{_osName} = shift if scalar @_ == 1;
    return $self->{_osName};
}

sub osSubVersion {
    my $self = shift;
    $self->{_osSubVersion} = shift if scalar @_ == 1;
    return $self->{_osSubVersion};
}

sub osType {
    my $self = shift;
    $self->{_osType} = shift if scalar @_ == 1;
    return $self->{_osType};
}

sub recordTime {
    my $self = shift;
    $self->{_recordTime} = shift if scalar @_ == 1;
    return $self->{_recordTime};
}

sub registeredOrg {
    my $self = shift;
    $self->{_registeredOrg} = shift if scalar @_ == 1;
    return $self->{_registeredOrg};
}

sub registeredOwner {
    my $self = shift;
    $self->{_registeredOwner} = shift if scalar @_ == 1;
    return $self->{_registeredOwner};
}

sub sysSerNum {
    my $self = shift;
    $self->{_sysSerNum} = shift if scalar @_ == 1;
    return $self->{_sysSerNum};
}

sub timeDirection {
    my $self = shift;
    $self->{_timeDirection} = shift if scalar @_ == 1;
    return $self->{_timeDirection};
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

sub tzDaylightName {
    my $self = shift;
    $self->{_tzDaylightName} = shift if scalar @_ == 1;
    return $self->{_tzDaylightName};
}

sub tzLocale {
    my $self = shift;
    $self->{_tzLocale} = shift if scalar @_ == 1;
    return $self->{_tzLocale};
}

sub tzName {
    my $self = shift;
    $self->{_tzName} = shift if scalar @_ == 1;
    return $self->{_tzName};
}

sub tzSeconds {
    my $self = shift;
    $self->{_tzSeconds} = shift if scalar @_ == 1;
    return $self->{_tzSeconds};
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
    my $s = "[Computer] ";
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
    $s .= "computerAlias=";
    if (defined $self->{_computerAlias}) {
        $s .= $self->{_computerAlias};
    }
    $s .= ",";
    $s .= "computerBootTime=";
    if (defined $self->{_computerBootTime}) {
        $s .= $self->{_computerBootTime};
    }
    $s .= ",";
    $s .= "computerModel=";
    if (defined $self->{_computerModel}) {
        $s .= $self->{_computerModel};
    }
    $s .= ",";
    $s .= "computerScantime=";
    if (defined $self->{_computerScantime}) {
        $s .= $self->{_computerScantime};
    }
    $s .= ",";
    $s .= "functionKeys=";
    if (defined $self->{_functionKeys}) {
        $s .= $self->{_functionKeys};
    }
    $s .= ",";
    $s .= "keyboardType=";
    if (defined $self->{_keyboardType}) {
        $s .= $self->{_keyboardType};
    }
    $s .= ",";
    $s .= "onSavingsTime=";
    if (defined $self->{_onSavingsTime}) {
        $s .= $self->{_onSavingsTime};
    }
    $s .= ",";
    $s .= "osInstDate=";
    if (defined $self->{_osInstDate}) {
        $s .= $self->{_osInstDate};
    }
    $s .= ",";
    $s .= "osMajorVersion=";
    if (defined $self->{_osMajorVersion}) {
        $s .= $self->{_osMajorVersion};
    }
    $s .= ",";
    $s .= "osMinorVersion=";
    if (defined $self->{_osMinorVersion}) {
        $s .= $self->{_osMinorVersion};
    }
    $s .= ",";
    $s .= "osName=";
    if (defined $self->{_osName}) {
        $s .= $self->{_osName};
    }
    $s .= ",";
    $s .= "osSubVersion=";
    if (defined $self->{_osSubVersion}) {
        $s .= $self->{_osSubVersion};
    }
    $s .= ",";
    $s .= "osType=";
    if (defined $self->{_osType}) {
        $s .= $self->{_osType};
    }
    $s .= ",";
    $s .= "recordTime=";
    if (defined $self->{_recordTime}) {
        $s .= $self->{_recordTime};
    }
    $s .= ",";
    $s .= "registeredOrg=";
    if (defined $self->{_registeredOrg}) {
        $s .= $self->{_registeredOrg};
    }
    $s .= ",";
    $s .= "registeredOwner=";
    if (defined $self->{_registeredOwner}) {
        $s .= $self->{_registeredOwner};
    }
    $s .= ",";
    $s .= "sysSerNum=";
    if (defined $self->{_sysSerNum}) {
        $s .= $self->{_sysSerNum};
    }
    $s .= ",";
    $s .= "timeDirection=";
    if (defined $self->{_timeDirection}) {
        $s .= $self->{_timeDirection};
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
    $s .= "tzDaylightName=";
    if (defined $self->{_tzDaylightName}) {
        $s .= $self->{_tzDaylightName};
    }
    $s .= ",";
    $s .= "tzLocale=";
    if (defined $self->{_tzLocale}) {
        $s .= $self->{_tzLocale};
    }
    $s .= ",";
    $s .= "tzName=";
    if (defined $self->{_tzName}) {
        $s .= $self->{_tzName};
    }
    $s .= ",";
    $s .= "tzSeconds=";
    if (defined $self->{_tzSeconds}) {
        $s .= $self->{_tzSeconds};
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
        my $sth = $connection->sql->{insertComputer};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->computerSysId
            ,$self->computerAlias
            ,$self->computerBootTime
            ,$self->computerModel
            ,$self->computerScantime
            ,$self->functionKeys
            ,$self->keyboardType
            ,$self->onSavingsTime
            ,$self->osInstDate
            ,$self->osMajorVersion
            ,$self->osMinorVersion
            ,$self->osName
            ,$self->osSubVersion
            ,$self->osType
            ,$self->registeredOrg
            ,$self->registeredOwner
            ,$self->sysSerNum
            ,$self->timeDirection
            ,$self->tmeObjectId
            ,$self->tmeObjectLabel
            ,$self->tzDaylightName
            ,$self->tzLocale
            ,$self->tzName
            ,$self->tzSeconds
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateComputer};
        $sth->execute(
            $self->computerAlias
            ,$self->computerBootTime
            ,$self->computerModel
            ,$self->computerScantime
            ,$self->functionKeys
            ,$self->keyboardType
            ,$self->onSavingsTime
            ,$self->osInstDate
            ,$self->osMajorVersion
            ,$self->osMinorVersion
            ,$self->osName
            ,$self->osSubVersion
            ,$self->osType
            ,$self->registeredOrg
            ,$self->registeredOwner
            ,$self->sysSerNum
            ,$self->timeDirection
            ,$self->tmeObjectId
            ,$self->tmeObjectLabel
            ,$self->tzDaylightName
            ,$self->tzLocale
            ,$self->tzName
            ,$self->tzSeconds
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
        insert into computer (
            computer_sys_id
            ,computer_alias
            ,computer_boot_time
            ,computer_model
            ,computer_scantime
            ,function_keys
            ,keyboard_type
            ,on_savings_time
            ,os_inst_date
            ,os_major_vers
            ,os_minor_vers
            ,os_name
            ,os_sub_vers
            ,os_type
            ,record_time
            ,registered_org
            ,registered_owner
            ,sys_ser_num
            ,time_direction
            ,tme_object_id
            ,tme_object_label
            ,tz_daylight_name
            ,tz_locale
            ,tz_name
            ,tz_seconds
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
            ,CURRENT TIMESTAMP
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
        ))
    ';
    return ('insertComputer', $query);
}

sub queryUpdate {
    my $query = '
        update computer
        set
            computer_alias = ?
            ,computer_boot_time = ?
            ,computer_model = ?
            ,computer_scantime = ?
            ,function_keys = ?
            ,keyboard_type = ?
            ,on_savings_time = ?
            ,os_inst_date = ?
            ,os_major_vers = ?
            ,os_minor_vers = ?
            ,os_name = ?
            ,os_sub_vers = ?
            ,os_type = ?
            ,record_time = CURRENT TIMESTAMP
            ,registered_org = ?
            ,registered_owner = ?
            ,sys_ser_num = ?
            ,time_direction = ?
            ,tme_object_id = ?
            ,tme_object_label = ?
            ,tz_daylight_name = ?
            ,tz_locale = ?
            ,tz_name = ?
            ,tz_seconds = ?
        where
            computer_sys_id = ?
    ';
    return ('updateComputer', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteComputer};
        $sth->execute(
            $self->computerSysId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from computer
        where
            computer_sys_id = ?
    ';
    return ('deleteComputer', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyComputer};
    my $id;
    my $computerAlias;
    my $computerBootTime;
    my $computerModel;
    my $computerScantime;
    my $functionKeys;
    my $keyboardType;
    my $onSavingsTime;
    my $osInstDate;
    my $osMajorVersion;
    my $osMinorVersion;
    my $osName;
    my $osSubVersion;
    my $osType;
    my $recordTime;
    my $registeredOrg;
    my $registeredOwner;
    my $sysSerNum;
    my $timeDirection;
    my $tmeObjectId;
    my $tmeObjectLabel;
    my $tzDaylightName;
    my $tzLocale;
    my $tzName;
    my $tzSeconds;
    $sth->bind_columns(
        \$id
        ,\$computerAlias
        ,\$computerBootTime
        ,\$computerModel
        ,\$computerScantime
        ,\$functionKeys
        ,\$keyboardType
        ,\$onSavingsTime
        ,\$osInstDate
        ,\$osMajorVersion
        ,\$osMinorVersion
        ,\$osName
        ,\$osSubVersion
        ,\$osType
        ,\$recordTime
        ,\$registeredOrg
        ,\$registeredOwner
        ,\$sysSerNum
        ,\$timeDirection
        ,\$tmeObjectId
        ,\$tmeObjectLabel
        ,\$tzDaylightName
        ,\$tzLocale
        ,\$tzName
        ,\$tzSeconds
    );
    $sth->execute(
        $self->computerSysId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->computerAlias($computerAlias);
    $self->computerBootTime($computerBootTime);
    $self->computerModel($computerModel);
    $self->computerScantime($computerScantime);
    $self->functionKeys($functionKeys);
    $self->keyboardType($keyboardType);
    $self->onSavingsTime($onSavingsTime);
    $self->osInstDate($osInstDate);
    $self->osMajorVersion($osMajorVersion);
    $self->osMinorVersion($osMinorVersion);
    $self->osName($osName);
    $self->osSubVersion($osSubVersion);
    $self->osType($osType);
    $self->recordTime($recordTime);
    $self->registeredOrg($registeredOrg);
    $self->registeredOwner($registeredOwner);
    $self->sysSerNum($sysSerNum);
    $self->timeDirection($timeDirection);
    $self->tmeObjectId($tmeObjectId);
    $self->tmeObjectLabel($tmeObjectLabel);
    $self->tzDaylightName($tzDaylightName);
    $self->tzLocale($tzLocale);
    $self->tzName($tzName);
    $self->tzSeconds($tzSeconds);
}

sub queryGetByBizKey {
    my $query = '
        select
            rtrim(ltrim(cast(char(computer_sys_id) as varchar(255))))
            ,computer_alias
            ,computer_boot_time
            ,computer_model
            ,computer_scantime
            ,function_keys
            ,keyboard_type
            ,on_savings_time
            ,os_inst_date
            ,os_major_vers
            ,os_minor_vers
            ,os_name
            ,os_sub_vers
            ,os_type
            ,record_time
            ,registered_org
            ,registered_owner
            ,sys_ser_num
            ,time_direction
            ,tme_object_id
            ,tme_object_label
            ,tz_daylight_name
            ,tz_locale
            ,tz_name
            ,tz_seconds
        from
            computer
        where
            computer_sys_id = ?
     with ur';
    return ('getByBizKeyComputer', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyComputer};
    my $computerAlias;
    my $computerBootTime;
    my $computerModel;
    my $computerScantime;
    my $functionKeys;
    my $keyboardType;
    my $onSavingsTime;
    my $osInstDate;
    my $osMajorVersion;
    my $osMinorVersion;
    my $osName;
    my $osSubVersion;
    my $osType;
    my $recordTime;
    my $registeredOrg;
    my $registeredOwner;
    my $sysSerNum;
    my $timeDirection;
    my $tmeObjectId;
    my $tmeObjectLabel;
    my $tzDaylightName;
    my $tzLocale;
    my $tzName;
    my $tzSeconds;
    $sth->bind_columns(
        \$computerAlias
        ,\$computerBootTime
        ,\$computerModel
        ,\$computerScantime
        ,\$functionKeys
        ,\$keyboardType
        ,\$onSavingsTime
        ,\$osInstDate
        ,\$osMajorVersion
        ,\$osMinorVersion
        ,\$osName
        ,\$osSubVersion
        ,\$osType
        ,\$recordTime
        ,\$registeredOrg
        ,\$registeredOwner
        ,\$sysSerNum
        ,\$timeDirection
        ,\$tmeObjectId
        ,\$tmeObjectLabel
        ,\$tzDaylightName
        ,\$tzLocale
        ,\$tzName
        ,\$tzSeconds
    );
    $sth->execute(
        $self->computerSysId
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->computerAlias($computerAlias);
    $self->computerBootTime($computerBootTime);
    $self->computerModel($computerModel);
    $self->computerScantime($computerScantime);
    $self->functionKeys($functionKeys);
    $self->keyboardType($keyboardType);
    $self->onSavingsTime($onSavingsTime);
    $self->osInstDate($osInstDate);
    $self->osMajorVersion($osMajorVersion);
    $self->osMinorVersion($osMinorVersion);
    $self->osName($osName);
    $self->osSubVersion($osSubVersion);
    $self->osType($osType);
    $self->recordTime($recordTime);
    $self->registeredOrg($registeredOrg);
    $self->registeredOwner($registeredOwner);
    $self->sysSerNum($sysSerNum);
    $self->timeDirection($timeDirection);
    $self->tmeObjectId($tmeObjectId);
    $self->tmeObjectLabel($tmeObjectLabel);
    $self->tzDaylightName($tzDaylightName);
    $self->tzLocale($tzLocale);
    $self->tzName($tzName);
    $self->tzSeconds($tzSeconds);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            computer_alias
            ,computer_boot_time
            ,computer_model
            ,computer_scantime
            ,function_keys
            ,keyboard_type
            ,on_savings_time
            ,os_inst_date
            ,os_major_vers
            ,os_minor_vers
            ,os_name
            ,os_sub_vers
            ,os_type
            ,record_time
            ,registered_org
            ,registered_owner
            ,sys_ser_num
            ,time_direction
            ,tme_object_id
            ,tme_object_label
            ,tz_daylight_name
            ,tz_locale
            ,tz_name
            ,tz_seconds
        from
            computer
        where
            computer_sys_id = ?
     with ur';
    return ('getByIdKeyComputer', $query);
}

1;
