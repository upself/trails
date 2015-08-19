package Recon::OM::ReconInstalledSoftwareData;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _hId => undef
        ,_hStatus => undef
        ,_hProcCount => undef
        ,_hHwStatus => undef
        ,_hSerial => undef
        ,_hChips => undef
        ,_hNbrCoresPerChip => undef
        ,_hProcessorBrand => undef
        ,_hProcessorModel => undef
        ,_hMachineTypeId => undef
        ,_hServerType => undef
        ,_hCpuMIPS => undef
        ,_hCpuGartnerMIPS => undef
        ,_hCpuMSU => undef
        ,_hCpuIFL => undef
        ,_hOwner => undef
        ,_mtType => undef
        ,_hlId => undef
        ,_hlStatus => undef
        ,_hlName => undef
        ,_hlPartMIPS => undef
        ,_hlPartGartnerMIPS => undef
        ,_hlPartMSU => undef
        ,_slId => undef
        ,_cId => undef
        ,_slName => undef
        ,_slStatus => undef
        ,_processorCount => undef
        ,_sId => undef
        ,_sName => undef
        ,_sStatus => undef
        ,_sPriority => undef
        ,_sLevel => undef
        ,_sVendorMgd => undef
        ,_sMfgId => undef
        ,_sMfg => undef
        ,_scName => undef
        ,_scParent => undef
        ,_scChildren => undef
        ,_bpIds => undef
        ,_bcSwIds => undef
        ,_bParent => undef
        ,_bChildren => undef
        ,_rId => undef
        ,_rTypeId => undef
        ,_rParentInstSwId => undef
        ,_rMachineLevel => undef
        ,_rIsManual => undef
        ,_licsToRecon => undef
        ,_scopeName => undef
        ,_scheduleFlevel => undef
        ,_expectedAlertType => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->hId && defined $object->hId) {
        $equal = 1 if $self->hId eq $object->hId;
    }
    $equal = 1 if (!defined $self->hId && !defined $object->hId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hStatus && defined $object->hStatus) {
        $equal = 1 if $self->hStatus eq $object->hStatus;
    }
    $equal = 1 if (!defined $self->hStatus && !defined $object->hStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hProcCount && defined $object->hProcCount) {
        $equal = 1 if $self->hProcCount eq $object->hProcCount;
    }
    $equal = 1 if (!defined $self->hProcCount && !defined $object->hProcCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hHwStatus && defined $object->hHwStatus) {
        $equal = 1 if $self->hHwStatus eq $object->hHwStatus;
    }
    $equal = 1 if (!defined $self->hHwStatus && !defined $object->hHwStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hSerial && defined $object->hSerial) {
        $equal = 1 if $self->hSerial eq $object->hSerial;
    }
    $equal = 1 if (!defined $self->hSerial && !defined $object->hSerial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hChips && defined $object->hChips) {
        $equal = 1 if $self->hChips eq $object->hChips;
    }
    $equal = 1 if (!defined $self->hChips && !defined $object->hChips);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hNbrCoresPerChip && defined $object->hNbrCoresPerChip) {
        $equal = 1 if $self->hNbrCoresPerChip eq $object->hNbrCoresPerChip;
    }
    $equal = 1 if (!defined $self->hNbrCoresPerChip && !defined $object->hNbrCoresPerChip);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hProcessorBrand && defined $object->hProcessorBrand) {
        $equal = 1 if $self->hProcessorBrand eq $object->hProcessorBrand;
    }
    $equal = 1 if (!defined $self->hProcessorBrand && !defined $object->hProcessorBrand);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hProcessorModel && defined $object->hProcessorModel) {
        $equal = 1 if $self->hProcessorModel eq $object->hProcessorModel;
    }
    $equal = 1 if (!defined $self->hProcessorModel && !defined $object->hProcessorModel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hMachineTypeId && defined $object->hMachineTypeId) {
        $equal = 1 if $self->hMachineTypeId eq $object->hMachineTypeId;
    }
    $equal = 1 if (!defined $self->hMachineTypeId && !defined $object->hMachineTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hServerType && defined $object->hServerType) {
        $equal = 1 if $self->hServerType eq $object->hServerType;
    }
    $equal = 1 if (!defined $self->hServerType && !defined $object->hServerType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuMIPS && defined $object->hCpuMIPS) {
        $equal = 1 if $self->hCpuMIPS eq $object->hCpuMIPS;
    }
    $equal = 1 if (!defined $self->hCpuMIPS && !defined $object->hCpuMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuGartnerMIPS && defined $object->hCpuGartnerMIPS) {
        $equal = 1 if $self->hCpuGartnerMIPS eq $object->hCpuGartnerMIPS;
    }
    $equal = 1 if (!defined $self->hCpuGartnerMIPS && !defined $object->hCpuGartnerMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuMSU && defined $object->hCpuMSU) {
        $equal = 1 if $self->hCpuMSU eq $object->hCpuMSU;
    }
    $equal = 1 if (!defined $self->hCpuMSU && !defined $object->hCpuMSU);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuIFL && defined $object->hCpuIFL) {
        $equal = 1 if $self->hCpuIFL eq $object->hCpuIFL;
    }
    $equal = 1 if (!defined $self->hCpuIFL && !defined $object->hCpuIFL);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hOwner && defined $object->hOwner) {
        $equal = 1 if $self->hOwner eq $object->hOwner;
    }
    $equal = 1 if (!defined $self->hOwner && !defined $object->hOwner);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->mtType && defined $object->mtType) {
        $equal = 1 if $self->mtType eq $object->mtType;
    }
    $equal = 1 if (!defined $self->mtType && !defined $object->mtType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlId && defined $object->hlId) {
        $equal = 1 if $self->hlId eq $object->hlId;
    }
    $equal = 1 if (!defined $self->hlId && !defined $object->hlId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlStatus && defined $object->hlStatus) {
        $equal = 1 if $self->hlStatus eq $object->hlStatus;
    }
    $equal = 1 if (!defined $self->hlStatus && !defined $object->hlStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlName && defined $object->hlName) {
        $equal = 1 if $self->hlName eq $object->hlName;
    }
    $equal = 1 if (!defined $self->hlName && !defined $object->hlName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlPartMIPS && defined $object->hlPartMIPS) {
        $equal = 1 if $self->hlPartMIPS eq $object->hlPartMIPS;
    }
    $equal = 1 if (!defined $self->hlPartMIPS && !defined $object->hlPartMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlPartGartnerMIPS && defined $object->hlPartGartnerMIPS) {
        $equal = 1 if $self->hlPartGartnerMIPS eq $object->hlPartGartnerMIPS;
    }
    $equal = 1 if (!defined $self->hlPartGartnerMIPS && !defined $object->hlPartGartnerMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlPartMSU && defined $object->hlPartMSU) {
        $equal = 1 if $self->hlPartMSU eq $object->hlPartMSU;
    }
    $equal = 1 if (!defined $self->hlPartMSU && !defined $object->hlPartMSU);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->slId && defined $object->slId) {
        $equal = 1 if $self->slId eq $object->slId;
    }
    $equal = 1 if (!defined $self->slId && !defined $object->slId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cId && defined $object->cId) {
        $equal = 1 if $self->cId eq $object->cId;
    }
    $equal = 1 if (!defined $self->cId && !defined $object->cId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->slName && defined $object->slName) {
        $equal = 1 if $self->slName eq $object->slName;
    }
    $equal = 1 if (!defined $self->slName && !defined $object->slName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->slStatus && defined $object->slStatus) {
        $equal = 1 if $self->slStatus eq $object->slStatus;
    }
    $equal = 1 if (!defined $self->slStatus && !defined $object->slStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sId && defined $object->sId) {
        $equal = 1 if $self->sId eq $object->sId;
    }
    $equal = 1 if (!defined $self->sId && !defined $object->sId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sName && defined $object->sName) {
        $equal = 1 if $self->sName eq $object->sName;
    }
    $equal = 1 if (!defined $self->sName && !defined $object->sName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sStatus && defined $object->sStatus) {
        $equal = 1 if $self->sStatus eq $object->sStatus;
    }
    $equal = 1 if (!defined $self->sStatus && !defined $object->sStatus);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sPriority && defined $object->sPriority) {
        $equal = 1 if $self->sPriority eq $object->sPriority;
    }
    $equal = 1 if (!defined $self->sPriority && !defined $object->sPriority);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sLevel && defined $object->sLevel) {
        $equal = 1 if $self->sLevel eq $object->sLevel;
    }
    $equal = 1 if (!defined $self->sLevel && !defined $object->sLevel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sVendorMgd && defined $object->sVendorMgd) {
        $equal = 1 if $self->sVendorMgd eq $object->sVendorMgd;
    }
    $equal = 1 if (!defined $self->sVendorMgd && !defined $object->sVendorMgd);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sMfg && defined $object->sMfg) {
        $equal = 1 if $self->sMfg eq $object->sMfg;
    }
    $equal = 1 if (!defined $self->sMfg && !defined $object->sMfg);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scName && defined $object->scName) {
        $equal = 1 if $self->scName eq $object->scName;
    }
    $equal = 1 if (!defined $self->scName && !defined $object->scName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scParent && defined $object->scParent) {
        $equal = 1 if $self->scParent eq $object->scParent;
    }
    $equal = 1 if (!defined $self->scParent && !defined $object->scParent);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scChildren && defined $object->scChildren) {
        $equal = 1 if $self->scChildren eq $object->scChildren;
    }
    $equal = 1 if (!defined $self->scChildren && !defined $object->scChildren);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bpIds && defined $object->bpIds) {
        $equal = 1 if $self->bpIds eq $object->bpIds;
    }
    $equal = 1 if (!defined $self->bpIds && !defined $object->bpIds);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bcSwIds && defined $object->bcSwIds) {
        $equal = 1 if $self->bcSwIds eq $object->bcSwIds;
    }
    $equal = 1 if (!defined $self->bcSwIds && !defined $object->bcSwIds);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bParent && defined $object->bParent) {
        $equal = 1 if $self->bParent eq $object->bParent;
    }
    $equal = 1 if (!defined $self->bParent && !defined $object->bParent);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bChildren && defined $object->bChildren) {
        $equal = 1 if $self->bChildren eq $object->bChildren;
    }
    $equal = 1 if (!defined $self->bChildren && !defined $object->bChildren);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rId && defined $object->rId) {
        $equal = 1 if $self->rId eq $object->rId;
    }
    $equal = 1 if (!defined $self->rId && !defined $object->rId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rTypeId && defined $object->rTypeId) {
        $equal = 1 if $self->rTypeId eq $object->rTypeId;
    }
    $equal = 1 if (!defined $self->rTypeId && !defined $object->rTypeId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rParentInstSwId && defined $object->rParentInstSwId) {
        $equal = 1 if $self->rParentInstSwId eq $object->rParentInstSwId;
    }
    $equal = 1 if (!defined $self->rParentInstSwId && !defined $object->rParentInstSwId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rMachineLevel && defined $object->rMachineLevel) {
        $equal = 1 if $self->rMachineLevel eq $object->rMachineLevel;
    }
    $equal = 1 if (!defined $self->rMachineLevel && !defined $object->rMachineLevel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rIsManual && defined $object->rIsManual) {
        $equal = 1 if $self->rIsManual eq $object->rIsManual;
    }
    $equal = 1 if (!defined $self->rIsManual && !defined $object->rIsManual);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->licsToRecon && defined $object->licsToRecon) {
        $equal = 1 if $self->licsToRecon eq $object->licsToRecon;
    }
    $equal = 1 if (!defined $self->licsToRecon && !defined $object->licsToRecon);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scopeName && defined $object->scopeName) {
        $equal = 1 if $self->scopeName eq $object->scopeName;
    }
    $equal = 1 if (!defined $self->scopeName && !defined $object->scopeName);
    return 0 if $equal == 0;

    return 1;
}

