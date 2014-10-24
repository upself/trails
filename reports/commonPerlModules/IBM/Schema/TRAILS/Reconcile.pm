package IBM::Schema::TRAILS::Reconcile;

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
  "machine_level",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
);
__PACKAGE__->set_primary_key("installed_software_id", "reconcile_type_id", "id");
__PACKAGE__->add_unique_constraint("IF3RECONCILE", ["id"]);
__PACKAGE__->add_unique_constraint(
  "IF5RECONCILE",
  ["machine_level", "id", "installed_software_id"],
);
__PACKAGE__->add_unique_constraint("IF4RECONCILE", ["installed_software_id"]);
__PACKAGE__->has_many(
  "license_recon_maps",
  "IBM::Schema::TRAILS::LicenseReconMap",
  { "foreign.reconcile_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "reconcile_type",
  "IBM::Schema::TRAILS::ReconcileType",
  { id => "reconcile_type_id" },
);
__PACKAGE__->belongs_to(
  "installed_software",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { id => "installed_software_id" },
);
__PACKAGE__->belongs_to(
  "parent_installed_software",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { id => "parent_installed_software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X6Kp2ZLI2QgniaYnxN2zAg

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.10 $))[1];
our $REVISION = '$Id: Reconcile.pm,v 1.10 2009/06/02 22:04:31 cweyl Exp $';

# get all the licenses this row relates to
__PACKAGE__->many_to_many(licenses => license_recon_maps => 'license');

1;
