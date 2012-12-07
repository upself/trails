package BRAVO::OM::Customer;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_customerId => undef
        ,_customerTypeId => undef
        ,_podId => undef
        ,_industryId => undef
        ,_accountNumber => undef
        ,_customerName => undef
        ,_contactDpeId => undef
        ,_contactFaId => undef
        ,_contactHwId => undef
        ,_contactSwId => undef
        ,_contactFocalAssetId => undef
        ,_contactTransitionId => undef
        ,_contractSignDate => undef
        ,_assetToolsBillingCode => undef
        ,_status => undef
        ,_hwInterlock => undef
        ,_swInterlock => undef
        ,_invInterlock => undef
        ,_swLicenseMgmt => undef
        ,_swSupport => undef
        ,_hwSupport => undef
        ,_transitionStatus => undef
        ,_transitionExitDate => undef
        ,_countryCodeId => undef
        ,_scanValidity => undef
        ,_swTracking => undef
        ,_swComplianceMgmt => undef
        ,_swFinancialResponsibility => undef
        ,_swFinancialMgmt => undef
        ,_creationDateTime => undef
        ,_updateDateTime => undef
        ,_action => undef
        ,_table => 'customer'
        ,_idField => 'customer_id'
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
    if (defined $self->customerTypeId && defined $object->customerTypeId) {
        $equal = 1 if $self->customerTypeId eq $object->customerTypeId;
    }
    $equal = 1 if (!defined $self->customerTypeId && !defined $object->customerTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->podId && defined $object->podId) {
        $equal = 1 if $self->podId eq $object->podId;
    }
    $equal = 1 if (!defined $self->podId && !defined $object->podId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->industryId && defined $object->industryId) {
        $equal = 1 if $self->industryId eq $object->industryId;
    }
    $equal = 1 if (!defined $self->industryId && !defined $object->industryId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->accountNumber && defined $object->accountNumber) {
        $equal = 1 if $self->accountNumber eq $object->accountNumber;
    }
    $equal = 1 if (!defined $self->accountNumber && !defined $object->accountNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->customerName && defined $object->customerName) {
        $equal = 1 if $self->customerName eq $object->customerName;
    }
    $equal = 1 if (!defined $self->customerName && !defined $object->customerName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contactDpeId && defined $object->contactDpeId) {
        $equal = 1 if $self->contactDpeId eq $object->contactDpeId;
    }
    $equal = 1 if (!defined $self->contactDpeId && !defined $object->contactDpeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contactFaId && defined $object->contactFaId) {
        $equal = 1 if $self->contactFaId eq $object->contactFaId;
    }
    $equal = 1 if (!defined $self->contactFaId && !defined $object->contactFaId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contactHwId && defined $object->contactHwId) {
        $equal = 1 if $self->contactHwId eq $object->contactHwId;
    }
    $equal = 1 if (!defined $self->contactHwId && !defined $object->contactHwId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contactSwId && defined $object->contactSwId) {
        $equal = 1 if $self->contactSwId eq $object->contactSwId;
    }
    $equal = 1 if (!defined $self->contactSwId && !defined $object->contactSwId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contactFocalAssetId && defined $object->contactFocalAssetId) {
        $equal = 1 if $self->contactFocalAssetId eq $object->contactFocalAssetId;
    }
    $equal = 1 if (!defined $self->contactFocalAssetId && !defined $object->contactFocalAssetId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contactTransitionId && defined $object->contactTransitionId) {
        $equal = 1 if $self->contactTransitionId eq $object->contactTransitionId;
    }
    $equal = 1 if (!defined $self->contactTransitionId && !defined $object->contactTransitionId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->contractSignDate && defined $object->contractSignDate) {
        $equal = 1 if $self->contractSignDate eq $object->contractSignDate;
    }
    $equal = 1 if (!defined $self->contractSignDate && !defined $object->contractSignDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->assetToolsBillingCode && defined $object->assetToolsBillingCode) {
        $equal = 1 if $self->assetToolsBillingCode eq $object->assetToolsBillingCode;
    }
    $equal = 1 if (!defined $self->assetToolsBillingCode && !defined $object->assetToolsBillingCode);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->status && defined $object->status) {
        $equal = 1 if $self->status eq $object->status;
    }
    $equal = 1 if (!defined $self->status && !defined $object->status);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwInterlock && defined $object->hwInterlock) {
        $equal = 1 if $self->hwInterlock eq $object->hwInterlock;
    }
    $equal = 1 if (!defined $self->hwInterlock && !defined $object->hwInterlock);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swInterlock && defined $object->swInterlock) {
        $equal = 1 if $self->swInterlock eq $object->swInterlock;
    }
    $equal = 1 if (!defined $self->swInterlock && !defined $object->swInterlock);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->invInterlock && defined $object->invInterlock) {
        $equal = 1 if $self->invInterlock eq $object->invInterlock;
    }
    $equal = 1 if (!defined $self->invInterlock && !defined $object->invInterlock);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swLicenseMgmt && defined $object->swLicenseMgmt) {
        $equal = 1 if $self->swLicenseMgmt eq $object->swLicenseMgmt;
    }
    $equal = 1 if (!defined $self->swLicenseMgmt && !defined $object->swLicenseMgmt);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swSupport && defined $object->swSupport) {
        $equal = 1 if $self->swSupport eq $object->swSupport;
    }
    $equal = 1 if (!defined $self->swSupport && !defined $object->swSupport);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hwSupport && defined $object->hwSupport) {
        $equal = 1 if $self->hwSupport eq $object->hwSupport;
    }
    $equal = 1 if (!defined $self->hwSupport && !defined $object->hwSupport);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->transitionStatus && defined $object->transitionStatus) {
        $equal = 1 if $self->transitionStatus eq $object->transitionStatus;
    }
    $equal = 1 if (!defined $self->transitionStatus && !defined $object->transitionStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->transitionExitDate && defined $object->transitionExitDate) {
        $equal = 1 if $self->transitionExitDate eq $object->transitionExitDate;
    }
    $equal = 1 if (!defined $self->transitionExitDate && !defined $object->transitionExitDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->countryCodeId && defined $object->countryCodeId) {
        $equal = 1 if $self->countryCodeId eq $object->countryCodeId;
    }
    $equal = 1 if (!defined $self->countryCodeId && !defined $object->countryCodeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scanValidity && defined $object->scanValidity) {
        $equal = 1 if $self->scanValidity eq $object->scanValidity;
    }
    $equal = 1 if (!defined $self->scanValidity && !defined $object->scanValidity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swTracking && defined $object->swTracking) {
        $equal = 1 if $self->swTracking eq $object->swTracking;
    }
    $equal = 1 if (!defined $self->swTracking && !defined $object->swTracking);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swComplianceMgmt && defined $object->swComplianceMgmt) {
        $equal = 1 if $self->swComplianceMgmt eq $object->swComplianceMgmt;
    }
    $equal = 1 if (!defined $self->swComplianceMgmt && !defined $object->swComplianceMgmt);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swFinancialResponsibility && defined $object->swFinancialResponsibility) {
        $equal = 1 if $self->swFinancialResponsibility eq $object->swFinancialResponsibility;
    }
    $equal = 1 if (!defined $self->swFinancialResponsibility && !defined $object->swFinancialResponsibility);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->swFinancialMgmt && defined $object->swFinancialMgmt) {
        $equal = 1 if $self->swFinancialMgmt eq $object->swFinancialMgmt;
    }
    $equal = 1 if (!defined $self->swFinancialMgmt && !defined $object->swFinancialMgmt);
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

