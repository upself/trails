package integration::reconEngine::CmdDeleteScheduleFOnProduct;

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
 delete from schedule_f where id in (
 select 
  sf.id
 from 
 schedule_f sf, 
 installed_software is, 
 software_lpar sl, 
 software_item si
 where 
 is.software_id = si.id
 and is.software_lpar_id = sl.id
 and is.id = ?
 and sf.software_id = si.id
 and sf.software_name = si.name
 and sf.customer_id = sl.customer_id
 and sf.level = 'PRODUCT'
)";

 $self->connection->prepareSqlQuery( 'queryCmdDeleteScheduleFOnProduct', $sql );
 my $sth = $self->connection->sql->{queryCmdDeleteScheduleFOnProduct};
 $sth->execute( $self->installedSoftwareId );
 $sth->finish;
}

1;

