package IBM::Schema::CNDB::DropDownValue;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DROP_DOWN_VALUE");
__PACKAGE__->add_columns(
  "drop_down_value_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "drop_down_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "value",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("drop_down_value_id");
__PACKAGE__->belongs_to(
  "drop_down",
  "IBM::Schema::CNDB::DropDown",
  { drop_down_id => "drop_down_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mX/ma6D4jyTGyt8hJY6VJA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