sub hId {
    my $self = shift;
    $self->{_hId} = shift if scalar @_ == 1;
    return $self->{_hId};
}

sub hStatus {
    my $self = shift;
    $self->{_hStatus} = shift if scalar @_ == 1;
    return $self->{_hStatus};
}

sub hProcCount {
    my $self = shift;
    $self->{_hProcCount} = shift if scalar @_ == 1;
    return $self->{_hProcCount};
}

sub hHwStatus {
    my $self = shift;
    $self->{_hHwStatus} = shift if scalar @_ == 1;
    return $self->{_hHwStatus};
}

sub hSerial {
    my $self = shift;
    $self->{_hSerial} = shift if scalar @_ == 1;
    return $self->{_hSerial};
}

sub hChips {
    my $self = shift;
    $self->{_hChips} = shift if scalar @_ == 1;
    return $self->{_hChips};
}

sub hNbrCoresPerChip {
    my $self = shift;
    $self->{_hNbrCoresPerChip} = shift if scalar @_ == 1;
    return $self->{_hNbrCoresPerChip};
}

sub hProcessorBrand {
    my $self = shift;
    $self->{_hProcessorBrand} = shift if scalar @_ == 1;
    return $self->{_hProcessorBrand};
}

sub hProcessorModel {
    my $self = shift;
    $self->{_hProcessorModel} = shift if scalar @_ == 1;
    return $self->{_hProcessorModel};
}

