package IBM::Schema::TRAILS::CustomerView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer_view");
__PACKAGE__->add_columns(
  "pod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "pod_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_type_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "sector_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "industry_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "customer_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "account_number",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "full_name",
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
  "pod_project",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "customer_project",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "scope_status",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "scope",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZUMOjoNhm3WuZ8L1FzbxvQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
