#!/usr/bin/perl -w

use FindBin;
use lib "$FindBin::Bin/..";
use Test::Class::Load qw(integration/reconEngine/Tests);

my @tcs;

my $tc1 = integration::reconEngine::Tests::TC1->new;
my $tc2 = integration::reconEngine::Tests::TestScarletReconcile->new;
push @tcs, ( $tc1, $tc2 );    #tc2 rely on the result of tc1.

push @tcs, integration::reconEngine::Tests::TestEndpoint->new;
push @tcs, integration::reconEngine::Tests::TestScarletReconcile->new;
push @tcs, integration::reconEngine::Tests::TC6->new;                  
push @tcs, integration::reconEngine::Tests::TC7->new;


$ENV{TEST_METHOD} = '.*39320.*';
Test::Class->runtests(@tcs);

