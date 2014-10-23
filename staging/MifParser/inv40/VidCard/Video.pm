package MifParser::inv40::Video;

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

    $rc->[0] = "insert into ".$tablePre."inst_vid_card ".
            "(computer_sys_id, ".
            "vid_card_id, ".
            "inst_vid_card_id, ".
            "vid_horizntl_res,  ".
            "vid_vertical_res, ".
            "vid_colors).".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Index'}."\',".
            "\'".$qh->{'Horizontal'}."\',".
            "\'".$qh->{'Vertical'}."\',".
            "\'".$qh->{'Colors'}."\')\n";


    $rc->[1] = "insert into ".$tablePre."vid_card ".
            "(vid_card_id, ".
            "vid_card_model, ".
            "vid_card_bios, ".
            "vid_dac_type,  ".
            "vid_mem, ".
            "vid_bios_reldate, ".
            "vid_chip_type) ".
            "values ("."\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Adapter Name'}."\',".
            "\'".$qh->{'Bios Version'}."\',".
            "\'".$qh->{'DAC Type'}."\',".
            "\'".$qh->{'Memory'}."\',".
            "\'".$qh->{'Bios Release Date'}."\',".
            "\'".$qh->{'Chip Type'}."\')\n";

     return $rc;
}

1;
