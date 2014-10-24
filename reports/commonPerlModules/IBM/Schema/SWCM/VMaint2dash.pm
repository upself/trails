package IBM::Schema::SWCM::VMaint2dash;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_maint2dash");
__PACKAGE__->add_columns(
  "maint_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "maint_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 30,
  },
  "maint_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 500,
  },
  "maint_supplier_id",
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
  "sup_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "maint_customer_id",
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
  "maint_con_status_id",
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
  "maint_contact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "maint_self_renewable",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "maint_notice_period",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "maint_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "maint_end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "maint_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 0,
    size => 13,
  },
  "maint_cost_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "exchange_rate",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "maint_cost_in_usd",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "maint_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "maint_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "maint_colt_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 18,
  },
  "maint_con_nature_id",
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
  "maint_pur_order_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "maint_order_system_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "order_system",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 71,
  },
  "maint_order_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "maint_partid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "maint_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "maint_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8bIrggQAY9e+BRZVH5vJUQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
