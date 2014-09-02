package IBM::Schema::SWCM::TMinorCode;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_minor_code");
__PACKAGE__->add_columns(
  "minor_code_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "minor_code_code",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 4 },
  "minor_code_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "minor_code_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "minor_code_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "minor_code_for_lic",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "minor_code_for_maint",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("minor_code_id");
__PACKAGE__->add_unique_constraint("UC_MINOR_CODE", ["minor_code_code"]);
__PACKAGE__->has_many(
  "t_draft_licenses",
  "IBM::Schema::SWCM::TDraftLicense",
  { "foreign.dr_lic_minor_code_id" => "self.minor_code_id" },
);
__PACKAGE__->has_many(
  "t_draft_maintenances",
  "IBM::Schema::SWCM::TDraftMaintenance",
  { "foreign.dr_maint_minor_code_id" => "self.minor_code_id" },
);
__PACKAGE__->has_many(
  "t_licenses",
  "IBM::Schema::SWCM::TLicense",
  { "foreign.lic_minor_code_id" => "self.minor_code_id" },
);
__PACKAGE__->has_many(
  "t_maintenances",
  "IBM::Schema::SWCM::TMaintenance",
  { "foreign.maint_minor_code_id" => "self.minor_code_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DsGLWdq8mhDk8VZ4w88zYQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
