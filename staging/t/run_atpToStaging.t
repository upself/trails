#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';
use t::unit_test::ATPDelegate::getHWCustomerId;
use t::unit_test::ATPDelegate::getHWLparCustomerId;
use t::unit_test::ATPDelegate::processorCountLogic;
use t::unit_test::ATPDelegate::cpuIflLogic;

Test::Class->runtests;