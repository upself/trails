package IBM::Schema::BRAVO::CustomerType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("customer_type");
__PACKAGE__->add_columns(
  "customer_type_id",
  { data_type => "BIGINT", default_value => undef, is_nullable => 0, size => 19 },
  "customer_type_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("customer_type_id", "customer_type_name");
__PACKAGE__->add_unique_constraint("UCUSTOMERTYPE", ["customer_type_id"]);
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::BRAVO::Customer",
  { "foreign.customer_type_id" => "self.customer_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-10-06 12:30:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KOj7HS+/xlPxhIBFhgELAg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
