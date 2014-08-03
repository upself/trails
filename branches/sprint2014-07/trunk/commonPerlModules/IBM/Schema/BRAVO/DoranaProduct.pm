package IBM::Schema::BRAVO::DoranaProduct;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("dorana_product");
__PACKAGE__->add_columns(
  "software_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "product",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
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
__PACKAGE__->set_primary_key("software_id", "id");
__PACKAGE__->add_unique_constraint("UDORANAPRODUCT", ["id"]);
__PACKAGE__->belongs_to(
  "software",
  "IBM::Schema::BRAVO::Software",
  { software_id => "software_id" },
);
__PACKAGE__->has_many(
  "installed_dorana_products",
  "IBM::Schema::BRAVO::InstalledDoranaProduct",
  { "foreign.dorana_product_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0C+E7BcDdge7ayJ5phbwGA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
