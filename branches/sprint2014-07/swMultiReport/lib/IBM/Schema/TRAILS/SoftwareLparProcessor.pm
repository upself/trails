package IBM::Schema::TRAILS::SoftwareLparProcessor;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar_processor");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "processor_num",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "manufacturer",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "max_speed",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "bus_speed",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "serial_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "is_active",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "num_boards",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "num_modules",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "pvu",
  { data_type => "BIGINT", default_value => undef, is_nullable => 1, size => 19 },
  "cache",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "current_speed",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("IF1SOFTWARELPARPRO", ["software_lpar_id", "id"]);
__PACKAGE__->add_unique_constraint("IF2SOFTWARELPARPRO", ["software_lpar_id", "processor_num"]);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { id => "software_lpar_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:f2JkaPSJnXbTZHaHSERMgw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
