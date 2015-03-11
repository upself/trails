#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';

use t::unit_test::HealthCheck::OM::Event;
Test::Class->runtests;
