package IBM::Schema::BRAVO::Bluegroup;

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
__PACKAGE__->has_many(
  "customer_bluegroups",
  "IBM::Schema::BRAVO::CustomerBluegroup",
  { "foreign.bluegroup_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6YR4zbWeUBcUtutJ/oyaaw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
