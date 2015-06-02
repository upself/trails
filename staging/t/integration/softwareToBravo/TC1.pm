package integration::softwareToBravo::TC1;

##############################################################
#
# This test case change processor count in staging, execute softwareToBravo loader and check results on trailspd and staging databases.
#
##############################################################


use Test::More;
use base 'Test::Class';
use BRAVO::SoftwareLoader;
use Base::Utils;

sub class { 'BRAVO::SoftwareLoader' };

$ENV{"PATH"} = "/usr/bin";
my @swLparCustomer;
my @swLparCustomerResult;
my $logFilePath   = "/var/staging/logs/softwareToBravo/TC1.log";
my $logFilePathChild   = "/var/staging/logs/softwareToBravo/TC1child.log";
my $configFile = "/opt/staging/v2/config/softwareToBravo.txt";
my $stagingConnection;
my $trailsConnection;

logging_level('debug');
logfile($logFilePath);
dlog("softwareToBravo integration test TC1 started");
dlog(" dirname $0");

sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
	my $class = $test->class;
	
	$stagingConnection = Database::Connection->new('staging');
	$trailsConnection = Database::Connection->new('trails');
	
	prepareStagingData($stagingConnection);
	
	
}

sub changeProcessorCount : Tests(7) {
	my $test  = shift;
	my $class = $test->class;
	
	$stagingConnection->prepareSqlQueryAndFields( getUpdateSwLparTestQuery());
	my $sth = $stagingConnection->sql->{updateSwLparTest};
	dlog("Changing to update sw lpar id ".$swLparCustomer[0]{softwareLparId}." and processor count ".$swLparCustomer[0]{processorCount});
	
	$sth->execute(++$swLparCustomer[0]{processorCount},$swLparCustomer[0]{softwareLparId});
	
	
	$stagingConnection->prepareSqlQueryAndFields( getUpdateSignatureTestQuery());
	$sth = $stagingConnection->sql->{updateSignatureTest};	
	dlog("Changing to update software signature id ".$swLparCustomer[0]{softwareSignatureId});
	$sth->execute($swLparCustomer[0]{softwareSignatureId});
	
	
	my $cmd = "/opt/staging/v2/softwareToBravoChild.pl -d 1 -a 1 -i ".$swLparCustomer[0]{customerId}." -l $logFilePathChild -p 5 -s ".$swLparCustomer[0]{swLparDate}." -c $configFile";
	dlog("spawning: $cmd");
	system($cmd);
	dlog("finished: $cmd");
	
	
	checkTrailsResults();
	checkStagingSwLparResults();
	checkStagingSSResults();
	checkSwLparReconQueueResults();

	
}

sub checkSwLparReconQueueResults {
	$trailsConnection->prepareSqlQueryAndFields( getSwLparReconQueueQuery());
	my $sth = $trailsConnection->sql->{swLparReconQueue};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @{ $trailsConnection->sql->{swLparReconQueueFields} } );
	$sth->execute($swLparCustomerResult[0]{swLparId},$swLparCustomer[0]{customerId});
	my $count = 0;
	while ( $sth->fetchrow_arrayref ) {
    }
	
	is($count,0, " Software lpar was not added to recon queue.");
}

sub checkIswReconQueueResults {
	$trailsConnection->prepareSqlQueryAndFields( getIswReconQueueQuery());
	my $sth = $trailsConnection->sql->{iswReconQueueQuery};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @{ $trailsConnection->sql->{iswReconQueueQueryFields} } );
	$sth->execute($swLparCustomerResult[0]{installedSoftwareId},$swLparCustomer[0]{customerId});
	my $count = 0;
	
	while ( $sth->fetchrow_arrayref ) {
    }
	
	is($count,0, " Installed software was not added to recon queue.");
}

sub checkTrailsResults {
	$trailsConnection->prepareSqlQueryAndFields( getTrailsSwLparTestQuery());
	my $sth = $trailsConnection->sql->{trailsSwLparTest};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @{ $trailsConnection->sql->{trailsSwLparTestFields} } );
	$sth->execute($swLparCustomer[0]{customerId},$swLparCustomer[0]{swLparName},$swLparCustomer[0]{softwareId});
	
	while ( $sth->fetchrow_arrayref ) {
    cleanValues( \%rec );
    upperValues( \%rec );
    
    	logRec( 'dlog', \%rec );        
        push @swLparCustomerResult, { swLparProcessorCount => $rec{swLparProcessorCount}, iswProcessorCount => $rec{iswProcessorCount}, swLparId => $rec{swLparId}, installedSoftwareId => $rec{installedSoftwareId}};
    
 		is($rec{swLparProcessorCount},$swLparCustomer[0]{processorCount}, " Processor count has been writen to trailspd. (software lpar)");
		is($rec{iswProcessorCount},$swLparCustomer[0]{processorCount}, " Processor count has been writen to trailspd. (installed software)");	
    }
	
}

sub checkStagingSwLparResults {
	$stagingConnection->prepareSqlQueryAndFields( getStagingSwLparResultsTestQuery());
	my $sth = $stagingConnection->sql->{stagingSwLparResultsTest};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{stagingSwLparResultsTestFields} } );
	$sth->execute($swLparCustomer[0]{softwareLparId});
	while ( $sth->fetchrow_arrayref ) {
    cleanValues( \%rec );
    upperValues( \%rec );
 		is($rec{processorCount},$swLparCustomer[0]{processorCount}, "Processor count was not changed on staging.");
		is($rec{action},'COMPLETE', " Staging sw lpar action is back complete.");	
    }
	
}

