package Staging::OM::License;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_extSrcId => undef
        ,_licType => undef
        ,_capType => undef
        ,_customerId => undef
        ,_softwareId => undef
        ,_quantity => undef
        ,_ibmOwned => undef
        ,_draft => undef
        ,_pool => undef
        ,_tryAndBuy => undef
        ,_expireDate => undef
        ,_endDate => undef
        ,_poNumber => undef
        ,_prodName => undef
        ,_fullDesc => undef
        ,_version => undef
        ,_cpuSerial => undef
        ,_licenseStatus => undef
        ,_swcmRecordTime => undef
        ,_agreementType => undef
        ,_environment => undef
        ,_lparName => undef
        ,_status => undef
        ,_action => undef
        ,_table => 'license'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->licType && defined $object->licType) {
        $equal = 1 if $self->licType eq $object->licType;
    }
    $equal = 1 if (!defined $self->licType && !defined $object->licType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->capType && defined $object->capType) {
        $equal = 1 if $self->capType eq $object->capType;
    }
    $equal = 1 if (!defined $self->capType && !defined $object->capType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerId && defined $object->customerId) {
        $equal = 1 if $self->customerId eq $object->customerId;
    }
    $equal = 1 if (!defined $self->customerId && !defined $object->customerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->quantity && defined $object->quantity) {
        $equal = 1 if $self->quantity eq $object->quantity;
    }
    $equal = 1 if (!defined $self->quantity && !defined $object->quantity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->ibmOwned && defined $object->ibmOwned) {
        $equal = 1 if $self->ibmOwned eq $object->ibmOwned;
    }
    $equal = 1 if (!defined $self->ibmOwned && !defined $object->ibmOwned);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->draft && defined $object->draft) {
        $equal = 1 if $self->draft eq $object->draft;
    }
    $equal = 1 if (!defined $self->draft && !defined $object->draft);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->pool && defined $object->pool) {
        $equal = 1 if $self->pool eq $object->pool;
    }
    $equal = 1 if (!defined $self->pool && !defined $object->pool);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tryAndBuy && defined $object->tryAndBuy) {
        $equal = 1 if $self->tryAndBuy eq $object->tryAndBuy;
    }
    $equal = 1 if (!defined $self->tryAndBuy && !defined $object->tryAndBuy);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->expireDate && defined $object->expireDate) {
        $equal = 1 if $self->expireDate eq $object->expireDate;
    }
    $equal = 1 if (!defined $self->expireDate && !defined $object->expireDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->endDate && defined $object->endDate) {
        $equal = 1 if $self->endDate eq $object->endDate;
    }
    $equal = 1 if (!defined $self->endDate && !defined $object->endDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->poNumber && defined $object->poNumber) {
        $equal = 1 if $self->poNumber eq $object->poNumber;
    }
    $equal = 1 if (!defined $self->poNumber && !defined $object->poNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->prodName && defined $object->prodName) {
        $equal = 1 if $self->prodName eq $object->prodName;
    }
    $equal = 1 if (!defined $self->prodName && !defined $object->prodName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->fullDesc && defined $object->fullDesc) {
        $equal = 1 if $self->fullDesc eq $object->fullDesc;
    }
    $equal = 1 if (!defined $self->fullDesc && !defined $object->fullDesc);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->version && defined $object->version) {
        $equal = 1 if $self->version eq $object->version;
    }
    $equal = 1 if (!defined $self->version && !defined $object->version);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cpuSerial && defined $object->cpuSerial) {
        $equal = 1 if $self->cpuSerial eq $object->cpuSerial;
    }
    $equal = 1 if (!defined $self->cpuSerial && !defined $object->cpuSerial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->licenseStatus && defined $object->licenseStatus) {
        $equal = 1 if $self->licenseStatus eq $object->licenseStatus;
    }
    $equal = 1 if (!defined $self->licenseStatus && !defined $object->licenseStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swcmRecordTime && defined $object->swcmRecordTime) {
        $equal = 1 if $self->swcmRecordTime eq $object->swcmRecordTime;
    }
    $equal = 1 if (!defined $self->swcmRecordTime && !defined $object->swcmRecordTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->agreementType && defined $object->agreementType) {
        $equal = 1 if $self->agreementType eq $object->agreementType;
    }
    $equal = 1 if (!defined $self->agreementType && !defined $object->agreementType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->environment && defined $object->environment) {
        $equal = 1 if $self->environment eq $object->environment;
    }
    $equal = 1 if (!defined $self->environment && !defined $object->environment);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lparName && defined $object->lparName) {
        $equal = 1 if $self->lparName eq $object->lparName;
    }
    $equal = 1 if (!defined $self->lparName && !defined $object->lparName);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub extSrcId {
    my $self = shift;
    $self->{_extSrcId} = shift if scalar @_ == 1;
    return $self->{_extSrcId};
}

