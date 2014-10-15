package IBM::IAMM::Schema::Result::ExplainPredicate;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("explain_predicate");
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
  "operator_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "predicate_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "how_applied",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 5 },
  "when_evaluated",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "relop_type",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 2 },
  "subquery",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "filter_factor",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "predicate_text",
  {
    data_type => "CLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2097152,
  },
);
__PACKAGE__->belongs_to(
  "explain_statement",
  "IBM::IAMM::Schema::Result::ExplainStatement",
  {
    explain_level     => "explain_level",
    explain_requester => "explain_requester",
    explain_time      => "explain_time",
    sectno            => "sectno",
    source_name       => "source_name",
    source_schema     => "source_schema",
    source_version    => "source_version",
    stmtno            => "stmtno",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AGL/1+dAPpMjHmhZePgm/g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
