package IBM::IAMM::Schema::Result::BravoCounts;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bravo_counts");
__PACKAGE__->add_columns(
  "account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "customer_type_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "pod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "sw_interlock",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "geo",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "region",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "country",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "sector",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "hw_lpar_total",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 7 },
  "sw_lpar_total",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 7 },
  "hw_lpar_scan_percent",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 4 },
  "installed_total",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 9 },
  "unique_total",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 6 },
  "hw_no_lpar",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 7 },
  "hw_totals",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 7 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TTOIamavz8kjZHMYg9k1TQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