sub customerId {
    my $self = shift;
    $self->{_customerId} = shift if scalar @_ == 1;
    return $self->{_customerId};
}

sub customerTypeId {
    my $self = shift;
    $self->{_customerTypeId} = shift if scalar @_ == 1;
    return $self->{_customerTypeId};
}

sub podId {
    my $self = shift;
    $self->{_podId} = shift if scalar @_ == 1;
    return $self->{_podId};
}

sub industryId {
    my $self = shift;
    $self->{_industryId} = shift if scalar @_ == 1;
    return $self->{_industryId};
}

sub accountNumber {
    my $self = shift;
    $self->{_accountNumber} = shift if scalar @_ == 1;
    return $self->{_accountNumber};
}

sub customerName {
    my $self = shift;
    $self->{_customerName} = shift if scalar @_ == 1;
    return $self->{_customerName};
}

sub contactDpeId {
    my $self = shift;
    $self->{_contactDpeId} = shift if scalar @_ == 1;
    return $self->{_contactDpeId};
}

sub contactFaId {
    my $self = shift;
    $self->{_contactFaId} = shift if scalar @_ == 1;
    return $self->{_contactFaId};
}

sub contactHwId {
    my $self = shift;
    $self->{_contactHwId} = shift if scalar @_ == 1;
    return $self->{_contactHwId};
}

