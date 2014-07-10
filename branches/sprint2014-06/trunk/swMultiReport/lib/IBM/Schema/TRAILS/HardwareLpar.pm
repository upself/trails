package IBM::Schema::TRAILS::HardwareLpar;

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
  "ext_id",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 8 },
  "tech_image_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("customer_id", "hardware_id", "id");
__PACKAGE__->add_unique_constraint("IF3HARDWARELPAR", ["name", "customer_id"]);
__PACKAGE__->add_unique_constraint("IF2HARDWARELPAR", ["id"]);
__PACKAGE__->add_unique_constraint(
  "IF4HARDWARELPAR",
  ["customer_id", "hardware_id", "id", "status"],
);
__PACKAGE__->has_many(
  "alert_hw_lpars",
  "IBM::Schema::TRAILS::AlertHwLpar",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "contact_lpars",
  "IBM::Schema::TRAILS::ContactLpar",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->belongs_to(
  "hardware",
  "IBM::Schema::TRAILS::Hardware",
  { id => "hardware_id" },
);
__PACKAGE__->belongs_to(
  "customer",
  "IBM::Schema::TRAILS::Customer",
  { customer_id => "customer_id" },
);
__PACKAGE__->has_many(
  "hardware_lpar_effs",
  "IBM::Schema::TRAILS::HardwareLparEff",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "hw_sw_composites",
  "IBM::Schema::TRAILS::HwSwComposite",
  { "foreign.hardware_lpar_id" => "self.id" },
);
__PACKAGE__->has_many(
  "recon_hw_lpars",
  "IBM::Schema::TRAILS::ReconHwLpar",
  { "foreign.hardware_lpar_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OoIPTZ6cEEuxr7uLReYVxw

# This as an extended relationship is a little bogus, since the intermediate
# table has unique indices on all columns (save "match_method")
__PACKAGE__->many_to_many(
    'software_lpars',
    hw_sw_composites => 'software_lpar',
);
    
# FIXME this will break if we ever start allowing multiple s/w lpars to h/w
sub software_lpar { shift->software_lpars->single }

1;
