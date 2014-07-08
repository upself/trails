package IBM::Schema::BRAVO::BankAccount;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bank_account");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "version",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 8 },
  "connection_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "connection_status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
  "data_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "database_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "database_version",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "database_name",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "database_schema",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "database_ip",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "database_port",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "database_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "database_password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "socks",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "tunnel",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "tunnel_port",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 8 },
  "authenticated_data",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "sync_sig",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "comments",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
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
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "bank_account_inclusions",
  "IBM::Schema::BRAVO::BankAccountInclusion",
  { "foreign.bank_account_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_dorana_products",
  "IBM::Schema::BRAVO::InstalledDoranaProduct",
  { "foreign.bank_account_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_filters",
  "IBM::Schema::BRAVO::InstalledFilter",
  { "foreign.bank_account_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_sa_products",
  "IBM::Schema::BRAVO::InstalledSaProduct",
  { "foreign.bank_account_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_signatures",
  "IBM::Schema::BRAVO::InstalledSignature",
  { "foreign.bank_account_id" => "self.id" },
);
__PACKAGE__->has_many(
  "installed_vm_products",
  "IBM::Schema::BRAVO::InstalledVmProduct",
  { "foreign.bank_account_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3y7Cxa40pboeTtytGfvIKg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
