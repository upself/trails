#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';
use t::tests::Test::SWCMLoader;
use t::tests::Test::BRAVODelegate;


Test::Class->runtests;
