package Sample::ReconHWSample;
use strict;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);

#super called.
sub getDeleteQuery {
	return 'delete from recon_hardware where id= ?';
}
