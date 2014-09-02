package IBM::IAMM::Schema::Result::AdvisePartition;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("advise_partition");
__PACKAGE__->add_columns(
  "explain_requester",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "explain_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "source_name",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "source_schema",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "source_version",
  { data_type => "VARCHAR", default_value => "''", is_nullable => 0, size => 64 },
  "explain_level",
  { data_type => "CHAR", default_value => "''", is_nullable => 0, size => 1 },
  "stmtno",
  { data_type => "INTEGER", default_value => 0, is_nullable => 0, size => 10 },
  "sectno",
  { data_type => "INTEGER", default_value => 0, is_nullable => 0, size => 10 },
  "queryno",
  { data_type => "INTEGER", default_value => 0, is_nullable => 0, size => 10 },
  "querytag",
  { data_type => "CHAR", default_value => "''", is_nullable => 0, size => 20 },
  "tbname",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "tbcreator",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "pmid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "tbspace",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "colnames",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "colcount",
  { data_type => "SMALLINT", default_value => 0, is_nullable => 0, size => 5 },
  "replicate",
  { data_type => "CHAR", default_value => "'N'", is_nullable => 0, size => 1 },
  "cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "useit",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "run_id",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
);
__PACKAGE__->belongs_to(
  "run",
  "IBM::IAMM::Schema::Result::AdviseInstance",
  { start_time => "run_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:40Cb8/57TLo65z0rBIbvlA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
