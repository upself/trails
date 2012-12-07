package MifParser::inv40::Partition;

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

    $qh->{'FS Type'} = substr($qh->{'FS Type'},0,32); 

    $rc->[0] = "insert into ".$tablePre."inst_partition ".
            "(computer_sys_id, ".
            "fs_access_point, ".
            "dev_name, ".
            "partition_type,  ".
            "media_type, ".
            "physical_size_kb, ".
            "fs_type, ".
            "fs_mount_point, ".
            "fs_total_size_kb, ".
            "fs_free_size_kb) ".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{'FS Access Point'}."\',".
            "\'".$qh->{'Device Name'}."\',".
            "\'".$qh->{'Type'}."\',".
            "\'".$qh->{'Media Type'}."\',".
            "".$qh->{'Physical Size'}.",".
            "\'".$qh->{'FS Type'}."\',".
            "\'".$qh->{'FS Mount Point'}."\',".
            "".$qh->{'FS Total Size'}.",".
            "".$qh->{'FS Free Size'}.")\n";


     return $rc;
}

1;
