package IBM::Schema::SWCM::TGeoRestriction;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_geo_restriction");
__PACKAGE__->add_columns(
  "geo_restriction_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "geo_restriction_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "geo_restriction_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "geo_restriction_lookup",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "geo_restriction_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "geo_restriction_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("geo_restriction_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DTwsYur8aAUiNGDoGgxVBw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
