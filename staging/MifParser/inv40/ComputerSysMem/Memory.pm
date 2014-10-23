package MifParser::inv40::ComputerSysMem::Memory;

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

 my $total_physical = $qh->{'Total Physical'};
 my $total_free     = $qh->{'Free Physical'};
 my $total_pages    = $qh->{'Total Page'};
 my $free_pages     = $qh->{'Free Page'};
 my $page_size      = $qh->{'Page Size'};
 my $virt_total     = $qh->{'Total Virtual'};
 my $virt_free      = $qh->{'Free Virtual'};

 $rc =
     "insert into "
   . $tablePre
   . "computer_sys_mem "
   . "(computer_sys_id,physical_total_kb,physical_free_kb,total_pages,"
   . "free_pages,page_size,virt_total_kb,virt_free_kb) values (" . "\'"
   . $hwsysid . "\',"
   . $total_physical . ","
   . $total_free . ","
   . $total_pages . ","
   . $free_pages . ","
   . $page_size . ","
   . $virt_total . ","
   . $virt_free . ")\n";

 return $rc;
}

1;
