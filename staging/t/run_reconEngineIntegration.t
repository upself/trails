#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/..";
use Test::Class::Load qw(integration/reconEngine/Tests);

my $tc1 = integration::reconEngine::Tests::TC1->new;
my $tc2 = integration::reconEngine::Tests::TC2->new;
my $tc3 = integration::reconEngine::Tests::TC3->new;
my $tc4 = integration::reconEngine::Tests::TC4->new;
my $tc5 = integration::reconEngine::Tests::TC5->new;

my @tcs;

push @tcs, $tc1;
push @tcs, $tc5;
push @tcs, $tc2;
push @tcs, $tc3;
push @tcs, $tc4;    

Test::Class->runtests(@tcs);
