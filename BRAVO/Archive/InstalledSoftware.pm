package BRAVO::Archive::InstalledSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::SoftwareDiscrepancyHistory;
use Recon::OM::AlertUnlicensedSoftware;
use Recon::OM::AlertUnlicensedSoftwareHistory;


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

    ilog('Deleting Scan SW Inst SW');
    $self->deleteScanSwInstSW;
    ilog('Deleted Scan SW Inst SW');
   
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


sub deleteScanSwInstSW {
    my $self = shift;

    dlog('Preparing Scan Sw Inst SW  query');
    $self->connection->prepareSqlQuery( $self->queryDeleteScanSwInstSW );
    dlog('Prepared Scan Sw Inst SW query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{deleteScanSwInstSW};
    dlog('Statement handle obtained');
    
    dlog('Executing query');
    $sth->execute( $self->installedSoftware->id );
    dlog('Executed query');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');
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

sub queryDeleteScanSwInstSW {
    my $self = shift;

    my $query = qq{
		delete
		from
		  scan_sw_inst_sw
		where
			installed_software_id = ?
        };

    dlog("queryDeleteScanSwInstSW=$query");
    return ( 'deleteScanSwInstSW', $query );
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
