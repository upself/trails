package SoftwareTlcmzDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Sigbank::Delegate::SoftwareTlcmzDelegate;
use Staging::OM::SoftwareTlcmz;
use Text::CSV_XS;

our @notFoundProductId;

sub getSoftwareTlcmzData {
	my ( $self, $connection, $bankAccount, $delta ) = @_;

	dlog('In the getSoftwareTlcmzData method');

	if ( $bankAccount->connectionType eq 'CONNECTED' ) {
		dlog( $bankAccount->name );
		my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
		my $softwareTlcmzMap = SoftwareTlcmzDelegate->getSoftwareTlcmzMap;
		return $self->getConnectedSoftwareTlcmzData( $connection, $bankAccount,
			$delta, $scanMap, $softwareTlcmzMap );
	}

	die('This is neither a connected or disconnected bank account');
}

sub getConnectedSoftwareTlcmzData {
	my ( $self, $connection, $bankAccount, $delta, $scanMap, $softwareTlcmzMap )
	  = @_;

	###No delta processing

	my %list;

	###Prepare the query
	$connection->prepareSqlQuery( $self->querySoftwareTlcmzData );

	###Define the fields
	my @fields = (qw(computerId tlcmzProduct ));

	###Get the statement handle
	my $sth = $connection->sql->{softwareTlcmzData};

	###Bind the columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @fields );

	###Execute the query
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {

		my $st =
		  $self->buildTlcmzSoftware( \%rec, $scanMap, $softwareTlcmzMap );
		next if ( !defined $st );

		my $key =
		    $st->scanRecordId . '|'
		  . $st->softwareTlcmzId . '|'
		  . $st->softwareId;

		###Add the hardware to the list
		$list{$key} = $st
		  if ( !defined $list{$key} );
	}

	###Close the statement handle
	$sth->finish;
	
	$self->writeLogNotFound();

	###Return the lists
	return ( \%list );
}

sub buildTlcmzSoftware {
	my ( $self, $rec, $scanMap, $softwareTlcmzMap ) = @_;

	cleanValues($rec);
	upperValues($rec);

	###We don't care about records that are not in our scan records
	return undef if ( !exists $scanMap->{ $rec->{computerId} } );

	if ( !exists $softwareTlcmzMap->{ $rec->{tlcmzProduct} } ) {
		SoftwareTlcmzDelegate->logNotFound($rec->{computerId}, $rec->{tlcmzProduct});
	}

	###We don't care if the software name does not exist
	#### We really need to check the logic here as to whether or not it is really
	###  acceptable to not uppercase or lower case these things
	return undef if ( !exists $softwareTlcmzMap->{ $rec->{tlcmzProduct} } );

	my $softwareTlcmzId = $softwareTlcmzMap->{ $rec->{tlcmzProduct} }->{'id'};
	my $softwareId      =
	  $softwareTlcmzMap->{ $rec->{tlcmzProduct} }->{'softwareId'};

	###Build our hardware object list
	my $st = new Staging::OM::SoftwareTlcmz();
	$st->softwareTlcmzId($softwareTlcmzId);
	$st->softwareId($softwareId);
	$st->scanRecordId( $scanMap->{ $rec->{computerId} } );

	return $st;
}

sub querySoftwareTlcmzData {
	my $query = '
        select
            a.computer_sys_id
            ,a.tlcmz_prod_id
        from
            inst_tlcmz_sware a
        with ur
    ';

	return ( 'softwareTlcmzData', $query );
}

sub logNotFound {
	my ( $self, $computerId, $tlcmzProductId ) = @_;
	push  @notFoundProductId, [ $computerId, $tlcmzProductId ];
}

sub writeLogNotFound {
	my $rec;
	my $now_time = localtime;
	open THISLOG, ">/var/ftp/mf_scan/mf_inv_logs/not_found_prod.txt";
  	for $rec ( @notFoundProductId ) {
 		print THISLOG "\"" . $rec->[0] . "\",\"" . $rec->[1] . "\",\"$now_time\"\n";
 	}
 	close THISLOG;	
}
1;
