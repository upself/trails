package Recon::Delegate::ReconDelegate;

use strict;
use Base::Utils;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use Recon::OM::Reconcile;
use Recon::OM::UsedLicense;
use BRAVO::OM::License;
use Recon::Queue;

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
	$data{'Automatic license allocation'}        = 5;
	$data{'Vendor managed product'}              = 6;
	$data{'Bundled software product'}            = 7;
	$data{'Covered by software category'}        = 8;
	$data{'Customer owned and customer managed'} = 15;
	$data{'Pending customer decision'}           = 16;

	return \%data;
}

sub breakReconcileById {
	my ( $self, $connection, $reconcileId ) = @_;
	dlog("begin breakReconcileById");
	dlog($reconcileId);

	###Get reconcile object.
	my $reconcile = new Recon::OM::Reconcile();
	$reconcile->id($reconcileId);
	$reconcile->getById($connection);
	dlog( "reconcile=" . $reconcile->toString() );

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
