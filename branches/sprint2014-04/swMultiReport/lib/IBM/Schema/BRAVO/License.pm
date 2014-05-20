package IBM::Schema::BRAVO::License;

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
  "po_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "po_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "cpu_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ibm_owned",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "expire_date",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "quantity",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "full_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "prod_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "cap_type",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
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
);
__PACKAGE__->set_primary_key("customer_id", "id");
__PACKAGE__->add_unique_constraint("ULICENSE", ["id"]);
__PACKAGE__->has_many(
  "alert_expired_maints",
  "IBM::Schema::BRAVO::AlertExpiredMaint",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::BRAVO::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "license_recon_maps  ",
  "IBM::Schema::BRAVO::LicenseReconMap",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->has_many(
  "license_recon_map_hs",
  "IBM::Schema::BRAVO::LicenseReconMapH",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->has_many(
  "license_sw_maps",
  "IBM::Schema::BRAVO::LicenseSwMap",
  { "foreign.license_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_licenses",
  "IBM::Schema::BRAVO::ReconLicense",
  { "foreign.license_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HIg3mheuIM2OGxm3zAk9dw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
