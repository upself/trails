package MifParser::inv40::NetworkAdapter;

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

    my $qh         = shift;
    my $type = $qh->{'Type'} ?  $qh->{'Type'} : $qh->{'Connector Type'};

    $rc = "insert into ".$tablePre."net_adapter ".
            "(computer_sys_id, perm_mac_addr, current_addr, adapter_type, ".
            "adapter_model, manufacturer, inst_date) ".
            "values ("."\'".$hwsysid."\',\'".$qh->{'Permanent Address'}."\',\'".
            $qh->{'Current Address'}."\',\'".$type."\',\'".
            $qh->{'Model'}."\',\'".$qh->{'Manufacturer'}."\',\'".
            $qh->{'Install Date'}."\')\n";

    return $rc;
}

1;
