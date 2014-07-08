package IBM::Schema::BRAVO::Reconcile;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("reconcile");
__PACKAGE__->add_columns(
  "installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "reconcile_type_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "parent_installed_software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("installed_software_id", "reconcile_type_id", "id");
__PACKAGE__->add_unique_constraint("URECONCILE", ["id"]);
__PACKAGE__->has_many(
  "license_recon_maps  ",
  "IBM::Schema::BRAVO::LicenseReconMap",
  { "foreign.reconcile_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::BRAVO::InstalledSoftware",
  { id => "installed_software_id" },
);
__PACKAGE__->belongs_to(
  "parent_installed_software",
  "IBM::Schema::BRAVO::InstalledSoftware",
  { id => "parent_installed_software_id" },
);
__PACKAGE__->belongs_to(
  "reconcile_type",
  "IBM::Schema::BRAVO::ReconcileType",
  { id => "reconcile_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kndkcT24dUnmsLizLWXQsA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
