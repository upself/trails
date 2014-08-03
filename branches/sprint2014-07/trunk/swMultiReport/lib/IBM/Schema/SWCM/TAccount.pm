package IBM::Schema::SWCM::TAccount;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_account");
__PACKAGE__->add_columns(
  "account_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "acc_dpe",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "acc_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 30,
  },
  "acc_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "acc_start_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "acc_end_date",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "acc_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "acc_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "acc_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("account_id");
__PACKAGE__->belongs_to(
  "acc_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "acc_customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4Nad9BuXD94+fiM0dL2K+A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
