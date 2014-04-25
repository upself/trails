package IBM::Schema::CNDB::Region;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("REGION");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "geography_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("SQL070524230500500", ["name"]);
__PACKAGE__->has_many(
  "country_codes",
  "IBM::Schema::CNDB::CountryCode",
  { "foreign.region_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "geography",
  "IBM::Schema::CNDB::Geography",
  { id => "geography_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X7lxjKBxAA6hZ7y+o2tCBw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
