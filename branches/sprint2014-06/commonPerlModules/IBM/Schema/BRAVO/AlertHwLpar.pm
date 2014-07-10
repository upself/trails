package IBM::Schema::BRAVO::AlertHwLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("alert_hw_lpar");
__PACKAGE__->add_columns(
  "hardware_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "creation_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "open",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
);
__PACKAGE__->set_primary_key("hardware_lpar_id", "id");
__PACKAGE__->add_unique_constraint("UALERTHWLPAR", ["id"]);
__PACKAGE__->belongs_to(
  "hardware_lpar",
  "IBM::Schema::BRAVO::HardwareLpar",
  { id => "hardware_lpar_id" },
);
__PACKAGE__->has_many(
  "alert_hw_lpar_hs",
  "IBM::Schema::BRAVO::AlertHwLparH",
  { "foreign.alert_hw_lpar_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yGb3L+zUgLE+lEjI46wMQA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
