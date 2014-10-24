package IBM::Schema::TRAILS::Manufacturer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("manufacturer");
__PACKAGE__->add_columns(
  "manufacturer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "manufacturer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "change_justification",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
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
__PACKAGE__->set_primary_key("manufacturer_id");
__PACKAGE__->add_unique_constraint("IF1MANUFACTURER", ["manufacturer_name"]);
__PACKAGE__->add_unique_constraint(
  "IF2MANUFACTURER",
  ["status", "manufacturer_id", "manufacturer_name"],
);
__PACKAGE__->has_many(
  "manufacturer_hs",
  "IBM::Schema::TRAILS::ManufacturerH",
  { "foreign.manufacturer_id" => "self.manufacturer_id" },
);
__PACKAGE__->has_many(
  "softwares",
  "IBM::Schema::TRAILS::Software",
  { "foreign.manufacturer_id" => "self.manufacturer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ifys38a8b+4wR5m3ZoV1yg

sub id   { shift->id                }
sub name { shift->manufacturer_name }

# You can replace this text with custom content, and it will be preserved on regeneration
1;