sub contactSwId {
    my $self = shift;
    $self->{_contactSwId} = shift if scalar @_ == 1;
    return $self->{_contactSwId};
}

sub contactFocalAssetId {
    my $self = shift;
    $self->{_contactFocalAssetId} = shift if scalar @_ == 1;
    return $self->{_contactFocalAssetId};
}

sub contactTransitionId {
    my $self = shift;
    $self->{_contactTransitionId} = shift if scalar @_ == 1;
    return $self->{_contactTransitionId};
}

sub contractSignDate {
    my $self = shift;
    $self->{_contractSignDate} = shift if scalar @_ == 1;
    return $self->{_contractSignDate};
}

sub assetToolsBillingCode {
    my $self = shift;
    $self->{_assetToolsBillingCode} = shift if scalar @_ == 1;
    return $self->{_assetToolsBillingCode};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
}

sub hwInterlock {
    my $self = shift;
    $self->{_hwInterlock} = shift if scalar @_ == 1;
    return $self->{_hwInterlock};
}

sub swInterlock {
    my $self = shift;
    $self->{_swInterlock} = shift if scalar @_ == 1;
    return $self->{_swInterlock};
}

sub invInterlock {
    my $self = shift;
    $self->{_invInterlock} = shift if scalar @_ == 1;
    return $self->{_invInterlock};
}

sub swLicenseMgmt {
    my $self = shift;
    $self->{_swLicenseMgmt} = shift if scalar @_ == 1;
    return $self->{_swLicenseMgmt};
}

sub swSupport {
    my $self = shift;
    $self->{_swSupport} = shift if scalar @_ == 1;
    return $self->{_swSupport};
}

sub hwSupport {
    my $self = shift;
    $self->{_hwSupport} = shift if scalar @_ == 1;
    return $self->{_hwSupport};
}

sub transitionStatus {
    my $self = shift;
    $self->{_transitionStatus} = shift if scalar @_ == 1;
    return $self->{_transitionStatus};
}

sub transitionExitDate {
    my $self = shift;
    $self->{_transitionExitDate} = shift if scalar @_ == 1;
    return $self->{_transitionExitDate};
}

sub countryCodeId {
    my $self = shift;
    $self->{_countryCodeId} = shift if scalar @_ == 1;
    return $self->{_countryCodeId};
}

sub scanValidity {
    my $self = shift;
    $self->{_scanValidity} = shift if scalar @_ == 1;
    return $self->{_scanValidity};
}

sub swTracking {
    my $self = shift;
    $self->{_swTracking} = shift if scalar @_ == 1;
    return $self->{_swTracking};
}

sub swComplianceMgmt {
    my $self = shift;
    $self->{_swComplianceMgmt} = shift if scalar @_ == 1;
    return $self->{_swComplianceMgmt};
}

sub swFinancialResponsibility {
    my $self = shift;
    $self->{_swFinancialResponsibility} = shift if scalar @_ == 1;
    return $self->{_swFinancialResponsibility};
}

