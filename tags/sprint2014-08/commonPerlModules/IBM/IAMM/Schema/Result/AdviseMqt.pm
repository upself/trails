package IBM::IAMM::Schema::Result::AdviseMqt;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("advise_mqt");
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
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "creator",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "iid",
  { data_type => "SMALLINT", default_value => 0, is_nullable => 0, size => 5 },
  "create_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "stats_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 1,
    size => 26,
  },
  "numrows",
  { data_type => "DOUBLE", default_value => 0, is_nullable => 0, size => 53 },
  "numcols",
  { data_type => "SMALLINT", default_value => 0, is_nullable => 0, size => 5 },
  "rowsize",
  { data_type => "DOUBLE", default_value => 0, is_nullable => 0, size => 53 },
  "benefit",
  { data_type => "DOUBLE", default_value => "0.0", is_nullable => 0, size => 53 },
  "use_mqt",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "mqt_source",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "query_text",
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
  "sample_text",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "colstats",
  {
    data_type => "CLOB",
    default_value => "''",
    is_nullable => 0,
    size => 2097152,
  },
  "extra_info",
  {
    data_type => "BLOB",
    default_value => "\"SYSIBM\".\"BLOB\"('')",
    is_nullable => 0,
    size => 2097152,
  },
  "tbspace",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 128,
  },
  "run_id",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "refresh_type",
  { data_type => "CHAR", default_value => "''", is_nullable => 0, size => 1 },
  "exists",
  { data_type => "CHAR", default_value => "'N'", is_nullable => 0, size => 1 },
);
__PACKAGE__->belongs_to(
  "run",
  "IBM::IAMM::Schema::Result::AdviseInstance",
  { start_time => "run_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:04N2LFIfaXb34JsRazp12Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
