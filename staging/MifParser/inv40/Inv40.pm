package MifParser::inv40::Inv40;

use Class::Struct;
use MifParser::MifParse;
use MifParser::inv40::UnixSysParams::UNIXSystemParams;
use MifParser::inv40::ComputerSysMem::Memory;
use MifParser::inv40::Computer::Regional;
use MifParser::inv40::Computer::OperatingSystem;
use MifParser::inv40::PCIDevice::PCIDevice;
use MifParser::inv40::IpAddr::IPAddress;
use MifParser::inv40::NetAdapter::NetworkAdapter;
use MifParser::inv40::Processor::Processor;
use MifParser::inv40::Storage::Storage;
use MifParser::inv40::Partition::Partition;
use MifParser::inv40::PCSysParams::PCSystemParams;
use MifParser::inv40::IpxAddr::IPXAddress;
use MifParser::inv40::VidCard::Video;
use MifParser::inv40::Printer::Printer;
use MifParser::inv40::USBDevice::USBDevice;
use MifParser::inv40::Mouse::PointingDevice;
use MifParser::inv40::UnMatched::TIV_Software_Files;
use MifParser::inv40::Matched::TIV_Signature_Keys;
use MifParser::inv40::Header::TIV_Header_Data;
use MifParser::inv40::Nativ::TIV_Registry_Entries;
use MifParser::inv40::Computer::ComponentID;
use MifParser::inv40::Computer::ScanInfo;
use MifParser::inv40::Computer::Keyboard;
use MifParser::inv40::DASDInv::DASD_INV;
use MifParser::inv40::ScanInfo::SCAN_INFO;
use MifParser::inv40::WinAuth::WIN_AUTH;
use MifParser::inv40::CpuCount::CPU_COUNT;
use Text::ParseWords;
use strict;

struct Inv40 => {
 parser     => 'MifParse',
 sigHashRef => '$',
 mifFile    => '$',
 debug      => '$',
 outFile    => '$',
 hwsysid    => '$',
 format     => '$',
 components => '@',
};

sub printData {
 my $self   = shift;
 my $groups = $self->parser->groups;
 my %tableParser;
 my $rc;

 # Look at all the components to print, if they do not have keys go ahead
 # and print them out (no need to look for table data in the mif file;

 print "All groups are: ", join ",", keys %{ $self->parser->groups }, "\n"
   if ( $self->debug == 1 );

 for ( my $i = 0 ; $i < ( scalar @{ $self->components } ) ; $i++ ) {
  print "The component is ", $self->components($i), "\n" if $self->debug;
  if ( exists $groups->{ $self->components($i) } ) {

   print "MATCH FOUND: " if $self->debug;
   print $groups->{ $self->components($i) }->name, "\n" if $self->debug == 1;

   if ( $groups->{ $self->components($i) }->key ) {
    print "key found, use table data\n" if $self->debug == 1;
    print "key:", $groups->{ $self->components($i) }->key, "\n"
      if $self->debug == 1;

    #$tableParser{$groups->{$self->components($i)}->name." Table"} =
    $tableParser{ $groups->{ $self->components($i) }->name } =
      $groups->{ $self->components($i) }->name;
   }
   else {
    print "No key, print the group data\n" if $self->debug == 1;

    my $mifComp;
    my $key = $groups->{ $self->components($i) }->name;

    $key =~ s/\s+//g;
    $mifComp = $key->new();

    if ($mifComp) {
     $mifComp->hwsysid( $self->hwsysid );
     $mifComp->group( $groups->{ $self->components($i) } );
     push @{$rc}, @{ $mifComp->createSQLLine( $self->format ) };
    }
   }

   print "\n" if $self->debug == 1;
  }
 }

 print "Now parsing table data in: ", $self->mifFile, "\n" if $self->debug;

 open MIF, $self->mifFile or die "Could not open " . $self->mifFile . "\n";

 my $startTable = 0;
 my $endTable   = 0;
 my $tableName;
 my $mifTable;

 while (<MIF>) {
  chomp;
  s/\r//;

  if (/^\s*Start Table/i) {
   $startTable = 1;
   $endTable   = 0;
   $tableName  = '';
   next;
  }
  elsif (/^\s*End Table/i) {
   $startTable = 0;
   $endTable   = 1;
   $tableName  = '';
   next;
  }

  if ($startTable) {
   if (/\s*name\s*=\s*(.*)/i) {

    #my $c_value = $1;
    #$c_value = s/\'//g;
    $tableName = ( quotewords( ",", 0, $1 ) )[0];
    $tableName =~ s/\s+Table//;
    my $compName = $tableName;
    $compName =~ s/\s+//g;
    print "tableName is $tableName\n" if $self->debug;
    print "keys are (from Table)  ", keys %tableParser, "\n"
      if $self->debug();
    if ( exists $tableParser{$tableName} ) {
     print "$tableParser{$tableName} exists\n" if $self->debug();
     $mifTable = $compName->new;
     $mifTable->hwsysid( $self->hwsysid );
     $mifTable->group( $groups->{ $tableParser{$tableName} } );
    }
    next;
   }
   next if (/\s*id\s*=\s*(.*)/i);
   next if (/\s*class\s*=\s*(.*)/i);

   if ( exists $tableParser{$tableName} ) {
    push @{$rc},
      $mifTable->createSQLLine( $self->format, $_, $self->sigHashRef );
   }
  }
 }

 #    foreach my $table (keys %tableParser) {
 #        print "Table: $tableParser{$table}\n";
 #        my $mifComp = PCIDev->new();
 #        $mifComp->hwsysid($self->hwsysid);
 #        $mifComp->group($mifComp->group($groups->{$table}));
 #        print $mifComp->createSQLAll($self->format);

 #    }

 return $rc;
}

