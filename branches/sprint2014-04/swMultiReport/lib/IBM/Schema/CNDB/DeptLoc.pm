package IBM::Schema::CNDB::DeptLoc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DEPT_LOC");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "department",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
  "location",
  { data_type => "VARCHAR", is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kaOynhfaoxDuWwXjtMmHeA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
