package BRAVO::Archive::InstalledSoftware;

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
    
    ilog('Deleting installed sa products');
    $self->deleteInstalledSoftwareEff;
    ilog('Deleted installed sa products');

    ilog('Deleting installed software');
    $self->deleteInstalledSoftware;
    ilog('Deleted installed software');
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



sub deleteInstalledSoftware {
    my $self = shift;

    $self->installedSoftware->delete( $self->connection );
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
