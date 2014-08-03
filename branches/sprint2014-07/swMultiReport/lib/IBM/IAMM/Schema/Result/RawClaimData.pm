package IBM::IAMM::Schema::Result::RawClaimData;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("raw_claim_data");
__PACKAGE__->add_columns(
  "month",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "department",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "lpid",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "account_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "work_item",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "work_item_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "activity",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "account_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "fa_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "billable_hrs",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "country_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "division",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "country",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "account_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "account_major",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "fin_chg_major",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "fin_rel_major",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "customer_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "account_group_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "account_group_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "account_group_cust_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 4 },
  "app_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "app_code_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "emp_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "emp_initials",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "emp_last_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "band",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "lotus_notes_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0RrhGfxMVO7Vy+wgPqyslw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
