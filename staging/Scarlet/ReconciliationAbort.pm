package Scarlet::ReconciliationAbort;

use strict;
use Base::Utils;
use Scarlet::LicenseEndpoint;
use Database::Connection;
use BRAVO::OM::Customer;
use Recon::ScarletInstalledSoftware;

sub new {
 my $class = shift;
 my $self  = {
  _skuEndpoint => new Scarlet::SkuEndpoint()
 };

 bless $self, $class;
}

sub skuEndpoint {
 my $self = shift;
 $self->{_skuEndpoint} = shift if scalar @_ == 1;
 return $self->{_skuEndpoint};
}

sub scarletAbort {
 my $self                       = shift;
 my $connection					= shift;
 my $hostnameonly				= shift;
 my $hwId						= shift;
 my $slId						= shift;
 my $customerNumber				= shift;
 my $installedSoftwareId		= shift;
 my $freePoolData				= shift;

 dlog("begin scarlet.scarletAbort");
 
 my $TORETURN = 0; # we should abort because of some dirty stuff

 my $sIs  = new Recon::ScarletInstalledSoftware();
 my $guid = $sIs->getGuiIdByInstalledSoftwareId($installedSoftwareId);

 my $GUIDs =
   $self->skuEndpoint->httpGet( $customerNumber, $guid );

 dlog( scalar @{$GUIDs} . ' GUID(s) found from scarlet.' );
 
 print $GUIDs[0]."   ".$GUIDs[1]."\n"; # debug
 
 $self->connection->prepareSqlQueryAndFields(
  $self->queryUsedGUIDs( $hostnameonly ) );
 my $sth = $self->connection->sql->{"usedGUIDs".$hostnameonly};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{"usedGUIDs".$hostnameonly."Fields"} } );

 $sth->execute($hwId, $slId);

 while ( $sth->fetchrow_arrayref ) {
    dlog("GUID = ".$rec{GUID}.", licenseID = ".$rec{lID});
  
    next unless ( grep ( $_ eq $rec{GUID}, @GUIDs ) ); # this isn't one of the GUIDs returned by JSON, so not our concern
  
    $TORETURN=1 unless ( exists $freePoolData{ $rec{lID} } ); # this IS one of the GUIDs from JSON, but the license used to it is not in our freePoolData!
 }
 $sth->finish;
 
 return $TORETURN;

}

sub queryUsedGUIDs {
 my $self      = shift;
 my $hostnameonly = shift;

 my @fields = qw(
   lId
   GUID
 );
 my $query = "
select
       ul.license_id, 
       kbd.guid 
from 
      used_license
      join reconcile_used_license rul
         on rul.used_license_id  =  ul.id
      join reconcile r 
         on rul . reconcile_id= r. id 
      installed_software is
         on is . id= r. installed_software_id 
      join software_lpar sl 
         on sl. id = is. software_lpar_id 
      join hw_sw_composite hsc 
         on hsc. software_lpar_id = sl . id 
      join hardware_lpar hl 
         on hl. id = hsc. hardware_lpar_id 
      join hardware h 
           on h. id = hl. hardware_id 
      join kb_definition kbd
		   on kbd.software_id = is.software_id
      where ";
  $query.="( h.id = ? and r.machine_level = 1 ) or " if ( $hostnameonly == 0 )
  $query.="sl.id = ?
        order by
        	l.id
        with ur
    ";

 dlog("Reading GUIDs query: $query");    # debug

 return ( 'usedGUIDs'.$hostnameonly, $query, \@fields );
}

1;
