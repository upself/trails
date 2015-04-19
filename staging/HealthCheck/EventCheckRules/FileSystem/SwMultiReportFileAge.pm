package HealthCheck::EventCheckRules::FileSystem::SwMultiReportFileAge;

use strict;
use Base::Utils;
use Net::FTP;
use POSIX;
use Config::Properties::Simple;

sub new {
 my ( $class, $rules ) = @_;
 my $self = { _ruels => $rules, };
 bless $self, $class;

 return $self;
}

sub validate() {
 return 1;
}

#parameter 1, staging connection config file path.
#parameter 2, the age of file need to count into the percentage.
sub assembleNotification() {

 my $self = shift;

 my $cfg =
   Config::Properties::Simple->new( file => ( $self->rules->metaRuleParameter1 ) );
 my $liveDays = $self->rules->metaRuleParameter2;

 my $hostName = $cfg->getProperty('gsa.swmulti.report.server');
 my $user     = $cfg->getProperty('gsa.swmulti.report.user');
 my $password = $cfg->getProperty('gsa.swmulti.report.password');
 my $path     = $cfg->getProperty('gsa.swmulti.report.target.folder');

 my $ftp = new Net::FTP( $hostName, Debug => 0 )
   or die "Cannot connect to some.host.name: $@";
 $ftp->login( $user, $password )
   or die "Cannot login ", $ftp->message;
 $ftp->cwd($path)
   or die "Cannot change working directory ", $ftp->message;
 my @fileList     = $ftp->ls();
 my $twoDaysInSec = 3600 * 24 * $liveDays;

 my $totalFilesCnt    = 0;
 my $over2DaysFileCnt = 0;

 foreach (@fileList) {
  my $timeDifferenceTillNowInSec = time - $ftp->mdtm($_);
  if ( $timeDifferenceTillNowInSec > $twoDaysInSec ) {
   $over2DaysFileCnt++;
  }
  $totalFilesCnt++;
 }
 $ftp->quit;

 my $p = $over2DaysFileCnt / $totalFilesCnt;
 $p = floor( ( $p * 100 + 0.5 ) );

 my $msg =    
"----------------------------------------------------------------------------------------------------------------------------------------------------------\n";
 $msg .= "Over 2 days sw-multi report percentage: $p \n";
 $msg .= "$over2DaysFileCnt of $totalFilesCnt file(s) are over 2 days";
 $msg .=
"----------------------------------------------------------------------------------------------------------------------------------------------------------\n";

 return $msg;

}

sub rules {
 my ( $self, $value ) = @_;
 $self->{_ruels} = $value if defined($value);
 return ( $self->{_ruels} );
}

1;

