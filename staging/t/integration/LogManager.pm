package integration::LogManager;

use strict;

use Base::Utils;
use Base::ConfigManager;

sub configLog {
 my ( $self, $opt_f, $opt_l ) = @_;

 my $cfgMgr = Base::ConfigManager->instance($opt_f);
 logfile($opt_l);
 logging_level( $cfgMgr->debugLevel );
}

sub configDebugLevel {
 my ( $self, $logFile ) = @_;

 logfile($logFile);    
 logging_level('debug');
}

1;
