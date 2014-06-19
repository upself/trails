package IBM::Schema::TRAILS::CapacityType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("capacity_type");
__PACKAGE__->add_columns(
  "code",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 60,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("code");
__PACKAGE__->add_unique_constraint("IF1CAPACITYTYPE", ["code", "description"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IGQhxl1eFXX/JVMVJ0+EGg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
