package IBM::Schema::SWCM::TAttachments;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("t_attachments");
__PACKAGE__->add_columns(
  "attach_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "attach_org_file_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "attach_customer_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "attach_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
  "attach_description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "attach_created",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "attach_last_modified",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "attach_content_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
  "attach_length",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("attach_id");
__PACKAGE__->has_many(
  "t_attachments_cons",
  "IBM::Schema::SWCM::TAttachmentsCon",
  { "foreign.attach_id" => "self.attach_id" },
);
__PACKAGE__->has_many(
  "t_attachments_lics",
  "IBM::Schema::SWCM::TAttachmentsLic",
  { "foreign.attach_id" => "self.attach_id" },
);
__PACKAGE__->has_many(
  "t_attachments_locs",
  "IBM::Schema::SWCM::TAttachmentsLoc",
  { "foreign.attach_id" => "self.attach_id" },
);
__PACKAGE__->has_many(
  "t_attachments_maints",
  "IBM::Schema::SWCM::TAttachmentsMaint",
  { "foreign.attach_id" => "self.attach_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UAZLyTqA9oFpGa6UI/bPvg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
