package IBM::Schema::BRAVO::Geography;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("geography");
__PACKAGE__->add_columns(
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
__PACKAGE__->set_primary_key("id", "name");
__PACKAGE__->add_unique_constraint("UGEOGRAPHY", ["id"]);
__PACKAGE__->has_many(
  "regions",
  "IBM::Schema::BRAVO::Region",
  { "foreign.geography_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E8VdnAlgwhir5MLkZrUfkg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
