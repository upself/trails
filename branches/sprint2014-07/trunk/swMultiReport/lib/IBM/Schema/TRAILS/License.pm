package IBM::Schema::TRAILS::License;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("license");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "lic_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cap_type",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "quantity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "ibm_owned",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "draft",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "pool",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "try_and_buy",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "expire_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "po_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "prod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "full_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "cpu_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "license_status",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "agreement_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 2 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("IF2LICENSE", ["ext_src_id"]);
__PACKAGE__->add_unique_constraint(
  "IF1LICENSE",
  ["status", "pool", "ibm_owned", "id", "customer_id"],
);
__PACKAGE__->has_many(
  "alert_expired_maints",
  "IBM::Schema::TRAILS::AlertExpiredMaint",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "license_recon_maps",
  "IBM::Schema::TRAILS::LicenseReconMap",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->has_many(
  "license_recon_map_hs",
  "IBM::Schema::TRAILS::LicenseReconMapH",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->has_many(
  "license_sw_maps",
  "IBM::Schema::TRAILS::LicenseSwMap",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_licenses",
  "IBM::Schema::TRAILS::ReconLicense",
  { "foreign.license_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LsyBUA5WTq9D7yaGtA/laQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
