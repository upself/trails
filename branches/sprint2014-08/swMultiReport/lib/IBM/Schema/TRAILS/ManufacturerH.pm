package IBM::Schema::TRAILS::ManufacturerH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("manufacturer_h");
__PACKAGE__->add_columns(
  "manufacturer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "manufacturer_h_id",
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
__PACKAGE__->set_primary_key("manufacturer_id", "manufacturer_h_id");
__PACKAGE__->add_unique_constraint("IF1MANUFACTURERH", ["manufacturer_h_id"]);
__PACKAGE__->belongs_to(
  "manufacturer",
  "IBM::Schema::TRAILS::Manufacturer",
  { manufacturer_id => "manufacturer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5FWl9XCKi25bAEXxN449tQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
