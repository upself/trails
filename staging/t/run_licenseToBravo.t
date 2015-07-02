#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';

use t::tests::licenseToBravo::compareLicensesAndSetFlags;

Test::Class->runtests;
