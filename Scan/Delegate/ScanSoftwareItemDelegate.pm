package ScanSoftwareItemDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Staging::OM::ScanSoftwareItem;
use Text::CSV_XS;

sub getScanSoftwareItemData {
	my ( $self, $connection, $bankAccount, $delta ) = @_;

	dlog('In the getScanSoftwareItemData method');

	if ( $bankAccount->connectionType eq 'CONNECTED' ) {
		dlog( $bankAccount->name );
		my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
		return $self->getConnectedScanSoftwareItemData( $connection,
			$bankAccount, $delta, $scanMap );
	}

	die('This is neither a connected or disconnected bank account');
}

sub getConnectedScanSoftwareItemData {
	my ( $self, $connection, $bankAccount, $delta, $scanMap ) = @_;

	###No delta processing

	my %list;

	###Prepare the query
	$connection->prepareSqlQuery( $self->queryScanSoftwareItemData );

	###Define the fields
	my @fields = (qw(computerId guId lastUsed useCount));

	###Get the statement handle
	my $sth = $connection->sql->{scanSoftwareItemData};

	###Bind the columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @fields );

	###Execute the query
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {

		my $st = $self->buildScanSoftwareItem( \%rec, $scanMap );
		next if ( !defined $st );

		my $key = $st->scanRecordId . '|' . $st->guId;

		###Add the hardware to the list
		$list{$key} = $st
		  if ( !defined $list{$key} );
	}

	###Close the statement handle
	$sth->finish;

	###Return the lists
	return ( \%list );
}

sub buildScanSoftwareItem {
	my ( $self, $rec, $scanMap ) = @_;

	cleanValues($rec);
	upperValues($rec);

	###We don't care about records that are not in our scan records
	return undef if ( !exists $scanMap->{ $rec->{computerId} } );

	###Build our software object list
	my $st = new Staging::OM::ScanSoftwareItem();
	$st->guId( $rec->{guId} );
	$st->scanRecordId( $scanMap->{ $rec->{computerId} } );
	$st->lastUsed( $rec->{lastUsed} );
	$st->useCount( $rec->{useCount} );

	return $st;
}

sub queryScanSoftwareItemData {
	my $query = '
(
SELECT 
S.system_key concat \'_\' concat N.node_key
     , P.feature_guid as guid
     , MAX(PU.PERIOD) AS LASTUSED
     , bigint(case when SUM(PU.EVENT_CNT) is null then 0 else SUM(PU.EVENT_CNT) end) AS TOTAL
  FROM PRODUCT_INSTALL AS PI
  JOIN PRODUCT AS P ON P.SW_KEY = PI.SW_KEY
  JOIN SYSTEM AS S ON S.SYSTEM_KEY = PI.SYSTEM_KEY
  LEFT OUTER JOIN PRODUCT_USE AS PU ON PU.SW_KEY = PI.SW_KEY AND PU.SYSTEM_KEY = PI.SYSTEM_KEY
  JOIN SYSTEM_NODE AS SN ON SN.SYSTEM_KEY = PI.SYSTEM_KEY
  JOIN NODE AS N ON N.NODE_KEY = SN.NODE_KEY
  join (select node_key, max(last_update_time) as my_update from system_node group by node_key) 
  as mapping on mapping.node_key = n.node_key and mapping.my_update = sn.last_update_time
  WHERE  PI.UNINSTALL_DATE IS NULL
    AND P.PRODUCT_NAME <> \'SCRT_ONLY\'
    AND P.SW_TYPE = \'FEATURE\' 
    AND N.node_type = \'LPAR\' 
  GROUP BY  N.node_key, p.feature_guid
  ORDER BY  N.node_key, p.feature_guid
)
    union
(
S.system_key concat \'_\' concat N.node_key
     , P.version_guid guid
     , MAX(PU.PERIOD)       AS LASTUSED
     , bigint(case when SUM(PU.EVENT_CNT) is null then 0 else SUM(PU.EVENT_CNT) end) AS TOTAL
  FROM PRODUCT_INSTALL AS PI
  JOIN PRODUCT AS P ON P.SW_KEY = PI.SW_KEY
  JOIN SYSTEM AS S ON S.SYSTEM_KEY = PI.SYSTEM_KEY
  LEFT OUTER JOIN PRODUCT_USE AS PU ON PU.SW_KEY = PI.SW_KEY AND PU.SYSTEM_KEY = PI.SYSTEM_KEY
  JOIN SYSTEM_NODE AS SN ON SN.SYSTEM_KEY = PI.SYSTEM_KEY
  JOIN NODE AS N ON N.NODE_KEY = SN.NODE_KEY
  join (select node_key, max(last_update_time) as my_update from system_node group by node_key) 
  as mapping on mapping.node_key = n.node_key and mapping.my_update = sn.last_update_time
  WHERE  PI.UNINSTALL_DATE IS NULL
    AND P.PRODUCT_NAME <> \'SCRT_ONLY\'
    AND P.SW_TYPE = \'VERSION\' 
    AND N.node_type = \'LPAR\'
    and p.version_guid not in 
    (
    SELECT distinct P2.version_guid
    FROM PRODUCT_INSTALL AS PI2
    JOIN PRODUCT AS P2 ON P2.SW_KEY = PI2.SW_KEY
    WHERE  PI2.UNINSTALL_DATE IS NULL
      AND P2.PRODUCT_NAME <> \'SCRT_ONLY\'
      AND P2.SW_TYPE = \'FEATURE\' 
      and PI.system_key = PI2.system_key
     )
  GROUP BY  N.node_key, p.version_guid
  ORDER BY  N.node_key, p.version_guid
)
WITH ur;
    ';

	return ( 'scanSoftwareItemData', $query );
}

1;
