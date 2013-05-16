#!/usr/bin/perl -w

use File::Basename;
use TLCMZ::MoveMainframe;
use HealthCheck::Delegate::EventLoaderDelegate;#Added by Larry for HealthCheck And Monitor Module - Phase 2B

my $eventTypeName = 'MOVEMAINFRAME_START_STOP_SCRIPT';#Added by Larry for HealthCheck And Monitor Module - Phase 2B
my $eventObject;#Added by Larry for HealthCheck And Monitor Module - Phase 2B

eval {#Added by Larry for HealthCheck And Monitor Module - Phase 2B

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
	###Notify Event Engine that we are starting.
    #dlog("eventTypeName=$eventTypeName");
	#print "eventTypeName=$eventTypeName\n";
    #ilog("starting $eventTypeName event status");
	#print "starting $eventTypeName event status\n";
    $eventObject = EventLoaderDelegate->start($eventTypeName);
    #ilog("started $eventTypeName event status");
    #print "started $eventTypeName event status\n";
	#Added by Larry for HealthCheck And Monitor Module - Phase 2B End 

	# Main
	my @files = glob '/var/ftp/mf_scan/' . "*.{txt,TXT,xml,XML,asc,ASC}";

	for my $file (@files) {
		my ( $basefile, $dir, $ext ) = fileparse($file);
		unless ( $basefile eq "log.txt"
			|| ( $basefile eq "to_scan.txt" )
			|| ( $basefile eq "nudge" )
			|| ( $basefile eq "perm" )
			|| ( $basefile eq "error_file.txt" ) )
		{
			my $subFile = TLCMZ::MoveMainframe->new('mf_scan', "$basefile" );
			my ( $cpu, $lpar, $myTime ) = $subFile->checkIt($basefile);
			if ( $cpu eq "bad" ) {
				$subFile->processBadFile($file);
			}
			elsif ( $cpu eq "working" ) {
				print "$basefile is currently being transmitted";
			}
			else {
				$subFile->moveFile( $file, $cpu, $lpar, $myTime );
			}
		}
	}
};#Added by Larry for HealthCheck And Monitor Module - Phase 2B

#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
if ($@) {
    #elog($@);
    die $@;

	###Notify the Event Engine that we had an error
    #ilog("erroring $eventTypeName event status");
	#print "erroring $eventTypeName event status\n";
    EventLoaderDelegate->error($eventObject,$eventTypeName);
    #ilog("errored $eventTypeName event status");
	#print "errored $eventTypeName event status\n";
}
else {

    ###Notify the Event Engine that we are stopping
    #ilog("stopping $eventTypeName event status");
	#print "stopping $eventTypeName event status\n";
	EventLoaderDelegate->stop($eventObject,$eventTypeName);
    #ilog("stopped $eventTypeName event status");
	#print "stopped $eventTypeName event status\n";
}
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End