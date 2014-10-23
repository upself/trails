package BRAVO::Archive::Software;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::SoftwareDiscrepancyHistory;
use Recon::OM::AlertUnlicensedSoftware;
use Recon::OM::AlertUnlicensedSoftwareHistory;
use BRAVO::OM::InstalledFilter;
use BRAVO::OM::InstalledSignature;
use BRAVO::OM::InstalledDorana;
use BRAVO::OM::InstalledTLCMZ;
use BRAVO::OM::BundleSoftware;
use BRAVO::OM::Bundle;
use BRAVO::OM::DoranaProduct;
use BRAVO::OM::SaProduct;
use BRAVO::OM::ScheduleF;
use BRAVO::OM::ScheduleFHistory;
use BRAVO::OM::SoftwareFilter;
use BRAVO::OM::SoftwareFilterHistory;
use BRAVO::OM::SoftwareSignature;
use BRAVO::OM::SoftwareSignatureHistory;
use BRAVO::OM::VmProduct;
use BRAVO::OM::InstalledSoftware;

sub new {
    my ( $class, $connection, $software ) = @_;
    my $self = {
        _connection => $connection,
        _software   => $software
    };
    bless $self, $class;
    dlog("instantiated self");

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Software is undefined'
      unless defined $self->software;
}

sub archive {
    my $self = shift;

    ilog('Deleting signature history');
    $self->deleteSoftwareSignatureHistory;
    ilog('Deleted signature history');

    ilog('Deleting signatures');
    $self->deleteSoftwareSignatures;
    ilog('Deleted signatures');

    ilog('Deleting filter history');
    $self->deleteSoftwareFilterHistory;
    ilog('Deleted filter history');

    ilog('Deleting filters');
    $self->deleteSoftwareFilters;
    ilog('Deleted filters');

    ilog('Deleting bundle software');
    $self->deleteBundleSoftware;
    ilog('Deleted bundle software');

    ilog('Deleting bundles');
    $self->deleteBundles;
    ilog('Deleted bundles');

    ilog('Deleting vm product');
    $self->deleteVmProduct;
    ilog('Deleted vm product');

    ilog('Deleting sa product');
    $self->deleteSaProduct;
    ilog('Deleted sa product');

    ilog('Deleting dorana product');
    $self->deleteDoranaProduct;
    ilog('Deleted dorana product');

    ilog('Deleting license sw map');
    $self->deleteLicenseSwMap;
    ilog('Deleted license sw map');

    ilog('Deleting schedule f history');
    $self->deleteScheduleFHistory;
    ilog('Deleted schedule f history');

    ilog('Deleting schedule f');
    $self->deleteScheduleF;
    ilog('Deleted schedule f');

    ilog('Deleting software');
    $self->deleteSoftware;
    ilog('Deleted software');

}

sub deleteSoftwareSignatureHistory {
    my $self = shift;

    my @ids = $self->getSoftwareSignatureHistoryIds;

    foreach my $id (@ids) {
        my $softwareSignatureH = new BRAVO::OM::SoftwareSignatureHistory();
        $softwareSignatureH->id($id);
        $softwareSignatureH->getById( $self->connection );
        ilog( $softwareSignatureH->toString );

        $softwareSignatureH->delete( $self->connection );
    }
}

sub getSoftwareSignatureHistoryIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareSignatureHistoryIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{softwareSignatureHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareSignatureHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub querySoftwareSignatureHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            software_signature_h_id
		from 
            software_signature_h
		where
			software_id = ?
        };

    dlog("querySoftwareSignatureHistoryIds=$query");
    return ( 'softwareSignatureHistoryIds', $query, \@fields );
}

sub deleteSoftwareSignatures {
    my $self = shift;

    my @ids = $self->getSoftwareSignatureIds;

    foreach my $id (@ids) {
        my $softwareSignature = new BRAVO::OM::SoftwareSignature();
        $softwareSignature->id($id);
        $softwareSignature->getById( $self->connection );
        ilog( $softwareSignature->toString );

        $softwareSignature->delete( $self->connection );
    }
}

sub getSoftwareSignatureIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareSignatureIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{softwareSignatureIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareSignatureIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub querySoftwareSignatureIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            software_signature_id
		from 
            software_signature
		where
			software_id = ?
        };

    dlog("querySoftwareSignatureIds=$query");
    return ( 'softwareSignatureIds', $query, \@fields );
}

sub deleteSoftwareFilterHistory {
    my $self = shift;

    my @ids = $self->getSoftwareFilterHistoryIds;

    foreach my $id (@ids) {
        my $softwareFilterH = new BRAVO::OM::SoftwareFilterHistory();
        $softwareFilterH->id($id);
        $softwareFilterH->getById( $self->connection );
        ilog( $softwareFilterH->toString );

        $softwareFilterH->delete( $self->connection );
    }
}

sub getSoftwareFilterHistoryIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareFilterHistoryIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{softwareFilterHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareFilterHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub querySoftwareFilterHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            software_filter_h_id
		from 
            software_filter_h
		where
			software_id = ?
        };

    dlog("querySoftwareFilterHistoryIds=$query");
    return ( 'softwareFilterHistoryIds', $query, \@fields );
}

sub deleteSoftwareFilters {
    my $self = shift;

    my @ids = $self->getSoftwareFilterIds;

    foreach my $id (@ids) {
        my $softwareFilter = new BRAVO::OM::SoftwareFilter();
        $softwareFilter->id($id);
        $softwareFilter->getById( $self->connection );
        ilog( $softwareFilter->toString );

        $softwareFilter->delete( $self->connection );
    }
}

sub getSoftwareFilterIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareFilterIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{softwareFilterIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareFilterIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub querySoftwareFilterIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            software_filter_id
		from 
            software_filter
		where
			software_id = ?
        };

    dlog("querySoftwareFilterIds=$query");
    return ( 'softwareFilterIds', $query, \@fields );
}

sub deleteBundleSoftware {
    my $self = shift;

    my @ids = $self->getBundleSoftwareIds;

    foreach my $id (@ids) {
        my $bundleSoftware = new BRAVO::OM::BundleSoftware();
        $bundleSoftware->id($id);
        $bundleSoftware->getById( $self->connection );
        ilog( $bundleSoftware->toString );

        $bundleSoftware->delete( $self->connection );
    }
}

sub getBundleSoftwareIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->queryBundleSoftwareIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{bundleSoftwareIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{bundleSoftwareIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryBundleSoftwareIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            bundle_software
		where
			software_id = ?
        };

    dlog("queryBundleSoftwareIds=$query");
    return ( 'bundleSoftwareIds', $query, \@fields );
}

sub deleteBundles {
    my $self = shift;

    my @ids = $self->getBundleIds;

    foreach my $id (@ids) {
        my $bundle = new BRAVO::OM::Bundle();
        $bundle->id($id);
        $bundle->getById( $self->connection );
        ilog( $bundle->toString );

        $bundle->delete( $self->connection );
    }
}

sub getBundleIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->queryBundleIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{bundleIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{bundleIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryBundleIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            bundle
		where
			software_id = ?
        };

    dlog("queryBundleIds=$query");
    return ( 'bundleIds', $query, \@fields );
}

sub deleteVmProduct {
    my $self = shift;

    my @ids = $self->getVmProductIds;

    foreach my $id (@ids) {
        my $vmProduct = new BRAVO::OM::VmProduct();
        $vmProduct->id($id);
        $vmProduct->getById( $self->connection );
        ilog( $vmProduct->toString );

        $vmProduct->delete( $self->connection );
    }
}

sub getVmProductIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->queryVmProductIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{vmProductIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{vmProductIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryVmProductIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            vm_product
		where
			software_id = ?
        };

    dlog("queryVmProductIds=$query");
    return ( 'vmProductIds', $query, \@fields );
}

sub deleteSaProduct {
    my $self = shift;

    my @ids = $self->getSaProductIds;

    foreach my $id (@ids) {
        my $saProduct = new BRAVO::OM::SaProduct();
        $saProduct->id($id);
        $saProduct->getById( $self->connection );
        ilog( $saProduct->toString );

        $saProduct->delete( $self->connection );
    }
}

sub getSaProductIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->querySaProductIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{saProductIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{saProductIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub querySaProductIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            sa_product
		where
			software_id = ?
        };

    dlog("querySaProductIds=$query");
    return ( 'saProductIds', $query, \@fields );
}

sub deleteDoranaProduct {
    my $self = shift;

    my @ids = $self->getDoranaProductIds;

    foreach my $id (@ids) {
        my $doranaProduct = new BRAVO::OM::DoranaProduct();
        $doranaProduct->id($id);
        $doranaProduct->getById( $self->connection );
        ilog( $doranaProduct->toString );

        $doranaProduct->delete( $self->connection );
    }
}

sub getDoranaProductIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->queryDoranaProductIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{doranaProductIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{doranaProductIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryDoranaProductIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            dorana_product
		where
			software_id = ?
        };

    dlog("queryDoranaProductIds=$query");
    return ( 'doranaProductIds', $query, \@fields );
}

sub deleteLicenseSwMap {
    my $self = shift;

    my @ids = $self->getSoftwareSignatureIds;

    foreach my $id (@ids) {
        my $softwareFilter = new BRAVO::OM::SoftwareFilter();
        $softwareFilter->id($id);
        $softwareFilter->getById( $self->connection );
        ilog( $softwareFilter->toString );

        $softwareFilter->delete( $self->connection );
    }
}

