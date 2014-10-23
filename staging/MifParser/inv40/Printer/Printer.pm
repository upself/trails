package MifParser::inv40::Printer;

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

    $rc->[0] = "insert into ".$tablePre."inst_printer ".
            "(computer_sys_id, ".
            "printer_id, ".
            "inst_printer_id, ".
            "printer_name,  ".
            "printer_location, ".
            "printer_is_local, ".
            "drv_name, ".
            "drv_vers, ".
            "port_name).".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Index'}."\',".
            "\'".$qh->{'Name'}."\',".
            "\'".$qh->{'Location'}."\',".
            "\'".$qh->{'Is Local'}."\',".
            "\'".$qh->{'Driver Name'}."\',".
            "\'".$qh->{'Driver Vers'}."\',".
            "\'".$qh->{'Port Name'}."\')\n";


    $rc->[1] = "insert into ".$tablePre."printer ".
            "(printer_id, ".
            "printer_model) ".
            "values ("."\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Description'}."\')\n";

     return $rc;
}

1;
