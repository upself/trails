package Sample::BravoHWSample;

use strict;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);


#super called.
sub getDeleteQuery {
    return 'delete from hardware where id=?';
}



