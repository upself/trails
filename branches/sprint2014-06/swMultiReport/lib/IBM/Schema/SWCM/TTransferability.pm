package IBM::Schema::SWCM::TTransferability;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_transferability");
__PACKAGE__->add_columns(
  "transf_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "transf_transf_status_id",
  { data_type => "INTEGER", default_value => 5, is_nullable => 0, size => 10 },
  "transf_product_category_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "transf_geo_restriction_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "transf_geo_value",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "transf_os_restriction",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_os_type_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "transf_cost_restriction",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_transf_cost_amount",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "transf_transf_cost_curr_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "transf_upgrade_cost_amount",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "transf_upgrade_cost_curr_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "transf_noti_required",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_gra_allowed",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_gra_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "transf_gra_curr_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "transf_migration_allowed",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_incl_maint",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_maint_cost",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 13,
  },
  "transf_maint_curr_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
  "transf_maint_time_restr",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_maint_time_element",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "transf_maint_time_element_unit",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "transf_maint_upgrade",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_lic_downlevel",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_contract_taken_over",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "transf_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "transf_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("transf_id");
__PACKAGE__->has_many(
  "t_contract_transferabilities",
  "IBM::Schema::SWCM::TContractTransferability",
  { "foreign.transf_id" => "self.transf_id" },
);
__PACKAGE__->has_many(
  "t_dr_contract_transferabilities",
  "IBM::Schema::SWCM::TDrContractTransferability",
  { "foreign.transf_id" => "self.transf_id" },
);
__PACKAGE__->has_many(
  "t_dr_maintenance_transferabilities",
  "IBM::Schema::SWCM::TDrMaintenanceTransferability",
  { "foreign.transf_id" => "self.transf_id" },
);
__PACKAGE__->has_many(
  "t_maintenance_transferabilities",
  "IBM::Schema::SWCM::TMaintenanceTransferability",
  { "foreign.transf_id" => "self.transf_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i6eXFW5mG/M6yDLe+1lMAA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
