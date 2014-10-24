package IBM::IAMM::Schema::Result::ExplainStatement;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("explain_statement");
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
  "explain_level",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "stmtno",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "sectno",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "queryno",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "querytag",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 20 },
  "statement_type",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 2 },
  "updatable",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "deletable",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "total_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "statement_text",
  {
    data_type => "CLOB",
    default_value => undef,
    is_nullable => 0,
    size => 2097152,
  },
  "snapshot",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 10485760,
  },
  "query_degree",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key(
  "explain_requester",
  "explain_time",
  "source_name",
  "source_schema",
  "source_version",
  "explain_level",
  "stmtno",
  "sectno",
);
__PACKAGE__->has_many(
  "explain_arguments",
  "IBM::IAMM::Schema::Result::ExplainArgument",
  {
    "foreign.explain_level"     => "self.explain_level",
    "foreign.explain_requester" => "self.explain_requester",
    "foreign.explain_time"      => "self.explain_time",
    "foreign.sectno"            => "self.sectno",
    "foreign.source_name"       => "self.source_name",
    "foreign.source_schema"     => "self.source_schema",
    "foreign.source_version"    => "self.source_version",
    "foreign.stmtno"            => "self.stmtno",
  },
);
__PACKAGE__->has_many(
  "explain_objects",
  "IBM::IAMM::Schema::Result::ExplainObject",
  {
    "foreign.explain_level"     => "self.explain_level",
    "foreign.explain_requester" => "self.explain_requester",
    "foreign.explain_time"      => "self.explain_time",
    "foreign.sectno"            => "self.sectno",
    "foreign.source_name"       => "self.source_name",
    "foreign.source_schema"     => "self.source_schema",
    "foreign.source_version"    => "self.source_version",
    "foreign.stmtno"            => "self.stmtno",
  },
);
__PACKAGE__->has_many(
  "explain_operators",
  "IBM::IAMM::Schema::Result::ExplainOperator",
  {
    "foreign.explain_level"     => "self.explain_level",
    "foreign.explain_requester" => "self.explain_requester",
    "foreign.explain_time"      => "self.explain_time",
    "foreign.sectno"            => "self.sectno",
    "foreign.source_name"       => "self.source_name",
    "foreign.source_schema"     => "self.source_schema",
    "foreign.source_version"    => "self.source_version",
    "foreign.stmtno"            => "self.stmtno",
  },
);
__PACKAGE__->has_many(
  "explain_predicates",
  "IBM::IAMM::Schema::Result::ExplainPredicate",
  {
    "foreign.explain_level"     => "self.explain_level",
    "foreign.explain_requester" => "self.explain_requester",
    "foreign.explain_time"      => "self.explain_time",
    "foreign.sectno"            => "self.sectno",
    "foreign.source_name"       => "self.source_name",
    "foreign.source_schema"     => "self.source_schema",
    "foreign.source_version"    => "self.source_version",
    "foreign.stmtno"            => "self.stmtno",
  },
);
__PACKAGE__->belongs_to(
  "explain_instance",
  "IBM::IAMM::Schema::Result::ExplainInstance",
  {
    explain_requester => "explain_requester",
    explain_time      => "explain_time",
    source_name       => "source_name",
    source_schema     => "source_schema",
    source_version    => "source_version",
  },
);
__PACKAGE__->has_many(
  "explain_streams",
  "IBM::IAMM::Schema::Result::ExplainStream",
  {
    "foreign.explain_level"     => "self.explain_level",
    "foreign.explain_requester" => "self.explain_requester",
    "foreign.explain_time"      => "self.explain_time",
    "foreign.sectno"            => "self.sectno",
    "foreign.source_name"       => "self.source_name",
    "foreign.source_schema"     => "self.source_schema",
    "foreign.source_version"    => "self.source_version",
    "foreign.stmtno"            => "self.stmtno",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yEpqX04ENYyrqjZKSl1tdw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
