package MifParser::inv40::ComputerRegional;

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

    my $tz_locale           = $qh->{'Local'};
    my $tz_seconds          = $qh->{'Time Zone Seconds'};
    my $tz_plus             = $qh->{'Time Zone Plus Minus'};
    my $daylight            = $qh->{'Daylight'};
    my $tz_name             = $qh->{'Time Zone Name'};
    my $tz_dayname          = $qh->{'Time Zone Daylight Name'};

    $rc = "update ".$tablePre."computer ".
            "set tz_locale = \'$tz_locale\', ".
            "tz_name = \'$tz_name\', ".
            "tz_daylight_name = \'$tz_dayname\', ".
            "on_savings_time  = \'$daylight\', ".
            "tz_seconds  = $tz_seconds, ".
            "time_direction  = \'$tz_plus\' ".
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

1;
