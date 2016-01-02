#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/..";    

use integration::reconEngine::Story36172::TC1;
use integration::reconEngine::Story38372::TC1;

my $reconTc1   = integration::reconEngine::Story36172::TC1->new;
my $scarletTc1 = integration::reconEngine::Story38372::TC1->new;

Test::Class->runtests( $reconTc1, $scarletTc1 );
