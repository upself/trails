package IBM::IAMM::Schema::Result::AssetTagPrefixMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("asset_tag_prefix_map");
__PACKAGE__->add_columns(
  "asset_tag_prefix_map_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "am_customer_name_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "asset_tag_prefix",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
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
);
__PACKAGE__->set_primary_key("asset_tag_prefix_map_id");
__PACKAGE__->belongs_to(
  "am_customer_name",
  "IBM::IAMM::Schema::Result::AmCustomerName",
  { am_customer_name_id => "am_customer_name_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:u0+3HmTymnS/8LpDyZRWtA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
