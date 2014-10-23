package MifParser::inv40::TIV_Software_Files;

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
    my $sig         = shift; 
    my $sigFlag     = 0;

    if ($sig) {
        if (exists $sig->{$qh->{'File_Id'}}) {
        $rc->[0] = "insert into ".$tablePre."matched_sware ".
                "(computer_sys_id, ".
                "sware_sig_id) ".
                "values ("."\'".$hwsysid."\',".
                "\'".$qh->{'File_Id'}."\')\n";
        }
    }
    else { 
        $rc->[0] = "insert into ".$tablePre."unmatched_files ".
        "(computer_sys_id, ".
        "file_desc_id, ".
        "inst_path_id, ".
        "created_time, ".
        "modified_time, ".
        "accessed_time, ".
        "file_permissions, ".
        "file_owner, ".
        "file_group, ".
        "checksum_quick, ".
        "checksum_crc32, ".
        "checksum_md5) ".
        "values ("."\'".$hwsysid."\', ".
        "\'".$qh->{'File_Id'}."\', ".
        "\'".$qh->{'Path_Id'}."\', ".
        "\'".$qh->{'File_C_Time'}."\', ".
        "\'".$qh->{'File_M_Time'}."\', ".
        "\'".$qh->{'File_A_Time'}."\', ".
        "\'".$qh->{'File_Perms'}."\', ".
        "\'".$qh->{'File_Owner'}."\', ".
        "\'".$qh->{'File_Group'}."\', ".
        "\'".$qh->{'File_Q32'}."\', ".
        "\'".$qh->{'File_C32'}."\', ".
        "\'".$qh->{'File_MD5'}."\')\n";

        $rc->[1] = "insert into ".$tablePre."file_desc ".
        "(file_desc_id, ".
        "file_name, ".
        "file_size) ".
        "values ("."\'".$qh->{'File_Id'}."\', ".
        "\'".$qh->{'File_Name'}."\', ".
        "\'".$qh->{'File_Size'}."\')\n";

        $rc->[2] = "insert into ".$tablePre."file_path ".
        "(file_path_id, ".
        "path) ".
        "values ("."\'".$qh->{'Path_Id'}."\', ".
        "\'".$qh->{'File_Path'}."\')\n";
    }

    return $rc;
}

1;
