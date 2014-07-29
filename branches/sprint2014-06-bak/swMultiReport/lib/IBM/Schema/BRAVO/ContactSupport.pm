package IBM::Schema::BRAVO::ContactSupport;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("contact_support");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "serial_mgr1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "serial_mgr2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "serial_mgr3",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "ismanager",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 3 },
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
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "contact_accounts",
  "IBM::Schema::BRAVO::ContactAccount",
  { "foreign.contact_support_id" => "self.id" },
);
__PACKAGE__->has_many(
  "contact_hardwares",
  "IBM::Schema::BRAVO::ContactHardware",
  { "foreign.contact_support_id" => "self.id" },
);
__PACKAGE__->has_many(
  "contact_lpars",
  "IBM::Schema::BRAVO::ContactLpar",
  { "foreign.contact_support_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8lEfqKAcVBaubLyVKM3Xow


# You can replace this text with custom content, and it will be preserved on regeneration
1;
