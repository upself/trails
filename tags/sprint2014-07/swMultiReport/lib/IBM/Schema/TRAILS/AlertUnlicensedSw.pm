package IBM::Schema::TRAILS::AlertUnlicensedSw;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("alert_unlicensed_sw");
__PACKAGE__->add_columns(
  "installed_software_id",
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
  "type",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
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
__PACKAGE__->set_primary_key("installed_software_id", "id");
__PACKAGE__->add_unique_constraint("IF1ALERTUNLICSW", ["id"]);
__PACKAGE__->add_unique_constraint("IF2ALERTUNLICSW", ["installed_software_id"]);
__PACKAGE__->add_unique_constraint(
  "IF3ALERTUNLICSW",
  [
    "open",
    "installed_software_id",
    "type",
    "remote_user",
    "creation_time",
  ],
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { id => "installed_software_id" },
);
__PACKAGE__->has_many(
  "alert_unlicensed_sw_hs",
  "IBM::Schema::TRAILS::AlertUnlicensedSwH",
  { "foreign.alert_unlicensed_sw_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pjheFddBXKp5+lJ+CB2UJw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
