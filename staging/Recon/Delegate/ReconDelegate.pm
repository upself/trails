package Recon::Delegate::ReconDelegate;

use strict;
use Base::Utils;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use Recon::OM::Reconcile;
use Recon::OM::UsedLicense;
use BRAVO::OM::License;
use Recon::Queue;
use Recon::OM::ScarletReconcile;

sub checkRunningProcHash { # compares the hash of running process IDs with actually running processes
						   # returns number of processes deleted from hash, that weren't running
	my $self = shift;
	my $param = shift;
	
	return 0 unless defined $param;
	
#    my %$param = %$param;
	
	my $toreturn=0;
	
	my @runningproc=split ('\n', `ps -A -o pid`);
	
	foreach my $procId (@runningproc) {
		chomp $procId;
#		$procId =~ /^[^ ]+[ ]+([^ ]+)/;
#		$procId = $1;
		$$param{$procId} = 2 if exists $$param{$procId}; # setting value to 2
															 # if the process is found among actually running ones
	}
	
	foreach my $hashnow ( keys %$param ) {
		if ( $$param{$hashnow} == 1 ) { # anything in process hash still value 1 is NOT running
			wlog("$hashnow is in process hash, but not running, deleting from hash!");
			delete $$param{$hashnow};
			$toreturn++;
		} else {
			$$param{$hashnow}=1;
		}
	}
	
	return $toreturn;
}

sub getReconcileTypeMap {
	my ($self) = @_;

	my %data;

	###NOTE: Hard coding these values from the database
	###b/c they are extremely static and this data is
	###required by the recon engine for the recon of
	###every piece of installed software, and the recon
	###engine children are short lived which does not
	###allow for ability to get once and reuse across
	###multiple recons.

	$data{'Manual license allocation'}           = 1;
	$data{'Included with other product'}		 = 4;
	$data{'Automatic license allocation'}        = 5;
	$data{'Vendor managed product'}              = 6;
	$data{'Bundled software product'}            = 7;
	$data{'Covered by software category'}        = 8;
	$data{'Customer owned and customer managed'} = 15;
	$data{'Pending customer decision'}           = 16;
	$data{'IBM owned, managed by 3rd party'}     = 17;
	$data{'Customer owned, managed by 3rd party'}= 18;
	$data{'IBM owned, IBM managed SW consumption based'} = 19;
	$data{'Customer owned, IBM managed SW consumption based'} = 20;

	return \%data;
}

sub getAllocationMethodologyMap {
	my ($self, $extrastring) = @_;

	my %data;
	$extrastring="" unless defined ($extrastring);

	###NOTE: Hard coding these values from the database
	###b/c they are extremely static and this data is
	###required by the recon engine for the recon of
	###every piece of installed software, and the recon
	###engine children are short lived which does not
	###allow for ability to get once and reuse across
	###multiple recons.
	
	$data{'Per LPAR'} = "1".$extrastring;
	$data{'Per processor'} = "2".$extrastring;
	$data{'Per hardware device'} = "3".$extrastring;
	$data{'Per hardware processor'} = "4".$extrastring;
	$data{'Per hardware chip'} = "5".$extrastring;
	$data{'Per PVU'} = "6".$extrastring;
	$data{'Per hardware Gartner MIPS'} = "21".$extrastring;
	$data{'Per LPAR Gartner MIPS'} = "22".$extrastring;
	$data{'Per hardware IBM LSPR MIPS'} = "23".$extrastring;
	$data{'Per LPAR IBM LSPR MIPS'} = "24".$extrastring;
	$data{'Per hardware MSU'} = "25".$extrastring;
	$data{'Per LPAR MSU'} = "26".$extrastring;
	$data{'Per hardware IFL'} = "41".$extrastring;

	return \%data;
}

