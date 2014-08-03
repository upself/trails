package IBM::IAMM::Schema::Result::AmCustomerName;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("am_customer_name");
__PACKAGE__->add_columns(
  "am_customer_name_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "am_customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "dpam_shared",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
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
  "cdir_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "pool_cdir_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "country_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 4 },
);
__PACKAGE__->set_primary_key("am_customer_name_id");
__PACKAGE__->add_unique_constraint(
  "IF1AMCUSTOMERNAME",
  ["cdir_number", "am_customer_name_id", "am_customer_name"],
);
__PACKAGE__->has_many(
  "asset_tag_prefix_maps",
  "IBM::IAMM::Schema::Result::AssetTagPrefixMap",
  { "foreign.am_customer_name_id" => "self.am_customer_name_id" },
);
__PACKAGE__->has_many(
  "customer_name_maps",
  "IBM::IAMM::Schema::Result::CustomerNameMap",
  { "foreign.am_customer_name_id" => "self.am_customer_name_id" },
);
__PACKAGE__->has_many(
  "metric_results",
  "IBM::IAMM::Schema::Result::MetricResult",
  { "foreign.am_customer_name_id" => "self.am_customer_name_id" },
);
__PACKAGE__->has_many(
  "non_std_customers",
  "IBM::IAMM::Schema::Result::NonStdCustomers",
  { "foreign.am_customer_name_id" => "self.am_customer_name_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2KUNNGKR6nqG6tRvVPT7XA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
