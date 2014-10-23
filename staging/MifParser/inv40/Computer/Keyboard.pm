package MifParser::inv40::ComputerKeyboard;

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

    my $type        = $qh->{'Type'};
    my $subType     = $qh->{'Sub Type'};
    my $cp          = $qh->{'Code Page'};
    my $function    = $qh->{'Number of Function Keys'};

    $rc = "update ".$tablePre."computer ".
            "set keyboard_type = \'$type\', ".
            "function_keys = \'$function\' ".
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
