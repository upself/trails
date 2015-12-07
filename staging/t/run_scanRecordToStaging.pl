#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';

use t::tests::scanRecordToStaging::removeSpacesAndNonDigits;
use t::tests::scanRecordToStaging::checkDateSyntax;

Test::Class->runtests;