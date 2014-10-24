package IBM::Schema::SWCM::Lics2trails;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("lics2trails");
__PACKAGE__->add_columns(
  "license type",
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
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "expiration date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "po_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 43,
  },
  "sw owner",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "swcm_lic_sw_prod_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 240,
  },
  "node_name",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
  "account_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 123,
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
  "sub software type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
  "sub_license_source",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
  "sub_license_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
  "sub_vendor_name",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
  "sub_agreement_type",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
  "status",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 0 },
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
  "swcm lic lic status id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nPKoOD14NktLM/gX/shsQQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
