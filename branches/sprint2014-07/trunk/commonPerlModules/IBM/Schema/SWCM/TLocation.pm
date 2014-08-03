package IBM::Schema::SWCM::TLocation;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_location");
__PACKAGE__->add_columns(
  "location_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "location_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "location_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "location_dc_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "location_dc_resp",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "location_site_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "location_address1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 35,
  },
  "location_address2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 75,
  },
  "location_zip_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "location_city",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 35,
  },
  "location_state_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "location_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "location_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "location_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
  "location_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "location_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("location_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8eXgBYigEhODKAIvGhZymQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
