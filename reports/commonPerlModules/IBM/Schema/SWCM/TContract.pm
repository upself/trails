package IBM::Schema::SWCM::TContract;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_contract");
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
  "con_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "con_con_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "con_con_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
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
    default_value => "'0'",
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
  "con_terms",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "con_commod_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "con_invoice_num",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "con_invoice_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "con_invoice_amt",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "con_invoice_curr_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 3 },
  "con_is_master",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
  "con_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "con_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "con_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "con_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
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
  "con_con_nature_id",
  { data_type => "SMALLINT", default_value => 1, is_nullable => 0, size => 5 },
  "con_del_re_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "con_del_re_comment",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "con_user_data_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "con_last_modified_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "con_icn",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
);
__PACKAGE__->set_primary_key("contract_id");
__PACKAGE__->has_many(
  "t_attachments_cons",
  "IBM::Schema::SWCM::TAttachmentsCon",
  { "foreign.contract_id" => "self.contract_id" },
);
__PACKAGE__->belongs_to(
  "con_cost_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "con_cost_curr_code" },
);
__PACKAGE__->belongs_to(
  "con_del_re",
  "IBM::Schema::SWCM::TDeletionReason",
  { del_re_id => "con_del_re_id" },
);
__PACKAGE__->belongs_to(
  "con_user_data",
  "IBM::Schema::SWCM::TUserData",
  { user_data_id => "con_user_data_id" },
);
__PACKAGE__->belongs_to(
  "con_con_nature",
  "IBM::Schema::SWCM::TContractNature",
  { contract_nature_id => "con_con_nature_id" },
);
__PACKAGE__->belongs_to(
  "con_invoice_curr_code",
  "IBM::Schema::SWCM::TCurrencyCode",
  { currency_code => "con_invoice_curr_code" },
);
__PACKAGE__->belongs_to(
  "con_con_status",
  "IBM::Schema::SWCM::TContractStatus",
  { contract_status_id => "con_con_status_id" },
);
__PACKAGE__->belongs_to(
  "con_supplier",
  "IBM::Schema::SWCM::TSupplier",
  { supplier_id => "con_supplier_id" },
);
__PACKAGE__->belongs_to(
  "con_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "con_customer_id" },
);
__PACKAGE__->belongs_to(
  "con_con_type",
  "IBM::Schema::SWCM::TContractType",
  { con_type_id => "con_con_type_id" },
);
__PACKAGE__->has_many(
  "t_contract_transferabilities",
  "IBM::Schema::SWCM::TContractTransferability",
  { "foreign.contract_id" => "self.contract_id" },
);
__PACKAGE__->has_many(
  "t_license_contracts",
  "IBM::Schema::SWCM::TLicenseContract",
  { "foreign.contract_id" => "self.contract_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w0VoA+rR9fQi4o7kUHXlfA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
