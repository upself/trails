package IBM::Schema::BRAVO::LicenseReconMapH;

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
__PACKAGE__->belongs_to(
  "reconcile_h",
  "IBM::Schema::BRAVO::ReconcileH",
  { id => "reconcile_h_id" },
);
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::BRAVO::License",
  { id => "license_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YHCXYo3z1KYF4LZ211ItOw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
