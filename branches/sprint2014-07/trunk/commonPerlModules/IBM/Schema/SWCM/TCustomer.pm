package IBM::Schema::SWCM::TCustomer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_customer");
__PACKAGE__->add_columns(
  "customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cus_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "cus_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
  "cus_ibm_exec",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "cus_contact_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "cus_contact_phone",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "cus_contact_email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "cus_subsidiary",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "cus_industry",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "cus_activity",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "cus_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "cus_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "cus_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "cus_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "cus_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cus_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("customer_id");
__PACKAGE__->add_unique_constraint("UC_CUSTOMER_NUMBER", ["cus_number"]);
__PACKAGE__->has_many(
  "t_accounts",
  "IBM::Schema::SWCM::TAccount",
  { "foreign.acc_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_contracts",
  "IBM::Schema::SWCM::TContract",
  { "foreign.con_customer_id" => "self.customer_id" },
);
__PACKAGE__->belongs_to(
  "cus_country_code",
  "IBM::Schema::SWCM::TCountryCode",
  { country_code => "cus_country_code" },
);
__PACKAGE__->has_many(
  "t_customer_cpus",
  "IBM::Schema::SWCM::TCustomerCpu",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_customer_lpars",
  "IBM::Schema::SWCM::TCustomerLpar",
  { "foreign.customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_draft_contracts",
  "IBM::Schema::SWCM::TDraftContract",
  { "foreign.dr_con_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_locs",
  "IBM::Schema::SWCM::TLoc",
  { "foreign.loc_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_named_cpuses",
  "IBM::Schema::SWCM::TNamedCpus",
  { "foreign.cpu_owning_customer_id" => "self.customer_id" },
);
__PACKAGE__->has_many(
  "t_notification_settings",
  "IBM::Schema::SWCM::TNotificationSetting",
  { "foreign.noti_set_customer_id" => "self.customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BfKD18TPEB4zV1zTY23tow


# You can replace this text with custom content, and it will be preserved on regeneration
1;
