package IBM::Schema::BRAVO::MachineType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("machine_type");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 8 },
  "definition",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("id", "name");
__PACKAGE__->add_unique_constraint("UMACHINETYPE", ["id"]);
__PACKAGE__->has_many(
  "hardwares",
  "IBM::Schema::BRAVO::Hardware",
  { "foreign.machine_type_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:doSrPA8pd8rQQA0x+0rMzw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