sub hMachineTypeId {
    my $self = shift;
    $self->{_hMachineTypeId} = shift if scalar @_ == 1;
    return $self->{_hMachineTypeId};
}

sub hServerType {
    my $self = shift;
    $self->{_hServerType} = shift if scalar @_ == 1;
    return $self->{_hServerType};
}

sub hCpuMIPS {
    my $self = shift;
    $self->{_hCpuMIPS} = shift if scalar @_ == 1;
    return $self->{_hCpuMIPS};
}

sub hCpuGartnerMIPS {
    my $self = shift;
    $self->{_hCpuGartnerMIPS} = shift if scalar @_ == 1;
    return $self->{_hCpuGartnerMIPS};
}

sub hCpuMSU {
    my $self = shift;
    $self->{_hCpuMSU} = shift if scalar @_ == 1;
    return $self->{_hCpuMSU};
}

sub hCpuIFL {
    my $self = shift;
    $self->{_hCpuIFL} = shift if scalar @_ == 1;
    return $self->{_hCpuIFL};
}

sub hOwner {
    my $self = shift;
    $self->{_hOwner} = shift if scalar @_ == 1;
    return $self->{_hOwner};
}

sub mtType {
    my $self = shift;
    $self->{_mtType} = shift if scalar @_ == 1;
    return $self->{_mtType};
}

