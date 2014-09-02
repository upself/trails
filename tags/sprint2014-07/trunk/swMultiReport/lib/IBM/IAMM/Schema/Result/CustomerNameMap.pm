package IBM::IAMM::Schema::Result::CustomerNameMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer_name_map");
__PACKAGE__->add_columns(
  "customer_name_map_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "am_customer_name_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("customer_name_map_id");
__PACKAGE__->add_unique_constraint(
  "IF1CUSTOMERNAMEMAP",
  ["am_customer_name_id", "customer_name_map_id"],
);
__PACKAGE__->has_many(
  "am_lpid_maps",
  "IBM::IAMM::Schema::Result::AmLpidMap",
  { "foreign.customer_name_map_id" => "self.customer_name_map_id" },
);
__PACKAGE__->belongs_to(
  "am_customer_name",
  "IBM::IAMM::Schema::Result::AmCustomerName",
  { am_customer_name_id => "am_customer_name_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UzP+rJXeR4CAGr2I8DpBbA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
