package MifParser::inv40::ComputerOperatingSystem;

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

    my $os_name             = $qh->{'Name'};
    my $os_type             = $qh->{'Type'};
    my $os_major            = $qh->{'Major Version'};
    my $os_minor            = $qh->{'Minor Version'};
    my $os_sub              = $qh->{'Sub Version'};
    my $os_date             = $qh->{'Install Date'};
    my $owner             = $qh->{'Registered Owner'};
    my $org             = $qh->{'Registered Organization'};

    $os_major = $os_major ? $os_major : 'null';
    $os_minor = $os_minor ? $os_minor : 'null';
   
    $org   = s/\'//g;
    $owner = s/\'//g;

    my $scan = dbstamp();

    $rc = "update ".$tablePre."computer ".
            "set os_name = \'$os_name\', ".
            "os_type = \'$os_type\', ".
            "computer_scantime = \'$scan\', ".
            "os_major_vers = $os_major, ".
            "os_minor_vers  = $os_minor, ".
            "os_inst_date  = \'$os_date\', ".
            "registered_owner  = \'$owner\', ".
            "registered_org  = \'$org\', ".
            "os_sub_vers  = \'$os_sub\' ".
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
