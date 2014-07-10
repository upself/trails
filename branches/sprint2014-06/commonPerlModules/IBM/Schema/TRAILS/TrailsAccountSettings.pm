package IBM::Schema::TRAILS::TrailsAccountSettings;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("trails_account_settings");
__PACKAGE__->add_columns(
  "trails_account_settings_id",
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
  "server_software",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "customer_server_software",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "workstation_software",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "customer_workstation_software",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "microsoft_software",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("trails_account_settings_id");
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q+VvRfqdmW7M/zyUP07fhw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
