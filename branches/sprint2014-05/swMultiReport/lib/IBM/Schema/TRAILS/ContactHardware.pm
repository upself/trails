package IBM::Schema::TRAILS::ContactHardware;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("contact_hardware");
__PACKAGE__->add_columns(
  "hardware_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "contact_support_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("hardware_id", "contact_support_id", "id");
__PACKAGE__->add_unique_constraint("IF1CONTACTHARDWARE", ["contact_support_id", "hardware_id"]);
__PACKAGE__->add_unique_constraint("IF2CONTACTHARDWARE", ["id"]);
__PACKAGE__->belongs_to(
  "contact_support",
  "IBM::Schema::TRAILS::ContactSupport",
  { id => "contact_support_id" },
);
__PACKAGE__->belongs_to(
  "hardware",
  "IBM::Schema::TRAILS::Hardware",
  { id => "hardware_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sYxuY8BBy3QF/ZNtYl6HwA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
