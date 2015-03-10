#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';

use t::environment_test::Database::Connection;

Test::Class->runtests;
