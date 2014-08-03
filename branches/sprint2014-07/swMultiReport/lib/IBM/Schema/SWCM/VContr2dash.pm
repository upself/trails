package IBM::Schema::SWCM::VContr2dash;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_contr2dash");
__PACKAGE__->add_columns(
  "contract_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "contract_id_ref",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "con_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 30,
  },
  "con_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 500,
  },
  "con_supplier_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "supplier_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
  "cus_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cus_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
  "con_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "contract_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 61,
  },
  "con_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "contract_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 71,
  },
  "con_owner",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "con_self_renewable",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "con_notice_period",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "con_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "con_end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "con_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "con_cost_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "exchange_rate",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "con_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "invoice_amount",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "invoice_currency_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "invoice_currency_rate",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "con_is_master",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "con_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "con_colt_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 18,
  },
  "contract_nature_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "contract_nature",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 171,
  },
  "con_icn",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "con_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "con_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:b7xlvzxGPPshnt8RvAlDzQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
