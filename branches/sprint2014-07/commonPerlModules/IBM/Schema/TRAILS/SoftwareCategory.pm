package IBM::Schema::TRAILS::SoftwareCategory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_category");
__PACKAGE__->add_columns(
  "software_category_id",
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
__PACKAGE__->set_primary_key("software_category_id");
__PACKAGE__->add_unique_constraint("IF1SWCATEGORY", ["software_category_name"]);
__PACKAGE__->add_unique_constraint(
  "IF2SWCATEGORY",
  ["software_category_id", "software_category_name"],
);
__PACKAGE__->has_many(
  "softwares",
  "IBM::Schema::TRAILS::Software",
  { "foreign.software_category_id" => "self.software_category_id" },
);
__PACKAGE__->has_many(
  "software_category_hs",
  "IBM::Schema::TRAILS::SoftwareCategoryH",
  { "foreign.software_category_id" => "self.software_category_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RQ5VewTGniApFsMH1D4fYw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
