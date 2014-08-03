package IBM::Schema::CNDB::AtsProgressSummary;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ATS_PROGRESS_SUMMARY");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
  "registered",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "not_open",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "total",
  { data_type => "INTEGER", is_nullable => 0, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d7bLWeSxacFuYNqR9KM/7Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
