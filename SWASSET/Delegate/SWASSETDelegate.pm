package SWASSETDelegate;

use strict;
use Base::Utils;
use SWASSET::OM::ManualComputer;
use SWASSET::OM::TLCMZComputer;

sub queryManualComputerData {
	my @fields = (
		"computerSysId", "computerScantime",
		"tmeObjectId",   "tmeObjectLabel",
		"processorCount"
	);
	my $query = '
        select
            a.computer_sys_id
            ,a.computer_scantime
            ,a.tme_object_id
            ,a.tme_object_label
            ,a.processor_count
        from
            manual_computer a
    ';
	dlog("manualComputerData query=$query");
	return ( 'manualComputerData', $query, \@fields );
}

sub queryInstalledManualSoftwareData {
	my @fields = ( "computerSysId", "softwareId", "productVersion", "users" );
	my $query  = '
        select
            a.computer_sys_id
            ,a.software_id
            ,a.prod_version
            ,a.users
        from
            inst_manual_sware a
    ';
	dlog("installedManualSoftwareData query=$query");
	return ( 'installedManualSoftwareData', $query, \@fields );
}

sub queryTLCMZComputerData {
	my @fields = (
		"computerSysId", "computerScantime",
		"tmeObjectId",   "tmeObjectLabel",
		"sysSerNum",     "processorCount"
	);
	my $query = '
        select
            a.computer_sys_id
            ,a.computer_scantime
            ,a.tme_object_id
            ,a.tme_object_label
            ,a.sys_ser_num
            ,a.processor_count
        from
            tlcmz_computer a
    ';
	dlog("tlcmzComputerData query=$query");
	return ( 'tlcmzComputerData', $query, \@fields );
}

sub queryTLCMZSoftwareData {
	my @fields = (
		"tlcmzProductId", "tlcmzProductName",
		"vendorId",       "vendorName",
		"versionGroupId", "productVersion",
		"productRelease", "productEblmtElgFlag",
		"ibmFeatureCode", "productDelIndicator"
	);
	my $query = '
        select
            a.tlcmz_prod_id
            ,a.tlcmz_prod_name
            ,a.vendor_id
            ,a.vendor_name
            ,a.version_group_id
            ,a.prod_version
            ,a.prod_release
            ,a.prod_eblmt_elg_flag
            ,a.ibm_ftr_code
            ,a.prod_del_indctr
        from
            tlcmz_sware a
    ';
	dlog("tlcmzSoftwareData query=$query");
	return ( 'tlcmzSoftwareData', $query, \@fields );
}

sub queryInstalledTLCMZSoftwareData {
	my @fields = ( "computerSysId", "tlcmzProductId" );
	my $query  = '
        select
            a.computer_sys_id
            ,a.tlcmz_prod_id
        from
            inst_tlcmz_sware a
    ';
	dlog("installedTLCMZSoftwareData query=$query");
	return ( 'installedTLCMZSoftwareData', $query, \@fields );
}

sub queryDoranaComputerData {
	my @fields = (
		"computerSysId", "computerScantime",
		"tmeObjectId",   "tmeObjectLabel",
		"sysSerNum",     "processorCount"
	);
	my $query = '
        select
            a.computer_sys_id
            ,a.computer_scantime
            ,a.tme_object_id
            ,a.tme_object_label
            ,a.sys_ser_num
            ,a.processor_count
        from
            dorana_computer a
    ';
	dlog("doranaComputerData query=$query");
	return ( 'doranaComputerData', $query, \@fields );
}

sub queryInstalledDoranaSoftwareData {
	my @fields = ( "computerSysId", "doranaProductId" );
	my $query  = '
        select
            a.computer_sys_id
            ,a.dorana_prod_id
        from
            inst_dorana_sware a
    ';
	dlog("installedDoranaSoftwareData query=$query");
	return ( 'installedDoranaSoftwareData', $query, \@fields );
}

sub getManualSoftwareCountByComputerSysId {
	my ( $self, $connection, $id ) = @_;

	my $count = undef;

	###Prepare and execute the necessary sql
	$connection->prepareSqlQueryAndFields(
		$self->queryManualSoftwareCountByComputerSysId() );
	my $sth = $connection->sql->{manualSoftwareCountByComputerSysId};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{manualSoftwareCountByComputerSysIdFields} } );
	$sth->execute($id);
	while ( $sth->fetchrow_arrayref ) {

		$count = $rec{count};
	}
	$sth->finish;

	return $count;
}

sub queryManualSoftwareCountByComputerSysId {
	my @fields = (qw( count ));
	my $query  = '
        select count(*)
        from inst_manual_sware a
        where a.computer_sys_id = ?
    ';

	return ( 'manualSoftwareCountByComputerSysId', $query, \@fields );
}

1;
