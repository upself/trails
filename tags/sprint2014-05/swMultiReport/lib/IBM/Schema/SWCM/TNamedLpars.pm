package IBM::Schema::SWCM::TNamedLpars;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_named_lpars");
__PACKAGE__->add_columns(
  "lpar_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lpar_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "lpar_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "lpar_cpu_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lpar_ext_src_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lpar_ext_src_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lpar_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 15,
  },
  "lpar_status_date",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "lpar_usage",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "lpar_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "lpar_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "lpar_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("lpar_id");
__PACKAGE__->has_many(
  "t_customer_lpars",
  "IBM::Schema::SWCM::TCustomerLpar",
  { "foreign.lpar_id" => "self.lpar_id" },
);
__PACKAGE__->has_many(
  "t_license_lpars",
  "IBM::Schema::SWCM::TLicenseLpar",
  { "foreign.lpar_id" => "self.lpar_id" },
);
__PACKAGE__->belongs_to(
  "lpar_cpu",
  "IBM::Schema::SWCM::TNamedCpus",
  { cpu_id => "lpar_cpu_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:k66IQCCVHX0DlopSrBoEog


# You can replace this text with custom content, and it will be preserved on regeneration
1;
