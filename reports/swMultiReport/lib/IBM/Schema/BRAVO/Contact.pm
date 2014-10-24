package IBM::Schema::BRAVO::Contact;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("contact");
__PACKAGE__->add_columns(
  "contact_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "role",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "serial",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "full_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "remote_user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "notes_mail",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("contact_id");
__PACKAGE__->has_many(
  "customer_contact_fas",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.contact_fa_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_dpes",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.contact_dpe_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_focal_assets",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.contact_focal_asset_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_hws",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.contact_hw_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_sws",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.contact_sw_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_transitions",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.contact_transition_id" => "self.contact_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rA/HoNIEzLR0gvKWqxlVGg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
