package IBM::Schema::BRAVO::HwSwComposite;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hw_sw_composite");
__PACKAGE__->add_columns(
  "software_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "hardware_lpar_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("software_lpar_id", "hardware_lpar_id", "id");
__PACKAGE__->add_unique_constraint("UHWSWCOMPOSITE", ["id"]);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::BRAVO::SoftwareLpar",
  { id => "software_lpar_id" },
);
__PACKAGE__->belongs_to(
  "hardware_lpar",
  "IBM::Schema::BRAVO::HardwareLpar",
  { id => "hardware_lpar_id" },
);
__PACKAGE__->has_many(
  "recon_hs_composites",
  "IBM::Schema::BRAVO::ReconHsComposite",
  { "foreign.hw_sw_composite_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CqbOj/Cp2XJKf5gefM7vNA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
