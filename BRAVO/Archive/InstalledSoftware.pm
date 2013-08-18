package BRAVO::Archive::InstalledSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::SoftwareDiscrepancyHistory;
use Recon::OM::AlertUnlicensedSoftware;
use Recon::OM::ReconcileH;
use Recon::OM::AlertUnlicensedSoftwareHistory;
use Recon::OM::ReconcileUsedLicenseHistory;
use Recon::OM::UsedLicenseHistory;
use BRAVO::OM::InstalledFilter;
use BRAVO::OM::InstalledSignature;
use BRAVO::OM::InstalledDorana;
use BRAVO::OM::InstalledTLCMZ;

sub new {
    my ( $class, $connection, $installedSoftware ) = @_;
    my $self = {
                 _connection        => $connection,
                 _installedSoftware => $installedSoftware
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

    croak 'Installed software is undefined'
      unless defined $self->installedSoftware;
}

sub archive {
    my $self = shift;

    dlog('Deleting software discrepancy history');
    $self->deleteSoftwareDiscrepancyHistory;
    dlog('Deleted software discrepancy history');

    dlog('Deleting alert unlicensed software');
    $self->deleteAlertUnlicensedSoftware;
    dlog('Deleted alert unlicensed software');

    dlog('Deleting installed filters');
    $self->deleteInstalledFilters;
    dlog('Deleted installed filters');

    dlog('Deleting installed signatures');
    $self->deleteInstalledSignatures;
    dlog('Deleted installed signatures');

    dlog('Deleting installed dorana products');
    $self->deleteInstalledDoranas;
    dlog('Deleted installed dorana products');

    dlog('Deleting installed sa products');
    $self->deleteInstalledSas;
    dlog('Deleted installed sa products');
    
    dlog('Deleting installed sa products');
    $self->deleteInstalledSoftwareEff;
    dlog('Deleted installed sa products');
      
    dlog('Deleting reconcile history record');
    $self->deleteInstalledSoftwareReconcileH;
    dlog('Deleted reconcile history record');

    dlog('Deleting installed software');
    $self->deleteInstalledSoftware;
    dlog('Deleted installed software');
}

sub deleteSoftwareDiscrepancyHistory {
    my $self = shift;

    my @ids = $self->getSoftwareDiscrepancyHistoryIds;

    foreach my $id (@ids) {
        my $softwareDiscrepancyH = new BRAVO::OM::SoftwareDiscrepancyHistory();
        $softwareDiscrepancyH->id($id);
        $softwareDiscrepancyH->getById( $self->connection );
        dlog( $softwareDiscrepancyH->toString );

        $softwareDiscrepancyH->delete( $self->connection );
    }
}

sub deleteAlertUnlicensedSoftware {
    my $self = shift;

    my $alertUnlicensedSoftware = new Recon::OM::AlertUnlicensedSoftware();
    $alertUnlicensedSoftware->installedSoftwareId( $self->installedSoftware->id );
    $alertUnlicensedSoftware->getByBizKey( $self->connection );
    dlog( $alertUnlicensedSoftware->toString );

    if ( defined $alertUnlicensedSoftware->id ) {

        dlog('Deleting alert unlicensed software history');
        $self->deleteAlertUnlicensedSoftwareHistory( $alertUnlicensedSoftware->id );
        dlog('Deleted alert unlicensed software history');

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
        dlog( $alertUnlicensedSoftwareH->toString );

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
        dlog( $filter->toString );

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
        dlog( $signature->toString );

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
        dlog( $dorana->toString );

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
        dlog( $sa->toString );

        $sa->delete( $self->connection );
    }
}

sub deleteInstalledSoftwareEff {
    my $self = shift;

        my @ids;

    dlog('Preparing software discrepancy history query');
    $self->connection->prepareSqlQuery( $self->queryDeleteInstalledSoftwareEff );
    dlog('Prepared software discrepancy history query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{deleteInstalledSoftwareEff};
    dlog('Statement handle obtained');
    
    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');
}

sub deleteInstalledSoftwareReconcileH {
    my $self = shift;

    my @ids = $self->getReconcileHIds;

    foreach my $id (@ids) {
        my $reconh = new Recon::OM::ReconcileH();
        $reconh->id($id);
        $reconh->getById( $self->connection );
        dlog( $reconh->toString );
        $self->deleteReconcileUsedLicenseHistory($id);
        $reconh->delete( $self->connection );
    }
}

sub deleteReconcileUsedLicenseHistory {
    my $self = shift;
    my $rhid = shift;

    my @ids = $self->getReconcileUsedLicenseHIds($rhid);
        my $rulh = new Recon::OM::ReconcileUsedLicenseHistory();
        $rulh->reconcileId($rhid);
        $rulh->getById( $self->connection );
        dlog( $rulh->toString );
    foreach my $ulhid (@ids) {
        $self->deleteUsedLicenseHistory($ulhid);
    }
        $rulh->delete( $self->connection );
}

sub deleteUsedLicenseHistory {
    my $self = shift;
    my $ulhid = shift;  
        my $ulh = new Recon::OM::UsedLicenseHistory();
        $ulh->id($ulhid);
        $ulh->getById( $self->connection );
        dlog( $ulh->toString );
        $ulh->delete( $self->connection );
}

sub deleteInstalledSoftware {
    my $self = shift;
    my $existReconcile = $self->checkReconcile;
    if (!$existReconcile) {
    	 $self->installedSoftware->delete( $self->connection );
    } else {
    	mlog( "Installed_software constricted to a reconcile");
    	mlog( $self->installedSoftware->toString );
    }
   
}

sub checkReconcile {
	my $self = shift;
    my @ids;	
    my $existReconcile = 0 ;
    $self->connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareReconcile );
    my $sth = $self->connection->sql->{installedSoftwareReconcileIds};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{ installedSoftwareReconcileIdsFields } } );
    $sth->execute( $self->installedSoftware->id );
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
        $existReconcile = 1 ;
    }
    $sth->finish;
    return $existReconcile
}

