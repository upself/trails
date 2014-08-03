package IBM::Schema::BRAVO::ContactLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("contact_lpar");
__PACKAGE__->add_columns(
  "hardware_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "contact_support_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("hardware_lpar_id", "contact_support_id", "id");
__PACKAGE__->add_unique_constraint("UCONTACTLPAR", ["id"]);
__PACKAGE__->belongs_to(
  "hardware_lpar",
  "IBM::Schema::BRAVO::HardwareLpar",
  { id => "hardware_lpar_id" },
);
__PACKAGE__->belongs_to(
  "contact_support",
  "IBM::Schema::BRAVO::ContactSupport",
  { id => "contact_support_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:51eLYG+HcVjpuh3ex1MtMA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
