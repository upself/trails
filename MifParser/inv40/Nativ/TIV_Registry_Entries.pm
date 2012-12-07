package MifParser::inv40::TIV_Registry_Entries;

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

    #$qh->{'Entry_Name'} = substr ($qh->{'Entry_Name'},0,64);

    $rc->[0] = "insert into ".$tablePre."nativ_sware ".
        "(nativ_id, ".
        "package_name, ".
        "package_vers, ".
       "publisher, ".
        "package_id) ".
        "values ("."\'".$qh->{'Entry_Key'}."\', ".
        "\'".$qh->{'Entry_Name'}."\', ".
        "\'".$qh->{'Entry_Vers'}."\', ".
        "\'".$qh->{'Entry_Publ'}."\', ".
        "\'".$qh->{'Entry_PkId'}."\')\n";

    $rc->[1] = "insert into ".$tablePre."inst_nativ_sware ".
        "(computer_sys_id, ".
        "file_path, ".
        "nativ_id) ".
        "values ("."\'".$hwsysid."\', ".
        "\'".$qh->{'Entry_Path'}."\', ".
        "\'".$qh->{'Entry_Key'}."\')\n";

    return $rc;
}
1;
