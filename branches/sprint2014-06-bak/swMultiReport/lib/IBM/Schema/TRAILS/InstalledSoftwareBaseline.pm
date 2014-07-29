package IBM::Schema::TRAILS::InstalledSoftwareBaseline;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("installed_software_baseline");
__PACKAGE__->add_columns(
  "installed_software_baseline_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "software_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "source",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "node_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 254,
  },
  "serial_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "users",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "swcm_sesdr",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "swcm_sw_product_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "swcm_sw_manufacturer_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "owner",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "deploy_status",
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
    size => 32,
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
__PACKAGE__->set_primary_key("customer_id", "software_id", "installed_software_baseline_id");
__PACKAGE__->add_unique_constraint("UINSTSWBASELINE", ["installed_software_baseline_id"]);
__PACKAGE__->has_many(
  "hw_sw_composites",
  "IBM::Schema::TRAILS::HwSwComposite",
  {
    "foreign.installed_software_baseline_id" => "self.installed_software_baseline_id",
  },
);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oLc3G7nSyaNreWTB1wEueQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
