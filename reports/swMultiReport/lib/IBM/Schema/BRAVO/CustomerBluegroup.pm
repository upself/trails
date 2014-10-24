package IBM::Schema::BRAVO::CustomerBluegroup;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer_bluegroup");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "bluegroup_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("customer_id", "bluegroup_id");
__PACKAGE__->belongs_to(
  "bluegroup",
  "IBM::Schema::BRAVO::Bluegroup",
  { id => "bluegroup_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::BRAVO::Customer",
  { customer_id => "customer_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/YBAukWlVU9T9PWwlcIm5A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
