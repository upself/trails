#!/usr/bin/perl -w

use strict;
use File::Find;
use File::Basename;

my $objgen = "perl " . dirname($0) . "/objgen.pl";

my @dirs  = ();
my @files = ();

push @dirs, ( dirname($0) . "/.." );
no warnings;
find(
	sub {
		next unless -f && -s;
		next unless m/.pm.xml$/;
		push( @files, $File::Find::name );
	},
	@dirs
);

foreach my $file (@files) {
	my $pm = basename($file);
	$pm =~ s/\.xml$//;
	my $outfile = dirname($file) . "/../" . $pm;
	print "generating: $outfile\n";
	open( OUTFILE, ">$outfile" )
	  or die "ERROR: Unable to write file $outfile: $!";
	my $cmd = "$objgen $file";
	open( CMD, "$cmd |" ) or die "ERROR: Unable to open command $cmd: $!";
	while (<CMD>) {
		print OUTFILE $_;
	}
	close(CMD);
	close(OUTFILE);
}

exit 0;
