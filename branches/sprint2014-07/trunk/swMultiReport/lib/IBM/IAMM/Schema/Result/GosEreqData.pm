package IBM::IAMM::Schema::Result::GosEreqData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("gos_ereq_data");
__PACKAGE__->add_columns(
  "tracking_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "geography",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "order_analyst",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "order_count",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 5 },
  "review_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "review_time",
  { data_type => "TIME", default_value => undef, is_nullable => 1, size => 8 },
  "assigned_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "assigned_time",
  { data_type => "TIME", default_value => undef, is_nullable => 1, size => 8 },
  "order_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "order_time",
  { data_type => "TIME", default_value => undef, is_nullable => 1, size => 8 },
  "defect",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vXs7GEKEHfo/pFqDRkAjmA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
