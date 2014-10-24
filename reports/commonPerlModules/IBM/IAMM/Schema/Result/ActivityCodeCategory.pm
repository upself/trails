package IBM::IAMM::Schema::Result::ActivityCodeCategory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("activity_code_category");
__PACKAGE__->add_columns(
  "activity_code_category_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "activity_code_category",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
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
);
__PACKAGE__->set_primary_key("activity_code_category_id");
__PACKAGE__->has_many(
  "activity_codes",
  "IBM::IAMM::Schema::Result::ActivityCode",
  {
    "foreign.activity_code_category_id" => "self.activity_code_category_id",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-10-22 14:08:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VsUC9txpDsjcGJi6+uNcYw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
