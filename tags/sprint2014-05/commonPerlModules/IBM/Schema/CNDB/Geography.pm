package IBM::Schema::CNDB::Geography;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("GEOGRAPHY");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("SQL070524230500360", ["name"]);
__PACKAGE__->has_many(
  "regions",
  "IBM::Schema::CNDB::Region",
  { "foreign.geography_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fbXZxt1AScpyuv0VJz3z2A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
