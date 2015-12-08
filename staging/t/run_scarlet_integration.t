#!/usr/bin/perl -w

use FindBin;    
use lib "$FindBin::Bin/..";

use Test::Class::Load qw(integration/reconEngine/Story36172);

Test::Class->runtests;