sub hlId {
    my $self = shift;
    $self->{_hlId} = shift if scalar @_ == 1;
    return $self->{_hlId};
}

sub hlStatus {
    my $self = shift;
    $self->{_hlStatus} = shift if scalar @_ == 1;
    return $self->{_hlStatus};
}

sub hlName {
    my $self = shift;
    $self->{_hlName} = shift if scalar @_ == 1;
    return $self->{_hlName};
}

sub hlPartMIPS {
    my $self = shift;
    $self->{_hlPartMIPS} = shift if scalar @_ == 1;
    return $self->{_hlPartMIPS};
}

sub hlPartGartnerMIPS {
    my $self = shift;
    $self->{_hlPartGartnerMIPS} = shift if scalar @_ == 1;
    return $self->{_hlPartGartnerMIPS};
}

sub hlPartMSU {
    my $self = shift;
    $self->{_hlPartMSU} = shift if scalar @_ == 1;
    return $self->{_hlPartMSU};
}

sub slId {
    my $self = shift;
    $self->{_slId} = shift if scalar @_ == 1;
    return $self->{_slId};
}

sub cId {
    my $self = shift;
    $self->{_cId} = shift if scalar @_ == 1;
    return $self->{_cId};
}

sub slName {
    my $self = shift;
    $self->{_slName} = shift if scalar @_ == 1;
    return $self->{_slName};
}

