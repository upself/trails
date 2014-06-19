package IBM::Schema::TRAILS::AlertHardware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("alert_hardware");
__PACKAGE__->add_columns(
  "hardware_id",
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
__PACKAGE__->set_primary_key("hardware_id", "id");
__PACKAGE__->add_unique_constraint("IF1ALERTHARDWARE", ["hardware_id"]);
__PACKAGE__->add_unique_constraint("IF2ALERTHARDWARE", ["id"]);
__PACKAGE__->add_unique_constraint(
  "IF3ALERTHARDWARE",
  ["open", "hardware_id", "remote_user", "creation_time"],
);
__PACKAGE__->belongs_to(
  "hardware",
  "IBM::Schema::TRAILS::Hardware",
  { id => "hardware_id" },
);
__PACKAGE__->has_many(
  "alert_hardware_hs",
  "IBM::Schema::TRAILS::AlertHardwareH",
  { "foreign.alert_hardware_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aE4Uf5wI9IRRbaTz+BtQtA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
