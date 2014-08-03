package IBM::Schema::BRAVO::SoftwareLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_lpar");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "bios_serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "processor_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "scantime",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "acquisition_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
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
__PACKAGE__->set_primary_key("customer_id", "id");
__PACKAGE__->add_unique_constraint("USOFTWARELPAR", ["id"]);
__PACKAGE__->has_many(
  "alert_expired_scans",
  "IBM::Schema::BRAVO::AlertExpiredScan",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "alert_sw_lpars",
  "IBM::Schema::BRAVO::AlertSwLpar",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "hw_sw_composites",
  "IBM::Schema::BRAVO::HwSwComposite",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_softwares",
  "IBM::Schema::BRAVO::InstalledSoftware",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_sw_lpars",
  "IBM::Schema::BRAVO::ReconSwLpar",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::BRAVO::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "software_lpar_hdisks",
  "IBM::Schema::BRAVO::SoftwareLparHdisk",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_ip_addresses",
  "IBM::Schema::BRAVO::SoftwareLparIpAddress",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_memories",
  "IBM::Schema::BRAVO::SoftwareLparMemory",
  { "foreign.software_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "software_lpar_os_infoes",
  "IBM::Schema::BRAVO::SoftwareLparOsInfo",
  { "foreign.software_lpar_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7akEL4Sm6gzrd5UyshOI2w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
