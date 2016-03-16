#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';
use lib '/opt/staging/v2/t';

use t::tests::Recon::ExpiredMaints;
use t::tests::Recon::IBMISVprio;
use t::tests::Recon::scheduleFbyISW;
use t::tests::Recon::validateScheduleF;
# use t::tests::Recon::TestSkuEndpoint;

Test::Class->runtests;
