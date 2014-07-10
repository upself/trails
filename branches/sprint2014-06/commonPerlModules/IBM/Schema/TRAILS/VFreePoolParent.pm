package IBM::Schema::TRAILS::VFreePoolParent;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_free_pool_parent");
__PACKAGE__->add_columns(
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "c_account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "l_account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "product_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "catalog_match",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "cap_type_code",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "cap_type_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 60,
  },
  "available_qty",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "quantity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "expire_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "cpu_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "po_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "owner",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 8 },
  "pool",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "full_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OsDBtiTLX1iDnFlmYx/19Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
