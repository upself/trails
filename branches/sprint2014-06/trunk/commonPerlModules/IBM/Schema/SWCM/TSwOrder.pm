package IBM::Schema::SWCM::TSwOrder;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_sw_order");
__PACKAGE__->add_columns(
  "sw_order_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "sw_order_po_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 10 },
  "sw_order_issue_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "sw_order_country_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_order_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 15,
  },
  "sw_order_cost_curr",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_order_vendor_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "sw_order_vendor_name",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 35 },
  "sw_order_vendor_ctry_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "sw_order_agreement_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "sw_order_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "sw_order_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "sw_order_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "sw_order_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("sw_order_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ta6xbHs2TJu5qSqMtTl/RQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
