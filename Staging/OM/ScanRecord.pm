package Staging::OM::ScanRecord;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_computerId => undef
        ,_name => undef
        ,_objectId => undef
        ,_model => undef
        ,_serialNumber => undef
        ,_scanTime => undef
        ,_osName => undef
        ,_osType => undef
        ,_osMajor => undef
        ,_osMinor => undef
        ,_osSub => undef
        ,_osInstDate => undef
        ,_userName => undef
        ,_biosManufacturer => undef
        ,_biosModel => undef
        ,_serverType => undef
        ,_techImgId => undef
        ,_extId => undef
        ,_memory => undef
        ,_disk => undef
        ,_dedicatedProcessors => undef
        ,_totalProcessors => undef
        ,_sharedProcessors => undef
        ,_processorType => undef
        ,_sharedProcByCores => undef
        ,_dedicatedProcByCores => undef
        ,_totalProcByCores => undef
        ,_alias => undef
        ,_physicalTotalKb => undef
        ,_virtualMemory => undef
        ,_physicalFreeMemory => undef
        ,_virtualFreeMemory => undef
        ,_nodeCapacity => undef
        ,_lparCapacity => undef
        ,_biosDate => undef
        ,_biosSerialNumber => undef
        ,_biosUniqueId => undef
        ,_boardSerial => undef
        ,_caseSerial => undef
        ,_caseAssetTag => undef
        ,_powerOnPassword => undef
        ,_users => undef
        ,_authenticated => undef
        ,_processorCount => undef
        ,_bankAccountId => undef
        ,_action => undef
        ,_isManual => undef
        ,_table => 'scan_record'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->computerId && defined $object->computerId) {
        $equal = 1 if $self->computerId eq $object->computerId;
    }
    $equal = 1 if (!defined $self->computerId && !defined $object->computerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->name && defined $object->name) {
        $equal = 1 if $self->name eq $object->name;
    }
    $equal = 1 if (!defined $self->name && !defined $object->name);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->objectId && defined $object->objectId) {
        $equal = 1 if $self->objectId eq $object->objectId;
    }
    $equal = 1 if (!defined $self->objectId && !defined $object->objectId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->model && defined $object->model) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if (!defined $self->model && !defined $object->model);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serialNumber && defined $object->serialNumber) {
        $equal = 1 if $self->serialNumber eq $object->serialNumber;
    }
    $equal = 1 if (!defined $self->serialNumber && !defined $object->serialNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scanTime && defined $object->scanTime) {
        $equal = 1 if $self->scanTime eq $object->scanTime;
    }
    $equal = 1 if (!defined $self->scanTime && !defined $object->scanTime);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osName && defined $object->osName) {
        $equal = 1 if $self->osName eq $object->osName;
    }
    $equal = 1 if (!defined $self->osName && !defined $object->osName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osType && defined $object->osType) {
        $equal = 1 if $self->osType eq $object->osType;
    }
    $equal = 1 if (!defined $self->osType && !defined $object->osType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osMajor && defined $object->osMajor) {
        $equal = 1 if $self->osMajor eq $object->osMajor;
    }
    $equal = 1 if (!defined $self->osMajor && !defined $object->osMajor);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osMinor && defined $object->osMinor) {
        $equal = 1 if $self->osMinor eq $object->osMinor;
    }
    $equal = 1 if (!defined $self->osMinor && !defined $object->osMinor);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osSub && defined $object->osSub) {
        $equal = 1 if $self->osSub eq $object->osSub;
    }
    $equal = 1 if (!defined $self->osSub && !defined $object->osSub);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->osInstDate && defined $object->osInstDate) {
        $equal = 1 if $self->osInstDate eq $object->osInstDate;
    }
    $equal = 1 if (!defined $self->osInstDate && !defined $object->osInstDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->userName && defined $object->userName) {
        $equal = 1 if $self->userName eq $object->userName;
    }
    $equal = 1 if (!defined $self->userName && !defined $object->userName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->biosManufacturer && defined $object->biosManufacturer) {
        $equal = 1 if $self->biosManufacturer eq $object->biosManufacturer;
    }
    $equal = 1 if (!defined $self->biosManufacturer && !defined $object->biosManufacturer);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->biosModel && defined $object->biosModel) {
        $equal = 1 if $self->biosModel eq $object->biosModel;
    }
    $equal = 1 if (!defined $self->biosModel && !defined $object->biosModel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serverType && defined $object->serverType) {
        $equal = 1 if $self->serverType eq $object->serverType;
    }
    $equal = 1 if (!defined $self->serverType && !defined $object->serverType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->techImgId && defined $object->techImgId) {
        $equal = 1 if $self->techImgId eq $object->techImgId;
    }
    $equal = 1 if (!defined $self->techImgId && !defined $object->techImgId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->extId && defined $object->extId) {
        $equal = 1 if $self->extId eq $object->extId;
    }
    $equal = 1 if (!defined $self->extId && !defined $object->extId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->memory && defined $object->memory) {
        $equal = 1 if $self->memory eq $object->memory;
    }
    $equal = 1 if (!defined $self->memory && !defined $object->memory);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->disk && defined $object->disk) {
        $equal = 1 if $self->disk eq $object->disk;
    }
    $equal = 1 if (!defined $self->disk && !defined $object->disk);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->dedicatedProcessors && defined $object->dedicatedProcessors) {
        $equal = 1 if $self->dedicatedProcessors eq $object->dedicatedProcessors;
    }
    $equal = 1 if (!defined $self->dedicatedProcessors && !defined $object->dedicatedProcessors);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->totalProcessors && defined $object->totalProcessors) {
        $equal = 1 if $self->totalProcessors eq $object->totalProcessors;
    }
    $equal = 1 if (!defined $self->totalProcessors && !defined $object->totalProcessors);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sharedProcessors && defined $object->sharedProcessors) {
        $equal = 1 if $self->sharedProcessors eq $object->sharedProcessors;
    }
    $equal = 1 if (!defined $self->sharedProcessors && !defined $object->sharedProcessors);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorType && defined $object->processorType) {
        $equal = 1 if $self->processorType eq $object->processorType;
    }
    $equal = 1 if (!defined $self->processorType && !defined $object->processorType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sharedProcByCores && defined $object->sharedProcByCores) {
        $equal = 1 if $self->sharedProcByCores eq $object->sharedProcByCores;
    }
    $equal = 1 if (!defined $self->sharedProcByCores && !defined $object->sharedProcByCores);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->dedicatedProcByCores && defined $object->dedicatedProcByCores) {
        $equal = 1 if $self->dedicatedProcByCores eq $object->dedicatedProcByCores;
    }
    $equal = 1 if (!defined $self->dedicatedProcByCores && !defined $object->dedicatedProcByCores);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->totalProcByCores && defined $object->totalProcByCores) {
        $equal = 1 if $self->totalProcByCores eq $object->totalProcByCores;
    }
    $equal = 1 if (!defined $self->totalProcByCores && !defined $object->totalProcByCores);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->alias && defined $object->alias) {
        $equal = 1 if $self->alias eq $object->alias;
    }
    $equal = 1 if (!defined $self->alias && !defined $object->alias);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->physicalTotalKb && defined $object->physicalTotalKb) {
        $equal = 1 if $self->physicalTotalKb eq $object->physicalTotalKb;
    }
    $equal = 1 if (!defined $self->physicalTotalKb && !defined $object->physicalTotalKb);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->virtualMemory && defined $object->virtualMemory) {
        $equal = 1 if $self->virtualMemory eq $object->virtualMemory;
    }
    $equal = 1 if (!defined $self->virtualMemory && !defined $object->virtualMemory);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->physicalFreeMemory && defined $object->physicalFreeMemory) {
        $equal = 1 if $self->physicalFreeMemory eq $object->physicalFreeMemory;
    }
    $equal = 1 if (!defined $self->physicalFreeMemory && !defined $object->physicalFreeMemory);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->virtualFreeMemory && defined $object->virtualFreeMemory) {
        $equal = 1 if $self->virtualFreeMemory eq $object->virtualFreeMemory;
    }
    $equal = 1 if (!defined $self->virtualFreeMemory && !defined $object->virtualFreeMemory);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->nodeCapacity && defined $object->nodeCapacity) {
        $equal = 1 if $self->nodeCapacity eq $object->nodeCapacity;
    }
    $equal = 1 if (!defined $self->nodeCapacity && !defined $object->nodeCapacity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lparCapacity && defined $object->lparCapacity) {
        $equal = 1 if $self->lparCapacity eq $object->lparCapacity;
    }
    $equal = 1 if (!defined $self->lparCapacity && !defined $object->lparCapacity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->biosDate && defined $object->biosDate) {
        $equal = 1 if $self->biosDate eq $object->biosDate;
    }
    $equal = 1 if (!defined $self->biosDate && !defined $object->biosDate);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->biosSerialNumber && defined $object->biosSerialNumber) {
        $equal = 1 if $self->biosSerialNumber eq $object->biosSerialNumber;
    }
    $equal = 1 if (!defined $self->biosSerialNumber && !defined $object->biosSerialNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->biosUniqueId && defined $object->biosUniqueId) {
        $equal = 1 if $self->biosUniqueId eq $object->biosUniqueId;
    }
    $equal = 1 if (!defined $self->biosUniqueId && !defined $object->biosUniqueId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->boardSerial && defined $object->boardSerial) {
        $equal = 1 if $self->boardSerial eq $object->boardSerial;
    }
    $equal = 1 if (!defined $self->boardSerial && !defined $object->boardSerial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->caseSerial && defined $object->caseSerial) {
        $equal = 1 if $self->caseSerial eq $object->caseSerial;
    }
    $equal = 1 if (!defined $self->caseSerial && !defined $object->caseSerial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->caseAssetTag && defined $object->caseAssetTag) {
        $equal = 1 if $self->caseAssetTag eq $object->caseAssetTag;
    }
    $equal = 1 if (!defined $self->caseAssetTag && !defined $object->caseAssetTag);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->powerOnPassword && defined $object->powerOnPassword) {
        $equal = 1 if $self->powerOnPassword eq $object->powerOnPassword;
    }
    $equal = 1 if (!defined $self->powerOnPassword && !defined $object->powerOnPassword);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->users && defined $object->users) {
        $equal = 1 if $self->users eq $object->users;
    }
    $equal = 1 if (!defined $self->users && !defined $object->users);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->authenticated && defined $object->authenticated) {
        $equal = 1 if $self->authenticated eq $object->authenticated;
    }
    $equal = 1 if (!defined $self->authenticated && !defined $object->authenticated);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorCount && defined $object->processorCount) {
        $equal = 1 if $self->processorCount eq $object->processorCount;
    }
    $equal = 1 if (!defined $self->processorCount && !defined $object->processorCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->bankAccountId && defined $object->bankAccountId) {
        $equal = 1 if $self->bankAccountId eq $object->bankAccountId;
    }
    $equal = 1 if (!defined $self->bankAccountId && !defined $object->bankAccountId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->isManual && defined $object->isManual) {
        $equal = 1 if $self->isManual eq $object->isManual;
    }
    $equal = 1 if (!defined $self->isManual && !defined $object->isManual);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub computerId {
    my $self = shift;
    $self->{_computerId} = shift if scalar @_ == 1;
    return $self->{_computerId};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub objectId {
    my $self = shift;
    $self->{_objectId} = shift if scalar @_ == 1;
    return $self->{_objectId};
}

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub serialNumber {
    my $self = shift;
    $self->{_serialNumber} = shift if scalar @_ == 1;
    return $self->{_serialNumber};
}

sub scanTime {
    my $self = shift;
    $self->{_scanTime} = shift if scalar @_ == 1;
    return $self->{_scanTime};
}

sub osName {
    my $self = shift;
    $self->{_osName} = shift if scalar @_ == 1;
    return $self->{_osName};
}

sub osType {
    my $self = shift;
    $self->{_osType} = shift if scalar @_ == 1;
    return $self->{_osType};
}

sub osMajor {
    my $self = shift;
    $self->{_osMajor} = shift if scalar @_ == 1;
    return $self->{_osMajor};
}

sub osMinor {
    my $self = shift;
    $self->{_osMinor} = shift if scalar @_ == 1;
    return $self->{_osMinor};
}

sub osSub {
    my $self = shift;
    $self->{_osSub} = shift if scalar @_ == 1;
    return $self->{_osSub};
}

sub osInstDate {
    my $self = shift;
    $self->{_osInstDate} = shift if scalar @_ == 1;
    return $self->{_osInstDate};
}

sub userName {
    my $self = shift;
    $self->{_userName} = shift if scalar @_ == 1;
    return $self->{_userName};
}

sub biosManufacturer {
    my $self = shift;
    $self->{_biosManufacturer} = shift if scalar @_ == 1;
    return $self->{_biosManufacturer};
}

sub biosModel {
    my $self = shift;
    $self->{_biosModel} = shift if scalar @_ == 1;
    return $self->{_biosModel};
}

sub serverType {
    my $self = shift;
    $self->{_serverType} = shift if scalar @_ == 1;
    return $self->{_serverType};
}

sub techImgId {
    my $self = shift;
    $self->{_techImgId} = shift if scalar @_ == 1;
    return $self->{_techImgId};
}

sub extId {
    my $self = shift;
    $self->{_extId} = shift if scalar @_ == 1;
    return $self->{_extId};
}

sub memory {
    my $self = shift;
    $self->{_memory} = shift if scalar @_ == 1;
    return $self->{_memory};
}

sub disk {
    my $self = shift;
    $self->{_disk} = shift if scalar @_ == 1;
    return $self->{_disk};
}

sub dedicatedProcessors {
    my $self = shift;
    $self->{_dedicatedProcessors} = shift if scalar @_ == 1;
    return $self->{_dedicatedProcessors};
}

sub totalProcessors {
    my $self = shift;
    $self->{_totalProcessors} = shift if scalar @_ == 1;
    return $self->{_totalProcessors};
}

sub sharedProcessors {
    my $self = shift;
    $self->{_sharedProcessors} = shift if scalar @_ == 1;
    return $self->{_sharedProcessors};
}

sub processorType {
    my $self = shift;
    $self->{_processorType} = shift if scalar @_ == 1;
    return $self->{_processorType};
}

sub sharedProcByCores {
    my $self = shift;
    $self->{_sharedProcByCores} = shift if scalar @_ == 1;
    return $self->{_sharedProcByCores};
}

sub dedicatedProcByCores {
    my $self = shift;
    $self->{_dedicatedProcByCores} = shift if scalar @_ == 1;
    return $self->{_dedicatedProcByCores};
}

sub totalProcByCores {
    my $self = shift;
    $self->{_totalProcByCores} = shift if scalar @_ == 1;
    return $self->{_totalProcByCores};
}

sub alias {
    my $self = shift;
    $self->{_alias} = shift if scalar @_ == 1;
    return $self->{_alias};
}

sub physicalTotalKb {
    my $self = shift;
    $self->{_physicalTotalKb} = shift if scalar @_ == 1;
    return $self->{_physicalTotalKb};
}

sub virtualMemory {
    my $self = shift;
    $self->{_virtualMemory} = shift if scalar @_ == 1;
    return $self->{_virtualMemory};
}

sub physicalFreeMemory {
    my $self = shift;
    $self->{_physicalFreeMemory} = shift if scalar @_ == 1;
    return $self->{_physicalFreeMemory};
}

sub virtualFreeMemory {
    my $self = shift;
    $self->{_virtualFreeMemory} = shift if scalar @_ == 1;
    return $self->{_virtualFreeMemory};
}

sub nodeCapacity {
    my $self = shift;
    $self->{_nodeCapacity} = shift if scalar @_ == 1;
    return $self->{_nodeCapacity};
}

sub lparCapacity {
    my $self = shift;
    $self->{_lparCapacity} = shift if scalar @_ == 1;
    return $self->{_lparCapacity};
}

sub biosDate {
    my $self = shift;
    $self->{_biosDate} = shift if scalar @_ == 1;
    return $self->{_biosDate};
}

sub biosSerialNumber {
    my $self = shift;
    $self->{_biosSerialNumber} = shift if scalar @_ == 1;
    return $self->{_biosSerialNumber};
}

sub biosUniqueId {
    my $self = shift;
    $self->{_biosUniqueId} = shift if scalar @_ == 1;
    return $self->{_biosUniqueId};
}

sub boardSerial {
    my $self = shift;
    $self->{_boardSerial} = shift if scalar @_ == 1;
    return $self->{_boardSerial};
}

sub caseSerial {
    my $self = shift;
    $self->{_caseSerial} = shift if scalar @_ == 1;
    return $self->{_caseSerial};
}

sub caseAssetTag {
    my $self = shift;
    $self->{_caseAssetTag} = shift if scalar @_ == 1;
    return $self->{_caseAssetTag};
}

sub powerOnPassword {
    my $self = shift;
    $self->{_powerOnPassword} = shift if scalar @_ == 1;
    return $self->{_powerOnPassword};
}

sub users {
    my $self = shift;
    $self->{_users} = shift if scalar @_ == 1;
    return $self->{_users};
}

sub authenticated {
    my $self = shift;
    $self->{_authenticated} = shift if scalar @_ == 1;
    return $self->{_authenticated};
}

sub processorCount {
    my $self = shift;
    $self->{_processorCount} = shift if scalar @_ == 1;
    return $self->{_processorCount};
}

sub bankAccountId {
    my $self = shift;
    $self->{_bankAccountId} = shift if scalar @_ == 1;
    return $self->{_bankAccountId};
}

sub action {
    my $self = shift;
    $self->{_action} = shift if scalar @_ == 1;
    return $self->{_action};
}

sub isManual {
    my $self = shift;
    $self->{_isManual} = shift if scalar @_ == 1;
    return $self->{_isManual};
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
    my $s = "[ScanRecord] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "computerId=";
    if (defined $self->{_computerId}) {
        $s .= $self->{_computerId};
    }
    $s .= ",";
    $s .= "name=";
    if (defined $self->{_name}) {
        $s .= $self->{_name};
    }
    $s .= ",";
    $s .= "objectId=";
    if (defined $self->{_objectId}) {
        $s .= $self->{_objectId};
    }
    $s .= ",";
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "serialNumber=";
    if (defined $self->{_serialNumber}) {
        $s .= $self->{_serialNumber};
    }
    $s .= ",";
    $s .= "scanTime=";
    if (defined $self->{_scanTime}) {
        $s .= $self->{_scanTime};
    }
    $s .= ",";
    $s .= "osName=";
    if (defined $self->{_osName}) {
        $s .= $self->{_osName};
    }
    $s .= ",";
    $s .= "osType=";
    if (defined $self->{_osType}) {
        $s .= $self->{_osType};
    }
    $s .= ",";
    $s .= "osMajor=";
    if (defined $self->{_osMajor}) {
        $s .= $self->{_osMajor};
    }
    $s .= ",";
    $s .= "osMinor=";
    if (defined $self->{_osMinor}) {
        $s .= $self->{_osMinor};
    }
    $s .= ",";
    $s .= "osSub=";
    if (defined $self->{_osSub}) {
        $s .= $self->{_osSub};
    }
    $s .= ",";
    $s .= "osInstDate=";
    if (defined $self->{_osInstDate}) {
        $s .= $self->{_osInstDate};
    }
    $s .= ",";
    $s .= "userName=";
    if (defined $self->{_userName}) {
        $s .= $self->{_userName};
    }
    $s .= ",";
    $s .= "biosManufacturer=";
    if (defined $self->{_biosManufacturer}) {
        $s .= $self->{_biosManufacturer};
    }
    $s .= ",";
    $s .= "biosModel=";
    if (defined $self->{_biosModel}) {
        $s .= $self->{_biosModel};
    }
    $s .= ",";
    $s .= "serverType=";
    if (defined $self->{_serverType}) {
        $s .= $self->{_serverType};
    }
    $s .= ",";
    $s .= "techImgId=";
    if (defined $self->{_techImgId}) {
        $s .= $self->{_techImgId};
    }
    $s .= ",";
    $s .= "extId=";
    if (defined $self->{_extId}) {
        $s .= $self->{_extId};
    }
    $s .= ",";
    $s .= "memory=";
    if (defined $self->{_memory}) {
        $s .= $self->{_memory};
    }
    $s .= ",";
    $s .= "disk=";
    if (defined $self->{_disk}) {
        $s .= $self->{_disk};
    }
    $s .= ",";
    $s .= "dedicatedProcessors=";
    if (defined $self->{_dedicatedProcessors}) {
        $s .= $self->{_dedicatedProcessors};
    }
    $s .= ",";
    $s .= "totalProcessors=";
    if (defined $self->{_totalProcessors}) {
        $s .= $self->{_totalProcessors};
    }
    $s .= ",";
    $s .= "sharedProcessors=";
    if (defined $self->{_sharedProcessors}) {
        $s .= $self->{_sharedProcessors};
    }
    $s .= ",";
    $s .= "processorType=";
    if (defined $self->{_processorType}) {
        $s .= $self->{_processorType};
    }
    $s .= ",";
    $s .= "sharedProcByCores=";
    if (defined $self->{_sharedProcByCores}) {
        $s .= $self->{_sharedProcByCores};
    }
    $s .= ",";
    $s .= "dedicatedProcByCores=";
    if (defined $self->{_dedicatedProcByCores}) {
        $s .= $self->{_dedicatedProcByCores};
    }
    $s .= ",";
    $s .= "totalProcByCores=";
    if (defined $self->{_totalProcByCores}) {
        $s .= $self->{_totalProcByCores};
    }
    $s .= ",";
    $s .= "alias=";
    if (defined $self->{_alias}) {
        $s .= $self->{_alias};
    }
    $s .= ",";
    $s .= "physicalTotalKb=";
    if (defined $self->{_physicalTotalKb}) {
        $s .= $self->{_physicalTotalKb};
    }
    $s .= ",";
    $s .= "virtualMemory=";
    if (defined $self->{_virtualMemory}) {
        $s .= $self->{_virtualMemory};
    }
    $s .= ",";
    $s .= "physicalFreeMemory=";
    if (defined $self->{_physicalFreeMemory}) {
        $s .= $self->{_physicalFreeMemory};
    }
    $s .= ",";
    $s .= "virtualFreeMemory=";
    if (defined $self->{_virtualFreeMemory}) {
        $s .= $self->{_virtualFreeMemory};
    }
    $s .= ",";
    $s .= "nodeCapacity=";
    if (defined $self->{_nodeCapacity}) {
        $s .= $self->{_nodeCapacity};
    }
    $s .= ",";
    $s .= "lparCapacity=";
    if (defined $self->{_lparCapacity}) {
        $s .= $self->{_lparCapacity};
    }
    $s .= ",";
    $s .= "biosDate=";
    if (defined $self->{_biosDate}) {
        $s .= $self->{_biosDate};
    }
    $s .= ",";
    $s .= "biosSerialNumber=";
    if (defined $self->{_biosSerialNumber}) {
        $s .= $self->{_biosSerialNumber};
    }
    $s .= ",";
    $s .= "biosUniqueId=";
    if (defined $self->{_biosUniqueId}) {
        $s .= $self->{_biosUniqueId};
    }
    $s .= ",";
    $s .= "boardSerial=";
    if (defined $self->{_boardSerial}) {
        $s .= $self->{_boardSerial};
    }
    $s .= ",";
    $s .= "caseSerial=";
    if (defined $self->{_caseSerial}) {
        $s .= $self->{_caseSerial};
    }
    $s .= ",";
    $s .= "caseAssetTag=";
    if (defined $self->{_caseAssetTag}) {
        $s .= $self->{_caseAssetTag};
    }
    $s .= ",";
    $s .= "powerOnPassword=";
    if (defined $self->{_powerOnPassword}) {
        $s .= $self->{_powerOnPassword};
    }
    $s .= ",";
    $s .= "users=";
    if (defined $self->{_users}) {
        $s .= $self->{_users};
    }
    $s .= ",";
    $s .= "authenticated=";
    if (defined $self->{_authenticated}) {
        $s .= $self->{_authenticated};
    }
    $s .= ",";
    $s .= "processorCount=";
    if (defined $self->{_processorCount}) {
        $s .= $self->{_processorCount};
    }
    $s .= ",";
    $s .= "bankAccountId=";
    if (defined $self->{_bankAccountId}) {
        $s .= $self->{_bankAccountId};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "isManual=";
    if (defined $self->{_isManual}) {
        $s .= $self->{_isManual};
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
        my $sth = $connection->sql->{insertScanRecord};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->computerId
            ,$self->name
            ,$self->objectId
            ,$self->model
            ,$self->serialNumber
            ,$self->scanTime
            ,$self->osName
            ,$self->osType
            ,$self->osMajor
            ,$self->osMinor
            ,$self->osSub
            ,$self->osInstDate
            ,$self->userName
            ,$self->biosManufacturer
            ,$self->biosModel
            ,$self->serverType
            ,$self->techImgId
            ,$self->extId
            ,$self->memory
            ,$self->disk
            ,$self->dedicatedProcessors
            ,$self->totalProcessors
            ,$self->sharedProcessors
            ,$self->processorType
            ,$self->sharedProcByCores
            ,$self->dedicatedProcByCores
            ,$self->totalProcByCores
            ,$self->alias
            ,$self->physicalTotalKb
            ,$self->virtualMemory
            ,$self->physicalFreeMemory
            ,$self->virtualFreeMemory
            ,$self->nodeCapacity
            ,$self->lparCapacity
            ,$self->biosDate
            ,$self->biosSerialNumber
            ,$self->biosUniqueId
            ,$self->boardSerial
            ,$self->caseSerial
            ,$self->caseAssetTag
            ,$self->powerOnPassword
            ,$self->users
            ,$self->authenticated
            ,$self->processorCount
            ,$self->bankAccountId
            ,$self->action
            ,$self->isManual
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateScanRecord};
        $sth->execute(
            $self->computerId
            ,$self->name
            ,$self->objectId
            ,$self->model
            ,$self->serialNumber
            ,$self->scanTime
            ,$self->osName
            ,$self->osType
            ,$self->osMajor
            ,$self->osMinor
            ,$self->osSub
            ,$self->osInstDate
            ,$self->userName
            ,$self->biosManufacturer
            ,$self->biosModel
            ,$self->serverType
            ,$self->techImgId
            ,$self->extId
            ,$self->memory
            ,$self->disk
            ,$self->dedicatedProcessors
            ,$self->totalProcessors
            ,$self->sharedProcessors
            ,$self->processorType
            ,$self->sharedProcByCores
            ,$self->dedicatedProcByCores
            ,$self->totalProcByCores
            ,$self->alias
            ,$self->physicalTotalKb
            ,$self->virtualMemory
            ,$self->physicalFreeMemory
            ,$self->virtualFreeMemory
            ,$self->nodeCapacity
            ,$self->lparCapacity
            ,$self->biosDate
            ,$self->biosSerialNumber
            ,$self->biosUniqueId
            ,$self->boardSerial
            ,$self->caseSerial
            ,$self->caseAssetTag
            ,$self->powerOnPassword
            ,$self->users
            ,$self->authenticated
            ,$self->processorCount
            ,$self->bankAccountId
            ,$self->action
            ,$self->isManual
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
        insert into scan_record (
            computer_id
            ,name
            ,object_id
            ,model
            ,serial_number
            ,scan_time
            ,os_name
            ,os_type
            ,os_major_vers
            ,os_minor_vers
            ,os_sub_vers
            ,os_inst_date
            ,user_name
            ,bios_manufacturer
            ,bios_model
            ,server_type
            ,tech_img_id
            ,ext_id
            ,memory
            ,disk
            ,dedicated_processors
            ,total_processors
            ,shared_processors
            ,processor_type
            ,shared_proc_by_cores
            ,dedicated_proc_by_cores
            ,total_proc_by_cores
            ,alias
            ,physical_total_kb
            ,virtual_memory
            ,physical_free_memory
            ,virtual_free_memory
            ,node_capacity
            ,lpar_capacity
            ,bios_date
            ,bios_serial_number
            ,bios_unique_id
            ,board_serial
            ,case_serial
            ,case_asset_tag
            ,power_on_password
            ,users
            ,authenticated
            ,processor_count
            ,bank_account_id
            ,action
            ,is_manual
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
    return ('insertScanRecord', $query);
}

sub queryUpdate {
    my $query = '
        update scan_record
        set
            computer_id = ?
            ,name = ?
            ,object_id = ?
            ,model = ?
            ,serial_number = ?
            ,scan_time = ?
            ,os_name = ?
            ,os_type = ?
            ,os_major_vers = ?
            ,os_minor_vers = ?
            ,os_sub_vers = ?
            ,os_inst_date = ?
            ,user_name = ?
            ,bios_manufacturer = ?
            ,bios_model = ?
            ,server_type = ?
            ,tech_img_id = ?
            ,ext_id = ?
            ,memory = ?
            ,disk = ?
            ,dedicated_processors = ?
            ,total_processors = ?
            ,shared_processors = ?
            ,processor_type = ?
            ,shared_proc_by_cores = ?
            ,dedicated_proc_by_cores = ?
            ,total_proc_by_cores = ?
            ,alias = ?
            ,physical_total_kb = ?
            ,virtual_memory = ?
            ,physical_free_memory = ?
            ,virtual_free_memory = ?
            ,node_capacity = ?
            ,lpar_capacity = ?
            ,bios_date = ?
            ,bios_serial_number = ?
            ,bios_unique_id = ?
            ,board_serial = ?
            ,case_serial = ?
            ,case_asset_tag = ?
            ,power_on_password = ?
            ,users = ?
            ,authenticated = ?
            ,processor_count = ?
            ,bank_account_id = ?
            ,action = ?
            ,is_manual = ?
        where
            id = ?
    ';
    return ('updateScanRecord', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteScanRecord};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from scan_record a where
            a.id = ?
    ';
    return ('deleteScanRecord', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyScanRecord};
    my $computerId;
    my $name;
    my $objectId;
    my $model;
    my $serialNumber;
    my $scanTime;
    my $osName;
    my $osType;
    my $osMajor;
    my $osMinor;
    my $osSub;
    my $osInstDate;
    my $userName;
    my $biosManufacturer;
    my $biosModel;
    my $serverType;
    my $techImgId;
    my $extId;
    my $memory;
    my $disk;
    my $dedicatedProcessors;
    my $totalProcessors;
    my $sharedProcessors;
    my $processorType;
    my $sharedProcByCores;
    my $dedicatedProcByCores;
    my $totalProcByCores;
    my $alias;
    my $physicalTotalKb;
    my $virtualMemory;
    my $physicalFreeMemory;
    my $virtualFreeMemory;
    my $nodeCapacity;
    my $lparCapacity;
    my $biosDate;
    my $biosSerialNumber;
    my $biosUniqueId;
    my $boardSerial;
    my $caseSerial;
    my $caseAssetTag;
    my $powerOnPassword;
    my $users;
    my $authenticated;
    my $processorCount;
    my $bankAccountId;
    my $action;
    my $isManual;
    $sth->bind_columns(
        \$computerId
        ,\$name
        ,\$objectId
        ,\$model
        ,\$serialNumber
        ,\$scanTime
        ,\$osName
        ,\$osType
        ,\$osMajor
        ,\$osMinor
        ,\$osSub
        ,\$osInstDate
        ,\$userName
        ,\$biosManufacturer
        ,\$biosModel
        ,\$serverType
        ,\$techImgId
        ,\$extId
        ,\$memory
        ,\$disk
        ,\$dedicatedProcessors
        ,\$totalProcessors
        ,\$sharedProcessors
        ,\$processorType
        ,\$sharedProcByCores
        ,\$dedicatedProcByCores
        ,\$totalProcByCores
        ,\$alias
        ,\$physicalTotalKb
        ,\$virtualMemory
        ,\$physicalFreeMemory
        ,\$virtualFreeMemory
        ,\$nodeCapacity
        ,\$lparCapacity
        ,\$biosDate
        ,\$biosSerialNumber
        ,\$biosUniqueId
        ,\$boardSerial
        ,\$caseSerial
        ,\$caseAssetTag
        ,\$powerOnPassword
        ,\$users
        ,\$authenticated
        ,\$processorCount
        ,\$bankAccountId
        ,\$action
        ,\$isManual
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->computerId($computerId);
    $self->name($name);
    $self->objectId($objectId);
    $self->model($model);
    $self->serialNumber($serialNumber);
    $self->scanTime($scanTime);
    $self->osName($osName);
    $self->osType($osType);
    $self->osMajor($osMajor);
    $self->osMinor($osMinor);
    $self->osSub($osSub);
    $self->osInstDate($osInstDate);
    $self->userName($userName);
    $self->biosManufacturer($biosManufacturer);
    $self->biosModel($biosModel);
    $self->serverType($serverType);
    $self->techImgId($techImgId);
    $self->extId($extId);
    $self->memory($memory);
    $self->disk($disk);
    $self->dedicatedProcessors($dedicatedProcessors);
    $self->totalProcessors($totalProcessors);
    $self->sharedProcessors($sharedProcessors);
    $self->processorType($processorType);
    $self->sharedProcByCores($sharedProcByCores);
    $self->dedicatedProcByCores($dedicatedProcByCores);
    $self->totalProcByCores($totalProcByCores);
    $self->alias($alias);
    $self->physicalTotalKb($physicalTotalKb);
    $self->virtualMemory($virtualMemory);
    $self->physicalFreeMemory($physicalFreeMemory);
    $self->virtualFreeMemory($virtualFreeMemory);
    $self->nodeCapacity($nodeCapacity);
    $self->lparCapacity($lparCapacity);
    $self->biosDate($biosDate);
    $self->biosSerialNumber($biosSerialNumber);
    $self->biosUniqueId($biosUniqueId);
    $self->boardSerial($boardSerial);
    $self->caseSerial($caseSerial);
    $self->caseAssetTag($caseAssetTag);
    $self->powerOnPassword($powerOnPassword);
    $self->users($users);
    $self->authenticated($authenticated);
    $self->processorCount($processorCount);
    $self->bankAccountId($bankAccountId);
    $self->action($action);
    $self->isManual($isManual);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            computer_id
            ,name
            ,object_id
            ,model
            ,serial_number
            ,scan_time
            ,os_name
            ,os_type
            ,os_major_vers
            ,os_minor_vers
            ,os_sub_vers
            ,os_inst_date
            ,user_name
            ,bios_manufacturer
            ,bios_model
            ,server_type
            ,tech_img_id
            ,ext_id
            ,memory
            ,disk
            ,dedicated_processors
            ,total_processors
            ,shared_processors
            ,processor_type
            ,shared_proc_by_cores
            ,dedicated_proc_by_cores
            ,total_proc_by_cores
            ,alias
            ,physical_total_kb
            ,virtual_memory
            ,physical_free_memory
            ,virtual_free_memory
            ,node_capacity
            ,lpar_capacity
            ,bios_date
            ,bios_serial_number
            ,bios_unique_id
            ,board_serial
            ,case_serial
            ,case_asset_tag
            ,power_on_password
            ,users
            ,authenticated
            ,processor_count
            ,bank_account_id
            ,action
            ,is_manual
        from
            scan_record
        where
            id = ?
    ';
    return ('getByIdKeyScanRecord', $query);
}

1;
