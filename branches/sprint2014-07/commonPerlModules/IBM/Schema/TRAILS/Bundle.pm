package IBM::Schema::TRAILS::Bundle;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bundle");
__PACKAGE__->add_columns(
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 254,
  },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("software_id", "name", "id");
__PACKAGE__->add_unique_constraint("IF2BUNDLE", ["name"]);
__PACKAGE__->add_unique_constraint("IF1BUNDLE", ["id"]);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);
__PACKAGE__->has_many(
  "bundle_hs",
  "IBM::Schema::TRAILS::BundleH",
  { "foreign.bundle_id" => "self.id" },
);
__PACKAGE__->has_many(
  "bundle_softwares",
  "IBM::Schema::TRAILS::BundleSoftware",
  { "foreign.bundle_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gA7tzajQWo3tzp5FB8KESg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
