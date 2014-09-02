package IBM::Schema::CNDB::AtsSurveyToolView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_SURVEY_TOOL_VIEW");
__PACKAGE__->add_columns(
  "component",
  { data_type => "VARCHAR", is_nullable => 0, size => 10 },
  "as_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "tool_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "tool_value",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fhO1c97mAUc4BtIQ/iY/kA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
