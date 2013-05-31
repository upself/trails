package IBM::Schema::TRAILS::TrailsRegistration;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("trails_registration");
__PACKAGE__->add_columns(
  "trails_registration_id",
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
  "license_tools",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "software_tools",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "ibm_obligation",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "ibm_own_software",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "ibm_software_on_customer",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "customer_software_on_ibm",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "asset_types",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "scope",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "scope_justification",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 254,
  },
  "scope_status",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "approval",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 3 },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "cirats_number",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("trails_registration_id");
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:32:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:indX/JJRq/9GWYiZC4gapA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
