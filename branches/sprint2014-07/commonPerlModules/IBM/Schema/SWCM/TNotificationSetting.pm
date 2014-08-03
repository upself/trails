package IBM::Schema::SWCM::TNotificationSetting;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_notification_setting");
__PACKAGE__->add_columns(
  "noti_set_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_set_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_set_noti_class_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_set_noti_email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "noti_set_noti_period",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "noti_set_noti_offset",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "noti_set_noti_aggr",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "noti_set_repetitive_noti",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "noti_set_active",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "noti_set_deleted",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => "'0'",
    is_nullable => 1,
    size => 1,
  },
  "noti_set_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "noti_set_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("noti_set_id");
__PACKAGE__->add_unique_constraint(
  "UC_NOTI_SET_CUS_ID",
  ["noti_set_customer_id", "noti_set_noti_class_id"],
);
__PACKAGE__->belongs_to(
  "noti_set_customer",
  "IBM::Schema::SWCM::TCustomer",
  { customer_id => "noti_set_customer_id" },
);
__PACKAGE__->belongs_to(
  "noti_set_noti_class",
  "IBM::Schema::SWCM::TNotificationClass",
  { noti_class_id => "noti_set_noti_class_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L2r3uzseamZQvsVqsBVl1Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
