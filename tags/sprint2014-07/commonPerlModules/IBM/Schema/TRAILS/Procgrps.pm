package IBM::Schema::TRAILS::Procgrps;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("procgrps");
__PACKAGE__->add_columns(
  "machine_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "model",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 20 },
  "procgrps_group",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 3 },
  "description",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 20 },
  "vendor",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 10 },
  "upduser",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 8 },
  "updstamp",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "msu",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 7 },
  "pslc_ind",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "wlc_ind",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "total_engines",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 3 },
  "zos_engines",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 3 },
  "ewlc_ind",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
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
__PACKAGE__->set_primary_key("machine_type_id", "model", "procgrps_group", "vendor");
__PACKAGE__->has_many(
  "mips",
  "IBM::Schema::TRAILS::Mips",
  {
    "foreign.machine_type_id" => "self.machine_type_id",
    "foreign.mips_group"      => "self.procgrps_group",
    "foreign.model"           => "self.model",
    "foreign.vendor"          => "self.vendor",
  },
);
__PACKAGE__->belongs_to(
  "machine_type",
  "IBM::Schema::TRAILS::MachineType",
  { id => "machine_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OMr6MGpygbEG0mx2ffvrLA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
