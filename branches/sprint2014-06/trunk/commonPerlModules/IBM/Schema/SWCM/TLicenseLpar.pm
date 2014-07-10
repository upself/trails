package IBM::Schema::SWCM::TLicenseLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_license_lpar");
__PACKAGE__->add_columns(
  "license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "lpar_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_lpar_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "lic_lpar_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
  "lic_lpar_created_by",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
);
__PACKAGE__->set_primary_key("license_id", "lpar_id");
__PACKAGE__->belongs_to(
  "license",
  "IBM::Schema::SWCM::TLicense",
  { license_id => "license_id" },
);
__PACKAGE__->belongs_to(
  "lpar",
  "IBM::Schema::SWCM::TNamedLpars",
  { lpar_id => "lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:okmAsM6VMlJFnx6VAX/iNw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
