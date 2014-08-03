package IBM::Schema::TRAILS::LicenseSwMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("license_sw_map");
__PACKAGE__->add_columns(
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("license_id", "software_id", "id");
__PACKAGE__->add_unique_constraint("IF2LICENSESWMAP", ["license_id"]);
__PACKAGE__->add_unique_constraint("IF3LICENSESWMAP", ["id"]);
__PACKAGE__->add_unique_constraint("IF1LICENSESWMAP", ["software_id", "license_id"]);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::TRAILS::License",
  { id => "license_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1iMoNisPiLBgqGQaUdNMtw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
