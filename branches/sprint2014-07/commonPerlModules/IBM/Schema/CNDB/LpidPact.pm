package IBM::Schema::CNDB::LpidPact;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("LPID_PACT");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "lpid",
  { data_type => "VARCHAR", is_nullable => 1, size => 8 },
  "description",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "fa_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "major",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
  "div",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
  "status",
  { data_type => "VARCHAR", is_nullable => 1, size => 2 },
  "contact",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "loc_code",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mhqV/P81bzXFH/KQ2BRHeg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
