package MifParser::inv40::IPXAddress;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::inv40::Component;
use Text::ParseWords;
use strict;
use base ("MifParser::inv40::Component");

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to print the header SQL object.  In this case a delete
# Statement to cleanup data
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub createSQLHeader {
    my $self    = shift;
    return unless $self->hwsysid;

    # This method is probally not needed anymore, we will be assuming that
    # a global header is set first off the bat.  This will prevent ownership
    # at the object label.
}

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

    $rc->[1] = "insert into ".$tablePre."pc_sys_params ".
            "(computer_sys_id, ".
            "ipx_addr, ".
            "net_num, ".
            "node_addr,  ".
            "link_speed, ".
            "max_packet_size).".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'Address'}."\',".
            "\'".$qh->{'Network Number'}."\',".
            "\'".$qh->{'Node Address'}."\',".
            "\'".$qh->{'Link Speed'}."\',".
            "\'".$qh->{'Max Packet Size'}."\')\n";


     return $rc;
}

1;
