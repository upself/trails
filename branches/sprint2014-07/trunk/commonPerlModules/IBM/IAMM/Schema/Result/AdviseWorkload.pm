package IBM::IAMM::Schema::Result::AdviseWorkload;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("advise_workload");
__PACKAGE__->add_columns(
  "workload_name",
  {
    data_type => "CHAR",
    default_value => "'WK0'",
    is_nullable => 0,
    size => 128,
  },
  "statement_no",
  { data_type => "INTEGER", default_value => 1, is_nullable => 0, size => 10 },
  "statement_text",
  {
    data_type => "CLOB",
    default_value => undef,
    is_nullable => 0,
    size => 1048576,
  },
  "statement_tag",
  {
    data_type => "VARCHAR",
    default_value => "''",
    is_nullable => 0,
    size => 256,
  },
  "frequency",
  { data_type => "INTEGER", default_value => 1, is_nullable => 0, size => 10 },
  "importance",
  { data_type => "DOUBLE", default_value => 1, is_nullable => 0, size => 53 },
  "weight",
  { data_type => "DOUBLE", default_value => 1, is_nullable => 0, size => 53 },
  "cost_before",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 1, size => 53 },
  "cost_after",
  { data_type => "DOUBLE", default_value => undef, is_nullable => 1, size => 53 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/j1xZFeVNxgazseZcAigZA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
