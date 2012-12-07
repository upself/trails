package MifParser::inv40::PointingDevice;

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

    $rc->[0] = "insert into ".$tablePre."inst_mouse ".
            "(computer_sys_id, ".
            "mouse_id, ".
            "inst_mouse_id) ".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Index'}."\')\n";


    $rc->[1] = "insert into ".$tablePre."mouse ".
            "(mouse_id, ".
            "buttons, ".
            "mouse_model, ".
            "mouse_type) ".
            "values ("."\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Number of Buttons'}."\',".
            "\'".$qh->{'Model'}."\',".
            "\'".$qh->{'Type'}."\')\n";

     return $rc;
}

1;
