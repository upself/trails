package IBM::IAMM::Schema::Result::AmLpidMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("am_lpid_map");
__PACKAGE__->add_columns(
  "am_lpid_map_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "am_lpid_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_name_map_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
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
__PACKAGE__->set_primary_key("am_lpid_map_id");
__PACKAGE__->belongs_to(
  "customer_name_map",
  "IBM::IAMM::Schema::Result::CustomerNameMap",
  { customer_name_map_id => "customer_name_map_id" },
);
__PACKAGE__->belongs_to(
  "am_lpid",
  "IBM::IAMM::Schema::Result::AmLpid",
  { am_lpid_id => "am_lpid_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UIHsEclwu/bBd7/Jz1e4rA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
