package IBM::Schema::SWCM::TDraftLicense;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_draft_license");
__PACKAGE__->add_columns(
  "dr_license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "dr_lic_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "dr_lic_sw_manu_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_sw_manu_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_lic_sw_prod_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_sw_prod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 240,
  },
  "dr_lic_sw_vers_upgrade",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_orig_sw_manufact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_lic_owned_by_ibm",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_lic_supplier_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_supplier_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_lic_lic_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_cap_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_quantity",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "dr_lic_domain_limiter",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_perpetual",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_lic_end_date",
  {
    data_type => "DATE",
    default_value => "'2999-12-31'",
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_restricted_use",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_restriction",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dr_lic_reusable",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_multicustomer",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_serialnumber",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_activation_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_license_key",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_lic_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_vendor_contr_ref",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_ibm_contr_ref",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_vendor_termin_note",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_ibm_contact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_maintain_period",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "dr_lic_physical_license",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_physical_loc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_lic_dongle_phys_key",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_ibm_dongle_cont",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "dr_lic_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "dr_lic_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "dr_lic_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "dr_lic_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "dr_lic_comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "dr_lic_action_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_lic_pur_order_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "dr_lic_order_system_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_order_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "dr_lic_pa_partid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "dr_lic_os_type_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_minor_code_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_draft_reason_id",
  {
    data_type => "SMALLINT",
    default_value => "NULL",
    is_nullable => 0,
    size => 5,
  },
  "dr_lic_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "dr_lic_cost_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "dr_lic_phys_delivery_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "dr_lic_purchased",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_dr_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "dr_lic_version_num_ver",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_version_num_rel",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_version_num_mod",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "dr_lic_version_num_free",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "dr_lic_try_and_buy",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_original_sw_prod",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 240,
  },
  "dr_lic_last_modified_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "dr_lic_pool_usable",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 1,
    size => 1,
  },
  "dr_lic_cost_type_id",
  { data_type => "INTEGER", default_value => 1, is_nullable => 1, size => 10 },
  "dr_lic_sw_prod_pid",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 25,
  },
  "dr_lic_agree_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 2 },
);
__PACKAGE__->set_primary_key("dr_license_id");
__PACKAGE__->belongs_to(
  "dr_lic_sw_manu",
  "IBM::Schema::SWCM::TSwManufacturer",
  { sw_manufact_id => "dr_lic_sw_manu_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_cap_type",
  "IBM::Schema::SWCM::TCapacityType",
  { cap_type_id => "dr_lic_cap_type_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_order_country_code",
  "IBM::Schema::SWCM::TCountryCode",
  { country_code => "dr_lic_order_country_code" },
);
__PACKAGE__->belongs_to(
  "dr_lic_draft_reason",
  "IBM::Schema::SWCM::TDraftReason",
  { draft_reason_id => "dr_lic_draft_reason_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "dr_lic_customer_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_dr_user_data",
  "IBM::Schema::SWCM::TDraftUserData",
  { dr_user_data_id => "dr_lic_dr_user_data_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_sw_prod",
  "IBM::Schema::SWCM::TSwProduct",
  { sw_product_id => "dr_lic_sw_prod_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_lic_type",
  "IBM::Schema::SWCM::TLicenseType",
  { lic_type_id => "dr_lic_lic_type_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_minor_code",
  "IBM::Schema::SWCM::TMinorCode",
  { minor_code_id => "dr_lic_minor_code_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_order_system",
  "IBM::Schema::SWCM::TOrderSystem",
  { order_system_id => "dr_lic_order_system_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_os_type",
  "IBM::Schema::SWCM::TOsType",
  { os_type_id => "dr_lic_os_type_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_lic_status",
  "IBM::Schema::SWCM::TLicenseStatus",
  { lic_status_id => "dr_lic_lic_status_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_supplier",
  "IBM::Schema::SWCM::TSupplier",
  { supplier_id => "dr_lic_supplier_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_cost_type",
  "IBM::Schema::SWCM::TCostType",
  { cost_type_id => "dr_lic_cost_type_id" },
);
__PACKAGE__->belongs_to(
  "dr_lic_cost_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "dr_lic_cost_curr_code" },
);
__PACKAGE__->has_many(
  "t_lic_tiers",
  "IBM::Schema::SWCM::TLicTier",
  { "foreign.lic_tier_dr_lic_id" => "self.dr_license_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g/TUS9URWMBHio8EM9r4Ig


# You can replace this text with custom content, and it will be preserved on regeneration
1;
