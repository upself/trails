package MifParser::inv40::PCSystemParams;

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

    $rc->[0] = "insert into ".$tablePre."pc_sys_params ".
            "(computer_sys_id, ".
            "user_name, ".
            "domain_name, ".
            "workgroup_name,  ".
            "bios_id, ".
            "bios_id_bytes, ".
            "bios_date, ".
            "bios_string, ".
            "bios_manufacturer, ".
            "bios_model, ".
            "bios_ser_num).".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'User Name'}."\',".
            "\'".$qh->{'Domain Name'}."\',".
            "\'".$qh->{'Workgroup Name'}."\',".
            "\'".$qh->{'Bios ID'}."\',".
            "\'".$qh->{'Bios ID Bytes'}."\',".
            "\'".$qh->{'Bios Date'}."\',".
            "\'".$qh->{'Bios String'}."\',".
            "\'".$qh->{'Bios Manufacturer'}."\',".
            "\'".$qh->{'Bios Model'}."\',".
            "\'".$qh->{'Bios Serial Number'}."\')\n";

     $rc->[1] =  "update ".$tablePre."computer ".
                "set computer_alias = \'".$qh->{"Computer Name"}."\' ".
                "where ".
                "computer_sys_id like \'$hwsysid\'\n";

     return $rc;
}

1;
