package MifParser::inv40::ComputerScanInfo;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::inv40::Component;
use Text::ParseWords;
use strict;
use base ("MifParser::inv40::Component");


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get the standard sql insert statement 
# 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLInsert {
    my $rc;

    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;

    return unless $hwsysid;
    my $qh          = shift;

    my $manufacturer        = $qh->{'Manufacturer'};
    my $majorVersion        = $qh->{'Major Version'};
    my $minorVersion        = $qh->{'Minor Version'};
    my $scan                = $qh->{'Scan Date'};
 
    $scan = dbstamp() unless $scan;

    $rc = "update ".$tablePre."computer ".
            "set computer_scantime = \'$scan\' ".
            "where ".
            "computer_sys_id like \'$hwsysid\'\n";

    return $rc;
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get the standard sql delete statement 
# 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLDelete {
    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;
    return unless $hwsysid;

    my $rc = "delete from $tablePre"."computer_sys_mem where computer_sys_id".
        " like \'$hwsysid\'\n";

    return $rc;
}

sub dbstamp {
    my @localtime = localtime();
    my $rc = sprintf("%04d-%02d-%02d-%02d.%02d.%02d.0000", $localtime[5]+1900,
        $localtime[4]+1, $localtime[3], $localtime[2], $localtime[1],
             $localtime[0]);
}

1;
