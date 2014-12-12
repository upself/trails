#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';
use t::tests::ATPDelegate::getHWCustomerId;
use t::tests::ATPDelegate::getHWLparCustomerId;
use t::tests::ATPDelegate::processorCountLogic;

Test::Class->runtests;