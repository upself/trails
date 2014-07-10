package IBM::Schema::CNDB::UniqueNumber;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("UNIQUE_NUMBER");
__PACKAGE__->add_columns(
  "unique_number_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "number_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "next_number",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "quantity",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("unique_number_id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NIWYHIDZ/VAbZGG1UBPd2g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
