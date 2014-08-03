package IBM::Schema::CNDB::AtsToolView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_TOOL_VIEW");
__PACKAGE__->add_columns(
  "tool_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "tool_type",
  { data_type => "VARCHAR", is_nullable => 0, size => 8 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IXXbgoOgJmZj6fUlQZGmnQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
