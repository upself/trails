package integration::reconEngine::CmdCreateScheduleFOnProduct;

use strict;
use base qw(integration::reconEngine::Properties);

sub new {
 my ( $class, $properties ) = @_;

 my $self = $class->SUPER::new($properties);

 bless $self, $class;
 return $self;

}

sub execute {
 my $self = shift;

 my $sql = "
 insert into schedule_f (customer_id, software_id, software_title,  software_name, 
 manufacturer, scope_id, source_id, source_location, status_id, business_justification,
 remote_user, record_time, level, sw_financial_resp)
 select 
 sl.customer_id, is.software_id, si.name, si.name, 
 'IBM',3,1, 'Test', 2, 'Test',
 'AUTO Test',current timestamp,'PRODUCT','IBM'
 from installed_software is, 
 software_lpar sl, 
 software_item si
 where 
 is.software_id = si.id
 and is.software_lpar_id = sl.id
 and is.id = ?";

 $self->connection->prepareSqlQuery( 'queryCmdCreateScheduleFOnHostname',
  $sql );
 my $sth = $self->connection->sql->{queryCmdCreateScheduleFOnHostname};
 $sth->execute( $self->installedSoftwareId );
 $sth->finish;
}

1;

