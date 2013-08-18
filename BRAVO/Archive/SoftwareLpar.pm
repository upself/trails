package BRAVO::Archive::SoftwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Processor;
use BRAVO::OM::MemMod;
use BRAVO::OM::IpAddress;
use BRAVO::OM::Hdisk;
use BRAVO::OM::Adc;
use Recon::OM::AlertExpiredScan;
use Recon::OM::AlertExpiredScanHistory;
use Recon::OM::AlertSoftwareLpar;
use Recon::OM::AlertSoftwareLparHistory;
use BRAVO::OM::SoftwareLparEff;
use BRAVO::OM::SoftwareLparEffHistory;

sub new {
    my ( $class, $connection, $softwareLpar ) = @_;
    my $self = {
                 _connection   => $connection,
                 _softwareLpar => $softwareLpar
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

    croak 'Software lpar is undefined'
      unless defined $self->softwareLpar;
}

sub archive {
    my $self = shift;

    ilog('Deleting software lpar processor');
    $self->deleteSoftwareLparProcessor;
    ilog('Deleted software lpar processor');

    ilog('Deleting software lpar mem mod');
    $self->deleteSoftwareLparMemMod;
    ilog('Deleted software lpar mem mod');

    ilog('Deleting software lpar ip address');
    $self->deleteSoftwareLparIpAddress;
    ilog('Deleted software lpar ip address');

    ilog('Deleting software lpar hdisk');
    $self->deleteSoftwareLparHdisk;
    ilog('Deleted software lpar hdisk');

    ilog('Deleting software lpar adc');
    $self->deleteSoftwareLparAdc;
    ilog('Deleted software lpar adc');

    ilog('Deleting alert expired scan');
    $self->deleteAlertExpiredScan;
    ilog('Deleted alert expired scan');

    ilog('Deleting alert software lpar');
    $self->deleteAlertSoftwareLpar;
    ilog('Deleted alert software lpar');

    ilog('Deleting effective processor');
    $self->deleteEffectiveProcessor;
    ilog('Deleted effective processor');

    ilog('Deleting software lpar');
    $self->deleteSoftwareLpar;
    ilog('Deleted software lpar');
}

sub deleteSoftwareLparProcessor {
    my $self = shift;

    my @ids = $self->getProcessorIds;

    foreach my $id (@ids) {
        my $processor = new BRAVO::OM::Processor();
        $processor->id($id);
        $processor->getById( $self->connection );
        dlog( $processor->toString );

        $processor->delete( $self->connection );
    }
}

sub deleteSoftwareLparMemMod {
    my $self = shift;

    my @ids = $self->getMemModIds;

    foreach my $id (@ids) {
        my $memMod = new BRAVO::OM::MemMod();
        $memMod->id($id);
        $memMod->getById( $self->connection );
        dlog( $memMod->toString );

        $memMod->delete( $self->connection );
    }
}

sub deleteSoftwareLparIpAddress {
    my $self = shift;

    my @ids = $self->getIpAddressIds;

    foreach my $id (@ids) {
        my $ipAddress = new BRAVO::OM::IpAddress();
        $ipAddress->id($id);
        $ipAddress->getById( $self->connection );
        dlog( $ipAddress->toString );

        $ipAddress->delete( $self->connection );
    }
}

sub deleteSoftwareLparHdisk {
    my $self = shift;

    my @ids = $self->getHdiskIds;

    foreach my $id (@ids) {
        my $hdisk = new BRAVO::OM::Hdisk();
        $hdisk->id($id);
        $hdisk->getById( $self->connection );
        dlog( $hdisk->toString );

        $hdisk->delete( $self->connection );
    }
}

sub deleteSoftwareLparAdc {
    my $self = shift;

    my @ids = $self->getAdcIds;

    foreach my $id (@ids) {
        my $adc = new BRAVO::OM::Adc();
        $adc->id($id);
        $adc->getById( $self->connection );
        dlog( $adc->toString );

        $adc->delete( $self->connection );
    }
}

sub deleteAlertExpiredScan {
    my $self = shift;

    my $alertExpiredScan = new Recon::OM::AlertExpiredScan();
    $alertExpiredScan->softwareLparId( $self->softwareLpar->id );
    $alertExpiredScan->getByBizKey( $self->connection );
    dlog( $alertExpiredScan->toString );

    if ( defined $alertExpiredScan->id ) {

        ilog('Deleting alert expired scan history');
        $self->deleteAlertExpiredScanHistory( $alertExpiredScan->id );
        ilog('Deleted alert expired scan history');

        $alertExpiredScan->delete( $self->connection );
    }
}

sub deleteAlertExpiredScanHistory {
    my ( $self, $alertExpiredScanId ) = @_;

    my @ids = $self->getAlertExpiredScanHistoryIds($alertExpiredScanId);

    foreach my $id (@ids) {
        my $alertExpiredScanH = new Recon::OM::AlertExpiredScanHistory();
        $alertExpiredScanH->id($id);
        $alertExpiredScanH->getById( $self->connection );
        dlog( $alertExpiredScanH->toString );

        $alertExpiredScanH->delete( $self->connection );
    }
}

sub deleteAlertSoftwareLpar {
    my $self = shift;

    my $alertSoftwareLpar = new Recon::OM::AlertSoftwareLpar();
    $alertSoftwareLpar->softwareLparId( $self->softwareLpar->id );
    $alertSoftwareLpar->getByBizKey( $self->connection );
    dlog( $alertSoftwareLpar->toString );

    if ( defined $alertSoftwareLpar->id ) {

        ilog('Deleting alert software lpar history');
        $self->deleteAlertSoftwareLparHistory( $alertSoftwareLpar->id );
        ilog('Deleted alert software lpar history');

        $alertSoftwareLpar->delete( $self->connection );
    }
}

sub deleteAlertSoftwareLparHistory {
    my ( $self, $alertSoftwareLparId ) = @_;

    my @ids = $self->getAlertSoftwareLparHistoryIds($alertSoftwareLparId);

    foreach my $id (@ids) {
        my $alertSoftwareLparH = new Recon::OM::AlertSoftwareLparHistory();
        $alertSoftwareLparH->id($id);
        $alertSoftwareLparH->getById( $self->connection );
        dlog( $alertSoftwareLparH->toString );

        $alertSoftwareLparH->delete( $self->connection );
    }

}

sub deleteEffectiveProcessor {
    my $self = shift;

    my $effectiveProcessor = new BRAVO::OM::SoftwareLparEff();
    $effectiveProcessor->softwareLparId( $self->softwareLpar->id );
    $effectiveProcessor->getByBizKey( $self->connection );
    dlog( $effectiveProcessor->toString );

    if ( defined $effectiveProcessor->id ) {

        ilog('Deleting effective processor history');
        $self->deleteEffectiveProcessorHistory( $effectiveProcessor->id );
        ilog('Deleted effective processor history');

        $effectiveProcessor->delete( $self->connection );
    }
}

sub deleteEffectiveProcessorHistory {
    my ( $self, $effectiveProcessorId ) = @_;

    my @ids = $self->getEffectiveProcessorHistoryIds($effectiveProcessorId);

    foreach my $id (@ids) {
        my $effectiveProcessorH = new BRAVO::OM::SoftwareLparEffHistory();    
        $effectiveProcessorH->id($id);
        $effectiveProcessorH->getById( $self->connection );
        dlog( $effectiveProcessorH->toString );

        $effectiveProcessorH->delete( $self->connection );
    }
}

sub deleteSoftwareLpar {
    my $self = shift;

    $self->softwareLpar->delete( $self->connection );
}

sub getAdcIds {
    my $self = shift;

    my @ids;

    dlog('Preparing adc query');
    $self->connection->prepareSqlQueryAndFields( $self->queryAdcIds );
    dlog('Prepared adc query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{adcIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{adcIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->softwareLpar->id );
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

sub queryAdcIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            sla.id
		from 
            software_lpar_adc sla
		where
			sla.software_lpar_id = ?
        };

    dlog("queryAdcIds=$query");
    return ( 'adcIds', $query, \@fields );
}

sub getHdiskIds {
    my $self = shift;

    my @ids;

    dlog('Preparing hdisk query');
    $self->connection->prepareSqlQueryAndFields( $self->queryHdiskIds );
    dlog('Hdisk query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{hdiskIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{hdiskIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->softwareLpar->id );
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

sub queryHdiskIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            slh.id
		from 
            software_lpar_hdisk slh
		where
			slh.software_lpar_id = ?
        };

    dlog("queryHdiskIds=$query");
    return ( 'hdiskIds', $query, \@fields );
}

sub getIpAddressIds {
    my $self = shift;

    my @ids;

    dlog('Preparing ip address query');
    $self->connection->prepareSqlQueryAndFields( $self->queryIpAddressIds );
    dlog('Prepared ip address query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{ipAddressIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{ipAddressIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->softwareLpar->id );
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

sub queryIpAddressIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            slip.id
		from 
            software_lpar_ip_address slip
		where
			slip.software_lpar_id = ?
        };

    dlog("queryIpAddressIds=$query");
    return ( 'ipAddressIds', $query, \@fields );
}

sub getMemModIds {
    my $self = shift;

    my @ids;

    dlog('Preparing mem mod query');
    $self->connection->prepareSqlQueryAndFields( $self->queryMemModIds );
    dlog('Prepared mem mod query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{memModIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{memModIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->softwareLpar->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

    return @ids;
}

sub queryMemModIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            slmm.id
		from 
            software_lpar_mem_mod slmm
		where
			slmm.software_lpar_id = ?
        };

    dlog("queryMemModIds=$query");
    return ( 'memModIds', $query, \@fields );
}

