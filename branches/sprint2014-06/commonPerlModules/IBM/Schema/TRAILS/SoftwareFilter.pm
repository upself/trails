package IBM::Schema::TRAILS::SoftwareFilter;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("software_filter");
__PACKAGE__->add_columns(
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_filter_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "software_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "software_version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "map_software_version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "end_of_support",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 26,
  },
  "os_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
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
__PACKAGE__->set_primary_key("software_id", "software_filter_id");
__PACKAGE__->add_unique_constraint("IF2SOFTWAREFILTER", ["software_name", "software_version"]);
__PACKAGE__->add_unique_constraint(
  "IF1SOFTWAREFILTER",
  [
    "software_id",
    "status",
    "software_filter_id",
    "software_name",
    "software_version",
  ],
);
__PACKAGE__->add_unique_constraint("IF3SOFTWAREFILTER", ["software_filter_id"]);
__PACKAGE__->has_many(
  "installed_filters",
  "IBM::Schema::TRAILS::InstalledFilter",
  { "foreign.software_filter_id" => "self.software_filter_id" },
);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);
__PACKAGE__->has_many(
  "software_filter_hs",
  "IBM::Schema::TRAILS::SoftwareFilterH",
  { "foreign.software_filter_id" => "self.software_filter_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gwH7c6jcN5MKKDjE+kxZ/w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
