#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/..";
use Test::Group;
use Test::Class::Load qw(integration/reconEngine/Story36172);

my $tc1 = integration::reconEngine::Story36172::TC1->new;
my $tc2 = integration::reconEngine::Story36172::TC2->new;
my $tc3 = integration::reconEngine::Story36172::TC3->new;
my $tc4 = integration::reconEngine::Story36172::TC4->new;
my $tc5 = integration::reconEngine::Story36172::TC5->new;

Test::Class->runtests( $tc1, $tc5, $tc2, $tc3, $tc4 );    
#Test::Class->runtests( $tc1, $tc4 );
