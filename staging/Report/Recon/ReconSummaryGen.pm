package Report::Recon::ReconSummaryGen;

use strict;
use Base::Utils;
use BRAVO::Delegate::BRAVODelegate;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _reconList => undef
    };

    bless $self, $class;
    dlog("instantiated self");

    return $self;
}

###Object get/set methods.
sub reconList {
    my ( $self, $value ) = @_;
    $self->{_reconList} = $value if defined($value);
    return ( $self->{_reconList} );
}

sub genReport {
    my ( $self, %args ) = @_;

    dlog("start genReport method");

    ###Set the job name of this script to update the status
    my $job = "Generating recon summary report";
    dlog("job=$job");

#    my $systemScheduleStatus;
#    ###Notify the scheduler that we are starting
#    ilog("starting $job system schedule status");
#    $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
#    ilog("started $job system schedule status");

    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    ilog("got bravo db connection");

    ###Get start time for processing
    my $begin = time();

    ###Wrap all of this in an eval so we can close the
    ###connections if something dies.  Use dieMsg to
    ###determine if this method should throw the die.
    my $dieMsg;
    eval {
        ###Get the recon summary data from bravo db
        $self->prepareSourceData( $bravoConnection );
        ilog("got data from bravo");
        $self->processReportData();
    };
    if ($@) {
        ###Something died in the eval, set dieMsg so
        ###we know to die after closing the db connections.
        elog($@);
        $dieMsg = $@;
    }

    ###Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    logMsg("totalProcessingTime: $totalProcessingTime secs");

    ###Close the staging db connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    ###die if dieMsg is defined
    die $dieMsg if defined $dieMsg;
}

sub prepareSourceData {
    my ( $self, $bravoConnection ) = @_;

    dlog('Start prepareSourceData method');

    $self->reconList(BRAVO::Delegate::BRAVODelegate->getReconSummaryData($bravoConnection));
    
    dlog('End prepareSourceData method');
}

