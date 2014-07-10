package IBM::Schema::BRAVO::InstalledSoftware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("installed_software");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "discrepancy_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "users",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "authenticated",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "research_flag",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
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
  "invalid_category",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("software_lpar_id", "software_id", "id");
__PACKAGE__->add_unique_constraint("UINSTSOFTWARE", ["id"]);
__PACKAGE__->has_many(
  "alert_unlicensed_sws",
  "IBM::Schema::BRAVO::AlertUnlicensedSw",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_dorana_products",
  "IBM::Schema::BRAVO::InstalledDoranaProduct",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_filters",
  "IBM::Schema::BRAVO::InstalledFilter",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_sa_products",
  "IBM::Schema::BRAVO::InstalledSaProduct",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_signatures",
  "IBM::Schema::BRAVO::InstalledSignature",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "discrepancy_type",
  "IBM::Schema::BRAVO::DiscrepancyType",
  { id => "discrepancy_type_id" },
);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::BRAVO::Software",
  { software_id => "software_id" },
);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::BRAVO::SoftwareLpar",
  { id => "software_lpar_id" },
);
__PACKAGE__->has_many(
  "installed_vm_products",
  "IBM::Schema::BRAVO::InstalledVmProduct",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "reconcile_installed_softwares",
  "IBM::Schema::BRAVO::Reconcile",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "reconcile_parent_installed_softwares",
  "IBM::Schema::BRAVO::Reconcile",
  { "foreign.parent_installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "reconcile_h_installed_softwares",
  "IBM::Schema::BRAVO::ReconcileH",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "reconcile_h_parent_installed_softwares",
  "IBM::Schema::BRAVO::ReconcileH",
  { "foreign.parent_installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_installed_sws",
  "IBM::Schema::BRAVO::ReconInstalledSw",
  { "foreign.installed_software_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_discrepancy_hs",
  "IBM::Schema::BRAVO::SoftwareDiscrepancyH",
  { "foreign.installed_software_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KlWXzUgbMTdtIBm6GNwYIw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
