package IBM::Schema::SWCM::TMaintenance;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_maintenance");
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
  "maint_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "maint_con_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
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
    default_value => "'0'",
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
  "maint_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "maint_commod_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "maint_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "maint_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
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
  "maint_order_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "maint_pa_partid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "maint_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => "'NONE'",
    is_nullable => 0,
    size => 20,
  },
  "maint_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => "'NONE'",
    is_nullable => 0,
    size => 10,
  },
  "maint_del_re_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "maint_del_re_comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "maint_minor_code_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "maint_renewed",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "maint_renewal_decision_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "maint_renewal_ref",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "maint_renewal_comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "maint_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "maint_last_modified_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "maint_sw_prod_pid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 25,
  },
);
__PACKAGE__->set_primary_key("maint_id");
__PACKAGE__->has_many(
  "t_attachments_maints",
  "IBM::Schema::SWCM::TAttachmentsMaint",
  { "foreign.maint_id" => "self.maint_id" },
);
__PACKAGE__->has_many(
  "t_license_maintenances",
  "IBM::Schema::SWCM::TLicenseMaintenance",
  { "foreign.maint_id" => "self.maint_id" },
);
__PACKAGE__->belongs_to(
  "maint_supplier",
  "IBM::Schema::SWCM::TSupplier",
  { supplier_id => "maint_supplier_id" },
);
__PACKAGE__->belongs_to(
  "maint_user_data",
  "IBM::Schema::SWCM::TUserData",
  { user_data_id => "maint_user_data_id" },
);
__PACKAGE__->belongs_to(
  "maint_con_nature",
  "IBM::Schema::SWCM::TContractNature",
  { contract_nature_id => "maint_con_nature_id" },
);
__PACKAGE__->belongs_to(
  "maint_del_re",
  "IBM::Schema::SWCM::TDeletionReason",
  { del_re_id => "maint_del_re_id" },
);
__PACKAGE__->belongs_to(
  "maint_order_country_code",
  "IBM::Schema::SWCM::TCountryCode",
  { country_code => "maint_order_country_code" },
);
__PACKAGE__->belongs_to(
  "maint_order_system",
  "IBM::Schema::SWCM::TOrderSystem",
  { order_system_id => "maint_order_system_id" },
);
__PACKAGE__->belongs_to(
  "maint_con_status",
  "IBM::Schema::SWCM::TContractStatus",
  { contract_status_id => "maint_con_status_id" },
);
__PACKAGE__->belongs_to(
  "maint_minor_code",
  "IBM::Schema::SWCM::TMinorCode",
  { minor_code_id => "maint_minor_code_id" },
);
__PACKAGE__->belongs_to(
  "maint_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "maint_customer_id" },
);
__PACKAGE__->belongs_to(
  "maint_cost_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "maint_cost_curr_code" },
);
__PACKAGE__->has_many(
  "t_maintenance_transferabilities",
  "IBM::Schema::SWCM::TMaintenanceTransferability",
  { "foreign.maint_id" => "self.maint_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:c/9tYxGijFyZFEMVMcEgqA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
