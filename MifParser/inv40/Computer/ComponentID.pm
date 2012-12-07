package MifParser::inv40::Computer::ComponentID;

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
    my $rc;

    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;

    return unless $hwsysid;
    my $qh          = shift;

    my $manufacturer        = $qh->{'Manufacturer'};
    my $product             = $qh->{'Product'};
    $product                = substr($product,0,31);
    my $version             = $qh->{'Version'};
    my $serial              = $qh->{'Serial Number'};

    $rc = "update ".$tablePre."computer ".
            "set computer_model = \'$product\', ".
            "sys_ser_num = \'$serial\' ".
            "where ".
            "computer_sys_id like \'$hwsysid\'\n";

    return $rc;
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get the standard sql delete statement 
# 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLDelete {
    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;
    return unless $hwsysid;

    my $rc = "delete from $tablePre"."computer_sys_mem where computer_sys_id".
        " like \'$hwsysid\'\n";

    return $rc;
}

1;
