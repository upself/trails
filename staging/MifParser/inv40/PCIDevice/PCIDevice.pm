package MifParser::inv40::PCIDevice;

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
    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;    
    return unless $hwsysid;

    my $qh          = shift;

    my $index       = $qh->{'Index'};
    my $name        = $qh->{'Name'};

    my $rc = "insert into ".$tablePre."pci_dev ".
            "(computer_sys_id, inst_pci_id, pci_dev_name) ".
            "values ("."\'".$hwsysid."\',\'".$index."\',\'".$name."\')\n";

    return $rc;
}

1;
