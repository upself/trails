package IBM::Schema::BRAVO::CountryCode;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("country_code");
__PACKAGE__->add_columns(
  "region_id",
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
  "code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("region_id", "id");
__PACKAGE__->add_unique_constraint("UCOUNTRYCODE", ["id"]);
__PACKAGE__->belongs_to("region", "IBM::Schema::BRAVO::Region", { id => "region_id" });
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.country_code_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2lMV3JuPmvs36wHfs3wcNA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
