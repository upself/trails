#!/usr/bin/perl
#
# IBM Confidential -- INTERNAL USE ONLY

use lib "/opt/report/bin";
#use lib "/home/ondrej/git_separate/bravotrails_master/reports";
require "/opt/staging/v2/Database/Connection.pm";
require "/opt/report/bin/fullRecon/fullReconReport.pm";

use POSIX;
use Getopt::Std;
use Conf::ReportProperty;
use Base::Utils;



my $cfg = new Conf::ReportProperty();
$cfg->initReportingSystem;

my $fileName = $cfg->thisReport;
my $fileDirectory = $cfg->thisDir;
my $tmpDir = $cfg->tmpDir;
my $finalDir = $cfg->reportDeliveryFolder('fullRecon');

my $logFilePath   = $fileDirectory.'/logs/fullReconReportLogTest.txt';


use vars qw ($opt_r $opt_t $opt_c $opt_d);
die "Usage: $0 -r <region name> -c <customer_id> -t <number of customers> -d <debug mode>" if !getopts("r:t:c:d:");
my $mode;
$mode = checkParameters($opt_r);

ilog("Starting full recon report driver : $opt_r $opt_t $opt_c ");

my $databaseName = 'trailsrp';
my $children           =0;
my $maxChildren        = 100;
my %children           = ();
my $trailsrpConnection = Database::Connection->new($databaseName);
my %allRegionHashList = fillAllRegionsHash($trailsrpConnection);
my %regionHashList;

if($mode eq "fullMode") {
	%regionHashList	= %allRegionHashList;
}
elsif( $mode eq "regionMode" ) {
	foreach my $key ( keys %allRegionHashList )
	{
 		if($allRegionHashList{$key} eq $opt_r) {
 			$regionHashList{$key} = $allRegionHashList{$key};
 		}
	}
}
else {
	die "wrong parametres";
}

if (defined $opt_d) {
	logging_level('debug');
}
else {
	logging_level('info');
}
logfile($logFilePath);

$trailsrpConnection->disconnect();
daemonize();
spawnChildren();
ilog("End full recon report driver ");
exit;

sub newChild {
  my($regionId, $regionName) = @_;
  my $pid;
  
  wlog("Spawning $regionId, $regionName");
  my $sigset = POSIX::SigSet->new(SIGINT);
  sigprocmask( SIG_BLOCK, $sigset ) or die "Can't block SIGINT for fork: $!";
  die "Cannot fork child: $!\n" unless defined( $pid = fork );
  
  if ($pid == 0){
  	# I am a child not a parent
  	dlog("i am a child : ".$regionName);
  	my $fullReconReport = new fullRecon::fullReconReport( $regionId, $regionName, $databaseName,$finalDir,$tmpDir,$fileDirectory,$opt_t,$opt_c);
  	$fullReconReport->start();
  	
  	sleep 5;
  	exit;
  }
  else {
  	return;
  }

}

sub spawnChildren {
 wlog("fullReconDriver Spawning children");

 my $regionName;
 my $regionId;

 foreach my $key ( keys %regionHashList ) {
 	$regionId = $key;
 	$regionName = $regionHashList{$key};
	newChild($regionId, $regionName );
 }


}
sub daemonize {
 my $pid = fork;
 defined($pid) or die "Cannot start daemon: $!";
 dlog "Parent daemon running.\n" if $pid;
 exit                             if $pid;

 POSIX::setsid();

 close(STDOUT);
 close(STDIN);
 close(STDERR);

 $SIG{__WARN__} = sub {
  ilog( "NOTE! " . join( " ", @_ ) );
 };

 $SIG{__DIE__} = sub {
  elog( "FATAL! " . join( " ", @_ ) );
 };

 $SIG{HUP} = $SIG{INT} = $SIG{TERM} = sub {
  my $sig = shift;
  $SIG{$sig} = 'IGNORE';
  kill 'INT' => keys %children;
  die "killed by $sig\n";
  exit;
 };

 $SIG{CHLD} = \&REAPER;
}

sub checkParameters() {
	my($region) = @_;
	if(defined $region) {
		dlog("full recon driver runs only for region $opt_r \n");
		return "regionMode";
	}
	else {
		dlog("full recon driver runs in full mode \n");
		return "fullMode";
	}
}


sub fillAllRegionsHash() {
	my($trailsrpConnection) = @_;
	
	my %allRegionsHash;
	
	dlog( "preparing fillAllRegionsHash SqlQuery And Fields");	
	$trailsrpConnection->prepareSqlQueryAndFields(getAllRegionsQuery());
	my $sth = $trailsrpConnection->sql->{allRegions};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @{ $trailsrpConnection->sql->{allRegionsFields} } );
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {
    	cleanValues( \%rec );
    	upperValues( \%rec );
    
    	$rec{region} =~ s/ /_/g;
    	$allRegionsHash{$rec{id}} = $rec{region};	
    	
	}
	
	return %allRegionsHash;
}

sub getAllRegionsQuery {
	   my @fields = (
        qw(id region)
	);	

 my $query = "
		SELECT r.id,
			   r.name
		FROM EAADMIN.REGION r
			join EAADMIN.country_code cc on cc.region_id = r.id
			join eaadmin.customer c on c.country_code_id = cc.id
			
		where c.status = \'ACTIVE\'
		
		group by r.id,r.name
		
		with ur";	
	
 return ('allRegions',$query, \@fields );	
}
