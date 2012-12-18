#!/usr/bin/perl
# !/usr/bin/perl -w

###############################################################################
# (C) COPYRIGHT IBM Corp. 2004
# All Rights Reserved
# Licensed Material - Property of IBM
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
###############################################################################

###############################################################################
# Name          : stagingImport.pl
# Component             : Staging
# Description   : Creates db2 import files for load into staging
# Author        : Alex Moise
# Date          : January 25, 2006
# Parameter(s)  : None
# Called By     : NULL
# Calls         : NULL
# Updates       :
#
#       WHO                     DATE            WHAT
#
#
#
###############################################################################
$VERSION = 'Version 1.0';
###############################################################################

###############################################################################
### Use/Require Statements
###
###############################################################################

use strict;
use Database::Connection;

###############################################################################
### Define Script Variables
###
###############################################################################

$| = 1;

my $SCRIPT = 'db_catalog.ksh';

my $scriptDir = '/opt/staging/v2';

###############################################################################
### Basic Checks
###
###############################################################################

###############################################################################
### Main
###
###############################################################################
my %check;
foreach (`db2 list node directory`) {
    chomp;
    next unless /Node name/;
    /(Node name).*\=\s+(.*)/;
    $check{$2} = 1;
}

my $connection   = Database::Connection->new('trails');
my @bankAccounts = getConnectedBankAccounts($connection);
$connection->disconnect;

foreach my $bankAccount ( ${@bankAccounts} ) {

    my $cmd =
          "$scriptDir/$SCRIPT "
        . $bankAccount->{ip}
        . $bankAccount->{dbName}
        . $bankAccount->{name}
        . $bankAccount->{name}
        . $bankAccount->{port}
        unless exists $check{ uc( $bankAccount->{name} ) };
    print "$cmd\n" if $cmd;
}

sub getConnectedBankAccounts {
    my ($connection) = @_;

    my @bankAccounts;

    $connection->prepareSqlQueryAndFields( queryConnectedBankAccounts() );
    my $sth = $connection->sql->{connectedBankAccounts};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{connectedBankAccountsFields} } );
    $sth->execute();

    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );
        my %data;
        push @bankAccounts, \%rec;
    }

    return @bankAccounts;
}

sub queryConnectedBankAccounts {
    my @fields = (qw( name port dbName ip ));
    my $query  = '
    select
        name
        ,database_port
        ,database_name
        ,database_ip
    from
        bank_account
    where
        status = \'ACTIVE\'
        and connection_type = \'CONNECTED\'
    with ur
    ';
    dlog("queryConnectedBankAccounts=$query");
    return ( 'connectedBankAccounts', $query, \@fields );
}
