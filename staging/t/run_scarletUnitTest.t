#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/..";
use Test::Class::Load qw(tests/Scarlet);


Test::Class->runtests();

