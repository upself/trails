package IBM::Schema::TRAILS::DiscrepancyType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("discrepancy_type");
__PACKAGE__->add_columns(
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
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
    size => 64,
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
__PACKAGE__->set_primary_key("id", "name");
__PACKAGE__->add_unique_constraint("IF2DISCREPANCYTYPE", ["name"]);
__PACKAGE__->add_unique_constraint("IF1DISCREPANCYTYPE", ["id"]);
__PACKAGE__->has_many(
  "installed_softwares",
  "IBM::Schema::TRAILS::InstalledSoftware",
  { "foreign.discrepancy_type_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9AbDHZsSzbkhuS7VYjt3Lg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
