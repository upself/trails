package IBM::Schema::TRAILS::LicenseBaseline;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("license_baseline");
__PACKAGE__->add_columns(
  "license_baseline_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "customer_id",
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
  "license_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "total_quantity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key(
  "customer_id",
  "product_description_id",
  "license_baseline_id",
  "license_type",
);
__PACKAGE__->add_unique_constraint("ULICENSEBASELINE", ["license_baseline_id"]);
__PACKAGE__->belongs_to(
  "product_description",
  "IBM::Schema::TRAILS::ProductDescription",
  { "product_description_id" => "product_description_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "license_details",
  "IBM::Schema::TRAILS::LicenseDetail",
  { "foreign.license_baseline_id" => "self.license_baseline_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+f7SH76FFd95A1moz83OLw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
