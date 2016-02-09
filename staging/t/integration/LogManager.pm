package integration::LogManager;

use strict;

use Base::Utils;
use Base::ConfigManager;

sub configLog {
 my ( $self, $opt_f, $opt_l ) = @_;

 my $cfgMgr = Base::ConfigManager->instance($opt_f);
 logfile($opt_l);
 logging_level( $cfgMgr->debugLevel );

 $self->checkAndInitLog($opt_l);    

}

sub configDebugLevel {
 my ( $self, $logFile ) = @_;

 logfile($logFile);
 logging_level('debug');

 $self->checkAndInitLog($logFile);
}

sub checkAndInitLog {
 my $self = shift;
 my $file = shift;

 if ( not $self->{_initiated}->{file} ) {
  init_log4perl;
  $self->{_initiated}->{file} = 1;
 }
}

1;
