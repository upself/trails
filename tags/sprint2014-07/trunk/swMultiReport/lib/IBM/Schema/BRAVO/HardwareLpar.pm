package IBM::Schema::BRAVO::HardwareLpar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hardware_lpar");
__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "hardware_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "name",
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
    size => 64,
  },
  "record_time",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 0,
    size => 26,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("customer_id", "hardware_id", "id");
__PACKAGE__->add_unique_constraint("UHARDWARELPAR", ["id"]);
__PACKAGE__->has_many(
  "alert_hw_lpars",
  "IBM::Schema::BRAVO::AlertHwLpar",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "contact_lpars",
  "IBM::Schema::BRAVO::ContactLpar",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "hardware",
  "IBM::Schema::BRAVO::Hardware",
  { id => "hardware_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::BRAVO::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "hardware_lpar_effs",
  "IBM::Schema::BRAVO::HardwareLparEff",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "hw_sw_composites",
  "IBM::Schema::BRAVO::HwSwComposite",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_hw_lpars",
  "IBM::Schema::BRAVO::ReconHwLpar",
  { "foreign.hardware_lpar_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:92kniIP25t4KAVS8R/S9aw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
