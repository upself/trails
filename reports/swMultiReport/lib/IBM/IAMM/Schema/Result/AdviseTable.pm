package IBM::IAMM::Schema::Result::AdviseTable;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("advise_table");
__PACKAGE__->add_columns(
  "run_id",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "table_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "table_schema",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "tablespace",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "selection_flag",
  { data_type => "VARCHAR", default_value => "''", is_nullable => 0, size => 8 },
  "table_exists",
  { data_type => "CHAR", default_value => "''", is_nullable => 0, size => 1 },
  "use_table",
  { data_type => "CHAR", default_value => "''", is_nullable => 0, size => 1 },
  "gen_columns",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "organize_by",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "creation_text",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "alter_command",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "diskuse",
  { data_type => "DOUBLE", default_value => 0, is_nullable => 0, size => 53 },
);
__PACKAGE__->belongs_to(
  "run",
  "IBM::IAMM::Schema::Result::AdviseInstance",
  { start_time => "run_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7B0A8GTwTFFOvy9smPweHQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