sub swFinancialMgmt {
    my $self = shift;
    $self->{_swFinancialMgmt} = shift if scalar @_ == 1;
    return $self->{_swFinancialMgmt};
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
    my $s = "[Customer] ";
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
    $s .= "customerTypeId=";
    if (defined $self->{_customerTypeId}) {
        $s .= $self->{_customerTypeId};
    }
    $s .= ",";
    $s .= "podId=";
    if (defined $self->{_podId}) {
        $s .= $self->{_podId};
    }
    $s .= ",";
    $s .= "industryId=";
    if (defined $self->{_industryId}) {
        $s .= $self->{_industryId};
    }
    $s .= ",";
    $s .= "accountNumber=";
    if (defined $self->{_accountNumber}) {
        $s .= $self->{_accountNumber};
    }
    $s .= ",";
    $s .= "customerName=";
    if (defined $self->{_customerName}) {
        $s .= $self->{_customerName};
    }
    $s .= ",";
    $s .= "contactDpeId=";
    if (defined $self->{_contactDpeId}) {
        $s .= $self->{_contactDpeId};
    }
    $s .= ",";
    $s .= "contactFaId=";
    if (defined $self->{_contactFaId}) {
        $s .= $self->{_contactFaId};
    }
    $s .= ",";
    $s .= "contactHwId=";
    if (defined $self->{_contactHwId}) {
        $s .= $self->{_contactHwId};
    }
    $s .= ",";
    $s .= "contactSwId=";
    if (defined $self->{_contactSwId}) {
        $s .= $self->{_contactSwId};
    }
    $s .= ",";
    $s .= "contactFocalAssetId=";
    if (defined $self->{_contactFocalAssetId}) {
        $s .= $self->{_contactFocalAssetId};
    }
    $s .= ",";
    $s .= "contactTransitionId=";
    if (defined $self->{_contactTransitionId}) {
        $s .= $self->{_contactTransitionId};
    }
    $s .= ",";
    $s .= "contractSignDate=";
    if (defined $self->{_contractSignDate}) {
        $s .= $self->{_contractSignDate};
    }
    $s .= ",";
    $s .= "assetToolsBillingCode=";
    if (defined $self->{_assetToolsBillingCode}) {
        $s .= $self->{_assetToolsBillingCode};
    }
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
    }
    $s .= ",";
    $s .= "hwInterlock=";
    if (defined $self->{_hwInterlock}) {
        $s .= $self->{_hwInterlock};
    }
    $s .= ",";
    $s .= "swInterlock=";
    if (defined $self->{_swInterlock}) {
        $s .= $self->{_swInterlock};
    }
    $s .= ",";
    $s .= "invInterlock=";
    if (defined $self->{_invInterlock}) {
        $s .= $self->{_invInterlock};
    }
    $s .= ",";
    $s .= "swLicenseMgmt=";
    if (defined $self->{_swLicenseMgmt}) {
        $s .= $self->{_swLicenseMgmt};
    }
    $s .= ",";
    $s .= "swSupport=";
    if (defined $self->{_swSupport}) {
        $s .= $self->{_swSupport};
    }
    $s .= ",";
    $s .= "hwSupport=";
    if (defined $self->{_hwSupport}) {
        $s .= $self->{_hwSupport};
    }
    $s .= ",";
    $s .= "transitionStatus=";
    if (defined $self->{_transitionStatus}) {
        $s .= $self->{_transitionStatus};
    }
    $s .= ",";
    $s .= "transitionExitDate=";
    if (defined $self->{_transitionExitDate}) {
        $s .= $self->{_transitionExitDate};
    }
    $s .= ",";
    $s .= "countryCodeId=";
    if (defined $self->{_countryCodeId}) {
        $s .= $self->{_countryCodeId};
    }
    $s .= ",";
    $s .= "scanValidity=";
    if (defined $self->{_scanValidity}) {
        $s .= $self->{_scanValidity};
    }
    $s .= ",";
    $s .= "swTracking=";
    if (defined $self->{_swTracking}) {
        $s .= $self->{_swTracking};
    }
    $s .= ",";
    $s .= "swComplianceMgmt=";
    if (defined $self->{_swComplianceMgmt}) {
        $s .= $self->{_swComplianceMgmt};
    }
    $s .= ",";
    $s .= "swFinancialResponsibility=";
    if (defined $self->{_swFinancialResponsibility}) {
        $s .= $self->{_swFinancialResponsibility};
    }
    $s .= ",";
    $s .= "swFinancialMgmt=";
    if (defined $self->{_swFinancialMgmt}) {
        $s .= $self->{_swFinancialMgmt};
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
        my $sth = $connection->sql->{insertCustomer};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->customerId
            ,$self->customerTypeId
            ,$self->podId
            ,$self->industryId
            ,$self->accountNumber
            ,$self->customerName
            ,$self->contactDpeId
            ,$self->contactFaId
            ,$self->contactHwId
            ,$self->contactSwId
            ,$self->contactFocalAssetId
            ,$self->contactTransitionId
            ,$self->contractSignDate
            ,$self->assetToolsBillingCode
            ,$self->status
            ,$self->hwInterlock
            ,$self->swInterlock
            ,$self->invInterlock
            ,$self->swLicenseMgmt
            ,$self->swSupport
            ,$self->hwSupport
            ,$self->transitionStatus
            ,$self->transitionExitDate
            ,$self->countryCodeId
            ,$self->scanValidity
            ,$self->swTracking
            ,$self->swComplianceMgmt
            ,$self->swFinancialResponsibility
            ,$self->swFinancialMgmt
            ,$self->creationDateTime
            ,$self->updateDateTime
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateCustomer};
        $sth->execute(
            $self->customerId
            ,$self->customerTypeId
            ,$self->podId
            ,$self->industryId
            ,$self->accountNumber
            ,$self->customerName
            ,$self->contactDpeId
            ,$self->contactFaId
            ,$self->contactHwId
            ,$self->contactSwId
            ,$self->contactFocalAssetId
            ,$self->contactTransitionId
            ,$self->contractSignDate
            ,$self->assetToolsBillingCode
            ,$self->status
            ,$self->hwInterlock
            ,$self->swInterlock
            ,$self->invInterlock
            ,$self->swLicenseMgmt
            ,$self->swSupport
            ,$self->hwSupport
            ,$self->transitionStatus
            ,$self->transitionExitDate
            ,$self->countryCodeId
            ,$self->scanValidity
            ,$self->swTracking
            ,$self->swComplianceMgmt
            ,$self->swFinancialResponsibility
            ,$self->swFinancialMgmt
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
            customer_id
        from
            final table (
        insert into customer (
            customer_id
            ,customer_type_id
            ,pod_id
            ,industry_id
            ,account_number
            ,customer_name
            ,contact_dpe_id
            ,contact_fa_id
            ,contact_hw_id
            ,contact_sw_id
            ,contact_focal_asset_id
            ,contact_transition_id
            ,contract_sign_date
            ,asset_tools_billing_code
            ,status
            ,hw_interlock
            ,sw_interlock
            ,inv_interlock
            ,sw_license_mgmt
            ,sw_support
            ,hw_support
            ,transition_status
            ,transition_exit_date
            ,country_code_id
            ,scan_validity
            ,sw_tracking
            ,sw_compliance_mgmt
            ,sw_financial_responsibility
            ,sw_financial_mgmt
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
    return ('insertCustomer', $query);
}

sub queryUpdate {
    my $query = '
        update customer
        set
            customer_id = ?
            ,customer_type_id = ?
            ,pod_id = ?
            ,industry_id = ?
            ,account_number = ?
            ,customer_name = ?
            ,contact_dpe_id = ?
            ,contact_fa_id = ?
            ,contact_hw_id = ?
            ,contact_sw_id = ?
            ,contact_focal_asset_id = ?
            ,contact_transition_id = ?
            ,contract_sign_date = ?
            ,asset_tools_billing_code = ?
            ,status = ?
            ,hw_interlock = ?
            ,sw_interlock = ?
            ,inv_interlock = ?
            ,sw_license_mgmt = ?
            ,sw_support = ?
            ,hw_support = ?
            ,transition_status = ?
            ,transition_exit_date = ?
            ,country_code_id = ?
            ,scan_validity = ?
            ,sw_tracking = ?
            ,sw_compliance_mgmt = ?
            ,sw_financial_responsibility = ?
            ,sw_financial_mgmt = ?
            ,creation_date_time = ?
            ,update_date_time = ?
        where
            customer_id = ?
    ';
    return ('updateCustomer', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteCustomer};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from customer
        where
            customer_id = ?
    ';
    return ('deleteCustomer', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyCustomer};
    my $id;
    my $customerTypeId;
    my $podId;
    my $industryId;
    my $accountNumber;
    my $customerName;
    my $contactDpeId;
    my $contactFaId;
    my $contactHwId;
    my $contactSwId;
    my $contactFocalAssetId;
    my $contactTransitionId;
    my $contractSignDate;
    my $assetToolsBillingCode;
    my $status;
    my $hwInterlock;
    my $swInterlock;
    my $invInterlock;
    my $swLicenseMgmt;
    my $swSupport;
    my $hwSupport;
    my $transitionStatus;
    my $transitionExitDate;
    my $countryCodeId;
    my $scanValidity;
    my $swTracking;
    my $swComplianceMgmt;
    my $swFinancialResponsibility;
    my $swFinancialMgmt;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$id
        ,\$customerTypeId
        ,\$podId
        ,\$industryId
        ,\$accountNumber
        ,\$customerName
        ,\$contactDpeId
        ,\$contactFaId
        ,\$contactHwId
        ,\$contactSwId
        ,\$contactFocalAssetId
        ,\$contactTransitionId
        ,\$contractSignDate
        ,\$assetToolsBillingCode
        ,\$status
        ,\$hwInterlock
        ,\$swInterlock
        ,\$invInterlock
        ,\$swLicenseMgmt
        ,\$swSupport
        ,\$hwSupport
        ,\$transitionStatus
        ,\$transitionExitDate
        ,\$countryCodeId
        ,\$scanValidity
        ,\$swTracking
        ,\$swComplianceMgmt
        ,\$swFinancialResponsibility
        ,\$swFinancialMgmt
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->customerId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->customerTypeId($customerTypeId);
    $self->podId($podId);
    $self->industryId($industryId);
    $self->accountNumber($accountNumber);
    $self->customerName($customerName);
    $self->contactDpeId($contactDpeId);
    $self->contactFaId($contactFaId);
    $self->contactHwId($contactHwId);
    $self->contactSwId($contactSwId);
    $self->contactFocalAssetId($contactFocalAssetId);
    $self->contactTransitionId($contactTransitionId);
    $self->contractSignDate($contractSignDate);
    $self->assetToolsBillingCode($assetToolsBillingCode);
    $self->status($status);
    $self->hwInterlock($hwInterlock);
    $self->swInterlock($swInterlock);
    $self->invInterlock($invInterlock);
    $self->swLicenseMgmt($swLicenseMgmt);
    $self->swSupport($swSupport);
    $self->hwSupport($hwSupport);
    $self->transitionStatus($transitionStatus);
    $self->transitionExitDate($transitionExitDate);
    $self->countryCodeId($countryCodeId);
    $self->scanValidity($scanValidity);
    $self->swTracking($swTracking);
    $self->swComplianceMgmt($swComplianceMgmt);
    $self->swFinancialResponsibility($swFinancialResponsibility);
    $self->swFinancialMgmt($swFinancialMgmt);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
}

sub queryGetByBizKey {
    my $query = '
        select
            customer_id
            ,customer_type_id
            ,pod_id
            ,industry_id
            ,account_number
            ,customer_name
            ,contact_dpe_id
            ,contact_fa_id
            ,contact_hw_id
            ,contact_sw_id
            ,contact_focal_asset_id
            ,contact_transition_id
            ,contract_sign_date
            ,asset_tools_billing_code
            ,status
            ,hw_interlock
            ,sw_interlock
            ,inv_interlock
            ,sw_license_mgmt
            ,sw_support
            ,hw_support
            ,transition_status
            ,transition_exit_date
            ,country_code_id
            ,scan_validity
            ,sw_tracking
            ,sw_compliance_mgmt
            ,sw_financial_responsibility
            ,sw_financial_mgmt
            ,creation_date_time
            ,update_date_time
        from
            customer
        where
            customer_id = ?
    ';
    return ('getByBizKeyCustomer', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyCustomer};
    my $customerId;
    my $customerTypeId;
    my $podId;
    my $industryId;
    my $accountNumber;
    my $customerName;
    my $contactDpeId;
    my $contactFaId;
    my $contactHwId;
    my $contactSwId;
    my $contactFocalAssetId;
    my $contactTransitionId;
    my $contractSignDate;
    my $assetToolsBillingCode;
    my $status;
    my $hwInterlock;
    my $swInterlock;
    my $invInterlock;
    my $swLicenseMgmt;
    my $swSupport;
    my $hwSupport;
    my $transitionStatus;
    my $transitionExitDate;
    my $countryCodeId;
    my $scanValidity;
    my $swTracking;
    my $swComplianceMgmt;
    my $swFinancialResponsibility;
    my $swFinancialMgmt;
    my $creationDateTime;
    my $updateDateTime;
    $sth->bind_columns(
        \$customerId
        ,\$customerTypeId
        ,\$podId
        ,\$industryId
        ,\$accountNumber
        ,\$customerName
        ,\$contactDpeId
        ,\$contactFaId
        ,\$contactHwId
        ,\$contactSwId
        ,\$contactFocalAssetId
        ,\$contactTransitionId
        ,\$contractSignDate
        ,\$assetToolsBillingCode
        ,\$status
        ,\$hwInterlock
        ,\$swInterlock
        ,\$invInterlock
        ,\$swLicenseMgmt
        ,\$swSupport
        ,\$hwSupport
        ,\$transitionStatus
        ,\$transitionExitDate
        ,\$countryCodeId
        ,\$scanValidity
        ,\$swTracking
        ,\$swComplianceMgmt
        ,\$swFinancialResponsibility
        ,\$swFinancialMgmt
        ,\$creationDateTime
        ,\$updateDateTime
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->customerId($customerId);
    $self->customerTypeId($customerTypeId);
    $self->podId($podId);
    $self->industryId($industryId);
    $self->accountNumber($accountNumber);
    $self->customerName($customerName);
    $self->contactDpeId($contactDpeId);
    $self->contactFaId($contactFaId);
    $self->contactHwId($contactHwId);
    $self->contactSwId($contactSwId);
    $self->contactFocalAssetId($contactFocalAssetId);
    $self->contactTransitionId($contactTransitionId);
    $self->contractSignDate($contractSignDate);
    $self->assetToolsBillingCode($assetToolsBillingCode);
    $self->status($status);
    $self->hwInterlock($hwInterlock);
    $self->swInterlock($swInterlock);
    $self->invInterlock($invInterlock);
    $self->swLicenseMgmt($swLicenseMgmt);
    $self->swSupport($swSupport);
    $self->hwSupport($hwSupport);
    $self->transitionStatus($transitionStatus);
    $self->transitionExitDate($transitionExitDate);
    $self->countryCodeId($countryCodeId);
    $self->scanValidity($scanValidity);
    $self->swTracking($swTracking);
    $self->swComplianceMgmt($swComplianceMgmt);
    $self->swFinancialResponsibility($swFinancialResponsibility);
    $self->swFinancialMgmt($swFinancialMgmt);
    $self->creationDateTime($creationDateTime);
    $self->updateDateTime($updateDateTime);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            customer_id
            ,customer_type_id
            ,pod_id
            ,industry_id
            ,account_number
            ,customer_name
            ,contact_dpe_id
            ,contact_fa_id
            ,contact_hw_id
            ,contact_sw_id
            ,contact_focal_asset_id
            ,contact_transition_id
            ,contract_sign_date
            ,asset_tools_billing_code
            ,status
            ,hw_interlock
            ,sw_interlock
            ,inv_interlock
            ,sw_license_mgmt
            ,sw_support
            ,hw_support
            ,transition_status
            ,transition_exit_date
            ,country_code_id
            ,scan_validity
            ,sw_tracking
            ,sw_compliance_mgmt
            ,sw_financial_responsibility
            ,sw_financial_mgmt
            ,creation_date_time
            ,update_date_time
        from
            customer
        where
            customer_id = ?
    ';
    return ('getByIdKeyCustomer', $query);
}

1;
