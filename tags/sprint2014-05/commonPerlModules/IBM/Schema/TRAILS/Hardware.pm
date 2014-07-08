package IBM::Schema::TRAILS::Hardware;

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
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "classification",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("machine_type_id", "serial", "country", "id");
__PACKAGE__->add_unique_constraint("IF2HARDWARE", ["machine_type_id", "serial", "country"]);
__PACKAGE__->add_unique_constraint("IF3HARDWARE", ["account_number", "id"]);
__PACKAGE__->add_unique_constraint(
  "IF4HARDWARE",
  ["hardware_status", "machine_type_id", "customer_number", "id"],
);
__PACKAGE__->add_unique_constraint("IF1HARDWARE", ["id"]);
__PACKAGE__->add_unique_constraint("IF6HARDWARE", ["status", "hardware_status", "id"]);
__PACKAGE__->has_many(
  "alert_hardwares",
  "IBM::Schema::TRAILS::AlertHardware",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->has_many(
  "contact_hardwares",
  "IBM::Schema::TRAILS::ContactHardware",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "machine_type",
  "IBM::Schema::TRAILS::MachineType",
  { id => "machine_type_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "hardware_lpars",
  "IBM::Schema::TRAILS::HardwareLpar",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_hardwares",
  "IBM::Schema::TRAILS::ReconHardware",
  { "foreign.hardware_id" => "self.id" },
);
__PACKAGE__->has_many(
  "scrt_records",
  "IBM::Schema::TRAILS::ScrtRecord",
  { "foreign.hardware_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QH0oDenk79pEFvgEEWR45w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
