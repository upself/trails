package IBM::Schema::TRAILS::Bluegroup;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bluegroup");
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
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("IF1BLUEGROUP", ["id", "name", "description"]);
__PACKAGE__->has_many(
  "customer_bluegroups",
  "IBM::Schema::TRAILS::CustomerBluegroup",
  { "foreign.bluegroup_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XCo3pdZ2AWEsZGFYYCLfcQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
