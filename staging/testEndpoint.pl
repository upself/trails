#!/usr/bin/perl -w

use strict;
use Scarlet::LicenseEndpoint;
use Test::Simple tests => 1;

my $endpoint = Scarlet::LicenseEndpoint->new;


my $ids =
  $endpoint->httpGet( '84690', '96804d13f07b4d1d8371942fc6449ea7' );   

ok( defined $ids && ( scalar @{$ids} gt 0 ), 'scarlet license endpoint' );
