package IBM::Schema::TRAILS::CustomerNumber;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer_number");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_number_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "creation_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "update_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("customer_id", "customer_number_id");
__PACKAGE__->add_unique_constraint("IF1CUSTOMERNUMBER", ["customer_number_id"]);
__PACKAGE__->add_unique_constraint("IF3CUSTOMERNUMBER", ["customer_number", "customer_id"]);
__PACKAGE__->add_unique_constraint("IF2CUSTOMERNUMBER", ["customer_number"]);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0sy7Bq47t5v1xQ293M1ONg

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.9 $))[1];
our $REVISION = '$Id: CustomerNumber.pm,v 1.9 2009/06/02 22:04:31 cweyl Exp $';
  
sub full_cndb_entry {
    my $self = shift @_;
  
    return $self
        ->result_source
        ->schema
        ->cndb
        ->resultset('CustomerNumber')
        ->search({ customer_number_id => $self->customer_number_id })
        ->first
        ;
} 
1;