sub licType {
    my $self = shift;
    $self->{_licType} = shift if scalar @_ == 1;
    return $self->{_licType};
}

sub capType {
    my $self = shift;
    $self->{_capType} = shift if scalar @_ == 1;
    return $self->{_capType};
}

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
}

sub quantity {
    my $self = shift;
    $self->{_quantity} = shift if scalar @_ == 1;
    return $self->{_quantity};
}

sub ibmOwned {
    my $self = shift;
    $self->{_ibmOwned} = shift if scalar @_ == 1;
    return $self->{_ibmOwned};
}

sub draft {
    my $self = shift;
    $self->{_draft} = shift if scalar @_ == 1;
    return $self->{_draft};
}

sub pool {
    my $self = shift;
    $self->{_pool} = shift if scalar @_ == 1;
    return $self->{_pool};
}

sub tryAndBuy {
    my $self = shift;
    $self->{_tryAndBuy} = shift if scalar @_ == 1;
    return $self->{_tryAndBuy};
}

sub expireDate {
    my $self = shift;
    $self->{_expireDate} = shift if scalar @_ == 1;
    return $self->{_expireDate};
}

sub endDate {
    my $self = shift;
    $self->{_endDate} = shift if scalar @_ == 1;
    return $self->{_endDate};
}

sub poNumber {
    my $self = shift;
    $self->{_poNumber} = shift if scalar @_ == 1;
    return $self->{_poNumber};
}

sub prodName {
    my $self = shift;
    $self->{_prodName} = shift if scalar @_ == 1;
    return $self->{_prodName};
}

sub fullDesc {
    my $self = shift;
    $self->{_fullDesc} = shift if scalar @_ == 1;
    return $self->{_fullDesc};
}

sub version {
    my $self = shift;
    $self->{_version} = shift if scalar @_ == 1;
    return $self->{_version};
}

sub cpuSerial {
    my $self = shift;
    $self->{_cpuSerial} = shift if scalar @_ == 1;
    return $self->{_cpuSerial};
}

sub licenseStatus {
    my $self = shift;
    $self->{_licenseStatus} = shift if scalar @_ == 1;
    return $self->{_licenseStatus};
}

sub swcmRecordTime {
    my $self = shift;
    $self->{_swcmRecordTime} = shift if scalar @_ == 1;
    return $self->{_swcmRecordTime};
}

sub agreementType {
    my $self = shift;
    $self->{_agreementType} = shift if scalar @_ == 1;
    return $self->{_agreementType};
}

sub environment {
    my $self = shift;
    $self->{_environment} = shift if scalar @_ == 1;
    return $self->{_environment};
}

