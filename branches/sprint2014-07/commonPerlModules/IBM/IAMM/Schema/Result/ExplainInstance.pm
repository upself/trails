package IBM::IAMM::Schema::Result::ExplainInstance;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("explain_instance");
__PACKAGE__->add_columns(
  "explain_requester",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "explain_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "source_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "source_schema",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "source_version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "explain_option",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "snapshot_taken",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "db2_version",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 7 },
  "sql_type",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "queryopt",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "block",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "isolation",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 2 },
  "buffpage",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "avg_appls",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "sortheap",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "locklist",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "maxlocks",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "locks_avail",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_speed",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "remarks",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "dbheap",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "comm_speed",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "parallelism",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 2 },
  "datajoiner",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key(
  "explain_requester",
  "explain_time",
  "source_name",
  "source_schema",
  "source_version",
);
__PACKAGE__->has_many(
  "explain_statements",
  "IBM::IAMM::Schema::Result::ExplainStatement",
  {
    "foreign.explain_requester" => "self.explain_requester",
    "foreign.explain_time"      => "self.explain_time",
    "foreign.source_name"       => "self.source_name",
    "foreign.source_schema"     => "self.source_schema",
    "foreign.source_version"    => "self.source_version",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iVGEwXtxsNGJl79VW1fb+g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
