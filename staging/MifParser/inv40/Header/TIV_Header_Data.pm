package MifParser::inv40::TIV_Header_Data;

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

    my $qh          = shift;

    $rc->[1] = "insert into ".$tablePre."inst_header_info ".
        "(computer_sys_id, ".
        "header_id) ".
        "values ("."\'".$hwsysid."\', ".
        "\'".$qh->{'Header_Key'}."\')\n";

    $rc->[0] = "insert into ".$tablePre."header_info ".
        "(header_id, ".
        "header_name, ".
        "header_vers, ".
        "header_publisher) ".
        "values ("."\'".$qh->{'Header_Key'}."\', ".
        "\'".$qh->{'Header_Name'}."\', ".
        "\'".$qh->{'Header_Vers'}."\', ".
        "\'".$qh->{'Header_Publ'}."\')\n";

    return $rc;
}
1;
