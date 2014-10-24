package IBM::Schema::TRAILS::HwSwComposite;

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
  "match_method",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("IF2HWSWCOMPOSITE", ["hardware_lpar_id", "software_lpar_id"]);
__PACKAGE__->add_unique_constraint("IF4HWSWCOMPOSITE", ["software_lpar_id"]);
__PACKAGE__->add_unique_constraint("IF1HWSWCOMPOSITE", ["software_lpar_id", "hardware_lpar_id"]);
__PACKAGE__->add_unique_constraint("IF3HWSWCOMPOSITE", ["hardware_lpar_id"]);
__PACKAGE__->belongs_to(
  "software_lpar",
  "IBM::Schema::TRAILS::SoftwareLpar",
  { id => "software_lpar_id" },
);
__PACKAGE__->belongs_to(
  "hardware_lpar",
  "IBM::Schema::TRAILS::HardwareLpar",
  { id => "hardware_lpar_id" },
);
__PACKAGE__->has_many(
  "recon_hs_composites",
  "IBM::Schema::TRAILS::ReconHsComposite",
  { "foreign.hw_sw_composite_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w+DeP7ALBaDJlMORLjRSYA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