sub checkStagingSSResults{
	$stagingConnection->prepareSqlQueryAndFields( getStagingSSResultsTestQuery());
	my $sth = $stagingConnection->sql->{stagingSSResultsTest};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{stagingSSResultsTestFields} } );
	$sth->execute($swLparCustomer[0]{softwareSignatureId});
	while ( $sth->fetchrow_arrayref ) {
    cleanValues( \%rec );
    upperValues( \%rec );
		is($rec{action},'COMPLETE', " Staging software signature action is back complete.");
		is($rec{processorCount},$swLparCustomer[0]{processorCount}, " Staging scan record has still same processor count.");	
    }
	
	
}

sub prepareStagingData {
	my ($stagingConnection) = @_;
	
	
	$stagingConnection->prepareSqlQueryAndFields( getSolftwareLparTestQuery());
	my $sth = $stagingConnection->sql->{solftwareLparTest};
	my %rec;
	dlog( "bind_columns");
    $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{solftwareLparTestFields} } );
    dlog( "execute query");
    $sth->execute();
    
    while ( $sth->fetchrow_arrayref ) {
    cleanValues( \%rec );
    upperValues( \%rec );
    	logRec( 'dlog', \%rec );        
        push @swLparCustomer, { softwareLparId => $rec{softwareLparId},swLparDate => $rec{swLparDate}, processorCount => $rec{processorCount}, customerId => $rec{customerId}, swLparName => $rec{swLparName}, softwareId => $rec{softwareId}, softwareSignatureId=> $rec{softwareSignatureId}};
    }
	
	
}

sub getSolftwareLparTestQuery {
    my @fields = (
        qw(
            customerId
            softwareLparId
            processorCount
            swLparName
            swLparDate
            softwareId
            softwareSignatureId
            )
    );
    my $query = '
			select
		        sl.customer_id
		        ,sl.id
		        ,sl.processor_count
		        ,sl.name
		        ,date(sl.scan_time)
		        ,ss.software_id
		        ,ss.id

			    from eaadmin.software_lpar sl
			        left outer join eaadmin.software_lpar_map slm on slm.software_lpar_id = sl.id
			        left outer join eaadmin.scan_record sr on sr.id = slm.scan_record_id
			        left outer join eaadmin.software_signature ss on ss.scan_record_id = sr.id
			        
			    where
			    	sl.action = \'COMPLETE\'
			    	and slm.action = \'COMPLETE\'
			    	and sr.action = \'COMPLETE\'
			    	and ss.action = \'COMPLETE\'
			    	
			    	and sl.customer_id != 999999
fetch first 1 rows only
                
    ';

    return ( 'solftwareLparTest', $query, \@fields );
}

sub getUpdateSwLparTestQuery {
    my $query = '
    		update
    			software_lpar
    		set
    			processor_count = ?
    			,action = \'UPDATE\'
    		where id = ?
                
    ';

    return ( 'updateSwLparTest', $query );
}

sub getUpdateSignatureTestQuery {
    my $query = '
    		update
    			software_signature
    		set
    			action = \'UPDATE\'
    		where id = ?
                
    ';

    return ( 'updateSignatureTest', $query );
}

sub getTrailsSwLparTestQuery {
    my @fields = (
        qw(
            swLparProcessorCount
            iswProcessorCount
            swLparId
            installedSoftwareId
            )
    );
    my $query = '
			select
		        sl.processor_count
		        ,isw.processor_count
		        ,sl.id
		        ,isw.id

			    from eaadmin.software_lpar sl
			    		join eaadmin.installed_software isw on isw.software_lpar_id = sl.id
			    where
			    	sl.customer_id = ?
			    	and sl.name = ?
			    	and isw.software_id = ?          
    ';
   return ( 'trailsSwLparTest', $query, \@fields );
}

sub getStagingSwLparResultsTestQuery() {
    my @fields = (
        qw(
            processorCount
            action
            )
    );
    my $query = '
    		select
    			processor_count
    			,action
    		from
    			software_lpar
    		where id = ?          
    ';
    return ( 'stagingSwLparResultsTest', $query, \@fields );
}
sub getStagingSSResultsTestQuery() {
    my @fields = (
        qw(
        	processorCount
            action
            )
    );
    my $query = '
    		select
    			sl.processor_count
    			,ss.action
    		from
    			software_signature ss
    				join scan_record sr on sr.id = ss.scan_record_id
    				join software_lpar_map slm on slm.scan_record_id = sr.id
    				join software_lpar sl on sl.id = slm.software_lpar_id
    		where ss.id = ?            
    ';
    return ( 'stagingSSResultsTest', $query, \@fields );
}
sub getSwLparReconQueueQuery() {
    my @fields = (
        qw(
            id
            )
    );
    my $query = '
    		select
    			id
    		from
    			recon_sw_lpar
    		where software_lpar_id = ?
    			  and customer_id = ?            
    ';
    return ( 'swLparReconQueue', $query, \@fields );
}

sub getIswReconQueueQuery() {
    my @fields = (
        qw(
            id
            )
    );
    my $query = '
    		select
    			id
    		from
    			recon_installed_sw
    		where installed_software_id = ?
    			  and customer_id = ?                 
    ';
    return ( 'iswReconQueueQuery', $query, \@fields );
}
1;