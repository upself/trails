package IBM::Schema::CNDB::DelegationNotification;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("DELEGATION_NOTIFICATION");
__PACKAGE__->add_columns(
  "delegation_notification_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "delegation_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "sent_time",
  { data_type => "TIMESTAMP", is_nullable => 1, size => 26 },
  "notified_email",
  { data_type => "VARCHAR", is_nullable => 0, size => 256 },
  "category",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "value",
  { data_type => "INTEGER", is_nullable => 1, size => 10 },
  "cause",
  { data_type => "VARCHAR", is_nullable => 1, size => 32 },
  "record_time",
  { data_type => "TIMESTAMP", is_nullable => 0, size => 26 },
);
__PACKAGE__->set_primary_key("delegation_notification_id");
__PACKAGE__->belongs_to(
  "delegation",
  "IBM::Schema::CNDB::Delegation",
  { delegation_id => "delegation_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VXQBuSXZcvOcVGiDKIulqg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
