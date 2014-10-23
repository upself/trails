package Sample::ReconHWLparSample;
use strict;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);

#super called.
sub getDeleteQuery {
	return 'delete from recon_hw_lpar where id= ?';
}

