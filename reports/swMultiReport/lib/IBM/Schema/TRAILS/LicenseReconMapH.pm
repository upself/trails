package IBM::Schema::TRAILS::LicenseReconMapH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("license_recon_map_h");
__PACKAGE__->add_columns(
  "reconcile_h_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "used_quantity",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "cap_type",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
);
__PACKAGE__->set_primary_key("reconcile_h_id", "license_id", "id");
__PACKAGE__->add_unique_constraint("IF2LICRECONMAPH", ["id"]);
__PACKAGE__->belongs_to(
  "reconcile_h",
  "IBM::Schema::TRAILS::ReconcileH",
  { id => "reconcile_h_id" },
);
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::TRAILS::License",
  { id => "license_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d0lPkGMbzo99DkpuWYhIGg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
