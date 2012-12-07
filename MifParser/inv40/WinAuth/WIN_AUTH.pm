package MifParser::inv40::WIN_AUTH;

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

    my $server_type      = $qh->{'server_type'};
    my $user_count       = $qh->{'user_count'};
    my $creation_date    = $qh->{'creation_date'};

    my $change_type      = 'INSERT';
    my $change_time      = getStamp();

    $rc = "insert into ".$tablePre."win_auth ".
            "(computer_sys_id,server_type, user_count, creation_date) ".
            "values (\'".$hwsysid."\',\'".$server_type."\',".
            $user_count.",\'".$creation_date."\')\n";

    #print "$rc\n";

    return $rc;
}

sub getStamp {
   my @localtime = localtime();
   my $rc = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $localtime[5]+1900 , $localtime[4]+1, $localtime[3], $localtime[2], $localtime[1], $localtime[0]);
}
1;