sub lparName {
    my $self = shift;
    $self->{_lparName} = shift if scalar @_ == 1;
    return $self->{_lparName};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
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
    my $s = "[License] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "extSrcId=";
    if (defined $self->{_extSrcId}) {
        $s .= $self->{_extSrcId};
    }
    $s .= ",";
    $s .= "licType=";
    if (defined $self->{_licType}) {
        $s .= $self->{_licType};
    }
    $s .= ",";
    $s .= "capType=";
    if (defined $self->{_capType}) {
        $s .= $self->{_capType};
    }
    $s .= ",";
    $s .= "customerId=";
    if (defined $self->{_customerId}) {
        $s .= $self->{_customerId};
    }
    $s .= ",";
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
    }
    $s .= ",";
    $s .= "quantity=";
    if (defined $self->{_quantity}) {
        $s .= $self->{_quantity};
    }
    $s .= ",";
    $s .= "ibmOwned=";
    if (defined $self->{_ibmOwned}) {
        $s .= $self->{_ibmOwned};
    }
    $s .= ",";
    $s .= "draft=";
    if (defined $self->{_draft}) {
        $s .= $self->{_draft};
    }
    $s .= ",";
    $s .= "pool=";
    if (defined $self->{_pool}) {
        $s .= $self->{_pool};
    }
    $s .= ",";
    $s .= "tryAndBuy=";
    if (defined $self->{_tryAndBuy}) {
        $s .= $self->{_tryAndBuy};
    }
    $s .= ",";
    $s .= "expireDate=";
    if (defined $self->{_expireDate}) {
        $s .= $self->{_expireDate};
    }
    $s .= ",";
    $s .= "endDate=";
    if (defined $self->{_endDate}) {
        $s .= $self->{_endDate};
    }
    $s .= ",";
    $s .= "poNumber=";
    if (defined $self->{_poNumber}) {
        $s .= $self->{_poNumber};
    }
    $s .= ",";
    $s .= "prodName=";
    if (defined $self->{_prodName}) {
        $s .= $self->{_prodName};
    }
    $s .= ",";
    $s .= "fullDesc=";
    if (defined $self->{_fullDesc}) {
        $s .= $self->{_fullDesc};
    }
    $s .= ",";
    $s .= "version=";
    if (defined $self->{_version}) {
        $s .= $self->{_version};
    }
    $s .= ",";
    $s .= "cpuSerial=";
    if (defined $self->{_cpuSerial}) {
        $s .= $self->{_cpuSerial};
    }
    $s .= ",";
    $s .= "licenseStatus=";
    if (defined $self->{_licenseStatus}) {
        $s .= $self->{_licenseStatus};
    }
    $s .= ",";
    $s .= "swcmRecordTime=";
    if (defined $self->{_swcmRecordTime}) {
        $s .= $self->{_swcmRecordTime};
    }
    $s .= ",";
    $s .= "agreementType=";
    if (defined $self->{_agreementType}) {
        $s .= $self->{_agreementType};
    }
    $s .= ",";
    $s .= "environment=";
    if (defined $self->{_environment}) {
        $s .= $self->{_environment};
    }
    $s .= ",";
    $s .= "lparName=";
    if (defined $self->{_lparName}) {
        $s .= $self->{_lparName};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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
        my $sth = $connection->sql->{insertLicense};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->extSrcId
            ,$self->licType
            ,$self->capType
            ,$self->customerId
            ,$self->softwareId
            ,$self->quantity
            ,$self->ibmOwned
            ,$self->draft
            ,$self->pool
            ,$self->tryAndBuy
            ,$self->expireDate
            ,$self->endDate
            ,$self->poNumber
            ,$self->prodName
            ,$self->fullDesc
            ,$self->version
            ,$self->cpuSerial
            ,$self->licenseStatus
            ,$self->swcmRecordTime
            ,$self->agreementType
            ,$self->environment
            ,$self->lparName
            ,$self->status
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateLicense};
        $sth->execute(
            $self->extSrcId
            ,$self->licType
            ,$self->capType
            ,$self->customerId
            ,$self->softwareId
            ,$self->quantity
            ,$self->ibmOwned
            ,$self->draft
            ,$self->pool
            ,$self->tryAndBuy
            ,$self->expireDate
            ,$self->endDate
            ,$self->poNumber
            ,$self->prodName
            ,$self->fullDesc
            ,$self->version
            ,$self->cpuSerial
            ,$self->licenseStatus
            ,$self->swcmRecordTime
            ,$self->agreementType
            ,$self->environment
            ,$self->lparName
            ,$self->status
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
        insert into license (
            ext_src_id
            ,lic_type
            ,cap_type
            ,customer_id
            ,software_id
            ,quantity
            ,ibm_owned
            ,draft
            ,pool
            ,try_and_buy
            ,expire_date
            ,end_date
            ,po_number
            ,prod_name
            ,full_desc
            ,version
            ,cpu_serial
            ,license_status
            ,swcm_record_time
            ,agreement_type
            ,environment
            ,lpar_name
            ,status
            ,action
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
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertLicense', $query);
}

sub queryUpdate {
    my $query = '
        update license
        set
            ext_src_id = ?
            ,lic_type = ?
            ,cap_type = ?
            ,customer_id = ?
            ,software_id = ?
            ,quantity = ?
            ,ibm_owned = ?
            ,draft = ?
            ,pool = ?
            ,try_and_buy = ?
            ,expire_date = ?
            ,end_date = ?
            ,po_number = ?
            ,prod_name = ?
            ,full_desc = ?
            ,version = ?
            ,cpu_serial = ?
            ,license_status = ?
            ,swcm_record_time = ?
            ,agreement_type = ?
            ,environment = ?
            ,lpar_name = ?
            ,status = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateLicense', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteLicense};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from license a where
            a.id = ?
    ';
    return ('deleteLicense', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyLicense};
    my $extSrcId;
    my $licType;
    my $capType;
    my $customerId;
    my $softwareId;
    my $quantity;
    my $ibmOwned;
    my $draft;
    my $pool;
    my $tryAndBuy;
    my $expireDate;
    my $endDate;
    my $poNumber;
    my $prodName;
    my $fullDesc;
    my $version;
    my $cpuSerial;
    my $licenseStatus;
    my $swcmRecordTime;
    my $agreementType;
    my $environment;
    my $lparName;
    my $status;
    my $action;
    $sth->bind_columns(
        \$extSrcId
        ,\$licType
        ,\$capType
        ,\$customerId
        ,\$softwareId
        ,\$quantity
        ,\$ibmOwned
        ,\$draft
        ,\$pool
        ,\$tryAndBuy
        ,\$expireDate
        ,\$endDate
        ,\$poNumber
        ,\$prodName
        ,\$fullDesc
        ,\$version
        ,\$cpuSerial
        ,\$licenseStatus
        ,\$swcmRecordTime
        ,\$agreementType
        ,\$environment
        ,\$lparName
        ,\$status
        ,\$action
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->extSrcId($extSrcId);
    $self->licType($licType);
    $self->capType($capType);
    $self->customerId($customerId);
    $self->softwareId($softwareId);
    $self->quantity($quantity);
    $self->ibmOwned($ibmOwned);
    $self->draft($draft);
    $self->pool($pool);
    $self->tryAndBuy($tryAndBuy);
    $self->expireDate($expireDate);
    $self->endDate($endDate);
    $self->poNumber($poNumber);
    $self->prodName($prodName);
    $self->fullDesc($fullDesc);
    $self->version($version);
    $self->cpuSerial($cpuSerial);
    $self->licenseStatus($licenseStatus);
    $self->swcmRecordTime($swcmRecordTime);
    $self->agreementType($agreementType);
    $self->environment($environment);
    $self->lparName($lparName);
    $self->status($status);
    $self->action($action);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            ext_src_id
            ,lic_type
            ,cap_type
            ,customer_id
            ,software_id
            ,quantity
            ,ibm_owned
            ,draft
            ,pool
            ,try_and_buy
            ,expire_date
            ,end_date
            ,po_number
            ,prod_name
            ,full_desc
            ,version
            ,cpu_serial
            ,license_status
            ,swcm_record_time
            ,agreement_type
            ,environment
            ,lpar_name
            ,status
            ,action
        from
            license
        where
            id = ?
    ';
    return ('getByIdKeyLicense', $query);
}

1;
