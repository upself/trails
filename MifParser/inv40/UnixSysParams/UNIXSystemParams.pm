package MifParser::inv40::UnixSysParams::UNIXSystemParams;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::inv40::Component;
use Text::ParseWords;
use strict;
use base ("MifParser::inv40::Component");

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get a stnadard SQL insert
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLInsert {
 my $rc;

 my $self     = shift;
 my $tablePre = shift;

 my $hwsysid = shift;
 return unless $hwsysid;

 my $qh = shift;

 my $bootTime = $qh->{'Boot Time'};
 my $upTime   = $qh->{'Uptime'};
 my $runLevel = $qh->{'Run Level'};
 my $hostname = $qh->{'Hostname'};

 $rc->[0] =
     "insert into "
   . $tablePre
   . "unix_sys_params "
   . "(computer_sys_id,boot_time,uptime,run_level,host_name) values(" . "\'"
   . $hwsysid . "\',\'"
   . $bootTime . "\',\'"
   . $upTime . "\',\'"
   . $runLevel . "\',\'"
   . $hostname . "\')\n";

 $rc->[1] =
     "update "
   . $tablePre
   . "computer "
   . "set computer_alias = \'$hostname\', "
   . "computer_boot_time = \'$bootTime\' "
   . "where "
   . "computer_sys_id like \'$hwsysid\'\n";

 return $rc;
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get a stnadard SQL delete
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLDelete {
 my $self     = shift;
 my $tablePre = shift;
 my $hwsysid  = shift;
 return unless $hwsysid;

 my $rc =
     "delete from $tablePre"
   . "unix_sys_params where computer_sys_id"
   . " like \'$hwsysid\'\n";

 return $rc;
}

1;
