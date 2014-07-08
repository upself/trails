package IBM::Schema::SWCM::TProcurementContract;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_procurement_contract");
__PACKAGE__->add_columns(
  "agreement_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "agreement_version",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 4 },
  "vendor_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "vendor_country_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 60,
  },
  "contract_type_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 80,
  },
  "agreement_doctype_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 80,
  },
  "contract_subfamily_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "agreement_status_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 23 },
  "agreement_contract_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 300,
  },
  "employee_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "employee_internet_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 80,
  },
  "agreement_effective_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "agreement_expire_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "agreement_perpetual_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "agreement_estimated_amount",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 17,
  },
  "agreement_estimated_currency",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 5 },
  "parent_agreement_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "commodity_family_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 4 },
  "agreement_update_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "agreement_stage_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 20 },
  "procurement_company_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 140,
  },
  "agreement_local_country_code",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 50 },
  "agreement_activate_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "agreement_actual_term_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d2Of1Tp7rQ0Gc8pHSGL6yw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
