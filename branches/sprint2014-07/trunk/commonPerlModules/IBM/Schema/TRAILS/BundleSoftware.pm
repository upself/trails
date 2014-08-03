package IBM::Schema::TRAILS::BundleSoftware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bundle_software");
__PACKAGE__->add_columns(
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bundle_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("software_id", "bundle_id", "id");
__PACKAGE__->add_unique_constraint("IF1BUNDLESOFTWARE", ["bundle_id", "software_id"]);
__PACKAGE__->add_unique_constraint("IF2BUNDLESOFTWARE", ["id"]);
__PACKAGE__->belongs_to("bundle", "IBM::Schema::TRAILS::Bundle", { id => "bundle_id" });
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::TRAILS::Software",
  { software_id => "software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hN2XM2MHVWwQk6dDEUM+4Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
