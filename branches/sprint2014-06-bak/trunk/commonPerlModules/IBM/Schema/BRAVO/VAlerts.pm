package IBM::Schema::BRAVO::VAlerts;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("v_alerts");
__PACKAGE__->add_columns(
  "pk",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 33,
  },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "fk_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
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
  "alert_age",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "creation_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "open",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 5,
  },
  "type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 17,
  },
  "display_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1y7IkE4YuvOA7wliXX8PXA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
