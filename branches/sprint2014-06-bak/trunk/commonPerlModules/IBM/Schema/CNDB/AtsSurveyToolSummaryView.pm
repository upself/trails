package IBM::Schema::CNDB::AtsSurveyToolSummaryView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_SURVEY_TOOL_SUMMARY_VIEW");
__PACKAGE__->add_columns(
  "tool_name",
  { data_type => "VARCHAR", is_nullable => 1, size => 256 },
  "tool_type",
  { data_type => "VARCHAR", is_nullable => 0, size => 8 },
  "financial",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "hw_asset",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "inventory",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "logistics",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "order",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "sw_asset",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "sw_license",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BWLRFLrVeABzB8rg6nO1Kg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
