package IBM::Schema::CNDB::VRevalUser;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("V_REVAL_USER");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "user_email",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/+2J13J9H3HlUvIyOPG4vQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
