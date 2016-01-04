#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/..";
use Test::Class::Load qw(integration/Scarlet/Story38372);
use integration::reconEngine::Story38372::TestScarletReconcile;
use integration::reconEngine::Story36172::TC1;

my @tcs;

my $tc1 = integration::reconEngine::Story36172::TC1->new;
my $tc2 = integration::reconEngine::Story38372::TestScarletReconcile->new;
push @tcs, ( $tc1, $tc2 );    #tc2 rely on the result of tc1.

push @tcs, integration::Scarlet::Story38372::TestEndpoint->new;
push @tcs, integration::Scarlet::Story38372::TestScarletReconcile->new;

Test::Class->runtests(@tcs);

