package MifParser::inv40::CPU_COUNT;

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

    my $ht_status      = $qh->{'HT_STATUS'};
    my $l_processor    = $qh->{'LOGICAL_PROCESSOR'};
    my $p_processor    = $qh->{'PHYSICAL_PROCESSOR'};

    my $change_type      = 'INSERT';
    my $change_time      = getStamp();

    if ($p_processor eq 'NULL') {
        $rc = "insert into ".$tablePre."cpu_count ".
            "(computer_sys_id,ht_status, logical_processor, physical_processor) ".
            "values (\'".$hwsysid."\',\'".$ht_status."\',".
            $l_processor.",NULL)\n";
    }
    else {
        $rc = "insert into ".$tablePre."cpu_count ".
            "(computer_sys_id,ht_status, logical_processor, physical_processor) ".
            "values (\'".$hwsysid."\',\'".$ht_status."\',".
            $l_processor.",".$p_processor.")\n";
    }

    #print "$rc\n";

    return $rc;
}

sub getStamp {
   my @localtime = localtime();
   my $rc = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $localtime[5]+1900 , $localtime[4]+1, $localtime[3], $localtime[2], $localtime[1], $localtime[0]);
}
1;
