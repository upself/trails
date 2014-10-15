package IBM::Schema::CNDB::RequestSummaryView;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("REQUEST_SUMMARY_VIEW");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "month",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "year",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "type",
  { data_type => "VARCHAR", is_nullable => 0, size => 263 },
  "count",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MCeof6iAJCimtkzsWWQ1vg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
