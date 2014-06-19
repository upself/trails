package IBM::Schema::SWCM::TLicTier;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_lic_tier");
__PACKAGE__->add_columns(
  "lic_tier_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "lic_tier_lic_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "lic_tier_dr_lic_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "lic_tier_tier_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_tier_part_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "lic_tier_quant",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("lic_tier_id");
__PACKAGE__->belongs_to(
  "lic_tier_tier_type",
  "IBM::Schema::SWCM::TTierType",
  { tier_type_id => "lic_tier_tier_type_id" },
);
__PACKAGE__->belongs_to(
  "lic_tier_lic",
  "IBM::Schema::SWCM::TLicense",
  { license_id => "lic_tier_lic_id" },
);
__PACKAGE__->belongs_to(
  "lic_tier_dr_lic",
  "IBM::Schema::SWCM::TDraftLicense",
  { dr_license_id => "lic_tier_dr_lic_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:M1Pdb68gnQaIloFReUbEvg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
