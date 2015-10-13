package fullRecon::fullReconReport;

use Base::Utils;
use File::Copy;
use Getopt::Std;
use Config::Properties::Simple;
use File::Basename;
use Conf::ReportProperty;
use Try::Tiny;

###Object constructor.
sub new {
    my ($class,$regionId,$regionName, $databaseName, $gsaPath,$tmpDir,$reportDir,$numberOfCustomers,$customerId) = @_;
    my $self = {
                 _class => $class,
                 _regionId => $regionId,
                 _regionName => $regionName,
                 _databaseName => $databaseName,
                 _gsaPath => $gsaPath,
                 _tmpDir => $tmpDir,
                 _reportDir => $reportDir,
                 _numberOfCustomers => $numberOfCustomers,
                 _customerId => $customerId
    };
    bless $self, $class;
    return $self;
}


sub start() {
	my ( $self) = @_;
	ilog("fullReconReport.pm starts");
	my $sqlFile = $self->tmpDir . '/' . $self->regionName . "_tmp.sql" ;
	my $regionFile = $self->tmpDir .'/'. $self->regionName;
	my $regionDataFile = $self->reportDir .'/processing/'. $self->regionName . ".tsv";
	
	my $cfg=Config::Properties::Simple->new(file=>'/opt/staging/v2/config/connectionConfig.txt');
    my $reportDatabase = $cfg->getProperty($self->databaseName.'.name');	
	my $reportDatabaseUser = $cfg->getProperty($self->databaseName.'.user');	
	my $reportDatabasePassword = $cfg->getProperty($self->databaseName.'.password');
	
	system("rm -f ".$regionDataFile);
	system("touch ".$regionDataFile);
	system("cat ".$self->reportDir."/fullReconDriver_header.txt >> ".$regionDataFile);
	
	my $connection = Database::Connection->new($self->databaseName);
	$connection->prepareSqlQueryAndFields($self->getCustomerPerRegion());
	my $sth = $connection->sql->{customerPerRegion};
	my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{customerPerRegionFields} } );
    $sth->execute($self->regionId);
    
    my $counter = 0;
    while ( $sth->fetchrow_arrayref ) {
    	cleanValues( \%rec );
    	
    	if( !(defined $self->customerId) || $self->customerId == $rec{customer_id}) {
	    	if( !(defined $self->numberOfCustomers) || $self->numberOfCustomers > $counter) {
	    	
	    	dlog($self->reportDir.'/fullReconReportPerCustomer.sh '.$self->databaseName .' '. $rec{customer_id}.' '.$regionDataFile);
	    	$output = system($self->reportDir.'/fullReconReportPerCustomer.sh '.$self->databaseName .' '. $rec{customer_id}.' '.$regionDataFile);
	    	
	    	if($output == 1) {die "error from sql query look to log for more details"};
	    	
	    	$counter++;
	    	}
    	}
    }
    
    system( "date >> $regionDataFile" );
    
    system("zip -j " . $self->tmpDir .'/'. $self->regionName . ".zip $regionDataFile");
    move($self->tmpDir .'/'. $self->regionName . ".zip",$self->gsaPath .'/'. $self->regionName . ".zip");
    
    ilog("fullReconRecort.pm ends for ".$self->regionName);
    
    unlink($regionDataFile);
	unlink($regionFile);
	unlink($sqlFile);
	unlink($self->tmpDir . $self->regionName . ".zip");
	system( "db2 terminated" );
	system("rm -f ".$regionDataFile);
	system("rm -f ".$regionFile);
	system("rm -f ".$sqlFile);

	
	

}

sub getCustomerPerRegion() {
	   my @fields = (
        qw(customer_id)
	);	

 my $query = "
		SELECT c.customer_id
		FROM EAADMIN.country_code cc
			join eaadmin.customer c on c.country_code_id = cc.id
			
		where c.status = \'ACTIVE\'
				and c.sw_license_mgmt = 'YES' 
				and cc.region_id = ?
		
		with ur
";	
	
 return ('customerPerRegion',$query, \@fields );	
}	

###Object get/set methods.
sub class {
    my ( $self, $value ) = @_;
    $self->{_class} = $value if defined($value);
    return ( $self->{_class} );
}

sub regionId {
    my ( $self, $value ) = @_;
    $self->{_regionId} = $value if defined($value);
    return ( $self->{_regionId} );
}
sub regionName {
    my ( $self, $value ) = @_;
    $self->{_regionName} = $value if defined($value);
    return ( $self->{_regionName} );
}

sub databaseName {
    my ( $self, $value ) = @_;
    $self->{_databaseName} = $value if defined($value);
    return ( $self->{_databaseName} );
}

sub gsaPath {
    my ( $self, $value ) = @_;
    $self->{_gsaPath} = $value if defined($value);
    return ( $self->{_gsaPath} );
}
sub tmpDir {
    my ( $self, $value ) = @_;
    $self->{_tmpDir} = $value if defined($value);
    return ( $self->{_tmpDir} );
}
sub reportDir {
    my ( $self, $value ) = @_;
    $self->{_reportDir} = $value if defined($value);
    return ( $self->{_reportDir} );
}
sub numberOfCustomers {
    my ( $self, $value ) = @_;
    $self->{_numberOfCustomers} = $value if defined($value);
    return ( $self->{_numberOfCustomers} );
}
sub customerId {
    my ( $self, $value ) = @_;
    $self->{_customerId} = $value if defined($value);
    return ( $self->{_customerId} );
}

1;