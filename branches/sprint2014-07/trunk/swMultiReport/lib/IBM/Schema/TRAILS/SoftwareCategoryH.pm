package IBM::Schema::TRAILS::SoftwareCategoryH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_category_h");
__PACKAGE__->add_columns(
  "software_category_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_category_h_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_category_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "change_justification",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
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
__PACKAGE__->set_primary_key("software_category_id", "software_category_h_id");
__PACKAGE__->add_unique_constraint("IF1SWCATEGORYH", ["software_category_h_id"]);
__PACKAGE__->belongs_to(
  "software_category",
  "IBM::Schema::TRAILS::SoftwareCategory",
  { software_category_id => "software_category_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DZPWtr26mk8V9p05HLuBsw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
