package MifParser::inv40::USBDevice;

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

    $rc->[0] = "insert into ".$tablePre."inst_usb_dev ".
            "(computer_sys_id, ".
            "usb_id, ".
            "host_cntrl, ".
            "dev_addr,  ".
            "ser_num, ".
            "port_num, ".
            "parent_addr) ".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'ID'}."\',".
            "\'".$qh->{'Host Controller'}."\',".
            "\'".$qh->{'Device Address'}."\',".
            "\'".$qh->{'Serial Number'}."\',".
            "\'".$qh->{'Port Number'}."\',".
            "\'".$qh->{'Parent Address'}."\')\n";


    $rc->[1] = "insert into ".$tablePre."usb_dev ".
            "(usb_vers, ".
            "dev_class, ".
            "dev_subclass, ".
            "vendor_id,  ".
            "product_id, ".
            "manufacturer, ".
            "product, ".
            "num_of_ports, ".
            "dev_is_hub) ".
            "values ("."\'".$qh->{'ID'}."\',".
            "\'".$qh->{'USB Version'}."\',".
            "\'".$qh->{'Device Class'}."\',".
            "\'".$qh->{'Device Subclass'}."\',".
            "\'".$qh->{'Vendor ID'}."\',".
            "\'".$qh->{'Product ID'}."\',".
            "\'".$qh->{'Manufacturer'}."\',".
            "\'".$qh->{'Product'}."\',".
            "\'".$qh->{'Number of Ports'}."\',".
            "\'".$qh->{'IsHub'}."\')\n";

     return $rc;
}

1;
