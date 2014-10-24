package IBM::Schema::SWCM::TDraftMaintenance;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_draft_maintenance");
__PACKAGE__->add_columns(
  "dr_maint_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_maint_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "dr_maint_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "dr_maint_supplier_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_maint_supplier_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_maint_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_maint_con_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_maint_contact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_maint_self_renewable",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_maint_notice_period",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_maint_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_maint_end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_maint_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "dr_maint_cost_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "dr_maint_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dr_maint_commod_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_maint_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "dr_maint_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "dr_maint_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_maint_colt_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 18,
  },
  "dr_maint_con_nature_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_maint_pur_order_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "dr_maint_order_system_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_maint_order_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "dr_maint_pa_partid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "dr_maint_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "dr_maint_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_maint_draft_reason_id",
  { data_type => "SMALLINT", default_value => 11, is_nullable => 0, size => 5 },
  "dr_maint_minor_code_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_maint_dr_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "dr_maint_last_modified_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "dr_maint_sw_prod_pid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 25,
  },
);
__PACKAGE__->set_primary_key("dr_maint_id");
__PACKAGE__->has_many(
  "t_dr_maintenance_transferabilities",
  "IBM::Schema::SWCM::TDrMaintenanceTransferability",
  { "foreign.dr_maint_id" => "self.dr_maint_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_draft_reason",
  "IBM::Schema::SWCM::TDraftReason",
  { draft_reason_id => "dr_maint_draft_reason_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_con_nature",
  "IBM::Schema::SWCM::TContractNature",
  { contract_nature_id => "dr_maint_con_nature_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_minor_code",
  "IBM::Schema::SWCM::TMinorCode",
  { minor_code_id => "dr_maint_minor_code_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_dr_user_data",
  "IBM::Schema::SWCM::TDraftUserData",
  { dr_user_data_id => "dr_maint_dr_user_data_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_order_country_code",
  "IBM::Schema::SWCM::TCountryCode",
  { country_code => "dr_maint_order_country_code" },
);
__PACKAGE__->belongs_to(
  "dr_maint_con_status",
  "IBM::Schema::SWCM::TContractStatus",
  { contract_status_id => "dr_maint_con_status_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_supplier",
  "IBM::Schema::SWCM::TSupplier",
  { supplier_id => "dr_maint_supplier_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_order_system",
  "IBM::Schema::SWCM::TOrderSystem",
  { order_system_id => "dr_maint_order_system_id" },
);
__PACKAGE__->belongs_to(
  "dr_maint_cost_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "dr_maint_cost_curr_code" },
);
__PACKAGE__->belongs_to(
  "dr_maint_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "dr_maint_customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I0gg0snh/T6mZFQMJAKydw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
