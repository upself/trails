package MifParser::inv40::Storage;

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


    $rc->[0] = "insert into ".$tablePre."storage_dev ".
            "(computer_sys_id, storage_class, inst_storage_id, storage_type,".
            "manufacturer, model, ser_num, hdisk_id) ".
            "values ("."\'".$hwsysid."\',".
            "\'".$qh->{''}."\',".
            "".$qh->{'Index'}.",".
            "\'".$qh->{'Type'}."\',".
            "\'".$qh->{'Manufacturer'}."\',".
            "\'".$qh->{'Model'}."\',".
            "\'".$qh->{'Serial Number'}."\',".
            "\'".$qh->{'ID'}."\')\n";


    $rc->[1] = "insert into ".$tablePre."hdisk ".
            "(hdisk_id, ".
            "hdisk_cylinders, ".
            "hdisk_sectors, ".
            "hdisk_heads,  ".
            "hdisk_size_mb) ".
            "values ("."\'".$qh->{'ID'}."\',".
            "".$qh->{'Cylinders'}.",".
            "".$qh->{'Sectors'}.",".
            "".$qh->{'Heads'}.",".
            "".$qh->{'Total Size'}.")\n";


     return $rc;
}

1;