sub getData {
 my $self   = shift;
 my $groups = $self->parser->groups;
 my %tableParser;
 my $rc;

 # Look at all the components to print, if they do not have keys go ahead
 # and print them out (no need to look for table data in the mif file;

 print "All groups are: ", join ",", keys %{ $self->parser->groups }, "\n"
   if ( $self->debug == 1 );

 for ( my $i = 0 ; $i < ( scalar @{ $self->components } ) ; $i++ ) {
  print "The component is ", $self->components($i), "\n" if $self->debug;
  if ( exists $groups->{ $self->components($i) } ) {

   print "MATCH FOUND: " if $self->debug;
   print $groups->{ $self->components($i) }->name, "\n" if $self->debug == 1;

   if ( $groups->{ $self->components($i) }->key ) {
    print "key found, use table data\n" if $self->debug == 1;
    print "key:", $groups->{ $self->components($i) }->key, "\n"
      if $self->debug == 1;

    #$tableParser{$groups->{$self->components($i)}->name." Table"} =
    $tableParser{ $groups->{ $self->components($i) }->name } =
      $groups->{ $self->components($i) }->name;
   }
   else {
    print "No key, print the group data\n" if $self->debug == 1;

    my $mifComp;
    my $key = $groups->{ $self->components($i) }->name;

    $key =~ s/\s+//g;
    $mifComp = $key->new();

    if ($mifComp) {
     $mifComp->hwsysid( $self->hwsysid );
     $mifComp->group( $groups->{ $self->components($i) } );
     push @{$rc}, $mifComp->createSQLLine( $self->format );

     #$rc .= $mifComp->createSQLLine($self->format);
    }
   }

   print "\n" if $self->debug == 1;
  }
 }

 print "Now parsing table data in: ", $self->mifFile, "\n" if $self->debug;

 open MIF, $self->mifFile or die "Could not open " . $self->mifFile . "\n";

 my $startTable = 0;
 my $endTable   = 0;
 my $tableName;
 my $mifTable;

 while (<MIF>) {
  chomp;
  s/\r//;

  if (/^\s*Start Table/i) {
   $startTable = 1;
   $endTable   = 0;
   $tableName  = '';
   next;
  }
  elsif (/^\s*End Table/i) {
   $startTable = 0;
   $endTable   = 1;
   $tableName  = '';
   next;
  }

  if ($startTable) {
   if (/\s*name\s*=\s*(.*)/i) {

    #my $c_value = $1;
    #$c_value = s/\'//g;
    $tableName = ( quotewords( ",", 0, $1 ) )[0];
    $tableName =~ s/\s+Table//;
    my $compName = $tableName;
    $compName =~ s/\s+//g;
    print "tableName is $tableName\n" if $self->debug;
    print "keys are (from Table)  ", keys %tableParser, "\n"
      if $self->debug();
    if ( exists $tableParser{$tableName} ) {
     print "$tableParser{$tableName} exists\n" if $self->debug();
     $mifTable = $compName->new;
     $mifTable->hwsysid( $self->hwsysid );
     $mifTable->group( $groups->{ $tableParser{$tableName} } );
    }
    next;
   }
   next if (/\s*id\s*=\s*(.*)/i);
   next if (/\s*class\s*=\s*(.*)/i);

   if ( exists $tableParser{$tableName} ) {
    push @{$rc},
      @{ $mifTable->createSQLLine( $self->format, $_, $self->sigHashRef ) };

    #$rc .= $mifTable->
    #    createSQLLine($self->format,$_,$self->sigHashRef);
   }
  }
 }

 #    foreach my $table (keys %tableParser) {
 #        print "Table: $tableParser{$table}\n";
 #        my $mifComp = PCIDev->new();
 #        $mifComp->hwsysid($self->hwsysid);
 #        $mifComp->group($mifComp->group($groups->{$table}));
 #        print $mifComp->createSQLAll($self->format);

 #    }

 return $rc;
}

1;
