package IBM::Schema::TRAILS::VCustomer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_customer");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "customer_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "pod",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "industry",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "sector",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:r6vg96LOs4J0BPo/YetfVg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
