package Test::Staging::MappingServiceTest;

use strict;
use base qw(Test::Class Test::Common::ConnectionManager);
use Test::More;
use Staging::Delegate::MappingService;
use File::Copy;
use File::stat;
use Staging::OM::ScanRecord;

sub test01 : Test(8) {

	my $srcInst = new Staging::Delegate::MappingService();
	##$srcInst->prepareMappings;
	my @names = (
		'suffix',        'prefix',
		'objectIdMap',   'nameMap',
		'namePrefixMap', 'customerAcctMap',
		'inclusionMap',  'hwLparMap'
	);
	my $lparMap2 = $srcInst->retrieveMap('inclusionMap');

	foreach my $n (@names) {
		my $lparMap = $srcInst->retrieveMap($n);
		my $i       = 0;
		$i += scalar( keys %{$lparMap} );
		diag( $n . '=' . $i );
	}
	$srcInst->init;
	diag( $srcInst->rootPath );

	ok( defined $srcInst->suffix,          'suffix defined' );
	ok( defined $srcInst->objectIdMap,     'objectIdMap defined' );
	ok( defined $srcInst->namePrefixMap,   'namePrefixMap defined' );
	ok( defined $srcInst->inclusionMap,    'inclusionMap defined' );
	ok( defined $srcInst->prefix,          'prefix defined' );
	ok( defined $srcInst->nameMap,         'nameMap defined' );
	ok( defined $srcInst->customerAcctMap, 'customerAcctMap defined' );
	ok( defined $srcInst->hwLparMap,       'hwLparMap defined' );
}

#Get the id throw following query.
#select sl.customer_id, sr.id from
#scan_record sr
#join software_lpar_map slm
#on sr.id = slm.scan_record_id join software_lpar sl
#on sl.id  = slm.software_lpar_id
#fetch first 10 rows only
sub test02 : Test(2) {
	my $self = shift;

	my $sr = new Staging::OM::ScanRecord;
	$sr->id(66);
	$sr->getById( $self->getStagingConnection );
	ok( defined $sr->bankAccountId, 'bank account id defined' );
	my $srcInst = new Staging::Delegate::MappingService();
	my $cid     = $srcInst->getCustomerId($sr);

	ok( defined $cid, 'Customer id fetched ' . $cid );

}

sub test03 : Test(2) {
	my $self = shift;

	my $srcInst = new Staging::Delegate::MappingService();
	$srcInst->needUpdate(1);
	ok( $srcInst->needUpdate, 'flag update' );
	$srcInst->needUpdate(0);
	ok( !$srcInst->needUpdate, 'flag update' );

}
1;
