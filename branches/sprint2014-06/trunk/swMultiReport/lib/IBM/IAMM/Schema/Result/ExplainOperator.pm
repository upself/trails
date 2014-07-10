package IBM::IAMM::Schema::Result::ExplainOperator;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("explain_operator");
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
  "operator_type",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 6 },
  "total_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "io_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "cpu_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "first_row_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "re_total_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "re_io_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "re_cpu_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "comm_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "first_comm_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "buffers",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "remote_total_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
  "remote_comm_cost",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 0, size => 53 },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OFoYM9R850fXLbhNl2AWGg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