sub getIBMISVprio {
	my ( $self, $conn, $manu_id, $cust_id ) = @_;
	
	dlog("Detecting expected alert type IBM / ISVPRIO / ISVNOPRIO...");
	
	# reading whether SW manufacturer is considered an IBM brand
		
	my $IBMquery = "select 1 from ibm_brand where manufacturer_id = ? with ur";
	
	$conn->prepareSqlQuery( 'IBMquery', $IBMquery );
	my $sth = $conn->sql->{IBMquery};
	$sth->execute ( $manu_id );
	my ($result) = $sth->fetchrow_array;
	$sth->finish;
	
	if ( ( defined $result ) && ( $result == 1 ) ) {
		dlog("SW manufacturer found in the table IBM_BRAND.");
		return "IBM";
	}
	
	# reading whether SW manufacturer is considered priority (account or global level)
	
	my $ISVquery = "select 1 from priority_isv_sw
						where
							manufacturer_id = ?
						and
							( ( level = 'GLOBAL' and customer_id is null )
							or ( level = 'ACCOUNT' and customer_id = ? ) )
						and
							status_id = 2
						with ur";
	
	$conn->prepareSqlQuery( 'ISVquery', $ISVquery );
	my $sth2 = $conn->sql->{ISVquery};
	$sth2->execute ( $manu_id, $cust_id );
	($result) = $sth2->fetchrow_array;
	$sth2->finish;

	if ( ( defined $result ) && ( $result == 1 ) ) {
		dlog("SW manufacturer found as being priority one.");
		return "ISVPRIO";
	}
	dlog("SW manufacturer not found in IBM brand table nor among the priority ISV manufacturers.");
	return "ISVNOPRIO";
}

