package IBM::Schema::SWCM::TDraftContract;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_draft_contract");
__PACKAGE__->add_columns(
  "dr_contract_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "dr_contract_id_ref",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "dr_con_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "dr_con_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "dr_con_supplier_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_con_supplier_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_con_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_con_con_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_con_con_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_con_owner",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_con_self_renewable",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_con_notice_period",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_con_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_con_end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_con_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "dr_con_cost_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "dr_con_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dr_con_commod_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_con_invoice_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "dr_con_invoice_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_con_invoice_amt",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "dr_con_invoice_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "dr_con_is_master",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_con_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "dr_con_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "dr_con_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "dr_con_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_con_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_con_colt_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 18,
  },
  "dr_con_con_nature_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_con_draft_reason_id",
  { data_type => "SMALLINT", default_value => 9, is_nullable => 0, size => 5 },
  "dr_con_dr_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "dr_con_last_modified_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "dr_con_icn",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
);
__PACKAGE__->set_primary_key("dr_contract_id");
__PACKAGE__->has_many(
  "t_dr_contract_transferabilities",
  "IBM::Schema::SWCM::TDrContractTransferability",
  { "foreign.dr_contract_id" => "self.dr_contract_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_con_status",
  "IBM::Schema::SWCM::TContractStatus",
  { contract_status_id => "dr_con_con_status_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_con_type",
  "IBM::Schema::SWCM::TContractType",
  { con_type_id => "dr_con_con_type_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "dr_con_customer_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_dr_user_data",
  "IBM::Schema::SWCM::TDraftUserData",
  { dr_user_data_id => "dr_con_dr_user_data_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_supplier",
  "IBM::Schema::SWCM::TSupplier",
  { supplier_id => "dr_con_supplier_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_draft_reason",
  "IBM::Schema::SWCM::TDraftReason",
  { draft_reason_id => "dr_con_draft_reason_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_con_nature",
  "IBM::Schema::SWCM::TContractNature",
  { contract_nature_id => "dr_con_con_nature_id" },
);
__PACKAGE__->belongs_to(
  "dr_con_cost_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "dr_con_cost_curr_code" },
);
__PACKAGE__->belongs_to(
  "dr_con_invoice_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "dr_con_invoice_curr_code" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zlYdYKAusRyDXz1Gw05mCA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
