package IBM::Schema::CNDB::DropDown;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DROP_DOWN");
__PACKAGE__->add_columns(
  "drop_down_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "form_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "field_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("drop_down_id");
__PACKAGE__->has_many(
  "drop_down_values",
  "IBM::Schema::CNDB::DropDownValue",
  { "foreign.drop_down_id" => "self.drop_down_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A3/FtGKiSxwflfHdieVfkg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
