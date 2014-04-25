package IBM::Schema::TRAILS::CountryCode;

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
__PACKAGE__->set_primary_key("region_id", "id");
__PACKAGE__->add_unique_constraint("IF2COUNTRYCODE", ["id"]);
__PACKAGE__->add_unique_constraint("IF1COUNTRYCODE", ["name"]);
__PACKAGE__->belongs_to("region", "IBM::Schema::TRAILS::Region", { id => "region_id" });
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.country_code_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j8Yp7G4F9bAOYLiJPindrw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
