package IBM::Schema::TRAILS::AlertSwLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("alert_sw_lpar");
__PACKAGE__->add_columns(
  "software_lpar_id",
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
__PACKAGE__->set_primary_key("software_lpar_id", "id");
__PACKAGE__->add_unique_constraint("IF1ALERTSWLPAR", ["software_lpar_id"]);
__PACKAGE__->add_unique_constraint("IF2ALERTSWLPAR", ["id"]);
__PACKAGE__->add_unique_constraint("IF4ALERTSWLPAR", ["software_lpar_id", "creation_time"]);
__PACKAGE__->add_unique_constraint(
  "IF3ALERTSWLPAR",
  ["software_lpar_id", "open", "remote_user", "creation_time"],
);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { id => "software_lpar_id" },
);
__PACKAGE__->has_many(
  "alert_sw_lpar_hs",
  "IBM::Schema::TRAILS::AlertSwLparH",
  { "foreign.alert_sw_lpar_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JTpgUBREZ/jMHZPJPDi54A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
