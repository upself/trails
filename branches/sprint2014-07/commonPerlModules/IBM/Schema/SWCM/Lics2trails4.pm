package IBM::Schema::SWCM::Lics2trails4;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("lics2trails4");
__PACKAGE__->add_columns(
  "license_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "swcm_lic_cap_type_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "total_quantity",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "expiration_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "po_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 43,
  },
  "sw_owner",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "swcm_lic_sw_prod_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 240,
  },
  "account_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "full_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 4000,
  },
  "swcm_license_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "swcm_lic_lic_status_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "draft",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 1 },
  "pool",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "tryandbuy",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "maint_exp_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "lic_sw_prod_ext_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 40,
  },
  "lic_sw_prod_ext_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "lic_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_agree_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 2 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6MzuJ+Hw7P3v1h3St5yLbA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