sub processReportData {
    my ($self) = @_;
    
    ### Loop thru the reconList array and process the data
    my $size = $self->reconList;
    dlog('no of rows: ' . scalar @$size);
    
    my $prevRec = undef;
    my $prevSoftwareId = undef;
    my $prevSoftRecTypeId = undef;
    my $first = 1;
    my $i=0;
    my $j=0;
    my $totInstances = 0;
    my $totOpenInstances = 0;
    my %typeOpenMap = (1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 13 => 0);
    my %typeClosedMap = (1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 13 => 0);
    my @reconcileTypes = (5,7,8,2,4,1,6,13,3);
    my $rptHdr = undef;
    my $rptLine = undef;
    my $key = 0;
    my $value = 0;

    ### open file in write mode
    open(DATA, '>/tmp/report/reconSum.tsv') or die "Couldn't open file /tmp/report/reconSum.tsv, $!";
   
    ### write the headers
    my @hdrs = ('Platform type','Manufacturer', 'Product name', 
                'Total instances', 'Total open instances', 
                'Percent open instances', 
                'Total instances closed with Automatic License Allocation', 
                'Percent instances closed with Automatic License Allocation', 
                'Total instances closed with Bundled Software Product', 
                'Percent instances closed with Bundled Software Product', 
                'Total instances closed with covered by Software Category', 
                'Percent instances closed with covered by Software Category', 
                'Total instances closed with Customer owned and Customer managed', 
                'Percent instances closed with Customer owned and Customer managed', 
                'Total instances closed with Included with other product', 
                'Percent instances closed with Included with other product', 
                'Total instances closed with Manual License Allocation', 
                'Percent instances closed with Manual License Allocation', 
                'Total instances closed with Vendor managed product', 
                'Percent instances closed with Vendor managed product',
                'Total instances closed with Covered by IBM owned Enterprise Agreement', 
                'Percent instances closed with Covered by IBM owned Enterprise Agreement', 
                'Total instances closed with Alternate Purchase Agreement', 
                'Percent instances closed with Alternate Purchase Agreement', 
                );
    
    for($i=0; $i<24; $i++) {
        $rptHdr = $rptHdr . $hdrs[$i] . "\t";
    }
    $rptHdr = $rptHdr . "\n";
    print DATA $rptHdr;
     
    for($i=0; $i<@$size; $i++) {
        my $rec = @$size[$i];
        my $curSoftwareId = $rec->{softwareId};
        my $curReconcileTypeId = $rec->{reconcileTypeId};
        
        if ($first == 1) {
            $first = 0;
        }
        elsif ($prevSoftwareId ne $curSoftwareId) {
            # calculate all stats
            while (($key, $value) = each %typeOpenMap) 
            {
                $totOpenInstances = $totOpenInstances + $typeOpenMap{$key};
                $totInstances = $totInstances + $typeOpenMap{$key};
            }

            while (($key, $value) = each %typeClosedMap)
            {
                $totInstances = $totInstances + $typeClosedMap{$key};
            }
 
            # out the tsv row
            $rptLine = $prevRec->{type} . "\t";
            $rptLine = $rptLine . $prevRec->{manufacturerName} . "\t";             
            $rptLine = $rptLine . $prevRec->{softwareName} . "\t";
            $rptLine = $rptLine . $totInstances . "\t";
            $rptLine = $rptLine . $totOpenInstances . "\t";
            $rptLine = $rptLine . $totOpenInstances / $totInstances * 100 . "\t";

            for ($j=0;$j<9;$j++) {
                $rptLine =  $rptLine . $typeClosedMap{$reconcileTypes[$j]} . "\t"; 

                if ($typeClosedMap{$reconcileTypes[$j]} ne 0) {
                    $rptLine = $rptLine . $typeClosedMap{$reconcileTypes[$j]} / 
                        ($totInstances) * 100;
                }
                $rptLine = $rptLine . "\t";
            }
            $rptLine = $rptLine . "\n";
            print DATA $rptLine;

        	# reset all counters
            $totInstances = 0;
            $totOpenInstances = 0;
        	%typeOpenMap = (1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 13 => 0);
            %typeClosedMap = (1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 13 => 0);
        }
        
        my $open = $rec->{open};                
        my $curSoftRecTypeId = $curSoftwareId . $curReconcileTypeId;
        if ($curSoftRecTypeId ne $prevSoftRecTypeId) {
            if ($open == 1) {
                $typeOpenMap{$curReconcileTypeId} = $rec->{count};
            }
            else {
                $typeClosedMap{$curReconcileTypeId} = $rec->{count};
            }
        }
        else {
	       $typeOpenMap{$curReconcileTypeId} = $rec->{count};
        }
        $prevSoftwareId = $curSoftwareId;
        $prevSoftRecTypeId = $curSoftRecTypeId;
        $prevRec = $rec;
    }
    ### write the last rec to file
    # calculate all stats
    while (($key, $value) = each %typeOpenMap) 
    {
        $totOpenInstances = $totOpenInstances + $typeOpenMap{$key};
        $totInstances = $totInstances + $typeOpenMap{$key};
    }
    
    while (($key, $value) = each %typeClosedMap)
    {
        $totInstances = $totInstances + $typeClosedMap{$key};
    }
 
    # out the tsv row
    $rptLine = $prevRec->{type} . "\t";
    $rptLine = $rptLine . $prevRec->{manufacturerName} . "\t";             
    $rptLine = $rptLine . $prevRec->{softwareName} . "\t";
    $rptLine = $rptLine . $totInstances . "\t";
    $rptLine = $rptLine . $totOpenInstances . "\t";
    $rptLine = $rptLine . $totOpenInstances / $totInstances * 100 . "\t";

    for ($j=0;$j<9;$j++) {
        $rptLine =  $rptLine . $typeClosedMap{$reconcileTypes[$j]} . "\t"; 
        if ($typeClosedMap{$reconcileTypes[$j]} ne 0) {
            $rptLine = $rptLine . $typeClosedMap{$reconcileTypes[$j]} / 
                ($totInstances) * 100;
        }
        $rptLine = $rptLine . "\t";
    }
    $rptLine = $rptLine . "\n";
    print DATA $rptLine;
    
    ### Close the file
    close(DATA) || die "Couldn't close file properly";
}

1;
