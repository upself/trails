package IBM::Schema::TRAILS::Region;

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
  "creation_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "update_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("geography_id", "id", "name");
__PACKAGE__->add_unique_constraint("IF2REGION", ["name"]);
__PACKAGE__->add_unique_constraint("IF1REGION", ["id"]);
__PACKAGE__->has_many(
  "country_codes",
  "IBM::Schema::TRAILS::CountryCode",
  { "foreign.region_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "geography",
  "IBM::Schema::TRAILS::Geography",
  { id => "geography_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FBlHxva9Z75S9Kap3W0GUQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
