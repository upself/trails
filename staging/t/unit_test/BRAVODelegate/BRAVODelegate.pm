package t::unit_test::BRAVODelegate::BRAVODelegate;

use Test::More;
use base 'Test::Class';
use Database::Connection;

my $bravoConnection;

sub class { 'BRAVO::Delegate::BRAVODelegate' }


sub querySoftwareIdBySoftwareName_old_query {
my $query ='
	select
            pi.id
        from
            product_info pi
            ,product p
            ,software_item si
            ,kb_definition kd
        where
            upper(si.name) = ?
            and product_role = ?
            and kd.deleted != 1
            and pi.id = p.id
            and p.id = si.id
            and si.id = kd.id
    ';
    return ( 'softwareIdBySoftwareNameOld', $query );
}

sub querySoftwareIdBySoftwareNameFromHistory_old_query {
my $query = '
	select
            pa.product_id
        from
            alias a
            ,product_alias pa
            ,product p
            ,software_item si
            ,kb_definition kd
        where
            upper(a.name) = ?
            and si.product_role = ?
            and kd.deleted != 1
            and a.id = pa.alias_id
            and pa.product_id = p.id
            and p.id = si.id
            and si.id = kd.id
    ';
    return ( 'softwareIdBySoftwareNameFromHistoryOld', $query );
}

sub startup : Tests(startup => 2) {
    my $test = shift;
    use_ok $test->class;
    $bravoConnection = Database::Connection->new('trails');
    isnt($bravoConnection,0,"Trails connection should be set up.");
}

sub querySoftwareIdBySoftwareName_Software_view_use : Tests(5+2) {
     my $test  = shift;
     my $class = $test->class;

	can_ok $class, 'querySoftwareIdBySoftwareName';
	my($tmp,$query) = $class->querySoftwareIdBySoftwareName;

	unlike($query,qr/software_item/m,"Query should not use eaadmin.software_item table");
	unlike($query,qr/kb_definition/m,"Query should not use eaadmin.kb_definition table");
	unlike($query,qr/product /m,"Query should not use eaadmin.product table");
	unlike($query,qr/product_info/m,"Query should not use eaadmin.product_info table");

	my @software_name = ('MICROSOFT ACTIVEX','Oracle 9i Portal');
	my @type = ('COMPONENT','COMPONENT');

	my $i = 0;
	foreach (@software_name) {
		is($class->getSoftwareIdBySoftwareNameAndType($bravoConnection,$software_name[$i], $type[$i]),querySoftwareIdBySoftwareName_old_vs_new_fce($software_name[$i], $type[$i]),"Software is from new and old query should be same");
		$i++;
 	}

	@software_name = ('MICROSOFT ACTIVEX','Oracle 9i Portal');
	@type = ('COMPONENT','COMPONENT');

	$i = 0;
	foreach (@software_name) {
		is($class->getSoftwareIdBySoftwareNameAndTypeFromHistory($bravoConnection,$software_name[$i], $type[$i]),querySoftwareIdBySoftwareNameFromHistory_old_vs_new_fce($software_name[$i], $type[$i]),"Software from History is from new and old query should be same");
		$i++;
 	}


}



sub querySoftwareIdBySoftwareNameFromHistory_Software_view_use : Tests(5) {
     my $test  = shift;
     my $class = $test->class;

	can_ok $class, 'querySoftwareIdBySoftwareNameFromHistory';
	my($tmp,$query) = $class->querySoftwareIdBySoftwareNameFromHistory;

	unlike($query,qr/software_item/m,"Query should not use eaadmin.software_item table");
	unlike($query,qr/kb_definition/m,"Query should not use eaadmin.kb_definition table");
	unlike($query,qr/product /m,"Query should not use eaadmin.product table");
	unlike($query,qr/product_info/m,"Query should not use eaadmin.product_info table");
}


sub querySoftwareIdBySoftwareName_old_vs_new_fce($softwareName, $type) {
	my $softwareId = undef;
	$bravoConnection->prepareSqlQuery( querySoftwareIdBySoftwareName_old_query() );
	my $sth = $bravoConnection->sql->{softwareIdBySoftwareNameOld};
	$sth->bind_columns( \$softwareId );
	$sth->execute( $softwareName, $type );
    	$sth->fetchrow_arrayref;
    	$sth->finish;

    	return $softwareId;
}

sub querySoftwareIdBySoftwareNameFromHistory_old_vs_new_fce($softwareName, $type) {
	my $softwareId = undef;
	$bravoConnection->prepareSqlQuery( querySoftwareIdBySoftwareNameFromHistory_old_query() );
	my $sth = $bravoConnection->sql->{softwareIdBySoftwareNameFromHistoryOld};
	$sth->bind_columns( \$softwareId );
	$sth->execute( $softwareName, $type );
    	$sth->fetchrow_arrayref;
    	$sth->finish;

    	return $softwareId;
}


1;
