package IBM::Schema::TRAILS::Contact;

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
  "creation_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
  "update_date_time",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT TIMESTAMP",
    is_nullable => 0,
    size => 26,
  },
);
__PACKAGE__->set_primary_key("contact_id");
__PACKAGE__->add_unique_constraint("IF2CONTACT", ["contact_id", "remote_user"]);
__PACKAGE__->add_unique_constraint("IF1CONTACT", ["role", "remote_user"]);
__PACKAGE__->add_unique_constraint("IF3CONTACT", ["contact_id", "full_name"]);
__PACKAGE__->has_many(
  "customer_contact_fas",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.contact_fa_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_dpes",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.contact_dpe_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_focal_assets",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.contact_focal_asset_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_hws",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.contact_hw_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_sws",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.contact_sw_id" => "self.contact_id" },
);
__PACKAGE__->has_many(
  "customer_contact_transitions",
  "IBM::Schema::TRAILS::Customer",
  { "foreign.contact_transition_id" => "self.contact_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qSSkAhhM5HcgyvFK5TDJeQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
