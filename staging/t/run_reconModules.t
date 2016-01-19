#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';

use t::tests::Recon::ExpiredMaints;
# use t::tests::Recon::IBMISVprio;
use t::tests::Recon::scheduleFbyISW;

Test::Class->runtests;
