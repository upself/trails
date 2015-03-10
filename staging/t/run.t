#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';
use t::unit_test::SWCMLoader::SWCMLoader;
use t::unit_test::BRAVODelegate::BRAVODelegate;
use t::environment_test::Database::Connection;


Test::Class->runtests;
