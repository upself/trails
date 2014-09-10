package IBM::IAMM::Schema::Result::RawEreqData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("raw_ereq_data");
__PACKAGE__->add_columns(
  "customer_number",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 7 },
  "geography",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "om_team",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 27,
  },
  "ship_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "product_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 54,
  },
  "cr_support",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 9 },
  "order_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "order_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "purchase_order",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "part_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "quantity_ordered",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 5 },
  "cr_received",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 5 },
  "received_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "inventoriable_flag",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "trackable_flag",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "manufacturer",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 27,
  },
  "accuracy",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "ps_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "ps_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 18,
  },
  "ps_retained",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "ps_exception",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
  "sample_ps",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sample_accuracy",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JJZrjqgc3RRkTGGLY0E2pw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
