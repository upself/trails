package IBM::Schema::BRAVO::ReconCustomerLog;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("recon_customer_log");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "hw_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "hw_avg",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 6 },
  "hw_lpar_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "hw_lpar_avg",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 6 },
  "sw_lpar_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "sw_lpar_avg",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 6 },
  "lic_count",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "lic_avg",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 0, size => 6 },
  "duration",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
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
);
__PACKAGE__->set_primary_key("customer_id", "id");
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::BRAVO::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+0FvykGAki0zFUi+mq1Lww


# You can replace this text with custom content, and it will be preserved on regeneration
1;
