package IBM::Schema::SWCM::TNotificationClass;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_notification_class");
__PACKAGE__->add_columns(
  "noti_class_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_class_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "noti_class_desc",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "noti_class_urgency",
  {
    data_type => "CHAR () FOR BIT DATA",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
  "noti_class_condition",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 2000,
  },
  "noti_class_email_single_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_class_email_group_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_class_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "noti_class_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("noti_class_id");
__PACKAGE__->belongs_to(
  "noti_class_email_group",
  "IBM::Schema::SWCM::TNotificationClassEmail",
  { noti_class_email_id => "noti_class_email_group_id" },
);
__PACKAGE__->belongs_to(
  "noti_class_email_single",
  "IBM::Schema::SWCM::TNotificationClassEmail",
  { noti_class_email_id => "noti_class_email_single_id" },
);
__PACKAGE__->has_many(
  "t_notification_settings",
  "IBM::Schema::SWCM::TNotificationSetting",
  { "foreign.noti_set_noti_class_id" => "self.noti_class_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Go2HhduWPUPZTpr54RKPrA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
