package MifParser::inv40::SCAN_INFO;

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

    my $ep_short_name    = $qh->{'EP_SHORTNAME'};
    my $booted_os_name   = $qh->{'BOOTED_OS_NAME'};
    my $booted_os_vers   = $qh->{'BOOTED_OS_VERSION'};
    my $scan_date        = $qh->{'SCAN_DATE'};
    my $scan_time        = $qh->{'SCAN_TIME'};

    my $change_type      = 'INSERT';
    my $change_time      = getStamp();

    $rc = "insert into ".$tablePre."scan_info ".
            "(Hardware_System_Id,ep_shortname, booted_os_name, ".
            "booted_os_version,"." scan_date, scan_time, ".
            "config_change_type, config_change_time)".
            "values (\'".$hwsysid."\',\'".$ep_short_name."\',\'".
            $booted_os_name."\',\'".$booted_os_vers."\',\'".$scan_date.
            "\',\'".$scan_time."\',\'".$change_type."\',\'".
            $change_time."\')\n";

    return $rc;
}

sub getStamp {
    my @localtime = localtime();
    my $rc = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $localtime[5]+1900, $localtime[4]+1, $localtime[3], $localtime[2], $localtime[1], $localtime[0]);
}

1;
