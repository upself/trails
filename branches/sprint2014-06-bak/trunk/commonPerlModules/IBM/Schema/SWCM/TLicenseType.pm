package IBM::Schema::SWCM::TLicenseType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_license_type");
__PACKAGE__->add_columns(
  "lic_type_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_type_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_type_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
  "lic_type_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "lic_type_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_type_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "lic_type_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("lic_type_id");
__PACKAGE__->add_unique_constraint("UC_LIC_TYPE_CODE", ["lic_type_code"]);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_lic_type_id" => "self.lic_type_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_lic_type_id" => "self.lic_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Bkn385khOkOC09DbBp4X+A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