sub slStatus {
    my $self = shift;
    $self->{_slStatus} = shift if scalar @_ == 1;
    return $self->{_slStatus};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
}

sub sId {
    my $self = shift;
    $self->{_sId} = shift if scalar @_ == 1;
    return $self->{_sId};
}

sub sName {
    my $self = shift;
    $self->{_sName} = shift if scalar @_ == 1;
    return $self->{_sName};
}

sub sStatus {
    my $self = shift;
    $self->{_sStatus} = shift if scalar @_ == 1;
    return $self->{_sStatus};
}

sub sPriority {
    my $self = shift;
    $self->{_sPriority} = shift if scalar @_ == 1;
    return $self->{_sPriority};
}

sub sLevel {
    my $self = shift;
    $self->{_sLevel} = shift if scalar @_ == 1;
    return $self->{_sLevel};
}

sub sVendorMgd {
    my $self = shift;
    $self->{_sVendorMgd} = shift if scalar @_ == 1;
    return $self->{_sVendorMgd};
}

sub sMfgId {
    my $self = shift;
    $self->{_sMfgId} = shift if scalar @_ == 1;
    return $self->{_sMfgId};
}

sub sMfg {
    my $self = shift;
    $self->{_sMfg} = shift if scalar @_ == 1;
    return $self->{_sMfg};
}

sub scName {
    my $self = shift;
    $self->{_scName} = shift if scalar @_ == 1;
    return $self->{_scName};
}

sub scParent {
    my $self = shift;
    $self->{_scParent} = shift if scalar @_ == 1;
    return $self->{_scParent};
}

sub scChildren {
    my $self = shift;
    $self->{_scChildren} = shift if scalar @_ == 1;
    return $self->{_scChildren};
}

sub bpIds {
    my $self = shift;
    $self->{_bpIds} = shift if scalar @_ == 1;
    return $self->{_bpIds};
}

sub bcSwIds {
    my $self = shift;
    $self->{_bcSwIds} = shift if scalar @_ == 1;
    return $self->{_bcSwIds};
}

sub bParent {
    my $self = shift;
    $self->{_bParent} = shift if scalar @_ == 1;
    return $self->{_bParent};
}

sub bChildren {
    my $self = shift;
    $self->{_bChildren} = shift if scalar @_ == 1;
    return $self->{_bChildren};
}

sub rId {
    my $self = shift;
    $self->{_rId} = shift if scalar @_ == 1;
    return $self->{_rId};
}

sub rTypeId {
    my $self = shift;
    $self->{_rTypeId} = shift if scalar @_ == 1;
    return $self->{_rTypeId};
}

sub rParentInstSwId {
    my $self = shift;
    $self->{_rParentInstSwId} = shift if scalar @_ == 1;
    return $self->{_rParentInstSwId};
}

sub rMachineLevel {
    my $self = shift;
    $self->{_rMachineLevel} = shift if scalar @_ == 1;
    return $self->{_rMachineLevel};
}

sub rIsManual {
    my $self = shift;
    $self->{_rIsManual} = shift if scalar @_ == 1;
    return $self->{_rIsManual};
}

sub licsToRecon {
    my $self = shift;
    $self->{_licsToRecon} = shift if scalar @_ == 1;
    return $self->{_licsToRecon};
}

sub scopeName {
    my $self = shift;
    $self->{_scopeName} = shift if scalar @_ == 1;
    return $self->{_scopeName};
}

sub scheduleFlevel {
    my $self = shift;
    $self->{_scheduleFlevel} = shift if scalar @_ == 1;
    return $self->{_scheduleFlevel};
}

sub expectedAlertType {
    my $self = shift;
    $self->{_expectedAlertType} = shift if scalar @_ == 1;
    return $self->{_expectedAlertType};
}

