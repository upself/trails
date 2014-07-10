package IBM::Schema::SWCM::TOrgLevel2;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_org_level2");
__PACKAGE__->add_columns(
  "org_level2_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "org_level2_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 25,
  },
  "org_level2_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "org_level2_del",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("org_level2_id");
__PACKAGE__->has_many(
  "t_country_codes",
  "IBM::Schema::SWCM::TCountryCode",
  { "foreign.org_level_2" => "self.org_level2_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SB7ORGHOsf6yEDIRpZO/kg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
