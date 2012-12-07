#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use Recon::ReconEngineCustomer;
use Base::ConfigManager;
use Tap::NewPerl; 


	logfile('/home/alexmois/output.out');
	logging_level('debug');

    my $reconEngine = new Recon::ReconEngineCustomer(4040,'2011-11-08');
    $reconEngine->recon;

exit 0;