sub deleteScheduleFHistory {
    my $self = shift;

    my @ids = $self->getSoftwareSignatureIds;

    foreach my $id (@ids) {
        my $softwareFilter = new BRAVO::OM::SoftwareFilter();
        $softwareFilter->id($id);
        $softwareFilter->getById( $self->connection );
        ilog( $softwareFilter->toString );

        $softwareFilter->delete( $self->connection );
    }
}

sub deleteScheduleF {
    my $self = shift;

    my @ids = $self->getSoftwareSignatureIds;

    foreach my $id (@ids) {
        my $softwareFilter = new BRAVO::OM::SoftwareFilter();
        $softwareFilter->id($id);
        $softwareFilter->getById( $self->connection );
        ilog( $softwareFilter->toString );

        $softwareFilter->delete( $self->connection );
    }
}

sub deleteSoftware {
    my $self = shift;

    $self->software->delete($self->connection);
}

sub deleteSoftwareDiscrepancyHistory {
    my $self = shift;

    my @ids = $self->getSoftwareDiscrepancyHistoryIds;

    foreach my $id (@ids) {
        my $softwareDiscrepancyH = new BRAVO::OM::SoftwareDiscrepancyHistory();
        $softwareDiscrepancyH->id($id);
        $softwareDiscrepancyH->getById( $self->connection );
        ilog( $softwareDiscrepancyH->toString );

        $softwareDiscrepancyH->delete( $self->connection );
    }
}

sub deleteAlertUnlicensedSoftware {
    my $self = shift;

    my $alertUnlicensedSoftware = new Recon::OM::AlertUnlicensedSoftware();
    $alertUnlicensedSoftware->installedSoftwareId( $self->installedSoftware->id );
    $alertUnlicensedSoftware->getByBizKey( $self->connection );
    ilog( $alertUnlicensedSoftware->toString );

    if ( defined $alertUnlicensedSoftware->id ) {

        ilog('Deleting alert unlicensed software history');
        $self->deleteAlertUnlicensedSoftwareHistory( $alertUnlicensedSoftware->id );
        ilog('Deleted alert unlicensed software history');

        $alertUnlicensedSoftware->delete( $self->connection );
    }
}

sub deleteAlertUnlicensedSoftwareHistory {
    my ( $self, $alertUnlicensedSoftwareId ) = @_;

    my @ids = $self->getAlertUnlicensedSoftwareHistoryIds($alertUnlicensedSoftwareId);

    foreach my $id (@ids) {
        my $alertUnlicensedSoftwareH = new Recon::OM::AlertUnlicensedSoftwareHistory();
        $alertUnlicensedSoftwareH->id($id);
        $alertUnlicensedSoftwareH->getById( $self->connection );
        ilog( $alertUnlicensedSoftwareH->toString );

        $alertUnlicensedSoftwareH->delete( $self->connection );
    }
}

sub deleteInstalledFilters {
    my $self = shift;

    my @ids = $self->getInstalledFilterIds;

    foreach my $id (@ids) {
        my $filter = new BRAVO::OM::InstalledFilter();
        $filter->id($id);
        $filter->getById( $self->connection );
        ilog( $filter->toString );

        $filter->delete( $self->connection );
    }
}

sub deleteInstalledSignatures {
    my $self = shift;

    my @ids = $self->getInstalledSignatureIds;

    foreach my $id (@ids) {
        my $signature = new BRAVO::OM::InstalledSignature();
        $signature->id($id);
        $signature->getById( $self->connection );
        ilog( $signature->toString );

        $signature->delete( $self->connection );
    }
}

sub deleteInstalledDoranas {
    my $self = shift;

    my @ids = $self->getInstalledDoranaIds;

    foreach my $id (@ids) {
        my $dorana = new BRAVO::OM::InstalledDorana();
        $dorana->id($id);
        $dorana->getById( $self->connection );
        ilog( $dorana->toString );

        $dorana->delete( $self->connection );
    }
}

sub deleteInstalledSas {
    my $self = shift;

    my @ids = $self->getInstalledSaIds;

    foreach my $id (@ids) {
        my $sa = new BRAVO::OM::InstalledTLCMZ();
        $sa->id($id);
        $sa->getById( $self->connection );
        ilog( $sa->toString );

        $sa->delete( $self->connection );
    }
}

