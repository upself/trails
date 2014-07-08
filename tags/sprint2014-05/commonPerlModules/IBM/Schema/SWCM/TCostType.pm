package IBM::Schema::SWCM::TCostType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_cost_type");
__PACKAGE__->add_columns(
  "cost_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cost_type_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cost_type_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "cost_type_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "cost_type_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("cost_type_id");
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_cost_type_id" => "self.cost_type_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_cost_type_id" => "self.cost_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jZnyJPwzwqOeyZbmKwNQhw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