sub toString {
    my ($self) = @_;
    my $s = "[ReconInstalledSoftwareData] ";
    $s .= "hId=";
    if (defined $self->{_hId}) {
        $s .= $self->{_hId};
    }
    $s .= ",";
    $s .= "hStatus=";
    if (defined $self->{_hStatus}) {
        $s .= $self->{_hStatus};
    }
    $s .= ",";
    $s .= "hProcCount=";
    if (defined $self->{_hProcCount}) {
        $s .= $self->{_hProcCount};
    }
    $s .= ",";
    $s .= "hHwStatus=";
    if (defined $self->{_hHwStatus}) {
        $s .= $self->{_hHwStatus};
    }
    $s .= ",";
    $s .= "hSerial=";
    if (defined $self->{_hSerial}) {
        $s .= $self->{_hSerial};
    }
    $s .= ",";
    $s .= "hChips=";
    if (defined $self->{_hChips}) {
        $s .= $self->{_hChips};
    }
    $s .= ",";
    $s .= "hNbrCoresPerChip=";
    if (defined $self->{_hNbrCoresPerChip}) {
        $s .= $self->{_hNbrCoresPerChip};
    }
    $s .= ",";
    $s .= "hProcessorBrand=";
    if (defined $self->{_hProcessorBrand}) {
        $s .= $self->{_hProcessorBrand};
    }
    $s .= ",";
    $s .= "hProcessorModel=";
    if (defined $self->{_hProcessorModel}) {
        $s .= $self->{_hProcessorModel};
    }
    $s .= ",";
    $s .= "hMachineTypeId=";
    if (defined $self->{_hMachineTypeId}) {
        $s .= $self->{_hMachineTypeId};
    }
    $s .= ",";
    $s .= "hServerType=";
    if (defined $self->{_hServerType}) {
        $s .= $self->{_hServerType};
    }
    $s .= ",";
    $s .= "hCpuMIPS=";
    if (defined $self->{_hCpuMIPS}) {
        $s .= $self->{_hCpuMIPS};
    }
    $s .= ",";
    $s .= "hCpuGartnerMIPS=";
    if (defined $self->{_hCpuGartnerMIPS}) {
        $s .= $self->{_hCpuGartnerMIPS};
    }
    $s .= ",";
    $s .= "hCpuMSU=";
    if (defined $self->{_hCpuMSU}) {
        $s .= $self->{_hCpuMSU};
    }
    $s .= ",";
    $s .= "hCpuIFL=";
    if (defined $self->{_hCpuIFL}) {
        $s .= $self->{_hCpuIFL};
    }
    $s .= ",";
    $s .= "hOwner=";
    if (defined $self->{_hOwner}) {
        $s .= $self->{_hOwner};
    }
    $s .= ",";
    $s .= "mtType=";
    if (defined $self->{_mtType}) {
        $s .= $self->{_mtType};
    }
    $s .= ",";
    $s .= "hlId=";
    if (defined $self->{_hlId}) {
        $s .= $self->{_hlId};
    }
    $s .= ",";
    $s .= "hlStatus=";
    if (defined $self->{_hlStatus}) {
        $s .= $self->{_hlStatus};
    }
    $s .= ",";
    $s .= "hlName=";
    if (defined $self->{_hlName}) {
        $s .= $self->{_hlName};
    }
    $s .= ",";
    $s .= "hlPartMIPS=";
    if (defined $self->{_hlPartMIPS}) {
        $s .= $self->{_hlPartMIPS};
    }
    $s .= ",";
    $s .= "hlPartGartnerMIPS=";
    if (defined $self->{_hlPartGartnerMIPS}) {
        $s .= $self->{_hlPartGartnerMIPS};
    }
    $s .= ",";
    $s .= "hlPartMSU=";
    if (defined $self->{_hlPartMSU}) {
        $s .= $self->{_hlPartMSU};
    }
    $s .= ",";
    $s .= "slId=";
    if (defined $self->{_slId}) {
        $s .= $self->{_slId};
    }
    $s .= ",";
    $s .= "cId=";
    if (defined $self->{_cId}) {
        $s .= $self->{_cId};
    }
    $s .= ",";
    $s .= "slName=";
    if (defined $self->{_slName}) {
        $s .= $self->{_slName};
    }
    $s .= ",";
    $s .= "slStatus=";
    if (defined $self->{_slStatus}) {
        $s .= $self->{_slStatus};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
    }
    $s .= ",";
    $s .= "sId=";
    if (defined $self->{_sId}) {
        $s .= $self->{_sId};
    }
    $s .= ",";
    $s .= "sName=";
    if (defined $self->{_sName}) {
        $s .= $self->{_sName};
    }
    $s .= ",";
    $s .= "sStatus=";
    if (defined $self->{_sStatus}) {
        $s .= $self->{_sStatus};
    }
    $s .= ",";
    $s .= "sPriority=";
    if (defined $self->{_sPriority}) {
        $s .= $self->{_sPriority};
    }
    $s .= ",";
    $s .= "sLevel=";
    if (defined $self->{_sLevel}) {
        $s .= $self->{_sLevel};
    }
    $s .= ",";
    $s .= "sVendorMgd=";
    if (defined $self->{_sVendorMgd}) {
        $s .= $self->{_sVendorMgd};
    }
    $s .= ",";
    $s .= "sMfgId=";
    if (defined $self->{_sMfgId}) {
        $s .= $self->{_sMfgId};
    }
    $s .= ",";
    $s .= "sMfg=";
    if (defined $self->{_sMfg}) {
        $s .= $self->{_sMfg};
    }
    $s .= ",";
    $s .= "scName=";
    if (defined $self->{_scName}) {
        $s .= $self->{_scName};
    }
    $s .= ",";
    $s .= "scParent=";
    if (defined $self->{_scParent}) {
        $s .= $self->{_scParent};
    }
    $s .= ",";
    $s .= "scChildren=";
    if (defined $self->{_scChildren}) {
        $s .= $self->{_scChildren};
    }
    $s .= ",";
    $s .= "bpIds=";
    if (defined $self->{_bpIds}) {
        $s .= $self->{_bpIds};
    }
    $s .= ",";
    $s .= "bcSwIds=";
    if (defined $self->{_bcSwIds}) {
        $s .= $self->{_bcSwIds};
    }
    $s .= ",";
    $s .= "bParent=";
    if (defined $self->{_bParent}) {
        $s .= $self->{_bParent};
    }
    $s .= ",";
    $s .= "bChildren=";
    if (defined $self->{_bChildren}) {
        $s .= $self->{_bChildren};
    }
    $s .= ",";
    $s .= "rId=";
    if (defined $self->{_rId}) {
        $s .= $self->{_rId};
    }
    $s .= ",";
    $s .= "rTypeId=";
    if (defined $self->{_rTypeId}) {
        $s .= $self->{_rTypeId};
    }
    $s .= ",";
    $s .= "rParentInstSwId=";
    if (defined $self->{_rParentInstSwId}) {
        $s .= $self->{_rParentInstSwId};
    }
    $s .= ",";
    $s .= "rMachineLevel=";
    if (defined $self->{_rMachineLevel}) {
        $s .= $self->{_rMachineLevel};
    }
    $s .= ",";
    $s .= "rIsManual=";
    if (defined $self->{_rIsManual}) {
        $s .= $self->{_rIsManual};
    }
    $s .= ",";
    $s .= "licsToRecon=";
    if (defined $self->{_licsToRecon}) {
        $s .= $self->{_licsToRecon};
    }
    $s .= ",";
    $s .= "scopeName=";
    if (defined $self->{_scopeName}) {
        $s .= $self->{_scopeName};
    }
    $s .= ",";
    $s .= "scheduleFlevel=";
    if (defined $self->{_scheduleFlevel}) {
        $s .= $self->{_scheduleFlevel};
    }
    $s .= ",";
    $s .= "expectedAlertType=";
    if (defined $self->{_expectedAlertType}) {
        $s .= $self->{_expectedAlertType};
    }
    $s .= ",";
    chop $s;
    return $s;
}


1;
