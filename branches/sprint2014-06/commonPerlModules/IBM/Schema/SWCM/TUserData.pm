package IBM::Schema::SWCM::TUserData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_user_data");
__PACKAGE__->add_columns(
  "user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "user_data_field1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "user_data_field2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "user_data_field3",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "user_data_field4",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "user_data_field5",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "user_data_field6",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
);
__PACKAGE__->set_primary_key("user_data_id");
__PACKAGE__->has_many(
  "t_contracts",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_user_data_id" => "self.user_data_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_user_data_id" => "self.user_data_id" },
);
__PACKAGE__->has_many(
  "t_locs",
  "IBM::Schema::SWCM::TLoc",
  { "foreign.loc_user_data_id" => "self.user_data_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_user_data_id" => "self.user_data_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lEVU5zKKQdUFPtatE2DKUA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
