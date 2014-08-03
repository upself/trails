package IBM::Schema::TRAILS::Geography;

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
__PACKAGE__->set_primary_key("id", "name");
__PACKAGE__->add_unique_constraint("IF1GEOGRAPHY", ["id"]);
__PACKAGE__->add_unique_constraint("IF2GEOGRAPHY", ["name"]);
__PACKAGE__->has_many(
  "regions",
  "IBM::Schema::TRAILS::Region",
  { "foreign.geography_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ljtNt3DZr1jfcPPZKzottQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
