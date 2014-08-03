package IBM::Schema::SWCM::TNamedCpus;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_named_cpus");
__PACKAGE__->add_columns(
  "cpu_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_manufacturer",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 35,
  },
  "cpu_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_model",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_serial_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 40,
  },
  "cpu_owning_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_sub_category",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "cpu_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "cpu_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 15,
  },
  "cpu_status_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "cpu_usage",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "cpu_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "cpu_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "cpu_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("cpu_id");
__PACKAGE__->has_many(
  "t_customer_cpus",
  "IBM::Schema::SWCM::TCustomerCpu",
  { "foreign.cpu_id" => "self.cpu_id" },
);
__PACKAGE__->has_many(
  "t_license_cpus",
  "IBM::Schema::SWCM::TLicenseCpu",
  { "foreign.cpu_id" => "self.cpu_id" },
);
__PACKAGE__->belongs_to(
  "cpu_owning_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "cpu_owning_customer_id" },
);
__PACKAGE__->has_many(
  "t_named_lpars",
  "IBM::Schema::SWCM::TNamedLpars",
  { "foreign.lpar_cpu_id" => "self.cpu_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BMP0kHq6FgeIkGEo/FxngQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
