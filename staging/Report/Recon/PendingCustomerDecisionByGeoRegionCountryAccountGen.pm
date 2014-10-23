package Report::Recon::PendingCustomerDecisionByGeoRegionCountryAccountGen;

use strict;
use Base::Utils;
use TRAILS::Delegate::PendingCustomerDecisionDelegate;
use Database::Connection;

### Object constructor.
sub new {
    my ($class) = @_;
    my $self = { _pendingCustomerDecisionByGeoRegionCountryAccountList => undef };

    bless $self, $class;
    dlog("Instantiated self");

    return $self;
}

### Object get/set methods.
sub pendingCustomerDecisionByGeoRegionCountryAccountList {
    my ( $self, $value ) = @_;
    $self->{_pendingCustomerDecisionByGeoRegionCountryAccountList} = $value if defined($value);
    return ( $self->{_pendingCustomerDecisionByGeoRegionCountryAccountList} );
}

sub genReport {
    my ( $self, %args ) = @_;

    dlog("Start genReport method");

    ### Set the job name of this script to update the status
    my $job = "Generating pending customer decision by geo, region, country and account detail report";
    dlog("job=$job");

    ### Get a connection to trails
    ilog("Getting trails db connection");    
    my $trailsConnection = Database::Connection->new('trails');
    ilog("Got trails db connection");

    ###Get start time for processing
    my $begin = time();

    ### Wrap all of this in an eval so we can close the connections if something
    ### dies. Use dieMsg to determine if this method should throw the die.
    my $dieMsg;
    eval {
        ###Get the recon summary data from bravo db
        $self->prepareSourceData($trailsConnection);
        ilog("Got data from trails");
        $self->processReportData();
    };
    if ($@) {
        ### Something died in the eval, set dieMsg so we know to die after closing
        ### the db connections.
        elog($@);
        $dieMsg = $@;
    }

    ### Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    logMsg("totalProcessingTime: $totalProcessingTime secs");

    ### Close the trails db connection
    ilog("Disconnecting bravo db connection");
    $trailsConnection->disconnect;
    ilog("Disconnected bravo db connection");

    ### die if dieMsg is defined
    die $dieMsg if defined $dieMsg;
}

sub prepareSourceData {
    my ( $self, $trailsConnection ) = @_;

    dlog('Start prepareSourceData method');

    $self->pendingCustomerDecisionByGeoRegionCountryAccountList(
               TRAILS::Delegate::PendingCustomerDecisionDelegate->getByGeoRegionCountryAccountData($trailsConnection) );

    dlog('End prepareSourceData method');
}

sub processReportData {
    my ($self) = @_;

    ### Loop thru the pendingCustomerDecisionByGeoRegionCountryAccountList array and process the data
    my $size = $self->pendingCustomerDecisionByGeoRegionCountryAccountList;
    dlog( 'Number of rows: ' . scalar @$size );

    my $i       = 0;
    my $rptHdr  = undef;
    my $rptLine = undef;

    ### Open file in write mode
    open( DATA, '>/var/http_reports/trails/pendingCustomerDecisionByGeoRegionCountryAccount.tsv' )
      or die "Couldn't open file /var/http_reports/trails/pendingCustomerDecisionByGeoRegionCountryAccount.tsv, $!";

    ### Write the report security classification
    print DATA "IBM Confidential\n";

    ### Write the report title and date
    my $dateTime = localtime();
    $rptLine = "Pending customer decision by geo, region, country and account" . "\t";
    $rptLine = $rptLine . $dateTime . "\n";
    print DATA $rptLine;

    ### Write the headers
    my @hdrs = (
                 'Geography',
                 'Region',
                 'Country code',
                 'Account number',
                 'Account name',
                 'Account type',
                 '0 - 45 days',
                 '46 - 90 days',
                 '91 - 120 days',
                 '121 - 180 days',
                 '181 - 365 days',
                 'Over 365 days'
    );

    for ( $i = 0 ; $i < 12 ; $i++ ) {
        $rptHdr = $rptHdr . $hdrs[$i] . "\t";
    }
    $rptHdr = $rptHdr . "\n";
    print DATA $rptHdr;

    for ( $i = 0 ; $i < @$size ; $i++ ) {
        my $rec = @$size[$i];

        # Output the tsv row
        $rptLine = $rec->{geo} . "\t";
        $rptLine = $rptLine . $rec->{region} . "\t";
        $rptLine = $rptLine . $rec->{country} . "\t";
        $rptLine = $rptLine . $rec->{accountNumber} . "\t";
        $rptLine = $rptLine . $rec->{customerName} . "\t";
        $rptLine = $rptLine . $rec->{customerTypeName} . "\t";
        $rptLine = $rptLine . $rec->{timeline1} . "\t";
        $rptLine = $rptLine . $rec->{timeline2} . "\t";
        $rptLine = $rptLine . $rec->{timeline3} . "\t";
        $rptLine = $rptLine . $rec->{timeline4} . "\t";
        $rptLine = $rptLine . $rec->{timeline5} . "\t";
        $rptLine = $rptLine . $rec->{timeline6} . "\t";
        $rptLine = $rptLine . "\n";
        print DATA $rptLine;
    }

    ### Close the file
    close(DATA) || die "Couldn't close file properly";
}

1;
