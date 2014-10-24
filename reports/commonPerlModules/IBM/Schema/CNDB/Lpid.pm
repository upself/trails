package IBM::Schema::CNDB::Lpid;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("LPID");
__PACKAGE__->add_columns(
  "lpid_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "major_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "lpid_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("lpid_id");
__PACKAGE__->has_many(
  "customer_numbers",
  "IBM::Schema::CNDB::CustomerNumber",
  { "foreign.lpid_id" => "self.lpid_id" },
);
__PACKAGE__->belongs_to(
  "major",
  "IBM::Schema::CNDB::Major",
  { major_id => "major_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HBM/lpdCaZ7/544YpGLsYg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
