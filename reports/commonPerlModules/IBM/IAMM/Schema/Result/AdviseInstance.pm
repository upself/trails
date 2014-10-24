package IBM::IAMM::Schema::Result::AdviseInstance;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("advise_instance");
__PACKAGE__->add_columns(
  "start_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "end_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "mode",
  { data_type => "VARCHAR", default_value => "''", is_nullable => 0, size => 4 },
  "wkld_compression",
  { data_type => "CHAR", default_value => "'NONE'", is_nullable => 0, size => 4 },
  "status",
  { data_type => "CHAR", default_value => "''", is_nullable => 0, size => 9 },
);
__PACKAGE__->set_primary_key("start_time");
__PACKAGE__->has_many(
  "advise_indexes",
  "IBM::IAMM::Schema::Result::AdviseIndex",
  { "foreign.run_id" => "self.start_time" },
);
__PACKAGE__->has_many(
  "advise_mqts",
  "IBM::IAMM::Schema::Result::AdviseMqt",
  { "foreign.run_id" => "self.start_time" },
);
__PACKAGE__->has_many(
  "advise_partitions",
  "IBM::IAMM::Schema::Result::AdvisePartition",
  { "foreign.run_id" => "self.start_time" },
);
__PACKAGE__->has_many(
  "advise_tables",
  "IBM::IAMM::Schema::Result::AdviseTable",
  { "foreign.run_id" => "self.start_time" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2CG3D+wblOGUGuEgEXoDLA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
