package IBM::Schema::BRAVO::Region;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("region");
__PACKAGE__->add_columns(
  "geography_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("geography_id", "id", "name");
__PACKAGE__->add_unique_constraint("UREGION", ["id"]);
__PACKAGE__->has_many(
  "country_codes",
  "IBM::Schema::BRAVO::CountryCode",
  { "foreign.region_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "geography",
  "IBM::Schema::BRAVO::Geography",
  { id => "geography_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZDVFMMZIp26PCGd7sgoY3A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