sub getScheduleFScope {
	my $self=shift;
	my $connection=shift;
	my $custId=shift;
	my $softName=shift;
	my $hwOwner=shift;
	my $hSerial=shift;
	my $hMachineTypeId=shift;
	my $slName=shift;
	
	my $prioFound=0; # temporary value with the priority of schedule F found, so we don't have to run several cycles
	my $scopeToReturn=undef;
	
	$connection->prepareSqlQueryAndFields(
		$self->queryScheduleFScope() );
	my $sth = $connection->sql->{ScheduleFScope};
	my %recc;
	$sth->bind_columns( map { \$recc{$_} }
		  @{ $connection->sql->{ScheduleFScopeFields} } );
	$sth->execute( $custId, $softName );
	
	dlog("Searching for ScheduleF scope, customer=".$custId.", software=".$softName);
	
	while ( $sth->fetchrow_arrayref ) {
		if (( $recc{level} eq "HOSTNAME" ) && ( $slName eq $recc{hostname} ) && ( $prioFound == 4 )) {
			wlog("ScheduleF HOSTNAME = ".$slName." for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "HOSTNAME" ) && ( $slName eq $recc{hostname} ) && ( $prioFound < 4 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=4;
		}
		if (( $recc{level} eq "HWBOX" ) && ( $hSerial eq $recc{hSerial} ) && ( $hMachineTypeId eq $recc{hMachineTypeId} ) && ( $prioFound == 3 )) {
			wlog("ScheduleF HWBOX = ".$hSerial." for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "HWBOX" ) && ( $hSerial eq $recc{hSerial} ) && ( $hMachineTypeId eq $recc{hMachineTypeId} ) && ( $prioFound < 3 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=3;
		}
		if (( $recc{level} eq "HWOWNER" ) && ( $hwOwner eq $recc{hwOwner} ) && ( $prioFound == 2 )) {
			wlog("ScheduleF HWOWNER =".$hwOwner." for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "HWOWNER" ) && ( $hwOwner eq $recc{hwOwner} ) && ( $prioFound < 2 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=2;
		}
		if (( $recc{level} eq "PRODUCT" ) && ( $prioFound == 1 )) {
			wlog("ScheduleF PRODUCT  for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "PRODUCT" ) && ( $prioFound < 1 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=1;
		}
		if (( $recc{level} eq "MANUFACTURER" ) && ( $prioFound == 0 )) {
			$scopeToReturn=$recc{scopeName};
		}
	}
	
	$sth->finish;
	
	dlog("custId= $custId, softName=$softName, hostname=$slName, serial=$hSerial, scopeName= $scopeToReturn, prioFound = $prioFound") if defined ($scopeToReturn);
	dlog("custId= $custId, softName=$softName, hostname=$slName, serial=$hSerial, no scopeName found") unless defined ($scopeToReturn);
	
	return ( $scopeToReturn, $prioFound );
}

sub getScheduleFScopeByISW {
	my $self=shift;
	my $connection=shift;
	my $swID=shift;
	
	$connection->prepareSqlQueryAndFields(
		$self->queryScheduleFSearch() );
	my $sth = $connection->sql->{ScheduleFSearch};
	my %recc;
	$sth->bind_columns( map { \$recc{$_} }
		  @{ $connection->sql->{ScheduleFSearchFields} } );
	$sth->execute( $swID );
	
	$sth->fetchrow_arrayref;
	
	$sth->finish;
	
	return ( undef, undef ) unless defined $recc{custId};
	
	my @ScheduleFlevels=( 'MANUFACTURER', 'PRODUCT', 'HWOWNER', 'HWBOX', 'HOSTNAME' );
	my @toreturn=getScheduleFScope( $self, $connection, $recc{custId}, $recc{softName}, $recc{hwOwner}, $recc{hSerial},
									$recc{hMachineTypeId}, $recc{slName}, $recc{swManufacturer} );
									
	return ( undef, undef ) unless defined $toreturn[0];
	
	return ( $toreturn[0], $ScheduleFlevels[$toreturn[1]] );
	
}

sub queryScheduleFScope {
	my @fields = qw(
	  hwOwner
	  hSerial
	  hMachineTypeId
	  hostname
	  level
	  scopeName
	);
	my $query = '
	  select
	    sf.hw_owner,
	    sf.serial,
	    mt.id,
	    sf.hostname,
	    sf.level,
	    s.name
	  from schedule_f sf
	    left outer join scope s
	      on sf.scope_id = s.id
	    left outer join machine_type mt
	      on mt.name = sf.machine_type
	  where
	    sf.customer_id = ?
	  and
	    (( sf.software_name = ? and sf.level != \'MANUFACTURER\' ) )
	  and
	    sf.status_id = 2
	  with ur
	';
	return('ScheduleFScope', $query, \@fields );
}

sub queryScheduleFSearch {
	my @fields = qw(
		custId
		softName
		hwOwner
		hSerial
		hMachineTypeId
		slName
		swManufacturer
	);
	
	my $query = 'select sl.customer_id, s.software_name, h.owner, h.serial, h.machine_type_id, sl.name, s.manufacturer_id
	from ( ( ( ( ( eaadmin.installed_software is
				   join eaadmin.software_lpar sl on sl.id = is.software_lpar_id )
                   join eaadmin.hw_sw_composite hsc on hsc.software_lpar_id = is.software_lpar_id )
                   join eaadmin.hardware_lpar hl on hl.id = hsc.hardware_lpar_id )
                   join eaadmin.hardware h on h.id = hl.hardware_id )
                   join eaadmin.software s on s.software_id = is.software_id )
                   where is.id = ?
     with ur';
     
     return ('ScheduleFSearch', $query, \@fields );
}

sub breakReconcileById {
	my ( $self, $connection, $reconcileId ) = @_;
	dlog("begin breakReconcileById");

	###Get reconcile object.
	my $reconcile = new Recon::OM::Reconcile();
	$reconcile->id($reconcileId);
	$reconcile->getById($connection);
	dlog( "reconcile=" . $reconcile->toString() );
	
	if ( ! defined $reconcile->reconcileTypeId ) {
		wlog ("Reconcile $reconcileId not found!");
		return;
	}

	###Get installed software object
	my $installedSoftware = new BRAVO::OM::InstalledSoftware();
	$installedSoftware->id( $reconcile->installedSoftwareId );
	$installedSoftware->getById($connection);
	dlog( "installed software=" . $installedSoftware->toString() );

	###Get software lpar object
	my $softwareLpar = new BRAVO::OM::SoftwareLpar();
	$softwareLpar->id( $installedSoftware->softwareLparId );
	$softwareLpar->getById($connection);
	dlog( "software lpar=" . $softwareLpar->toString() );

	###Hash to hold license ids to recon
	my %licenseIds = ();

	###Array to hold used license to delete
	my @uls;

	###Query the used license table by reconcile id
	$connection->prepareSqlQueryAndFields(
		$self->queryUsedLicenseIdByReconcileId() );
	my $sth = $connection->sql->{usedLicenseByReconcileId};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{usedLicenseByReconcileIdFields} } );
	$sth->execute( $reconcile->id );
	while ( $sth->fetchrow_arrayref ) {
		logRec( 'dlog', \%rec );
		push @uls, $rec{ulId};
	}
	$sth->finish;

	###Delete the reconcile used license
	dlog("deleting reconcile used license");
	foreach my $ulId (@uls) {

		###Delete the reconcile used license item.
		$connection->prepareSqlQuery( $self->queryDeleteReconUsedLicense() );
		my $deleteRul = $connection->sql->{deleteReconUsedLicense};
		$deleteRul->execute( $reconcileId, $ulId );
		$deleteRul->finish;
		dlog("deleted reconcile used licnese");

		###Check if the used liscense is refered by other reconcile.
		my $orphaned = 0;
		$connection->prepareSqlQuery( $self->queryCountReconcileUsedLicense() );
		my $sth = $connection->sql->{countReconcileUsedLicense};
		my $counter;
		$sth->bind_columns( \$counter );
		$sth->execute($ulId);
		$sth->fetchrow_arrayref;
		$sth->finish;

		$orphaned = 1 if defined $counter && $counter == 0;
		dlog( '$orphaned=' . $orphaned . '$counter=' . $counter );
		### remove the orphaned licnese items.
		if ($orphaned) {

			###Instantiate lic recon map object and delete.
			my $usedLicense = new Recon::OM::UsedLicense();
			$usedLicense->id($ulId);
			$usedLicense->getById($connection);
			
			next if(!defined $usedLicense->licenseId);

			###Add license id to hash for recon of lic.
			$licenseIds{ $usedLicense->licenseId }++;

			dlog( "usedLicense=" . $usedLicense->toString() );

			###delete the used license;
			$usedLicense->delete($connection);
			dlog("deleted used licnese");
		}
	}

	###Delete reconcile object.
	dlog("deleting the reconciliation");
	$reconcile->delete($connection);
	dlog("deleted the reconciliation");
	
	###Delete scarlet reconcile object if exists.
	dlog("deleting the scarlet reconciliation");
	my $scarletReconcile = new Recon::OM::ScarletReconcile();
    $scarletReconcile->id($reconcile->id);
    $scarletReconcile->getByBizKey($connection);
    
    if(defined $scarletReconcile->lastValidateTime){
	  $scarletReconcile->delete($connection);
    }
	dlog("deleted the scarlet reconciliation");

	dlog("Adding licenses to queue");
	foreach my $licenseId ( keys %licenseIds ) {
		my $license = new BRAVO::OM::License();
		$license->id($licenseId);
		$license->getById($connection);
		dlog( "license=" . $license->toString() );

		my $queue = Recon::Queue->new( $connection, $license );
		$queue->add;
	}
	dlog("Added licenses to queue");

	dlog("Adding installed software to queue");
	my $queue =
	  Recon::Queue->new( $connection, $installedSoftware, $softwareLpar );
	$queue->add;
	dlog("Added installed software to queue");

	dlog("end breakReconcileById");
	return;
}

sub queryUsedLicenseIdByReconcileId {
	my @fields = qw(
	  ulId
	);
	my $query = '
        select
            rul.used_license_id
        from
            reconcile_used_license rul
        where
            rul.reconcile_id = ?
        with ur
    ';
	return ( 'usedLicenseByReconcileId', $query, \@fields );
}

sub queryCountReconcileUsedLicense {
	my $query = '
        select
            count(*)
        from
            reconcile_used_license
        where
            used_license_id = ?
        with ur
    ';
	return ( 'countReconcileUsedLicense', $query );
}

sub queryDeleteReconUsedLicense {
	my $query = '
        delete from reconcile_used_license
        where
        	reconcile_id = ? 
        	and used_license_id = ?
    ';
	return ( 'deleteReconUsedLicense', $query );
}

1;
