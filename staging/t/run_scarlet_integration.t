#!/usr/bin/perl -w

use lib '/opt/staging/v2';
use FindBin;    
use lib "$FindBin::Bin/..";

use integration::scarlet::Story36172_TC1;

Test::Class->runtests;
