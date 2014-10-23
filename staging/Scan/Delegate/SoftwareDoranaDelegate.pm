package SoftwareDoranaDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Sigbank::Delegate::SoftwareDoranaDelegate;
use Staging::OM::SoftwareDorana;
use Text::CSV_XS;

sub getSoftwareDoranaData {
	my ( $self, $connection, $bankAccount, $delta ) = @_;

	dlog('In the getSoftwareDoranaData method');

	if ( $bankAccount->connectionType eq 'CONNECTED' ) {
		dlog( $bankAccount->name );
		my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
		my $softwareDoranaMap = SoftwareDoranaDelegate->getSoftwareDoranaMap;
		return $self->getConnectedSoftwareDoranaData( $connection, $bankAccount,
			$delta, $scanMap, $softwareDoranaMap );
	}

	die('This is neither a connected or disconnected bank account');
}

sub getConnectedSoftwareDoranaData {
	my ( $self, $connection, $bankAccount, $delta, $scanMap,
		$softwareDoranaMap ) = @_;

	###No delta processing

	my %list;

	###Prepare the query
	$connection->prepareSqlQuery(
		$self->querySoftwareDoranaData );

	###Define the fields
	my @fields = (qw(computerId doranaProduct ));

	###Get the statement handle
	my $sth = $connection->sql->{softwareDoranaData};

	###Bind the columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @fields );

	###Execute the query
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {

		my $st =
		  $self->buildDoranaSoftware( \%rec, $scanMap, $softwareDoranaMap );
		next if ( !defined $st );

		my $key =
		    $st->scanRecordId . '|'
		  . $st->softwareDoranaId . '|'
		  . $st->softwareId;

		###Add the hardware to the list
		$list{$key} = $st
		  if ( !defined $list{$key} );
	}

	###Close the statement handle
	$sth->finish;

	###Return the lists
	return ( \%list );
}

sub buildDoranaSoftware {
	my ( $self, $rec, $scanMap, $softwareDoranaMap ) = @_;

	cleanValues($rec);
	upperValues($rec);

	###We don't care about records that are not in our scan records
	return undef if ( !exists $scanMap->{ $rec->{computerId} } );

	###We don't care if the software name does not exist
	#### We really need to check the logic here as to whether or not it is really
	###  acceptable to not uppercase or lower case these things
	return undef if ( !exists $softwareDoranaMap->{ $rec->{doranaProduct} } );

	my $softwareDoranaId =
	  $softwareDoranaMap->{ $rec->{doranaProduct} }->{'id'};
	my $softwareId =
	  $softwareDoranaMap->{ $rec->{doranaProduct} }->{'softwareId'};

	###Build our hardware object list
	my $st = new Staging::OM::SoftwareDorana();
	$st->softwareDoranaId($softwareDoranaId);
	$st->softwareId($softwareId);
	$st->scanRecordId( $scanMap->{ $rec->{computerId} } );

	return $st;
}

sub querySoftwareDoranaData {
	my $query = '
        select
            a.computer_sys_id
            ,a.dorana_prod_id
        from
            inst_dorana_sware a
        with ur
    ';

	return ( 'softwareDoranaData', $query );
}
1;
