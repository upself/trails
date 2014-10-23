#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use Recon::ReconAffectedInstalledSw;

###Check usage.
use vars qw( $opt_l  );
getopts("l:");
die "Usage: $0" . " -l <refresh by software lpar> \n"
  unless ( defined $opt_l );

my $loader = new Recon::ReconAffectedInstalledSw;
#0 by installed software
#1 by software lpar.
$loader->execute($opt_l);
