package IBM::Schema::TRAILS::CustomerType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer_type");
__PACKAGE__->add_columns(
  "customer_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_type_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
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
__PACKAGE__->set_primary_key("customer_type_id", "customer_type_name");
__PACKAGE__->add_unique_constraint("IF2CUSTOMERTYPE", ["customer_type_name"]);
__PACKAGE__->add_unique_constraint("IF1CUSTOMERTYPE", ["customer_type_id"]);
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.customer_type_id" => "self.customer_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dNlW81OTTcskVWALK7DdIw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