sub getProcessorIds {
    my $self = shift;

    my @ids;

    dlog('Preparing processor query');
    $self->connection->prepareSqlQueryAndFields( $self->queryProcessorIds );
    dlog('Prepared processor query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{processorIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{processorIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->softwareLpar->id );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

    return @ids;
}

sub queryProcessorIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            slp.id
		from 
            software_lpar_processor slp
		where
			slp.software_lpar_id = ?
        };

    dlog("queryProcessorIds=$query");
    return ( 'processorIds', $query, \@fields );
}

sub getAlertExpiredScanHistoryIds {
    my ( $self, $alertExpiredScanId ) = @_;

    my @ids;

    dlog('Preparing alert ExpiredScan history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryAlertExpiredScanHistoryIds );
    dlog('Alert ExpiredScan history query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{alertExpiredScanHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{alertExpiredScanHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute($alertExpiredScanId);
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

sub queryAlertExpiredScanHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            alert_exp_scan_h
		where
			alert_expired_scan_id = ?
        };

    dlog("queryAlertExpiredScanHistoryIds=$query");
    return ( 'alertExpiredScanHistoryIds', $query, \@fields );
}

sub getAlertSoftwareLparHistoryIds {
    my ( $self, $alertSoftwareLparId ) = @_;

    my @ids;

    dlog('Preparing alert SoftwareLpar history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryAlertSoftwareLparHistoryIds );
    dlog('Alert SoftwareLpar history query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{alertSoftwareLparHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{alertSoftwareLparHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute($alertSoftwareLparId);
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

sub queryAlertSoftwareLparHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            alert_sw_lpar_h
		where
			alert_sw_lpar_id = ?
        };

    dlog("queryAlertSoftwareLparHistoryIds=$query");
    return ( 'alertSoftwareLparHistoryIds', $query, \@fields );
}

sub getEffectiveProcessorHistoryIds {
    my ( $self, $effectiveProcessorId ) = @_;

    my @ids;

    dlog('Preparing alert Effective processor history query');
    $self->connection->prepareSqlQueryAndFields( $self->queryEffectiveProcessorHistoryIds );
    dlog('Alert effective processor history query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{effectiveProcessorHistoryIds};
    dlog('Statement handle obtained');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{effectiveProcessorHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute($effectiveProcessorId);
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

sub queryEffectiveProcessorHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from 
            software_lpar_eff_h
		where
			software_lpar_eff_id = ?
        };

    dlog("queryEffectiveProcessorHistoryIds=$query");
    return ( 'effectiveProcessorHistoryIds', $query, \@fields );
}

sub log {
    my $self = shift;

    $self->softwareLpar->toString;
}

sub connection {
    my ( $self, $value ) = @_;
    $self->{_connection} = $value if defined($value);
    return ( $self->{_connection} );
}

sub softwareLpar {
    my ( $self, $value ) = @_;
    $self->{_softwareLpar} = $value if defined($value);
    return ( $self->{_softwareLpar} );
}

1;