sub queryInstalledSoftwareReconcile {
    my $self = shift;
    my @fields = (qw(id));
    my $query = qq{
		select
            id
		from 
            reconcile
		where
			installed_software_id = ?
        };

    dlog("queryInstalledSoftwareReconcileIds=$query");
    return ( 'installedSoftwareReconcileIds', $query, \@fields );
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

sub getReconcileHIds {
    my $self = shift;

    my @ids;

    dlog('Preparing reconcile history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryReconcileHIds );
    dlog('Prepared reconcile history query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{reconcileHIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{reconcileHIdsFields} } );
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

sub getReconcileUsedLicenseHIds {
    my $self = shift;
    my $rhid = shift;

    my @ids;

    dlog('Preparing reconcile used license history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryReconcileUsedLicenseHIds );
    dlog('Prepared reconcile used license history query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{reconcileUsedLicenseHIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{reconcileUsedLicenseHIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $rhid );
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


sub queryReconcileHIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            reconcile_h
		where
			installed_software_id = ?
        };

    dlog("queryReconcileHIds=$query");
    return ( 'reconcileHIds', $query, \@fields );
}

sub queryReconcileUsedLicenseHIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            H_USED_LICENSE_ID
		from 
            h_reconcile_used_license
		where
			H_RECONCILE_ID = ?
        };

    dlog("queryReconcileUsedLicenseHIds=$query");
    return ( 'reconcileUsedLicenseHIds', $query, \@fields );
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

sub queryDeleteInstalledSoftwareEff {
    my $self = shift;

    my $query = qq{
		delete
		from
		  installed_software_eff
		where
			installed_software_id = ?
        };

    dlog("queryDeleteInstalledSoftwareEff=$query");
    return ( 'deleteInstalledSoftwareEff', $query );
}

sub log {
    my $self = shift;

    $self->installedSoftware->toString;
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

1;
