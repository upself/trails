package IBM::Schema::BRAVO::BundleSoftware;

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
__PACKAGE__->add_unique_constraint("UBUNDLESOFTWARE", ["id"]);
__PACKAGE__->belongs_to("bundle", "IBM::Schema::BRAVO::Bundle", { id => "bundle_id" });
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::BRAVO::Software",
  { software_id => "software_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FtXYiLu/JLHNY7g7RIOgiQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
