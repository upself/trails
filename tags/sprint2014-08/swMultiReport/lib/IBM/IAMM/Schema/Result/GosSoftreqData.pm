package IBM::IAMM::Schema::Result::GosSoftreqData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("gos_softreq_data");
__PACKAGE__->add_columns(
  "sr_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "bond_cart_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "date_dpe_approved",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "time_dpe_approved",
  { data_type => "TIME", default_value => undef, is_nullable => 1, size => 8 },
  "bond_cart_order_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "bond_cart_order_time",
  { data_type => "TIME", default_value => undef, is_nullable => 1, size => 8 },
  "assignee",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RKNiMpvQHoS207MHwe3N6A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