sub deleteInstalledSoftware {
    my $self = shift;

    my @ids = $self->getInstalledSoftwareIds;

    foreach my $id (@ids) {
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($id);
        $installedSoftware->getById( $self->connection );
        ilog( $installedSoftware->toString );
        
        $self->installedSoftware($installedSoftware);

        ilog('Deleting software discrepancy history');
        $self->deleteSoftwareDiscrepancyHistory;
        ilog('Deleted software discrepancy history');

        ilog('Deleting alert unlicensed software');
        $self->deleteAlertUnlicensedSoftware;
        ilog('Deleted alert unlicensed software');

        ilog('Deleting installed filters');
        $self->deleteInstalledFilters;
        ilog('Deleted installed filters');

        ilog('Deleting installed signatures');
        $self->deleteInstalledSignatures;
        ilog('Deleted installed signatures');

        ilog('Deleting installed dorana products');
        $self->deleteInstalledDoranas;
        ilog('Deleted installed dorana products');

        ilog('Deleting installed sa products');
        $self->deleteInstalledSas;
        ilog('Deleted installed sa products');

        $installedSoftware->delete( $self->connection );
    }

}

sub getInstalledSoftwareIds {
    my $self = shift;

    my @ids;

    dlog('Preparing software discrepancy history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareIds );
    dlog('Prepared software discrepancy history query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{installedSoftwareIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedSoftwareIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->software->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryInstalledSoftwareIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            installed_software
		where
			software_id = ?
        };

    dlog("queryInstalledSoftwareIds=$query");
    return ( 'installedSoftwareIds', $query, \@fields );
}

sub getSoftwareDiscrepancyHistoryIds {
    my $self = shift;

    my @ids;

    dlog('Preparing software discrepancy history query');
    $self->connection->prepareSqlQueryAndFields( $self->querySoftwareDiscrepancyHistoryIds );
    dlog('Prepared software discrepancy history query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{softwareDiscrepancyHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{softwareDiscrepancyHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub querySoftwareDiscrepancyHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            software_discrepancy_h
		where
			installed_software_id = ?
        };

    dlog("querySoftwareDiscrepancyHistoryIds=$query");
    return ( 'softwareDiscrepancyHistoryIds', $query, \@fields );
}

sub getInstalledFilterIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed filter query');
    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledFilterIds );
    dlog('Prepared installed filter query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{installedFilterIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedFilterIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryInstalledFilterIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            installed_filter
		where
			installed_software_id = ?
        };

    dlog("queryInstalledFilterIds=$query");
    return ( 'installedFilterIds', $query, \@fields );
}

sub getInstalledSignatureIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed signature query');
    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledSignatureIds );
    dlog('Prepared installed signature query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{installedSignatureIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedSignatureIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryInstalledSignatureIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            installed_signature
		where
			installed_software_id = ?
        };

    dlog("queryInstalledSignatureIds=$query");
    return ( 'installedSignatureIds', $query, \@fields );
}

sub getInstalledDoranaIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed dorana query');
    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledDoranaIds );
    dlog('Prepared installed dorana query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{installedDoranaIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedDoranaIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryInstalledDoranaIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            installed_dorana_product
		where
			installed_software_id = ?
        };

    dlog("queryInstalledDoranaIds=$query");
    return ( 'installedDoranaIds', $query, \@fields );
}

sub getInstalledSaIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed sa product query');
    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledSaIds );
    dlog('Prepared installed sa product query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{installedSaIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{installedSaIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryInstalledSaIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            installed_sa_product
		where
			installed_software_id = ?
        };

    dlog("queryInstalledSaIds=$query");
    return ( 'installedSaIds', $query, \@fields );
}

sub getAlertUnlicensedSoftwareHistoryIds {
    my ( $self, $alertUnlicensedSoftwareId ) = @_;

    my @ids;

    dlog('Preparing alert hardware history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryAlertUnlicensedSoftwareHistoryIds );
    dlog('Alert hardware history query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{alertUnlicensedSoftwareHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{alertUnlicensedSoftwareHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute($alertUnlicensedSoftwareId);
    dlog('Query executed');

    dlog('Looping throw resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Looped through resultset');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

    return @ids;
}

sub queryAlertUnlicensedSoftwareHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            alert_unlicensed_sw_h
		where
			alert_unlicensed_sw_id = ?
        };

    dlog("queryAlertUnlicensedSoftwareHistoryIds=$query");
    return ( 'alertUnlicensedSoftwareHistoryIds', $query, \@fields );
}

sub log {
    my $self = shift;

    $self->software->toString;
}

sub connection {
    my ( $self, $value ) = @_;
    $self->{_connection} = $value if defined($value);
    return ( $self->{_connection} );
}

sub installedSoftware {
    my ( $self, $value ) = @_;
    $self->{_installedSoftware} = $value if defined($value);
    return ( $self->{_installedSoftware} );
}

sub software {
    my ( $self, $value ) = @_;
    $self->{_software} = $value if defined($value);
    return ( $self->{_software} );
}

1;
