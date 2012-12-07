package MifParser::inv40::DASD_INV;

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

 my $self     = shift;
 my $tablePre = shift;
 my $hwsysid  = shift;
 return unless $hwsysid;

 my $qh = shift;

 my $physical_volumn         = $qh->{'PhysicalVolumn'};
 my $volumn_group            = $qh->{'VolumnGroup'};
 my $total_bytes             = $qh->{'TotalBytes'};
 my $used_bytes              = $qh->{'UsedBytes'};
 my $position                = $qh->{'Position'};
 my $connection              = $qh->{'Connection'};
 my $description             = $qh->{'Description'};
 my $pvid_lun                = $qh->{'PVID_LUN'};
 my $enclosure_location      = $qh->{'EnclosureLocation'};
 my $enclosure_serial_number = $qh->{'EnclosureSerialNumber'};
 my $change_type             = 'INSERT';
 my $change_time             = getStamp();

 $rc = "insert into " . $tablePre . "dasd_inv " .
   "(Hardware_System_Id,PhysicalVolumn, VolumnGroup, TotalBytes,"
   . " UsedBytes, Position, Connection, Description, PVID_LUN, "
   . "EnclosureLocation, EnclosureSerialNumber, config_change_type,config_change_time) "
   . "values (\'"
   . $hwsysid . "\',\'"
   . $physical_volumn . "\',\'"
   . $volumn_group . "\',\'"
   . $total_bytes . "\',\'"
   . $used_bytes . "\',\'"
   . $position . "\',\'"
   . $connection . "\',\'"
   . $description . "\',\'"
   . $pvid_lun . "\',\'"
   . $enclosure_location . "\',\'"
   . $enclosure_serial_number . "\',\'"
   . $change_type . "\',\'"
   . $change_time . "\')\n";

 return $rc;
}

sub getStamp {
 my @localtime = localtime();
 my $rc        = sprintf(
  "%04d-%02d-%02d %02d:%02d:%02d",
  $localtime[5] + 1900,
  $localtime[4] + 1,
  $localtime[3], $localtime[2], $localtime[1], $localtime[0]
 );
}
1;
