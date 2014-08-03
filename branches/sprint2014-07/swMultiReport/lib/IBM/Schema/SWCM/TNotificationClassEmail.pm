package IBM::Schema::SWCM::TNotificationClassEmail;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_notification_class_email");
__PACKAGE__->add_columns(
  "noti_class_email_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "noti_class_email_subject",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 2000,
  },
  "noti_class_email_text",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 2000,
  },
  "noti_class_email_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "noti_class_email_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("noti_class_email_id");
__PACKAGE__->has_many(
  "t_notification_class_noti_class_email_groups",
  "IBM::Schema::SWCM::TNotificationClass",
  {
    "foreign.noti_class_email_group_id" => "self.noti_class_email_id",
  },
);
__PACKAGE__->has_many(
  "t_notification_class_noti_class_email_singles",
  "IBM::Schema::SWCM::TNotificationClass",
  {
    "foreign.noti_class_email_single_id" => "self.noti_class_email_id",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pRMuKX1eHyiEaiiZ+Tj3KQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
