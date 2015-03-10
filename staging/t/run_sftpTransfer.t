#!/usr/bin/env perl -T

use lib '/opt/staging/v2/';
use lib '/home/michal.g/';
use t::unit_test::sftpTransfer::sftpTransfer;

# global variables
our $name; # name of this FTP session processed
our $direction; # remote to local or local to remote
our $srchostname; # remote hostname of source
our $tgthostname; # remote hostname of target
our $source; # source directory
our $target; # target directory
our $filemask; # regular expression to match the filename
our $delsource; # true false whether to keep the original files after successful copy
our $minage; # minimum age of file, in minutes
our $flag; # a special file marking the files are ready (is by itself never transferred
our $srcftpuser; # source FTP user
our $srcftppwd; # source FTP password
our $tgtftpuser; # target FTP user
our $tgtftppwd; # target FTP password

our $flagispresent; # flag is present

our %processednames; # hash of all the processed FTP sessions

Test::Class->runtests;
