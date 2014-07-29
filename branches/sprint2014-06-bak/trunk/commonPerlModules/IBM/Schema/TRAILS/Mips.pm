package IBM::Schema::TRAILS::Mips;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("mips");
__PACKAGE__->add_columns(
  "machine_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "model",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 20 },
  "mips_group",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "vendor",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 10 },
  "mipsvendor",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 10 },
  "mips",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 7 },
  "upduser",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 8 },
  "updstamp",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "upd_intranet_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 60 },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("machine_type_id", "model", "mips_group", "vendor", "mipsvendor");
__PACKAGE__->belongs_to(
  "machine_type",
  "IBM::Schema::TRAILS::MachineType",
  { id => "machine_type_id" },
);
__PACKAGE__->belongs_to(
  "procgrp",
  "IBM::Schema::TRAILS::Procgrps",
  {
    machine_type_id => "machine_type_id",
    model => "model",
    procgrps_group => "mips_group",
    vendor => "vendor",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q3+4vDAf/uxGrPnUgLZZvQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
