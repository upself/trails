package IBM::Schema::CNDB::AtsToolName;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_TOOL_NAME");
__PACKAGE__->add_columns(
  "tool_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2cctDtsmS63TnVpIil4HeQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
