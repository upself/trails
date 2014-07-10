package IBM::Schema::SWCM::TAttachmentsMaint;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_attachments_maint");
__PACKAGE__->add_columns(
  "attach_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "maint_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("attach_id", "maint_id");
__PACKAGE__->belongs_to(
  "attach",
  "IBM::Schema::SWCM::TAttachments",
  { attach_id => "attach_id" },
);
__PACKAGE__->belongs_to(
  "maint",
  "IBM::Schema::SWCM::TMaintenance",
  { maint_id => "maint_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:D0QS9nmAkmDPx/hrx9w7Yg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
