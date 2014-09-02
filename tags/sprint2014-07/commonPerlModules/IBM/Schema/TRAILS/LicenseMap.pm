package IBM::Schema::TRAILS::LicenseMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("license_map");
__PACKAGE__->add_columns(
  "license_map_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "software_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "product_description_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("product_description_id", "software_id", "license_map_id");
__PACKAGE__->add_unique_constraint("ULICENSEMAP", ["license_map_id"]);
__PACKAGE__->belongs_to(
  "product_description",
  "IBM::Schema::TRAILS::ProductDescription",
  { "product_description_id" => "product_description_id" },
);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DRqUg+U4HBFeBeOxt+/u2A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
