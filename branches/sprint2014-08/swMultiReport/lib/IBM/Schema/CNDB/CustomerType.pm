package IBM::Schema::CNDB::CustomerType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("CUSTOMER_TYPE");
__PACKAGE__->add_columns(
  "customer_type_id",
  { data_type => "BIGINT", is_nullable => 0, size => 19 },
  "customer_type_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("customer_type_id");
__PACKAGE__->has_many(
  "customers",
  "IBM::Schema::CNDB::Customer",
  { "foreign.customer_type_id" => "self.customer_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:k2VEZtJh/kyA8XfzZi1ryQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
