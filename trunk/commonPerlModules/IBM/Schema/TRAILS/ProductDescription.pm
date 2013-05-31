package IBM::Schema::TRAILS::ProductDescription;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("product_description");
__PACKAGE__->add_columns(
  "product_description_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "product_description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("product_description_id");
__PACKAGE__->has_many(
  "license_baselines",
  "IBM::Schema::TRAILS::LicenseBaseline",
  {
    "foreign.product_description_id" => "self.product_description_id",
  },
);
__PACKAGE__->has_many(
  "license_maps",
  "IBM::Schema::TRAILS::LicenseMap",
  {
    "foreign.product_description_id" => "self.product_description_id",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0g5C42OxpxAIjGYDeWJ8uQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
