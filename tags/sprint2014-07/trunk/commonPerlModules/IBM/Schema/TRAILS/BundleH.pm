package IBM::Schema::TRAILS::BundleH;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bundle_h");
__PACKAGE__->add_columns(
  "bundle_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
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
);
__PACKAGE__->set_primary_key("bundle_id", "id");
__PACKAGE__->add_unique_constraint("IF1BUNDLEH", ["id"]);
__PACKAGE__->belongs_to("bundle", "IBM::Schema::TRAILS::Bundle", { id => "bundle_id" });


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ly9dnKzf6H6PWrb83Jz7cQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
