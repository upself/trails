#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';

use t::tests::Test::Connection;

Test::Class->runtests;
