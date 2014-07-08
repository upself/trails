package IBM::Schema::BRAVO::Hardware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hardware");
__PACKAGE__->add_columns(
  "machine_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "country",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 2 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "owner",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "customer_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
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
  "hardware_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "account_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
);
__PACKAGE__->set_primary_key("machine_type_id", "serial", "country", "id");
__PACKAGE__->add_unique_constraint("UHARDWARE", ["id"]);
__PACKAGE__->has_many(
  "alert_hardwares",
  "IBM::Schema::BRAVO::AlertHardware",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->has_many(
  "contact_hardwares",
  "IBM::Schema::BRAVO::ContactHardware",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "machine_type",
  "IBM::Schema::BRAVO::MachineType",
  { id => "machine_type_id" },
);
__PACKAGE__->has_many(
  "hardware_lpars",
  "IBM::Schema::BRAVO::HardwareLpar",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_hardwares",
  "IBM::Schema::BRAVO::ReconHardware",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->has_many(
  "scrt_records",
  "IBM::Schema::BRAVO::ScrtRecord",
  { "foreign.hardware_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vTlUob8LR6T9vETAD4Nt6Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
